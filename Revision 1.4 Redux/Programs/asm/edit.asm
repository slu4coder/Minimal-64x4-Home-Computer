; ---------------------------------------------------
; Minimal Text Editor for the 'Minimal 64x4 Computer'
; written by Carsten Herting - last update 10.02.2025
; ---------------------------------------------------

; CHANGE LOG
; o converted code to faster zero-page instructions where possible

; LICENSING INFORMATION
; This file is free software: you can redistribute it and/or modify it under the terms of the
; GNU General Public License as published by the Free Software Foundation, either
; version 3 of the License, or (at your option) any later version.
; This file is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the
; implied warranty of MERCHANMBBILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public
; License for more details. You should have received a copy of the GNU General Public License along
; with this program. If not, see https://www.gnu.org/licenses/.

#org 0x0100

Editor:       MIB 0xfe,0xffff                                    ; init the stack pointer
              CIB 1,iscoldstart FNE warmstart                    ; is it a warmstart
                CLB iscoldstart CLB DATABUF                      ; invalidate text data only at first (cold) start
                MIV COPYEND,copyptr                              ; invalidate copied data
                MIW namebuf,nameptr                              ; invlaidate pointer to end of filename in filebuf
                CLB namebuf                                      ; invalidate any filename

  warmstart:  JPS _SkipSpace                                     ; parse command line: skip spaces after 'edit/run   filename'
              CIT 32,_ReadPtr FLE mainload                       ; FILENAME following 'edit' in command line?
                MVV _ReadPtr,strcpy_s                            ; prepare copy of filename into buffer
                MIV namebuf,strcpy_d
                JPS _LoadFile                                    ; load it with filename in _ReadPtr
                CPI 1 FEQ loaddone                               ; everything okay?
                  LDI '?' JAS _PrintChar
                  LDI 10 JAS _PrintChar                          ; ENTER
                  JPA _Prompt
    loaddone:   MIT 0,_ReadPtr                                   ; LOADED! => truncate rest of command line
                JPS strcpy                                       ; copy filename into name buffer
                MZB strcpy_d+0,nameptr+0                         ; copy nameptr (pointing to end of file)
                MZB strcpy_d+1,nameptr+1

; ------------------------------------------------------------

  mainload:   CLV markptr                                        ; jump here after LOAD
              CLZ cptr+0 CLZ tptr+0                              ; init cursor to top of file
              MIZ >DATABUF,cptr+1 SDZ tptr+1
              CLZ xcur CLZ ycur CLZ xorg
              MIZ 1,yorg+0 CLZ yorg+1                            ; yorg = 1
              CLZ changed
              JPS pullline
              MIZ 3,redraw                                       ; redraw all

  mainclear:  CLZ state

  mainloop:   LDZ state                                          ; process according to the editor's state
              CPI 0 BEQ StateChar
                CPI 'N' BEQ StateNew
                  CPI 'L' BEQ StateLoad
                    CPI 'S' BEQ StateSave
                      JPA StateReceive

; ------------------------------------------------------------
; SCREEN REFRESH
; ------------------------------------------------------------

  DrawLine:     CLZ _XPos MZZ ycur,_YPos                         ; REDRAW = 1: DRAW CURRENT LINE
                MVV yorg,pu_len
                AZV ycur,pu_len
                MIZ 1,pu_n JPS Print999                          ; draw only current line (pu_len, pu_n=1)
                CLZ pc_ptr+0                                     ; pc_ptr -> line buffer start
                MIZ >LINEBUF,pc_ptr+1
    ud_while2:  CIT 10,pc_ptr FLE ud_linret
                  LDZ pc_ptr+0 CPZ xorg FCC ud_notprnt
                    SUI <WIDTH-4 FCC ud_doprnt
                      CPZ xorg FCS ud_notprnt
    ud_doprnt:      LDT pc_ptr JAS _Char INZ _XPos
    ud_notprnt: INZ pc_ptr+0 FPA ud_while2
    ud_linret:  JPS _ClearRow
                JPA DrawCursor                                   ; clear remaining row

; ------------------------------------------------------------

; ------------------------------------------------------------
; Inverts a character at position (_XPos, _YPos) without changing _XPos or _YPos
; ------------------------------------------------------------
InvertChar:     LDI <VIEWPORT ADZ _XPos
                SDB in_index+1 SDB in_indey+1                    ; index to video position of char
                LDZ _YPos LL1 ADI >VIEWPORT
                SDB in_index+2 INC SDB in_indey+2                ; multiply y with 8*64 = 512
  in_index:     NOB 0xffff                                       ; invert video RAM
  in_indey:     NOB 0xffff                                       ; invert video RAM
                AIB 64,in_index+1 SDB in_indey+1                 ; move down one pixel row
                FCC in_index                                     ; plot 2x4 bytes
  in_exit:        RTS

; ------------------------------------------------------------
; copies the content of a source string at 'strcpy_s' to a
; destination at 'strcpy_d' (no overlap allowed! no safety!)
; ------------------------------------------------------------
strcpy:         MTT pu_sptr,pu_dptr CPI 0 FEQ strcpyend
                  INV pu_sptr INV pu_dptr FPA strcpy
  strcpyend:    RTS

; ------------------------------------------------------------

#page

