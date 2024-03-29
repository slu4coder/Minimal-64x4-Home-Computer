; ---------------------------------------------------------------------------
; Startfield Simulation Demo by Carsten Herting (slu4) 2024
; Simulates a starfield of 1000 stars moving towards the viewer by using
; the projection sx = x * 256 / z and sy = y * 256 / z, where (sy, sy)
; is the screen coordinate, and (x,y,z) is the position of a star.
; The number 256 represents the distance of the observer from the background.
; ---------------------------------------------------------------------------
#org 0x2000     JPS MakeStars                       ; generate star data
                JPS _Clear

drawloop:       JPS UpdateStars FPA drawloop        ; move and draw the stars in an endless loop

; ------------------------------------------------------------------------------
; Generate N random star elements (x,y,z) at STARDATA: quadinfo, x, y, z, sx, sy
; modifies: z0
; ------------------------------------------------------------------------------
MakeStars:      MIV 0x00f0,z0                       ; make N stars
                MIV STARDATA,ptr                    ; start of star data table
  makestar:     JPS _Random ANI 3 STT ptr INV ptr   ; quadrant of star (0, 1, 2, 3)
  redox:        JPS _Random CPI 200 FCS redox STT ptr INV ptr ; unsigned x
  redoy:        JPS _Random ANI 0x7f CPI 120 FCS redoy STT ptr INV ptr ; unsigned y
  redoz:        JPS _Random STT ptr INV ptr         ; unsigned z
                MIT 0,ptr INV ptr MIT 0,ptr INV ptr ; unsigned sx=0, unsigned sy=0
                DEV z0 FCS makestar
                  MIT 0xff,ptr                      ; write endmarker
                  RTS

; -------------------------------------------------------------------------
; Fast unsigned division of 256 * (8-bit A) / (8-bit B) = (16-bit C). The
; remainder is in inta+1.
; 1. A is shifted up one step into inta+1
; 2. If B fits into inta+1, B is subtracted and C is incremented.
; 3. Step 1 and 2 are repeated 16 times, with each loop-back shifting up C.
; -------------------------------------------------------------------------
Div256x8_8:     CLZ inta+1 CLV intc                 ; set A MSB = 0, result C = 0 plus endmarker
                MIZ 16,cnt FPA ds_entry
  ds_next:        LLV intc                          ; shift up existing result bits
  ds_entry:     LLV inta FCS ds_always FEQ ds_never ; shift up A into empty MSB, watch out for carry
                  SUZ intb FCC ds_never             ; CASE C=0: A >= B?
                    STZ inta+1 INZ intc+0           ; subtract B from A_MSB, set bit 0 of C
  ds_never:       DEZ cnt FGT ds_next
                    RTS
  ds_always:    SZZ intb,inta+1 INZ intc            ; CASE C=1: A > B!
                DEZ cnt FGT ds_next
                  RTS

; ------------------------------------------------
; deletes a star at position (xa, ya) of sector z0
; ------------------------------------------------
DeleteStar:     CLZ xa+1
                LDZ z0 CPI 0 FEQ dsector0
                       CPI 1 FEQ dsector1
                       CPI 2 FEQ dsector2
  dsector3:     NEV xa AIV 200,xa AIZ 120,ya JPS _ClearPixel RTS
  dsector2:     NEV xa AIV 200,xa NEZ ya AIZ 120,ya JPS _ClearPixel RTS
  dsector1:     AIV 200,xa NEZ ya AIZ 120,ya JPS _ClearPixel RTS
  dsector0:     AIV 200,xa AIZ 120,ya JPS _ClearPixel RTS

; ------------------------------------------------
; draws a star at position (z1, intc) of sector z0
; ------------------------------------------------
DrawStar:       MZZ z1,xa+0 CLZ xa+1 MZZ intc+0,ya 
                LDZ z0 CPI 0 FEQ sector0
                       CPI 1 FEQ sector1
                       CPI 2 FEQ sector2
  sector3:      NEV xa AIV 200,xa AIZ 120,ya JPS _SetPixel RTS
  sector2:      NEV xa AIV 200,xa NEZ ya AIZ 120,ya JPS _SetPixel RTS
  sector1:      AIV 200,xa NEZ ya AIZ 120,ya JPS _SetPixel RTS
  sector0:      AIV 200,xa AIZ 120,ya JPS _SetPixel RTS

#page

UpdateStars:    MIV STARDATA,ptr
  updateloop:   LDT ptr CPI 0xff FNE nextstar
                  RTS
  nextstar:     STZ z0                              ; quad -> z0
                AIV 4,ptr LDT ptr STZ xa            ; old screen position to (xa,ya) for deletion
                INV ptr LDT ptr STZ ya
                SIV 4,ptr LDT ptr STZ inta+0        ; x -> inta
                AIV 2,ptr SIT 1,ptr FNE zinside     ; z: move star towards observer
    xoutside:     DEV ptr                           ; respawn star far away, move down from z -> y
    youtside:     DEV ptr                           ; move down from y -> x
                  JPS DeleteStar
    redox2:       JPS _Random CPI 200 FCS redox2 STT ptr INV ptr ; new unsigned x
    redoy2:       JPS _Random ANI 0x7f CPI 120 FCS redoy2 STT ptr ; new unsigned y
    unchanged:    AIV 4,ptr FPA updateloop          ; goto start of next star element

    zinside:    STZ intb                            ; z -> intb
                JPS Div256x8_8                      ; nsx = 256 * x / z
                CIZ 0,intc+1 FNE xoutside           ; nsx outside viewport?
                CIZ 200,intc+0 FCS xoutside
                  MZZ intc+0,z1                     ; nsx -> z1
                  DEV ptr LDT ptr STZ inta          ; abs(y) -> inta, z in intb remains unchanged
                  JPS Div256x8_8                    ; nsy = 256 * y / z
                  CIZ 0,intc+1 FNE youtside         ; nsy outside viewport?
                  CIZ 120,intc+0 FCS youtside       ; nsy -> intc+0
                    CZZ z1,xa+0 FNE changed
                    CZZ intc+0,ya FEQ unchanged
  changed:            AIV 2,ptr                     ; goto sx
                      LDZ z1 STT ptr INV ptr        ; update screen coordinates (sx, sy)
                      LDZ intc+0 STT ptr INV ptr    ; ptr now points to next element
                      JPS DeleteStar JPS DrawStar   ; update star on screen
                      FPA updateloop

STARDATA:                                           ; put star data here

#mute #org 0x0080                                   ; zero-page variables and constants

xa:             0xffff                              ; MinOS graphics interface (_SetPixel, _ClearPixel)
ya:             0xff
inta:           0xffff                              ; math registers
intb:           0xff                                ; calculates 0x0300 / 0x96 = 0x05 R 0x12
intc:           0xffff                              ; math result register
cnt:            0xff                                ; math bit counter
ptr:            0xffff                              ; star pointer
z0:             0xff                                ; multi-purpose registers
z1:             0xff

#org 0xf003     _Prompt:                            ; API functions
#org 0xf009     _Random:
#org 0xf015     _WaitInput:
#org 0xf033     _Clear:
#org 0xf04e     _SetPixel:
#org 0xf057     _ClearPixel:
