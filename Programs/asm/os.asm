; ******************************************************************
; *****                                                        *****
; *****       MinOS 2 for the Minimal 64x4 Home Computer       *****
; *****                                                        *****
; ***** written by Carsten Herting - last update May 17th 2024 *****
; *****                                                        *****
; ******************************************************************

; CHANGE LOG
; 08.02.2024: Updating the keyboard handler timing to Minimal 64x4 speed.
; 09.02.2024: Cosmetic updates, changing quotation from ' to ".
; 10.02.2024: Rewriting 'mon' with cleaner code, now makes use of _ReadHex.
; 15.02.2024: Adding _ClearPixel function, renaming _Pixel to _SetPixel.
; 17.05.2024: Added support for 'autostart' batch file.

; HOW TO USE THIS CODE
; This is the sourcecode of the operating system MinOS 2 of the MINIMAL 64x4. A HEX file of the OS
; code can be produced by typing 'asm os.asm'. This HEX file can be burned into the first 3 banks of the
; 512KB FLASH SSD ROM of the MINIMAL 64x4. In case you already have a version of MinOS installed, the OS
; can also be updated 'in situ': Upload the HEX file into RAM by typing 'receive ENTER' and pasting the
; HEX file into a terminal to the MINIMAL 64x4 via the UART interface. The image will be written to the
; FLASH banks 0-2. Upon pressing RESET, the new OS boots. Your file data remains unchanged on the SSD.

; o After boot-up, the Minimal 64x4 deactivates FLASH (BANK = 0xff), exposing 64KB of contiguous RAM.
; o After boot-up, FLASH access is provided by the instructions R.. and W.. (see manual for details).
; o _<labels> provide access to kernel functions & data via a jump table.
; o 0xcc denotes code subject to change during runtime, i.e. self-modifying code.

; LICENSING INFORMATION
; This file is free software: you can redistribute it and/or modify it under the terms of the
; GNU General Public License as published by the Free Software Foundation, either
; version 3 of the License, or (at your option) any later version.
; This file is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the
; implied warranty of MERCHANMBBILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public
; License for more details. You should have received a copy of the GNU General Public License along
; with this program. If not, see https://www.gnu.org/licenses/.

; -------------------------------------------------------------------------------------
; Entry point after RESET with BANK = PC = MAR = 0
; -------------------------------------------------------------------------------------
#org 0x0000     MIW OS_Image_Start,0xfffc                     ; OS image address to 0xfffc/d
                MIW _Start,0xfffe                             ; OS target address to 0xfffe/f
  imcopyloop:   LDR 0xfffc STR 0xfffe                         ; copy the OS image to RAM
                INW 0xfffc INW 0xfffe                         ; show progress of bootloader in VRAM
                CIB <OS_Image_End,0xfffe FNE imcopyloop       ; target address beyond OS kernel?
                  CIB >OS_Image_End,0xffff FCC imcopyloop

OS_Image_Start: #mute #org 0xf000 #emit                       ; change OS target address but emit OS image here

  _Start:       JPA OS_Start                                  ; OS JUMP TABLE
  _Prompt:      JPA OS_Prompt
  _MemMove:     JPA OS_MemMove
  _Random:      JPA OS_Random
  _ScanPS2:     JPA OS_ScanPS2
  _ResetPS2:    JPA OS_ResetPS2
  _ReadInput:   JPA OS_ReadInput
  _WaitInput:   JPA OS_WaitInput
  _ReadLine:    JPA OS_ReadLine
  _SkipSpace:   JPA OS_SkipSpace
  _ReadHex:     JPA OS_ReadHex
  _SerialWait:  JPA OS_SerialWait
  _SerialPrint: JPA OS_SerialPrint
  _FindFile:    JPA OS_FindFile
  _LoadFile:    JPA OS_LoadFile
  _SaveFile:    JPA OS_SaveFile
  _ClearVRAM:   JPA OS_ClearVRAM
  _Clear:       JPA OS_Clear
  _ClearRow:    JPA OS_ClearRow
  _ScrollUp:    JPA OS_ScrollUp
  _ScrollDn:    JPA OS_ScrollDn
  _Char:        JPA OS_Char
  _PrintChar:   JPA OS_PrintChar
  _Print:       JPA OS_Print
  _PrintPtr:    JPA OS_PrintPtr
  _PrintHex:    JPA OS_PrintHex
  _SetPixel:    JPA OS_SetPixel
  _Line:        JPA OS_Line
  _Rect:        JPA OS_Rect
  _ClearPixel:  JPA OS_ClearPixel

