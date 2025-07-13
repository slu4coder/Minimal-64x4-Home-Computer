#org 0xd000

; *******************************************
; *****                                 *****
; *****   Minimal 64x4 BLOCKS by slu4   *****
; *****     last update: 31.01.2024     *****
; *****                                 *****
; *******************************************
              LDI 0xfe SDB 0xffff                                ; init stack
game_restart: CLB state                                          ; 0: state_intro, 1: state_run, 2:state_over
              JPS PrintIntro                                     ; print the intro screen

game_loop:    LDB state
              DEC BCC state_intro                                ; switching states
                DEC BCC state_run
                  JPA state_over

state_intro:  INB _RandomState+0                                 ; randomize pseudo-random generator
              JPS _ReadInput
              CPI ' ' BNE game_loop                              ; immediate loop-back
                LDI <vram SDB ptr+0                              ; SETUP THE GAME 
                LDI >vram SDB ptr+1                              ; clear playfield
  cfloop:       LDI '.' SDR ptr
                INW ptr
                LDB ptr+0
                CPI 200
                BCC cfloop
                  CLW score                                      ; reset all game variables
                  CLW gameframes
                  LDI 80 SDB waiting                             ; fall timer init
                  CLW counter                                    ; init slow-down counter
                  CLB dropsteps
                  JPS PrintFrame                                 ; print empty field
                  JPS NewShape                                   ; pick new shape to start with (no test required)
                  JPS NewShape                                   ; fill the forecast pipeline
                  LDI '#' SDB shapechar JPS PrintShape           ; draw tetromino
                  CLB _XPos CLB _YPos
                  JPS _Print 'SCORE 00000', 0
                  LDI 27 SDB _XPos
                  JPS _Print 'HIGH ', 0
                  LDB highscore+0 PHS LDB highscore+1 PHS
                  JPS U16_Text PLS PLS
                  CLB _XPos LDI 3 SDB _YPos
                  JPS _Print ' CONTROLS', 10, 10
                             ' A - Left', 10
                             ' D - Right', 10
                             ' W - Rotate', 10
                             ' S - Drop', 0
                  LDI 28 SDB _XPos LDI 3 SDB _YPos
                  JPS _Print 'FORECAST',0
                  INB state                                      ; STATE = RUNNING!!!
                  JPA game_loop

state_run:    JPS _ReadInput CPI 0 BEQ run_nokey                 ; non-blocking key input
                CPI 'a' BEQ a_key
                CPI 'd' BEQ d_key
                CPI 'w' BEQ w_key
                CPI 's' BEQ s_key
                JPA run_nokey

      a_key:      LDI '.' SDB shapechar JPS PrintShape
                  LDB xpos DEC PHS LDB ypos PHS JPS TestShape PLS
                  PLS SU.B xpos
                  JPA r_drshape
      d_key:      INB _RandomState+1
                  LDI '.' SDB shapechar JPS PrintShape
                  LDB xpos INC PHS LDB ypos PHS JPS TestShape PLS
                  PLS AD.B xpos
                  JPA r_drshape
      w_key:      INB _RandomState+2
                  LDI '.' SDB shapechar JPS PrintShape           ; delete old shape
                  JPS RotateShape                                ; make rotate shape
                  LDB xpos PHS LDB ypos PHS JPS TestShape PLS PLS DEC BCS r_drshape ; test position
                  LDB xpos INC SDB xpos PHS LDB ypos PHS JPS TestShape PLS PLS DEC BCS r_drshape ; and possible wall kicks
                  LDB xpos SUI 2 SDB xpos PHS LDB ypos PHS JPS TestShape PLS PLS DEC BCS r_drshape
                  LDB xpos ADI 3 SDB xpos PHS LDB ypos PHS JPS TestShape PLS PLS DEC BCS r_drshape
                  LDB xpos SUI 4 SDB xpos PHS LDB ypos PHS JPS TestShape PLS PLS DEC BCS r_drshape
                    INB xpos                                     ; back to beginning
                    INB xpos
                    JPS RotateShape                              ; rotation wasn't free -> rotate back
                    JPS RotateShape
                    JPS RotateShape
                    JPA r_drshape
      s_key:      INB _RandomState+3
                  INB dropsteps
                  LDI -1 SDB waiting
                  JPA game_loop

  run_nokey:  DEW counter BCS game_loop
                LDI 0x01 SDB counter+1 LDI 0x80 SDB counter+0    ; restart counter
                INW gameframes                                   ; count a frame
                DEB waiting                                      ; tetromino falling? Watch out: waiting may already be < 0 due to 's' key
                BPL game_loop

                  LDB gameframes+1                               ; set fall timer 'waiting'
                  LR1 NEG ADI 80 SDB waiting
                  LDB xpos PHS LDB ypos INC PHS
                  JPS TestShape PLS
                  PLS DEC BCC run_place                          ; no space? place it here
                    LDI '.' SDB shapechar JPS PrintShape         ; free space? let it fall
                    INB ypos

  r_drshape:  LDI '#' SDB shapechar JPS PrintShape
              JPA game_loop

  run_place:  LDI <shape SDB ptr+0
              LDI >shape SDB ptr+1
              LDI >vram SDB ptr2+1
              LDI 4 SDB vari
  rploop:     LDB xpos                                           ; DRAW SHAPE TO VRAM
              ADR ptr                                            ; add shape xoffset
              SDB ptr2+0                                         ; write x info
              INW ptr                                            ; goto shape yoffset
              LDB ypos
              ADR ptr                                            ; add shape yoffset
              LL1 PHS ADW ptr2                                   ; add y x 2 zum vram-pointer
              PLS LL2 ADW ptr2
              LDI '#' SDR ptr2                                   ; write to VRAM
              INW ptr
              DEB vari
              BNE rploop
                CLB anzrows
                LDI 10 SDB ptr2+0                                ; start of VRAM = Anfang Reihe 1
                LDI >vram SDB ptr+1
                SDB ptr1+1
                LDI 19 SDB vary                                  ; test 19 rows
  rpyloop:    LDI 1 SDB rowfull                                  ; assume row is full
              LDI 10 SDB varx
  rpxloop:    LDI '.' CPR ptr2
              BNE rpiswall
                CLB rowfull                                      ; mark row as not empty
  rpiswall:   INB ptr2
              DEB varx
              BNE rpxloop
                LDB rowfull DEC
                BCC rpcopydone
                  INB anzrows                                    ; row is full
                  LDB ptr2+0 DEC SDB ptr+0
                  SUI 10 SDB ptr1+0
  rpcopyloop:     LDR ptr1 SDR ptr
                  DEB ptr DEB ptr1
                  BCS rpcopyloop
  rpleerloop:       INB ptr1
                    CPI 10
                    BCC rpcopydone
                    LDI '.' SDR ptr1
                    JPA rpleerloop
  rpcopydone:   DEB vary
                BNE rpyloop
                  LDI >wintable SDB ptr+1 LDI <wintable SDB ptr+0
                  LDB anzrows ADW ptr
                  LDR ptr ADW score LDR ptr ADW score            ; add score for cleared rows
                  LDB dropsteps ADW score                        ; add the drop points
                  CLB _YPos LDI 6 SDB _XPos
                  LDB score+0 PHS LDB score+1 PHS
                  JPS U16_Text PLS PLS                           ; print score
                  LDB score+1                                    ; check if there is a new highscore
                  CPB highscore+1
                  BCC rpnewshape
                  BNE rpnewhigh
                    LDB score+0
                    CPB highscore+0
                    BCC rpnewshape
  rpnewhigh:          LDB score+0 SDB highscore+0                ; score = highscore
                      LDB score+1 SDB highscore+1

  rpnewshape:   CLB dropsteps
                JPS NewShape                                     ; pick a new shape
                JPS PrintField                                   ; draw field
                JPS PrintShape                                   ; Tetromino malen
                LDB xpos PHS LDB ypos PHS JPS TestShape PLS
                PLS DEC BCS game_loop
                  INB state                                      ; INVALID POSITION => GAME OVER
                  JPS PrintOver
                  JPA game_loop

state_over:   JPS _ReadInput CPI 32 BNE game_loop
                JPA game_restart