Update:       LDZ xcur SUI <WIDTH-4-1 FCC ud_usexorg             ; check whether cursor has moved outside viewport
                CPZ xorg FCS ud_usexmin
  ud_usexorg: LDZ xorg
  ud_usexmin: CPZ xcur FCC ud_useit
                LDZ xcur
  ud_useit:   CPZ xorg FEQ ud_notnew
                SDZ xorg
                JPS pushline
                AIZ 2,redraw                                     ; force at least text redraw (full redraw after POS1 or END)

  ud_notnew:  LDZ redraw                                         ; switch case redraw
              CPI 0 BEQ MoveCursor
                CPI 1 BEQ DrawLine
                  CPI 2 BEQ DrawText

  DrawAll:      CLV _XPos                                        ; REDRAW >= 3: WHOLE SCREEN
                MVV yorg,pu_len
                MIZ <HEIGHT,pu_n JPS Print999                    ; set number of line numbers to print

  DrawText:     MVV tptr,pc_ptr                                  ; REDRAW = 2: DRAW ALL TEXT, top pointer tptr -> current ptr
                MIZ <HEIGHT,pc_n                                 ; print all rows starting from top
                CLZ _YPos                                        ; cursor to top

    ud_newline: DEZ pc_n BCC DrawCursor
                  MVV pc_ptr,pc_sptr                             ; current ptr -> line start sptr
                  MIZ 4,_XPos                                    ; set cursor to line start
    ud_while:     LDT pc_ptr CPI 10 FGT ud_normal                ; either EOL or EOF
                    FNE ud_clear                                 ; test EOF
                      JPS _ClearRow                              ; ENTER
                      INZ _YPos INV pc_ptr
                      FPA ud_newline 
      ud_normal:  SDB ud_print+1                                 ; deposit char for printing
                  LDZ pc_ptr+0 SUZ pc_sptr+0                     ; determin if char is visible
                  CPZ xorg FCC ud_consume
                    SUI <WIDTH-4 FCC ud_print
                      SUZ xorg FCS ud_consume
      ud_print:     LDI 0xcc JAS _Char INZ _XPos                 ; print the visible char (return = clear)
    ud_consume:   INV pc_ptr FPA ud_while

    ud_clear:     JPS _ClearRow                                  ; EOF
                  MIZ 4,_XPos
                  INZ _YPos CPI <HEIGHT FCC ud_clear             ; clear the remaining lines of the screen
                    JPA DrawCursor

; ------------------------------------------------------------

  MoveCursor:   JPS InvertChar                                   ; REDRAW = 0: JUST HANDLE CURSOR POSITION, clear old cursor
  DrawCursor:   CLZ redraw                                       ; required by callers of DrawCursor
                MZZ ycur,_YPos                                   ; invert char at cursor position
                LDZ xcur SUZ xorg ADI 4
                SDZ _XPos JPS InvertChar
                RTS

; ------------------------------------------------------------
; INPUT HANDLER FOR NORMAL INPUT
; ------------------------------------------------------------

StateChar:  JPS Update                                           ; check if redraw is needed but always draw cursor
            JPS _WaitInput                                       ; get char
            CPI 8 BEQ pc_BackSp                                  ; BACKSPACE
            CPI 9 BEQ pc_Tab                                     ; convert MBBULATOR to SPACE
            CPI 27 BEQ pc_CtrlQ                                  ; ESC = CTRL+Q
            CPI 13 BEQ mainloop                                  ; discard CR
            CPI 0xe0 BCC pc_default                              ; 0xe0 - 0xfe are custom function keys (see PS2 table)
              SUI 0xe0 LL1                                       ; calculate table index (x2 due to words)
              JAR jumptable                                      ; jump to *(jumptable+A)

              ; JUMP M.BBLE FOR HANDLING SPECIAL FUNCTION KEYS
  jumptable:  pc_CtrlQ, pc_Up, pc_Down, pc_Left, pc_Right, pc_Pos1, pc_End, pc_PgUp, pc_PgDown ; 0xe0-0xe8
              pc_CtrlA, pc_CtrlX, pc_CtrlC, pc_CtrlV, pc_CtrlL, pc_CtrlS, pc_CtrlN, pc_Delete ; 0xe9-0xf0
              pc_CtrlR, pc_CtrlT                                 ; 0xf1 - 0xf2

; ------------------------------------------------------------

  pc_CtrlA:     MVV tptr,marktptr                                ; save tptr
                MVV yorg,markyorg                                ; save yorg
                MVV cptr,markptr                                 ; save cptr + xcur as cursor pos in text
                MZZ xcur,markx ADV markptr                       ; save cursor x/y
                MZZ ycur,marky
                JPA mainloop

; ------------------------------------------------------------

  pc_CtrlX:     JPS pushline                                     ; update data with current line
                JPS CopyMarked
                CIZ <COPYEND,copyptr+0 FNE pc_n42ok
                  CIZ >COPYEND,copyptr+1 BEQ mainloop            ; has something been saved?
    pc_n42ok:       MVV cptr,pc_sptr
                    AZV xcur,pc_sptr                             ; pc_sptr = current cursor position
                    LDI 0 PHS LDZ pc_sptr+0 PHS LDZ pc_sptr+1 PHS
                    JPS length PLS                               ; get rest length of text to shift
                    PLS SDZ pc_ptr+1 PLS SDZ pc_ptr+0 INV pc_ptr ; pc_ptr = number of bytes to shift (incl. 0)
                    LDZ markptr+0 PHS LDZ markptr+1 PHS          ; push destination
                    LDZ pc_sptr+0 PHS LDZ pc_sptr+1 PHS          ; push sources
                    LDZ pc_ptr+0 PHS LDZ pc_ptr+1 PHS            ; push number of bytes to move
                    JPS _MemMove AIB 6,0xffff                    ; move and clean up stack
                MVV marktptr,tptr
                MVV markyorg,yorg
                MVV markptr,cptr
                MZZ markx,xcur SUV cptr MZZ marky,ycur
  pc_reuse2:    JPS pullline
                JPS _ResetPS2                                    ; clears ALT, CTRL, SHIFT key status
                MIZ 3,redraw
                JPA mainloop

; ------------------------------------------------------------

  pc_CtrlC:     JPS pushline
                JPS CopyMarked
                JPA mainloop

