#org 0x2000     MIB 0xfe,0xffff                                  ; initialize stack

                CLV _XPos                                        ; reset cursor position
  reset:        MIZ ' ',0
  again:        INZ 0 FCS reset                                  ; displaying chars 33-255 continuously (scrolling)
                  JAS _PrintChar
                JPS _ReadInput CPI 0 FEQ again

loopcl:         JPS _Random JAS VGA_Fill                         ; fill & clear the screen
                JPS _Clear
                JPS _ReadInput CPI 0 FEQ loopcl

loop1:          JPS _Random ANI 63 CPI 50 FCS loop1 SDZ <_XPos   ; print hello world
                JPS _Random ANI 31 CPI 30-1 FGT loop1 SDZ <_YPos
                FNE printit
                  LDZ <_XPos CPI 50-12 FCS loop1
  printit:      JPS _Print 'Hello, world!', 0
                JPS _ReadInput CPI 0 FEQ loop1
                  JPS _Clear

loop2:          JPS _Random CPI 200 FCS loop2                    ; plot pixels at random positions
                  LL1 SDZ 0x80 LDI 0 RL1 SDZ 0x81
                  JPS _Random ANI 1 OR.Z 0x80
  loop70:       JPS _Random CPI 240 FCS loop70 SDZ 0x82
                JPS _SetPixel
                JPS _ReadInput CPI 0 FEQ loop2
                  JPS _Clear

loop4:          JPS _Random SDZ 0x80 CLZ 0x81                    ; draw random rectangles at x: 0-255, y:0-127
                JPS _Random LR1 SDZ 0x82
                MIZ 144,0x83 CLZ 0x84 MIZ 112,0x85
                JPS _ScanPS2
                JPS _Rect
                JPS _ReadInput CPI 0 FEQ loop4
                  JPS _Clear

loop3:          JPS _Random CPI 200 FCS loop3                    ; draw random lines
                  LL1 SDZ 0x80 LDI 0 RL1 SDZ 0x81
                  JPS _Random ANI 1 OR.Z 0x80
  loop71:       JPS _Random CPI 240 FCS loop71 SDZ 0x82
  loop72:       JPS _Random CPI 200 FCS loop72
                  LL1 SDZ 0x83 LDI 0 RL1 SDZ 0x84
                  JPS _Random ANI 1 OR.Z 0x83
  loop6:        JPS _Random CPI 240 FCS loop6 SDZ 0x85
                JPS _ScanPS2
                JPS _Line
                JPS _ReadInput CPI 0 BEQ loop3
                  JPS _Clear
                
                MIV sprite1,sptr MIZ 16,sh
redox:          JPS _Random CPI 192 FCS redox                    ; should be 0...384 but is 0..383
                LL1 SDZ sx+0 LDI 0 RL1 SDZ sx+1
                  JPS _Random ANI 1 OR.Z sx+0
  redoy:        JPS _Random CPI 224 FGT redoy SDZ sy             ; 0..224 (= 240 - 16)
                JPS DelRect
                JPS DrawSprite
                JPS _ReadInput CPI 0 FEQ redox

                  CLZ _XPos MIZ 29,_YPos                         ; set cusor to bottom left
                  JPA _Prompt                                    ; and exit

; ----------------------------------------------------------------------------------
; Deletes a 16 x sh pixel rectangle at pixel position of left upper corner at (x|y)
; 0x80..81: x-position
; 0x82: y-position
; 0x83: rect height sh
; modifies: 0x00, mask
; ----------------------------------------------------------------------------------
DelRect:        MIV 0x00ff,mask+0 MIV 0xff00,mask+2              ; prepare the erase mask 0xff0000ff
                LDZ sy LL6 SDZ vadr+0                            ; LSB of ypos*64
                LDZ sy RL7 ANI 63 ADI >ViewPort SDZ vadr+1       ; MSB of ypos*64 (rotate via C)
                LDZ sx+1 DEC LDZ sx+0 RL6 ANI 63                 ; add xpos/8
                ADI <ViewPort OR.Z vadr+0
                LDZ sx ANI 7 DEC FCC maskdone                    ; store sub byte pixel pos
                  SDZ 0
  maskloop:     LLQ mask DEZ 0 FCS maskloop                      ; shift mask once to pixel position
  maskdone:     MZZ sh,0                                         ; number of lines to process
  lineloop:     LDZ mask+1 AN.T vadr INZ vadr+0
                LDZ mask+2 AN.T vadr INZ vadr+0
                LDZ mask+3 AN.T vadr AIV 62,vadr                 ; goto next line
                DEZ 0 FGT lineloop
                  RTS

