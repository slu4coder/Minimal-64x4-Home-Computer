; ------------------------------------------------------
; ALIEN INVADERS for the MINIMAL 64x4 Home Computer
; by Carsten Herting (slu4) 2022 17.11.2022 - 20.11.2022
; adopted to Minimal 64x4 by slu4 26.12.2023
; Original SPACE INVADERS by TAITO 1978
; ------------------------------------------------------

#org 0x8000

start:          LDI 0xfe STB 0xffff
                CLW score
                CLB gamestate

  mainloop:     CLW counter
    waitloop:   JPS KeyHandler INW counter CPI 0x04 BCC waitloop ; on real hardware use 0x05
                  INB framecount
                  LDB gamestate
                  DEC BCC gamestate0
                    DEC BCC gamestate1
                      DEC BCC gamestate2
                        DEC BCC gamestate3

                ; GAME OVER -------------------------------------
                LDB score+1 CPB hiscore+1 BCC nonewhigh BGT newhigh
                  LDB hiscore+0 CPB score+0 BCS nonewhigh
  newhigh:          LDB score+1 STB hiscore+1
                    LDB score+0 STB hiscore+0
                    LDI 22 STB _XPos LDI 2 STB _YPos LDB hiscore+0 PHS LDB hiscore+1 PHS JPS DecPrint PLS PLS
  nonewhigh:    LDI 2 STB _XPos LDI 27 STB _YPos JPS _Print 'PRESS <SPACE>', 0
                LDI 6 STB _XPos LDI 7 STB _YPos JPS _Print '   GAME OVER   ', 0
  waitendfire:  JPS _WaitInput CPI ' ' BNE waitendfire
                  CLB gamestate
                  JPA mainloop

                ; SHIP DESTROYED --------------------------------
gamestate3:     JPS UpdateShot
                LDB framecount ANI 4 LL1 RL6 ADI 9 PHS        ; explosion animation
                LDB shippos PHS LDI 192 PHS JPS DrawSprite PLS PLS PLS ; players ship exploding
                DEB waitframes BCS mainloop
                  LDI 12 PHS LDB shippos PHS LDI 192 PHS JPS DrawSprite PLS PLS PLS ; delete ship
                  JPS ResetAlienShots
                  LDI 4 STB gamestate
                  DEB lives BEQ mainloop                      ; no lives left -> gamestate 4
                    LDI 2 STB _XPos LDI 27 STB _YPos
                    LDB lives ADI '0' JAS _PrintChar
                    LDB lives DEC LL1 AD.B _XPos
                    LDI ' ' JAS _PrintChar LDI ' ' JAS _PrintChar ; delete one spare ship
                    LDI 8 PHS LDI 16 STB shippos PHS LDI 192 PHS
                    JPS DrawSprite PLS PLS PLS                ; draw new ship
                    LDI 2 STB gamestate                       ; go back to the game
                    JPA mainloop

                ; GAME IS RUNNING -------------------------------
gamestate2:     LDB a_total CPI 0 BNE aliensleft              ; check if some aliens are left over
                DEB gamestate JPA mainloop                    ; no aliens => setup a new level
  aliensleft:   JPS UpdateSaucer
                JPS KeyHandler
                JPS UpdateAlienShots
                JPS KeyHandler
                JPS UpdateShot
                JPS KeyHandler
                JPS UpdateAliens
                JPS KeyHandler
                LDB left CPI 1 BNE checkright                 ; check player's ship movement
                  LDB shippos CPI 17 BCC checkright
                    DEB shippos JPA redrawship
  checkright:    LDB right CPI 1 BNE checkfire
                  LDB shippos CPI 191 BCS checkfire
                    INB shippos
    redrawship:      LDI 8 PHS LDB shippos PHS LDI 192 PHS JPS DrawSprite PLS PLS PLS ; players ship
  checkfire:    LDB fire CPI 1 BNE mainloop
                  JPS PlaceShot
                  JPA mainloop

                  ; SETUP NEW LEVEL -----------------------------
gamestate1:       LDI <ViewPort+0x0600 STB vc_loopx+1         ; CLEAR GAME AREA
                  LDI >ViewPort+0x0600 STB vc_loopx+2
    vc_loopy:     MIZ 16,0                                    ; screen width in words
    vc_loopx:     CLW 0xcccc
                  LDI 2 AD.B vc_loopx+1
                  DEZ 0 BGT vc_loopx                          ; self-modifying code
                    LDI 32 ADW vc_loopx+1                     ; add blank number of cols
                    CPI 0x77 BCC vc_loopy                     ; clear until row 208 (starting at 0x7700)
                  LDI <0x788c STB vl_loopx+3                  ; DRAW BOTTOM LINE
                  LDI >0x788c STB vl_loopx+4
                  MIZ 28,0
    vl_loopx:     LDI 0xff STB 0xcccc INW vl_loopx+3
                  DEZ 0 BGT vl_loopx                          ; self-modifying code
                  LDI 32 PHS LDI 168 PHS JPS DrawWall PLS PLS ; DRAW WALLS
                  LDI 78 PHS LDI 168 PHS JPS DrawWall PLS PLS
                  LDI 124 PHS LDI 168 PHS JPS DrawWall PLS PLS
                  LDI 170 PHS LDI 168 PHS JPS DrawWall PLS PLS
                  JPS ResetSaucer                             ; reset systems
                  JPS ResetShot
                  JPS ResetAlienShots
                  JPS ResetAliens
                  CLB left CLB right CLB fire
                  LDI 13 STB _XPos LDI 2 STB _YPos            ; print level
                  INB level ADI '0' JAS _Char
                  LDI 8 PHS LDB shippos PHS LDI 192 PHS JPS DrawSprite PLS PLS PLS ; redraw players ship
                  INB gamestate
                  JPA mainloop

                ; DRAW THE START SCREEN -------------------------