; moves current 'nextshape' into 'shape' and builds a random tetromino into nextshape
NewShape:     LDI <nextshape SDB ptr+0                           ; copy nextshape into shape
              LDI >nextshape SDB ptr+1
              LDI <shape SDB ptr2+0
              LDI >shape SDB ptr2+1
              LDI 9 SDB vari                                     ; copy including xoff
  nscopyloop: LDR ptr SDR ptr2
              INW ptr INW ptr2
              DEB vari BNE nscopyloop
                LDI 4 SDB xpos
                LDI 1 SDB ypos
                CLB yoff
                LDI ' ' SDB shapechar
                JPS PrintNext                                    ; erase old forecast
              LDI <minos SDB ptr+0                               ; copy a random piece into shape
              LDI >minos SDB ptr+1
              LDI <nextshape SDB ptr2+0
              LDI >nextshape SDB ptr2+1
  rndagain:   JPS _Random ANI 7 CPI 7 BCS rndagain               ; 0..6
              SDB vari LL3 ADB vari   ; x 9
              ADW ptr
              LDI 9 SDB vari                                     ; size including xoff
  nscpylp:    LDR ptr SDR ptr2
              INW ptr INW ptr2
              DEB vari BNE nscpylp
                LDI '#' SDB shapechar
                JPS PrintNext                                    ; show new forecast
                RTS

TestShape:    LDI <shape SDB ptr+0                               ; test if pos is free
              LDI >shape SDB ptr+1
              LDI >vram SDB ptr2+1
              LDI 4 SDB vari
  tsloop:     LDS 4                                              ; lade test-xpos
              ADR ptr                                            ; addiere shape-xoffset hinzu
              BMI tsoutside                                      ; prüfe linke Grenze
                CPI 10 BCS tsoutside                             ; prüfe rechte Grenze
              SDB ptr2+0                                         ; beschreibe vram-pointer mit x-info
              INW ptr                                            ; gehe zum shape-yoffset
              LDS 3                                              ; lade test-ypos
              ADR ptr                                            ; addiere shape-yoffset hinzu
              BMI tsoutside                                      ; prüfe linke Grenze
                CPI 20 BCS tsoutside                             ; prüfe untere Grenze
              LL1 PHS ADW ptr2                                   ; addiere y x 2 zum vram-pointer
              PLS LL2 ADW ptr2                                   ; addiere y x 8 zum vram-pointer
              LDR ptr2                                           ; lies VRAM an dieser Stelle
              CPI '#'
              BEQ tsoutside
                INW ptr
                DEB vari
                BNE tsloop
                  LDI 1 SDS 4                                    ; return 'space is valid'
                  RTS
  tsoutside:  LDI 0 SDS 4                                        ; return 'space is invalid'
              RTS

RotateShape:  LDB xoff AD.B xpos
              LDB yoff AD.B ypos
              LDI 5 SDB vari
              LDI >shape SDB ptr+1
              LDI <shape SDB ptr+0
  rsloop:     LDR ptr PHS INW ptr
              LDR ptr PHS DEW ptr
              PLS SDR ptr INW ptr
              PLS NEG SDR ptr INW ptr
              DEB vari
              BNE rsloop
                RTS

PrintShape:   LDI >shape SDB ptr+1
              LDI <shape SDB ptr+0
              LDI 4 SDB vari
  psloop:     LDB xpos ADI 14 ADR ptr SDB _XPos
              INW ptr
              LDB ypos ADR ptr SDB _YPos
              LDB shapechar JAS _Char
              INW ptr         ; next square
              DEB vari
              BNE psloop
                RTS

PrintNext:    LDI >nextshape SDB ptr+1
              LDI <nextshape SDB ptr+0
              LDI 4 SDB vari
  pnloop:     LDI 31 ADR ptr SDB _XPos
              INW ptr
              LDI 6 ADR ptr SDB _YPos
              LDB shapechar JAS _Char
              INW ptr         ; next square
              DEB vari
              BNE pnloop
                RTS

PrintField:   CLB _YPos
              LDI >vram SDB ptr+1
              CLB ptr+0
              LDI 20 SDB vary
  pflinstart: LDI 14 SDB _XPos
              LDI 10 SDB varx
  pfxloop:    LDR ptr JAS _Char
              INB _XPos
              INB ptr+0
              DEB varx
              BNE pfxloop
                INB _YPos
                DEB vary
                BNE pflinstart
                  RTS

PrintFrame:   JPS _Clear
              CLB _YPos
              LDI 20 SDB vary
  pfrloop:    LDI 12 SDB _XPos
              JPS _Print '<!..........!>', 0
              INB _YPos
              DEB vary
              BNE pfrloop
                MIZ 12,_XPos
                JPS _Print '<!==========!>', 0
                INB _YPos
                MIZ 12,_XPos                
                JPS _Print '  VVVVVVVVVV  ', 0
                RTS