; ----------------------------------------------------------------------------------
; Draws a 16 x sh pixel sprite at pixel position (x|y)
; 0x80..81: x-position sx
; 0x82: y-position sy
; 0x83: sprite height sh
; 0x84..85: sptr sprite data pointer
; modifies: 0x00, 0x01, dptr, sbuf, shift, vadr
; ----------------------------------------------------------------------------------
DrawSprite:     LDZ sy LL6 SDZ vadr+0                            ; LSB of ypos*64
                LDZ sy RL7 ANI 63 ADI >ViewPort SDZ vadr+1       ; MSB of ypos*64 (rotate via C)
                LDZ sx+1 DEC LDZ sx+0 RL6 ANI 63                 ; add xpos/8
                ADI <ViewPort OR.Z vadr+0
                LDZ sx ANI 7 SDZ shift                           ; store sub byte pixel pos
                MZZ sh,1                                         ; number of lines to process
                MVV sptr,dptr                                    ; copy the sprite data pointer
  slinloop:     MTZ dptr,sbuf+0 INV dptr                         ; shift sprite bits
                MTZ dptr,sbuf+1 INV dptr
                CLZ sbuf+2
                LDZ shift DEC FCC shiftdone                      ; shift that buffer to pixel position
                SDZ 0
  shiftloop:      LLQ sbuf DEZ 0 FCS shiftloop
  shiftdone:    LDZ sbuf+0 OR.T vadr INZ vadr+0
                LDZ sbuf+1 OR.T vadr INZ vadr+0
                LDZ sbuf+2 OR.T vadr AIV 62,vadr
                DEZ 1 FGT slinloop                               ; haben wir alle sprite lines verarbeitet?
                  RTS

sprite1:        0x00,0x00,0x00,0x04,0x00,0x0b,0xc0,0x08,0x30,0x10,0x0c,0x10,0x02,0x20,0x04,0x20
                0x04,0x40,0x08,0x40,0x08,0x80,0x10,0x60,0x10,0x18,0x20,0x06,0xa0,0x01,0x40,0x00

sprite2:        0x00,0x00,0x00,0x04,0x00,0x0f,0xc0,0x0f,0xf0,0x1f,0xfc,0x1f,0xfe,0x3f,0xfc,0x3f,
                0xfc,0x7f,0xf8,0x7f,0xf8,0xff,0xf0,0x7f,0xf0,0x1f,0xe0,0x07,0xe0,0x01,0x40,0x00,

; *******************************************************************************
; Fills pixel area with value in A
; *******************************************************************************
VGA_Fill:       SDB vf_loopx+1                                   ; save fill value
                MIV ViewPort,2                                   ; init VRAM pointer 2..3
                MIZ 240,1                                        ; number of lines
  vf_loopy:     MIZ 50,0                                         ; number of cols
  vf_loopx:     MIT 0xcc,2 INZ 2
                DEZ 0 FNE vf_loopx
                  AIV 14,2 DEZ 1 FNE vf_loopy
                    RTS

#mute

#org 0x0080

sx:             0xffff                                           ; sprite engine
sy:             0xff
sh:             0xff                                             ; number of sprite lines to process
sptr:           0xffff
dptr:           0xffff                                           ; sprite data pointer
vadr:           0xffff                                           ; vram address to write to
sbuf:           0, 0, 0, 0xff                                    ; generate the shifted sprite pattern
shift:          0xff                                             ; number of pixels to shift
mask:           0xff, 0, 0, 0xff                                 ; generate the shifted delete pattern

#org 0x430c ViewPort:

#mute ; MinOS API definitions generated by 'asm os.asm -s_'

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
