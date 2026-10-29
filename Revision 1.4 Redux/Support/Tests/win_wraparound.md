# WIN wraparound when input arrives during a wait

## Reproduction and cause

Place WIN (04) at ffff with UART and PS/2 not ready. Execute three complete
six-clock wait iterations, then make UART or PS/2 ready before the next clock.
The original ROM wakes at **ff00**, not the intended next PC **0000**.
Other PCs/arrival phases can also be affected; ffff is a particularly clear
wraparound reproduction, not the only possible failing address.

The wait row latches flags at step 1 (`FF|BI|FI`). If input becomes ready then,
FI selects a ready-input row in the middle of the instruction. That row skips
the low-byte decrement at step 3 but, with carry=0, still decrements the high
byte at step 5. At ffff, fetch has already wrapped PC to 0000, so the high-byte
decrement incorrectly changes it to ff00. This is a control-word selection
issue, not an assembler or MinOS issue.

## Fix and compatibility

Remove FI from step 1 of the two **waiting** definitions `WINx11x0xx` and
`WINx11x1xx`. Their existing step-3 FI now samples readiness at the same edge
as the low-byte decrement, so any subsequent row switch uses its matching
carry and performs the required high-byte correction.

- The instruction encoding, ready-input rows, reset rows and other opcodes
  are unchanged.
- Already-ready input still returns in 2 clocks; a no-input wait iteration
  remains 5 clocks normally or 6 at the low-byte wrap boundary.
- Input arriving during a wait can finish the rewind and return on the next
  poll. Wakeup latency/intermediate flags are therefore **not guaranteed
  identical to the defective ROM**. WIN still does not consume input.
- Only 16 control words change (R=1, K=T=1, either carry value at step 1).
  The regenerated binary difference is LSB=16, MSB=0, HSB=0 bytes.
- `microcode_rom.csv`, program `flash.bin`, MinOS and Revision 1.1 are unchanged.

## Reproducible checks

From the repository root, Python 3 standard library only:

```sh
python3 "Revision 1.4 Redux/Support/Tests/test_win_wraparound.py"
python3 "Revision 1.4 Redux/Support/Tests/test_win_wraparound.py" --trace
```

The test checks the actual ROM words for 4,608 combinations of PC high/low
bytes, initial A/B, UART/PS2 readiness and 32 input arrival phases. It checks
the PC/MAR at every instruction boundary, wakeup only after readiness, no
RAM writes and no input consumption. It also checks no-input wait periods
and the already-ready path. All three images are compared against a full
CSV reassembly (524,288 control words).

To reproduce the old failure and its clock-by-clock trace:

```sh
python3 "Revision 1.4 Redux/Support/Tests/test_win_wraparound.py" \
  --redux-dir /path/to/original/"Revision 1.4 Redux"
python3 "Revision 1.4 Redux/Support/Tests/test_win_wraparound.py" \
  --redux-dir /path/to/original/"Revision 1.4 Redux" --trace
```

To explicitly regenerate control images after a CSV edit:

```sh
python3 "Revision 1.4 Redux/Support/Tests/microcode_test_support.py" --write-images
```

`win_wraparound.asm` is a manual MinOS smoke test which installs a WIN at ffff
and jump handlers at 0000/ff00. Load/run it at 8000 and send an input byte
after the waiting message. It reports the reached target. The original bug
is input-phase-dependent, so a PASS on the original ROM does not disprove it;
the Python trace supplies the deterministic arrival phase.

The RAM-only test fixture is deliberately narrow: it drives readiness levels,
not UART/PS2 bit timing, and does not model RESET, FLASH, VGA or physical
propagation delays. Physical-board timing has not been validated. This change
does not include or depend on the separate XOR writeback fix.
