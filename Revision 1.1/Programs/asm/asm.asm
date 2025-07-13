; ------------------------------------------------------------------
; Native Assembler v3.0 for 'Minimal 64x4' by Carsten Herting (slu4)
; ------------------------------------------------------------------
; initial version for the 'Minimal 64'       02.10.2022 - 06.10.2022
; adapted to 'Minimal Ultra'                 10.09.2023 - 11.09.2023
; adapted to 'Minimal 64x4'                  09.10.2023 - 30.10.2023
; re-implementation for 'smart parsing'      01.02.2024 - 05.02.2024
; ------------------------------------------------------------------

; LICENSING INFORMATION
; This is free software: you can redistribute it and/or modify it under the terms of the
; GNU General Public License as published by the Free Software Foundation, either
; version 3 of the License, or (at your option) any later version.
; This software is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even
; the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public
; License for more details. You should have received a copy of the GNU General Public License along
; with this program. If not, see https://www.gnu.org/licenses/.

; CHANGE LOG

#org 0x1000   ; BUILD address of the assembler

; Building this assembler on the Minimal natively: Change the above build address from 0x1000 to 0x2000.
; Remove all comments of this file by searching for REGEX "; ([\s\S]*)" and replacing with nothing.
; Remove all trailing SPACES, too. Upload the remaining source file into the Minimal editor with Ctrl+R.
; Build with 'asm ENTER'. Copy the output to it's target 0x1000 with 'memmove 2000 2fff 1000'.

#mute
#org 0x1000   ; TARGET address of 'asm'. Do *not* change this unless you know what you are doing. There
#emit         ; might be consequences involving the integration of 'asm' with the rest of the tool-chain.

; ------------------------------------------------
; load file if filename is present in command line
; ------------------------------------------------
Init:         MIB 0xfe,0xffff                                 ; init stack
              CLV sptr                                        ; pointer to optional symbol tag
              JPS _Print '64x4 Assembler', 10, 0              ; print headline
              JPS _SkipSpace                                  ; parse command line: skip whitespace after 'asm'
              CIT '-',_ReadPtr FEQ init_sym                   ; look for -s... option
              CIT 32,_ReadPtr FLE PassOne                     ; no FILENAME in command line? Just assemble!
                JPS _LoadFile                                 ; load filename at _ReadPtr
                CPI 0 FEQ init_err                            ; file not found?
                  JPS _SkipSpace                              ; skip whitespace after filename
                  CIT '-',_ReadPtr FNE PassOne                ; look for -s... option
  init_sym:         INV _ReadPtr                              ; consume '-'
                    CIT 's',_ReadPtr FNE PassOne              ; ignore unknown command line option
                      INV _ReadPtr MVV _ReadPtr,sptr          ; consume 's' and store sym tag pointer
                      FPA PassOne
  init_err:     JPS _Print 'Not found.', 10, 0                ; report error
                JPA _Prompt

; ----------------------------------------------------------------
; Print out list of symbols according to -s... command line option
; ----------------------------------------------------------------
PassSymbols:  CIZ 0,sptr+0 BEQ PassTwo                        ; symbol table option active?
                MIV labels,lptr
  ps_loop:      CIT 0,lptr BEQ _Prompt                        ; labels in database?
                  MVV sptr,ssptr MVV lptr,llptr               ; copy pointers
    ps_cmploop:   LDT ssptr CPI 32 FLE ps_match               ; load tag char
                  CPT llptr FNE ps_nomatch
                    INV ssptr DEV llptr                       ; consume matching tag/label chars
                    LDT ssptr CPI 32 FGT ps_cmploop           ; end of tag reached for match?

  ps_match:       LDT lptr CPI ':' FEQ ps_endl
                    JAS _PrintChar DEV lptr FPA ps_match
    ps_endl:      JPS _Print " 0x",0                          ; print matching label
                  SIV 2,lptr LDT lptr JAS _PrintHex           ; print label value in MSB LSB order
                  INV lptr LDT lptr JAS _PrintHex
                  LDI 10 JAS _PrintChar
                  SIV 2,lptr FPA ps_loop                      ; goto next label

  ps_nomatch:     LDT lptr CPI ':' BEQ ps_endnoma             ; skip non-matching label
                    DEV lptr FPA ps_nomatch
    ps_endnoma:   SIV 3,lptr FPA ps_loop                      ; goto next label