PrintIntro:   JPS _Clear
              CLZ _XPos MIZ 10,_YPos
              JPS _Print 'M I N I M A L   6 4 x 4   B L O C K S', 10, 10, 10, 10, 10, 10
                         '             by slu4 2025', 0
              JPA PrintSpace

PrintOver:    MIZ 14,_XPos MIZ 10,_YPos
              JPS _Print 'GAME  OVER', 0

PrintSpace:   MIZ 13,_XPos MIZ 23,_YPos
              JPS _Print 'Press  SPACE', 0
              RTS

; print out an unsigned 16-bit decimal number in the format 00000
; push: number_lsb, number_msb
; pull: #, #
U16_Text:       LDS 3 SDB U16_C+1  ; PRINT A POSIMIVE NUMBER
                LDS 4 SDB U16_C+0
                LDI 0 PHS SDB U16_digits
  U16_start:    CLB U16_C+2
                LDI 16 SDB U16_count
  U16_shift:    LDB U16_C+2 RL1
                LDB U16_C+0 RL1 SDB U16_C+0
                LDB U16_C+1 RL1 SDB U16_C+1
                LDB U16_C+2 RL1 SDB U16_C+2
                CPI 10 BCC U16_done
                  ADI 118 SDB U16_C+2
  U16_done:      DEB U16_count BNE U16_shift
                  LDB U16_C+2 ANI 0x7f
                  ADI '0' PHS INB U16_digits
                  LDB U16_C+2 RL1
                  LDB U16_C+0 RL1 SDB U16_C+0
                  LDB U16_C+1 RL1 SDB U16_C+1
                  LDB U16_C+2 RL1 SDB U16_C+2
                  LDI 0
                  CPB U16_C+0 BNE U16_start
                    CPB U16_C+1 BNE U16_start
  U16_before:         INB U16_digits CPI 6 BEQ U16_stack
                        LDI '0' JAS _Char INB _XPos JPA U16_before
  U16_stack:          PLS CPI 0 BEQ U16_exit
                        JAS _Char INB _XPos
                        JPA U16_stack
  U16_exit:            RTS

              ;  initial tetrominos with initial x-offset for SRS
minos:        0,  0,  1,  0,  0, -1, 1, -1,   1                  ; square
              -1, -1, 0,  -1, 0, 0,  1, 0,    0                  ; Z
              -1, 0,  0,  0,  0, -1, 1, -1,   0                  ; neg. Z
              -1, 0,  0,  0,  1, 0,  2, 0,    1                  ; slab
              -1, 0,  0,  0,  1, 0,  0, -1,   0                  ; pyramid
              -1, -1, -1, 0,  0, 0,  1, 0,    0                  ; L
              -1, 0,  0,  0,  1, 0,  1, -1,   0                  ; neg. L

wintable:     0, 20, 50, 100, 250                                ; points depending on cleared rows (x2)

highscore:    0x07e9                                             ; "2025"

#mute

#org 0xd800   vram:                                              ; 20*10 bytes Video RAM
#org 0xd8c8                                                      ; variables

U16_C:        0xffff, 0xff                                       ; for U16_Text
U16_count:    0xff
U16_digits:   0xff

shapechar:    0                                                  ; current look of a piece, either '#' or '.'
nextshape:    0, 0, 0, 0, 0, 0, 0, 0
              0                                                  ; nextshapes's xoff
shape:        0, 0, 0, 0, 0, 0, 0, 0                             ; current shape (and it's rotation state)
xoff:         0                                                  ; SRS rotation compensation
yoff:         0

state:        0xff          ; 0: intro, 1: running, 2: over
score:        0xffff        ; holding the current score
waiting:      0xff          ; timer
counter:      0x0000        ; 1/60s wait counter
gameframes:   0xffff        ; counting the game frames
xpos:         0xff          ; current position of tetromino
ypos:         0xff
ptr:          0xffff        ; multi-purpose pointers
ptr1:         0xffff
ptr2:         0xffff
vari:         0xff          ; multi-purpose
varx:         0xff
vary:         0xff
dropsteps:    0xff          ; counting hard drops
anzrows:      0xff          ; count cleared lines
rowfull:      0xff          ; boolean line completed

#mute                       ; MinOS label definitions generated by 'asm os.asm -s_'

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
