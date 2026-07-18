; --------------------------------------------------------------------------------------
; 3D Maze Demo written by Carsten Herting (slu4) 2026/06/29 - 2026/07/10 in Boersmose/DK
; This code renders a classic 16 x 16 cell maze using a simple ray-casting technique.
; Runs approximately at 8fps.
; --------------------------------------------------------------------------------------
#org 0x2000     MIZ 0x0a,angle ; set the initial view angle
                MIV 0x0181,px ; set the initial viewer's position
                MIV 0x0182,py
                MIZ 0,startup

drawloop:       JPS render

                CIZ 0,startup FNE keyloop
                  MIZ 14,_XPos MIZ 2,_YPos JPS _Print   'R A Y - C A S T I N G', 0
                  MIZ 14,_XPos MIZ 5,_YPos JPS _Print   '3 D  M A Z E  D E M O', 0
                  MIZ 14,_XPos MIZ 8,_YPos JPS _Print   '    by slu4 2026', 0
                  MIZ 13,_XPos MIZ 24,_YPos JPS _Print 'Use WASD to move around.', 0
                  MIZ 1,startup
                  
  keyloop:      WIN INK
                CPI 0x1c FNE testd ; PS/2 'A'
                  SIZ 4,angle FPA drawloop
  testd:        CPI 0x23 FNE testw ; PS/2 'D'
                  AIZ 4,angle FPA drawloop
  testw:        CPI 0x1d FNE tests ; PS/2 'W'
                  JPS make16bitdir
                  MVV px,nx MVV py,ny
                  AVV a,nx AVV b,ny
    dothestep:    LDZ ny+1 LL4 ADZ nx+1 LAP >maze CPI 0 FNE drawloop
                    MVV nx,px MVV ny,py
                  FPA drawloop
  tests:        CPI 0x1b FNE keyloop ; PS/2 'S'
                  JPS make16bitdir
                  MVV px,nx MVV py,ny
                  SVV a,nx SVV b,ny
                  FPA dothestep

make16bitdir:     LDZ a LL1 LDI 0xff ACI 0 NOT SDZ a+1 ; make signed 16-bit
                  LDZ b LL1 LDI 0xff ACI 0 NOT SDZ b+1
                  LDZ a+1 LL1 RRZ a+1 RRZ a+0 ; 16-bit arithmetic shift right
                  LDZ a+1 LL1 RRZ a+1 RRZ a+0
                  LDZ b+1 LL1 RRZ b+1 RRZ b+0
                  LDZ b+1 LL1 RRZ b+1 RRZ b+0
                  RTS

#page

; -------------------------------------------------------------
; renders a scene from position (px, py) with direction 'angle'
; -------------------------------------------------------------
  render:       CLV lastid CLZ lastwall
                MIV -200,s
                LZB angle,costable SDZ a
                LZB angle,sintable SDZ b
                JPS _Clear

  rayloop:      LDZ a LL1 SDZ dx+0                     ; calculate dx = a<<1 with sign
                LDI 0xff ACI 0 NOT SDZ dx+1
                LDZ b LL1 SDZ dy+0                     ; calculate dy = b<<1 with sign
                LDI 0xff ACI 0 NOT SDZ dy+1

    dodx:       MZZ b,z_a+0 MVV s,z_b
                JPS muls8_16f LLQ z_c                          ; (b*s) >> 7 = shifting up 1 step and using z_c+1..
                CIZ 0,sign FPL bspos
                  AVV z_c+1,dx FPA dody
      bspos:    SVV z_c+1,dx

    dody:       MZZ a,z_a+0 MVV s,z_b
                JPS muls8_16f LLQ z_c                          ; (a*s) >> 7 = shifting up 1 step and using z_c+1..
                CIZ 0,sign FMI asneg
                  AVV z_c+1,dy FPA initray
      asneg:    SVV z_c+1,dy


    initray:    MVV px,x MVV py,y                             ; set ray's origin


      checkdx:  CIZ 0,dx+1 FPL dxpos
                  MIZ 0x80,signdx
                  NEV dx MZZ x+0,ix FPA checkdy

        dxpos:  MIZ 0x00,signdx
                LDZ x+0 NOT SDZ ix

      checkdy:  CIZ 0,dy+1 FPL dypos
                  MIZ 0x80,signdy
                  NEV dy MZZ y+0,iy FPA checkdxzero

        dypos:  MIZ 0x00,signdy
                LDZ y+0 NOT SDZ iy


  checkdxzero:  CIV 0x0000,dx FNE dxnotzero
                  MIV 0xffff,nextx_y MIV 0xffff,stepx_y FPA checkdyzero
    dxnotzero:  CLQ z_a MVV dy,z_a+1 MVV dx,z_b JPS divu17_16f
                CIV 0x0000,z_c+2 FEQ dxnotover
                  MIV 0xffff stepx_y FPA dxdonext
    dxnotover:  MVV z_c,stepx_y
    
    dxdonext:   MZZ ix,z_a MVV stepx_y,z_b JPS mulu8_16f
                CIZ 0,z_c+3 FEQ dxnotover2
                  MIV 0xffff nextx_y FPA checkdyzero
    dxnotover2: MVV z_c+1,nextx_y


  checkdyzero:  CIV 0x0000,dy FNE dynotzero
                  MIV 0xffff,nexty_x MIV 0xffff,stepy_x JPA castloop
    dynotzero:  CLQ z_a MVV dx,z_a+1 MVV dy,z_b JPS divu17_16f
                CIV 0x0000,z_c+2 FEQ dynotover
                  MIV 0xffff stepy_x FPA dydonext
    dynotover:  MVV z_c,stepy_x
    
    dydonext:   MZZ iy,z_a MVV stepy_x,z_b JPS mulu8_16f
                CIZ 0,z_c+3 FEQ dynotover2
                  MIV 0xffff nexty_x FPA castloop
    dynotover2: MVV z_c+1,nexty_x