gamestate0:     JPS _Clear
                LDI 2 STB _XPos CLZ _YPos JPS _Print 'SCORE<1>', 0
                LDI 18 STB _XPos CLZ _YPos JPS _Print 'HI-SCORE', 0
                LDI 12 STB _XPos LDI 5 STB _YPos JPS _Print 'PLAY', 0
                LDI 7 STB _XPos LDI 8 STB _YPos JPS _Print 'ALIEN INVADERS', 0
                LDI 3 STB _XPos LDI 13 STB _YPos JPS _Print '* SCORE ADVANCE TABLE *', 0
                LDI 10 STB _XPos LDI 16 STB _YPos JPS _Print '= MYSTERY', 0
                LDI 10 STB _XPos LDI 18 STB _YPos JPS _Print '= 30 POINTS', 0
                LDI 10 STB _XPos LDI 20 STB _YPos JPS _Print '= 20 POINTS', 0
                LDI 10 STB _XPos LDI 22 STB _YPos JPS _Print '= 10 POINTS', 0
                LDI 2 STB _XPos LDI 27 STB _YPos JPS _Print 'PRESS <SPACE>', 0
                LDI 17 STB _XPos LDI 27 STB _YPos JPS _Print 'CREDIT 00', 0
                LDI 3 STB _XPos LDI 25 STB _YPos JPS _Print '<A> -- <D>', 0
                LDI 6 PHS LDI 56 PHS LDI 128 PHS JPS DrawSprite PLS PLS PLS
                LDI 5 PHS LDI 56 PHS LDI 144 PHS JPS DrawSprite PLS PLS PLS
                LDI 3 PHS LDI 56 PHS LDI 160 PHS JPS DrawSprite PLS PLS PLS
                LDI 1 PHS LDI 56 PHS LDI 176 PHS JPS DrawSprite PLS PLS PLS
                LDI 8 PHS LDI 56 PHS LDI 200 PHS JPS DrawSprite PLS PLS PLS
                LDI 2 STB _XPos LDI 2 STB _YPos LDB score+0 PHS LDB score+1 PHS JPS DecPrint PLS PLS
                LDI 22 STB _XPos LDI 2 STB _YPos LDB hiscore+0 PHS LDB hiscore+1 PHS JPS DecPrint PLS PLS
  waitstart:    JPS _Random JPS _WaitInput CPI ' ' BNE waitstart
                  CLB fire CLB left CLB right                 ; init a new game
                  CLB level CLW score
                  LDI 3 STB lives
                  LDI 16 STB shippos
                  LDI 2 STB _XPos LDI 2 STB _YPos LDB score+0 PHS LDB score+1 PHS JPS DecPrint PLS PLS
                  LDI 12 STB _XPos CLZ _YPos JPS _Print 'WAVE', 0
                  LDI 2 STB _XPos LDI 27 STB _YPos JPS _Print '3            ', 0 ; number of lives
                  LDI 8 PHS LDI 24 PHS LDI 216 PHS JPS DrawSprite PLS PLS PLS ; ship symbol
                  LDI 8 PHS LDI 40 PHS LDI 216 PHS JPS DrawSprite PLS PLS PLS ; ship symbol
                  INB gamestate                               ; start the level setup
                  JPA mainloop

; ----------------------------------------------------------------------------------------------

ResetSaucer:      CLB u_state
                  LDI 0x58 STB u_timer+0
                  LDI 0x02 STB u_timer+1
                  RTS

UpdateSaucer:     LDB u_state
                  DEC BCC sr_state0
                    DEC BCC sr_state1
                      DEC BCC sr_state2
                        DEC BCC sr_state3

  sr_state4:      DEW u_timer BCS sr_rts
                  LDB u_pos RL6 ANI 31 STB _XPos LDI 4 STB _YPos
                  JPS _Print '   ', 0 ; delete number
                  JPA ResetSaucer      ; and return from there

  sr_state3:      DEW u_timer BCS sr_rts
                    LDI 12 PHS LDB u_pos PHS LDI 32 PHS       ; delete pop explosion
                    JPS DrawSprite PLS PLS PLS
                    LDB u_valptr+0 CPI <u_values+9 BCS ResetSaucer ; too many tries -> no score adv and return from there
                      SUI <u_values LL2 STB u_timer+0
                      LDI >u_text STB u_timer+1
                      LDI <u_text ADW u_timer
                      LDB u_timer+0 PHS LDB u_timer+1 PHS     ; push pointer to val string
                      LDB u_pos RL6 ANI 31 STB _XPos LDI 4 STB _YPos
                      JPS _PrintPtr PLS PLS
                      LDR u_valptr ADW score                  ; add value to score
                      LDI 2 STB _XPos LDI 2 STB _YPos         ; reprint score
                      LDB score+0 PHS LDB score+1 PHS
                      JPS DecPrint PLS PLS
                      CLB u_timer+1 LDI 24 STB u_timer+0
                      INB u_state
                      RTS

  sr_state2:      LDI 11 PHS LDB u_pos PHS LDI 32 PHS         ; draw pop explosion
                  JPS DrawSprite PLS PLS PLS
                  LDI 12 STB u_timer+0 CLB u_timer+1
                  INB u_state
                  RTS

  sr_state1:      LDB framecount ANI 1 DEC BCC sr_nostep
                    LDB u_step AD.B u_pos
    sr_nostep:    LDB u_pos CPI 0 BEQ sr_delete
                    CPI 209 BEQ sr_delete
    sr_draw:          LDB u_step INC LR1 ADI 6 PHS            ; push costume
                      JPA sr_common
    sr_delete:    JPS ResetSaucer
                  LDI 12 PHS
    sr_common:    LDB u_pos PHS LDI 32 PHS                    ; push pos
                  JPS DrawSprite PLS PLS PLS                  ; draw/del the sprite
                  RTS

  sr_state0:      DEW u_timer BCS sr_rts
                    LDB a_total CPI 12 BCC sr_rts
                      JPS _Random ANI 2 SUI 1 STB u_step
                      CPI 1 BNE sr_notone
                        STB u_pos JPA sr_setval
    sr_notone:        LDI 208 STB u_pos
    sr_setval:        LDI <u_values STB u_valptr+0            ; point to 300 points
                      LDI >u_values STB u_valptr+1
                      INB u_state
    sr_rts:       RTS

ResetAlienShots:  JPS as0_reset
                  JPS as1_reset
                  JPS as2_reset
  as_rts:         RTS

as0_reset:        LDB as0_active CPI 0xff BEQ as_rts
                    LDI 0xff STB as0_active                   ; deactivate this shot
                    LDB as0_timer CPI 0xff BNE as0_delexpl
                      LDI 12 PHS LDB as0_x DEC PHS LDB as0_y PHS
                      JPS DrawShot PLS PLS PLS
                      RTS
  as0_delexpl:      LDI 3 PHS LDB as0_x PHS LDB as0_y PHS     ; delete a small explosion (type II)
                    JPS DrawSmall PLS PLS PLS
                    RTS