; ------------------------------------------------------------

  pc_CtrlV:     JPS pushline
                MVV cptr,pc_ptr
                AZV xcur,pc_ptr                                  ; pc_ptr = address of current cursor position in the line
                LDI 0 PHS                                        ; find remaining data length until (and excluding here) 0
                MZZ pc_ptr+0,pc_dptr+0 PHS                       ; pc_dptr = source for move, destination for insert
                MZZ pc_ptr+1,pc_dptr+1 PHS
                JPS length PLS
                PLS SDZ pc_sptr+1 PLS SDZ pc_sptr+0              ; pc_sptr = bytesize of remaining text that needs shifting
                INZ pc_sptr                                      ;           increase for zero-terminator!
                MIV COPYEND,pu_len                               ; pu_len = bytesize of clipboard data
                SVV copyptr,pu_len
                AVV pu_len,pc_ptr                                ; pc_ptr = move destination address
                LDZ pc_ptr+0 PHS LDZ pc_ptr+1 PHS                ; push move destination
                LDZ pc_dptr+0 PHS LDZ pc_dptr+1 PHS              ; push move source
                LDZ pc_sptr+0 PHS LDZ pc_sptr+1 PHS              ; push move anzahl
                JPS _MemMove AIB 6,0xffff                        ; move exisiting text to pc_ptr

                ; move the reverse stuff into text, update cptr, xcur, ycur, yorg and tptr char by char

                MIV COPYEND,pc_ptr                               ; pc_ptr = source at top of clipboard
  ctrlv_loop:   DEV pu_len BCC pc_reuse2                         ; insert the backwards clipboard and *** exit *** here
                  MTT pc_ptr,pc_dptr                             ; copy a char starting at cursor pos
                  CPI 10 FEQ pc22enter                           ; was it an ENTER?
                    INZ xcur JPA pc22done                        ; no ENTER -> only move cursor left
    pc22enter:    CLZ xcur                                       ; ENTER-Event!
                  LDZ cptr+0 PHS LDZ cptr+1 PHS
                  JPS getnext                                    ; modifies pc_sptr!!!
                  PLS SDZ cptr+1 PLS SDZ cptr+0
                  CIZ <HEIGHT-1,ycur FCS pc22doorg               ; was cursor at the bottom?
                    INZ ycur JPA pc22done                        ; no bottom -> only move cursor down
    pc22doorg:    INV yorg                                       ; move origin down
                  LDZ tptr+0 PHS LDZ tptr+1 PHS
                  JPS getnext                                    ; modifies pc_sptr!!!
                  PLS SDZ tptr+1 PLS SDZ tptr+0
    pc22done:     INV pc_dptr DEV pc_ptr                         ; advance to next char, got down clipboard data
                  JPA ctrlv_loop

; ------------------------------------------------------------

  pc_CtrlQ:     JPS pushline
                JPS _Clear
                CLV _XPos
                JPA _Prompt

; ------------------------------------------------------------

  pc_CtrlR:     MIZ 'R',state                                    ; RECEIVE
                JPS InvertChar                                   ; delete old cursor
                MIV COPYEND,copyptr                              ; reset copyptr
                CLV _XPos JPS _ClearRow
                JPS _Print 'RECEIVE (ESC) ', 0
                JPA mainloop

; ------------------------------------------------------------
                                                                 ; TRANSMIT FILE
  pc_CtrlT:     LDI 10 OUT                                       ; ENTER
                MIV DATABUF,Z3
    loopT:      CIT 0,Z3 FEQ endT                                ; = LDT .. CPI ..
                  OUT INV Z3 JPA loopT
    endT:       LDI 10 OUT                                       ; ENTER
                JPA rd2mainclear

; ------------------------------------------------------------

  pc_CtrlL:     MIZ 'L',state                                    ; change state to L
                JPS InvertChar                                   ; delete current cursor
                JPS pushline                                     ; from here on same for L and S
                CLV _XPos JPS _ClearRow                          ; clears both X and Y position
                JPS _Print 'LOAD ', 0
                JPA pc_doname

; ------------------------------------------------------------

  pc_CtrlS:     MIZ 'S',state
                JPS InvertChar                                   ; delete current cursor
    pc_AbortS:  JPS pushline
                CLV _XPos JPS _ClearRow
                JPS _Print 'SAVE ', 0
    pc_doname:  MIV namebuf,Z3 JPA pc_entry
    pc_loop:      JAS _PrintChar INV Z3
    pc_entry:   CIT 0,Z3 FNE pc_loop
                  JPS InvertChar                                 ; put new cursor
                  JPA mainloop

; ------------------------------------------------------------

  pc_CtrlN:     MIZ 'N',state                                    ; NEW
                JPS pushline
                JPS InvertChar                                   ; delete old cursor
                CLV _XPos JPS _ClearRow
                JPS _Print 'NEW (y/n)', 160, 0                   ; put new cursor
                JPA mainloop