; --------------------------------------------------

    castloop:   MVV nextx_y,z_a AZV ix,z_a FCS zagreater ; eval cell boundary crossings
                MVV nexty_x,z_b AZV iy,z_b FCS zasmaller ; watch out for overflows here!
                  CVV z_a,z_b FCC zagreater
                
      zasmaller:  CIZ 0,signdx FPL cl_dxpos ; case ix + nextx_y < iy + nexty_x
                    SZV ix,x DEV x
        cl_testdy:  CIZ 0,signdy FPL cl_dypos1
                      SVV nextx_y,y FPA cl_done1
        cl_dypos1:  AVV nextx_y,y FPA cl_done1
      cl_dxpos:     AZV ix,x INV x FPA cl_testdy

      cl_done1:     SVV nextx_y,iy FPL okay1
                      CLV iy
        okay1:      SZV ix,nexty_x FCS okay2
                      CLV nexty_x
        okay2:      MIZ 0xff,ix
                    MVV stepx_y,nextx_y
                    MIZ 0,face
                    FPA testinside
                    
      zagreater:  CIZ 0,signdy FPL cl_dypos2 ; case ix + nextx_y >= iy + nexty_x
                    SZV iy,y DEV y
        cl_testdx:  CIZ 0,signdx FPL cl_dxpos1
                      SVV nexty_x,x FPA cl_done2
        cl_dxpos1:  AVV nexty_x,x FPA cl_done2
      cl_dypos2:    AZV iy,y INV y FPA cl_testdx

      cl_done2:     SVV nexty_x,ix FPL okay3
                      CLV ix
        okay3:      SZV iy,nextx_y FCS okay4
                      CLV nextx_y
        okay4:      MIZ 0xff,iy
                    MVV stepy_x,nexty_x
                    MIZ 1,face
      
      testinside: LDZ y+1 LL4 ADZ x+1 LAP >maze ; while(arr[y>>8][x>>8] == 0)
                  CPI 0 FEQ castloop

; --------------------------------------------------

                  LDZ y+1 LL2 SDZ id LDZ x+1 LL1 AD.Z id AZZ face,id ; calculate wall id

                  ; calculate wall height
                  LRZ dx+1 RRZ dx+0 ; dx = dx >> 1; dx/dy are now unsigned 8 bit again
                  LRZ dy+1 RRZ dy+0 ; dy = dy >> 1
                  CZZ dx,dy FCS dygreater

      dxgreater:  MVV x,z_b SVV px,z_b FPL dpos1 ; case dx > dy
                    NEV z_b FCC dpos1
                      MIZ 1,z_b+0
        dpos1:    CLQ z_a MZZ dx,z_a+1 ; set divident
                    FPA calcwall
              
      dygreater:  MVV y,z_b SVV py,z_b FPL dpos2 ; case dy > dx
                    NEV z_b FCC dpos2
                      MIZ 1,z_b+0
        dpos2:    CLQ z_a MZZ dy,z_a+1 ; set divident

      calcwall:   JPS divu17_16f
                  CIV 0x0000,z_c+1 FEQ wallio ; check for wall height > 0xff
                    MIZ 0xff,wall FPA drawit ; set max wall height

        wallio:   MZZ z_c+0,wall