as1_reset:        LDB as1_active CPI 0xff BEQ as_rts
                    LDI 0xff STB as1_active                   ; deactivate this shot
                    LDB as1_timer CPI 0xff BNE as1_delexpl
                      LDI 12 PHS LDB as1_x DEC PHS LDB as1_y PHS
                      JPS DrawShot PLS PLS PLS
                      RTS
  as1_delexpl:      LDI 3 PHS LDB as1_x PHS LDB as1_y PHS     ; delete a small explosion (type II)
                    JPS DrawSmall PLS PLS PLS
                    RTS

as2_reset:        LDB as2_active CPI 0xff BEQ as_rts
                    LDI 0xff STB as2_active                   ; deactivate this shot
                    LDB as2_timer CPI 0xff BNE as2_delexpl
                      LDI 12 PHS LDB as2_x DEC PHS LDB as2_y PHS
                      JPS DrawShot PLS PLS PLS
                      RTS
  as2_delexpl:      LDI 3 PHS LDB as2_x PHS LDB as2_y PHS     ; delete a small explosion (type II)
                    JPS DrawSmall PLS PLS PLS
                    RTS

UpdateAlienShots: JPS as_manage JPS KeyHandler
                  JPS as0_update JPS KeyHandler
                  JPS as1_update JPS KeyHandler
                  JPS as2_update JPS KeyHandler
                  RTS

as_manage:        LDB level LL2 STZ 0                         ; time to place a new shot?
                  JPS _Random CPZ 0 BCS as_rts
  as_redorand:      JPS _Random RL5 ANI 15 CPI 11 BCS as_redorand ; pick a random column 0..10
                      STB as_col
                  LDB level LL3 STZ 0
                  JPS _Random CPZ 0 BCS as_usecol             ; time for a precise shot?
                    LDB shippos ADI 8 SUB a_x
                    CPI 176 BCS as_usecol
                      RL5 ANI 15 STB as_col                   ; pick the column under which the player ship is located

  as_usecol:        CLB as_c
    as_cloop:       CLB as_r
    as_rloop:       LDB as_col ADB as_c CPI 11 BCC as_cokay
                      SUI 11
      as_cokay:     STB as_ptr+0 STB as_colcmod               ; (col+c) % 11, store result for later
                    LDI >a_alive STB as_ptr+1
                    LDB as_r AD.B as_ptr+0                    ; + 1*r
                    LDB as_r LL1 AD.B as_ptr+0                ; + 2*r
                    LDB as_r LL3 AD.B as_ptr+0                ; + 8*r
                    LDI <a_alive ADW as_ptr                   ; point to alive table position
                    LDR as_ptr CPI 1 BEQ as_living
                    INB as_r CPI 5 BCC as_rloop
    as_living:        LDB as_r CPI 5 BCS as_trynext           ; no alien found in this column
                        LDB as_colcmod LL4 ADI 8 ADB a_x STB as_px ; put exactly below alien (upper row of shot pixels is empty)
                        LDB as_r LL4 NEG ADB a_y STB as_py
                        LDB as0_active CPI 0xff BNE as_try1   ; find a free slot
                          LDB as_px STB as0_x LDB as_py STB as0_y
                          LDI 0xff STB as0_timer LDI 1 STB as0_active
                          RTS
    as_try1:            LDB as1_active CPI 0xff BNE as_try2
                          LDB as_px STB as1_x LDB as_py STB as1_y
                          LDI 0xff STB as1_timer LDI 1 STB as1_active
                          RTS
    as_try2:            LDB as2_active CPI 0xff BNE as_rts
                          LDB as_px STB as2_x LDB as_py STB as2_y
                          LDI 0xff STB as2_timer LDI 1 STB as2_active
                          RTS
    as_trynext:      INB as_c CPI 11 BCC as_cloop
                     RTS

as0_update:        LDB as0_active CPI 0xff BEQ as_rts         ; is this slot active?
                    LDB as0_timer CPI 0xff BNE as0_explosion  ; shot is exploding
                      INB as0_y CPI 207 BCC as0_falling       ; the shot is currently falling down
                        LDI 1 PHS                             ; shot has reached the bottom
                        LDI 4 SU.B as0_x PHS
                        LDI 207 STB as0_y PHS
                        JPS DrawSmall PLS PLS PLS
                        LDI 12 STB as0_timer
                        RTS
  as0_falling:        ; shot is still falling down -> COLLISION DETECTION
                      LDB as0_y ADI 7 LL6 STB addr+0          ; LSB of ypos*64
                      LDB as0_y ADI 7 RL7 ANI 63 ADI >ViewPort STB addr+1 ; MSB of ypos*64 (rotate via C)
                      LDB as0_x RL6 ANI 63 ADI <ViewPort OR.B addr+0 ; xpos/8
                      LDB as0_x ANI 7 ADI LL0+0 STB as0_llx   ; use sub pixel pos
                      LDI 1
  as0_llx:              0xcc                                  ; this instruction gets modified
                      ANR addr CPI 0 BEQ as0_emptyspace
                        ;  a white pixel was hit
                        LDI 12 PHS LDB as0_x DEC PHS LDB as0_y DEC PHS ; delete shot at its last position
                        JPS DrawShot PLS PLS PLS
                        LDB as0_y CPI 184 BCC as0_anywhite    ; was the player's ship hit?
                          CPI 192 BCS as0_anywhite
                            LDI 60 STB waitframes
                            LDI 3 STB gamestate               ; ship destroyed
                            RTS
  as0_anywhite:         LDI 1 PHS                             ; plot explosion
                        LDI 4 SU.B as0_x PHS LDI 5 AD.B as0_y PHS ; rember this position
                        JPS DrawSmall PLS PLS PLS
                        LDI 12 STB as0_timer
                        RTS
  as0_emptyspace:     ; free pixel below shot => plot the shot at new position
                      LDB framecount ADI 0                    ; as0 pic
                      ANI 15 LR1 LR1 ADI 0                    ; as0 type
                      PHS
                      LDB as0_x DEC PHS LDB as0_y PHS
                      JPS DrawShot PLS PLS PLS
                      RTS
  as0_explosion:  DEB as0_timer BGT as_rts
                    LDI 3 PHS LDB as0_x PHS LDB as0_y PHS     ; delete the explosion after some frames
                    JPS DrawSmall PLS PLS PLS
                    LDI 0xff STB as0_active
                    RTS