; ------------------------------------------------------------

  pc_BackSp:    CLV markptr
                MIZ 1,redraw
                CIZ 0,xcur FEQ pc_8else
                  DEZ xcur PHS LDI >LINEBUF PHS                  ; case xcur > 0
                  JPS cutchar PLS PLS
                  MIZ 1,changed
                  JPA mainloop
    pc_8else:   LDZ cptr+0 PHS LDZ cptr+1 PHS JPS getprev        ; case xcur = 0
                PLS SDZ pc_ptr+1 PLS SDZ pc_ptr+0                ; pc_ptr = prev
                CPZ cptr+0 FNE pc_8if
                  CZZ pc_ptr+1,cptr+1 BEQ mainloop
    pc_8if:         JPS pushline                                 ; prev != cptr -> alles okay
                    LDI 10 PHS LDZ pc_ptr+0 PHS LDZ pc_ptr+1 PHS
                    JPS length PLS PLS PLS SDZ pc_n              ; pc_n = length of prev exclusive return
                    LDI 10 PHS LDZ cptr+0 PHS LDZ cptr+1 PHS
                    JPS length PLS PLS PLS                       ; length of cptr exclusive return
                    ADZ pc_n BCS mainloop CPI 254 BCS mainloop   ; test l0 + l1 < 254
                      DEV cptr
                      LDZ cptr+0 PHS LDZ cptr+1 PHS
                      JPS cutchar PLS PLS
                      DEZ ycur
                      MZZ pc_n,xcur
                      MVV pc_ptr,cptr                            ; cptr = prev
                      JPA pc_reuse2

; ------------------------------------------------------------

  pc_Delete:    CLV markptr
                MZZ xcur,pc_dptr+0 MIZ >LINEBUF,pc_dptr+1
                LDT pc_dptr CPI 10 FNE pc_127else
                  JPS pushline                                   ; case delete an '\n'
                  LDZ cptr+0 PHS LDZ cptr+1 PHS JPS getnext
                  PLS SDZ pc_ptr+1 PLS SDZ pc_ptr+0              ; pc_ptr = next
                  LDI 10 PHS LDZ pc_ptr+0 PHS LDZ pc_ptr+1 PHS
                  JPS length PLS PLS PLS SDZ pc_n                ; length of next line
                  LDI 10 PHS LDZ cptr+0 PHS LDZ cptr+1 PHS
                  JPS length PLS PLS PLS                         ; length of this line
                  ADZ pc_n BCS mainloop CPI 254 BCS mainloop
                    DEV pc_ptr                                   ; next - 1
                    LDZ pc_ptr+0 PHS LDZ pc_ptr+1 PHS
                    JPS cutchar PLS PLS
                    JPA pc_reuse2
    pc_127else: CPI 0 BEQ mainloop                               ;  do not cut the very last zero in the file
                  LDZ xcur PHS LDI >LINEBUF PHS
                  JPS cutchar PLS PLS
                  MIZ 1,changed MIZ 1,redraw
                  JPA mainloop

; ------------------------------------------------------------

  pc_Tab:     LDI 32                                             ; TAB = SPACE, then goto default

; ------------------------------------------------------------

  pc_default: SDZ Z3                                             ; getchar -> X
              LDI 0 PHS PHS LDI >LINEBUF PHS                     ; DEFAULT (including ENTER)
              SDZ pc_sptr+1 SDZ pc_dptr+1
              JPS length PLS PLS                                 ; pc_sptr = source = lenght of line (index points to terminating zero)
              PLS CPI 254 BCS mainloop
                SDZ pc_sptr+0
                INC SDZ pc_dptr+0                                ; pc_dptr = destination = pc_sptr + 1 (one beyond)
    pc_forlp: LDZ pc_sptr+0 CPZ xcur FCC pc_endf                 ; shift the line content to the right including xcur index
                MTT pc_sptr,pc_dptr
                DEZ pc_dptr+0 DEZ pc_sptr+0 FCS pc_forlp
    pc_endf:  MIZ 1,changed                                      ; mark es changed
              MZT Z3,pc_dptr                                     ; now put in the new character
              CPI 10 FNE pc_not10
                JPS pushline
                LDZ cptr+0 PHS LDZ cptr+1 PHS JPS getnext        ; cptr = getnext(cptr)
                PLS SDZ cptr+1 PLS SDZ cptr+0
                CIZ <HEIGHT-1,ycur FCS pc_bottom
                  INZ ycur
                  FPA pc_daswars
    pc_bottom:  LDZ tptr+0 PHS LDZ tptr+1 PHS JPS getnext        ; tptr = getnext(tptr)
                PLS SDZ tptr+1 PLS SDZ tptr+0
                INV yorg
    pc_daswars: JPS pullline
                CLZ xcur LDI 2    ; draw all
                JPA pc_dend
    pc_not10: INZ xcur LDI 1      ; draw line
    pc_dend:  SDZ redraw
              CLV markptr
              JPA mainloop

; ------------------------------------------------------------

  pc_Up:        JPS pushline
                LDZ cptr+0 PHS LDZ cptr+1 PHS JPS getprev
                PLS SDZ pc_ptr+1 PLS SDZ pc_ptr+0
                CPZ cptr+0 FNE csi_ain
                  LDZ pc_ptr+1 CPZ cptr+1 BEQ mainclear          ; leave if
    csi_ain:        MVV pc_ptr,cptr
                      CIZ 0,ycur FEQ csi_aelse
                        DEZ ycur
                        FPA csi_bweiter
    csi_aelse:        LDZ tptr+0 PHS LDZ tptr+1 PHS JPS getprev
                      PLS SDZ tptr+1 PLS SDZ tptr+0
                      JPS InvertChar                             ; delete old cursor
                      JPS _ScrollDn
                      DEV yorg
                      MIZ 1,redraw
                      JPA csi_bweiter

; ------------------------------------------------------------

  pc_Down:      JPS pushline
                LDZ cptr+0 PHS LDZ cptr+1 PHS JPS getnext
                PLS SDZ pc_ptr+1 PLS SDZ pc_ptr+0
                CPZ cptr+0 FNE csi_bin
                  CZZ pc_ptr+1,cptr+1 BEQ mainclear              ; leave if
    csi_bin:        DEV pc_ptr CIT 10,pc_ptr BNE mainclear
                      INV pc_ptr
                      MVV pc_ptr,cptr
                      CIZ <HEIGHT-1,ycur FCS csi_belse
                        INZ ycur
                        FPA csi_bweiter
    csi_belse:        LDZ tptr+0 PHS LDZ tptr+1 PHS JPS getnext
                      PLS SDZ tptr+1 PLS SDZ tptr+0
                      JPS InvertChar                             ; delete old cursor
                      JPS _ScrollUp
                      INV yorg
                      MIZ 1,redraw
    csi_bweiter:      JPS pullline
                      LDI 10 PHS LDI <LINEBUF PHS LDI >LINEBUF PHS JPS length
                      PLS PLS PLS CPZ xcur BCS mainclear
                        SDZ xcur
                        JPA mainclear

