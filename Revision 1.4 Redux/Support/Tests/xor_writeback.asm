; Assemble with Support/Assembler/asm.cpp and load/run at 8000.
; Prints PASS with corrected ROMs, FAIL with the original Redux ROMs.
; Uses only the existing MinOS jump table. No Forth/custom emulator required.
#org 0x8000
        MIB 0xfe,0xffff
        MIB 0,0x1200
        LDI 1
        XR.B 0x1200
        LDB 0x1200
        CPI 1
        BNE failed
        MIB 0,0x1200
        MIB 0,0x4500
        MIB 0x12,0x4501
        LDI 1
        XR.R 0x4500
        LDB 0x1200
        CPI 1
        BNE failed
        JPS 0xf045 "PASS: XR.B / XR.R writeback",10,0
        JPA 0xf003
failed:
        JPS 0xf045 "FAIL: XR.B / XR.R writeback",10,0
        JPA 0xf003