OS_Start:       0xff                                          ; switch OFF FLASH after boot-up
                MIB 0xfe,0xffff                               ; init stack pointer
                JPS OS_ClearVRAM                              ; clear VRAM including blanking intervals

                INK CPI 0x76 FEQ OS_Splash                    ; ESC on PS/2 bails out of startup sequence
                  MIV OS_StartFile,_ReadPtr                   ; set _ReadPtr to startup batch filename
                  JPS OS_LoadFile CPI 0 FEQ OS_Splash         ; load startup batch file
                    MVV PtrD,PtrF                             ; save batch file pointer
  startupnext:      MVV PtrF,_ReadPtr                         ; go to next startup batch file entry
  startuplook:      LDT _ReadPtr CPI 32 FGT startupload       ; filename found?
                      CPI 0 BEQ OS_Splash                     ; end of batch file?
                        INV _ReadPtr FPA startuplook          ; skip over chars 1..32
  startupload:      JPS OS_LoadFile CPI 0 FEQ OS_Splash       ; try loading this filename
                      MVV _ReadPtr,PtrF                       ; save batch file pointer
                      LDI <startupnext-2 PHS                  ; fake return address
                      LDI >startupnext-2 PHS
                      JPR PtrD                                ; next "RTS" will jump back to 'startupnext'

  OS_Splash:    JPS OS_SerialPrint                            ; send "READY." via UART
                27, "[H", 27, "[J", 27, "[?25hREADY.", 10, 0  ; ANSI CSI: home, clear, show cursor
                JPS OS_Logo                                   ; draw "Minimal" logo
                MIZ 1,_YPos                                   ; display splash screen text
                MIZ 14,_XPos JPS OS_Print "**** MINIMAL 64x4 - MinOS 2 ****", 10, 10, 0
                MIZ 14,_XPos JPS OS_Print "64KB SRAM - 512KB FLASH - 8.0MHz", 10, 10, 0
                MIZ 14,_XPos JPS OS_Print "Type 'show manual' for more info", 10, 10, 0
  OS_Prompt:    MIB 0xfe,0xffff                               ; init stack after re-entry
                JPS OS_Print "READY.", 10, 0                  ; show prompt
    parseline:  MIV _ReadBuffer,_ReadPtr                      ; parse a line of user input
                JPS OS_ReadLine                               ; MAIN LOOP: read in a line of user input
                JPS OS_SkipSpace                              ; consume leading whitespace ("' )
                CIT 10,_ReadPtr FEQ parseline                 ; empty line?
                  JPS OS_LoadFile CPI 0 FEQ notfound          ; load the program (or OS command)
                    JPR PtrD                                  ; run program (_ReadPtr may be used for further parsing)
    notfound:     JPS OS_Print "NOT FOUND.", 10, 0
                  JPA OS_Prompt

; --------------------------------------------------------------------------------------------
; Resets the state of keys ALT, SHIFT, CTRL to avoid lock-up after a longer operation (CTRL+V)
; that did not allow for polling the PS/2 register properly.
; --------------------------------------------------------------------------------------------
OS_ResetPS2:      MIB 0xff,ps2_shift STB ps2_ctrl STB ps2_alt
                  RTS

; --------------------------------------------------
; Moves N bytes from S.. to D.. taking overlap into account.
; push: D_lsb, D_msb, S_lsb, S_msb, N_lsb, N_msb
; Pull: #, #, #, #, #, #
; --------------------------------------------------
OS_MemMove:   LDS 3 STZ PtrB+1 LDS 4 STZ PtrB+0               ; B = number of bytes
              DEV PtrB FCC mc_done
              LDS 5 STZ PtrA+1 LDS 6 STZ PtrA+0               ; A = source
              LDS 7 STZ PtrC+1 LDS 8 STZ PtrC+0               ; C = destination
              CZZ PtrC+1,PtrA+1 FCC a_less_c FNE c_less_a
                CZZ PtrC+0,PtrA+0 FCC a_less_c FEQ mc_done
  c_less_a:   LDT PtrA STT PtrC
              INV PtrA INV PtrC
              DEV PtrB FCS c_less_a
                RTS
  a_less_c:   AVV PtrB,PtrA AVV PtrB,PtrC
    alc_loop: LDT PtrA STT PtrC
              DEV PtrA DEV PtrC
              DEV PtrB FCS alc_loop
  mc_done:      RTS

; -------------------------------------------------------------------------------------
; Reads a line of input into _ReadBuffer starting from _ReadPtr
; set _ReadPtr to the desired position within _ReadBuffer buffer
; modifies: _ReadPtr
; -------------------------------------------------------------------------------------
OS_ReadLine:  LDZ _ReadPtr+0 PHS LDZ _ReadPtr+1 PHS           ; save desired start of parsing
  waitchar:   LDI 160 JAS OS_Char                             ; put the cursor
              JPS OS_WaitInput                                ; wait on any input
              CPI 0x80 FCS waitchar                           ; ignore unprintable chars (UP, DN, PgUp, etc.)
              CPI 9 FEQ waitchar                              ; no MBB
              CPI 27 BNE checkback                            ; ESC invalidates input data
                JPS clrcursor
                PLS STZ _ReadPtr+1 PLS STZ _ReadPtr+0         ; move to start of input and put ENTER
                MIT 10,_ReadPtr JAS OS_PrintChar              ; perform ENTER
                RTS
  checkback:  CPI 8 BNE havenoback                            ; check for BACKSPACE
                LDZ _XPos CPI 0 FEQ waitchar                  ; check for BACKSPACE at linestart
                  JPS clrcursor
                  DEZ _XPos DEZ _ReadPtr+0 JPA waitchar
  havenoback: STT _ReadPtr CPI 10 BEQ haveenter               ; check for ENTER
                LDZ _ReadPtr+0 CPI <ReadLast BEQ waitchar     ; end of line reached?
                  LDT _ReadPtr JAS OS_Char
                  INZ _XPos INZ _ReadPtr+0
                  JPA waitchar
  haveenter:  JPS clrcursor
              PLS STZ _ReadPtr+1 PLS STZ _ReadPtr+0           ; move to start of input
              LDI 10 JAS OS_PrintChar RTS                     ; perform ENTER and return
  clrcursor:  LDI " " JAS OS_Char RTS                         ; print SPACE and return

; --------------------------------------------------------------------
; Sends a null-terminated string trailing the function call via UART
; modifies Z0..1
; --------------------------------------------------------------------
OS_SerialPrint: PLS STZ Z1 PLS STZ Z0 AIV 2,Z0 FPA s_entry    ; string address = return address + 2
  s_loop:         OUT JPS _SerialWait INV Z0                  ; send the char and advance
  s_entry:        CIT 0,Z0 FNE s_loop                         ; load next char, check for zero-terminator
                    DEV Z0 LDZ Z0 PHS LDZ Z1 PHS              ; push back LSB, MSB return address
                    RTS

; --------------------------------------------------------
; Parses HEX number 0000..ffff from _ReadPtr into _ReadNum
; breaks at any char != [0..9, a..f, A..F]
; modifies: _ReadPtr, _ReadNum
; --------------------------------------------------------
OS_ReadHex:    CLV _ReadNum MIZ 0xf0,_ReadNum+2
  hxgetchar:    LDT _ReadPtr                                  ; input string lesen
                CPI "g" FCS hxreturn                          ; above f? -> melde Fehler!
                CPI "a" FCS hxletter                          ; a..f?
                CPI "G" FCS hxreturn
                CPI "A" FCS hxLETTER                          ; A..F?
                CPI ":" FCS hxreturn                          ; above 9? -> Separator: Zurück, wenn was da ist, sonst übergehen.
                CPI "0" FCS hxzahl                            ; 0...9?
                  JPA hxreturn                                ; unter 0? -> Separator: Zurück, wenn was da ist, sonst übergehen.
  hxletter:     SUI 32
  hxLETTER:     SUI 7
  hxzahl:       SUI 48 PHS
                LLV _ReadNum RLZ _ReadNum+2                   ; shift existing hex data 4 steps to the left
                LLV _ReadNum RLZ _ReadNum+2
                LLV _ReadNum RLZ _ReadNum+2
                LLV _ReadNum RLZ _ReadNum+2
                PLS AD.Z _ReadNum+0                           ; add new hex nibble (carry cannot happen)
                INV _ReadPtr FPA hxgetchar
  hxreturn:     RTS

; -------------------------------------------------------
; Loads <filename> pointed to by _ReadPtr from SSD
; <filename> must be terminated by <= 39 '
; success: returns A=1, _ReadPtr points beyond <filename>
; failure: returns A=0, _ReadPtr points to <filename>
; modifies: _ReadPtr, PtrA, PtrB, PtrC, PtrD
; -------------------------------------------------------
OS_LoadFile:    JPS OS_FindFile CPI 1 BNE lf_failure          ; check result in A
                  ; ----- PtrA0..2 now points to file in FLASH
                  AIV 20,PtrA JPS OS_FlashA                   ; search for target addr
                  RDR PtrA STZ PtrC+0 STZ PtrD+0 INV PtrA JPS OS_FlashA ; destination addr -> PtrC, PtrD
                  RDR PtrA STZ PtrC+1 STZ PtrD+1 INV PtrA JPS OS_FlashA
                  RDR PtrA STZ PtrB+0 INV PtrA JPS OS_FlashA  ; bytesize -> PtrB (PtrA now points to data)
                  RDR PtrA STZ PtrB+1 INV PtrA JPS OS_FlashA
  lf_loadloop:    DEV PtrB BCC lf_success                     ; alles kopiert?
                    RDR PtrA STT PtrC                         ; copy block from A -> to C
                    INV PtrA INV PtrC JPS OS_FlashA JPA lf_loadloop
  lf_success:     LDI 1 RTS                                   ; switch off FLASH
  lf_failure:     LDI 0 RTS

; -------------------------------------------------------------------------------------------------------
; Produces a FLASH/BANK address in the correct form: PtrA+2: bank number, PtrA0..1: 12bit section address
; Adds the value of bits 12-15 of PtrA to PtrA+2, updates bank register and clears upper nibble of PtrA
; Call this routine *everytime* the FLASH data pointer PtrA is modified.
; modifies: PtrA+0..2
; -------------------------------------------------------------------------------------------------------
OS_FlashA:      LDZ PtrA+1 RL5 ANI 0x0f                       ; is something in the upper nibble?
                CPI 0 BEQ fa_farts
                  AD.Z PtrA+2                                 ; there was something -> update bank register PtrA+2
                  LDI 0x0f AN.Z PtrA+1                        ; correct PtrA+1
  fa_farts:     RTS

; --------------------------------------------------
; Searches SSD for <filename> at _ReadPtr (any char <= 39 terminates <filename>)
; returns A=1: _ReadPtr points beyond <filename>, PtrA0..2/BANK point at start of file in FLASH
; returns A=0: _ReadPtr points to start of <filename>, PtrA0..2/BANK point beyond last file in FLASH
; modifies: _ReadPtr, PtrA, PtrB, PtrC, BANK
; --------------------------------------------------
OS_FindFile:      ; ----- browse through all stored files and see if <filename> matches name, any char <=39 stops
                  CLV PtrA MIZ 2,PtrA+2                       ; SSD address -> PtrA
  ff_search:        RDR PtrA CPI 0xff BEQ ff_returnfalse      ; end of data reached -> no match
                    ; ----- check if name matches (across banks)
                    MVV PtrA,PtrC MZZ PtrA+2,PtrC+2           ; PtrA -> PtrC
                    MVV _ReadPtr,PtrB                         ; _ReadPtr -> PtrB
  match_loop:       RDR PtrC STB ff_isnoend+1                 ; read letter from FLASH
                    LDT PtrB CPI 39 BGT ff_isnoend            ; tausche TRAILING whitespaces gegen 0 aus!
                      LDI 0
  ff_isnoend:       CPI 0xcc BNE files_dontmatch              ; stimmen Buchstaben überein?
                      CPI 0 BEQ ff_returntrue                 ; wurde gemeinsame 0 erreicht => match!
                        INV PtrB INV PtrC SUI 0x10 BCC match_loop ; teste nä. Buchstaben, handle 12-bit overflow in C
                          STZ PtrC+1 INZ PtrC+2 JPA match_loop
                    ; ----- this filename does not match => jump over (across banks)
  files_dontmatch:  AIV 22,PtrA JPS OS_FlashA                 ; advance over header to bytesize LSB
                    RDR PtrA STZ PtrB+0 INV PtrA JPS OS_FlashA ; extract bytesize -> PtrB
                    RDR PtrA STZ PtrB+1 INV PtrA
                    AVV PtrB,PtrA                             ; PtrA points beyond this file
                      RL5 ANI 15 AD.Z PtrA+2                  ; update BANK
                      LDZ PtrA+1 LL5 RL4
                      STZ PtrA+1 JPA ff_search                ; use only lower 12 bits
  ff_returntrue:    MVV PtrB,_ReadPtr                         ; parse over good filename
                    LDI 1 RTS
  ff_returnfalse:   LDI 0 RTS                                 ; not found, don't change _ReadPtr

; --------------------------------------------------
; Saves a RAM area as file <name> to SSD drive, checks if there is enough space, asks before overwriting
; expects: _ReadPtr points to filename starting with char >= 40, terminated by char <= 39
; push: first_lsb, first_msb, last_lsb, last_msb
; pull: #, #, #, result (1: success, 0: failure, 2: user abortion) same as in A
; modifies: Z0, PtrA, PtrB, PtrC, PtrD, PtrE, PtrF, _ReadPtr
; --------------------------------------------------
OS_SaveFile:      LDS 3 STZ PtrF+1 LDS 4 STZ PtrF+0
                  LDS 5 STZ PtrE+1 LDS 6 STZ PtrE+0
                  ; ----- assemble a zero-filled 20-byte filename starting at _ReadBuffer for the header
                  MIZ 19,Z0                                   ; copy up to 19 chars of filename
                  MIV _ReadBuffer,PtrD                        ; _ReadBuffer -> temp PtrD
  sf_namecopy:    LDT _ReadPtr CPI 39 BLE sf_nameend          ; read a name char, anything <= 39 ends name
                    STT PtrD INV _ReadPtr INV PtrD            ; copy name char
                    DEZ Z0 BNE sf_namecopy
  sf_nameend:     MIT 0,PtrD                                  ; overwrite rest including 20th byte with zero
                  INV PtrD DEZ Z0 BCS sf_nameend              ; PtrD points beyond 20-byte area
                  ; ----- invalidate exisiting files with that name, look for enough free space on the SSD
  sf_existfile:   MIV _ReadBuffer,_ReadPtr                    ; _ReadPtr points back to filename
                  JPS OS_FindFile CPI 1 BNE sf_foundfree
                    CIZ 3,PtrA+2 BCC sf_returnfalse           ; file is write protected
                    JPS OS_Print "OVERWRITE (y/n)?", 10, 0
                    JPS OS_WaitInput CPI "y" BNE sf_returnbrk ; used break => no error
                    ; ----- invalidate existing filename to 0
                    LDI 0xaa WDB 0x0555,0x05                  ; INIT FLASH WRITE PROGRAM
                    LDI 0x55 WDB 0x0aaa,0x02
                    LDI 0xa0 WDB 0x0555,0x05
                    LDI 0 WDR PtrA                            ; START INVALIDATE WRITE PROCESS
                    MIZ 20,Z0                                 ; re-read a maximum times
    sf_delcheck:    DEZ Z0 BCC sf_returnfalse                 ; write took too long => ERROR!!!
                      RDR PtrA CPI 0 BNE sf_delcheck          ; re-read FLASH location -> data okay?
                        JPA sf_existfile
  sf_foundfree:   ; ----- PtrA/PtrA+2 now point to free SSD space
                  SVV PtrE,PtrF INV PtrF                      ; calculate data bytesize: PtrF = last - first + 1
                  MVV PtrA,PtrB MVV PtrF,PtrC                 ; FLASH start -> temp PtrB, data bytesize -> temp PtrC
                  MIZ 4,Z0
  sf_shiftloop:   DEZ Z0 BCC sf_shifted
                    LRZ PtrB+1 RRZ PtrB+0                     ; divide FLASH start by 2
                    LRZ PtrC+1 RRZ PtrC+0                     ; divide bytesize by 2
                    JPA sf_shiftloop
  sf_shifted:     MZZ PtrA+2,PtrB+1                           ; PtrB now holds FLASH start in nibbles (rounded down)
                  INV PtrB                                    ; add 1 nibble for rounding up
                  AIV 3,PtrC                                  ; PtrC now holds bytesize in nibbles + 3 (headersize + rouning safety)
                  AVV PtrC,PtrB                               ; formerly sf_shifted (bug-fix)
                  CPI 0x80 BCS sf_returnfalse                 ; 512KB overflow!
                  ; ----- write header start address and bytesize
                  MVV PtrE,_ReadBuffer+20                     ; write start addr to header
                  MVV PtrF,_ReadBuffer+22                     ; write data bytesize to header
                  ; ----- write header to FLASH memory
                  MIV _ReadBuffer,PtrC                        ; start addr of header -> PtrC, free addr is already in PtrA+0..2
                  MIV 0x0018,PtrB                             ; bytesize 24 of header -> PtrB
                  JPS OS_FLASHWrite                           ; write the header (incrementing PtrA, PtrA+2)
                  CIZ 0xff,PtrB+1 BNE sf_returnfalse          ; check if all bytes have been written successfully
                  ; ----- write body to FLASH memory
                  MVV _ReadBuffer+20,PtrC                     ; start -> PtrC
                  MVV _ReadBuffer+22,PtrB                     ; bytesize -> PtrB, PtrA, PtrA+2 already positioned behind header
                  JPS OS_FLASHWrite                           ; write the data body
                  CIZ 0xff,PtrB+1 BNE sf_returnfalse          ; check if all bytes have been written successfully
                    LDI 1 STS 6 RTS                           ; return success, FLASH off
  sf_returnfalse: LDI 0 STS 6 RTS                             ; return failure, FLASH off
  sf_returnbrk:   LDI 2 STS 6 RTS                             ; signal user abortion

; --------------------------------------------------
; Writes data to FLASH at PtrA+0..2, PtrC: RAM source, PtrB: bytesize
; modifies: PtrA (points to byte after target data if successful)
;           PtrB (0xffff: success by underflow, else failure)
;           PtrC (points to byte after source data if successful)
; modifies: Z0
; --------------------------------------------------
OS_FLASHWrite:    DEV PtrB BCC fw_return                      ; Anzahl runterzählen
                  RDR PtrA CPI 0xff BNE fw_return             ; teste FLASH, ob dest byte == 0xff ist
                    LDI 0xaa WDB 0x0555,0x05                  ; INIT FLASH WRITE PROGRAM
                    LDI 0x55 WDB 0x0aaa,0x02
                    LDI 0xa0 WDB 0x0555,0x05
                    LDT PtrC WDR PtrA                         ; INITIATE BYTE WRITE PROCESS
                    MIZ 20,Z0                                 ; re-read a maximum times
  fw_writecheck:    DEZ Z0 BCC fw_return                      ; write took too long => PtrB != 0xffff => ERROR!
                      RDR PtrA CPT PtrC BNE fw_writecheck     ; re-read FLASH location until is data okay
                        INV PtrC INV PtrA                     ; DATA OKAY! Increase both pointers to next byte
                        LDZ PtrA+1 SUI 0x10 BCC OS_FLASHWrite ; no need to correct bank and address?
                          STZ PtrA+1 INZ PtrA+2               ; correct it!
                          JPA OS_FLASHWrite                   ; write next data byte to FLASH
  fw_return:      RTS

; --------------------------------------------------------------------------------------
; Draws a rect with left upper corner at (xa, ya), xb+1 pixels wide and yb+1 pixels high
; Requirement: w must be >= 7
; --------------------------------------------------------------------------------------
OS_Rect:          RZP ya,>LineMSBTable,1                      ; extract msb line start address
                  STB re_tlindex+2 STB re_trindex+2           ; set top msb line start address
                  STB re_mlindex+2 STB re_mrindex+2           ; also set msb for middle part
                  RZP ya,>LineLSBTable,1                      ; extract lsb line start address
                  STB re_tlindex+1 STB re_trindex+1
                  LDZ xa+1 DEC LDZ xa RL6 ANI 63              ; get x pos, trick: move 1th bit of x_msb to C
                  AD.B re_tlindex+1 STB re_mlindex+1          ; add lsb lpos, overflow into msb cannot happen
                  LDZ xa ANI 7                                ; compute left bit patterns
                  RAP >RectLeftTable,1                        ; set left end
                  STB re_tlbptr+1 STB re_blbpat+1             ; set left middle bitmask
                  LDZ xa ANI 7
                  RAP >SetTable,1 STB re_mlbptr+1
                  AVV xb,xa                                   ; x = x + w
                  DEC LDZ xa RL6 ANI 63
                  AD.B re_trindex+1 STB re_mrindex+1          ; add lsb rpos, overflow into msb cannot happen
                  LDZ xa ANI 7                                ; compute right bit patterns
                  RAP >RectRightTable,1                       ; set right top/bottom end
                  STB re_trbptr+1 STB re_brbpat+1
                  LDZ xa ANI 7                                ; set right middle bitmask
                  RAP >SetTable,1 STB re_mrbptr+1
                  ; ----- the top border -----
  re_tlbptr:      LDI 0xcc                                    ; top left bit pattern
  re_tlindex:     OR.B 0xcccc
                  INB re_tlindex+1 CPB re_trindex+1 FCS re_trbptr
                    LDI 0xff FPA re_tlindex
  re_trbptr:      LDI 0xcc                                    ; top right bit pattern
  re_trindex:     OR.B 0xcccc
                  ; ----- plot left and right border -----
                  DEZ yb FCC re_exit                          ; quit after top border at h=0
  re_midloop:       DEZ yb FCC re_bottom                      ; h=1 ? no middle section
                      AIW 64,re_mlindex+1                     ; one line down
                      AIW 64,re_mrindex+1
  re_mlbptr:          LDI 0xcc
  re_mlindex:         OR.B 0xcccc                             ; index of left border
  re_mrbptr:          LDI 0xcc
  re_mrindex:         OR.B 0xcccc                             ; index of right border
                      FPA re_midloop
                  ; ----- plot the bottom border -----
  re_bottom:      AIW 64,re_mlindex+1                         ; one line down
                  MBB re_mlindex+1,re_blindex+1
                  MBB re_mlindex+2,re_blindex+2
                  AIW 64,re_mrindex+1
                  MBB re_mrindex+1,re_brindex+1
                  MBB re_mrindex+2,re_brindex+2
  re_blbpat:      LDI 0xcc                                    ; bottom left bit pattern
  re_blindex:     OR.B 0xcccc
                  INB re_blindex+1 CPB re_brindex+1 FCS re_brbpat
                    LDI 0xff FPA re_blindex
  re_brbpat:      LDI 0xcc                                    ; bottom left bit pattern
  re_brindex:     OR.B 0xcccc
  re_exit:        RTS

; *******************************************************************************
; Clears text area
; highly optimized with self-modifying code
; modifies: Z0
; *******************************************************************************
OS_Clear:         LDI <VIEWPORT-1 STB vc_loopx+1              ; set start index
                  LDI >VIEWPORT STB vc_loopx+2
  vc_loopy:       MIZ 13,Z0                                   ; screen width in words
  vc_loopx:       CLL 0xcccc
                  AIB 4,vc_loopx+1
                  DEZ Z0 FGT vc_loopx                         ; self-modifying code
                    AIW 12,vc_loopx+1 FPL vc_loopy            ; add blank number of cols
                      RTS

; *******************************************************************************
; Clears the entire video RAM including the blanking areas (0.070s)
; Note: This can't be done from FLASH memory, since self-modifying code is used.
; *******************************************************************************
OS_ClearVRAM:     LDI <VIDEORAM STB ca_loop+1                 ; init video RAM pointer
                  LDI >VIDEORAM STB ca_loop+2
  ca_loop:        CLL 0xcccc                                  ; erase VRAM area
                  AIW 4,ca_loop+1 FPL ca_loop
                    RTS

; *******************************************************************************
; Plots the Minimal 72x28 pixel bitmap logo
; modifies: Z0..4
; *******************************************************************************
OS_Logo:          MIV VIEWPORT+896+3,Z3                       ; Z3..4 point to VRAM position
                  CLZ Z0                                      ; Z0 is logo data page index (LSB)
                  MIZ 28,Z2                                   ; logo pixel height
  vl_loopy:       MIZ 9,Z1                                    ; logo byte width
  vl_loopx:       RZP Z0,>MinimalLogo,0 STT Z3                ; move byte from FLASH bank 0 to VRAM ptr
                  INZ Z3 INZ Z0 DEZ Z1 FGT vl_loopx
                    AIV 64-9,Z3 DEZ Z2 FGT vl_loopy           ; stride to next line
                      RTS

; *******************************************************************************
; Reads input from any input source (either serial or PS/2)
; Returns in A either 0 for no input or the ASCII code of the last pressed key
; modifies: Z0
; *******************************************************************************
OS_ReadInput:     INT CPI 0xff FNE ri_exit                    ; check for direct terminal input
                    JPS OS_ScanPS2                            ; read & clear the PS2 register and convert to ASCII
                    LDB ps2_ascii                             ; transfer ASCII key code into A
                    CLB ps2_ascii                             ; clear storage without changing A
  ri_exit:        RTS                                         ; returns result in A

; *******************************************************************************
; Wait on input from any input source
; Returns either 0 for no input or the ASCII code of the pressed key
; modifies: Z0
; *******************************************************************************
OS_WaitInput:     WIN INT CPI 0xff FNE wi_exit                ; FAST testing (read/clear must happen within 32/4*3=24 cycles of receiving with UART)
                    JPS OS_ScanPS2                            ; read & clear PS/2 register, UART already cleared
                    CIB 0,ps2_ascii FEQ OS_WaitInput          ; Is there a new ASCII key code? No => repeat
                      CLB ps2_ascii                           ; clear keyboard
  wi_exit:        RTS                                         ; return result in A

; ---------------------------------------------------------------------
; This routine asserts a 176 cycle time between OUT when called via API
; ---------------------------------------------------------------------
OS_SerialWait:    LDI 19                                      ; LDI: 2
  wuart_loop:     DEC BNE wuart_loop                          ; duration = n * (3+5) cycles
                  RTS                                         ; JPS: 11, RTS: 10, API-JPA: 5, OUT: 2

; *******************************************************************************
; Sets a pixel at position (xa, ya) without safety check (highly optimized)
; *******************************************************************************
OS_SetPixel:      RZP ya,>LineMSBTable,1 STB vs_index+1       ; calculate start index using (xa,ya)
                  RZP ya,>LineLSBTable,1 STB vs_index+0       ; get start index of line
                  LDZ xa+1 DEC LDZ xa                         ; adjust VRAM x position
                  RL6 ANI 63 AD.B vs_index+0                  ; overflow is not possible
                  LDZ xa+0 ANI 7 RAP >SetTable,1 OR.B         ; init bit pixel pattern
  vs_index:       0xcccc RTS                                  ; self-modifying code

; **************************************************************
; Draws a line from point (xa, ya) to point (xb, yb) using
; Bresenham's line drawing algorithm
; highly optimized with self-modifying code
; draws ~1000 random lines per second
; **************************************************************
OS_Line:        MIB AIW+0,dyvert STB dxvert                   ; init direction up/dn to dn => use AIW
                CZZ xa+0,xb+0 STZ dx+0                        ; make dx positive, always drawing from left to right
                LDZ xb+1 SCZ xa+1 STZ dx+1 FPL dxpos
                  NEW dx
                  RZP yb,>LineMSBTable,1                      ; calculate start index using (xb,yb)
                  STB dxindex+1 STB dyindex+1
                  RZP yb,>LineLSBTable,1                      ; get start index of line
                  STB dxindex+0 STB dyindex+0
                  LDZ xb+1 DEC LDZ xb                         ; adjust VRAM position lsb
                  RL6 ANI 63 AD.B dxindex+0 STB dyindex+0     ; overflow is not possible
                  LDZ xb ANI 7 RAP >SetTable,1 STZ bit        ; init bit pixel pattern
                  CZZ yb,ya FPA common
  dxpos:        RZP ya,>LineMSBTable,1                        ; calculate start index using (xa,ya)
                STB dxindex+1 STB dyindex+1
                RZP ya,>LineLSBTable,1                        ; get start index of line
                STB dxindex+0 STB dyindex+0
                LDZ xa+1 DEC LDZ xa                           ; adjust VRAM position lsb
                RL6 ANI 63 AD.B dxindex+0 STB dyindex+0       ; overflow is not possible
                LDZ xa ANI 7 RAP >SetTable,1 STZ bit          ; init bit pixel pattern
                CZZ ya,yb
  common:       STZ dy FCS fastdir                            ; swap for positive dy
                  NEZ dy MIB SIW+0,dxvert STB dyvert          ; line goes up => use SIW
  fastdir:      CIZ 0,dx+1 FGT dxfastdir
                  CZZ dx+0,dy FCC dxfastdir
; -----------------------------------------------------------
  dyfastdir:    MZZ dy,steps                                  ; y = FAST DIR (SLOPE >=1) with dx<dy
                LDZ dy LR1 STZ err+0 CLZ err+1                ; init err = dy/2
  dyfloop:      LDZ bit OR.B
    dyindex:    0xcccc                                        ; plot pixel
    dyvert:     AIW 64,dyindex                                ; advance index in y, either AIW or SIW
                SZZ dx,err+0 FCS dyfnover                     ; adjust error for x step
                  DEZ err+1
    dyfnover:   CIZ 0,err+1 FPL dyfnodiag                     ; test for err<0
                  LLZ bit FCC dybitin                         ; advance pos in x
                    MIZ 1,bit INW dyindex
    dybitin:      AZV dy,err                                  ; adjust error for x diag step
    dyfnodiag:  DEZ steps FCS dyfloop
                  RTS
; -----------------------------------------------------------
dxfastdir:      MVV dx,steps                                  ; x = FAST DIR (SLOPE <1) with dy<=dx
                LDZ dx+1 DEC LDZ dx+0 RR1                     ; init err = dx/2
                STZ err+0 CLZ err+1
  dxfloop:      LDZ bit OR.B
    dxindex:    0xcccc                                        ; plot pixel
                LLZ bit FCC dxbitin                           ; advance pos in x
                  RLZ bit INW dxindex
    dxbitin:    SZZ dy,err+0 FCS dxfnover                     ; adjust error for x step
                  DEZ err+1
    dxfnover:   CIZ 0,err+1 FPL dxfnodiag                     ; test for err<0
    dxvert:     AIW 64,dxindex                                ; advance pos in y, either AIW or SIW
                  AVV dx,err                                  ; adjust error for y diag step
    dxfnodiag:  DEZ steps+0 FCS dxfloop
                  DEZ steps+1 FCS dxfloop
                    RTS

; ***************************************************************************
; Eraseses a 4KB FLASH sector in A without any protection (handle with care!)
; ***************************************************************************
OS_FLASHErase:  STB os_bank+5 STB fe_wait+3                   ; set the bank to be erased
                LDI 0xaa WDB 0x0555,0x05                      ; issue FLASH ERASE COMMAND
                LDI 0x55 WDB 0x0aaa,0x02
                LDI 0x80 WDB 0x0555,0x05
                LDI 0xaa WDB 0x0555,0x05
                LDI 0x55 WDB 0x0aaa,0x02
  os_bank:      LDI 0x30 WDB 0x0fff,0xcc                      ; initiate the BLOCK ERASE command
  fe_wait:      RDB 0x0fff,0xcc LL1 BCC fe_wait               ; wait for 8th bit go HIGH, this code HAS to run in RAM!
                  RTS

; ------------------------------------------------------------
; Clears the current row from cursor position onwards
; modifies: Z0
; ------------------------------------------------------------
OS_ClearRow:    LDI <WIDTH+1 SUZ _XPos LR1 FEQ cr_exit        ; calculate number of words to clear
                  STB cr_line+1
                LL1 NEG ADI 64 STB cr_adder+1                 ; calculate stride
                LDZ _XPos ADI <VIEWPORT                       ; index to video position of char
                STB cr_upper+1 STB cr_lower+1                 ; init start of row
                LDZ _YPos LL1 ADI >VIEWPORT                   ; multiply y with 8*64 = 512
                STB cr_upper+2 INC STB cr_lower+2             ; init half row pointers
  cr_line:      MIZ 0xcc,Z0                                   ; screen width in quads
  cr_upper:     CLW 0xcccc
  cr_lower:     CLW 0xcccc
                AIB 2,cr_upper+1 STB cr_lower+1
                DEZ Z0 FGT cr_upper
  cr_adder:       AIB 0xcc,cr_upper+1 STB cr_lower+1          ; add stride
                  FCC cr_line                       
                  
  cr_exit:      RTS

; --------------------------------------------------------------------
; Prints a null-terminated string trailing the function call into VRAM
; starting at (_XPos, _YPos) - based upen an idea by Hans-Jürgen Jacob
; updates cursor position, handles LF and scrolling
; example: JPS _Print "Hello, World!", 0
; modifies _XPos, _YPos, (Z0..2), Z3..4
; --------------------------------------------------------------------
OS_Print:       PLS STZ Z4 PLS STZ Z3 AIV 2,Z3 FPA p_entry    ; pull MSB, LSB, string = return addr + 2
  p_loop:         JAS _PrintChar INV Z3                       ; print the char
  p_entry:        CIT 0,Z3 FNE p_loop                         ; load next char
                    DEV Z3 LDZ Z3 PHS LDZ Z4 PHS              ; push LSB, MSB of return address (beyond string - 2)
                    RTS

; *******************************************************************************
; Scrolls the video area one character downwards
; modifies: Z0..1
; *******************************************************************************
OS_ScrollDn:    MIB 0x7b,sd_loopx+2                           ; set source and target page
                MIB 0x7d,sd_loopx+5
                MIB 0x7c,sd_loopx+8                           ; set source and target page
                MIB 0x7e,sd_loopx+11 
                MIZ <VIEWPORT,Z0                              ; skip empty bytes of page
  sd_loopq:     MIZ <WIDTH,Z1                                 ; chars per row
  sd_loopx:     LZP Z0,0xcc SZP Z0,0xcc                       ; move a char (upper and lower part)
                LZP Z0,0xcc SZP Z0,0xcc
                INZ Z0 DEZ Z1 FGT sd_loopx                    ; horizontal step
                  AIZ <64-WIDTH,Z0 FCC sd_loopq               ; next line, repeat 4 times
                    SIB 2,sd_loopx+11 DEC STB sd_loopx+5      ; goto next char row
                    DEC STB sd_loopx+8 DEC STB sd_loopx+2
                    CPI 0x43 FCS sd_loopq
                      CLZ _XPos JPS OS_ClearRow RTS           ; clears from _XPos onwards

; *******************************************************************************
; Puts a character at position (_XPos, _YPos) without changing _XPos or _YPos
; expects char in A
; Z1..2: VRAM address
; modifies: Z0..2
; *******************************************************************************
OS_Char:        STZ Z0 LDI <VIEWPORT ADZ _XPos STZ Z1         ; index to video position of char
                LDZ _YPos LL1 ADI >VIEWPORT STZ Z2            ; multiply y with 8*64 = 512
                RZP Z0,>Charset+0,1 STT Z1 AIZ 64,Z1       ; load from FLASH addr Z0,page on bank 1
                RZP Z0,>Charset+256,1 STT Z1 AIZ 64,Z1
                RZP Z0,>Charset+512,1 STT Z1 AIZ 64,Z1
                RZP Z0,>Charset+768,1 STT Z1 INZ Z2
                RZP Z0,>Charset+1792,1 STT Z1 SIZ 64,Z1
                RZP Z0,>Charset+1536,1 STT Z1 SIZ 64,Z1
                RZP Z0,>Charset+1280,1 STT Z1 SIZ 64,Z1
                RZP Z0,>Charset+1024,1 STT Z1
                RTS

; ---------------------------------------------------------------------------------------
; Reads out the PS2 keyboard register. Stores ASCII code of pressed key in ps2_ascii.
; Call this routine in intervals < 835µs (5010 clocks) to not miss any PS2 datagrams.
; In case a 0xf0 release code is detected, the routine waits some time for next datagram.
; modifies: ps2_ascii
; ---------------------------------------------------------------------------------------
OS_ScanPS2:       INK CPI 0xff FNE key_reentry                ; fast readout of keyboard register, nothing in?
                    RTS
key_reentry:      CPI 0xf0 FEQ key_release                    ; key release detected?
                    CPI 0x11 FEQ key_alt                      ; special keys pressed?
                      CPI 0x12 FEQ key_shift
                        CPI 0x59 FEQ key_shift
                          CPI 0x14 FEQ key_ctrl
                            CPI 0xe0 FEQ key_rts              ; ignore special marker for cursor keys
                  ANI 0x7f STB ps2_ptr+0                      ; set scan table index according to SHIFT / ALT / CTRL
                    CIB 1,ps2_release FEQ key_clrrel          ; marked as a release? -> don't store
                      MIB >PS2Table,ps2_ptr+1                 ; keyPRESS, LSB was already set
                      LDI 1
                      CPB ps2_shift FNE key_check2            ; chose the right PS2 scan code table
                        AIB 0x80,ps2_ptr+0 FPA key_ptrok
  key_check2:         CPB ps2_alt FNE key_check3
                        INB ps2_ptr+1 FPA key_ptrok
  key_check3:         CPB ps2_ctrl FNE key_ptrok
                        INB ps2_ptr+1 AIB 0x80,ps2_ptr+0
  key_ptrok:          RDR ps2_ptr STB ps2_ascii               ; read table data from FLASH memory and store ASCII code
                      RTS

  key_release:    MIB 1,ps2_release                           ; IMPROVED PS2 RELEASE DETECTION by Michael Kamprath - WORKS GREATER!
                    CLZ 0xff                                  ; waits for the follow-up of 0xf0 for
    key_wait:       INK CPI 0xff BNE key_reentry              ; a maximum of ~10ms (3+2+3+18*16+5+4) * 256 * 0.125ns
                      NOP NOP NOP NOP NOP NOP NOP NOP NOP NOP ; to allow for key up datagram to arrive
                      NOP NOP NOP NOP NOP NOP NOP NOP
                      INZ 0xff BCC key_wait                   ; and repeat max. 256 times
                        FPA key_clrrel                        ; time-out: ignore 0xf0 (missed proceeding datum)

  key_shift:      LDB ps2_release NEG STB ps2_shift FPA key_clrrel
  key_alt:        LDB ps2_release NEG STB ps2_alt FPA key_clrrel
  key_ctrl:       LDB ps2_release NEG STB ps2_ctrl
  key_clrrel:     MIB 0xff,ps2_release
  key_rts:        RTS

  ps2_shift:      0xff                                        ; state of special keys
  ps2_ctrl:       0xff
  ps2_alt:        0xff
  ps2_release:    0xff
  ps2_ascii:      0x00                                        ; store pressed key code here
  ps2_ptr:        0xffff, 0x01                                ; pointer to FLASH tables on bank 1

; --------------------------------------------------
; Prints out a byte value A in HEX format
; modifies: (Z0..2)
; --------------------------------------------------
OS_PrintHex:    STB th_store+1 RL5 ANI 15 ADI "0"             ; extract MSB
                CPI 58 FCC th_msn
                  ADI 39
  th_msn:       JAS OS_PrintChar
  th_store:     LDI 0xcc ANI 15 ADI "0"                       ; extract LSB
                CPI 58 FCC th_lsn
                  ADI 39
  th_lsn:       JAS OS_PrintChar
                RTS

; ---------------------------------------------------------------------------
; Skips whitespace in user input by advancing _ReadPtr over characters 32..39
; ---------------------------------------------------------------------------
OS_SkipSpace: CIT 32,_ReadPtr BCC ps_useit
                CIT 39,_ReadPtr BGT ps_useit
                  INZ _ReadPtr+0 JPA OS_SkipSpace
  ps_useit:   RTS

; *******************************************************************************
; Prints a single character in A at position (_XPos, _YPos)
; updates _XPos and _YPos and handles LF including scrolling
; modifies: _XPos, _YPos, (Z0..2)
; *******************************************************************************
OS_PrintChar:   CPI 10 FNE pz_regular
  pz_enter:       CLZ _XPos INZ _YPos CPI <HEIGHT FCC pz_exit ; ENTER in last row? scroll!
                    DEZ _YPos JPA OS_ScrollUp                 ; ... and returns from there
    pz_godown:    INZ _YPos RTS                               ; move cursor one down
  pz_regular:   JAS OS_Char
                INZ _XPos CPI <WIDTH FCS pz_enter
  pz_exit:        RTS

; *******************************************************************************
; Scrolls the video area one character upwards
; modifies: Z0..1
; *******************************************************************************
OS_ScrollUp:    MIB 0x45,su_loopx+2                           ; set source and target page
                MIB 0x43,su_loopx+5
                MIB 0x46,su_loopx+8                           ; set source and target page
                MIB 0x44,su_loopx+11
                MIZ <VIEWPORT,Z0                              ; skip empty bytes of page
  su_loopq:     MIZ <WIDTH,Z1                                 ; chars per row
  su_loopx:     LZP Z0,0xcc SZP Z0,0xcc                       ; move a char (upper and lower part)
                LZP Z0,0xcc SZP Z0,0xcc
                INZ Z0 DEZ Z1 FGT su_loopx                    ; horizontal step
                  AIZ <64-WIDTH,Z0 FCC su_loopq               ; next line, repeat 4 times
                    AIB 2,su_loopx+5 INC STB su_loopx+11      ; goto next char row
                    INC STB su_loopx+2 INC STB su_loopx+8 FPL su_loopq
                      CLZ _XPos JPS OS_ClearRow RTS           ; clears from _XPos onwards

; *******************************************************************************
; Clears a pixel at position (xa, ya) without safety check (highly optimized)
; *******************************************************************************
OS_ClearPixel:    RZP ya,>LineMSBTable,1 STB cp_index+1       ; calculate start index using (xa,ya)
                  RZP ya,>LineLSBTable,1 STB cp_index+0       ; get start index of line
                  LDZ xa+1 DEC LDZ xa                         ; adjust VRAM x position
                  RL6 ANI 63 AD.B cp_index+0                  ; overflow is not possible
                  LDZ xa+0 ANI 7 RAP >ClrTable,1 AN.B         ; init bit pixel pattern
  cp_index:       0xcccc RTS                                  ; self-modifying code

; *******************************************************************************
; Prints a null-terminated string into video RAM starting at (_XPos, _YPos)
; updates cursor position, handles LF and scrolling
; push: strptr_lsb, strptr_msb
; pull: #, #
; modifies: _XPos, _YPos, (Z0..2)
; *******************************************************************************
OS_PrintPtr:    LDS 3 STZ Z4 LDS 4 STZ Z3 FPA vpp_entry       ; copy text pointer
  vpp_loop:       JAS OS_PrintChar INV Z3
  vpp_entry:      CIT 0,Z3 FNE vpp_loop                       ; load next char and test for end
                    RTS

; ------------------------------------------------------------------------------------------------------
; Generates a pseudo-random byte in A (highly optimized)
; Algorithm described by EternityForest (2011)
; https://www.electro-tech-online.com/threads/ultra-fast-pseudorandom-number-generator-for-8-bit.124249/
; ------------------------------------------------------------------------------------------------------
OS_Random:      INZ _RandomState+0                            ; x,A = x++
                XRZ _RandomState+3                            ; A = x^c
                XR.Z _RandomState+1                           ; a,A = x^a^c order of XOR doesn't matter
                AD.Z _RandomState+2                           ; b,A = b + a
                LR1                                           ; A = b>>1
                ADZ _RandomState+3                            ; A = (b>>1)+c
                XRZ _RandomState+1                            ; A = (c+(b>>1))^a
                STZ _RandomState+3                            ; c = (c+(b>>1))^a
                RTS                                           ; return c in A

OS_StartFile:   "autostart", 0                                ; filename of the startup batch file

OS_Image_End:                                                 ; address of first byte beyond OS kernel code

#org 0xf00      ; 72 x 28 pixel Minimal logo (252 bytes)

MinimalLogo:    0xe0,0x01,0x00,0xc0,0x01,0x00,0x00,0x00,0x78,0xe0,0x03,0x00,0xf0,0x03,0x00,0x00,0x00,0xfc
                0xe0,0x0f,0x00,0xf8,0x03,0x00,0x00,0x00,0xe6,0xe0,0x1e,0x00,0xbe,0x03,0x00,0x00,0x00,0xc3
                0xe0,0x3c,0x80,0xcf,0x01,0x00,0x00,0x80,0xc3,0xe0,0x78,0xc0,0xc7,0x01,0x00,0x00,0xc0,0xc1
                0xc0,0xe0,0xf0,0xc1,0x01,0x00,0x00,0xc0,0xc0,0xc0,0xc1,0x79,0xe0,0x00,0x00,0x00,0xe0,0xc0
                0xc0,0x81,0x3f,0xe0,0x00,0x00,0x00,0x60,0x60,0xc0,0x01,0x1f,0x60,0x00,0x00,0x00,0x70,0x60
                0x80,0x03,0x06,0x70,0x00,0x00,0x00,0x70,0x70,0x80,0x03,0x00,0x70,0x00,0x00,0x00,0x30,0x30
                0x80,0x03,0x00,0x30,0x00,0x00,0x00,0x30,0x18,0xc0,0x01,0x00,0x30,0x00,0x00,0x00,0x38,0x1c
                0xc0,0x01,0x00,0x38,0x00,0x00,0x00,0x38,0x0c,0xe0,0x00,0xe0,0x38,0x00,0x00,0x00,0x38,0x06
                0xe0,0x3c,0xf0,0x79,0x00,0x00,0xe0,0x39,0x07,0x70,0x3e,0xe0,0x71,0x00,0x00,0xf8,0xbb,0x03
                0x30,0x0e,0x00,0x70,0x18,0xe0,0xdc,0xfb,0x61,0x38,0x00,0x00,0xe0,0x1c,0xf3,0xcc,0xf1,0x38
                0x18,0x00,0x00,0xe3,0x9c,0xfb,0xee,0xff,0x1f,0x1c,0x67,0x98,0xc3,0xd9,0xef,0xfe,0x8f,0x07
                0x8c,0x63,0x9e,0xc3,0xf9,0xe7,0x3c,0x00,0x00,0x8e,0xf3,0x9f,0xcf,0xb9,0xe3,0x00,0x00,0x00
                0xce,0xf1,0x9f,0x87,0x1b,0x00,0x00,0x00,0x00,0xc7,0xf7,0x39,0x83,0x03,0x00,0x00,0x00,0x00
                0x87,0x63,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x07,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00

#mute                                                         ; GLOBAL OS LABELS AND CONSTANTS

#org 0x0080     xa: steps: 0xffff                             ; zero-page graphics interface (OS_SetPixel, OS_ClearPixel, OS_Line, OS_Rect)
                ya:        0xff
                xb:        0xffff
                yb:        0xff
                dx:        0xffff
                dy:        0xff
                bit:       0xff
                err:       0xffff

#org 0x0080     PtrA:                                         ; lokaler pointer (3 bytes) used for FLASH addr and bank
#org 0x0083     PtrB:                                         ; lokaler pointer (3 bytes)
#org 0x0086     PtrC:                                         ; lokaler pointer (3 bytes)
#org 0x0089     PtrD:                                         ; lokaler pointer (3 bytes)
#org 0x008c     PtrE:                                         ; lokaler pointer (2 bytes)
#org 0x008e     PtrF:                                         ; lokaler pointer (2 bytes)

#org 0x0090     Z0:                                           ; OS zero-page multi-purpose registers
#org 0x0091     Z1:
#org 0x0092     Z2:
#org 0x0093     Z3:
#org 0x0094     Z4:
#org 0x0095     Z5:

#org 0x00c0     _XPos:                                        ; current VGA cursor col position (x: 0..WIDTH-1)
#org 0x00c1     _YPos:                                        ; current VGA cursor row position (y: 0..HEIGHT-1)
#org 0x00c2     _RandomState:                                 ; 4-byte storage (x, a, b, c) state of the pseudo-random generator
#org 0x00c6     _ReadNum:                                     ; 3-byte storage for parsed 16-bit number, MSB: 0xf0=invalid, 0x00=valid
#org 0x00c9     _ReadPtr:                                     ; Zeiger (2 bytes) auf das letzte eingelesene Zeichen (to be reset at startup)
#org 0x00cb                                                   ; 2 bytes unused
#org 0x00cd     _ReadBuffer:                                  ; WIDTH bytes of OS line input buffer
#org 0x00fe     ReadLast:                                     ; last byte of read buffer
#org 0x00ff     SystemReg:                                    ; Don't use it unless you know what you're doing.

#org 0x4000     VIDEORAM:                                     ; start of 16KB of VRAM 0x4000..0x7fff
#org 0x430c     VIEWPORT:                                     ; start index of 416x240 pixel viewport (0x4000 + 12*64 + 11)
#org 0x0032     WIDTH:                                        ; screen width in characters
#org 0x001e     HEIGHT:                                       ; screen height in characters

#emit

; **********************************************************************************************************

#org 0x1000                                                   ; store tables in bank 1

  #mute
  #org 0x0000   ; BANK 1: Charset & Table Data
  #emit
Charset:        ; CHARACTER SET (256 x 8 bytes) and lookup tables for bit value
SetTable:       0x01,0x02,0x04,0x08,0x10,0x20,0x40,0x80,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xc0,0x03,0x00,0x18,0x66,0x66,0x18,0x46,0x3c,0x30,0x30,0x0c,0x00,0x00,0x00,0x00,0x00,0x00,0x3c,0x18,0x3c,0x3c,0x60,0x7e,0x3c,0x7e,0x3c,0x3c,0x00,0x00,0x70,0x00,0x0e,0x3c,0x3c,0x18,0x3e,0x3c,0x1e,0x7e,0x7e,0x3c,0x66,0x3c,0x78,0x66,0x06,0xc6,0x66,0x3c,0x3e,0x3c,0x3e,0x3c,0x7e,0x66,0x66,0xc6,0x66,0x66,0x7e,0x3c,0x00,0x3c,0x08,0x00,0x3c,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x70,0x18,0x0e,0x00,0x00,0x00,0x00,0x00,0x18,0x18,0x18,0x18,0x18,0x18,0x00,0x00,0x00,0x18,0x18,0xff,0xff,0x80,0x01,0xf0,0x0f,0xff,0x00,0xf0,0x0f,0xff,0x00,0xf0,0x0f,0xff,0x00,0xf0,0x0f,0xff,0xe7,0x99,0x99,0xe7,0xb9,0xc3,0xcf,0xcf,0xf3,0xff,0xff,0xff,0xff,0xff,0xff,0xc3,0xe7,0xc3,0xc3,0x9f,0x81,0xc3,0x81,0xc3,0xc3,0xff,0xff,0x8f,0xff,0xf1,0xc3,0xc3,0xe7,0xc1,0xc3,0xe1,0x81,0x81,0xc3,0x99,0xc3,0x87,0x99,0xf9,0x39,0x99,0xc3,0xc1,0xc3,0xc1,0xc3,0x81,0x99,0x99,0x39,0x99,0x99,0x81,0xc3,0xff,0xc3,0xf7,0xff,0xc3,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0x8f,0xe7,0xf1,0xff,0xff,
ClrTable:       0xfe,0xfd,0xfb,0xf7,0xef,0xdf,0xbf,0x7f,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xe0,0x07,0x00,0x18,0x66,0x66,0x7c,0x66,0x66,0x30,0x18,0x18,0x66,0x18,0x00,0x00,0x00,0xc0,0x66,0x18,0x66,0x66,0x70,0x06,0x66,0x66,0x66,0x66,0x00,0x00,0x18,0x00,0x18,0x66,0x66,0x3c,0x66,0x66,0x36,0x06,0x06,0x66,0x66,0x18,0x30,0x36,0x06,0xee,0x6e,0x66,0x66,0x66,0x66,0x66,0x18,0x66,0x66,0xc6,0x66,0x66,0x60,0x0c,0x06,0x30,0x1c,0x00,0x66,0x00,0x06,0x00,0x60,0x00,0x70,0x00,0x06,0x18,0x60,0x06,0x1c,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x18,0x00,0x00,0x00,0x00,0x00,0x00,0x18,0x18,0x18,0x00,0x08,0x00,0x00,0x00,0x18,0x18,0x18,0x18,0x18,0x18,0x00,0x00,0x00,0x18,0x18,0xfe,0x7f,0xc0,0x03,0xf0,0x0f,0xff,0x00,0xf0,0x0f,0xff,0x00,0xf0,0x0f,0xff,0x00,0xf0,0x0f,0xff,0xe7,0x99,0x99,0x83,0x99,0x99,0xcf,0xe7,0xe7,0x99,0xe7,0xff,0xff,0xff,0x3f,0x99,0xe7,0x99,0x99,0x8f,0xf9,0x99,0x99,0x99,0x99,0xff,0xff,0xe7,0xff,0xe7,0x99,0x99,0xc3,0x99,0x99,0xc9,0xf9,0xf9,0x99,0x99,0xe7,0xcf,0xc9,0xf9,0x11,0x91,0x99,0x99,0x99,0x99,0x99,0xe7,0x99,0x99,0x39,0x99,0x99,0x9f,0xf3,0xf9,0xcf,0xe3,0xff,0x99,0xff,0xf9,0xff,0x9f,0xff,0x8f,0xff,0xf9,0xe7,0x9f,0xf9,0xe3,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xe7,0xff,0xff,0xff,0xff,0xff,0xff,0xe7,0xe7,0xe7,0xff,0xf7,
RectLeftTable:  0xff,0xfe,0xfc,0xf8,0xf0,0xe0,0xc0,0x80,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x70,0x0e,0x00,0x18,0x66,0xff,0x06,0x30,0x3c,0x30,0x0c,0x30,0x3c,0x18,0x00,0x00,0x00,0x60,0x76,0x1c,0x60,0x60,0x78,0x3e,0x06,0x30,0x66,0x66,0x18,0x18,0x0c,0x7e,0x30,0x60,0x76,0x66,0x66,0x06,0x66,0x06,0x06,0x06,0x66,0x18,0x30,0x1e,0x06,0xfe,0x7e,0x66,0x66,0x66,0x66,0x06,0x18,0x66,0x66,0xc6,0x3c,0x66,0x30,0x0c,0x0c,0x30,0x36,0x00,0x76,0x3c,0x06,0x3c,0x60,0x3c,0x18,0x7c,0x06,0x00,0x00,0x06,0x18,0x66,0x3e,0x3c,0x3e,0x7c,0x3e,0x7c,0x7e,0x66,0x66,0xc6,0x66,0x66,0x7e,0x18,0x18,0x18,0x00,0x0c,0x00,0x00,0x00,0x18,0x18,0x18,0x18,0x18,0x18,0x00,0x00,0x00,0x38,0x1c,0xfc,0x3f,0xe0,0x07,0xf0,0x0f,0xff,0x00,0xf0,0x0f,0xff,0x00,0xf0,0x0f,0xff,0x00,0xf0,0x0f,0xff,0xe7,0x99,0x00,0xf9,0xcf,0xc3,0xcf,0xf3,0xcf,0xc3,0xe7,0xff,0xff,0xff,0x9f,0x89,0xe3,0x9f,0x9f,0x87,0xc1,0xf9,0xcf,0x99,0x99,0xe7,0xe7,0xf3,0x81,0xcf,0x9f,0x89,0x99,0x99,0xf9,0x99,0xf9,0xf9,0xf9,0x99,0xe7,0xcf,0xe1,0xf9,0x01,0x81,0x99,0x99,0x99,0x99,0xf9,0xe7,0x99,0x99,0x39,0xc3,0x99,0xcf,0xf3,0xf3,0xcf,0xc9,0xff,0x89,0xc3,0xf9,0xc3,0x9f,0xc3,0xe7,0x83,0xf9,0xff,0xff,0xf9,0xe7,0x99,0xc1,0xc3,0xc1,0x83,0xc1,0x83,0x81,0x99,0x99,0x39,0x99,0x99,0x81,0xe7,0xe7,0xe7,0xff,0xf3,
RectRightTable: 0x01,0x03,0x07,0x0f,0x1f,0x3f,0x7f,0xff,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x38,0x1c,0x00,0x18,0x00,0x66,0x3c,0x18,0x1c,0x00,0x0c,0x30,0xff,0x7e,0x00,0x7e,0x00,0x30,0x6e,0x18,0x30,0x38,0x66,0x60,0x3e,0x18,0x3c,0x7c,0x00,0x00,0x06,0x00,0x60,0x30,0x76,0x7e,0x3e,0x06,0x66,0x1e,0x1e,0x76,0x7e,0x18,0x30,0x0e,0x06,0xd6,0x7e,0x66,0x3e,0x66,0x3e,0x3c,0x18,0x66,0x66,0xd6,0x18,0x3c,0x18,0x0c,0x18,0x30,0x63,0x00,0x76,0x60,0x3e,0x06,0x7c,0x66,0x7c,0x66,0x3e,0x1c,0x60,0x36,0x18,0xfe,0x66,0x66,0x66,0x66,0x66,0x06,0x18,0x66,0x66,0xd6,0x3c,0x66,0x30,0x0e,0x18,0x70,0xdc,0xfe,0xf8,0xff,0x1f,0xf8,0xff,0x1f,0xf8,0xff,0x1f,0xff,0xe0,0x07,0xf0,0x0f,0xf8,0x1f,0xf0,0x0f,0xf0,0x0f,0xff,0x00,0xf0,0x0f,0xff,0x00,0xf0,0x0f,0xff,0x00,0xf0,0x0f,0xff,0xe7,0xff,0x99,0xc3,0xe7,0xe3,0xff,0xf3,0xcf,0x00,0x81,0xff,0x81,0xff,0xcf,0x91,0xe7,0xcf,0xc7,0x99,0x9f,0xc1,0xe7,0xc3,0x83,0xff,0xff,0xf9,0xff,0x9f,0xcf,0x89,0x81,0xc1,0xf9,0x99,0xe1,0xe1,0x89,0x81,0xe7,0xcf,0xf1,0xf9,0x29,0x81,0x99,0xc1,0x99,0xc1,0xc3,0xe7,0x99,0x99,0x29,0xe7,0xc3,0xe7,0xf3,0xe7,0xcf,0x9c,0xff,0x89,0x9f,0xc1,0xf9,0x83,0x99,0x83,0x99,0xc1,0xe3,0x9f,0xc9,0xe7,0x01,0x99,0x99,0x99,0x99,0x99,0xf9,0xe7,0x99,0x99,0x29,0xc3,0x99,0xcf,0xf1,0xe7,0x8f,0x23,0x01,
                0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x1c,0x38,0x00,0x00,0x00,0xff,0x60,0x0c,0xe6,0x00,0x0c,0x30,0x3c,0x18,0x00,0x00,0x00,0x18,0x66,0x18,0x0c,0x60,0xfe,0x60,0x66,0x18,0x66,0x60,0x00,0x00,0x0c,0x7e,0x30,0x18,0x06,0x66,0x66,0x06,0x66,0x06,0x06,0x66,0x66,0x18,0x30,0x1e,0x06,0xc6,0x76,0x66,0x06,0x66,0x1e,0x60,0x18,0x66,0x66,0xfe,0x3c,0x18,0x0c,0x0c,0x30,0x30,0x00,0x00,0x06,0x7c,0x66,0x06,0x66,0x7e,0x18,0x66,0x66,0x18,0x60,0x1e,0x18,0xfe,0x66,0x66,0x66,0x66,0x06,0x3c,0x18,0x66,0x66,0xfe,0x18,0x66,0x18,0x18,0x18,0x18,0x76,0xfe,0xf8,0xff,0x1f,0xf8,0xff,0x1f,0xf8,0xff,0x1f,0xff,0xf0,0x0f,0xe0,0x07,0xf0,0x0f,0xf8,0x1f,0x00,0x00,0x00,0xf0,0xf0,0xf0,0xf0,0x0f,0x0f,0x0f,0x0f,0xff,0xff,0xff,0xff,0xff,0xff,0x00,0x9f,0xf3,0x19,0xff,0xf3,0xcf,0xc3,0xe7,0xff,0xff,0xff,0xe7,0x99,0xe7,0xf3,0x9f,0x01,0x9f,0x99,0xe7,0x99,0x9f,0xff,0xff,0xf3,0x81,0xcf,0xe7,0xf9,0x99,0x99,0xf9,0x99,0xf9,0xf9,0x99,0x99,0xe7,0xcf,0xe1,0xf9,0x39,0x89,0x99,0xf9,0x99,0xe1,0x9f,0xe7,0x99,0x99,0x01,0xc3,0xe7,0xf3,0xf3,0xcf,0xcf,0xff,0xff,0xf9,0x83,0x99,0xf9,0x99,0x81,0xe7,0x99,0x99,0xe7,0x9f,0xe1,0xe7,0x01,0x99,0x99,0x99,0x99,0xf9,0xc3,0xe7,0x99,0x99,0x01,0xe7,0x99,0xe7,0xe7,0xe7,0xe7,0x89,0x01,
                0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x0e,0x70,0x00,0x00,0x00,0x66,0x3e,0x66,0x66,0x00,0x18,0x18,0x66,0x18,0x18,0x00,0x18,0x0c,0x66,0x18,0x06,0x66,0x60,0x66,0x66,0x18,0x66,0x66,0x18,0x18,0x18,0x00,0x18,0x00,0x66,0x66,0x66,0x66,0x36,0x06,0x06,0x66,0x66,0x18,0x36,0x36,0x06,0xc6,0x66,0x66,0x06,0x3c,0x36,0x66,0x18,0x66,0x3c,0xee,0x66,0x18,0x06,0x0c,0x60,0x30,0x00,0x00,0x66,0x66,0x66,0x06,0x66,0x06,0x18,0x7c,0x66,0x18,0x60,0x36,0x18,0xd6,0x66,0x66,0x3e,0x7c,0x06,0x60,0x18,0x66,0x3c,0x7c,0x3c,0x7c,0x0c,0x18,0x18,0x18,0x00,0x0c,0x18,0x18,0x18,0x18,0x18,0x18,0x00,0x00,0x00,0x00,0x38,0x1c,0x00,0x00,0xe0,0x07,0xfc,0x3f,0x00,0x00,0x00,0xf0,0xf0,0xf0,0xf0,0x0f,0x0f,0x0f,0x0f,0xff,0xff,0xff,0xff,0xff,0xff,0x99,0xc1,0x99,0x99,0xff,0xe7,0xe7,0x99,0xe7,0xe7,0xff,0xe7,0xf3,0x99,0xe7,0xf9,0x99,0x9f,0x99,0x99,0xe7,0x99,0x99,0xe7,0xe7,0xe7,0xff,0xe7,0xff,0x99,0x99,0x99,0x99,0xc9,0xf9,0xf9,0x99,0x99,0xe7,0xc9,0xc9,0xf9,0x39,0x99,0x99,0xf9,0xc3,0xc9,0x99,0xe7,0x99,0xc3,0x11,0x99,0xe7,0xf9,0xf3,0x9f,0xcf,0xff,0xff,0x99,0x99,0x99,0xf9,0x99,0xf9,0xe7,0x83,0x99,0xe7,0x9f,0xc9,0xe7,0x29,0x99,0x99,0xc1,0x83,0xf9,0x9f,0xe7,0x99,0xc3,0x83,0xc3,0x83,0xf3,0xe7,0xe7,0xe7,0xff,0xf3,
                0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x07,0xe0,0x00,0x18,0x00,0x66,0x18,0x62,0xfc,0x00,0x30,0x0c,0x00,0x00,0x18,0x00,0x18,0x06,0x3c,0x7e,0x7e,0x3c,0x60,0x3c,0x3c,0x18,0x3c,0x3c,0x00,0x18,0x70,0x00,0x0e,0x18,0x3c,0x66,0x3e,0x3c,0x1e,0x7e,0x06,0x3c,0x66,0x3c,0x1c,0x66,0x7e,0xc6,0x66,0x3c,0x06,0x70,0x66,0x3c,0x18,0x3c,0x18,0xc6,0x66,0x18,0x7e,0x3c,0xc0,0x3c,0x00,0x00,0x3c,0x7c,0x3e,0x3c,0x7c,0x3c,0x18,0x60,0x66,0x3c,0x60,0x66,0x3c,0xc6,0x66,0x3c,0x06,0x60,0x06,0x3e,0x70,0x7c,0x18,0x6c,0x66,0x30,0x7e,0x70,0x18,0x0e,0x00,0x08,0x18,0x18,0x18,0x18,0x18,0x18,0x00,0x00,0x00,0x00,0x18,0x18,0x00,0x00,0xc0,0x03,0xfe,0x7f,0x00,0x00,0x00,0xf0,0xf0,0xf0,0xf0,0x0f,0x0f,0x0f,0x0f,0xff,0xff,0xff,0xff,0xe7,0xff,0x99,0xe7,0x9d,0x03,0xff,0xcf,0xf3,0xff,0xff,0xe7,0xff,0xe7,0xf9,0xc3,0x81,0x81,0xc3,0x9f,0xc3,0xc3,0xe7,0xc3,0xc3,0xff,0xe7,0x8f,0xff,0xf1,0xe7,0xc3,0x99,0xc1,0xc3,0xe1,0x81,0xf9,0xc3,0x99,0xc3,0xe3,0x99,0x81,0x39,0x99,0xc3,0xf9,0x8f,0x99,0xc3,0xe7,0xc3,0xe7,0x39,0x99,0xe7,0x81,0xc3,0x3f,0xc3,0xff,0xff,0xc3,0x83,0xc1,0xc3,0x83,0xc3,0xe7,0x9f,0x99,0xc3,0x9f,0x99,0xc3,0x39,0x99,0xc3,0xf9,0x9f,0xf9,0xc1,0x8f,0x83,0xe7,0x93,0x99,0xcf,0x81,0x8f,0xe7,0xf1,0xff,0xf7,
                0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x03,0xc0,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x0c,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x0c,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xff,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x3e,0x00,0x00,0x3c,0x00,0x00,0x00,0x00,0x00,0x06,0x60,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x1e,0x00,0x00,0x18,0x00,0x00,0x00,0x18,0x18,0x18,0x18,0x18,0x18,0x00,0x00,0x00,0x00,0x18,0x18,0x00,0x00,0x80,0x01,0xff,0xff,0x00,0x00,0x00,0xf0,0xf0,0xf0,0xf0,0x0f,0x0f,0x0f,0x0f,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xf3,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xf3,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0x00,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xc1,0xff,0xff,0xc3,0xff,0xff,0xff,0xff,0xff,0xf9,0x9f,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xe1,0xff,0xff,0xe7,0xff,0xff,0xff,

#org 0x1800
  #mute
  #org 0x0800   ; LSB of the VRAM line address
  #emit
LineLSBTable:   0x0c,0x4c,0x8c,0xcc,0x0c,0x4c,0x8c,0xcc,0x0c,0x4c,0x8c,0xcc,0x0c,0x4c,0x8c,0xcc,0x0c,0x4c,0x8c,0xcc,
                0x0c,0x4c,0x8c,0xcc,0x0c,0x4c,0x8c,0xcc,0x0c,0x4c,0x8c,0xcc,0x0c,0x4c,0x8c,0xcc,0x0c,0x4c,0x8c,0xcc,
                0x0c,0x4c,0x8c,0xcc,0x0c,0x4c,0x8c,0xcc,0x0c,0x4c,0x8c,0xcc,0x0c,0x4c,0x8c,0xcc,0x0c,0x4c,0x8c,0xcc,
                0x0c,0x4c,0x8c,0xcc,0x0c,0x4c,0x8c,0xcc,0x0c,0x4c,0x8c,0xcc,0x0c,0x4c,0x8c,0xcc,0x0c,0x4c,0x8c,0xcc,
                0x0c,0x4c,0x8c,0xcc,0x0c,0x4c,0x8c,0xcc,0x0c,0x4c,0x8c,0xcc,0x0c,0x4c,0x8c,0xcc,0x0c,0x4c,0x8c,0xcc,
                0x0c,0x4c,0x8c,0xcc,0x0c,0x4c,0x8c,0xcc,0x0c,0x4c,0x8c,0xcc,0x0c,0x4c,0x8c,0xcc,0x0c,0x4c,0x8c,0xcc,
                0x0c,0x4c,0x8c,0xcc,0x0c,0x4c,0x8c,0xcc,0x0c,0x4c,0x8c,0xcc,0x0c,0x4c,0x8c,0xcc,0x0c,0x4c,0x8c,0xcc,
                0x0c,0x4c,0x8c,0xcc,0x0c,0x4c,0x8c,0xcc,0x0c,0x4c,0x8c,0xcc,0x0c,0x4c,0x8c,0xcc,0x0c,0x4c,0x8c,0xcc,
                0x0c,0x4c,0x8c,0xcc,0x0c,0x4c,0x8c,0xcc,0x0c,0x4c,0x8c,0xcc,0x0c,0x4c,0x8c,0xcc,0x0c,0x4c,0x8c,0xcc,
                0x0c,0x4c,0x8c,0xcc,0x0c,0x4c,0x8c,0xcc,0x0c,0x4c,0x8c,0xcc,0x0c,0x4c,0x8c,0xcc,0x0c,0x4c,0x8c,0xcc,
                0x0c,0x4c,0x8c,0xcc,0x0c,0x4c,0x8c,0xcc,0x0c,0x4c,0x8c,0xcc,0x0c,0x4c,0x8c,0xcc,0x0c,0x4c,0x8c,0xcc,
                0x0c,0x4c,0x8c,0xcc,0x0c,0x4c,0x8c,0xcc,0x0c,0x4c,0x8c,0xcc,0x0c,0x4c,0x8c,0xcc,0x0c,0x4c,0x8c,0xcc,

#org 0x1900
  #mute
  #org 0x0900   ; MSB of the VRAM line address
  #emit
LineMSBTable:   0x43,0x43,0x43,0x43,0x44,0x44,0x44,0x44,0x45,0x45,0x45,0x45,0x46,0x46,0x46,0x46,0x47,0x47,0x47,0x47,
                0x48,0x48,0x48,0x48,0x49,0x49,0x49,0x49,0x4a,0x4a,0x4a,0x4a,0x4b,0x4b,0x4b,0x4b,0x4c,0x4c,0x4c,0x4c,
                0x4d,0x4d,0x4d,0x4d,0x4e,0x4e,0x4e,0x4e,0x4f,0x4f,0x4f,0x4f,0x50,0x50,0x50,0x50,0x51,0x51,0x51,0x51,
                0x52,0x52,0x52,0x52,0x53,0x53,0x53,0x53,0x54,0x54,0x54,0x54,0x55,0x55,0x55,0x55,0x56,0x56,0x56,0x56,
                0x57,0x57,0x57,0x57,0x58,0x58,0x58,0x58,0x59,0x59,0x59,0x59,0x5a,0x5a,0x5a,0x5a,0x5b,0x5b,0x5b,0x5b,
                0x5c,0x5c,0x5c,0x5c,0x5d,0x5d,0x5d,0x5d,0x5e,0x5e,0x5e,0x5e,0x5f,0x5f,0x5f,0x5f,0x60,0x60,0x60,0x60,
                0x61,0x61,0x61,0x61,0x62,0x62,0x62,0x62,0x63,0x63,0x63,0x63,0x64,0x64,0x64,0x64,0x65,0x65,0x65,0x65,
                0x66,0x66,0x66,0x66,0x67,0x67,0x67,0x67,0x68,0x68,0x68,0x68,0x69,0x69,0x69,0x69,0x6a,0x6a,0x6a,0x6a,
                0x6b,0x6b,0x6b,0x6b,0x6c,0x6c,0x6c,0x6c,0x6d,0x6d,0x6d,0x6d,0x6e,0x6e,0x6e,0x6e,0x6f,0x6f,0x6f,0x6f,
                0x70,0x70,0x70,0x70,0x71,0x71,0x71,0x71,0x72,0x72,0x72,0x72,0x73,0x73,0x73,0x73,0x74,0x74,0x74,0x74,
                0x75,0x75,0x75,0x75,0x76,0x76,0x76,0x76,0x77,0x77,0x77,0x77,0x78,0x78,0x78,0x78,0x79,0x79,0x79,0x79,
                0x7a,0x7a,0x7a,0x7a,0x7b,0x7b,0x7b,0x7b,0x7c,0x7c,0x7c,0x7c,0x7d,0x7d,0x7d,0x7d,0x7e,0x7e,0x7e,0x7e,

#org 0x1a00
  #mute
  #org 0x0a00   ; PS/2 lookup table (in: PS/2 scancode and state PLAIN, SHIFT, ALTGR or CTRL, out: ASCII code)
  #emit
                ; _ReadInput and _WaitInput emit the following pseudo-ASCII codes for special PS/2 keypresses:
                ; ------------------------------------------------------------------------------------------------
                ; 0xe0 - 0xe7: CTRL q, Cursor Up, Cursor Down, Cursor Left, Cursor Right, Pos1, End, Page Up
                ; 0xe8 - 0xef: Page Down, CTRL a, CTRL x, CTRL c, CTRL v, CTRL l, CTRL s, CTRL n
                ; 0xf0 - 0xf2: Delete, CTRL r, CTRL t
                ; 0xf3 - 0xff: unused

PS2Table:       ; US KEYBOARD LAYOUT
  ; state: PLAIN keys
        0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0, 0x09,    0,    0,  ;  0x0_
        0,    0,    0,    0,    0,  "q",  "1",    0,    0,    0,  "z",  "s",  "a",  "w",  "2",    0,  ;  0x1_
        0,  "c",  "x",  "d",  "e",  "4",  "3",    0,    0,  " ",  "v",  "f",  "t",  "r",  "5",    0,  ;  0x2_
        0,  "n",  "b",  "h",  "g",  "y",  "6",    0,    0,    0,  "m",  "j",  "u",  "7",  "8",    0,  ;  0x3_
        0,  ",",  "k",  "i",  "o",  "0",  "9",    0,    0,  ".",  "/",  "l",  ";",  "p",  "-",    0,  ;  0x4_
        0,    0,  "'",    0,  "[",  "=",    0,    0,    0,    0,   10,  "]",    0,  "\",    0,    0,  ;  0x5_
        0,  "<",    0,    0,    0,    0,    8,    0,    0, 0xe6,    0, 0xe3, 0xe5,    0,    0,    0,  ;  0x6_
        0, 0xf0, 0xe2,    0, 0xe4, 0xe1,   27,    0,    0,    0, 0xe8,    0,    0, 0xe7,    0,    0,  ;  0x7_
  ;  -------------------------------------------------------------------------------------------------+------
  ;  0x_0  0x_1  0x_2  0x_3  0x_4  0x_5  0x_6  0x_7  0x_8  0x_9  0x_a  0x_b  0x_c  0x_d  0x_e  0x_f   ;  scan
  ;                                                                                                   ;  code
  ; state: with SHIFT
        0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,  "~",    0,  ;  0x0_
        0,    0,    0,    0,    0,  "Q",  "!",    0,    0,    0,  "Z",  "S",  "A",  "W",  "@",    0,  ;  0x1_
        0,  "C",  "X",  "D",  "E",  "$",  "#",    0,    0,    0,  "V",  "F",  "T",  "R",  "%",    0,  ;  0x2_
        0,  "N",  "B",  "H",  "G",  "Y",  "^",    0,    0,    0,  "M",  "J",  "U",  "&",  "*",    0,  ;  0x3_
        0,  "<",  "K",  "I",  "O",  ")",  "(",    0,    0,  ">",  "?",  "L",  ":",  "P",  "_",    0,  ;  0x4_
        0,    0,  '"',    0,  "{",  "+",    0,    0,    0,    0,    0,  "}",    0,  "|",    0,    0,  ;  0x5_
        0,  ">",    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,  ;  0x6_
        0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,  ;  0x7_
  ;  -------------------------------------------------------------------------------------------------+------
  ;  0x_0  0x_1  0x_2  0x_3  0x_4  0x_5  0x_6  0x_7  0x_8  0x_9  0x_a  0x_b  0x_c  0x_d  0x_e  0x_f   ;  scan
  ;                                                                                                   ;  code

  ; state: with ALTGR(=ALT)
        0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0 ;  0x0_
        0,    0,    0,    0,    0,  "@",    0,    0,    0,    0,    0,    0,    0,    0,    0,    0 ;  0x1_
        0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0 ;  0x2_
        0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,  "{",  "[",    0 ;  0x3_
        0,    0,    0,    0,    0,  "}",  "]",    0,    0,    0,    0,    0,    0,    0,  "\",    0 ;  0x4_
        0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,  "~",    0,    0,    0,    0 ;  0x5_
        0,  "|",    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0 ;  0x6_
        0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0 ;  0x7_
  ;  ------------------------------------------------------------------------------------------------+------
  ;  0x_0  0x_1  0x_2  0x_3  0x_4  0x_5  0x_6  0x_7  0x_8  0x_9  0x_a  0x_b  0x_c  0x_d  0x_e  0x_f  ;  scan
  ;                                                                                                  ;  code
  ; state: with CTRL(=STRG)
        0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0 ;  0x0_
        0,    0,    0,    0,    0, 0xe0,    0,    0,    0,    0,    0, 0xee, 0xe9,    0,    0,    0 ;  0x1_
        0, 0xeb, 0xea,    0,    0,    0,    0,    0,    0,    0, 0xec,    0, 0xf2, 0xf1,    0,    0 ;  0x2_
        0, 0xef,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0 ;  0x3_
        0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0, 0xed,    0,    0,    0,    0 ;  0x4_
        0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0 ;  0x5_
        0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0 ;  0x6_
        0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0 ;  0x7_
  ;  ------------------------------------------------------------------------------------------------+------
  ;  0x_0  0x_1  0x_2  0x_3  0x_4  0x_5  0x_6  0x_7  0x_8  0x_9  0x_a  0x_b  0x_c  0x_d  0x_e  0x_f  ;  scan
  ;                                                                                                  ;  code

#org 0x1c00
  #mute
  #org 0x0c00   ; list of mnemonic arguments (used by assembler asm.asm)
  #emit
Arguments:      0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
                0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
                0x02,0x03,0x02,0x03,0x02,0x03,0x02,0x03,0x02,0x03,0x02,0x03,0x02,0x03,0x02,0x03,
                0x00,0x02,0x03,0x02,0x03,0x02,0x03,0x00,0x02,0x03,0x02,0x03,0x02,0x03,0x01,0x02,
                0x03,0x02,0x03,0x02,0x03,0x01,0x02,0x03,0x02,0x03,0x02,0x03,0x01,0x02,0x03,0x02,
                0x03,0x02,0x03,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x03,0x03,0x03,0x03,
                0x03,0x03,0x03,0x03,0x03,0x03,0x03,0x03,0x03,0x00,0x00,0x00,0x01,0x01,0x13,0x03,
                0x03,0x32,0x13,0x03,0x01,0x02,0x03,0x02,0x03,0x01,0x03,0x12,0x32,0x02,0x03,0x02,
                0x03,0x12,0x21,0x31,0x21,0x31,0x23,0x33,0x22,0x32,0x23,0x33,0x22,0x23,0x02,0x03,
                0x02,0x03,0x02,0x03,0x00,0x02,0x03,0x02,0x03,0x02,0x03,0x00,0x02,0x03,0x02,0x03,
                0x02,0x03,0x01,0x02,0x03,0x02,0x03,0x02,0x03,0x02,0x03,0x02,0x03,0x02,0x03,0x21,
                0x31,0x21,0x31,0x21,0x31,0x21,0x31,0x22,0x32,0x22,0x32,0x22,0x32,0x23,0x33,0x23,
                0x33,0x23,0x22,0x01,0x02,0x03,0x02,0x03,0x02,0x03,0x02,0x03,0x02,0x03,0x02,0x03,
                0x21,0x31,0x21,0x31,0x21,0x31,0x21,0x31,0x22,0x32,0x22,0x32,0x22,0x32,0x23,0x33,
                0x23,0x33,0x23,0x22,0x01,0x02,0x03,0x02,0x03,0x21,0x31,0x21,0x31,0x22,0x32,0x23,
                0x33,0x01,0x02,0x03,0x02,0x03,0x02,0x03,0x01,0x02,0x03,0x02,0x03,0x02,0x03,0x00

#org 0x1d00
  #mute
  #org 0x0d00   ; list of mnemonic tokens (used by assembler asm.asm)
  #emit
Mnemonics:      "NOP","OUT","INT","INK","WIN","SEC","CLC","LL0","LL1","LL2","LL3","LL4","LL5","LL6","LL7","RL0",
                "RL1","RL2","RL3","RL4","RL5","RL6","RL7","RR1","LR0","LR1","LR2","LR3","LR4","LR5","LR6","LR7",
                "LLZ","LLB","LLV","LLW","LLQ","LLL","LRZ","LRB","RLZ","RLB","RLV","RLW","RLQ","RLL","RRZ","RRB",
                "NOT","NOZ","NOB","NOV","NOW","NOQ","NOL","NEG","NEZ","NEB","NEV","NEW","NEQ","NEL","ANI","ANZ",
                "ANB","ANT","ANR","ZAN","BAN","ORI","ORZ","ORB","ORT","ORR","ZOR","BOR","XRI","XRZ","XRB","XRT",
                "XRR","ZXR","BXR","FNE","FEQ","FCC","FCS","FPL","FMI","FGT","FLE","FPA","BNE","BEQ","BCC","BCS",
                "BPL","BMI","BGT","BLE","JPA","JPR","JAR","JPS","JAS","RTS","PHS","PLS","LDS","STS","RDB","RDR",
                "RAP","RZP","WDB","WDR","LDI","LDZ","LDB","LDT","LDR","LAP","LAB","LZP","LZB","STZ","STB","STT",
                "STR","SZP","MIZ","MIB","MIT","MIR","MIV","MIW","MZZ","MZB","MBZ","MBB","MVV","MWV","CLZ","CLB",
                "CLV","CLW","CLQ","CLL","INC","INZ","INB","INV","INW","INQ","INL","DEC","DEZ","DEB","DEV","DEW",
                "DEQ","DEL","ADI","ADZ","ADB","ADT","ADR","ZAD","BAD","TAD","RAD","ADV","ADW","ADQ","ADL","AIZ",
                "AIB","AIT","AIR","AIV","AIW","AIQ","AIL","AZZ","AZB","AZV","AZW","AZQ","AZL","ABZ","ABB","ABV",
                "ABW","ABQ","AVV","SUI","SUZ","SUB","SUT","SUR","ZSU","BSU","TSU","RSU","SUV","SUW","SUQ","SUL",
                "SIZ","SIB","SIT","SIR","SIV","SIW","SIQ","SIL","SZZ","SZB","SZV","SZW","SZQ","SZL","SBZ","SBB",
                "SBV","SBW","SBQ","SVV","CPI","CPZ","CPB","CPT","CPR","CIZ","CIB","CIT","CIR","CZZ","CZB","CBZ",
                "CBB","ACI","ACZ","ACB","ZAC","BAC","ACV","ACW","SCI","SCZ","SCB","ZSC","BSC","SCV","SCW","???"

; **********************************************************************************************************

#org 0x2000                                                   ; store MinOS commands as files in bank 2

"save", 0, "              ", 0, SaveStart, SaveEnd-SaveStart  ; file header

  #mute
  #org 0xff00                                                 ; target address in lower stack memory
  #emit                                                       ; this allows saving any RAM area except stack mem

  ; --------------------------------------------------
  ; usage: save <first_hex_addr> <last_hex_addr> <filename> <ENTER>
  ; receives access to command line on stack
  ; --------------------------------------------------
  SaveStart:      MIZ 1,Z0                                    ; read in first and last hex woard address
    sv_loop:      JPS _SkipSpace JPS _ReadHex                 ; skip spaces and parse first address
                  CIZ 0xf0,_ReadNum+2 BNE sv_input            ; wurde eine Zahl eingelesen?
    sv_syntax:      JPS _Print "save <first> <last> <name>", 10, 0
                    JPA _Prompt                               ; stack cleanup intentionally left out
    sv_input:     LDZ _ReadNum+0 PHS LDZ _ReadNum+1 PHS       ; push onto stack
                  DEZ Z0 BCS sv_loop
                    JPS _SkipSpace
                    LDT _ReadPtr CPI 39 BLE sv_syntax         ; look for a valid filename
                      JPS _SaveFile CPI 0 BNE _Prompt
                        JPS _Print "SAVE ERROR.", 10, 0
                        JPA _Prompt                           ; stack cleanup intentionally left out

  SaveEnd:

; **********************************************************************************************************

"dir", 0, "               ", 0, DirStart, DirEnd-DirStart     ; file header

  #mute
  #org 0xfc00                                                 ; target address of the code
  #emit

  ; --------------------------------------------------
  ; Displays the directory of the SSD drive
  ; usage: dir <ENTER>
  ; --------------------------------------------------
  DirStart:       JPS _Print 10, "FILENAME........... DEST ..SIZE (ESC)", 10, 0
                  CLV PtrA MIZ 2,PtrA+2                       ; point PtrA to start of SSD
                  MIZ 0x07,PtrC+2 MIV 0xe000,PtrC             ; PtrC holds SSD bytesize 0x07e000

  dc_lookfiles:   RDR PtrA CPI 0xff BEQ dc_endreached         ; end of used area reached?
                    ; first extract all data, later decide on printing
                    MVV PtrA,_ReadNum MZZ PtrA+2,_ReadNum+2   ; copy PtrA and PtrA+2 for printing
                    AIV 20,PtrA JPS OS_FlashA                 ; read start address -> PtrE
                    RDR PtrA STZ PtrE+0 INV PtrA JPS OS_FlashA
                    RDR PtrA STZ PtrE+1 INV PtrA JPS OS_FlashA
                    RDR PtrA STZ PtrB+0 INV PtrA JPS OS_FlashA ; read bytesize -> PtrB, F
                    RDR PtrA STZ PtrB+1 INV PtrA JPS OS_FlashA ; PtrA, PtrA+2 now point to data section
                    AVV PtrB,PtrA JPS OS_FlashA               ; add data byte size to reach next file pos
                    SVV PtrB,PtrC LDI 0 SC.Z PtrC+2           ; subtract data bytesize in PtrB from PtrC
                    SIV 24,PtrC LDI 0 SC.Z PtrC+2             ; subtract headersize from PtrC

  stoop:            CLZ _XPos                                 ; line start
                    JPS _ReadInput CPI 0 BNE _Prompt          ; user break?
                      RDR _ReadNum CPI 0 BEQ dc_lookfiles     ; check once if info should be printed
  dc_nextchar:          JAS _PrintChar                        ; print filename
                        INV _ReadNum SUI 0x10 BCC dc_noover
                          STZ _ReadNum+1 INZ _ReadNum+2
  dc_noover:            RDR _ReadNum CPI 0 BNE dc_nextchar    ; print stuff here
                          MIZ 20,_XPos
                          LDZ PtrE+1 JAS _PrintHex            ; start
                          LDZ PtrE+0 JAS _PrintHex
                          MIZ 27,_XPos
                          LDZ PtrB+1 JAS _PrintHex            ; bytesize
                          LDZ PtrB+0 JAS _PrintHex
                          INZ _YPos                           ; ENTER
                          CPI <HEIGHT BCC dc_lookfiles        ; scrolling?
                            DEZ _YPos JPS _ScrollUp
                              JPA dc_lookfiles

  dc_endreached:  MIZ 25,_XPos
                  LDZ PtrC+2 JAS _PrintHex
                  LDZ PtrC+1 JAS _PrintHex
                  LDZ PtrC+0 JAS _PrintHex
                  MIZ 20,_XPos JPS _Print "FREE ", 10, 0
                  JPA _Prompt

  DirEnd:

; **********************************************************************************************************

"defrag", 0, "            ", 0, DefragStart, DefragEnd-DefragStart ; file header

  #mute
  #org 0xfc00                                                 ; target address of the code
  #emit

  ; ---------------------------------------------------------------
  ; Defragments the SSD by removing/formating/freeing deleted parts
  ; usage: defrag <ENTER>
  ; dg_bin: FLASH has been processed behind this position
  ; dg_next: pointer beyond current file in FLASH
  ; dg_ram: pointer to RAM buffer 0x3000..0x3fff
  ; dg_newbank: next sector to be used
  ; ---------------------------------------------------------------
  DefragStart:    LDI 3 STB dg_next+2 STB dg_bis+2 STB dg_newbank ; pnext = pbis = user SSD start
                  CLW dg_next CLW dg_bis

    dg_nextchunk: LDI <0x3000 STB dg_ram+0 LDI >0x3000 STB dg_ram+1 ; reset RAM buffer pointer to buffer start

    dg_biseqnext: LDB dg_bis+0 CPB dg_next+0 BNE dg_copyabyte ; bis = next?
                    LDB dg_bis+1 CPB dg_next+1 BNE dg_copyabyte
                      LDB dg_bis+2 CPB dg_next+2 BNE dg_copyabyte
                        ; current file was processed (read into RAM) completely => fetch next one
                        MWV dg_next,PtrA MBZ dg_next+2,PtrA+2 ; bis now points beyond current file
      dg_checknext:     RDR PtrA                              ; READ BYTE AT NEXT LOCATION
                        CPI 0xff BEQ dg_endofused             ; END OF USED SSD AREA REACHED?
                          PHS                                 ; NO! -> store first byte of filename
                          AIV 22,PtrA JPS OS_FlashA           ; extract data bytesize
                          RDR PtrA STZ PtrB+0 INV PtrA JPS OS_FlashA ; read bytesize -> PtrB
                          RDR PtrA STZ PtrB+1 INV PtrA JPS OS_FlashA ; PtrA now point to data section
                          AVV PtrB,PtrA JPS OS_FlashA         ; add data byte size to reach next file pos, PtrA points beyond current file
                          LDZ PtrA+0 STB dg_next+0            ; WE HAVE AN UNTESTED NEW NEXT FILE LOCATION
                          LDZ PtrA+1 STB dg_next+1
                          LDZ PtrA+2 STB dg_next+2
                          PLS CPI 0 BNE dg_copythisfile       ; *bis = 0? Was that a visible file that needs copying?
                            LDI "." JAS _PrintChar            ; signal an invisible fragment
                            LDB dg_next+0 STB dg_bis+0        ; mark it as processed...
                            LDB dg_next+1 STB dg_bis+1        ; ... without copying it to RAM
                            LDB dg_next+2 STB dg_bis+2        ; now PtrA = next = bis
                            JPA dg_checknext                  ; go look for a non-deleted file
    dg_copythisfile:      LDI "f" JAS _PrintChar              ; signal a visible file
                          JPA dg_biseqnext                    ; reenter copying loop

    dg_copyabyte: LDB dg_ram+1 SUI >0x3000 CPI >0x1000 BCC dg_ramokay ; is still some space in RAM buffer?
                    ; RAM buffer is full => byte cannot be read and written
                    JPS writeRAM CIZ 0xff,PtrB+1 BEQ dg_nextchunk ; formats and writes (unfinished) sector
      dg_error:       JPS _Print 10, "WRITE ERROR", 10, 0
                      JPA _Prompt
    dg_ramokay:   ; read a byte from dg_bis to dg_ram
                  RDR dg_bis STR dg_ram                       ; read FLASH address and result store in RAM
                  INW dg_ram INW dg_bis SUI 0x10 BCC dg_biseqnext ; correct dg_bis+0..2 pointer
                    STB dg_bis+1 INB dg_bis+2 JPA dg_biseqnext

; writes a chunk of copied RAM data to FLASH starting at sector dg_newbank, FLASH addr 0x000
; PtrA+0..2: FLASH destination
; PtrB+0..1: RAM bytesize
; PtrC+0..1: RAM source addr
  writeRAM:     LDI "#" JAS _PrintChar                        ; indicate sector write
                MBZ dg_newbank,PtrA+2 CLV PtrA                ; set FLASH write destination
                LDI >0x3000 SU.B dg_ram+1 STZ PtrB+1
                MBZ dg_ram+0,PtrB+0                           ; PtrB = bytesize
                MIV 0x3000,PtrC                               ; PtrC = RAM source
                DEW dg_ram BCS dg_bytes                       ; calculate last used RAM location
                  STZ PtrB+1 RTS                              ; return 0xff = SUCCESS, nothing was written
  dg_bytes:     LDB dg_newbank JAS OS_FLASHErase              ; erase this FLASH bank
                INB dg_newbank                                ; goto next free bank
                JPS OS_FLASHWrite                             ; write used RAM chunk to FLASH
                RTS

; end of used SSD area => write the rest of RAM buffer to FLASH, format all used banks above
  dg_endofused: JPS writeRAM CIZ 0xff,PtrB+1 BNE dg_error     ; formats and writes (unfinished) chunk
                DEW dg_bis BCS dg_laloop                      ; perform dg_bis-- to point to last processed location
                  DEB dg_bis+2 LDI 0x0f STB dg_bis+1          ; calculate the max used FLASH bank
    dg_laloop:  LDB dg_newbank CPB dg_bis+2 BGT dg_raus
                  JAS OS_FLASHErase                           ; format this bank
                  LDI "-" JAS _PrintChar                      ; indicate a freed-up sector
                  INB dg_newbank JPA dg_laloop
    dg_raus:    LDI 10 JAS _PrintChar                         ; ENTER
                JPA _Prompt                                   ; END

  dg_ram:         0xffff                                      ; pointer to next free RAM location (0x8000..0xefff)
  dg_bis:         0xffff, 0xff                                ; pointer (bank/sector addr) to last read location of FLASH
  dg_next:        0xffff, 0xff                                ; pointer beyond FLASH area of current file
  dg_newbank:     0xff                                        ; next free bank

  DefragEnd:

; **********************************************************************************************************

"run", 0, "               ", 0, RunStart, RunEnd-RunStart     ; file header

  #mute
  #org 0xfc00                                                 ; target address of the code
  #emit

  ; --------------------------------------------------
  ; Displays the directory of the SSD drive
  ; usage: jump <address> <ENTER>
  ; --------------------------------------------------
  RunStart:       JPS _SkipSpace JPS _ReadHex                 ; skip spaces and parse first address
                  CIZ 0xf0,_ReadNum+2 BEQ 0x0100              ; default ist 0x0100
                    JPR _ReadNum

  RunEnd:

; **********************************************************************************************************

"clear", 0, "             ", 0, ClearStart, ClearEnd-ClearStart ; file header

  #mute
  #org 0xfc00                                                 ; target address of the code
  #emit

  ; --------------------------------------------------
  ; Clears the VGA screen and positions the cursor at the top
  ; usage: jump <address> <ENTER>
  ; --------------------------------------------------
  ClearStart:     JPS _Clear
                  CLZ _XPos CLZ _YPos
                  JPA _Prompt

  ClearEnd:

; **********************************************************************************************************

"del", 0, "               ", 0, DelStart, DelEnd-DelStart     ; file header

  #mute
  #org 0xfc00                                                 ; target address of the code
  #emit

  ; --------------------------------------------------
  ; Deletes a file from the SSD
  ; usage: del <filename> <ENTER>
  ; modifies: Z0
  ; --------------------------------------------------
  DelStart:       JPS _SkipSpace
                  LDT _ReadPtr CPI 39 BLE de_syntax           ; look for a valid filename
                    JPS _FindFile CPI 1 BNE de_notferror      ; invalidate exisiting file with that name?
                    LDZ PtrA+2 CPI 3 BCC de_canterror         ; file exists and may be deleted? invalidate its name to 0
                    LDI 0xaa WDB 0x0555,0x05                  ; INIT FLASH WRITE PROGRAM
                    LDI 0x55 WDB 0x0aaa,0x02
                    LDI 0xa0 WDB 0x0555,0x05
                    LDI 0 WDR PtrA                            ; START WRITE PROCESS
                    MIZ 20,Z0                                 ; re-read a maximum times
    de_delcheck:    DEZ Z0 BCC de_flasherror                  ; write took too long => ERROR!!!
                      RDR PtrA CPI 0 BNE de_delcheck          ; re-read FLASH location -> data okay?
                        JPA _Prompt                           ; FLASH off und zurück
  de_syntax:      JPS _Print "del <filename>", 10, 0 JPA _Prompt
  de_flasherror:  JPS _Print "DEL ERROR.", 10, 0 JPA _Prompt
  de_canterror:   JPS _Print "PROTECTED.", 10, 0 JPA _Prompt
  de_notferror:   JPS _Print "NOT FOUND.", 10, 0 JPA _Prompt

  DelEnd:

; **********************************************************************************************************

"show", 0, "              ", 0, ShowStart, ShowEnd-ShowStart  ; file header

  #mute
  #org 0xfc00                                                 ; target address of the code
  #emit

  ; --------------------------------------------------
  ; Displays a text file by paragraph marked as %
  ; usage: show <filename> <ENTER>
  ; modifies:
  ; --------------------------------------------------
  ShowStart:      JPS _SkipSpace
                  LDT _ReadPtr CPI 39 BGT sh_syntaxok         ; look for a valid filename
                    JPS _Print "show <textfile>", 10, 0
                    JPA _Prompt
    sh_syntaxok:  JPS _FindFile CPI 1 BEQ sh_found            ; A=1: success
                    JPS _Print "NOT FOUND.", 10, 0
                    JPA _Prompt
    sh_found:     AIV 24,PtrA JPS OS_FlashA                   ; hop over file header

    sh_firstpage: LDI 0xff PHS                                ; push end marker onto stack
    sh_nextpage:  LDZ PtrA+0 PHS LDZ PtrA+1 PHS LDZ PtrA+2 PHS ; push current page address onto stack
                  JPS _Clear CLV _XPos                        ; clear screen and cursor pos
    sh_shownext:  RDR PtrA                                    ; load next char
                  CPI 0 BMI sh_userexit                       ; test for EOF or illegal char
                    BNE sh_not_eof
                      JPS _WaitInput                          ; EOF => wait on user input
                      CPI 0xe1 BEQ sh_backpage
                      CPI 0xe7 BEQ sh_backpage
        sh_userexit:    JPS _Clear CLV _XPos JPA _Prompt      ; exit show
      sh_not_eof:   CPI "%" BEQ sh_pagebreak                  ; percentage sign indicates custom page-break
                      CPI 10 BEQ sh_enter
                        JAS _Char                             ; display a regular char
                        INZ _XPos CPI <WIDTH BCC sh_advance
      sh_enter:       CLZ _XPos INZ _YPos CPI <HEIGHT BCC sh_advance

      sh_pagebreak: INV PtrA JPS OS_FlashA                    ; PAGE-BREAK, advance over last char
                    JPS _WaitInput CPI 27 BEQ sh_userexit     ; wait on user input
                      CPI 0xe1 BEQ sh_backpage
                      CPI 0xe7 BEQ sh_backpage
                        JPA sh_nextpage
        sh_backpage:  PLS STZ PtrA+2 PLS STZ PtrA+1 PLS STZ PtrA+0 ; go back to top of current page
                      PLS CPI 0xff BEQ sh_firstpage           ; start of document was reached
                        STZ PtrA+2 PLS STZ PtrA+1 PLS STZ PtrA+0 ; go back one more page
                        JPA sh_nextpage

    sh_advance:   INV PtrA JPS OS_FlashA JPA sh_shownext      ; goto next char
    
  ShowEnd:

; **********************************************************************************************************

"memset", 0, "            ", 0, MemsetStart, MemsetEnd-MemsetStart ; file header

  #mute
  #org 0xfc00                                                 ; target address of the code
  #emit

  ; --------------------------------------------------
  ; usage: memset <adr_first> <adr_last> <byte> <ENTER>
  ; --------------------------------------------------
  MemsetStart:    JPS _SkipSpace JPS _ReadHex                 ; skip spaces and parse first address
                  CIZ 0xf0,_ReadNum+2 BEQ mf_syntax           ; number entered?
                    MVV _ReadNum,PtrA                         ; first address
                  JPS _SkipSpace JPS _ReadHex                 ; skip spaces and parse last address
                  CIZ 0xf0,_ReadNum+2 BEQ mf_syntax
                    MVV _ReadNum,PtrB                         ; last address
                  JPS _SkipSpace JPS _ReadHex                 ; skip spaces and parse byte value
                  CIZ 0xf0,_ReadNum+2 BEQ mf_syntax

  mfnext:           LDZ _ReadNum+0 STT PtrA                   ; WRITE INTO MEMORY
                    CZZ PtrA+0,PtrB+0 BNE mfweiter
                      CZZ PtrA+1,PtrB+1 BEQ _Prompt
  mfweiter:             INV PtrA
                        JPA mfnext

  mf_syntax:      JPS _Print "memset <first> <last> <value>", 10, 0
                  JPA _Prompt

  MemsetEnd:

; **********************************************************************************************************

"memmove", 0, "           ", 0, MemmoveStart, MemmoveEnd-MemmoveStart ; file header

  #mute
  #org 0xfc00                                                 ; target address of the code
  #emit

  ; --------------------------------------------------
  ; usage: memmove <adr_first> <adr_last> <adr_dest> <ENTER>
  ; --------------------------------------------------
  MemmoveStart:   JPS _SkipSpace JPS _ReadHex                 ; skip spaces and parse first address
                  CIZ 0xf0,_ReadNum+2 BEQ sc_syntax           ; number was entered?
                    MVV _ReadNum,PtrA                         ; first address
                  JPS _SkipSpace JPS _ReadHex                 ; skip spaces and parse last address
                  CIZ 0xf0,_ReadNum+2 BEQ sc_syntax
                    MVV _ReadNum,PtrB                         ; last address
                  JPS _SkipSpace JPS _ReadHex                 ; skip spaces and parse byte value
                  CIZ 0xf0,_ReadNum+2 BEQ sc_syntax
                    LDZ _ReadNum+0 PHS LDZ _ReadNum+1 PHS     ; push destination
                    LDZ PtrA+0 PHS SUV PtrB                   ; push source
                    LDZ PtrA+1 PHS SU.Z PtrB+1 INV PtrB       ; B = B - A + 1
                    LDZ PtrB+0 PHS LDZ PtrB+1 PHS             ; push number of bytes
                    JPS _MemMove                              ; do not clean up the stack
                    JPA _Prompt

  sc_syntax:      JPS _Print "memmove <first> <last> <dest>", 10, 0
                  JPA _Prompt 

  MemmoveEnd:

; **********************************************************************************************************

"format", 0, "            ", 0, FormatStart, FormatEnd-FormatStart ; file header

  #mute
  #org 0xfc00                                                 ; target address of the code
  #emit

  ; -------------------------------------------------
  ; Formats the SSD user area (all data will be lost)
  ; usage: format <ENTER>
  ; -------------------------------------------------
  FormatStart:    JPS _Print "Are you sure? (y/n)", 10, 0
                  JPS _WaitInput
    fm_input:     CPI "y" BNE _Prompt
                    JPS _Print "Formatting sectors 3-127.", 10, 0
    format_all:     LDI 0x03                                  ; start of SSD area is bank #03
    format_loop:    JAS OS_FLASHErase                         ; push bank address and delete
                    INC BPL format_loop
                      JPA _Prompt

  FormatEnd:

; **********************************************************************************************************

"receive", 0, "           ", 0, ReceiveStart, ReceiveEnd-ReceiveStart ; file header

  #mute
  #org 0xfc00                                                 ; target address of the code
  #emit

  ; ---------------------------------------------
  ; usage: receive <ENTER>, then paste a HEX file
  ; modifies: _ReadPtr, PtrA, Z0: hl_ReadHexByte, Z0..2: _Char
  ;           Z3: number of bytes to read
  ;           Z4: line checksum byte
  ;           Z5: isram flag, 0: FLASH, 1: RAM
  ;           PtrE: first address data is written to
  ;           PtrF: last address data is written to
  ; ---------------------------------------------
  ReceiveStart:   JPS _Print "Upload HEX file (ESC) ", 0
                  CLZ PtrA+1 CLZ _ReadPtr+1                   ; clear MSBs of pointers
                  MIV 0xffff,PtrE MIZ 1,Z5                    ; set firstaddr = INVALID, set isram = 1

  hl_readline:    MIZ <_ReadBuffer,PtrA+0 STZ _ReadPtr+0      ; _ReadPtr and PtrA point to _ReadBuffer
    hl_readloop:  JPS _WaitInput                              ; READ A LINE OF THE HEX FILE
                  CPI 27 FNE hl_next
      hl_exit:      JPS _Print " ", 10, 0 JPA _Prompt
      hl_fileerror: JPS _Print " ", 10, "FILE ERROR.", 10, 0 JPA _Prompt
    hl_next:      CPI 13 FEQ hl_readloop                      ; ignore CR
                    STT PtrA                                  ; store char in ReadBuffer
                    CPI 10 FEQ hl_scanforhex                  ; LF = end of the line?
                      INZ PtrA FPA hl_readloop                ; look for more line data first

  hl_scanforhex:  LDZ Z4 JAS _Char                            ; output checksum indicator
                  CIT ":",_ReadPtr FNE hl_fileerror           ; PROCESS A ":..." LINE OF THE HEX FILE
                    INZ _ReadPtr                              ; consume :
                    JPS hl_ReadHexByte STZ Z3 STZ Z4          ; parse number of data bytes, init checksum
                    JPS hl_ReadHexByte STZ PtrB+1 AD.Z Z4     ; parse 16-bit address -> PtrB
                    JPS hl_ReadHexByte STZ PtrB+0 AD.Z Z4
                    JPS hl_ReadHexByte                        ; parse record type
                    CPI 0x01 BEQ hl_endoffile
                      CPI 0x00 FNE hl_fileerror               ; only allow DATA type 0x00 here
                        ; DEZ Z3 FCC hl_alllineread           ; > 0 bytes to process?
                        CIZ 0xff,PtrE+1 FNE hl_readdata       ; check if it is the VERY FIRST received byte
                          MVV PtrB,PtrE                       ; store first addr
                          ORZ PtrB+0 STZ Z5                   ; LSB | MSB = 0 => set FLASH image upload
  hl_readdata:          MVV PtrB,PtrC
                        CIZ 0,Z5 FNE hl_dataloop
                          AIZ 0x80,PtrC+1                     ; add 0x8000 offset for FLASH images
    hl_dataloop:        JPS hl_ReadHexByte STT PtrC AD.Z Z4   ; parse and copy data block to RAM
                        INV PtrB INV PtrC
                        DEZ Z3 FGT hl_dataloop
                          MVV PtrB,PtrF                       ; save last address after this line
                          JPS hl_ReadHexByte                  ; read final checksum...
                          ADZ Z4 FEQ hl_readline              ; ... and goto next line
    hl_checkerror:          JPS _Print " ", 10, "CHECKSUM ERROR.", 10, 0
                            JPA _Prompt

  hl_endoffile:     AD.Z Z4                                   ; add record type 0x01 to checksum
                    JPS hl_ReadHexByte ADZ Z4 FNE hl_checkerror ; errors in last checksum?
                      CIZ 0,Z5 BEQ hl_flashimage              ; was this a FLASH images?
                        JPS _Print " ", 10, "Written to ", 0  ; WRITTEN TO RAM => output memory range
                        LDZ PtrE+1 JAS _PrintHex
                        LDZ PtrE+0 JAS _PrintHex
                        INZ _XPos DEW PtrF
                        LDZ PtrF+1 JAS _PrintHex
                        LDZ PtrF+0 JAS _PrintHex
                        JPA hl_exit                           ; SUCCESS

  hl_flashimage:    JPS _Print " ", 10, "Write image? (y/n)", 10, 0 ; WRITE FLASH IMAGE
                    JPS _WaitInput CPI "y" BNE _Prompt
    hl_imageclr:      CIZ >0x8000+0x3000,PtrC+1 FEQ hl_imagerdy ; fill rest of 3rd sector with 0xff
                        MIT 0xff,PtrC INV PtrC FPA hl_imageclr
    hl_imagerdy:      JPS _Print "Writing...", 10, 0
                      LDI 0 JAS OS_FLASHErase                 ; erase banks 0..2
                      LDI 1 JAS OS_FLASHErase
                      LDI 2 JAS OS_FLASHErase
                      MIV 0x8000,PtrC                         ; start of 3 sectors in RAM
                      MIV 0x3000,PtrB                         ; byte size of the 3 sectors
                      CLV PtrA CLZ PtrA+2
                      JPS OS_FLASHWrite
                      CIZ 0xff,PtrB+1 BEQ _Prompt             ; all went well?
                        JPS _Print "FLASH ERROR.", 10, 0
                        JPA _Prompt

  ; ------------------------------------------------------------------------------------------
  ; Parse a HEX TWO-DIGIT UPPER-CASE number from _ReadPtr pointing into OS command line buffer 
  ; modifies: _ReadPtr, Z0 (HEX result)
  ; ------------------------------------------------------------------------------------------
  hl_ReadHexByte: CIT "0",_ReadPtr                            ; rel load from _ReadPtr, subtract 48
                    CPI 17 FCC hl_gotfirst                    ; 1st is a digit 0..9?
                      SUI 7                                   ; 1st must be A..F
    hl_gotfirst:  LL4 STZ Z0                                  ; store 1st as upper nibble
                  INZ _ReadPtr CIT "0",_ReadPtr               ; consume 1st char, load 2nd char
                    CPI 17 FCC hl_gotsecond                   ; 2nd is a digit 0..9?
                      SUI 7                                   ; 2nd must be A..F
    hl_gotsecond: AD.Z Z0                                     ; add 2nd as lower nibble
                  INZ _ReadPtr                                ; consume 2nd
                  LDZ Z0                                      ; return full byte value in A
                  RTS

  ReceiveEnd:

; **********************************************************************************************************

"mon", 0, "               ", 0, MonStart, MonEnd-MonStart     ; file header

  #mute
  #org 0xfc00                                                 ; target address of the code
  #emit

  ; --------------------------------------------------
  ; Memory Monitor
  ; usage: mon [<start>[.[<last>]]] <ENTER>
  ; modifies: Z5: mode, Z4, Z3, (Z0..2)
  ; --------------------------------------------------
  MonStart:   JPS _Print 10, "[MONITOR] [':' deposit, '.' list, 'n' bank]", 10, 0
              CLV PtrA+0 MIZ 0xff,PtrA+2                      ; set address and bank to default 0x0000, 0xff
              CIT 10,_ReadPtr FNE w_parseln                   ; use command line parameters trailing 'mon'?
  w_startln:    JPS w_printaddr
                MIV _ReadBuffer,_ReadPtr                      ; init read buffer
                AZZ _XPos,_ReadPtr+0                          ; parse fewer byte due to line address
                JPS _ReadLine                                 ; get a line of input
  w_parseln:  CLZ Z5                                          ; reset monitor mode
              CIT 10,_ReadPtr FNE w_parsing                   ; Check for empty ENTER => EXIT
                JPA _Prompt
  w_consume:  INV _ReadPtr
  w_parsing:  LDT _ReadPtr                                    ; BYTE-BY-BYTE PARSING OF THE LINE INPUT BUFFER
              CPI "n" FNE w_next1                             ; check for "n"
                MIZ 3,Z5 FPA w_consume
    w_next1:  CPI ":" FNE w_next2                             ; check for ":"
                MIZ 2,Z5 FPA w_consume
    w_next2:  CPI "." FNE w_next3                             ; check for "."
                MIZ 1,Z5 FPA w_consume
    w_next3:  JPS _ReadHex                                    ; check for valid hex value
              CIZ 0xf0,_ReadNum+2 FEQ w_next4
                LDZ Z5                                        ; switch (mode) ...
                CPI 0 FNE w_tmode1
                  MVV _ReadNum,PtrA                           ; ***** MODE 0: SET START ADDRESS
                  FPA w_parsing
      w_tmode1: CPI 1 FNE w_tmode2                            ; print memory list PtrA to _ReadNum
      w_listpage: MIZ 24,Z4                                   ; ***** MODE 1: PRINT MEMORY LIST
      w_listline: MIZ 16,Z3                                   ; init 16-bytes counter
                  JPS w_printaddr                             ; print line start address
      w_nextel:   RDR PtrA JAS _PrintHex                      ; print out memory content (works for FLASH or RAM)
                  CZZ _ReadNum+0,PtrA+0 FNE w_lweiter
                    CZZ _ReadNum+1,PtrA+1 FEQ w_clear         ; END of list
      w_lweiter:      INV PtrA DEZ Z3 FEQ w_linend
                        LL5 FNE w_nextel
                          INZ _XPos FPA w_nextel              ; bug-fix by paulscottrobson Thank you!
      w_linend:       DEZ Z4 FNE w_listline
                        JPS _WaitInput
                        CPI 27 FNE w_listpage
                          FPA w_clear
      w_tmode2: CPI 2 FNE w_mode3
                  LDZ PtrA+2 LL1 BCS w_isram                  ; always write, if (bank & 0x80) = 0x80
                    LDZ PtrA+1 ANI 0xf0 CPI 0 FEQ w_parsing   ; do not write into FLASH
        w_isram:  LDZ _ReadNum+0 STT PtrA                     ; ***** MODE 2: DEPOSIT IN RAM
                  INV PtrA FPA w_parsing
      w_mode3:  MZZ _ReadNum+0,PtrA+2                         ; ***** MODE 3: set BANK register
      w_clear:  CLZ Z5 FPA w_parsing
    w_next4:  CIT 10,_ReadPtr FEQ w_startln                   ; ENTER => read new input
                FPA w_consume                                 ; consume any other char (space, tab, comma, ...)
  w_printaddr:  LDI 10 JAS _PrintChar                         ; start a new line
                LDI "[" JAS _PrintChar                        ; prints start address "[ff|0000] "
                LDZ PtrA+2 JAS _PrintHex
                LDI "|" JAS _PrintChar
                LDZ PtrA+1 JAS _PrintHex
                LDZ PtrA+0 JAS _PrintHex
                LDI "]" JAS _PrintChar INZ _XPos
                RTS

  MonEnd:

; **********************************************************************************************************

0, "                  ", 0, 0x0000, 0x3000-*-2                ; dummy file filling up the rest of bank 0x02