; ------------------------------------------------------------

; ------------------------------------------------------------
; calculate the length of a string (excluding the terminator)
; push: terminator (active lower or equal), string_LSB, string_MSB
; pull: #, len_MSB, len_LSB
; ------------------------------------------------------------
length:         LDS 4 SDB lenptr+0 LDS 3 SDB lenptr+1
                LDS 5 SDB lenterm
  lenloop:      LDI
  lenterm:      0xff CPB
  lenptr:       0xffff FCS lenende                               ; stops when reaching char <= lenterm
                  INW lenptr JPA lenloop
  lenende:      LDS 3 SU.B lenptr+1
                LDS 4 SUW lenptr
                LDB lenptr+1 SDS 4
                LDB lenptr+0 SDS 5
                RTS

; ------------------------------------------------------------

#page

  pc_Left:      CIZ 0,xcur FEQ csi_delse
                  DEZ xcur
                  JPA mainclear
    csi_delse:  CIZ <DATABUF,cptr+0 FNE csi_din
                  CIZ >DATABUF,cptr+1 BEQ mainclear
      csi_din:      JPS pushline
                    LDZ cptr+0 PHS LDZ cptr+1 PHS JPS getprev
                    PLS SDZ pc_ptr+1 PLS SDZ pc_ptr+0
                    CPZ cptr+0 FNE csi_din2
                      CZZ pc_ptr+1,cptr+1 BEQ mainclear          ; leave if
        csi_din2:       MVV pc_ptr,cptr
                        CIZ 0,ycur FEQ csi_delse2
                          DEZ ycur
                          MIZ 3,redraw
                          FPA csi_dweiter
        csi_delse2:     LDZ tptr+0 PHS LDZ tptr+1 PHS JPS getnext
                        PLS SDZ tptr+1 PLS SDZ tptr+0
                        JPS InvertChar                           ; delete old cursor
                        JPS _ScrollDn
                        DEV yorg
                        MIZ 1,redraw
        csi_dweiter:    JPS pullline
                        LDI 10 PHS LDI <LINEBUF PHS LDI >LINEBUF PHS JPS length
                        PLS PLS PLS SDZ xcur
                        JPA mainclear

; ------------------------------------------------------------

  pc_Right:     LDI 10 PHS LDI <LINEBUF PHS LDI >LINEBUF PHS JPS length
                PLS PLS PLS
                CPZ xcur FCC csi_celse FEQ csi_celse
                  INZ xcur
                  JPA mainclear
    csi_celse:  SDZ pc_ptr+0 MIZ >LINEBUF,pc_ptr+1
                CIT 0,pc_ptr BEQ mainclear
                  JPS pushline
                  LDZ cptr+0 PHS LDZ cptr+1 PHS JPS getnext
                  PLS SDZ pc_ptr+1 PLS SDZ pc_ptr+0
                  CPZ cptr+0 FNE csi_cin
                    CZZ pc_ptr+1,cptr+1 BEQ mainclear
      csi_cin:        DEV pc_ptr CIT 10,pc_ptr BNE mainclear
                        INV pc_ptr
                        MVV pc_ptr,cptr
                        CIZ <HEIGHT-1,ycur FCS csi_celse2
                          INZ ycur
                          MIZ 3,redraw
                          FPA csi_cweiter
      csi_celse2:       LDZ tptr+0 PHS LDZ tptr+1 PHS JPS getnext
                        PLS SDZ tptr+1 PLS SDZ tptr+0
                        JPS InvertChar                           ; delete old cursor
                        JPS _ScrollUp
                        INV yorg
                        MIZ 1,redraw
      csi_cweiter:      JPS pullline
                        CLZ xcur
                        JPA mainclear

; ------------------------------------------------------------

  pc_Pos1:        JPS pushline
                  CIZ 0,xcur BEQ mainclear
                    CLZ xcur MIZ 3,redraw
                    JPA mainclear

; ------------------------------------------------------------

  pc_End:         JPS pushline
                  LDI 10 PHS LDI <LINEBUF PHS LDI >LINEBUF PHS JPS length
                  PLS PLS PLS
                  CPZ xcur BEQ mainclear
                    SDZ xcur MIZ 3,redraw
                    JPA mainclear

