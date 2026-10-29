#!/usr/bin/env python3
"""XR.B/XR.R regression; use --redux-dir to test another Redux source tree."""
import argparse
from pathlib import Path
import unittest

from microcode_test_support import DEFAULT_REDUX, KEY, RUN, UART, RamCPU, check_images, load_words

ROOT = DEFAULT_REDUX


class XorWritebackTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.cpu = RamCPU(load_words(ROOT))

    def test_csv_reproduces_all_three_images(self):
        check_images(ROOT)

    def check_case(self, indirect, a, b, destination):
        cpu = self.cpu
        start, pointer = 0x80ff, 0xffff if a & 1 else 0x45ff
        operand = pointer if indirect else destination
        opcode, clocks = (0x54, 13) if indirect else (0x52, 10)
        cpu.ram[start:start+3] = bytes([opcode, operand & 255, operand >> 8])
        if indirect:
            cpu.ram[pointer] = destination & 255
            cpu.ram[(pointer + 1) & 65535] = destination >> 8
        cpu.ram[0xff] = 0x5a
        cpu.ram[destination-1:destination+2] = bytes([0xc3, b, 0x3c])
        flags = RUN | KEY | UART | (a & 15)
        cpu.reset_case(start, a=a, b=0x39, flags=flags)
        self.assertEqual(cpu.instruction(), clocks)
        label = f"opcode={opcode:02x}, A={a:02x}, memory={b:02x}, destination={destination:04x}"
        self.assertEqual(cpu.ram[destination], a ^ b, label)
        self.assertEqual(cpu.a, a ^ b, label)
        self.assertEqual(cpu.fr, flags, label)
        self.assertEqual((cpu.pc, cpu.mar), (start+3, start+3), label)
        self.assertTrue(all(addr == destination for addr in cpu.writes), label)
        self.assertEqual((cpu.ram[destination-1], cpu.ram[destination+1]), (0xc3, 0x3c), label)
        if destination != 0xff:
            self.assertEqual(cpu.ram[0xff], 0x5a, label)

    def test_all_131072_byte_pairs_and_pointer_boundaries(self):
        for indirect in (False, True):
            for a in range(256):
                for b in range(256):
                    self.check_case(indirect, a, b, 0x12ff if b & 1 else 0x1234)

    def test_minimal_reproductions(self):
        for indirect in (False, True):
            with self.subTest(indirect=indirect):
                self.check_case(indirect, 1, 0, 0x1200)

    def test_scratch_byte_is_a_valid_destination(self):
        for indirect in (False, True):
            for a, b in [(0, 0), (0x55, 0xaa), (255, 255)]:
                self.check_case(indirect, a, b, 0xff)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--redux-dir", type=Path, default=DEFAULT_REDUX)
    args, remaining = parser.parse_known_args()
    ROOT = args.redux_dir.resolve()
    unittest.main(argv=[__file__, *remaining])
