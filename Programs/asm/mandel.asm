; ------------------------------------------------------------------------
; Displays the 'Mandelbrot' set by projecting the area (-2.5..1) * (-1..1)
; onto 32 x 22 pixels using a maximum of 15 iterations and 16/32-bit math
; operations with fixed-point int values written by C. Herting (slu4) 2024
; ------------------------------------------------------------------------
#org 0x2000 JPS Clear

            CLZ YPos MIV 0xfe06,cb              ; set cb
nextline:   CLZ XPos MIV 0xfaf8,ca              ; set ca

nextpixel:  MVV ca,za MVV cb,zb MIZ 14,iter     ; init za=ca, zb=cb, max iterations (n+1)

iterate:    MVV za,inta MVV za,intb             ; calculate za^2
            JPS Multiply
            LDZ intc+3 LR1                      ; store result >>9 in zasq
            LDZ intc+2 RR1 STZ zasq+1
            LDZ intc+1 RR1 STZ zasq+0

            MVV zb,inta MVV zb,intb             ; calculate zb^2
            JPS Multiply
            LDZ intc+3 LR1                      ; store (result>>9) in zbsq
            LDZ intc+2 RR1 STZ zbsq+1
            LDZ intc+1 RR1 STZ zbsq+0

            LDZ zasq+0 ADZ zbsq+0               ; calculate za^2 + zb^2
            LDZ zasq+1 ACZ zbsq+1
            CPI 0x08 FCS plotpixel              ; quit iteration if result >= 4
              MVV za,inta MVV zb,intb           ; zb = (za * zb)>>8 + cb (eff x2)
              JPS Multiply
              MZZ intc+1,zb+0
              LDZ intc+2 ADZ cb+1 STZ zb+1
              AZV cb+0,zb
              MVV zasq,za                       ; za = za^2 - zb^2 + ca
              SZZ zbsq+1,za+1 SZV zbsq+0,za
              AZV ca+0,za AZZ ca+1,za+1
              DEZ iter FCS iterate              ; 15 iterations from 14..0

plotpixel:  AIZ '!',iter JAS PrintChar          ; plot current pixel in ASCII style (' ' = 0)
            AIV 56,ca
            CIZ 32,XPos FCC nextpixel           ; advance to next position
              AIV 46,cb
              MIZ 0,XPos                        ; ENTER
              INZ YPos CPI 22 FCC nextline      ; advance to next line
                JPA Prompt

; ----------------------------------------------------------------------
; Fast signed multiplication 32-bit intc = (16-bit inta) * (16-bit intb)
; ----------------------------------------------------------------------
Multiply:   CLQ intc CLZ sign                   ; set result C = 0, sign = positive
            CIZ 0,inta+1 FPL aposi              ; test sign of A
              AIZ 0x80,sign NEV inta            ; make A positive
  aposi:    CIZ 0,intb+1 FPL bposi              ; test sign of B
              AIZ 0x80,sign NEV intb            ; make B positive
  bposi:    MIZ 15,cnt FPA entry                ; initial C does not need shifting
  nextbit:    LLQ intc                          ; shift the current result up one step
    entry:  LLV inta FPL bitisoff               ; shift next bit into bit 15 position
              AZQ intb+0,intc AZQ intb+1,intc+1 ; add 16-bit B to 32-bit C result
  bitisoff: DEZ cnt FNE nextbit                 ; bit14 to bit0 are processed
              CIZ 0,sign FPL exit               ; test result's sign
                NEQ intc                        ; negate 32-bit result
      exit:   RTS

#mute

#org 0x0000                                     ; place all variables in zero page

inta:       0x0000                              ; math registers
intb:       0x0000
intc:       0x0000, 0x0000, 0                   ; safety byte for MSB addition with AZQ
sign:       0
cnt:        0

iter:       0
ca:         0, 0                                ; fixed-point Mandelbrot variables
cb:         0, 0
za:         0, 0
zb:         0, 0
zasq:       0, 0
zbsq:       0, 0

#org 0xf003 Prompt:
#org 0xf033 Clear:
#org 0xf03f Char:
#org 0xf042 PrintChar:
#org 0x00c0 XPos:
#org 0x00c1 YPos:
