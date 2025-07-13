; -----------------------------------------------------------
; MIN Programming Language for the 'MINIMAL 64' Home Computer
; original version for the 'Minimal UART CPU'
; written by Carsten Herting (slu4)       10.02.22-31.05.2022
; optimized and ported to the MINIMAL 64  15.09.22-15.11.2022
; tokenized and highly optimized version  21.01.23-11.02.2023
; last functional update                           16.03.2023
; ported to Minimal 64x4                           30.10.2023
; optimized for zero page                          31.01.2024
; optimized for Minimal 64x4 instruction set       13.02.2025
; -----------------------------------------------------------

; LICENSING INFORMATION
; This file is free software: you can redistribute it and/or modify it under the terms of the
; GNU General Public License as published by the Free Software Foundation, either
; version 3 of the License, or (at your option) any later version.
; This file is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the
; implied warranty of MERCHANMBBILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public
; License for more details. You should have received a copy of the GNU General Public License along
; with this program. If not, see https://www.gnu.org/licenses/.

; MIN's MEMORY LAYOUT:
; 0x0100 - 0x0fff   4KB text editor
; ---------------
; 0x1000 - 0x2dff   8KB MIN interpreter incl. MIN global state (64 bytes)
; 0x2e00 - 0x30ff   call dict (255 x 3 bytes)
; 0x3100 - 0x39ff   var dict (255 x 9 bytes)
; 0x3a00 - 0x3f7f   local variables and expressions (1408 bytes)
; 0x3f92 - 0x3fff   use dict (5 x 22 bytes)
; ---------------
; 0x8000 - 0xefff   28KB MIN source file (appended tokenized file is approx. half the source file size)
; ---------------
; 0xf000 - 0xfdff   4KB OS kernel
; 0xfe00 - 0xfe7f   OS save space
; 0xfe80 - 0xfeff   expansion card memory map
; 0xff00 - 0xffff   fast page and stack

; --------------------------------------------------------------------------------------
; MAIN PROCEDURE (FILE LOADER, TOKENIZER, INTERPRETER)
; --------------------------------------------------------------------------------------

#org 0x1000     MIB 0xfe,0xffff                                  ; init stack
                JPS _SkipSpace                                   ; command line: skip spaces after 'min <filename>'
                JPS Loader                                       ; _ReadPtr potentially points to <filename>

                MIW 0xffff,g_stop                                ; set no stop for tokenizer
                JPS Tokenizer                                    ; build tokenized code beyond source code

                MIV firstcall,z_nextcall                         ; init MIN interpreter global state
                MIV firstvar,z_nextvar
                MIV firstsp,z_sp
                MIV firstsp,z_spi INV z_spi
                CLZ z_sub CLZ z_halt CLV z_cnt
                MIZ 0xff,z_tind                                  ; tind will be 0 upon entering the program block
                MVV z_PtrD,z_pc                                  ; point program counter to tokenized prg
                JPS Block                                        ; run program as a Block()

                JPA _Prompt                                      ; return to OS prompt

; ------------------------------------------------------------------------------------------
; Loads <filename> pointed to by _ReadPtr from SSD into address given in PtrD
; <filename> must be terminated by <= 32
; success: returns A=1, _ReadPtr points beyond <filename>, PtrD points beyond loaded data
; failure: returns A=0, _ReadPtr points to <filename>
; modifies: _ReadPtr, PtrA, PtrB, PtrC (by _FindFile), PtrD (D is not modified by _FindFile)
; ------------------------------------------------------------------------------------------
LoadFileTo:     JPS _FindFile CPI 1 BEQ lf_found                 ; PtrA0..2 now points to file in active FLASH
                LDI 0 RTS                                        ; return a failure (file not found)
  lf_found:     AIV 22,z_PtrA JPS _FlashA                        ; search for bytesize of file
                RDR z_PtrA SDZ z_PtrB+0 INV z_PtrA JPS _FlashA   ; bytesize -> PtrB (PtrA now points to data)
                RDR z_PtrA SDZ z_PtrB+1 INV z_PtrA JPS _FlashA
  lf_loadloop:  DEV z_PtrB BCC lf_success                        ; done with copying?
                  RDR z_PtrA SDT z_PtrD                          ; load byte from FLASH, switch FLASH off
                  INV z_PtrD INV z_PtrA JPS _FlashA
                  JPA lf_loadloop
  lf_success:   LDI 1 RTS                                        ; switch off FLASH

; --------------------------------------------------------------------------------------
; ERROR HANDLING (ERROR NUMBER, LINE NUMBER)
; --------------------------------------------------------------------------------------

; Frontend for run-time error handling within the *tokenized* code (finds pos in source)
; Intended to be called via 'JPA Error' and *not* via 'JPS Error'.
; push: errortext_lsb, errortext_msb
; pull: not necessary, exits to _Prompt
Error:          MZB z_pc+0,g_stop+0 MZB z_pc+1,g_stop+1          ; run tokenizer until stop position
                JPS Tokenizer                                    ; now z_pc points at error in source code
                JPA SourceError                                  ; pull A back into A

; Outputs an error text and the current line number corresponding to z_pc within the *source* code
; Intended to be called via 'JPA' and *not* via 'JPS'. Exits to _Prompt with CPU stack reset.
; push: errortext_lsb, errortext_msb
; pull: not necessary, exits to _Prompt
SourceError:    JPS PrintEnter
                LDB srcptr+0 PHS LDB srcptr+1 PHS JPS _PrintPtr PLS PLS ; print filename
                JPS PrintEnter
                JPS _PrintPtr PLS PLS                            ; print specific error text
                JPS _Print ' in line ', 0
                MWV g_line,z_A                                   ; move line number into z_A
                JPS int_tostr                                    ; convert line number in z_A to string
                LDB strptr+0 PHS LDB strptr+1 PHS JPS _PrintPtr PLS PLS ; print line number
                JPS PrintEnter
                ; find and print out erroneous row
                MVV z_pc,z_A                                     ; use z_A as pointer
  se_loop:      DEV z_A CPI >file BNE se_infile                  ; one step back
                  LDZ z_A+0 CPI <file BEQ se_start               ; reached start of file area?
  se_infile:    LDT z_A CPI 10 BNE se_loop
                  INV z_A                                        ; do not show leading RETURN
  se_start:     LDT z_A JAS _PrintChar
                INV z_A CPZ z_pc+1 BCC se_start
                  LDZ z_A+0 CPZ z_pc+0 BCC se_start
                    JPS _Print '??', 10, 0
                    JPA _Prompt                                  ; exit to OS prompt (does stack reset)

  PrintEnter:   LDI 10 JAS _PrintChar RTS

; --------------------------------------------------------------------------------------
; LOADER AND TOKENIZER
; --------------------------------------------------------------------------------------

; -----------------------------------------------------------
; loads filename at _ReadPtr into z_PtrD
; advances z_PtrD and generates an entry to the sources vector
; -----------------------------------------------------------
LoadFile:       MZT z_PtrD+0,z_nextsrc INV z_nextsrc             ; emplace first source addr into sources vector
                MZT z_PtrD+1,z_nextsrc INV z_nextsrc
                MZB z_nextsrc+0,snameptr+0                       ; filename pointer in sources
                MZB z_nextsrc+1,snameptr+1
                MVV _ReadPtr,z_A                                 ; remember filename start
                JPS LoadFileTo                                   ; load filename in _ReadPtr into z_PtrD location
                CPI 1 BEQ foundfile                              ; file found? -> run now with file loaded
                  JPS _Print 'Not found: ', 0
  nameerrloop:    LDR _ReadPtr CPI 33 BCC returnchar
                    CPI '"' BEQ returnchar
                      JAS _PrintChar
                      INV _ReadPtr JPA nameerrloop
  returnchar:      LDI 10 JAS _PrintChar
                  JPA _Prompt
  foundfile:    LDZ _ReadPtr+0 SUZ z_A+0 SDZ z_B+0               ; calc filename byte count -> z_B+0
  snameloop:    DEZ z_B+0 BCC finalizesrc                        ; some filename chars to write?
                  MTB z_A,                                       ; copy filename into sources vector
  snameptr:       0xcccc
                  INV z_A INW snameptr JPA snameloop
  finalizesrc:  MIR 0,snameptr                                   ; finalize the name in sources
                AIV 20,z_nextsrc                                 ; finalize sources entry
                RTS

Loader:         MIV firstsrc,z_nextsrc                           ; init sources vector
                MIV file,z_PtrD                                  ; init z_PtrD (points beyond last source file)
                MIV file, z_pc                                   ; init z_pc (used by Loader to parse for use ...)
                LDR _ReadPtr CPI 33 BCS appendfile               ; load first source from commandline or use text?
                  MIT <file,z_nextsrc INV z_nextsrc              ; emplace first source addr into sources vector
                  MIT >file,z_nextsrc INV z_nextsrc
                  MIT 0,z_nextsrc                                ; null name in sources
                  AIV 20,z_nextsrc                               ; finalize sources entry
    dst_loop:     LDT z_PtrD CPI 0 BEQ found_zero                ; look for 0 in source file
                    INV z_PtrD JPA dst_loop
    found_zero:  INV z_PtrD JPA loader_while                     ; z_PtrD now points beyond source file
  appendfile:    JPS LoadFile

                ; scan for more files to use
  loader_while: LDZ z_pc+1 CPZ z_PtrD+1 BCC loader_loop BGT loader_rts
                  LDZ z_pc+0 CPZ z_PtrD+0 BCS loader_rts
  loader_loop:      LDT z_pc CPI 'u' BEQ loader_use
    loader_not:        INV z_pc JPA loader_while                 ; else z_pc++
    loader_use:     INV z_pc LDT z_pc CPI 's' BNE loader_not
                      INV z_pc LDT z_pc CPI 'e' BNE loader_not
                        INV z_pc JPS Next LDT z_pc CPI '"' BNE loader_not
                          INV z_pc LDZ z_nextsrc+1 CPI >endsrc BCS loader_full
                            MVV z_pc,_ReadPtr
                            JPS LoadFile
                            MVV _ReadPtr,z_pc
                            JPA loader_while
  loader_full:  JPS _Print 'Use max 5 files.', 10, 0
                JPA _Prompt
  loader_rts:   RTS