as1_update:       LDB as1_active CPI 0xff BEQ as_rts          ; is this slot active?
                    LDB as1_timer CPI 0xff BNE as1_explosion  ; shot is exploding
                      INB as1_y CPI 207 BCC as1_falling       ; the shot is currently falling down
                        LDI 1 PHS                             ; shot has reached the bottom
                        LDI 4 SU.B as1_x PHS
                        LDI 207 STB as1_y PHS
                        JPS DrawSmall PLS PLS PLS
                        LDI 12 STB as1_timer
                        RTS
  as1_falling:        ; shot is still falling down -> COLLISION DETECTION
                      LDB as1_y ADI 7 LL6 STB addr+0          ; LSB of ypos*64
                      LDB as1_y ADI 7 RL7 ANI 63 ADI >ViewPort STB addr+1 ; MSB of ypos*64 (rotate via C)
                      LDB as1_x RL6 ANI 63 ADI <ViewPort OR.B addr+0 ; xpos/8
                      LDB as1_x ANI 7 ADI LL0+0 STB as1_llx   ; use sub pixel pos
                      LDI 1                                   ; generate pixel mask
  as1_llx:              0xcc                                  ; this instruction gets modified
                      ANR addr CPI 0 BEQ as1_emptyspace
                        ;  a white pixel was hit
                        LDI 12 PHS LDB as1_x DEC PHS LDB as1_y DEC PHS ; delete shot at its last position
                        JPS DrawShot PLS PLS PLS
                        LDB as1_y CPI 184 BCC as1_anywhite    ; was the player's ship hit?
                          CPI 192 BCS as1_anywhite
                            LDI 60 STB waitframes
                            LDI 3 STB gamestate               ; ship destroyed
                            RTS
  as1_anywhite:         LDI 1 PHS                             ; plot explosion
                        LDI 4 SU.B as1_x PHS LDI 5 AD.B as1_y PHS ; rember this position
                        JPS DrawSmall PLS PLS PLS
                        LDI 12 STB as1_timer
                        RTS
  as1_emptyspace:     ; free pixel below shot => plot the shot at new position
                      LDB framecount ADI 1                    ; as1_ pic
                      ANI 15 LR1 LR1 ADI 4                    ; as1_ type
                      PHS
                      LDB as1_x DEC PHS LDB as1_y PHS
                      JPS DrawShot PLS PLS PLS
                      RTS
  as1_explosion:  DEB as1_timer BGT as_rts
                    LDI 3 PHS LDB as1_x PHS LDB as1_y PHS     ; delete the explosion after some frames
                    JPS DrawSmall PLS PLS PLS
                    LDI 0xff STB as1_active
                    RTS

as2_update:       LDB as2_active CPI 0xff BEQ as_rts          ; is this slot active?
                    LDB as2_timer CPI 0xff BNE as2_explosion  ; shot is exploding
                      INB as2_y CPI 207 BCC as2_falling       ; the shot is currently falling down
                        LDI 1 PHS                             ; shot has reached the bottom
                        LDI 4 SU.B as2_x PHS
                        LDI 207 STB as2_y PHS
                        JPS DrawSmall PLS PLS PLS
                        LDI 12 STB as2_timer
                        RTS
  as2_falling:        ; shot is still falling down -> COLLISION DETECTION
                      LDB as2_y ADI 7 LL6 STB addr+0          ; LSB of ypos*64
                      LDB as2_y ADI 7 RL7 ANI 63 ADI >ViewPort STB addr+1 ; MSB of ypos*64 (rotate via C)
                      LDB as2_x RL6 ANI 63 ADI <ViewPort OR.B addr+0 ; xpos/8
                      LDB as2_x ANI 7 ADI LL0+0 STB as2_llx   ; use sub pixel pos
                      LDI 1                                   ; generate pixel mask
  as2_llx:              0xcc                                  ; this instruction gets modified
                      ANR addr CPI 0 BEQ as2_emptyspace
                        ; a white pixel was hit
                        LDI 12 PHS LDB as2_x DEC PHS LDB as2_y DEC PHS ; delete shot at its last position
                        JPS DrawShot PLS PLS PLS
                        LDB as2_y CPI 184 BCC as2_anywhite    ; was the player's ship hit?
                          CPI 192 BCS as2_anywhite
                            LDI 60 STB waitframes
                            LDI 3 STB gamestate               ; ship destroyed
                            RTS
  as2_anywhite:         LDI 1 PHS                             ; plot explosion
                        LDI 4 SU.B as2_x PHS LDI 5 AD.B as2_y PHS ; rember this position
                        JPS DrawSmall PLS PLS PLS
                        LDI 12 STB as2_timer
                        RTS
  as2_emptyspace:     ; free pixel below shot => plot the shot at new position
                      LDB framecount ADI 2                    ; as2_ pic
                      ANI 15 LR1 LR1 ADI 8                    ; as2_ type
                      PHS
                      LDB as2_x DEC PHS LDB as2_y PHS
                      JPS DrawShot PLS PLS PLS
                      RTS
  as2_explosion:  DEB as2_timer BGT as_rts
                    LDI 3 PHS LDB as2_x PHS LDB as2_y PHS     ; delete the explosion after some frames
                    JPS DrawSmall PLS PLS PLS
                    LDI 0xff STB as2_active
                    RTS

ResetShot:        CLB s_state
                  RTS

PlaceShot:        LDB s_state CPI 0 BNE ps_rts                ; already active
                    LDI 1 STB s_state
                    LDB shippos ADI 8 STB s_x
                    LDI 188 STB s_y
                    INW u_valptr
                    JPS DrawLaser
  ps_rts:         RTS

UpdateShot:       LDB s_state DEC BCC us_rts
                    DEC BCC us_fired
                      DEC BCC us_smallex
  us_popping:     DEB s_timer BCS us_rts                      ; wait while alien is popping
                    LDI 12 PHS LDB s_x PHS LDB s_y PHS
                    JPS DrawSprite PLS PLS PLS                ; clear alien pop
                    CLB a_halt
                    CLB s_state
  us_rts:            RTS

  us_smallex:     DEB s_timer BCS us_rts                      ; wait while a small explosion is active
                    LDI 2 PHS LDB s_x PHS LDB s_y PHS         ; clear the small explosion
                    JPS DrawSmall PLS PLS PLS
                    CLB s_state                               ; back to normal
                    LDB s_y CPI 24 BEQ us_rts                 ; eat up wall infront of the explosion
                      LDI 3 PHS LDB s_x PHS LDB s_y SUI 3 PHS
                      JPS DrawSmall PLS PLS PLS
                      RTS

  us_fired:       JPS DeleteLaser                             ; delete laser at the old poition
                  LDB s_y CPI 28 BGT us_flying                ; new position would be 4 pixels higher (24)
                    LDI 0 PHS                                 ; draw explosion at the top
                    LDI 4 SU.B s_x PHS                        ; set explosion (x|y)
                    LDI 24 STB s_y PHS
                    JPS DrawSmall PLS PLS PLS
                    LDI 2 STB s_state LDI 12 STB s_timer
                    RTS
    us_flying:    MIZ 4,1                                     ; PIXEL-EXACT COLLISION DETECTION starting from old top
                  LDB s_y LL6 STB addr+0                      ; LSB of ypos*64
                  LDB s_y RL7 ANI 63 ADI >ViewPort STB addr+1 ; MSB of ypos*64 (rotate via C)
                  LDB s_x RL6 ANI 63 ADI <ViewPort OR.B addr+0 ; xpos/8
                  LDB s_x ANI 7 ADI LL0+0 STB us_llx          ; use sub pixel pos
                  LDI 1                                       ; generate pixel mask
  us_llx:           0xcc                                      ; this instruction gets modified
                  STB us_mask
  us_flyloop:     DEB s_y LDI 64 SUW addr LDR addr            ; move one pixel up
                  ANB us_mask CPI 0 BEQ us_nopixel
                    ; pixel is white -> check for collision with alien
                    LDB s_x SUB a_x+0 STB s_dx
                      RL5 ANI 15 STB s_ix                     ; horizontal tile index of current alien
                    LDB a_y SUB s_y STB s_dy
                      RL6 ANI 31 STB s_by LR1 STB s_iy        ; vertical byte index, vertical tile index
                    LDB s_dx CPI 176 BCS us_noalien
                      LDB s_dy CPI 80 BCS us_noalien
                        LDI >a_alive STB us_ptr+1
                        LDB s_iy STB us_ptr+0
                        LL1 PHS AD.B us_ptr+0 PLS
                        LL2 AD.B us_ptr+0
                        LDB s_ix AD.B us_ptr+0
                        LDI <a_alive ADW us_ptr
                        LDR us_ptr CPI 1 BNE us_noalien
                          ; alien getroffen
                          LDI 0 STR us_ptr                    ; mark alien as dead
                          DEB a_total LDI 1 STB a_halt
                          LDI 12 STB s_timer LDI 3 STB s_state
                          LDI 11 PHS
                          LDB s_ix LL4 ADB a_x+0 STB s_x PHS
                          LDB s_by LL3 NEG ADB a_y SUI 7 STB s_y PHS
                          JPS DrawSprite PLS PLS PLS          ; draw alien pop
                          LDB s_iy LR1 INC ADW score
                          LDI 2 STB _XPos LDI 2 STB _YPos LDB score+0 PHS LDB score+1 PHS JPS DecPrint PLS PLS
                          RTS
                    ; no alien hit -> check for collision with wall, shot or saucer
  us_noalien:       LDB s_y CPI 40 BCS us_wallshot
                      ; saucer was hit
                      LDI 2 STB u_state CLB s_state
                      RTS
  us_wallshot:      ; wall or alien shot was hit
                    LDI 0 PHS LDI 4 SU.B s_x PHS DEB s_y PHS  ; store correct explosion position
                    JPS DrawSmall PLS PLS PLS                 ; show little explosion
                    LDI 2 STB s_state LDI 12 STB s_timer
                    RTS                                       ; exit without drawing the Laser!
  us_nopixel:       DEZ 1 BGT us_flyloop
                    JPS DrawLaser                             ; no collisions => draw the laser
                    RTS

  us_mask:        0
  us_ptr:         0x0000

ResetAliens:      LDI 26 STB a_x+0 CLB a_x+1
                  LDB level ADI 15 LL3 DEC STB a_y
                  LDI 0xff STB a_num
                  LDI 55 STB a_total
                  LDI 2 STB a_step
                  CLB a_halt
                  CLB a_costume
                  MIZ 55,0
                  LDI <a_alive STB ra_loop+3
                  LDI >a_alive STB ra_loop+4
  ra_loop:        LDI 1 STB 0xffff INW ra_loop+3 DEZ 0 BGT ra_loop
                  RTS

UpdateAliens:     LDB a_halt CPI 1 BEQ ua_rts
  ua_nextnum:       INB a_num CPI 55 BCC ua_below
                      CLB a_num LDB a_costume XRI 1 STB a_costume ; change costume
                      JPS ua_movexstep
  ua_below:         LDI <a_alive STB ua_ptr+1
                    LDI >a_alive STB ua_ptr+2
                    LDB a_num ADW ua_ptr+1                    ; set alien index
  ua_ptr:           LDB 0xffff                                ; self-modifying code here
                    CPI 0 BEQ ua_nextnum
                      ; here we have the current alien to move
                      LDB a_num PHS JPS GetModDiv11
                      STB a_pic LL4 STB a_r
                      PLS LL4 STB a_c
                      LDB a_pic ANI 6 ORB a_costume           ; prepare costume
                      PHS
                      LDB a_x+0 STB ua_pos+0                  ; prepare x
                      LDB a_x+1 STB ua_pos+1
                      LDB a_c ADW ua_pos LDB ua_pos+0 PHS
                      LDB a_y SUI 7 SUB a_r PHS               ; prepare y
                      JPS DrawSprite PLS PLS PLS              ; draw the alien
                      JPS KeyHandler
                      LDI 12 PHS                              ; costume 12 is empty for erasing
                      LDB ua_pos+0 PHS
                      LDB a_y SUI 15 SUB a_r PHS
                      JPS DrawSprite PLS PLS PLS              ; erase the sprite above (slow!)
                      LDB a_y SUI 7 SUB a_r CPI 192 BCC ua_notlanded ; check for aliens reaching the ground
                        LDI 1 STB lives LDI 60 STB waitframes ; take away spare lives...
                        LDI 3 STB gamestate                   ; ... and destroy ship
                        RTS
  ua_notlanded:         LDB ua_pos CPI 10 BCC ua_turnaliens   ; check for aliens reaching the border => turn
                        CPI 198 BCS ua_turnaliens
                          RTS
  ua_turnaliens:      NEB a_step
                      JPS ua_movexstep
                      LDI 8 AD.B a_y
                      LDI 0xff STB a_num
  ua_rts:             RTS

  ua_movexstep:        LDB a_step CPI 2 BNE ua_substep        ; move aliens a step
                       ADW a_x RTS
  ua_substep:          LDI 2 SUW a_x RTS

  ua_pos:          0xffff

; ----------------------------------------------------------------------------------------------

; -----------------------------------------------
; Fast keyboard handler
; modifies: key states "left", "right" and "fire"
; -----------------------------------------------
KeyHandler:     INK CPI 0xff BEQ key_rts
                  CPI 0xf0 BEQ release
  key_entry:    CPI 0x29 BEQ isspace
                CPI 0x1c BEQ isa
                CPI 0x23 BEQ isd
  key_rts:        RTS
isa:            MBB pressed,left ORI 1 STB pressed CLB right RTS
isspace:        MBB pressed,fire ORI 1 STB pressed RTS        ; no counterpart to clear here
isd:            MBB pressed,right ORI 1 STB pressed CLB left RTS

                ; PS2 release detection (M. Kamprath): Wait for max 10ms on a followup data
release:        CLZ 0xff                                      ; use 0xff as a byte counter
  key_wait:     INK CPI 0xff BNE key_release                  ; poll for max 10ms: (3+2+3+18*16+5+4) * 256 * 0.125ns
                  NOP NOP NOP NOP NOP NOP NOP NOP NOP NOP     ; wait for key up datagram
                  NOP NOP NOP NOP NOP NOP NOP NOP NOP
                  INZ 0xff BCC key_wait
                    RTS                                       ; timeout! => no 2nd datagram arrived -> dismiss event
  key_release:  STZ 0xff CLB pressed LDZ 0xff FPA key_entry   ; released key was received! -> analyze it now

pressed:        1

; print number 000 - 999 +  '0'
; push: number_lsb, number_msb
; pull: #, #
; pu_len (2 bytes), pu_n (1 byte)
DecPrint:       LDS 3 STB pu_len+1
                LDS 4 STB pu_len+0
                LDI '0' STB pu_n
  p100loop:     LDI 100 SUW pu_len BCC p99end100
                  INB pu_n JPA p100loop
  p99end100:    LDI 100 ADW pu_len
                LDB pu_n JAS _PrintChar
                LDI '0' STB pu_n
  p10loop:      LDI 10 SU.B pu_len+0 BCC p99end10
                  INB pu_n JPA p10loop
  p99end10:     LDB pu_n JAS _PrintChar
                LDI 58 AD.B pu_len+0
                LDB pu_len+0 JAS _PrintChar
                LDI '0' JAS _PrintChar
                RTS
pu_len:         0xffff
pu_n:           0xff

; ----------------------------------------------------------------------------------
; Draws a 16x8 pixel sprite (alien, ship, explosions) at the given position (0..255)
; push: num, x, y
; pull: #, #, #
; modifies: X, Y registers
; ----------------------------------------------------------------------------------
DrawSprite:     CLW mask+1 LDI 0xff STB mask+0 STB mask+3     ; prepare the erase rect mask
                LDI <sprites STB dptr+0 LDI >sprites STB dptr+1 ; init sprite data pointer
                LDS 5 LL4 ADW dptr                            ; point to sprite num (+ num*16 bytes)
                LDS 3 LL6 STB addr+0                          ; LSB of ypos*64
                LDS 3 RL7 ANI 63 ADI >ViewPort STB addr+1     ; MSB of ypos*64 (rotate via C)
                LDS 4 RL6 ANI 63 ADI <ViewPort OR.B addr+0    ; xpos/8
                LDS 4 ANI 7 STZ 2 DEC FCC maskdone            ; store sub byte pixel pos
                  STZ 0
  maskloop:       LLL mask DEZ 0 FCS maskloop                 ; shift mask once to pixel position
  maskdone:     MIZ 8,1                                       ; number of lines to process
  lineloop:     LDR dptr STB buffer+0 INW dptr                ; copy the sprite bit mask
                LDR dptr STB buffer+1 INW dptr CLB buffer+2
                LDZ 2 DEC FCC shiftdone                       ; shift that buffer to pixel position
                  STZ 0
  shiftloop:      LLL buffer DEZ 0 FCS shiftloop
  shiftdone:    LDB mask+1 ANR addr ORB buffer+0 STR addr INW addr ; delete old sprite rect
                LDB mask+2 ANR addr ORB buffer+1 STR addr INW addr ; and draw new sprite
                LDB mask+3 ANR addr ORB buffer+2 STR addr LDI 62 ADW addr ; ... and move to the next line
                DEZ 1 FGT lineloop                            ; haben wir alle sprite daten verarbeitet?
                  RTS

dptr:           0xffff                                        ; sprite data pointer
shift:          0xff                                          ; number of pixels to shift
addr:           0xffff                                        ; vram address to write to
buffer:         0, 0, 0, 0xff                                 ; generate the shifted sprite pattern
mask:           0xff, 0, 0, 0xff                              ; generate the shifted delete pattern

; ----------------------------------------------------------------------------------
; Draws a 3x8 pixel alien shot at the given position (0..255)
; push: num, x, y
; pull: #, #, #
; modifies: X, Y registers
; ----------------------------------------------------------------------------------
DrawShot:       LDI <shots STB dptr+0 LDI >shots STB dptr+1   ; init sprite data pointer
                LDS 5 LL3 ADW dptr                            ; point to shot num (+ num*8 bytes)
                LDS 3 LL6 STB addr+0                          ; LSB of ypos*64
                LDS 3 RL7 ANI 63 ADI >ViewPort STB addr+1     ; MSB of ypos*64 (rotate via C)
                LDS 4 RL6 ANI 63 ADI <ViewPort OR.B addr+0    ; xpos/8
                LDS 4 ANI 7 STB shift                         ; store sub byte pixel pos
                MIZ 8,1                                       ; number of lines to process
  ds_lineloop:  LDR dptr STB buffer+0
                ORI 0xf8 STB buffer+2 INW dptr                ; prepare the bit masks
                CLB buffer+1 LDI 0xff STB buffer+3
                LDB shift STZ 0 DEZ 0 BCC ds_shiftdone        ; shift that buffer to pixel position
  ds_shiftloop:   LLW buffer+0 LLW buffer+2 INB buffer+2      ; set mask, keep mask
                  DEZ 0 BCS ds_shiftloop
  ds_shiftdone:     LDB buffer+2 ANR addr ORB buffer+0 STR addr INW addr
                    LDB buffer+3 ANR addr ORB buffer+1 STR addr LDI 63 ADW addr ; ... and move to the next line
                    DEZ 1 BNE ds_lineloop                     ; haben wir alle sprite daten verarbeitet?
                      RTS

; ----------------------------------------------------------------------------------
; Draws or erases an 8x8 pixel sprite at the given position (0..255)
; push: num 0..1 (bit1=0: draw, bit1=1: erase), x, y
; pull: #, #, #
; modifies: X, Y registers
; ----------------------------------------------------------------------------------
DrawSmall:      LDI <smalls STB dptr+0 LDI >smalls STB dptr+1 ; init sprite data pointer
                LDS 5 ANI 1 LL3 ADW dptr                      ; point to shot num (+ num*8 bytes)
                LDS 3 LL6 STB addr+0                          ; LSB of ypos*64
                LDS 3 RL7 ANI 63 ADI >ViewPort STB addr+1     ; MSB of ypos*64 (rotate via C)
                LDS 4 RL6 ANI 63 ADI <ViewPort OR.B addr+0    ; xpos/8
                LDS 4 ANI 7 STB shift                         ; store sub byte pixel pos
                MIZ 8,1                                       ; number of lines to process
  dm_lineloop:  LDR dptr STB buffer+0 INW dptr CLB buffer+1   ; prepare the bit masks
                LDB shift STZ 0 DEZ 0 BCC dm_shiftdone        ; shift that buffer to pixel position
  dm_shiftloop:   LLW buffer+0 DEZ 0 BCS dm_shiftloop
  dm_shiftdone: LDS 5 ANI 2 CPI 2 BEQ dm_clearit
                  LDB buffer+0 ORR addr STR addr INW addr     ; store line buffer to VRAM addr
                  LDB buffer+1 ORR addr STR addr JPA dm_common
  dm_clearit:   LDB buffer+0 NOT ANR addr STR addr INW addr   ; store line buffer to VRAM addr
                LDB buffer+1 NOT ANR addr STR addr
  dm_common:    LDI 63 ADW addr                               ; ... and move to the next line
                DEZ 1 BNE dm_lineloop                         ; haben wir alle sprite daten verarbeitet?
                  RTS

; ----------------------------------------------------------------------------------
; Draws a 24x16 pixel sprite (wall) at the given position (0..255)
; push: x, y
; pull: #, #
; modifies: X, Y registers
; ----------------------------------------------------------------------------------
DrawWall:       LDI <wall STB dptr+0 LDI >wall STB dptr+1     ; hard-coded wall data pointer
                LDS 3 LL6 STB addr+0                          ; LSB of ypos*64
                LDS 3 RL7 ANI 63 ADI >ViewPort STB addr+1     ; MSB of ypos*64 (rotate via C)
                LDS 4 RL6 ANI 63 ADI <ViewPort OR.B addr+0    ; xpos/8
                LDS 4 ANI 7 STB shift                         ; store sub byte pixel pos
                MIZ 16,1                                      ; number of lines to process
  dw_lineloop:  LDR dptr STB buffer+0 INW dptr                ; prepare the bit masks
                LDR dptr STB buffer+1 INW dptr
                LDR dptr STB buffer+2 INW dptr CLB buffer+3
                LDB shift STZ 0 DEZ 0 BCC dw_shiftdone        ; shift that buffer to pixel position
  dw_shiftloop:   LLW buffer+0 RLW buffer+2 DEZ 0 BCS dw_shiftloop
  dw_shiftdone:     LDB buffer+0 ORR addr STR addr INW addr
                    LDB buffer+1 ORR addr STR addr INW addr
                    LDB buffer+2 ORR addr STR addr INW addr
                    LDB buffer+3 ORR addr STR addr LDI 61 ADW addr ; ... and move to the next line
                    DEZ 1 BNE dw_lineloop                     ; haben wir alle sprite daten verarbeitet?
                      RTS

DrawLaser:      LDB s_y LL6 STB addr+0                        ; LSB of ypos*64
                LDB s_y RL7 ANI 63 ADI >ViewPort STB addr+1   ; MSB of ypos*64 (rotate via C)
                LDB s_x RL6 ANI 63 ADI <ViewPort OR.B addr+0  ; xpos/8
                LDB s_x ANI 7 ADI LL0+0 STB dl_llx            ; use sub pixel pos
                LDI 1
  dl_llx:         0xcc                                        ; trick: instruction LL0..LL7 is placed here
                STZ 0
                LDR addr ORZ 0 STR addr LDI 64 ADW addr
                LDR addr ORZ 0 STR addr LDI 64 ADW addr
                LDR addr ORZ 0 STR addr LDI 64 ADW addr
                LDR addr ORZ 0 STR addr
                RTS

  dl_mask:      0

DeleteLaser:    LDB s_y LL6 STB addr+0                        ; LSB of ypos*64
                LDB s_y RL7 ANI 63 ADI >ViewPort STB addr+1   ; MSB of ypos*64 (rotate via C)
                LDB s_x RL6 ANI 63 ADI <ViewPort OR.B addr+0  ; xpos/8
                LDB s_x ANI 7 ADI LL0+0 STB de_llx            ; use sub pixel pos
                LDI 1
  de_llx:         0xcc                                        ; trick: instruction LL0..LL7 is placed here
                NOT STZ 0                                     ; invert mask for deletion
                LDR addr ANZ 0 STR addr LDI 64 ADW addr
                LDR addr ANZ 0 STR addr LDI 64 ADW addr
                LDR addr ANZ 0 STR addr LDI 64 ADW addr
                LDR addr ANZ 0 STR addr
                RTS

; ---------------------------------
; returns the num / 11 and num % 11
; push:          num 0..54
; pull:         num % 11
; A: return     num / 11
; ---------------------------------
GetModDiv11:    LDS 3
                CPI 44 BCS gdm44
                  CPI 33 BCS gdm33
                    CPI 22 BCS gdm22
                      CPI 11 BCS gdm11
                        STS 3 LDI 0 RTS
  gdm44:        SUI 44 STS 3 LDI 4 RTS
  gdm33:        SUI 33 STS 3 LDI 3 RTS
  gdm22:        SUI 22 STS 3 LDI 2 RTS
  gdm11:        SUI 11 STS 3 LDI 1 RTS

; ----------------------------------------------------------------------------------------------

sprites:        0xc0,0x03,0xf8,0x1f,0xfc,0x3f,0x9c,0x39,0xfc,0x3f,0x70,0x0e,0x98,0x19,0x30,0x0c,
                0xc0,0x03,0xf8,0x1f,0xfc,0x3f,0x9c,0x39,0xfc,0x3f,0x60,0x06,0xb0,0x0d,0x0c,0x30,
                0x20,0x08,0x40,0x04,0xe0,0x0f,0xb0,0x1b,0xf8,0x3f,0xe8,0x2f,0x28,0x28,0xc0,0x06,
                0x20,0x08,0x48,0x24,0xe8,0x2f,0xb8,0x3b,0xf8,0x3f,0xf0,0x1f,0x20,0x08,0x10,0x10,
                0x80,0x01,0xc0,0x03,0xe0,0x07,0xb0,0x0d,0xf0,0x0f,0xa0,0x05,0x10,0x08,0x20,0x04,
                0x80,0x01,0xc0,0x03,0xe0,0x07,0xb0,0x0d,0xf0,0x0f,0x40,0x02,0xa0,0x05,0x50,0x0a,
                0xe0,0x03,0xf8,0x0f,0xfc,0x1f,0x56,0x35,0xff,0x7f,0xdc,0x1d,0x08,0x08,0x00,0x00,
                0xc0,0x07,0xf0,0x1f,0xf8,0x3f,0xac,0x6a,0xfe,0xff,0xb8,0x3b,0x10,0x10,0x00,0x00,
                0x00,0x01,0x80,0x03,0x80,0x03,0xf8,0x3f,0xfc,0x7f,0xfc,0x7f,0xfc,0x7f,0xfc,0x7f,
                0x0c,0x20,0x41,0x98,0x08,0x03,0x40,0x40,0xd2,0x8c,0x84,0x23,0xf8,0x0f,0xec,0x4f,
                0x40,0x00,0x00,0x08,0x40,0x05,0x48,0x00,0x80,0x0d,0xa2,0x15,0xf8,0x27,0xfc,0xaf,
                0x48,0x24,0x90,0x12,0x20,0x08,0x0c,0x60,0x20,0x08,0x10,0x10,0x88,0x22,0x40,0x04,
                0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,

shots:          0x00,0x02,0x01,0x02,0x04,0x02,0x01,0x02,0x00,0x00,0x02,0x04,0x02,0x01,0x02,0x04,
                0x00,0x02,0x04,0x02,0x01,0x02,0x04,0x02,0x00,0x00,0x02,0x01,0x02,0x04,0x02,0x01,
                0x00,0x02,0x02,0x02,0x02,0x02,0x02,0x07,0x00,0x02,0x02,0x02,0x02,0x07,0x02,0x02,
                0x00,0x02,0x02,0x07,0x02,0x02,0x02,0x02,0x00,0x02,0x07,0x02,0x02,0x02,0x02,0x02,
                0x00,0x02,0x02,0x02,0x02,0x02,0x02,0x02,0x00,0x02,0x03,0x06,0x02,0x03,0x06,0x02,
                0x00,0x02,0x02,0x02,0x02,0x02,0x02,0x02,0x00,0x02,0x06,0x03,0x02,0x06,0x03,0x02,
                0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,

smalls:         0x91,0x44,0x7e,0xff,0xff,0x7e,0x24,0x89,0x10,0x3a,0x78,0x3c,0x3a,0x7c,0x3a,0x54,

wall:           0xf0,0xff,0x03,0xf8,0xff,0x07,0xfc,0xff,0x0f,0xfe,0xff,0x1f,
                0xff,0xff,0x3f,0xff,0xff,0x3f,0xff,0xff,0x3f,0xff,0xff,0x3f,
                0xff,0xff,0x3f,0xff,0xff,0x3f,0xff,0xff,0x3f,0xff,0xff,0x3f,
                0x7f,0xc0,0x3f,0x3f,0x80,0x3f,0x1f,0x00,0x3f,0x1f,0x00,0x3f,

hiscore:        0x00c6

u_values:       0, 30, 20, 10, 10, 5, 5, 5, 5
u_text:         '---', 0, '300', 0, '200', 0, '100', 0, '100', 0
                ' 50', 0, ' 50', 0, ' 50', 0, ' 50', 0
u_empty:        

text0:          
text1:          
text2:          
text3:          
text4:          
text5:          
text6:          
text7:          
text8:          
text9:          
texta:          
textb:          
textc:          
textd:          
texte:          

; ----------------------------------------------------------------------------------------------

#mute

; global variables of ALIEN INVADERS
gamestate:      0
score:          0x0000
shippos:        0        ; horizontal position of the ship (left upper corner)
lives:          0
level:          0
fire:           0        ; keyboard control state, modified by KeyHandler
left:           0
right:          0
waitframes:     0x0000
framecount:     0x00
counter:        0x0000

a_total:        0        ; alien system
a_x:            0x0000
a_y:            0
a_c:            0
a_r:            0
a_pic:          0
a_num:          0
a_step:         0        ; 1: ax+=2, -1: ax-=2
a_costume:      0
a_halt:         0        ; can be used to stop the movement for a while
a_alive:        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0               ; state of each alien
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

s_x:            0
s_y:            0
s_timer:        0
s_state:        0
s_dx:           0
s_dy:           0
s_ix:           0
s_iy:           0
s_by:           0

u_state:        0
u_valptr:       0xffff
u_timer:        0x0000
u_pos:          0
u_step:         0

as_ptr:         0xffff
as_col:         0
as_c:           0
as_r:           0
as_colcmod:     0    ; holds (col+c)%11
as_px:          0
as_py:          0

as0_active:     0    ; -1: free, >=0: shot type
as0_x:          0
as0_y:          0    ; TOP MIDDLE position of the shot
as0_timer:      0
as1_active:     0    ; -1: free, >=0: shot type
as1_x:          0
as1_y:          0    ; TOP MIDDLE position of the shot
as1_timer:      0
as2_active:     0    ; -1: free, >=0: shot type
as2_x:          0
as2_y:          0    ; TOP MIDDLE position of the shot
as2_timer:      0

#org 0x430c     ViewPort:
; ----------------------------------------------------------------------------------------------

#mute           ; MinOS API definitions generated by 'asm os.asm -s_'

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
#org 0xf021 _SerialWait:
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