; --------------------------------------------------

    drawit:       MVV s,xa AIV 200,xa ; always set xa drawing position
                  
                  LDZ xa+1 DEC LDZ xa+0 RL6 ANI 63 SDZ stride ; pre-calculate x-stride
                  LDZ xa+0 ANI 7 RAP >0x0000,1 SDZ pattern    ; pre-calculate bit pattern

                  CIZ 120,wall FLE drawpixel ; check for clipping
                    MIZ 120,wall FPA checkline ; skip pixel drawing
      drawpixel:  MIZ 120,ya SZZ wall,ya JPS SetPixel
                  MIZ 119,ya AZZ wall,ya JPS SetPixel

                  CIZ 0,lastwall FEQ devandcheck
                    LRZ pattern FCC patokay
                      MIZ 0x80,pattern DEZ stride

      patokay:      LDZ lastwall ADZ wall LR1 SDZ w ; w = (lastwall + wall)>>1
                    MIZ 120,ya SZZ w,ya JPS SetPixel
                    MIZ 119,ya AZZ w,ya JPS SetPixel
                    FPA checkline

    devandcheck:  LRZ pattern FCC checkline
                      MIZ 0x80,pattern DEZ stride

    checkline:    CIZ 0,lastid FEQ enddone ; draw a vertical line between blocks
                    CZZ id,lastid FEQ enddone
                      CZZ wall,lastwall FCS wlessoreq ; if (wall > lastwall) w = wall; else w = lastwall;
                        MZZ wall,w FPA wdone
      wlessoreq:      MZZ lastwall,w
      wdone:          MIZ 121,ya SZZ w,ya
                      LDZ w DEC LL1 SDZ yb JPS VertLine

      enddone:  MZZ id,lastid MZZ wall,lastwall
                
                AIV 2,s BMI rayloop ; draw the next ray
                  CIZ 200,s+0 BCC rayloop
                    RTS

#page

; -------------------------------------------------------------------------------------------
; draws a vertical line from (xa,ya) to (xa,yb)
; xa = x-Start-Position 0..399
; ya = y-Start-Position 0..239
; yb = height in pixels
; -------------------------------------------------------------------------------------------
VertLine:         RZP ya,>0x0900,1 SDZ index+1               ; use OS LineMSBTable: set top msb line start address
                  RZP ya,>0x0800,1 SDZ index+0               ; use OS LineLSBTable: set top lsb line start address
                  AZZ stride,index                           ; note: overflow is not possible
                  MZB pattern,vl_bitpat+1
  vl_bitpat:      LDI 0xcc OR.T index                        ; index of left border
                  AIV 64,index DEZ yb FGT vl_bitpat          ; one line down
                    RTS

; ****************************************************************************
; Sets a pixel at position (xa, ya) without safety checking (highly optimized)
; ****************************************************************************
SetPixel:         RZP ya,>0x0900,1 SDZ index+1               ; calculate byte index using (xa,ya)
                  RZP ya,>0x0800,1 SDZ index+0 
                  AZZ stride,index                           ; note: overflow is not possible
                  LDZ pattern OR.T index                     ; init bit pixel pattern
                  RTS

; ----------------------------------------------------------------------
; Fast (signed) multiplication (8-bit z_a) * (16-bit z_b) = (24-bit z_c)
; ----------------------------------------------------------------------
muls8_16f:  CLQ z_c CLZ sign                                 ; clear result and sign
            CIZ 0,z_a FPL aposif                             ; test sign of A
              AIZ 0x80,sign NEZ z_a                          ; make negative A positive
  aposif:   CIZ 0,z_b+1 FPL bposif                           ; test sign of B
              AIZ 0x80,sign NEV z_b                          ; make B negative positive
  bposif:   LLZ z_a FPL sbit6off
              MVV z_b,z_c
  sbit6off: LLV z_c LLZ z_a FPL sbit5off
              AVV z_b,z_c LDI 0 AC.Z z_c+2
  sbit5off: LLQ z_c LLZ z_a FPL sbit4off
              AVV z_b,z_c LDI 0 AC.Z z_c+2
  sbit4off: LLQ z_c LLZ z_a FPL sbit3off
              AVV z_b,z_c LDI 0 AC.Z z_c+2
  sbit3off: LLQ z_c LLZ z_a FPL sbit2off
              AVV z_b,z_c LDI 0 AC.Z z_c+2
  sbit2off: LLQ z_c LLZ z_a FPL sbit1off
              AVV z_b,z_c LDI 0 AC.Z z_c+2
  sbit1off: LLQ z_c LLZ z_a FPL sbit0off
              AVV z_b,z_c LDI 0 AC.Z z_c+2
  sbit0off: RTS