; ------------------------------------------------------------

  pc_PgUp:        CIZ >DATABUF,cptr+1 FNE pp5_noteq              ; if (cptr == data) break
                    CIZ <DATABUF,cptr+0 BEQ mainclear            ; quick exit when already up
    pp5_noteq:        JPS pushline
                  LDZ tptr+1 CPI >DATABUF FNE pp5_else           ; if (tptr == data) ...
                    LDZ tptr+0 CPI <DATABUF FNE pp5_else
                      SDZ cptr+0 MZZ tptr+1,cptr+1               ; ... { cptr = tptr; ycur = 0; }
                      CLZ ycur JPA pp5_pullout
    pp5_else:     CLZ pc_n
    pp5_loop:     LDZ tptr+0 PHS LDZ tptr+1 PHS JPS getprev
                  LDS 2 CPZ tptr+0 FNE pp5_lpnoteq
                    LDS 1 CPZ tptr+1 FEQ pp5_lpout
    pp5_lpnoteq:      PLS SDZ tptr+1 PLS SDZ tptr+0
                      DEV yorg
                      INZ pc_n CPI <HEIGHT FCC pp5_loop
    pp5_lpout:    LDZ ycur ADZ pc_n SUI <HEIGHT FCS pp5_ispos
                    LDI 0
    pp5_ispos:    SDZ ycur
                  MVV tptr,cptr
                  CLZ pc_n                                       ; for (int i=0; i<ycur; i++) cptr = getnext(cptr);
    pp5_for:      LDZ pc_n CPZ ycur FCS pp5_pullout
                    LDZ cptr+0 PHS LDZ cptr+1 PHS JPS getnext
                    PLS SDZ cptr+1 PLS SDZ cptr+0
                    INZ pc_n FPA pp5_for
    pp5_pullout:        JPS pullline
                        LDI 10 PHS LDI <LINEBUF PHS LDI >LINEBUF PHS JPS length
                        PLS PLS PLS CPZ xcur FCC pp5_useit
                          LDZ xcur
          pp5_useit:    SDZ xcur
          rd2mainclear: MIZ 3,redraw
                        JPA mainclear

; ------------------------------------------------------------

; ------------------------------------------------------------
; returns next line address after \n or returns address of EOF
; push: address LSB, MSB
; pull: address MSB, LSB
; ------------------------------------------------------------
getnext:        LDS 4 SDZ pu_sptr+0
                LDS 3 SDZ pu_sptr+1
  gn_loop:      LDT pu_sptr
                CPI 0 FEQ gn_return
                CPI 10 FEQ gn_addret
                  INV pu_sptr
                  FPA gn_loop
  gn_addret:    INV pu_sptr
  gn_return:    LDZ pu_sptr+1 SDS 3
                LDZ pu_sptr+0 SDS 4
                RTS

; ------------------------------------------------------------
; pulls current line incuding \n into 'line buffer' and terminates with zero
; ------------------------------------------------------------
pullline:       LDZ cptr+0 PHS LDZ cptr+1 PHS
                JPS getnext
                PLS PLS SUZ cptr+0 SDZ pu_n
                  MIV LINEBUF,pu_dptr
                  MVV cptr,pu_sptr
  pl_loop:      DEZ pu_n FCC pl_return
                  MTT pu_sptr,pu_dptr
                  INV pu_sptr INV pu_dptr FPA pl_loop
  pl_return:    MIT 0,pu_dptr
                CLZ changed
                RTS

; ------------------------------------------------------------

#page

  pc_PgDown:      LDZ cptr+0 PHS LDZ cptr+1 PHS JPS getnext      ; bptr = getnext(cptr);
                  PLS SDZ bptr+1 PLS SDZ bptr+0
                  CIT 0,bptr BEQ mainclear                       ; if (*bptr == 0) break;
                    JPS pushline
                  CLZ pc_n
    pp3_for1:     INZ pc_n ADZ ycur SUI <HEIGHT-1 FCS pp3_for1end ; start for with i=1
                    LDZ bptr+0 PHS LDZ bptr+1 PHS JPS getnext    ; char* n = getnext(bptr);
                    PLS SDZ pc_ptr+1 PLS SDZ pc_ptr+0
                    CIT 0,pc_ptr FEQ pp3_for1brk                 ; if (*n == 0) break;
                      MVV pc_ptr,bptr
                      FPA pp3_for1
    pp3_for1brk:  MVV bptr,cptr                                  ; if (i < 29-ycur) { cptr = bptr; ycur += i; }
                  LDZ pc_n AD.Z ycur JPA pp5_pullout             ; reuse code from pc_PgUp
    pp3_for1end:  CLZ pc_n
    pp3_for2:       LDZ bptr+0 PHS LDZ bptr+1 PHS JPS getnext    ; char* n = getnext(bptr);
                    PLS SDZ pc_ptr+1 PLS SDZ pc_ptr+0
                    CIT 0,pc_ptr FEQ pp3_for2brk                 ; if (*n == 0) break;
                      MVV pc_ptr,bptr                            ; else bptr = n;
                      LDZ tptr+0 PHS LDZ tptr+1 PHS JPS getnext  ; tptr = getnext(tptr);
                      PLS SDZ tptr+1 PLS SDZ tptr+0
                      LDZ cptr+0 PHS LDZ cptr+1 PHS JPS getnext  ; tptr = getnext(tptr);
                      PLS SDZ cptr+1 PLS SDZ cptr+0
                      INV yorg INZ pc_n CPI <HEIGHT FCC pp3_for2
                        JPA pp5_pullout                          ; normal end reached
    pp3_for2brk:  CIZ 0,pc_n BNE pp5_pullout
                    MVV bptr,cptr                                ; if (i == 0) { cptr = bptr; ycur = 30-1; }
                    MIZ <HEIGHT-1,ycur JPA pp5_pullout

; ------------------------------------------------------------
; INPUT HANDLER FOR MENU STATE NEW, LOAD, SAVE
; ------------------------------------------------------------

StateReceive:   JPS _WaitInput
                CPI 27 FNE rec_next1                             ; ESC ends this process
                  CLZ state JPA pc_CtrlV
  rec_next1:    CPI 13 FEQ StateReceive                          ; ignore CR
                CPI 10 FNE rec_next2                             ; check for LF
                  SDT copyptr DEV copyptr
                  LDZ copyptr+0 JAS _Char                        ; print indicator after every LF
                  FPA StateReceive
  rec_next2:    CPI 9 FNE rec_char
                  MIT ' ',copyptr DEV copyptr LDI ' '            ; convert tab to double SPACE
  rec_char:     SDT copyptr DEV copyptr
                JPA StateReceive

; ------------------------------------------------------------