; --------------------------------------------------------------
; Output the address of the last output byte and return to MinOS
; --------------------------------------------------------------
PassDone:     JPS _Print 'Last byte at 0x', 0                 ; print out last used address
              DEV mc
              LDZ mc+1 JAS _PrintHex
              LDZ mc+0 JAS _PrintHex
              LDI 10 JAS _PrintChar
              JPA _Prompt                                     ; will also clean up stack

; -------------------------------------------------------------------------------------------
; evaluate byte size of all elements, extract label definitions and calculate their addresses
; -------------------------------------------------------------------------------------------
PassOne:      ; JPS _Print "Pass 1", 10, 0
              MIV source,ep MIV default,pc MVV pc,mc          ; reset ep, pc, mc
              CLZ isparse CLZ args CLB labels                 ; clear label database with 0
                JPA p1_while

#page

    p1_next:    MVV enext,ep                                  ; only reentry: consume current element
  p1_while:   JPS findelem CPI 0 BEQ PassSymbols              ; sets ep, elen and enext
              CPI -1 BEQ Error                                ; Error: Invalid element (e.g. open string "...)

                MVV enext,eptr DEV eptr                       ; TEST FOR LABEL DEF, goto last char of element
                CIT ':',eptr FNE p1_preproc
                  MZZ elen,Z0 JPS findlabel                   ; looks for label at eptr of length Z0 in database
                  CPI 1 BEQ Error                             ; Error: Label already defined
                    JPS putlabel FPA p1_next
  p1_preproc:   CIT '#',ep BNE p1_parse                       ; TEST FOR PRE-PROC
                  MVV ep,eptr
                  CIZ 4,elen FNE p1_pre5char
                    INV eptr CIT 'o',eptr FNE p1_next
                    INV eptr CIT 'r',eptr FNE p1_next
                    INV eptr CIT 'g',eptr FNE p1_next
                      INV eptr MVV eptr,ep JPS findelem
                        CIZ 2,elen BLE Error
                        CIZ 6,elen BGT Error
                          MVV ep,eptr CIT '0',eptr BNE Error
                          INV eptr CIT 'x',eptr BNE Error
                          INV eptr MVV eptr,_ReadPtr
                          JPS _ReadHex
                          CIZ 0xf0,_ReadNum+2 BEQ Error       ; valid result?
                            MVV _ReadNum,pc                   ; copy valid result
                            LDZ _ReadPtr+0 SUZ eptr+0         ; number of hex digits
                            ADI 2 CPZ elen BNE Error          ; 0x + digits = elen? (valid hex constant)
                              FPA p1_next
    p1_pre5char:  CIZ 5,elen FNE p1_next                      ; ignore all other pre-proc stuff in pass 1
                    INV eptr CIT 'p',eptr BNE p1_next
                    INV eptr CIT 'a',eptr BNE p1_next
                    INV eptr CIT 'g',eptr BNE p1_next
                    INV eptr CIT 'e',eptr BNE p1_next
                      LDZ pc+0 NEG ADV pc FPA p1_next         ; int delta = (-(pc & 0xff)) & 0xff; pc += delta;

  p1_parse:     LDZ args ANI 0x0f                             ; PARSE ARG-SPECIFICALLY, use lower nibble
                CPI 0 BEQ p1_arg0
                  CPI 1 BEQ p1_arg1
                    CPI 2 BEQ p1_arg2
                      CPI 3 BEQ p1_arg3

    p1_arg4:      JPS parseexpr                               ; *** EXPECT FAST JUMP ***
                  CIZ 1,isop BEQ Error                        ; Error: Operator not allowed in expression
                  CIZ 1,ismsb BEQ Error
                  INV pc JPA p1_nextarg

    p1_arg3:      JPS parseexpr                               ; *** EXPECT WORD ***
                  CIZ 1,isop BEQ Error                        ; Error: Operator not allowed in expression
                  CIZ 1,isword BNE p1_byte3
                  CIZ 1,islsb BEQ p1_byte3
                  CIZ 1,ismsb FEQ p1_byte3
                    AIV 2,pc FPA p1_nextarg                   ; count as a word
      p1_byte3:   LDZ args ANI 0xf0 ORI 0x01 STZ args         ; change expectation to byte
                  INV pc JPA p1_next

    p1_arg2:      JPS parseexpr                               ; *** EXPECT ZERO-PAGE ***
                  CIZ 1,isop BEQ Error                        ; Error: Operator not allowed in expression
                  CIZ 1,ismsb BEQ Error
                    FPA p1_isbyte1

    p1_arg1:      JPS parseexpr                               ; *** EXPECT BYTE ***
                  CIZ 1,isop BEQ Error                        ; Error: Operator not allowed in expression
                  CIZ 0,isword FEQ p1_isbyte1
                  CIZ 1,islsb FEQ p1_isbyte1
                  CIZ 1,ismsb BNE Error                       ; Error: Expecting a byte argument
      p1_isbyte1:   INV pc                                    ; pc++
      p1_nextarg: LDZ args RL5 ANI 0x0f STZ args              ; args >>= 4
                  JPA p1_next

    p1_arg0:      LDT ep CPI "'" BEQ p1_string                ; *** EXPECT ANYTHING ***
                         CPI '"' BEQ p1_string
      p1_else:      JPS parseexpr                             ; call with isparse=0, sets: isop, islsb, ismsb, isword
                    CIZ 1,isop FNE p1_notop
                      RZP expr,>arguments,1 STZ args          ; access FLASH argument data on bank 1
                      INV pc JPA p1_next                      ; pc++
      p1_notop:     CIZ 0,isword FEQ p1_isbyte
                    CIZ 1,islsb FEQ p1_isbyte
                    CIZ 1,ismsb FEQ p1_isbyte
                      AIV 2,pc JPA p1_next                    ; pc+=2
      p1_isbyte:    INV pc JPA p1_next                        ; pc++
      p1_string:  MVV ep,eptr AVV elen,eptr DEV eptr          ; pure string: ep->first char, eptr->last char
                  LDT ep CPT eptr FNE p1_else
                    LDZ elen SUI 2 ADV pc JPA p1_next         ; pc += elen-2

; --------------------------------------------------------------------------------
; emit code directly into memory, substituting address values for label references
; --------------------------------------------------------------------------------
PassTwo:      ; JPS _Print "Pass 2", 10, 0
              MIV source,ep MIV default,pc MVV pc,mc          ; reset ep, pc, mc
              MIZ 1,isemit MIZ 1,isparse CLZ args             ; switch ON code emission by default
              FPA p2_while

    p2_next:    MVV enext,ep                                  ; only after reentry: consume current element
  p2_while:   JPS findelem CPI 0 BEQ PassDone                 ; sets ep, elen and enext if successful (A=1)
              CPI -1 BEQ Error                                ; Error: Invalid element (e.g. open string "...)

                MVV enext,eptr DEV eptr                       ; look at last char of element for ':'
                CIT ':',eptr FEQ p2_next                      ; ignore this

                CIT '#',ep BNE p2_parse
                  MVV ep,eptr INV eptr
                  CIZ 5,elen BNE p2_testlen4
                             CIT 'p',eptr BNE p2_mute
                    INV eptr CIT 'a',eptr BNE Error
                    INV eptr CIT 'g',eptr BNE Error
                    INV eptr CIT 'e',eptr BNE Error
                      LDZ pc+0 NEG STZ Z0 ADV pc              ; int delta = (-(pc & 0xff)) & 0xff; pc += delta;
      p2_pageok:      CIZ 1,isemit BNE p2_next
                        AZV Z0,mc JPA p2_next                 ; set mc only while emitting

    p2_mute:                 CIT 'm',eptr FNE p2_emit
                    INV eptr CIT 'u',eptr BNE Error
                    INV eptr CIT 't',eptr BNE Error
                    INV eptr CIT 'e',eptr BNE Error
                      CLZ isemit JPA p2_next
    p2_emit:                 CIT 'e',eptr BNE Error
                    INV eptr CIT 'm',eptr BNE Error
                    INV eptr CIT 'i',eptr BNE Error
                    INV eptr CIT 't',eptr BNE Error
                      MIZ 1,isemit JPA p2_next
    p2_testlen4:  CIZ 4,elen BNE Error                        ; Error: Invalid pre-proc
                             CIT 'o',eptr BNE Error
                    INV eptr CIT 'r',eptr BNE Error
                    INV eptr CIT 'g',eptr BNE Error
                      INV eptr MVV eptr,ep JPS findelem
                      CIZ 2,elen BLE Error                    ; anything between 0x1 and 0xffff is okay
                      CIZ 6,elen BGT Error
                        MVV ep,eptr CIT '0',eptr BNE Error
                        INV eptr CIT 'x',eptr BNE Error
                        INV eptr MVV eptr,_ReadPtr
                        JPS _ReadHex
                        CIZ 0xf0,_ReadNum+2 BEQ Error         ; valid result parsed?
                          MVV _ReadNum,pc                     ; copy valid result
                          LDZ _ReadPtr+0 SUZ eptr+0           ; number of hex digits
                          ADI 2 CPZ elen BNE Error            ; 0x + digits = elen? (valid hex constant)
                            CIZ 1,isemit BNE p2_next
                              MVV pc,mc JPA p2_next           ; set mc only while emitting

  p2_parse:     LDZ args ANI 0x0f                             ; PARSE ARG-SPECIFICALLY, use lower nibble
                CPI 0 BEQ p2_arg0
                  CPI 1 BEQ p2_arg1
                    CPI 2 BEQ p2_arg2
                      CPI 3 BEQ p2_arg3

    p2_arg4:      JPS parseexpr                               ; *** EXPECT FAST JUMP ***
                  CIZ 1,isop BEQ Error                        ; Error: Operator not allowed in expression
                  CIZ 1,ismsb BEQ Error
                  CIZ 1,islsb FEQ p2_arg4ok
                  CZZ expr+1,pc+1 BNE Error                   ; matching MSBs?
      p2_arg4ok:    INV pc
                    CIZ 1,isemit BNE p2_nextarg
                      LDZ expr+0 STT mc INV mc                ; emit LSB
                      JPA p2_nextarg

    p2_arg3:      JPS parseexpr                               ; *** EXPECT WORD ***
                  CIZ 1,isop BEQ Error
                  CIZ 1,islsb FNE p2_arg3m
      p2_reuse2:    INV pc
                    CIZ 1,isemit FNE p2_reuse
                      LDZ expr+0 STT mc INV mc                ; emit LSB
      p2_reuse:     LDZ args ANI 0xf0 ORI 0x01 STZ args       ; args = (args & 0xf0) | 0x01
                    JPA p2_next
      p2_arg3m:   CIZ 1,ismsb FNE p2_arg3w
                    INV pc
                    CIZ 1,isemit FNE p2_reuse
                      LDZ expr+1 STT mc INV mc                ; emit MSB
                      FPA p2_reuse
      p2_arg3w:   CIZ 1,isword FNE p2_arg3c
                    AIV 2,pc
                    CIZ 1,isemit BNE p2_nextarg
                      LDZ expr+0 STT mc INV mc                ; emit LSB
                      LDZ expr+1 STT mc INV mc                ; emit MSB
                      JPA p2_nextarg
      p2_arg3c:   CIZ 0x00,expr+1 FEQ p2_reuse2
                  CIZ 0xff,expr+1 BNE Error
                    LDZ expr+0 ANI 0x80 CPI 0x80 FEQ p2_reuse2
                      JPA Error

    p2_arg2:      JPS parseexpr                               ; *** EXPECT ZERO-PAGE ***
                  CIZ 1,isop BEQ Error                        ; Error: Operator not allowed in expression
                  CIZ 1,ismsb BEQ Error
                  CIZ 1,islsb BEQ p2_arg4ok
                    CIZ 0,expr+1 BEQ p2_arg4ok                ; MSB != 0x00?
                      JPA Error                               ; Error: Expecting a zero-page argument

    p2_arg1:      JPS parseexpr                               ; *** EXPECT BYTE ***
                  CIZ 1,islsb BEQ p2_arg4ok                   ; goto emit LSB
                  CIZ 1,ismsb BNE p2_arg1w
                    INV pc
                    CIZ 1,isemit BNE p2_nextarg
                      LDZ expr+1 STT mc INV mc                ; emit MSB
                      JPA p2_nextarg
      p2_arg1w:   CIZ 1,isop BEQ Error
                  CIZ 1,isword BEQ Error
                    CIZ 0x00,expr+1 BEQ p2_arg4ok             ; goto emit LSB
                      CIZ 0xff,expr+1 BNE Error
                      LDZ expr+0 ANI 0x80
                      CPI 0x80 BEQ p2_arg4ok                  ; goto emit LSB
                        JPA Error                             ; Error: xpecting byte expression

    p2_arg0:      CIZ 3,elen FLE p2_arg0ex                    ; *** EXPECT ANYTHING ***
                  CIT "'",ep FEQ p2_arg0qu
                  CIT '"',ep FNE p2_arg0ex                    ; treat as expression
      p2_arg0qu:    INV ep SIZ 2,elen                         ; consume leading "
                    AZV elen,pc                               ; pc += elen-2
        p2_arg0nx:  LDT ep STT mc
                    INV ep INV mc DEZ elen FGT p2_arg0nx      ; copy the string
                      JPA p2_next

      p2_arg0ex:  JPS parseexpr                               ; handle expression
                  CIZ 1,isop BNE p2_arg0l
                    RZP expr,>arguments,1 STZ args            ; access FLASH argument data on bank 1
                    FPA p2_arg0ok                             ; reuse
      p2_arg0l:   CIZ 1,islsb FEQ p2_arg0ok                   ; goto emit LSB without arg-shifting
                  CIZ 1,ismsb FNE p2_arg0w
                    INV pc
                    CIZ 1,isemit BNE p2_next
                      LDZ expr+1 STT mc INV mc                ; emit MSB without arg-shifting
                      JPA p2_next
      p2_arg0w:   CIZ 1,isword FNE p2_arg0e
                    AIV 2,pc
                    CIZ 1,isemit BNE p2_next
                      LDZ expr+0 STT mc INV mc                ; emit LSB without arg-shifting
                      LDZ expr+1 STT mc INV mc                ; emit MSB without arg-shifting
                      JPA p2_next
      p2_arg0e:   CIZ 0x00,expr+1 FEQ p2_arg0ok
                  CIZ 0xff,expr+1 BNE Error
                  LDZ expr+0 ANI 0x80
                  CPI 0x80 BNE Error
      p2_arg0ok:    INV pc
                    CIZ 1,isemit BNE p2_next
                      LDZ expr+0 STT mc INV mc                ; emit LSB without arg-shifting
                      JPA p2_next

  p2_nextarg:   LDZ args RL5 ANI 0x0f STZ args                ; args >>= 4 (consume argument, advance pipeline)
                JPA p2_next

; ****************************
; *****                  *****
; ***** HELPER FUNCTIONS *****
; *****                  *****
; ****************************

; ----------------------------------------------------------------------------------
; prints out an error message containing the line number and the "erroneous element"
; ----------------------------------------------------------------------------------
Error:        JPS _Print 'Error in line ', 0
              JPS linenr JPS _Print ': "', 0
  er_loop:    DEZ elen BCC er_endelem                         ; print out erroneous element
                LDT ep JAS _PrintChar
                INV ep FPA er_loop
  er_endelem: JPS _Print '"', 10, 0
              JPA _Prompt

; --------------------------------------------------------------
; parses for an expression
; pass 1 (doparse = 0): only sets descriptive flags
; pass 2: (doparse = 1): also computes expression value
; prior to calling, check for: label-def, long strings, pre-proc
; needs: isparse, isemit, ep, elen
; modifies: eptr, sign, term, expr, islsb, ismsb, isword, isop,
;           Z0..1, _ReadPtr, _ReadNum
; --------------------------------------------------------------
parseexpr:      CLZ isop CLZ isword CLZ islsb CLZ ismsb       ; reset parse flags
                MVV ep,eptr LDZ elen JAS OpCode               ; Test for pure mnemonic (eptr, A=elen  => result in A)
                CPI 0xff FEQ pe_notop
                  STZ expr+0 MIZ 1,isop RTS                   ; SUCCESS
  pe_notop:     CLV expr                                      ; init expression, eptr = start of expression
                CIT '<',eptr FNE pe_testmsbop                 ; parse for a leading < or >
                  MIZ 1,islsb FPA pe_eatlsbmsb
  pe_testmsbop: CIT '>',eptr FNE pe_exprloop
                  MIZ 1,ismsb
  pe_eatlsbmsb: INV eptr                                      ; consume leading < or >
  pe_exprloop:  CLV term MIZ '+',sign                         ; PARSE EXPRESSION PARTS
                LDT eptr CPI '+' BEQ pe_eatsign               ; parse for a sign
                  CPI '-' BNE pe_testchar
                    STZ sign
  pe_eatsign:   INV eptr                                      ; consume sign

  pe_testchar:  LDT eptr CPI '"' FEQ pe_isquote               ; parse 'A'
                  CPI "'" BNE pe_testhex
    pe_isquote: STZ Z0                                        ; store quotation start marker
                CIZ 3,elen BCC Error                          ; Error '...' in expr
                  INV eptr LDT eptr STZ term                  ; store the char as lsb of term
                  INV eptr LDT eptr CPZ Z0 BNE Error          ; Error wrong quotation end marker
                    INV eptr JPA pe_addterm                   ; consume end quotation

  pe_testhex:   CIT '0',eptr FNE pe_dostar                    ; check for 0x...
                  MVV eptr,_ReadPtr INV _ReadPtr              ; consume 0 (may also be a decimal 0)
                  CIT 'x',_ReadPtr FNE pe_latedeci            ; entry into decimal number 0123...?
                    INV _ReadPtr JPS _ReadHex                 ; consume x, _ReadPtr points beyond hex number
                    CIZ 0xf0,_ReadNum+2 BEQ Error             ; valid result?
                      MVV _ReadNum,term                       ; copy valid result
                      LDZ _ReadPtr+0 SUZ eptr+0
                      CPI 4 FLE pe_hexbyte                    ; if (k-x > 4 && lsbmsb == 0) lsbmsb = 'w';
                        MIZ 1,isword                          ; it's a word!
  pe_hexbyte:         MVV _ReadPtr,eptr JPA pe_addterm        ; advance over hex

  pe_dostar:    CIT '*',eptr FNE pe_dodecimal                 ; check for * location symbol
                    MVV mc,term MIZ 1,isword                  ; consume *
                    INV eptr JPA pe_addterm                   ; advance over *

  pe_dodecimal: CIT '0',eptr FCC pe_dolabel                   ; decimal number (test this only after 0x test)
    pe_latedeci:  CIT '9',eptr FGT pe_dolabel
    pe_nextdec:     LLV term MVV term,Z0  	                  ; store 2*term
                    LLV term LLV term AVV Z0,term             ; 10*term = 8*term + 2*term
                    LDT eptr SUI '0' ADV term INV eptr        ; consume this digit
                    CIT '0',eptr BCC pe_addterm               ; next one still decimal?
                      CIT '9',eptr BGT pe_addterm
                        FPA pe_nextdec

  pe_dolabel:   MVV eptr,Z0                                   ; LABEL OR EMBEDDED MNEMONIC?
    frl_test:   LDT Z0                                        ; Z0..1 = end of label (well-defined <= ep + elen)
                CPI ' ' FLE frl_exit                           ; catches ' ' \n \r \t \0
                  CPI '+' FEQ frl_exit
                    CPI '-' FEQ frl_exit
                      CPI ',' FEQ frl_exit
                        CPI ';' FEQ frl_exit
                          CPI ':' FEQ frl_exit
                            INV Z0 FPA frl_test               ; consume label char
    frl_exit:   SVV eptr,Z0                                   ; Z0..1 = length of label/mnemonic
                CIZ 0,Z0 BEQ Error                            ; Error: Empty expression
                  JAS OpCode CPI 0xff FEQ pe_tstlabel         ; A = length
                    STZ term FPA pe_consume
  pe_tstlabel:    MIZ 1,isword
                  CIZ 0,isparse FEQ pe_consume
                    JPS findlabel CPI 0 BEQ Error             ; Error: Unknown reference
                      LDT lptr STZ term+0 DEV lptr            ; extract term from PC value in label database
                      LDT lptr STZ term+1

  pe_consume:   AVV Z0,eptr                                   ; consume this element part, proceed with adding term

  pe_addterm:   CIZ '-',sign FNE pe_positive
                  NEV term
  pe_positive:  AVV term,expr                                 ; expr += sign * term
                LDT eptr CPI '+' BEQ pe_exprloop              ; loop back if a trailing + or - is parsed
                  CPI '-' BEQ pe_exprloop
                SVV enext,eptr ORZ eptr+0 CPI 0 BNE Error     ; CHECK: expression parsed completely?
                  RTS                                         ; SUCCESS

; ----------------------------------------------------------
; Checks whether a mnemonic of length A is present at eptr.
; Mnemonics may have the form ABC or AB.C (tokenized to CAB)
; Additionally, mnemonics are parsed case-insensitively.
; returns A = <opcode> or A = 0xff 'invalid opcode'
; modifies: 0x80..0x8a
; ----------------------------------------------------------
OpCode:         CPI 3 FEQ oc_normal                           ; test for A = length 3 (ABC) or 4 (AB.C)
                  CPI 4 BEQ oc_withdot
                    LDI 0xff RTS                              ; return "not a mnemonic"
  oc_normal:    MVV eptr,0x84                                 ; setup pointers A,B,C of ABC
                MVV 0x84,0x86 INV 0x86
                MVV 0x86,0x88 INV 0x88
                FPA op_continue
  oc_withdot:     MVV eptr,0x84 AIV 2,0x84                    ; check for dot in correct position
                  CIT '.',0x84 FNE oc_isnt0
                    INV 0x84 MVV eptr,0x86                    ; setup pointers C,A,B of AB.C
                    MVV 0x86,0x88 INV 0x88
  op_continue:  MIV mnemonics,0x80 MIZ 1,0x82                 ; 0x80..2 = start of mnemonic (token) table in FLASH
                CLZ 0x83                                      ; init opcode register
  oc_compare:   RDR 0x0080 STZ 0x8a                           ; read first letter of mnemonic from table
                LDT 0x84 CPI 64 FLE oc_ep0 ANI 0xdf           ; erasing bit 5 (value 32) converts to upper-case
  oc_ep0:       CPZ 0x8a FNE oc_isnt0
                  INV 0x80 RDR 0x0080 STZ 0x8a
                LDT 0x86 CPI 64 FLE oc_ep1 ANI 0xdf
  oc_ep1:       CPZ 0x8a FNE oc_isnt1
                  INV 0x80 RDR 0x0080 STZ 0x8a
                LDT 0x88 CPI 64 FLE oc_ep2 ANI 0xdf
  oc_ep2:       CPZ 0x8a FNE oc_isnt2
                  LDZ 0x83 RTS                                ; success => return opcode
  oc_isnt0:     AIV 3,0x80 FPA oc_next                        ; stride over unparsed part of table mnemonic
  oc_isnt1:     AIV 2,0x80 FPA oc_next
  oc_isnt2:     INV 0x80
  oc_next:      INZ 0x83 CPI 0xff BNE oc_compare
                  RTS                                         ; failure => return 0xff (no mnemonic)

; --------------------------------------------------------------------------
; stores label definition (including :) and its PC value at the current lptr
; position in database in reversed order: 0, MSB, LSB, ':', 'lebal'.
; Call 'findlabel' to check whether the label existis and to find free slot.
; --------------------------------------------------------------------------
putlabel:       MVV ep,eptr LDT eptr CPI ':' FEQ pl_exit      ; do not store empty labels
  pl_copy:        STT lptr INV eptr DEV lptr                  ; store label including : backwards
                  LDT eptr CPI ':' FNE pl_copy
                             STT lptr DEV lptr                ; store ':' end marker and move down
                    LDZ pc+0 STT lptr DEV lptr
                    LDZ pc+1 STT lptr DEV lptr
                    MIT 0,lptr                                ; write table endmarker into free pos
                    CIZ >asm_end,lptr+1 FGT pl_exit
                      CIZ <asm_end,lptr+0 FGT pl_exit
                        JPS _Print "Out of memory.", 10, 0
                        JPA _Prompt
  pl_exit:      RTS

; ----------------------------------------------------------------------
; Searches label database for a match with label of length Z0..1 at eptr
; (eptr and Z0..1 are not changed)
; returns: not found: A=0, lptr points at end of table
;          found      A=1, lptr points at LSB of label PC
; modifies: Z2, Z3..4, lptr
; ----------------------------------------------------------------------
findlabel:      MIV labels,lptr                               ; label pointer to start of label table
  fl_nextl:     CIT 0,lptr FEQ fl_labelsend
                  MVV eptr,Z3 MZZ Z0,Z2                       ; Z3..4 = start of element of length Z2
  fl_nextc:     LDT lptr CPT Z3 FNE fl_noteq
                  DEV lptr INV Z3 DEZ Z2 FGT fl_nextc
                    CIT ':',lptr FEQ fl_found                 ; label ended, stored label end, too?
  fl_searchend:   DEV lptr LDT lptr                           ; didn't end => move over nonzero char and search end
  fl_noteq:       CPI ':' FNE fl_searchend                    ; find end of label that isn't matching
  fl_labelend:      SIV 3,lptr FPA fl_nextl                   ; advance over LSB, MSB to next label
  fl_labelsend: LDI 0 RTS                                     ; NOT FOUND => lptr points to label table's EOF
  fl_found:     DEV lptr LDI 1 RTS                            ; lptr points to PC_LSB

; ---------------------------------------------------
; prints out the line number of current 'ep' position
; ---------------------------------------------------
linenr:         MIW 0x0001,ln_num
                MIW source,ln_ptr                             ; point to start of source
  ln_loop:      CZB ep+0,ln_ptr+0 BNE ln_noteq
                  CZB ep+1,ln_ptr+1 BNE ln_noteq
                    MIZ '0',0x80                              ; ep is reached => print dec line number
  p100loop:         SIW 100,ln_num BCC p99end100
                      INZ 0x80 JPA p100loop
  p99end100:        AIW 100,ln_num                            ; correct it
                    LDZ 0x80 JAS _PrintChar                   ; print 100er
                    MIZ '0',0x80
  p10loop:          SIB 10,ln_num+0 BCC p99end10
                      INZ 0x80 JPA p10loop                    ; correct it
  p99end10:         LDZ 0x80 JAS _PrintChar                   ; print 10er
                    LDB ln_num+0 ADI 58 JAS _PrintChar        ; '0' + 10 correction
                    RTS
  ln_noteq:     CIR 10,ln_ptr BNE ln_noenter                  ; count LFs
                  INW ln_num                                  ; count up for ENTER
  ln_noenter:   INW ln_ptr JPA ln_loop
  ln_ptr:       0xffff                                        ; local source pointer
  ln_num:       0xffff

; -------------------------------------------------------------------------------------------------------------
; finds the next element starting at ep pointing into whitespace (typically at the end of the previous element)
; returns: A=0: element EOF, A=-1: invalid element, A=1: valid element (elen=length, enext=pointer beyond)
; -------------------------------------------------------------------------------------------------------------
findelem:       CIT 0,ep FEQ fe_eofelem                       ; check for EOF
                  CPI ' ' FLE fe_moveep CPI ',' FEQ fe_moveep ; move over TAB, SPACE, LF, CR, comma (WHITESPACE)
                    CPI ';' FNE fe_findlength                 ; NON-WHITESPACE encountered
    fe_commloop:      INV ep                                  ; consume comment char
                      CIT 0,ep FEQ fe_eofelem                 ; check for EOF in comment
                        CPI 10 FNE fe_commloop                ; leave comment upon LF
    fe_moveep:    INV ep FPA findelem
  fe_findlength:  MVV ep,elen                                 ; START ELEMENT LENGTH CALCULATION
                  LDT elen CPI '"' FEQ fe_quote
                    CPI "'" FEQ fe_quote
    fe_consume:       INV elen                                ; ... while element goes on...
                      LDT elen CPI 32 FLE fe_retlength
                        CPI ',' FEQ fe_retlength
                          CPI ';' FNE fe_consume
      fe_retlength:         MVV elen,enext SVV ep,elen        ; return valid elen, enext
                            LDI 1 RTS
    fe_eofelem:     LDI 0 RTS                                 ; return "EOF element"
    fe_error:       LDI -1 RTS                                ; return "invalid element length"
  fe_quote:       STZ Z0                                      ; ENTERING QUOTE, store quotation style
    fe_nextquote: INV elen LDT elen CPI 32 FCC fe_error       ; invalid end of "...
                    CPZ Z0 FNE fe_nextquote
                      FPA fe_consume                          ; consume quotation endmarker

asm_end:                                                      ; end of asm (labels database size check!)

#mute                         ; constants

#org 0x8000     source:       ; default beginning of the src code
#org 0x2000     default:      ; default beginning of the program
#org 0x1fff     labels:       ; beginning of temp label buffer, growing downwards (may also use the larger 0x3fff)
#org 0x0c00     arguments:    ; mnemonic arguments on BANK 1 (0x0=any, 0x1=B, 0x2=Z, 0x3=W, 0x4=fjump)
#org 0x0d00     mnemonics:    ; mnemonic token strings on BANK 1

#org 0x0000                   ; zero-page

pc:             0xffff        ; program counter (used in pass 1 and 2)
mc:             0xffff        ; emission counter (used in pass 2 only)
isemit:         0xff          ; toggle switch for code emission (set by #emit, #mute)

args:           0xff          ; argument buffer (each nibble codes an expected argument)
expr:           0xffff        ; holds expression
term:           0xffff        ; holds term value
sign:           0xff          ; holds sign

isparse:        0xff          ; 0: do not evaluate expression (pass 1), 1: evaluate expression (pass 2)
isop:           0xff          ; expression = operator
isword:         0xff          ; label || * || 0x... || dec > 255 || dec < -128
islsb:          0xff          ; < operator
ismsb:          0xff          ; > operator

ep:             0xffff        ; element pointer parsing the source code
elen:           0xffff        ; length of an element
enext:          0xffff        ; = ep + elen
eptr:           0xffff        ; multi-purpose element pointer (= ep + elen)

lptr:           0xffff        ; pointer to free label slot. Format (in reversed order): 'label', ':', 2-byte address
sptr:           0xffff        ; pointer to optional symbol tag
llptr:          0xffff        ; multi-purpose pointer
ssptr:          0xffff        ; multi-purpose pointer

count:          0xff          ; used for counting the number of rows when printing labels with -s

#org 0x0090     Z0:           ; OS registers
#org 0x0091     Z1:
#org 0x0092     Z2:
#org 0x0093     Z3:

#org 0xf003 _Prompt:
#org 0xf01b _SkipSpace:
#org 0xf01e _ReadHex:
#org 0xf02a _LoadFile:
#org 0xf042 _PrintChar:
#org 0xf045 _Print:
#org 0xf04b _PrintHex:
#org 0x00c6 _ReadNum:
#org 0x00c9 _ReadPtr:
