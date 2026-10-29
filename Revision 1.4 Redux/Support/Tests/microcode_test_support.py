"""Small RAM-only control-word test fixture, NOT a complete board emulator.

Only used for targeted instruction regressions. There is no RESET, FLASH,
video, UART/PS2 framing or hardware timing model. Tests may change the external
active-low K/T readiness levels between clocks; FI samples these into FR.
I/O and bank-control words are explicitly rejected. Python stdlib only.
"""
from pathlib import Path

NAMES = "BO EC ES EO IC II FI IO MC CIH CE BI AI AO COH COL MIL MIH ME CIL MZ RO NI RI".split()
SIGNALS = {name: 1 << bit for bit, name in enumerate(NAMES)}
globals().update(SIGNALS)
INVERT = 0xEBFAF9
FILES = ("ctrl_lsb.bin", "ctrl_msb.bin", "ctrl_hsb.bin")
RUN, KEY, UART = 0x40, 0x20, 0x10
DEFAULT_REDUX = Path(__file__).resolve().parents[2]


def compile_images(root):
    """Reassemble the CSV truth table without third-party tools or packages."""
    definitions = {}
    for line in (root / "microcode_def.csv").read_text().splitlines():
        if not line.startswith("#define "):
            continue
        _, name, body = line.split(None, 2)
        words = []
        for word in body.split(","):
            logical = 0
            for signal in word.strip().split("|"):
                if signal not in ("0", "FF"):
                    logical |= SIGNALS[signal]
            words.append(logical ^ INVERT)
        if len(words) != 16 or name in definitions:
            raise ValueError(f"invalid definition: {name}")
        definitions[name] = words
    rows = []
    for line in (root / "microcode_rom.csv").read_text().splitlines():
        row = [name.strip() for name in line.split("*/", 1)[1].split(",") if name.strip()]
        if len(row) != 256:
            raise ValueError("expected 256 opcode entries per flag row")
        rows.append(row)
    if len(rows) != 128:
        raise ValueError("expected 128 flag rows")
    images = [bytearray() for _ in FILES]
    for row in rows:
        for name in row:
            for word in definitions[name]:
                for lane, image in enumerate(images):
                    image.append((word >> (lane * 8)) & 255)
    return dict(zip(FILES, map(bytes, images)))


def load_words(root):
    images = [(root / "FLASH Images" / name).read_bytes() for name in FILES]
    if any(len(image) != 0x80000 for image in images):
        raise ValueError("expected three 512 KiB control images")
    return tuple((lo | mid << 8 | hi << 16) ^ INVERT for lo, mid, hi in zip(*images))


def check_images(root):
    for name, expected in compile_images(root).items():
        actual = (root / "FLASH Images" / name).read_bytes()
        if actual != expected:
            raise AssertionError(f"CSV/image mismatch: {name}")


class RamCPU:
    def __init__(self, words):
        self.words = words
        self.ram = bytearray(0x10000)
        self.reset_case(0x8000)

    def reset_case(self, pc, a=0, b=0, flags=RUN | KEY | UART):
        self.pc = self.mar = pc
        self.a, self.b = a, b
        self.fr = flags
        self.ready = flags & (KEY | UART)
        self.ir = self.sc = self.clocks = 0
        self.writes = []

    def word(self):
        return self.words[self.fr << 12 | self.ir << 4 | self.sc]

    def step(self):
        word, old_pc = self.word(), self.pc
        if word & (IO | NI):
            raise ValueError("I/O/bank control is outside this RAM-only test fixture")
        addend = (self.b ^ 255) if word & ES else self.b
        total = self.a + addend + bool(word & EC)
        result = total & 255
        alu = ((4 if total > 255 else 0) | (8 if result & 128 else 0)
               | (1 if result & 15 == 0 else 0) | (2 if result & 240 == 0 else 0))
        bus = 255
        if word & AO:
            bus = self.a
        if word & BO:
            bus = self.b
        if word & EO:
            bus = result
        elif word & ES:
            bus = self.a & self.b
        elif word & EC:
            bus = self.a | self.b
        if word & RO:
            bus = self.ram[self.mar]
        if word & COL:
            bus = self.pc & 255
        if word & COH:
            bus = self.pc >> 8
        if word & RI:
            self.ram[self.mar] = bus
            self.writes.append(self.mar)
        if word & AI:
            self.a = bus
        if word & BI:
            self.b = bus
        if word & FI:
            self.fr = RUN | self.ready | alu
        if word & II:
            self.ir = bus
        if word & CE:
            self.pc = (self.pc + 1) & 65535
        if word & CIL:
            self.pc = (self.pc & 0xff00) | bus
        if word & CIH:
            self.pc = (self.pc & 255) | bus << 8
        if word & ME:
            self.mar = (self.mar + 1) & 65535
        if word & MIL:
            self.mar = (self.mar & 0xff00) | ((old_pc & 255) if word & MC else bus)
        if word & MIH:
            high = 0 if word & MZ else (old_pc & 0xff00) if word & MC else bus << 8
            self.mar = (self.mar & 255) | high
        self.sc = 0 if word & IC else (self.sc + 1) & 15
        self.clocks += 1

    def instruction(self, limit=16):
        for _ in range(limit):
            self.step()
            if self.sc == 0:
                return self.clocks
        raise AssertionError("instruction did not finish")


if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser(description="Check or regenerate the three control images from CSV")
    parser.add_argument("--write-images", action="store_true", help="explicitly regenerate this tree's control images")
    args = parser.parse_args()
    if args.write_images:
        images = compile_images(DEFAULT_REDUX)
        for name in FILES:
            path = DEFAULT_REDUX / "FLASH Images" / name
            if path.is_symlink() or not path.is_file():
                parser.error(f"not a regular existing control image: {path}")
        for name, data in images.items():
            path = DEFAULT_REDUX / "FLASH Images" / name
            if path.read_bytes() != data:
                path.write_bytes(data)
    check_images(DEFAULT_REDUX)
    print("All three control images match the CSV truth table.")
