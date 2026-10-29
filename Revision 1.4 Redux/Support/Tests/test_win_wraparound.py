#!/usr/bin/env python3
"""WIN readiness-phase regression; --redux-dir selects another Redux tree."""
import argparse
from pathlib import Path
import unittest

from microcode_test_support import DEFAULT_REDUX, KEY, RUN, UART, RamCPU, check_images, load_words

ROOT = DEFAULT_REDUX


class WinWraparoundTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.cpu = RamCPU(load_words(ROOT))

    def test_csv_reproduces_all_three_images(self):
        check_images(ROOT)

    def test_all_4608_address_register_readiness_phase_combinations(self):
        cases = 0
        cpu = self.cpu
        for high in (0, 1, 0x80, 0xff):
            for low in (0, 0xfe, 0xff):
                start = high << 8 | low
                for a in (0, 1, 255):
                    for b in (0, 255):
                        for ready_bit in (UART, KEY):
                            for arrival in range(32):
                                cpu.ram[start] = 4
                                cpu.reset_case(start, a=a, b=b, flags=RUN | KEY | UART | 15)
                                next_pc = (start + 1) & 65535
                                exited = False
                                label = f"PC={start:04x}, A={a:02x}, B={b:02x}, ready={ready_bit:02x}, arrival={arrival}"
                                for clock in range(arrival + 20):
                                    if clock == arrival:
                                        cpu.ready &= ~ready_bit
                                    cpu.step()
                                    if cpu.sc == 0:
                                        if cpu.pc == next_pc:
                                            self.assertGreaterEqual(clock, arrival, label)
                                            self.assertEqual(cpu.mar, next_pc, label)
                                            exited = True
                                            break
                                        self.assertEqual(cpu.pc, start, label)
                                        self.assertEqual(cpu.mar, start, label)
                                self.assertTrue(exited, label)
                                self.assertEqual(cpu.ready & ready_bit, 0, label)
                                self.assertEqual(cpu.writes, [], label)
                                cases += 1
        self.assertEqual(cases, 4608)

    def test_no_input_wait_period_and_already_ready_fast_path(self):
        cpu = self.cpu
        for start in (0x8000, 0x80ff, 0xffff):
            cpu.ram[start] = 4
            cpu.reset_case(start)
            period = 6 if (start + 1) & 255 == 0 else 5
            for _ in range(3):
                before = cpu.clocks
                for _ in range(period):
                    cpu.step()
                self.assertEqual(cpu.clocks - before, period)
                self.assertEqual((cpu.pc, cpu.mar, cpu.sc), (start, start, 0))
            for ready_bit in (UART, KEY):
                cpu.reset_case(start, flags=(RUN | KEY | UART) & ~ready_bit)
                self.assertEqual(cpu.instruction(), 2)
                self.assertEqual((cpu.pc, cpu.mar), ((start+1) & 65535,) * 2)


def trace(root):
    """Input becomes ready after three complete ffff wait iterations."""
    cpu = RamCPU(load_words(root))
    cpu.ram[0xffff] = 4
    cpu.reset_case(0xffff)
    print("clock PC   MAR  SC FR word   (UART becomes ready at clock 18)")
    for clock in range(32):
        if clock == 18:
            cpu.ready &= ~UART
        print(f"{clock:5} {cpu.pc:04x} {cpu.mar:04x} {cpu.sc:2} {cpu.fr:02x} {cpu.word():06x}")
        cpu.step()
        if clock >= 18 and cpu.sc == 0 and cpu.pc != 0xffff:
            print(f"wake PC={cpu.pc:04x}, MAR={cpu.mar:04x}; expected 0000")
            return
    raise AssertionError("trace did not wake")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--redux-dir", type=Path, default=DEFAULT_REDUX)
    parser.add_argument("--trace", action="store_true", help="print the ffff/clock-18 UART trace instead of unit tests")
    args, remaining = parser.parse_known_args()
    ROOT = args.redux_dir.resolve()
    if args.trace:
        trace(ROOT)
    else:
        unittest.main(argv=[__file__, *remaining])
