; Manual smoke test: load/run at 8000, then send one input byte while waiting.
; Correct ROM: PASS. Original ROM: some input phases reach FAIL (repeat to test).
; Clock-exact reproduction is provided by test_win_wraparound.py --trace.
#org 0x8000
        MIB 0xfe,0xffff
        JPS 0xf045 "Waiting at ffff. Send an input byte.",10,0
        ; Install JPA handlers at intended 0000 and erroneous ff00 wake targets.
        MIB 0x66,0x0000
        MIB <passed,0x0001
        MIB >passed,0x0002
        MIB 0x66,0xff00
        MIB <failed,0xff01
        MIB >failed,0xff02
        INT
        INK
        ; ffff is also the stack-pointer byte: no calls until a handler resets it.
        MIB 0x04,0xffff
        JPA 0xffff
passed:
        MIB 0xfe,0xffff
        JPS 0xf045 "PASS: WIN woke at 0000",10,0
        JPA 0xf003
failed:
        MIB 0xfe,0xffff
        JPS 0xf045 "FAIL: WIN woke at ff00",10,0
        JPA 0xf003