#page

; -------------------------------------------------------------------------------
; Fast unsigned multiplication (8-bit z_a) * (16-bit z_b) = (24-bit z_c)
; -------------------------------------------------------------------------------
mulu8_16f:  CLQ z_c LLZ z_a FCC ubit7off
              MVV z_b,z_c
  ubit7off: LLQ z_c LLZ z_a FCC ubit6off
              AVV z_b,z_c LDI 0 AC.Z z_c+2
  ubit6off: LLQ z_c LLZ z_a FCC ubit5off
              AVV z_b,z_c LDI 0 AC.Z z_c+2
  ubit5off: LLQ z_c LLZ z_a FCC ubit4off
              AVV z_b,z_c LDI 0 AC.Z z_c+2
  ubit4off: LLQ z_c LLZ z_a FCC ubit3off
              AVV z_b,z_c LDI 0 AC.Z z_c+2
  ubit3off: LLQ z_c LLZ z_a FCC ubit2off
              AVV z_b,z_c LDI 0 AC.Z z_c+2
  ubit2off: LLQ z_c LLZ z_a FCC ubit1off
              AVV z_b,z_c LDI 0 AC.Z z_c+2
  ubit1off: LLQ z_c LLZ z_a FCC ubit0off
              AVV z_b,z_c LDI 0 AC.Z z_c+2
  ubit0off: RTS                                              ; the sign is intentionally not applied to the result

#page

; -----------------------------------------------------------------
; Fast unsigned division (17-bit z_a) / (16-bit z_b) = (17-bit z_c)
; -----------------------------------------------------------------
divu17_16f:     CLZ z_a+3 CLQ z_c
                CVV z_b,z_a+2 FCC d_nofit16
                  SVV z_b,z_a+2 MIZ 1,z_c+0
  d_nofit16:    LLZ z_c LLQ z_a
                CVV z_b,z_a+2 FCC d_nofit15
                  SVV z_b,z_a+2 INZ z_c+0
  d_nofit15:    LLZ z_c LLQ z_a
                CVV z_b,z_a+2 FCC d_nofit14
                  SVV z_b,z_a+2 INZ z_c+0
  d_nofit14:    LLZ z_c LLQ z_a
                CVV z_b,z_a+2 FCC d_nofit13
                  SVV z_b,z_a+2 INZ z_c+0
  d_nofit13:    LLZ z_c LLQ z_a
                CVV z_b,z_a+2 FCC d_nofit12
                  SVV z_b,z_a+2 INZ z_c+0
  d_nofit12:    LLZ z_c LLQ z_a
                CVV z_b,z_a+2 FCC d_nofit11
                  SVV z_b,z_a+2 INZ z_c+0
  d_nofit11:    LLZ z_c LLQ z_a
                CVV z_b,z_a+2 FCC d_nofit10
                  SVV z_b,z_a+2 INZ z_c+0
  d_nofit10:    LLZ z_c LLQ z_a
                CVV z_b,z_a+2 FCC d_nofit9
                  SVV z_b,z_a+2 INZ z_c+0
  d_nofit9:     LLV z_c LLQ z_a
                CVV z_b,z_a+2 FCC d_nofit8
                  SVV z_b,z_a+2 INZ z_c+0
  d_nofit8:     LLV z_c LLQ z_a
                CVV z_b,z_a+2 FCC d_nofit7
                  SVV z_b,z_a+2 INZ z_c+0
  d_nofit7:     LLV z_c LLQ z_a
                CVV z_b,z_a+2 FCC d_nofit6
                  SVV z_b,z_a+2 INZ z_c+0
  d_nofit6:     LLV z_c LLQ z_a
                CVV z_b,z_a+2 FCC d_nofit5
                  SVV z_b,z_a+2 INZ z_c+0
  d_nofit5:     LLV z_c LLQ z_a
                CVV z_b,z_a+2 FCC d_nofit4
                  SVV z_b,z_a+2 INZ z_c+0
  d_nofit4:     LLV z_c LLQ z_a
                CVV z_b,z_a+2 FCC d_nofit3
                  SVV z_b,z_a+2 INZ z_c+0
  d_nofit3:     LLV z_c LLQ z_a
                CVV z_b,z_a+2 FCC d_nofit2
                  SVV z_b,z_a+2 INZ z_c+0
  d_nofit2:     LLV z_c LLQ z_a
                CVV z_b,z_a+2 FCC d_nofit1
                  SVV z_b,z_a+2 INZ z_c+0
  d_nofit1:     LLQ z_c LLQ z_a
                CVV z_b,z_a+2 FCC d_nofit0
                  SVV z_b,z_a+2 INZ z_c+0
  d_nofit0:     RTS

#page

costable:       0x7f,0x7f,0x7f,0x7f,0x7e,0x7e,0x7e,0x7d,0x7d,0x7c,0x7b,0x7a,0x7a,0x79,0x78,0x76,
                0x75,0x74,0x73,0x71,0x70,0x6f,0x6d,0x6b,0x6a,0x68,0x66,0x64,0x62,0x60,0x5e,0x5c,
                0x5a,0x58,0x55,0x53,0x51,0x4e,0x4c,0x49,0x47,0x44,0x41,0x3f,0x3c,0x39,0x36,0x33,
                0x31,0x2e,0x2b,0x28,0x25,0x22,0x1f,0x1c,0x19,0x16,0x13,0x10,0x0c,0x09,0x06,0x03,
                0x00,0xfe,0xfb,0xf8,0xf5,0xf1,0xee,0xeb,0xe8,0xe5,0xe2,0xdf,0xdc,0xd9,0xd6,0xd3,
                0xd0,0xce,0xcb,0xc8,0xc5,0xc2,0xc0,0xbd,0xba,0xb8,0xb5,0xb3,0xb0,0xae,0xac,0xa9,
                0xa7,0xa5,0xa3,0xa1,0x9f,0x9d,0x9b,0x99,0x97,0x96,0x94,0x92,0x91,0x90,0x8e,0x8d,
                0x8c,0x8b,0x89,0x88,0x87,0x87,0x86,0x85,0x84,0x84,0x83,0x83,0x83,0x82,0x82,0x82,
                0x82,0x82,0x82,0x82,0x83,0x83,0x83,0x84,0x84,0x85,0x86,0x87,0x87,0x88,0x89,0x8b,
                0x8c,0x8d,0x8e,0x90,0x91,0x92,0x94,0x96,0x97,0x99,0x9b,0x9d,0x9f,0xa1,0xa3,0xa5,
                0xa7,0xa9,0xac,0xae,0xb0,0xb3,0xb5,0xb8,0xba,0xbd,0xc0,0xc2,0xc5,0xc8,0xcb,0xce,
                0xd0,0xd3,0xd6,0xd9,0xdc,0xdf,0xe2,0xe5,0xe8,0xeb,0xee,0xf1,0xf5,0xf8,0xfb,0xfe,
                0x00,0x03,0x06,0x09,0x0c,0x10,0x13,0x16,0x19,0x1c,0x1f,0x22,0x25,0x28,0x2b,0x2e,
                0x31,0x33,0x36,0x39,0x3c,0x3f,0x41,0x44,0x47,0x49,0x4c,0x4e,0x51,0x53,0x55,0x58,
                0x5a,0x5c,0x5e,0x60,0x62,0x64,0x66,0x68,0x6a,0x6b,0x6d,0x6f,0x70,0x71,0x73,0x74,
                0x75,0x76,0x78,0x79,0x7a,0x7a,0x7b,0x7c,0x7d,0x7d,0x7e,0x7e,0x7e,0x7f,0x7f,0x7f,