Tokenizer:      CLB vid CLB cid                                  ; start var and call tokens from 0
                MZB z_PtrD+0,dst+0 MZB z_PtrD+1,dst+1            ; set dst as working destination pointer
                MIW newitems,itnext                              ; top end of tokenizer items (keywords, vars, calls) points beyond keyword items
                MZB z_nextsrc+1,srcptr+1
                MZB z_nextsrc+0,srcptr+0
                AIW 2,srcptr                                     ; go up to ->name

  t_srcwhile:   SIW 24,srcptr                                    ; go down to last src->ptr
                LDB srcptr+0 CPI <firstsrc BCC t_endreached      ; is this still a valid entry?
                  MRZ srcptr,z_pc+0 INW srcptr                   ; extract ->ptr to source code
                  MRZ srcptr,z_pc+1 INW srcptr                   ; srcptr now points to filename (for error)
                  MIB 1,g_line+0 CLB g_line+1                    ; set line number to 1

  t_while:      JPS Look CPI 0 BEQ t_srcwhile                    ; get next char (ignoring #...)

                  LDT z_pc CPI 'u' BNE t_measure                 ; overlook 'use ...' commands
                    LDZ z_pc+0 PHS LDZ z_pc+1 PHS                ; push current PC
                    INV z_pc LDT z_pc CPI 's' BNE t_pcback
                      INV z_pc LDT z_pc CPI 'e' BNE t_pcback
                        INV z_pc JPS Next
                        LDT z_pc CPI '"' BNE t_pcback            ; now we have found a "...
    t_eatname:            INV z_pc LDT z_pc CPI 0 BEQ t_pcback
                            CPI 10 BEQ t_pcback
                              CPI '"' BNE t_eatname
                                INV z_pc JPS Next                ; skip potential spaces until end of line
                                JPA t_pckeep

    t_pcback:     PLS SDZ z_pc+1 PLS SDZ z_pc+0 JPA t_measure    ; go back to u...
    t_pckeep:       PLS PLS
    t_measure:    CLB ind                                        ; measure indentation
    t_indloop:    JPS Look CPI ' ' BEQ t_indent                  ; SPACE +1
                    CPI 9 BNE t_inddone                          ; MBB +2
                    INB ind
      t_indent:   INB ind INV z_pc JPA t_indloop                 ; count indent, consume and look for more indent
      t_inddone:  LDB ind LR1 BCS t_inderror                     ; uneven spaces = error
                    CPI 30 FLE t_indokay                         ; indent <= 30?
      t_inderror: LDI <error11 PHS LDI >error11 PHS JPA SourceError ; error invalid indent
      t_indokay:  NOT DEC SDB ind                                ; code indentation range -1..30 -> 0xff..0xe0

                  JPS Next CPI 0 BEQ t_srcwhile                  ; break if EOF

                  LDT z_pc CPI 10 BNE t_notenter                 ; is this a non-empty line?
                    INW g_line INV z_pc JPA t_while              ; else move over \n without copy, count \n & continue

                                                                 ; START OF NON_EMPTY LINE
    t_notenter:    MBR ind,dst INW dst                           ; write indentation marker

                                                                 ; START OF LINE PROCESSING

    t_lineloop:   LDI '0' PHS LDI 'x' PHS JPS TakeTwo PLS PLS    ; HEX: 0x = 0x0 = 0x00 = 0x000 = 0x0000 will mean zero
                  CPI 0 BEQ t_next0
                    CLV z_A CLZ z_B                              ; use z_A for result, z_B for counting digits
      t_getchar:    LDT z_pc                                     ; input lesen
                    CPI 'f' BGT t_writeconst                     ; above f?
                    CPI 'a' BCS t_hxletter                       ; a..f?
                    CPI '9' BGT t_writeconst                     ; above 9?
                    CPI '0' BCS t_hxzahl                         ; 0..9?
                      JPA t_writeconst
      t_hxletter:     SUI 39                                     ; 39 + 48 = 97 = 'a'
      t_hxzahl:       SUI 48                                     ; 48 = '0'
                    PHS INZ z_B
                    LLV z_A LLV z_A LLV z_A LLV z_A              ; shift up 4 bits
                    PLS AD.Z z_A+0 INV z_pc JPA t_getchar        ; add new hex nibble (carry cannot happen)

      t_next0:    LDI '+' PHS LDI '=' PHS JPS TakeTwo PLS PLS
                  CPI 0 BEQ t_nexta LDI 'a' JPA t_puttoken       ; fast increment
      t_nexta:    LDI '-' PHS LDI '=' PHS JPS TakeTwo PLS PLS
                  CPI 0 BEQ t_next1 LDI 's' JPA t_puttoken       ; fast decrement
      t_next1:    LDI '=' PHS LDI '=' PHS JPS TakeTwo PLS PLS
                  CPI 0 BEQ t_next2 LDI 0xd3 JPA t_puttoken
      t_next2:    LDI '!' PHS LDI '=' PHS JPS TakeTwo PLS PLS
                  CPI 0 BEQ t_next3 LDI 0xd4 JPA t_puttoken
      t_next3:    LDI '<' PHS LDI '<' PHS JPS TakeTwo PLS PLS
                  CPI 0 BEQ t_next4 LDI 0xdd JPA t_puttoken
      t_next4:    LDI '<' PHS LDI '=' PHS JPS TakeTwo PLS PLS
                  CPI 0 BEQ t_next5 LDI 0xd5 JPA t_puttoken
      t_next5:    LDI '>' PHS LDI '>' PHS JPS TakeTwo PLS PLS
                  CPI 0 BEQ t_next6 LDI 0xde JPA t_puttoken
      t_next6:    LDI '>' PHS LDI '=' PHS JPS TakeTwo PLS PLS
                  CPI 0 BEQ t_next7 LDI 0xd6 JPA t_puttoken

      t_next7:    LDT z_pc                                       ; look at single source char instead
                  CPI '<' BNE t_next8 INV z_pc LDI 0xd2 JPA t_puttoken
      t_next8:    CPI '>' BNE t_next9 INV z_pc LDI 0xd7 JPA t_puttoken

      t_next9:    CPI '"' BNE t_next10                           ; "STRING"
                    SDR dst INW dst INV z_pc                     ; write and consume "
        t_string:    LDT z_pc CPI '"' BEQ t_strclose             ; close and consume "
                      CPI 0 BEQ t_strbail CPI 10 BEQ t_strbail   ; close without consuming on 0 and 10
                        JPS TakeOrd SDR dst INW dst              ; consume and store (special) char
                        JPA t_string
        t_strclose:    INV z_pc                                  ; consume source char
        t_strbail:    MIR '"',dst INW dst JPA t_stopcheck

      t_next10:   CPI '0' BCC t_next11 CPI '9' FGT t_next11      ; DEC: CHECK FOR DIGIT 0-9
                    CLV z_A
      t_digloop:    LLV z_A SDZ z_B+1 MZZ z_A+0,z_B+0            ; A x 2 -> B
                    LLV z_A LLV z_A                              ; A x 8
                    LDZ z_B+1 AD.Z z_A+1 LDZ z_B+0 ADV z_A       ; A -> A x 10
                    LDT z_pc SUI '0' ADV z_A INV z_pc            ; reload, add & consume the digit
                    LDT z_pc CPI '0' BCC t_writeconst
                      CPI '9' FLE t_digloop                      ; read next digit 0-9

      t_writeconst:       MIR 0xd0,dst INW dst                   ; ... write word TN_CONST
                          MZR z_A+0,dst INW dst
                          MZR z_A+1,dst INW dst
                          JPA t_stopcheck

      t_next11:   CPI ',' BNE t_next12 INV z_pc JPA t_continue   ; omit these characters, stop check not needed
      t_next12:   CPI ';' BNE t_next13 INV z_pc JPA t_continue
      t_next13:   CPI ':' BNE t_next14 INV z_pc JPA t_continue

      t_next14:   JPS TakeAlNum CPI 0 BEQ t_else                 ; reads AlNum into itnext using alptr
                    CPI 14 BCC t_alnumok
                      LDI <error01 PHS LDI >error01 PHS JPA SourceError ; string too long => error invalid var/call
        t_alnumok:  MIW items,itptr                              ; point at start of items dictionary

          t_alloop: MBB itptr+0,strcmp_a+0 MBB itptr+1,strcmp_a+1 ; vgl. string @ itptr mit string @ itnext
                    MBB itnext+0,strcmp_b+0 MBB itnext+1,strcmp_b+1
                    JPS strcmp CPI 0 BEQ t_alentry               ; found? itptr then points to that entry
                      LDI 16 ADW itptr CPB itnext+1 BNE t_alloop ; no match => check next entry
                        LDB itptr+0 CPB itnext+0 BNE t_alloop
                          LDI 14 ADW itnext                      ; reached itptr == itnext, keep name
                          JPS Next CPI '(' BNE t_variable        ; END REACHED w/o match: make it a new item
                            MIR 'S',itnext INW itnext            ; write call
                            MBR cid,itnext INW itnext            ; itnext points to free item now
                            INB cid JPA t_idcheck
          t_variable:      MIR 'V',itnext INW itnext
                          MBR vid,itnext INW itnext              ; itnext points to free item now
                          INB vid
          t_idcheck:      CPI 0xe0 BCC t_alentry                 ; don't let these numbers be confused with indents
                            LDI <error07 PHS LDI >error07 PHS JPA SourceError ; error too many tokens
      t_alentry:    LDI 14 ADW itptr                             ; itptr points to start of relevant entry
                    MRR itptr,dst INW itptr INW dst              ; write token
                    LDR itptr CPI 0xff BEQ t_stopcheck           ; do not store invalid ID (as used for keywords)
                      JPA t_puttoken                             ; and write id != 0xff

      t_else:      LDT z_pc PHS INV z_pc PLS                     ; else *dst++ = *z_pc++ write anything else

    t_puttoken:   SDR dst INW dst                                ; DO THE STOP CHECK IN ANY CASE
    t_stopcheck:  LDB dst+1 CPB g_stop+1                         ; if (dst >= stop) return;
                  BCC t_continue FGT t_rts
                    LDB dst+0 CPB g_stop+0 BCS t_rts             ; MSBs are equal

    t_continue:   JPS Next
                  CPI 10 BEQ t_while CPI 0 BEQ t_while           ; line ends?
                    JPA t_lineloop                               ; line goes on

  t_endreached: MIR 0xff,dst
  t_rts:        RTS

  srcptr:       0xffff                                           ; pointer into sources dict (vector)
  itnext:       0xffff                                           ; init to beyond keywords
  itptr:        0xffff                                           ; used as item search pointer
  ind:          0xff                                             ; measured indentation
  dst:          0xffff                                           ; destination (write) pointer
  vid:          0xff                                             ; ids of var and call identifiers
  cid:          0xff

; compares string at 'strcmp_b' and 'strcmp_a' for equality
; returns: A=0: equal, A=1: not equal
strcmp:         LDB
  strcmp_b:     0xffff
                CPB
  strcmp_a:      0xffff                                          ; self-modifying code
                FNE strcmpfalse CPI 0 FEQ strcmpexit
                  INW strcmp_a INW strcmp_b
                  FPA strcmp
  strcmpfalse:  LDI 1
  strcmpexit:   RTS

#page

; takes (specical) character including '\n' or '\e', returns result in A
; NOTE: 0, 10 and " have to be checked before!
TakeOrd:        LDT z_pc CPI '\' FNE takeordret
                  INV z_pc LDT z_pc                              ; look at next character
                  CPI 0 FEQ takeordexit CPI 10 FEQ takeordexit   ; exit without consuming 0 or \n
  takeo0:            CPI 'r' FNE takeo1 LDI 13 FPA takeordret
  takeo1:            CPI 'n' FNE takeo2 LDI 10 FPA takeordret
  takeo2:            CPI 't' FNE takeo3 LDI 9 FPA takeordret
  takeo3:            CPI 'e' FNE takeo4 LDI 27 FPA takeordret
  takeo4:            CPI '0' FNE takeordret LDI 0
  takeordret:      PHS INV z_pc PLS RTS
  takeordexit:   LDI '\' RTS

; returns in A the next non-shite-space character including '\0' and '\n' but omitting # comments
; modifies: z_pc
Next:           JPS Look
                CPI ' ' FEQ nexttake                             ; ' '
                  CPI 9 FEQ nexttake                             ; '\t'
                    CPI 13 FEQ nexttake                          ; '\r'
                      RTS
  nexttake:     INV z_pc FPA Next

; Takes two consecutive chars if matching (result = 1), else result = 0
; push: first char, second char
; pull #, result
TakeTwo:        LDS 4 CPT z_pc FNE firstfalse
                  INV z_pc
                  LDS 3 CPT z_pc FNE secondfalse
                    INV z_pc LDI 1 SDS 4 RTS
  secondfalse:  DEV z_pc                                         ; move back again
  firstfalse:   LDI 0 SDS 4 RTS                                  ; return false

; --------------------------------------------------------------------------------------
; TOKENIZER PARSING ROUTINES
; --------------------------------------------------------------------------------------

; takes an alnum into 'itnext' position
; 'alptr' then points beyond the zero-termination, stores length in 'alcount' and A
TakeAlNum:      MBB itnext+0,alptr+0 MBB itnext+1,alptr+1        ; init alptr
                CLB alcount LDT z_pc                             ; first char needs no be an alpha
                CPI 'z' FGT takeaout                             ; one above 'z'
                CPI 'a' FCS takeisa
                CPI 'Z' FGT takeaout                             ; one above 'Z'
                CPI 'A' FCC takeaout
  takeisa:        SDR alptr INW alptr INV z_pc INB alcount       ; store the char and continue
  takeanloop:     LDT z_pc                                       ; consecutive chars
                CPI 'z' FGT takeaout
                CPI 'a' FCS takeisa
                CPI 'Z' FGT takeaout
                CPI 'A' FCS takeisa
                CPI '9' FGT takeaout                             ; one above '9'
                CPI '0' FCS takeisa
  takeaout:       MIR 0,alptr INW alptr
                  LDB alcount RTS                                ; set null termination

  alcount:      0x00
  alptr:        0x0000

; returns current character in A including '\0' and '\n' but omitting any # comments
; modifies: z_pc
Look:           LDT z_pc CPI '#' FNE lookexit                    ; returns next character, ignores comments
  lookcomment:    INV z_pc LDT z_pc
                  CPI 0 FEQ lookexit                             ; ENDMARKER
                  CPI 10 FNE lookcomment                         ; NEWLINE
  lookexit:     RTS

; --------------------------------------------------------------------------------------
; 16-BIT MATH LIBRARY
; --------------------------------------------------------------------------------------

int_lsr:        LDZ z_B+0 CPI 0 FEQ intlsrdone
                  FPL intlsrpos
                    NEG FPA intlslpos
  intlsrpos:      SDZ z_count
  intlsrloop:     LRZ z_A+1 RRZ z_A+0
                  DEZ z_count FGT intlsrloop
  intlsrdone:       RTS

int_lsl:        LDZ z_B+0 CPI 0 FEQ intlsldone
                  FPL intlslpos
                    NEG FPA intlsrpos
  intlslpos:      SDZ z_count
  intlslloop:      LLV z_A DEZ z_count FGT intlslloop
  intlsldone:        RTS

; strptr points to a null-terminated string
; modifies: z_C
int_tostr:      CLB int_str                                      ; PRINT A 16-BIT REGISTER AS DEC NUMBER
                MVV z_A,z_C                                      ; copy A to working reg C so A remains unchanged
                RL1 FCC int_notneg
                  NEV z_C MIB '-',int_str                        ; negative sign
  int_notneg:   MIW int_str+5,strptr                             ; point to last digit of output string
  int_start:    CLZ z_C+2                                        ; clear upper register and carry store
                MIZ 16,z_count
  int_shift:    LDZ z_C+2 RL1                                    ; activate C stored in bit 7 (initially = 0)
                RLV z_C RLZ z_C+2                                ; shift C back in and shift everything one step left
                CPI 10 FCC int_done                              ; 10 did not fit in => do not set bit 7 as carry
                  ADI 118 SDZ z_C+2                              ; 10 went into it => subtract 10 and set bit 7 as carry (-10 +128)
  int_done:     DEZ z_count FNE int_shift
                  LDZ z_C+2 ANI 0x7f                             ; erase a possible stored carry
                  ADI '0' SDR strptr DEW strptr                  ; store remainder as char
                  LDZ z_C+2 RL1                                  ; restore stored carry flag
                  RLV z_C                                        ; shift in C and shift everything one step up
                  RLZ z_C+2                                      ; shift C into 'remember' and shift an old carry out
                  LDI 0 CPZ z_C+0 FNE int_start                  ; prüfe nach, ob big register null enthält
                    CPZ z_C+1 FNE int_start
                      LDB int_str CPI '-' FNE int_out
                        SDR strptr RTS
  int_out:            INW strptr RTS
  int_str:      '-32768', 0
  strptr:        0x0000

int_div:        CLZ z_flag                                       ; clear the sign byte
                LDZ z_A+1 CPI 0 FPL divanotneg                   ; make A and B positive, evaluate the sign of result
                  INZ z_flag NEV z_A                             ; store a sign, negate A                  ;
  divanotneg:   LDZ z_B+1 CPI 0 FPL divbnotneg
                  INZ z_flag NEV z_B                             ; store a(nother) sign, negate B
  divbnotneg:    MZZ z_B+0,z_B+1 CLZ z_B+0                       ; move the lower half of B to upper half, clear lower half
                CLV z_D                                          ; clear result E
                MIZ 8,z_count                                    ; pre-init the shiftcounter (needs modification below)
  divup:        LDZ z_B+1 LL1 FMI divloop                        ; ist oberstes bit vom B schon 'ganz oben'?
                  SDZ z_B+1 INZ z_count FPA divup                ; increase number of shifts and shift upper B one step up
  divloop:      MVV z_A,z_C                                      ; copy A to C
                LDZ z_B+0 SUV z_A+0 FCC divcarry0 SZZ z_B+1,z_A+1 FCS divresult ; A = A - B (B fits in A => shift '1' into E)
  divcarry0:      MVV z_C,z_A                                    ; restore A from C (B does not fit in A => shift '0' into E)
  divresult:    RLV z_D                                          ; E = E<<1 | C (1: B fit in A, 0: B does not fit into A)
                LRZ z_B+1 RRZ z_B+0                              ; shift B one step down
                DEZ z_count FCS divloop
                  MVV z_D,z_A                                    ; move result back into A
                  LDZ z_flag LR1 FCC divallnotneg
                    NEV z_A
  divallnotneg:    RTS

int_mul:        MVV z_A,z_C                                      ; copy A factor into C (C will be shifted right)
                CLV z_A
                MIZ 16,z_count
  multloop:     RRZ z_C+1 RRZ z_C+0                              ; shift C one step right, lowest bit is now in carry flag
                FCC multbitoff
                  AVV z_B,z_A                                    ; adds current B to accumulator A
  multbitoff:   LLV z_B                                          ; increase the value of B with shift left one step left
                DEZ z_count FNE multloop
                  RTS

; ------------------------------------------------------------------------------------------------
; INTERPRETER: SUPPORTING FUNCTIONS
; ------------------------------------------------------------------------------------------------

; Reads an element of the math stack (int or char -> int, depending on z_type) into z_A
get:            CIZ 2,z_type FEQ getint
                  MTZ z_sp,z_A+0                                 ; load char and cast to int in C-style
                  LL1 FCS getminus
                    CLZ z_A+1 RTS
  getminus:        MIZ 0xff,z_A+1 RTS
  getint:       MTZ z_sp,z_A+0                                   ; load int
                MTZ z_spi,z_A+1
                RTS

; Reads an element of the math stack (int or char -> int, depending on z_type) into z_B
getB:           CIZ 2,z_type FEQ getBint
                  MTZ z_sp,z_B+0                                 ; load char and cast to int in C-style
                  LL1 FCS getBminus
                    CLZ z_B+1 RTS
  getBminus:      MIZ 0xff,z_B+1 RTS
  getBint:      MTZ z_sp,z_B+0                                   ; load int
                MTZ z_spi,z_B+1
                RTS

; Put z_A as single-element value on math stack. Requires 'z_type' to be set to desired type.
put:            CLZ z_cnt+1 MIZ 1,z_cnt+0                        ; set element count to one in any case
                CPZ z_type FEQ putchar
                  MZT z_A+1,z_spi                                ; store single int
  putchar:      MZT z_A+0,z_sp
                RTS

; Enforces that a specific char is consumed, throws an error otherwise
AssertCSquare:  LDT z_pc CPI ']' FEQ asstrue
                  LDI <error30 PHS LDI >error30 PHS JPA Error
AssertORound:   LDT z_pc CPI '(' FEQ asstrue
                  LDI <error31 PHS LDI >error31 PHS JPA Error
AssertCRound:   LDT z_pc CPI ')' FEQ asstrue
                  LDI <error32 PHS LDI >error32 PHS JPA Error
AssertEquals:   LDT z_pc CPI '=' FEQ asstrue
                  LDI <error33 PHS LDI >error33 PHS JPA Error
  asstrue:      INV z_pc RTS

; skips code until indentation <= target indentation or ENDMARKER is reached
  gotadvance:   INV z_pc
SkipStmt:       CIT 0xe0,z_pc FCS gotindent                  ; move over current line until next indent is found
                  CPI 0xd0 FNE gotadvance
                    AIV 3,z_pc FPA SkipStmt                      ; hop over numbers like 254 that might look like fake indent
  gotindent:    NOT DEC SDZ z_mind INV z_pc                      ; leaves with MEASURED and consumed indentation
                CZZ z_mind,z_tind FMI SkipStmt
                RTS

; --------------------------------------------------------------------------------------
; CALL AND VAR HANDLER
; --------------------------------------------------------------------------------------

; Search var dictionary for *latest* match. Returns pointer to variable *type* data.
; push: #, var_id
; pull: var_msb, var_lsb
getVar:         MVV z_nextvar,z_getptr                           ; copy var top ptr
  varnext:      SIV 9,z_getptr                                   ; move down one var
                CPI >firstvar FCS varokay                        ; MSB below start of var dict? -> end search
  varerror:       LDI <error01 PHS LDI >error01 PHS JPA Error    ; error undefined var
  varokay:      LDS 3 CPT z_getptr FNE varnext                     ; matching ID?
                  INV z_getptr CZT z_sub,z_getptr FEQ var_ok   ; advance to vp->sub
                    CPI 0xff FEQ var_ok                          ; check for global
                      SIV 10,z_getptr                              ; not the right sub level => down one var
                      CPI >firstvar FCS varokay
                        FPA varerror
  var_ok:       INV z_getptr                                       ; advance to ->type data
                SDS 3 LDZ z_getptr+0 SDS 4                         ; put var ptr to type on stack
                RTS

; search call dictionary for *latest* match
; push: #, call_id
; pull: pc_msb, pc_lsb
getCall:        MVV z_nextcall,z_getptr                           ; copy call top ptr
  callnext:     SIV 3,z_getptr                                     ; move down one call
                CPI >firstcall FCS callokay                      ; stop below first call
                  LDI <error01 PHS LDI >error01 PHS JPA Error    ; error undefined call
  callokay:     LDS 3 CPT z_getptr FNE callnext
                  INV z_getptr LDT z_getptr SDS 4                 ; put call jump address on stack
                  INV z_getptr LDT z_getptr SDS 3
                  RTS

; --------------------------------------------------------------------------------------
; EXPRESSIONS
; --------------------------------------------------------------------------------------

#page

Factor:         CLZ z_refset LDT z_pc                            ; use default referenced element size 1

                CPI 0xd0 FNE fac_next2                           ; TN_INT_CONST
                  INV z_pc MIZ 2,z_type
                  MIZ 1,z_cnt+0 CLZ z_cnt+1                      ; single int
                  MTT z_pc,z_sp INV z_pc
                  MTT z_pc,z_spi INV z_pc
                  RTS

fac_next2:      CPI '&' FNE fac_next3                            ; VARIABLE
                  PHS INV z_pc                                   ; push & consume '&'
                  LDT z_pc CPI 'V' FEQ fac_isvar
                    LDI <error05 PHS LDI >error05 PHS JPA Error  ; error Invalid expression
fac_next3:      CPI 'V' BNE fac_next4
                  PHS                                            ; push 'V'
  fac_isvar:      INV z_pc                                       ; consume, either 'V' or '&' was pushed above
                  LDT z_pc PHS PHS INV z_pc JPS getVar           ; get & consume variable ID, push v->type on stack
                  PLS SDB facptr+1 PLS SDB facptr+0              ; load var item onto stack:
                  LDR facptr PHS INW facptr                      ; ->type
                  LDR facptr PHS INW facptr LDR facptr PHS INW facptr ; ->cnt
                  LDR facptr PHS INW facptr LDR facptr PHS       ; ->ptr
                  LDT z_pc CPI '[' BNE fac_fullvar               ; [|] OPERATOR PRESENT?

                    ; PARSE [|] OPERATOR
                    INW facptr LDR facptr PHS INW facptr LDR facptr PHS ; ->max is also needed
                    LDI 0 PHS PHS LDS 8 PHS LDS 8 PHS            ; push start, anz = ->cnt
                    INV z_pc LDT z_pc CPI '|' FNE fac_nopipe     ; consume [, parse for |
                      INV z_pc LDT z_pc CPI ']' BEQ fac_closed
                        JPS Expr JPS get
                        LDZ z_A+0 SDS 2 LDZ z_A+1 SDS 1          ; set anz
                        LL1 BCC fac_closed                       ; anz < 0 => error
                          JPA fac_error
  fac_nopipe:        JPS Expr JPS get
                    LDZ z_A+0 SDS 4 LDZ z_A+1 SDS 3              ; set start
                    LL1 BCS fac_error                            ; start < 0 => error
                      LDT z_pc CPI '|' BNE fac_nopipe2
                        INV z_pc LDT z_pc CPI ']' FNE fac_else
                          LDS 1 SDZ z_A+1 LDS 2 SDZ z_A+0
                          LDS 3 SU.Z z_A+1 LDS 4 SUV z_A
                          LDZ z_A+0 SDS 2 LDZ z_A+1 SDS 1
                          LL1 BCC fac_closed                     ; anz = anz - start < 0 => error
                            JPA fac_error
      fac_else:          JPS Expr JPS get
                          LDS 3 SU.Z z_A+1 LDS 4 SUV z_A
                          LDZ z_A+0 SDS 2 LDZ z_A+1 SDS 1
                          LL1 FCC fac_closed                     ; anz = end - start < 0 => error
                            JPA fac_error
    fac_nopipe2:      LDI 1 SDS 2 LDI 0 SDS 1                    ; set anz = 1
  fac_closed:         JPS AssertCSquare
                    LDS 5 SDZ z_A+1 LL1 FCS fac_passed           ; z_A = ->max, ->max = 0xffff means ignore test
                      LDS 6 SDZ z_A+0
                      LDS 1 SU.Z z_A+1 LDS 2 SUV z_A LL1 BCS fac_error ; ->max - (start + anz) < 0 => error
                      LDS 3 SU.Z z_A+1 LDS 4 SUV z_A LL1 BCS fac_error

                  ; copies variable elements onto the math stack
    fac_passed:    LDS 12 CPI '&' FEQ fac_elemref                ; ELEMENTS [|] OF VARIABLE
                    LDS 11 SDZ z_type                            ; z_type = vp->type
                    LDS 2 SDZ z_A+0 SDZ z_cnt+0
                    LDS 1 SDZ z_A+1 SDZ z_cnt+1                  ; z_A = anz, z_cnt = anz
                    LDS 4 SDZ z_B+0 LDS 3 SDZ z_B+1              ; z_B = startindex
                    LDZ z_type CPI 1 FEQ fac_elembyte
                      LLV z_B LLV z_A                            ; int type: x2 startindex, count now bytesize
    fac_elembyte:   LDS 8 SDB fac_src0+0 LDS 7 SDB fac_src0+1    ; source address = ->ptr + startindex * ->type
                    LDZ z_B+1 AD.B fac_src0+1 LDZ z_B+0 ADW fac_src0
                    MZB z_sp+0,fac_dst0+0 MZB z_sp+1,fac_dst0+1  ; z_sp = destination
    fac_loop0:      DEV z_A FCC fac_endelem
                      LDB
    fac_src0:          0xffff SDB
    fac_dst0:          0xffff INW fac_src0 INW fac_dst0 FPA fac_loop0
    fac_endelem:    MIR 0,fac_dst0                               ; write zero-termination byte
                    LDB fac_dst0+1 CPI >endsp FCC fac_elemrts    ; MATH MEMORY CHECK SINGLE FACTOR
      memerror:        LDI <error08 PHS LDI >error08 PHS JPA Error ; error out of memory
  fac_elemref:    MIZ 2,z_type MIZ 1,z_refset                    ; ELEMENT REFERENCE
                  LDS 3 SDZ z_B+1 LDS 4 SDZ z_B+0                ; start -> z_B
                  LDS 11 CPI 1 FEQ fac_char                      ; ->type = char?
                    LLV z_B                                      ; start x 2 wg. int
    fac_char:     LDS 8 ADV z_B LDS 7 AD.Z z_B+1                 ; add vp->ptr to z_B
                  LDS 2 SDZ z_refcnt+0 LDS 1 SDZ z_refcnt+1      ; store anz
    fac_elemrts:  LDI 12 AD.B 0xffff RTS

                  ; copies the full variable onto the math stack (faster)
  fac_fullvar:    LDS 6 CPI '&' BEQ fac_fullref                  ; FULL VAR
                    LDS 4 SDZ z_cnt+0 SDZ z_A+0                  ; set z_cnt, use z_A as byte counter
                    LDS 3 SDZ z_cnt+1 SDZ z_A+1
    fac_nosingle:    LDS 5 SDZ z_type CPI 1 FEQ fac_fullchar     ; set z_type
                      LLV z_A                                    ; x2 wg. int
    fac_fullchar:   LDS 2 SDB fac_src+0 LDS 1 SDB fac_src+1      ; set src data pointer
                    MZB z_sp+0,fac_dst+0 MZB z_sp+1,fac_dst+1    ; set dst to top of math stack
    fac_loop:        DEV z_A FCC fac_endfull
                      LDB
    fac_src:          0xffff SDB
    fac_dst:          0xffff INW fac_src INW fac_dst FPA fac_loop
    fac_endfull:    MIR 0,fac_dst                                ; always write 0-termination into stack memory
                    LDB fac_dst+1 CPI >endsp FCC fac_fullrts     ; MATH MEMORY CHECK SINGLE FACTOR
                      JPA memerror
  fac_fullref:    MIZ 2,z_type                                   ; FULL REFERENCE
                  MIZ 1,z_refset SDZ z_cnt+0 CLZ z_cnt+1         ; set type=2, cnt=1
                  LDS 4 SDZ z_refcnt+0 LDS 3 SDZ z_refcnt+1      ; ->cnt to z_refcnt, z_refset=1
                  LDS 2 SDT z_sp LDS 1 SDT z_spi                 ; put ->ptr onto math stack
    fac_fullrts:  LDI 6 AD.B 0xffff RTS

fac_next4:      CPI '"' FNE fac_next5                            ; ".." STRING
                  INV z_pc MIZ 1,z_type CLV z_cnt
                  MZB z_sp+0,fac_p+0 MZB z_sp+1,fac_p+1
  fac_while:      LDT z_pc CPI '"' FEQ fac_endstr
                    SDB
  fac_p:            0xffff INV z_pc INW fac_p INV z_cnt FPA fac_while
  fac_endstr:     MIR 0,fac_p                                    ; write 0-termination byte
                  LDB fac_p+1 CPI >endsp BCS memerror            ; MATH MEMORY CHECK SINGLE FACTOR
                  INV z_pc RTS                                   ; consume "

fac_next5:      CPI 'S' FNE fac_next6                            ; FUNCTION
                  INV z_pc LDT z_pc PHS PHS INV z_pc             ; consume and push ID & container
                  JPS getCall JPS FunctionCall PLS PLS           ; ID -> getCall -> call pc -> function call
                  RTS

fac_next6:      CPI '(' FNE fac_error                            ; (..) EXPRESSION
                  INV z_pc JPS Expr JPS AssertCRound
                  RTS

fac_error:      LDI <error05 PHS LDI >error05 PHS JPA Error      ; error Invalid expr

facptr:          0xffff

; -------------------------------------------------------------------

#page

Term:            JPS Factor
  term_while:    LDT z_pc CPI '*' FEQ term_mult
                  CPI '/' FNE term_rts
                    INV z_pc                                     ; consume /
                    JPS get LDZ z_A+0 PHS LDZ z_A+1 PHS          ; push A
                    JPS Factor JPS getB                          ; get into z_B
                    LDZ z_B+0 ORZ z_B+1 CPI 0 FNE term_okay
                      LDI <error22 PHS LDI >error22 PHS JPA Error ; error divide by 0
    term_okay:      PLS SDZ z_A+1 PLS SDZ z_A+0                  ; pull A
                    JPS int_div FPA term_reuse
  term_mult:    INV z_pc                                         ; consume *
                JPS get LDZ z_A+0 PHS LDZ z_A+1 PHS              ; push A
                JPS Factor JPS getB
                PLS SDZ z_A+1 PLS SDZ z_A+0                      ; pull A
                JPS int_mul
    term_reuse: MZT z_A+0,z_sp MZT z_A+1,z_spi                   ; store result as int
                CLZ z_refset MIZ 2,z_type
                CLZ z_cnt+1 MIZ 1,z_cnt+0
                JPA term_while
  term_rts:      RTS

; -------------------------------------------------------------------

BaseExpr:       LDT z_pc CPI '-' FEQ base_minus
                  JPS Term FPA base_while
  base_minus:   INV z_pc                                         ; consume -
                JPS Term JPS get NEV z_A
  base_reuse:   SDT z_spi MZT z_A+0,z_sp                         ; assumes MSB already in A
                CLZ z_refset MIZ 2,z_type
                CLZ z_cnt+1 MIZ 1,z_cnt+0
  base_while:   LDT z_pc CPI '+' FEQ base_plus
                  CPI '-' FNE base_rts
                    INV z_pc                                     ; consume '-'
                    JPS get LDZ z_A+1 PHS LDZ z_A+0 PHS          ; push A reversed here
                    JPS Term JPS get NEV z_A                     ; -b
                    PLS ADV z_A+0 PLS AD.Z z_A+1                 ; a = a+(-b)
                    JPA base_reuse
    base_plus:  INV z_pc                                         ; consume '+'
                JPS get LDZ z_A+1 PHS LDZ z_A+0 PHS              ; push A reversed here
                JPS Term JPS get
                PLS ADV z_A+0 PLS AD.Z z_A+1                     ; a = a+b
                JPA base_reuse
  base_rts:     RTS

; -------------------------------------------------------------------

#page

; handle relational operators <, ==, !=, <=, >=, >
RelExpr:        JPS BaseExpr
  rele_while:   LDT z_pc CPI 0xd2 FCC rele_rts FNE rele_eq       ; a < b <=> a+(-b) < 0
                  INV z_pc JPS get
                  LDZ z_A+0 PHS LDZ z_A+1 PHS
                  JPS BaseExpr JPS getB NEV z_B
                  PLS AD.Z z_B+1 PLS ADV z_B FMI int_true
    int_false:      CLV z_A FPA rele_reuse
    int_true2:      PLS MIZ 0xff,z_A+0 SDZ z_A+1 FPA rele_reuse ; with PLS
    int_false2:      PLS CLV z_A FPA rele_reuse                  ; with PLS
  rele_eq:      CPI 0xd3 FNE rele_neq                            ; a == b
                  INV z_pc
                  JPS get LDZ z_A+0 PHS LDZ z_A+1 PHS
                  JPS BaseExpr JPS getB
                  PLS CPZ z_B+1 FNE int_false2
                    PLS CPZ z_B+0 FNE int_false
      int_true:        MIZ 0xff,z_A+0 SDZ z_A+1
    rele_reuse:   MZT z_A+0,z_sp MZT z_A+1,z_spi                 ; store result as int
                  CLZ z_refset MIZ 2,z_type
                  CLZ z_cnt+1 MIZ 1,z_cnt+0
                  JPA rele_while
  rele_neq:     CPI 0xd4 FNE rele_leq                            ; a != b
                  INV z_pc
                  JPS get LDZ z_A+0 PHS LDZ z_A+1 PHS
                  JPS BaseExpr JPS getB
                  PLS CPZ z_B+1 FNE int_true2
                    PLS CPZ z_B+0 FNE int_true
                      CLV z_A FPA rele_reuse
  rele_leq:     CPI 0xd5 FNE rele_geq                            ; a <= b <=> b-a >= 0
                  INV z_pc JPS get
                  LDZ z_A+0 PHS LDZ z_A+1 PHS
                  JPS BaseExpr JPS getB
                  PLS SU.Z z_B+1 PLS SUV z_B BPL int_true
                      CLV z_A FPA rele_reuse
  rele_geq:     CPI 0xd6 FNE rele_greater                        ; a >= b <=> a+(-b) >= 0
                  INV z_pc JPS get
                  LDZ z_A+0 PHS LDZ z_A+1 PHS
                  JPS BaseExpr JPS getB NEV z_B
                  PLS AD.Z z_B+1 PLS ADV z_B BPL int_true
                      CLV z_A FPA rele_reuse
  rele_greater: CPI 0xd7 FNE rele_rts                            ; a > b <=> 0 > b+(-a)
                  INV z_pc JPS get NEV z_A
                  LDZ z_A+0 PHS LDZ z_A+1 PHS
                  JPS BaseExpr JPS getB
                  PLS AD.Z z_B+1 PLS ADV z_B BMI int_true
                    CLV z_A FPA rele_reuse
  rele_rts:     RTS

; -------------------------------------------------------------------

; handle logical operators: not, and, or, xor, <<, >> (and simultaeously bitwise operators)
Expr:           LDT z_pc CPI 0xd9 FEQ expr_not
                  JPS RelExpr FPA expr_while
  expr_not:     INV z_pc                                         ; consume 'not'
                JPS RelExpr JPS get NOV z_A                      ; NOT
    expr_reuse: MZT z_A+0,z_sp MZT z_A+1,z_spi                   ; store result as int
                CLZ z_refset MIZ 2,z_type
                CLZ z_cnt+1 MIZ 1,z_cnt+0
  expr_while:   LDT z_pc CPI 0xda FCC expr_rts
                  FNE expr_or
                    INV z_pc
                    JPS get LDZ z_A+0 PHS LDZ z_A+1 PHS          ; push A
                    JPS RelExpr JPS get
                    PLS AN.Z z_A+1 PLS AN.Z z_A+0                ; AND
                    FPA expr_reuse
  expr_or:      CPI 0xdb FNE expr_xor
                  INV z_pc
                  JPS get LDZ z_A+0 PHS LDZ z_A+1 PHS            ; push A
                  JPS RelExpr JPS get
                  PLS OR.Z z_A+1 PLS OR.Z z_A+0                  ; OR
                  JPA expr_reuse
  expr_xor:     CPI 0xdc FNE expr_shiftl
                  INV z_pc
                  JPS get LDZ z_A+0 PHS LDZ z_A+1 PHS            ; push A
                  JPS RelExpr JPS get
                  PLS XRZ z_A+1 SDZ z_A+1                        ; XOR
                  PLS XRZ z_A+0 SDZ z_A+0
                  JPA expr_reuse
  expr_shiftl:  CPI 0xdd FNE expr_shiftr
                  INV z_pc
                  JPS get LDZ z_A+0 PHS LDZ z_A+1 PHS            ; push A
                  JPS RelExpr JPS getB
                  PLS SDZ z_A+1 PLS SDZ z_A+0                    ; pull A
                  JPS int_lsl FPA expr_reuse
  expr_shiftr:  CPI 0xde FNE expr_rts
                  INV z_pc
                  JPS get LDZ z_A+0 PHS LDZ z_A+1 PHS            ; push A
                  JPS RelExpr JPS getB
                  PLS SDZ z_A+1 PLS SDZ z_A+0                    ; pull A
                  JPS int_lsr FPA expr_reuse
  expr_rts:     RTS

; -------------------------------------------------------------------

#page

CompExpr:       JPS Expr
  compwhile:    LDT z_pc CPI '_' FNE comp_rts                    ; concatenation?
                  INV z_pc
                  LDZ z_sp+0 PHS LDZ z_sp+1 PHS                  ; save expr info on CPU stack
                  LDZ z_cnt+0 PHS LDZ z_cnt+1 PHS
                  LDZ z_type PHS CPI 1 FEQ compbyte
                    LLV z_cnt                                    ; z_cnt now holds bytesize of prev expression
    compbyte:     LDZ z_cnt+1 AD.Z z_sp+1                        ; advance math stack pointers over ex. data
                  LDZ z_cnt+0 ADV z_sp+0 SDZ z_spi+1
                  MZZ z_sp+0,z_spi+0 INV z_spi                   ; MSB stays in A
                  CPI >endsp BCS memerror                        ; MATH MEMORY CHECK
                    JPS Expr                                     ; read next expression into SP
                    PLS CPZ z_type FEQ comptypeok                ; vgl. gespeicherten z_type mit neuem z_type
                      LDI <error06 PHS LDI >error06 PHS JPA Error ; type mismatch
  comptypeok:       PLS AD.Z z_cnt+1 PLS ADV z_cnt               ; add up to total element count
                    PLS SDZ z_sp+1 SDZ z_spi+1                   ; restore stack state
                    PLS SDZ z_sp+0 SDZ z_spi+0 INV z_spi
                    FPA compwhile
  comp_rts:     RTS

; -------------------------------------------------------------------

; Asserts a (compound) expression of specified type (casts single element, throws error for multiple)
; push: desired type
; pull: desired type
TypedCompExpr:  JPS CompExpr                                     ; parses compound expression of any type
                LDS 3 CPZ z_type FEQ tcomp_rts                   ; matching types -> do nothing, else enforce type
                  SDZ z_type CPI 1 FEQ tcompcntchk               ; no further action if cast int -> char (truncate)
                    LDT z_sp LL1 LDI 0 RL1 NEG SDT z_spi         ; cast char -> int in C-style w/o branching
  tcompcntchk:    LDZ z_cnt+0 ANI 0xfe ORZ z_cnt+1               ; error for z_cnt > 1
                  CPI 0 FNE tcomperror
  tcomp_rts:        RTS
  tcomperror:   LDI <error06 PHS LDI >error06 PHS JPA Error      ; error type mismatch

; --------------------------------------------------------------------------------------
; STATEMENTS
; --------------------------------------------------------------------------------------

ReturnStmt:     LDT z_pc CPI 0xe0 FCS return_else
                  JPS CompExpr LDI 4 OR.Z z_halt                 ; it is important to set halt *after* CompExpr()!
                  MVV z_sp,z_retsp
                  RTS
  return_else:  LDI 4 OR.Z z_halt CLV z_cnt                      ; do not return anything after plain return statement
                RTS

CallStmt:       LDT z_pc CPI 0xd0 FEQ callint                    ; address is TN_INT_CONST
  callerror:      LDI <error05 PHS LDI >error05 PHS JPA Error    ; error invalid expr
  callint:      INV z_pc
                MTB z_pc,callto+0 INV z_pc
                MTB z_pc,callto+1 INV z_pc
                  JPS                                            ; jump to subroutine
  callto:          0xffff SDZ 0xff                               ; store accumulator SysReg
                  RTS

WhileStmt:      LDZ z_pc+0 PHS LDZ z_pc+1 PHS
  whileloop:    JPS Expr JPS get
                LDZ z_A+0 ORZ z_A+1 CPI 0 FEQ whilebreak
                  JPS Block
                  LDZ z_halt CPI 0 FNE whilebreak
                    LDS 1 SDZ z_pc+1 LDS 2 SDZ z_pc+0
                    FPA whileloop
  whilebreak:   PLS PLS
                JPS SkipStmt
                LDI 0xfd AN.Z z_halt                             ; z_halt &= ~BREAK;
                RTS

IfStmt:         JPS Expr JPS get LDZ z_A+0 ORZ z_A+1 PHS
                CPI 0 FEQ if_1_else
                  JPS Block FPA if_while
  if_1_else:    JPS SkipStmt
  if_while:     LDT z_pc CPI 'F' FNE if_1_end
                  LDZ z_mind CPZ z_tind FNE if_1_end
                    INV z_pc
                    LDS 1 CPI 0 FEQ if_2_else
                      JPS SkipStmt FPA if_while
    if_2_else:      JPS Expr JPS get LDZ z_A+0 ORZ z_A+1 SDS 1
                    CPI 0 FEQ if_3_else
                      JPS Block FPA if_while
      if_3_else:    JPS SkipStmt FPA if_while
  if_1_end:           LDT z_pc CPI 'E' FNE if_2_end
                        LDZ z_mind CPZ z_tind FNE if_2_end
                          INV z_pc
                          LDS 1 CPI 0 FEQ if_4_else
                            JPS SkipStmt FPA if_2_end
    if_4_else:        JPS Block
  if_2_end:         PLS RTS

PrintStmt:      JPS AssertORound
  printmore:    LDT z_pc CPI ')' FEQ printexit
                JPS CompExpr
                LDZ z_type CPI 1 FEQ printchars
                  MVV z_cnt,z_B                                  ; z_cnt -> z_B as counter
                  MVV z_sp,z_D                                   ; z_D = print pointer
    printnext:    DEV z_B FCC printmore                          ; first test for zero elements
    printnext2:     MTZ z_D,z_A+0 INV z_D                        ; read out next int
                    MTZ z_D,z_A+1 INV z_D
                    JPS int_tostr                                ; convert z_A to string
                    LDB strptr+0 PHS LDB strptr+1 PHS JPS _PrintPtr PLS PLS
                    DEV z_B FCC printmore
                      LDI '_' JAS _PrintChar FPA printnext2
  printchars:   LDZ z_sp+0 PHS LDZ z_sp+1 PHS JPS _PrintPtr PLS PLS
                FPA printmore
  printexit:    INV z_pc RTS                                     ; consume final ')'

; ------------------------------------------------------------------------------------------------
; FUNCTIONS AND VARIABLES
; ------------------------------------------------------------------------------------------------

; push: pc_lsb, pc_msb
; pull: #, #
FunctionCall:       LDZ z_nextvar+0 PHS LDZ z_nextvar+1 PHS
                    LDZ z_sp+0 PHS LDZ z_sp+1 PHS
                    LDZ z_tind PHS CLZ z_tind
                    JPS AssertORound                             ; consume caller (
                    LDZ z_pc+0 PHS LDZ z_pc+1 PHS                ; store z_pc -> args
                    LDS 11 SDZ z_pc+0 LDS 10 SDZ z_pc+1          ; callee params -> z_pc

  fun_while:        LDT z_pc CPI ')' BEQ fun_whileex             ; parse for callee's parameter )
                      CPI '1' FEQ fun_typeok
                        CPI '2' FEQ fun_typeok
    fun_typeerr:          LDI <error17 PHS LDI >error17 PHS JPA Error ; error Invalid parameter
    fun_typeok:       SUI '0' SDZ 0 INV z_pc                     ; park type in X, consume type
                      LDT z_pc CPI '&' BNE fun_plainvar          ; reference & variable
                        INV z_pc                                 ; consume &
                        LDT z_pc CPI 'V' FNE fun_typeerr
                          INV z_pc                               ; consume V
                          MTT z_pc,z_nextvar INV z_pc            ; consume & store ->id
                          INV z_nextvar LDZ z_sub INC SDT z_nextvar ; store ->sub
                          INV z_nextvar MZT 0,z_nextvar          ; store X ->type
                          AIV 7,z_nextvar                        ; goto new top of vars
                          LDZ z_pc+0 SDS 11 LDZ z_pc+1 SDS 10    ; z_pc -> par
                          LDS 2 SDZ z_pc+0 LDS 1 SDZ z_pc+1      ; arg -> z_pc
                          LDT z_pc CPI 'V' FEQ fun_isvar
                            LDI <error19 PHS LDI >error19 PHS JPA Error ; error invalid argument
      fun_isvar:          INV z_pc                               ; consume V
                          LDT z_pc PHS PHS INV z_pc JPS getVar   ; consume and push ID
                          PLS SDB refptr+1 PLS SDB refptr+0      ; return pointer to ref variable *type*
                          SIV 7,z_nextvar                        ; down to ->type
                          LDR refptr CPT z_nextvar BNE fun_typeerr ; error Reference type mismatch
                            INV z_nextvar INW refptr             ; advance to ->cnt
                            MRT refptr,z_nextvar INV z_nextvar INW refptr ; -> cnt
                            MRT refptr,z_nextvar INV z_nextvar INW refptr
                            MRT refptr,z_nextvar INV z_nextvar INW refptr ; -> ptr
                            MRT refptr,z_nextvar INV z_nextvar INW refptr
                            MRT refptr,z_nextvar INV z_nextvar INW refptr ; -> max
                            MRT refptr,z_nextvar INV z_nextvar INW refptr
                            JPA fun_whileon
      refptr:             0xffff

    fun_plainvar:     CPI 'V' BNE fun_typeerr
                        INV z_pc                                 ; consume 'V'
                        MTT z_pc,z_nextvar INV z_pc              ; store & consume ->id
                        INV z_nextvar LDZ z_sub INC SDT z_nextvar ; store ->sub
                        INV z_nextvar MZT 0,z_nextvar            ; store X ->type
                        AIV 7,z_nextvar                          ; goto new top of vars
                        LDZ z_pc+0 SDS 11 LDZ z_pc+1 SDS 10      ; z_pc -> par
                        LDS 2 SDZ z_pc+0 LDS 1 SDZ z_pc+1        ; arg -> z_pc
                        LDZ 0 PHS JPS TypedCompExpr              ; request with type again
                        SIV 6,z_nextvar                          ; go down to ->cnt
                        MZT z_cnt+0,z_nextvar INV z_nextvar      ; ->cnt
                        MZT z_cnt+1,z_nextvar INV z_nextvar
                        MZT z_sp+0,z_nextvar INV z_nextvar       ; ->ptr
                        MZT z_sp+1,z_nextvar INV z_nextvar
                        MZT z_cnt+0,z_nextvar INV z_nextvar      ; ->max
                        MZT z_cnt+1,z_nextvar INV z_nextvar
                        PLS CPI 1 FEQ fun_pvarchar               ; finally pull the type here
                          LLV z_cnt                              ; x2 for int
    fun_pvarchar:       AVV z_cnt,z_sp                           ; z_sp += z_cnt * z_type
                        AVV z_cnt,z_spi                          ; z_sp += z_cnt * z_type
    fun_whileon:        LDZ z_pc+0 SDS 2 LDZ z_pc+1 SDS 1        ; both cases: arg = z_pc; z_pc = par;
                        LDS 11 SDZ z_pc+0 LDS 10 SDZ z_pc+1      ; back to parameters
                        JPA fun_while

  fun_whileex:      INV z_pc                                     ; consume callee's param )
                    INZ z_sub JPS FastBlock DEZ z_sub            ; jump into callee's function block
                    PLS SDZ z_pc+1 PLS SDZ z_pc+0                ; pull arg -> z_pc (back to caller)
                    JPS AssertCRound                             ; consume caller's ')' to reach next statement
                    PLS SDZ z_tind
                    PLS SDZ z_sp+1 SDZ z_spi+1
                    PLS SDZ z_sp+0 SDZ z_spi+0 INV z_spi
                    PLS SDZ z_nextvar+1 PLS SDZ z_nextvar+0
                    LDZ z_halt CPI 0 FEQ fun_nohalt
                      LDI 0xfb AN.Z z_halt                       ; clear RETURN flag
                      LDZ z_cnt+0 ORZ z_cnt+1 CPI 0 FEQ fun_rts
                        MZB z_sp+0,fun_dst+0                     ; move return data
                        MZB z_sp+1,fun_dst+1
                        MZB z_retsp+0,fun_src+0
                        MZB z_retsp+1,fun_src+1
                        MVV z_cnt,z_A
                        CIZ 1,z_type FEQ fun_loop
                          LLV z_A
    fun_loop:           DEV z_A FCC fun_rts
                          LDB
      fun_src:            0xffff SDB
      fun_dst:            0xffff INW fun_src INW fun_dst FPA fun_loop
  fun_rts:            RTS
  fun_nohalt:       CLV z_cnt RTS                                ; no 'return' happened

DefStmt:            LDT z_pc CPI 'S' FNE deferror
                      LDZ z_sub CPI 0 FNE deferror
                        LDZ z_mind CPI 0 FNE deferror
                          INV z_pc                               ; consume TN_CALL
                          MTT z_pc,z_nextcall INV z_pc INV z_nextcall ; consume and store call ID
                          JPS AssertORound                       ; consume (
                          MZT z_pc+0,z_nextcall INV z_nextcall   ; store PC of call
                          MZT z_pc+1,z_nextcall INV z_nextcall
                          JPS SkipStmt
                          RTS
  deferror:         LDI <error16 PHS LDI >error16 PHS JPA Error  ; error invalid definition

#page

; push: (vp->type)_lsb, (vp->type)_msb
; pull: #, #
VarAssignment:      LDT z_pc CPI '[' FEQ ass_element
                      LDI 0xff PHS PHS FPA ass_operator          ; push no-offset marker and goto operator
  ass_element:      INV z_pc                                     ; consume [
                    JPS Expr JPS get JPS AssertCSquare           ; parse offset ]
                    LDZ z_A+0 PHS LDZ z_A+1 PHS                  ; push offset
  ass_operator:     LDT z_pc CPI '=' BNE ass_fastaddsub
                      INV z_pc                                   ; consume =
                      LDS 6 SDB assptr+0 LDS 5 SDB assptr+1      ; vp->type
                      LDR assptr PHS                             ; load vp->type 1 or 2 and push
                      JPS TypedCompExpr PLS                      ; request typed comp-expr (now z_type = vp->type)
                      PLS CPI 0xff BEQ ass_nooffset              ; pull and test offset MSB
                        SDB ass_dst+1 SDZ z_A+1                  ; offset -> ass_dst, z_A
                        PLS SDB ass_dst+0 SDZ z_A+0
                        AVV z_cnt,z_A                            ; RANGE SAFETY-CHECK 1: z_A = z_cnt + offset
                        CIZ 2,z_type FNE ass_typedone            ; get type from X
                          LLV z_cnt LLW ass_dst                  ; x2 of address offset and expression size
          ass_typedone: LDS 4 SDB assptr+0 LDS 3 SDB assptr+1    ; goto vp->type
                        AIW 3,assptr LDR assptr ADW ass_dst      ; ass_dst = vp->ptr + offset * vp->type
                        INW assptr LDR assptr AD.B ass_dst+1
                        INW assptr MRZ assptr,z_B+0              ; RANGE SAFETY-CHECK 2: z_B = ->max
                        INW assptr MRZ assptr,z_B+1
                        LDZ z_A+1 SU.Z z_B+1 FCC ass_indexerr    ; ->max - (z_cnt + offset) >= 0 ? -> okay!
                          LDZ z_A+0 SUV z_B FCS ass_copy
      ass_indexerr:          LDI <error14 PHS LDI >error14 PHS   ; error Invalid index
                          JPA Error
    ass_nooffset:     PLS                                        ; discard no-offset LSB
                      LDS 4 SDB assptr+0 LDS 3 SDB assptr+1      ; goto vp->type
                      INW assptr MZR z_cnt+0,assptr              ; z_cnt -> vp->cnt
                      INW assptr MZR z_cnt+1,assptr
                      INW assptr MRB assptr,ass_dst+0            ; ->ptr
                      INW assptr MRB assptr,ass_dst+1
                      INW assptr MRZ assptr,z_A+0                ; ->max into z_A for RANGE SAFETY-CHECK WHOLE
                      INW assptr MRZ assptr,z_A+1
                      LDZ z_cnt+1 SU.Z z_A+1 FCC ass_indexerr    ; ->max - z_cnt >= 0 means okay
                        LDZ z_cnt+0 SUV z_A FCC ass_indexerr
                          LDZ z_type CPI 2 FNE ass_copy          ; reuse z_cnt as byte counter
                            LLV z_cnt                            ; x 2 for int
      ass_copy:           MZB z_sp+0,ass_src+0                   ; from z_sp to vp->ptr [+ offset * vp->type]
                        MZB z_sp+1,ass_src+1
      ass_loop:           DEW  z_cnt FCC ass_rts                 ; reuses z_cnt as byte counter
                            LDB
      ass_src:              0xffff SDB
      ass_dst:              0xffff INW ass_src INW ass_dst FPA ass_loop
      ass_rts:            RTS

    ass_fastaddsub: SDZ 1 INV z_pc LDT z_pc CPI 0xd0 BNE ass_error ; TN_INT_CONST -> Y
                      INV z_pc
                      LDS 6 SDB assptr+0 LDS 5 SDB assptr+1      ; vp->type
                      MRZ assptr,0
                      PLS CPI 0xff FEQ ass_nooffa
                        SDZ z_A+1 PLS SDZ z_A+0                  ; z_A = offset
                        CIZ 1,0 FEQ ass_achar
                          LLV z_A                                ; offset x 2 = byte offset
      ass_achar:        AIW 3,assptr                             ; goto ->ptr
                        LDR assptr ADV z_A INW assptr            ; z_A = ->ptr + offset * ->type
                        LDR assptr AD.Z z_A+1 JPA ass_offaset
      ass_nooffa:     PLS                                        ; pull LSB rest of null-offset
                      INW assptr                                 ; goto ->cnt
                      MIR 1,assptr INW assptr                    ; ->cnt = 1
                      MIR 0,assptr INW assptr
                      MRZ assptr,z_A+0 INW assptr                ; z_A = ->ptr
                      MRZ assptr,z_A+1
      ass_offaset:    CIZ 1,0 FEQ ass_aachar
                        MTZ z_A,z_B+0 INV z_A
                        MTZ z_A,z_B+1
                        LDZ 1 CPI 'a' FNE ass_fsubint
                          LDT z_pc ADV z_B INV z_pc              ; add fast int
                          LDT z_pc AD.Z z_B+1 SDT z_A INV z_pc
                          DEV z_A MZT z_B+0,z_A RTS
        ass_fsubint:    CPI 's' FNE ass_error
                          LDT z_pc SUV z_B INV z_pc              ; sub fast int
                          LDT z_pc SU.Z z_B+1 SDT z_A INV z_pc
                          DEV z_A MZT z_B+0,z_A RTS
        ass_aachar:   LDZ 1 CPI 'a' FNE ass_fsubchar
                        LDT z_A ADT z_pc SDT z_A                 ; add fast char
                        AIV 2,z_pc RTS
        ass_fsubchar: CPI 's' FNE ass_error
                        LDT z_A SUT z_pc SDT z_A                 ; sub fast char
                        AIV 2,z_pc RTS
    ass_error:      LDI <error05 PHS LDI >error05 PHS JPA Error  ; error Invalid assign

  assptr:           0xffff

#page

; 'type' token was just consumed, now expect a TN_VAR and it's identifier
; push: type (1 or 2)
; pull: #
VarDefinition:      LDT z_pc CPI 'V' FEQ var_okay
                      LDI <error01 PHS LDI >error01 PHS JPA Error ; error Expecting an identifier
  var_okay:         INV z_pc MTT z_pc,z_nextvar                  ; consume 'V', read & store id
                    INV z_pc INV z_nextvar                       ; move to ->sub
                    LDZ z_sub ORZ z_mind DEC FCC var_writesub
                      LDZ z_sub
  var_writesub:     SDT z_nextvar INV z_nextvar                  ; move to ->type
                    LDS 3 SDT z_nextvar                          ; write sub (0xff for global) and type

                    LDT z_pc CPI '@' BNE var_localvar
                      INV z_pc AIV 7,z_nextvar                   ; protect the new var entry
                      JPS Expr
                      LDZ z_type CPI 2 FEQ var_typok
                        LDI <error05 PHS LDI >error05 PHS JPA Error ; error Expecting an int address
    var_typok:        JPS get SIV 4,z_nextvar
                      MZT z_A+0,z_nextvar INV z_nextvar          ; vp->ptr
                      MZT z_A+1,z_nextvar INV z_nextvar
                      MIT 0xff,z_nextvar INV z_nextvar           ; vp->max
                      MIT 0xff,z_nextvar INV z_nextvar
                      LDT z_pc CPI '=' BNE var_abselse
                        INV z_pc
                        LDS 3 PHS JPS TypedCompExpr
                        SIV 6,z_nextvar
                        MZT z_cnt+0,z_nextvar INV z_nextvar
                        MZT z_cnt+1,z_nextvar INV z_nextvar
                        MTB z_nextvar,var_dst+0 INV z_nextvar
                        MTB z_nextvar,var_dst+1 AIV 3,z_nextvar
                        MZB z_sp+0,var_src+0 MZB z_sp+1,var_src+1
                        PLS CPI 1 FEQ var_loop                   ; check type for int
                          LLV z_cnt
      var_loop:          DEV z_cnt FCC var_absexit
                          LDB
      var_src:            0xffff SDB
      var_dst:            0xffff INW var_src INW var_dst FPA var_loop
      var_absexit:      RTS

#page

    var_abselse:      SIV 6,z_nextvar
                      LDZ z_refset CPI 1 FEQ var_refset
                        MIT 1,z_nextvar INV z_nextvar
                        MIT 0,z_nextvar AIV 5,z_nextvar
                        RTS
      var_refset:     MZT z_refcnt+0,z_nextvar INV z_nextvar
                      MZT z_refcnt+1,z_nextvar AIV 5,z_nextvar
                      RTS

  var_localvar:     AIV 3,z_nextvar                              ; move to ->ptr
                    MZT z_sp+0,z_nextvar INV z_nextvar           ; write z_sp ->ptr
                    MZT z_sp+1,z_nextvar INV z_nextvar           ; points to v->max
                    LDT z_pc CPI '=' FNE var_locelse
                      INV z_pc                                   ; consume =
                      MIT 0xff,z_nextvar INV z_nextvar           ; vp->max = 0xffff
                      MIT 0xff,z_nextvar INV z_nextvar
                      LDS 3 PHS JPS TypedCompExpr PLS
                      SIV 6,z_nextvar
                      MZT z_cnt+0,z_nextvar INV z_nextvar        ; ->cnt = z_cnt
                      MZT z_cnt+1,z_nextvar AIV 3,z_nextvar      ; move to ->max
                      MZT z_cnt+0,z_nextvar INV z_nextvar        ; ->max = z_cnt
                      MZT z_cnt+1,z_nextvar INV z_nextvar
                      LDS 3 CPI 1 FEQ var_char
                        LLV z_cnt                                ; z_cnt now is z_cnt * z_type
    var_char:         LDZ z_cnt+0 ADV z_sp
                      LDZ z_cnt+1 AD.Z z_sp+1
                      LDZ z_cnt+0 ADV z_spi
                      LDZ z_cnt+1 AD.Z z_spi+1
                      RTS

    var_locelse:    SIV 4,z_nextvar                              ; move to ->cnt
                    MIT 1,z_nextvar INV z_nextvar                ; vp->cnt = 1
                    MIT 0,z_nextvar AIV 3,z_nextvar              ; move to ->max
                    MIT 1,z_nextvar INV z_nextvar                ; vp->max = 1
                    MIT 0,z_nextvar INV z_nextvar
                    LDS 3 ADV z_sp
                    LDS 3 ADV z_spi
                    RTS

; --------------------------------------------------------------------------------------
; LANGUAGE STRUCTURE
; --------------------------------------------------------------------------------------

Statement:      CZZ z_tind,z_mind FEQ stmtnormal
                  FMI stmtblockend
                    LDI <error11 PHS LDI >error11 PHS JPA Error  ; error unexpected indent
  stmtnormal:   CIT 'I',z_pc FNE stmtnext1
                  INV z_pc JPS IfStmt RTS
    stmtnext1:  CPI 'W' FNE stmtnext2
                  INV z_pc JPS WhileStmt RTS
    stmtnext2:  CPI 'D' FNE stmtsimple
                  INV z_pc JPS DefStmt RTS
    stmtsimple: JPS SimpleLine
                RTS
  stmtblockend: LDI 1 OR.Z z_halt                                ; set BLOCKEND bit 0
                RTS

; -------------------------------------------------------------------

Block:          LDZ z_nextvar+0 PHS LDZ z_nextvar+1 PHS          ; save variable and stack state
                LDZ z_sp+0 PHS LDZ z_sp+1 PHS
                CIT 0xe0,z_pc FCC blocksimple                    ; is there an indent? => hanging block
                  NOT DEC SDZ z_mind INV z_pc                    ; consume indentation mark
                  INZ z_tind                                     ; indentation +1
  blockwhile:     JPS Statement CIZ 0,z_halt FEQ blockwhile
                  DEZ z_tind FPA blockend                        ; indentation -1
  blocksimple:  JPS SimpleLine
  blockend:     LDI 0xfe AN.Z z_halt                             ; clear BLOCKEND flag (bit 0)
                PLS SDZ z_sp+1 SDZ z_spi+1                       ; restore variable and stack state
                PLS SDZ z_sp+0 SDZ z_spi+0 INV z_spi
                PLS SDZ z_nextvar+1 PLS SDZ z_nextvar+0          ; (forget blocks's local variables)
                RTS

; -------------------------------------------------------------------

; push: character
; pull: #
SimpleLine:     CIT 'V',z_pc FNE linenext1
                  INV z_pc LDT z_pc PHS PHS INV z_pc JPS getVar
                  JPS VarAssignment PLS PLS FPA linecont
  linenext1:    CPI 'B' FNE linenext2
                  INV z_pc LDI 2 OR.Z z_halt FPA linecont        ; BreakStmt: z_halt |= BREAK
  linenext2:    CPI 'S' FNE linenext3
                  INV z_pc LDT z_pc PHS PHS INV z_pc JPS getCall
                  JPS FunctionCall PLS PLS FPA linecont
  linenext3:    CPI 'R' FNE linenext4
                  INV z_pc JPS ReturnStmt FPA linecont
  linenext4:    CPI '1' FNE linenext5
                  INV z_pc LDI 1 PHS JPS VarDefinition PLS FPA linecont
  linenext5:    CPI '2' FNE linenext6
                  INV z_pc LDI 2 PHS JPS VarDefinition PLS FPA linecont
  linenext6:    CPI 'C' FNE linenext7
                  INV z_pc JPS CallStmt FPA linecont
  linenext7:    CPI 'P' FNE linenext8
                  INV z_pc JPS PrintStmt FPA linecont
  linenext8:    LDI <error02 PHS LDI >error02 PHS JPA Error      ; error invalid simple stmt
  linecont:     CIT 0xe0,z_pc FCS lineindent                 ; end of the line (indent) reached?
                  CIZ 0,z_halt FEQ SimpleLine                ; any halt flag set?
                    RTS
  lineindent:   NOT DEC SDZ z_mind INV z_pc RTS

; -------------------------------------------------------------------

; function block does not need an additional push/pull of variables and math stack
FastBlock:      CIT 0xe0,z_pc FCC fblocksimple                  ; is there an indent? => hanging block
                  NOT DEC SDZ z_mind INV z_pc                    ; consume indentation mark
                  INZ z_tind                                     ; indentation +1
  fblockwhile:      JPS Statement CIZ 0,z_halt FEQ fblockwhile
                  DEZ z_tind                                     ; indentation -1
                  LDI 0xfe AN.Z z_halt                           ; clear BLOCKEND flag (bit 0)
                  RTS
  fblocksimple: JPS SimpleLine
                LDI 0xfe AN.Z z_halt                             ; clear BLOCKEND flag (bit 0)
                RTS

; --------------------------------------------------------------------------------------
; GLOBAL STATE
; --------------------------------------------------------------------------------------

g_stop:         0x0000        ; tokenizer will stop here, set to 0xffff to tokenize the entire source code
g_line:         0x0000        ; line number (set by the tokenizer)

error01:        'Invalid ID', 0
error02:        'Unknown stmt', 0
error05:        'Invalid expr', 0
error06:        'Type mismatch', 0
error07:        'Out of IDs', 0
error08:        'Out of RAM', 0
error11:        'Unclear indent', 0
error14:        'Invalid index', 0
error16:        'Invalid def', 0
error17:        'Invalid parameter', 0
error19:        'Invalid argument', 0
error22:        'Devide by 0', 0
error30:        'Expect ]', 0
error31:        'Expect (', 0
error32:        'Expect )', 0
error33:        'Expect =', 0

                              ; tokenizing item dictionary
items:          'if',0,'...........', 'I',  0xff,  'elif',0,'.........', 'F',  0xff,  'else',0,'.........', 'E',  0xff,
                'while',0,'........', 'W',  0xff,  'break',0,'........', 'B',  0xff,  'def',0,'..........', 'D',  0xff,
                'return',0,'.......', 'R',  0xff,  'char',0,'.........', '1',  0xff,  'int',0,'..........', '2',  0xff,
                'call',0,'.........', 'C',  0xff,  'not',0,'..........', 0xd9,  0xff,  'and',0,'..........', 0xda,  0xff,
                'or',0,'...........', 0xdb,  0xff,  'xor',0,'..........', 0xdc,  0xff, 'print',0,'........', 'P',  0xff,
newitems:                     ; start of new tokenizer items (variables and calls)

#mute

; --------------------------------------------------------------------------------------
; MIN GLOBAL CONSTANTS
; --------------------------------------------------------------------------------------

#org 0x8000     file:         ; beginning of the source file (editor text file)
#org 0x2e00     firstcall:    ; call dictionary 3 bytes * 256 = 0x300 bytes
#org 0x3100     firstvar:     ; var dictionary  9 bytes * 256 = 0x900 bytes
#org 0x3a00     firstsp:      ; data memory stack (1408 bytes)
#org 0x3f80     endsp:        ; data memory end
#org 0x3f92     firstsrc:     ; vector of imported source files (22bytes * 5 = 110 bytes, max. 5 entries)
#org 0xf000     endsrc:       ; end of source vector

#org 0x0050                   ; zero page used by Min

z_A:            0x0000        ; MATH REGISTERS
z_B:            0x0000
z_C:            0x0000, 0x00  ; used as modifiable copy
z_D:            0x0000        ; only used by div
z_count:        0x00
z_flag:         0x00

z_pc:           0x0000        ; program counter
z_sub:          0xff          ; subroutine calling level
z_tind:         0xff          ; target indentation
z_mind:         0xff          ; measured indentation
z_halt:         0xff          ; halt flags ... stop processing of statements
z_nextcall:     0xffff        ; free top of call list
z_nextvar:      0xffff        ; free top of var list
z_nextsrc:      0xffff        ; free top of the source list
z_sp:           0xffff        ; expression stack pointer (to char or LSB of int)
z_spi:          0xffff        ; expression stack pointer (to MSB of int)
z_cnt:          0xffff        ; element count of expression (or returned data) on stack
z_type:         0xff          ; element type of last expression (or returned data) on stack
z_retsp:        0xffff        ; pointer at returned expression data on the stack
z_refcnt:       0xffff        ; used by @: referenced element count, set by & only if cnt > 1
z_refset:       0xff          ; 1: refcnt was actively set, 0: use refcnt = 1

#org 0x0080     z_PtrA:           ; lokaler pointer (3 bytes) used for FLASH addr and bank
#org 0x0083     z_PtrB:           ; lokaler pointer (3 bytes)
#org 0x0089     z_PtrD:           ; lokaler pointer (3 bytes)
#org 0x008c     z_PtrE: z_getptr: ; lokaler pointer (2 bytes)
#org 0x008e     z_PtrF:           ; lokaler pointer (2 bytes)


#mute                         ; MinOS API label definitions generated by 'asm os.asm -s_'

#org 0xf000 _Start:
#org 0xf003 _Prompt:
#org 0xf006 _MemMove:
#org 0xf009 _Random:
#org 0xf00c _ScanPS2:
#org 0xf00f _ResetPS2:
#org 0xf012 _ReadInput:
#org 0xf015 _WaitInput:
#org 0xf018 _ReadLine:
#org 0xf01b _SkipSpace:
#org 0xf01e _ReadHex:
#org 0xf021 _FlashA:
#org 0xf024 _SerialPrint:
#org 0xf027 _FindFile:
#org 0xf02a _LoadFile:
#org 0xf02d _SaveFile:
#org 0xf030 _ClearVRAM:
#org 0xf033 _Clear:
#org 0xf036 _ClearRow:
#org 0xf039 _ScrollUp:
#org 0xf03c _ScrollDn:
#org 0xf03f _Char:
#org 0xf042 _PrintChar:
#org 0xf045 _Print:
#org 0xf048 _PrintPtr:
#org 0xf04b _PrintHex:
#org 0xf04e _SetPixel:
#org 0xf051 _Line:
#org 0xf054 _Rect:
#org 0x00c0 _XPos:
#org 0x00c1 _YPos:
#org 0x00c2 _RandomState:
#org 0x00c6 _ReadNum:
#org 0x00c9 _ReadPtr:
#org 0x00cd _ReadBuffer:
