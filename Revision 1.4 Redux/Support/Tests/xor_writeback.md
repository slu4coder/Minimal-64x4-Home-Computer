# XR.B / XR.R destination writeback

## Reproduction

With A=1 and RAM[1200]=0, `XR.B 0x1200` should leave A=1 and
RAM[1200]=1. The original microcode leaves RAM[1200]=0 and writes the AND
intermediate (0) to scratch RAM[00ff].

With RAM[4500]=00 and RAM[4501]=12 (little-endian pointer 1200), A=1 and
RAM[1200]=0, `XR.R 0x4500` should similarly store 1 at 1200. The original
microcode writes the final XOR result to 00ff instead.

`xor_writeback.asm` is a small MinOS-compatible smoke test for both cases.
Assemble it with the existing assembler and load/run it at 8000 using the
normal loader/emulator workflow. It prints FAIL with the original images and
PASS with the corrected images. No changes to the assembler or MinOS are needed.

## Microcode change

Keep MAR at the destination rather than redirecting it to scratch:

- XR_B step 5: remove `MIL|MZ|MIH` (keep the slot).
- XR_B step 9: add `RI` to the final XOR result.
- XR_R step 8: remove `MIL|MZ|MIH` (keep the slot).

The AND intermediate is temporarily stored at the destination. The following
OR is computed while A/B still contain the original operands; the intermediate
is then read back and subtracted from the OR to obtain XOR. The destination
is still in MAR for the final write. RAM[00ff] is no longer changed unless it
is the explicit destination. FR is unchanged; instruction durations remain
10 clocks (XR.B) and 13 clocks (XR.R), including fetch.

Only 192 running-state control words change: 64 flag rows times three slots.
The regenerated binary difference is LSB=0, MSB=0, HSB=192 bytes. Reset rows,
other opcodes, the mapping CSV and program `flash.bin` are unchanged.

## Reproducible checks

From the repository root, Python 3 standard library only:

```sh
python3 "Revision 1.4 Redux/Support/Tests/test_xor_writeback.py"
```

The test reassembles all 524,288 control words from both CSVs and compares all
three checked-in images. A deliberately small RAM-only clock fixture executes
the actual images for all 131,072 A/memory byte pairs, checking A, destination,
FR, PC/MAR, write addresses, scratch preservation and 10/13-clock timing.
It also covers pointer fetch at ffff/0000 and destination 00ff. Expectations
use Python's `a ^ b`, not the microcode's arithmetic recipe.

To explicitly regenerate the three control images after a CSV edit:

```sh
python3 "Revision 1.4 Redux/Support/Tests/microcode_test_support.py" --write-images
```

To reproduce the failure against an unmodified Redux tree:

```sh
python3 "Revision 1.4 Redux/Support/Tests/test_xor_writeback.py" \
  --redux-dir /path/to/original/"Revision 1.4 Redux"
```

The fixture is not a complete board emulator and does not model FLASH, video,
external devices or physical timing. Physical-board operation/timing has not
been validated. This change is independent of the separate WIN wraparound fix.