StateNew:   JPS _WaitInput
            CPI 'y' BNE rd2mainclear
              CLB DATABUF                                        ; invalidate text data
              CLB namebuf                                        ; invalidate namebuf
              MIW namebuf,nameptr                                ; point to start of filename
              JPA mainload

; ------------------------------------------------------------

#page

StateLoad:  JPS _WaitInput
            CPI 10 FNE pl_next1                                  ; ENTER
              CIB <namebuf,nameptr+0 BEQ rd2mainclear            ; is there a non-zero filename?
                MIV namebuf,strcpy_s                             ; copy filename into _ReadBuffer (out of bank #00!!!)
                MIV _ReadBuffer,strcpy_d                         ; point _ReadPtr to start of filename
                MIV _ReadBuffer,_ReadPtr
                JPS strcpy                                       ; copy the filename away from FLASH interferance
                JPS _LoadFile CPI 1 BEQ mainload                 ; success?
                  JPS _Print ' not found.', 0                    ; moves cursor by 11 steps
                  JPS _WaitInput                                 ; clear released keys, wait on a keypress
                    MIZ 11,Z3
  sl_delete:        DEZ _XPos
                    LDI ' ' JAS _Char
                    DEZ Z3 FGT sl_delete
                  JPS InvertChar
                  JPA mainloop

  pl_next1:   CPI 8 FNE pl_default                               ; handle backspace
                CIB <namebuf,nameptr+0 BEQ mainloop              ; left border reached?
                  LDI ' ' JAS _Char                              ; del old cursor
                  DEZ _XPos
                  LDI 160 JAS _Char                              ; show new cursor
                  DEW nameptr MIR 0,nameptr                      ; write zero terminator
                  JPA mainloop

  pl_default: CPI 0xe0 BEQ _Start                                ; Ctrl+Q also works here
              CPI 27 BEQ rd2mainclear                            ; DEFAULT: ESC -> leave input
              CPI 33 BCC mainloop                                ;          ignore SPACE and below
              CPI 0x80 BCS mainloop                              ;          ignore chars >= 128
              SDZ Z3
              LDB nameptr+0 SUI <namebuf CPI 19 BCS mainloop     ; filename too long?
                MZR Z3,nameptr
                JAS _Char INZ _XPos
                JPS InvertChar       ; show new cursor position
                INW nameptr MIR 0,nameptr                        ; always write a zero at the end of the name
                JPA mainloop

; ------------------------------------------------------------

StateSave:  JPS _WaitInput
            CPI 10 BNE pl_next1                                  ; ATTENTION: SaveFile modifies _ReadBuffer!!!
              CIB <namebuf,nameptr+0 BEQ rd2mainclear            ; ENTER PRESSED: Any name there?
                MIV DATABUF,pc_ptr                               ; find the end of the file
  ps_findz:     CIT 0,pc_ptr FEQ ps_saveit                       ; found last (0) byte?
                  INV pc_ptr FPA ps_findz
  ps_saveit:    MIV namebuf,_ReadPtr                             ; set parse pointer to start of the name
                LDI <DATABUF PHS LDI >DATABUF PHS                ; start address of the data
                LDZ pc_ptr+0 PHS LDZ pc_ptr+1 PHS                ; address of last byte to save (0)
                JPS InvertChar INZ _XPos                         ; behind name: del cursor & move right for OVERWRITING (y/n)?
                JPS _SaveFile PLS PLS PLS                        ; call save (will copy filename to _ReadBuffer start)
                PLS CPI 1 BEQ rd2mainclear                       ; get result: success?
                  JPA pc_AbortS                                  ; 0: error or 2: user abortion => back to name input

#page

; ------------------------------------------------------------
; Copies a marked area in reversed order downwards from copy buffer end
; modifies: pc_ptr, pu_len
; ------------------------------------------------------------
CopyMarked:   MIV COPYEND,copyptr                                ; set copyptr to upper end of usable RAM
              MVV cptr,pu_len ; pc_ptr = starts at markptr and goes up right before cptr, pu_len = current text pos - markptr = marked bytesize
              AZV xcur,pu_len
              MZZ markptr+1,pc_ptr+1 SU.Z pu_len+1 FCC cm_return ; subtract markptr to get the required bytesize
              MZZ markptr+0,pc_ptr+0 SUV pu_len FCC cm_return    ; don't do anything if A is later than cursor
  cm_loop:      DEV pu_len FCC cm_return                         ; copy the stuff
                  MTT pc_ptr,copyptr
                  INV pc_ptr DEV copyptr                         ; reverse order
                  FPA cm_loop
  cm_return:  RTS

; ------------------------------------------------------------

; returns previous line's address or returns the same address
; push: address LSB, MSB
; pull: address MSB, LSB
getprev:        LDS 4 SDZ pu_sptr+0
                LDS 3 SDZ pu_sptr+1
                CIZ >DATABUF,pu_sptr+1 FNE gp_loop1
                CIZ <DATABUF,pu_sptr+0 FEQ gp_return
  gp_loop1:       DEV pu_sptr
  gp_loop2:       CIZ >DATABUF,pu_sptr+1 FNE gp_loopon
                  CIZ <DATABUF,pu_sptr+0 FEQ gp_return
  gp_loopon:        DEV pu_sptr
                    CIT 10,pu_sptr FNE gp_loop2
                      INV pu_sptr
  gp_return:    LDZ pu_sptr+1 SDS 3
                LDZ pu_sptr+0 SDS 4
                RTS

; ------------------------------------------------------------
; cuts out a character from a zero-terminated string, moving the tail end and shortening the string
; push: str_lsb, str_msb
; pull: #, #
; ------------------------------------------------------------
cutchar:        LDS 3 SDB cut_dptr+1 SDB cut_sptr+1              ; retrieve address of the char to cut
                LDS 4 SDB cut_dptr+0 SDB cut_sptr+0
                INW cut_sptr
  cut_loop:     LDB
  cut_sptr:     0xffff SDB
  cut_dptr:     0xffff CPI 0 FEQ cut_done
                  INW cut_sptr INW cut_dptr JPA cut_loop
  cut_done:     RTS

; ----------------------------------------------------------------
; print number <pu_n> 3-digit decimal numbers starting at <pu_len>
; modifies: (F0, F1), pu_len (2 bytes), pu_n (1 byte)
; ----------------------------------------------------------------
Print999:       MIB '0',pstring+0 SDB pstring+1 SDB pstring+2
  p100loop:     SIV 100,pu_len FCC p99end100
                  INB pstring+0 FPA p100loop
  p99end100:    AIV 100,pu_len
  p10loop:      SIZ 10,pu_len+0 FCC p99end10
                  INB pstring+1 FPA p10loop
  p99end10:     AIZ 58,pu_len+0 SDB pstring+2
  pnext:        JPS _Print
  pstring:      '000|', 0
                DEZ pu_n FEQ pexit
                  CLZ _XPos INZ _YPos
                  INB pstring+2 CPI '9' FLE pnext
                    MIB '0',pstring+2
                  INB pstring+1 CPI '9' FLE pnext
                    MIB '0',pstring+1
                  INB pstring+0 FPA pnext
  pexit:        RTS                                              ; pull string address only once

#page

; ------------------------------------------------------------
; push 'line buffer' into current line postion, replacing the old line
; ------------------------------------------------------------
pushline:       CIZ 0,changed FEQ pl_nochange
                  CLZ changed
                  MZZ cptr+0,pu_dptr+0 PHS
                  MZZ cptr+1,pu_dptr+1 PHS
                  JPS getnext
                  PLS SDZ pu_sptr+1 PLS SDZ pu_sptr+0            ; get next pointer
                  LDI 0 PHS PHS LDI >LINEBUF PHS
                  JPS length PLS PLS PLS SDZ pu_n                ; get newsize of line
                  ADV pu_dptr                                    ; pu_dptr = cptr + newsize
                  LDI 0 PHS LDZ pu_sptr+0 PHS LDZ pu_sptr+1 PHS
                  JPS length PLS
                  PLS SDZ pu_len+1 PLS SDZ pu_len+0 INV pu_len   ; pu_len = rest (incl. zero)
                  LDZ pu_dptr+0 PHS LDZ pu_dptr+1 PHS            ; push dest
                  LDZ pu_sptr+0 PHS LDZ pu_sptr+1 PHS            ; push source
                  LDZ pu_len+0 PHS LDZ pu_len+1 PHS              ; push size
                  JPS _MemMove AIB 6,0xffff
                  LDZ cptr+0 PHS LDZ cptr+1 PHS                  ; push dest
                  LDI <LINEBUF PHS LDI >LINEBUF PHS              ; push source
                  LDZ pu_n PHS LDI 0 PHS                         ; push size
                  JPS _MemMove AIB 6,0xffff
  pl_nochange:  RTS

                    ; ------------------------------------------------------------
                    ; DATA AREA OF THE EDITOR
                    ; ------------------------------------------------------------

iscoldstart:        1                                            ; indicating first (cold) start of this editor
namebuf:            '...................', 0                     ; protected buffer for filename in use, don't put it in ZP
nameptr:            0xffff                                       ; pointing to end of filename in namebuf

#mute

#org 0x0040         ; ZERO-PAGE VARIABLES

pc_sptr:            0xffff        ; shared by functions that only use these basic procedures:
pc_dptr:            0xffff        ; pushline / pullline / getprev / getnext / length
pc_ptr:             0xffff
pc_n:               0xff

pu_sptr: strcpy_s:  0xffff        ; used inside these often used funtions:
pu_dptr: strcpy_d:  0xffff        ; strcpy / pushline / pullline / getprev / getnext / length
pu_len:             0xffff
pu_n:               0xff

tptr:               0xffff        ; top pointer
cptr:               0xffff        ; current line pointer
bptr:               0xffff        ; bottom pointer
state:              0xff          ; 0: edit mode, N: New, S: Save, L: Load
xcur:               0xff          ; must be followed by ycur
ycur:               0xff          ; y position of the cursor (starting from 0)
xorg:               0xff          ; x position of the cursor (starting from 0)
yorg:               0xffff        ; global line number of the first columns of the screen (starting from 1)
redraw:             0xff          ; 2: all, 1: line, 0: nix
changed:            0xff          ; 1: line was changed, 0: line is unchnaged (no need to pushline)

copyptr:            0xffff        ; points to the next free byte below copied data, growing downwards
markptr:            0xffff        ; pointer to linestart of a marked area, invalid: MSB = 0x00
marktptr:           0xffff        ; remembers the top ptr while marking
markyorg:           0xffff        ; remember the yorg that fits to the top
markx:              0xff          ; remembers xcur while marking
marky:              0xff          ; remembers ycur while marking

#org 0x0093         Z3:           ; zero-page OS registers reused by edit
#org 0x0094         Z4:

                    ; CONSTANTS

#org 0x0f00         LINEBUF:      ; alligned 256 bytes line buffer
#org 0x8000         DATABUF:      ; beginning of the data area until 0xefff
#org 0xefff         COPYEND:      ; end of the copybuffer area (used downwards)

#org 0x430c         VIEWPORT:     ; start index of 416x240 pixel viewport (0x4000 + 12*64 + 11)
#org 0x0032         WIDTH:        ; screen width in characters
#org 0x001e         HEIGHT:       ; screen height in characters

                    ; MINOS API FUNCTION DEFINITIONS

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