sintable:       0x00,0x03,0x06,0x09,0x0c,0x10,0x13,0x16,0x19,0x1c,0x1f,0x22,0x25,0x28,0x2b,0x2e,
                0x31,0x33,0x36,0x39,0x3c,0x3f,0x41,0x44,0x47,0x49,0x4c,0x4e,0x51,0x53,0x55,0x58,
                0x5a,0x5c,0x5e,0x60,0x62,0x64,0x66,0x68,0x6a,0x6b,0x6d,0x6f,0x70,0x71,0x73,0x74,
                0x75,0x76,0x78,0x79,0x7a,0x7a,0x7b,0x7c,0x7d,0x7d,0x7e,0x7e,0x7e,0x7f,0x7f,0x7f,
                0x7f,0x7f,0x7f,0x7f,0x7e,0x7e,0x7e,0x7d,0x7d,0x7c,0x7b,0x7a,0x7a,0x79,0x78,0x76,
                0x75,0x74,0x73,0x71,0x70,0x6f,0x6d,0x6b,0x6a,0x68,0x66,0x64,0x62,0x60,0x5e,0x5c,
                0x5a,0x58,0x55,0x53,0x51,0x4e,0x4c,0x49,0x47,0x44,0x41,0x3f,0x3c,0x39,0x36,0x33,
                0x31,0x2e,0x2b,0x28,0x25,0x22,0x1f,0x1c,0x19,0x16,0x13,0x10,0x0c,0x09,0x06,0x03,
                0x00,0xfe,0xfb,0xf8,0xf5,0xf1,0xee,0xeb,0xe8,0xe5,0xe2,0xdf,0xdc,0xd9,0xd6,0xd3,
                0xd0,0xce,0xcb,0xc8,0xc5,0xc2,0xc0,0xbd,0xba,0xb8,0xb5,0xb3,0xb0,0xae,0xac,0xa9,
                0xa7,0xa5,0xa3,0xa1,0x9f,0x9d,0x9b,0x99,0x97,0x96,0x94,0x92,0x91,0x90,0x8e,0x8d,
                0x8c,0x8b,0x89,0x88,0x87,0x87,0x86,0x85,0x84,0x84,0x83,0x83,0x83,0x82,0x82,0x82,
                0x82,0x82,0x82,0x82,0x83,0x83,0x83,0x84,0x84,0x85,0x86,0x87,0x87,0x88,0x89,0x8b,
                0x8c,0x8d,0x8e,0x90,0x91,0x92,0x94,0x96,0x97,0x99,0x9b,0x9d,0x9f,0xa1,0xa3,0xa5,
                0xa7,0xa9,0xac,0xae,0xb0,0xb3,0xb5,0xb8,0xba,0xbd,0xc0,0xc2,0xc5,0xc8,0xcb,0xce,
                0xd0,0xd3,0xd6,0xd9,0xdc,0xdf,0xe2,0xe5,0xe8,0xeb,0xee,0xf1,0xf5,0xf8,0xfb,0xfe,

maze:           1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, ; 16 x 16 maze definition
                1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,
                1,0,0,0,0,0,1,1,0,0,0,0,0,0,0,1,
                1,1,1,1,0,0,0,0,0,1,0,0,0,0,0,1,
                1,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1,
                1,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,
                1,0,0,0,0,1,0,1,1,1,0,0,0,0,0,1,
                1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,
                1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,1,
                1,0,0,1,0,0,0,1,0,0,0,0,0,0,0,1,
                1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,
                1,0,0,0,0,0,0,1,0,1,1,0,1,1,0,1,
                1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,
                1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,
                1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
                1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,

#mute

#org 0x0040     ; zero-page variables and constants

startup:        0x00
a:              0x0000
b:              0x0000
dx:             0x0000
dy:             0x0000
signdx:         0x00
signdy:         0x00
angle:          0x00
s:              0x0000
face:           0x00
id:             0x00
lastid:         0x00
wall:           0x00
lastwall:       0x00
w:              0x00
px:             0x0000 ; player's position
py:             0x0000
x:              0x0000 ; ray's position
y:              0x0000
nx:             0x0000
ny:             0x0000
ix:             0x0000 ; distance to next cell boundary
iy:             0x0000
stepy_x:        0x0000 ; y-Schritt über Zelle: nötige Schrittweite in x
stepx_y:        0x0000 ; x-Schritt über Zelle: nötige Schrittweite in y
nexty_x:        0x0000 ; y-Schritt zum Zellenrand: nötige Schrittweite in x
nextx_y:        0x0000 ; x-Schritt zum Zellenrand: nötige Schrittweite in y

#org 0x0070

z_a:            0x00, 0x00, 0x00, 0x00 ; zero-page math registers
z_b:            0x00, 0x00
z_c:            0x00, 0x00, 0x00, 0x00
sign:           0x00

xa:             0x0000 ; zero-page graphics register
ya:             0x00
yb:             0x00
index:          0x0000
pattern:        0x00
stride:         0x00

#org 0xf033     _Clear:
#org 0xf045     _Print:
#org 0x00c0     _XPos:
#org 0x00c1     _YPos: