; Begin code at $7530
org $7530

; System variables
tv_flag     EQU $5c3c   ; TV flags
last_k      EQU $5c08   ; Last pressed key
clr_screen  EQU $0daf   ; ROM routine to clear the screen
frames      EQU $5c78

; Video RAM
LINHA9      EQU $4820
LINHA10     EQU $4840
LINHA11     EQU $4860   

; Star Structure
; X - 1 Byte - $00 - $ff
; Y - 1 Byte - $00 - $bf
; Z - 1 Byte
; Color - 1 Byte
STAR_SIZE   EQU $4
MAX_STARS   EQU 10
STARS       DS STAR_SIZE * MAX_STARS, 0

INCLUDE "starrnd.asm"

start
    xor a
    ld (tv_flag), a
    push bc

    call clear_screen
    ;call INITIALIZE_STARS
    ld c, 32
main
    ld de, frames
    ld a, (de)
    ld d, 0
    ld e, a
    ld hl, LINHA9
    add hl, de
    ld a, (hl)
    set 0,a
    ld (hl), a

    halt
    
    dec c
    jr nz, main
    
    pop bc
    ret

PROC
INITIALIZE_STARS
    push bc
    ld b, MAX_STARS
    ld hl, STARS
INITIALIZE_STARS_LOOP
    ld a, 10
    ld (hl),a
    inc hl
    ld a, 15
    ld (hl),a
    inc hl
    ld a, 1
    ld (hl),a
    inc hl
    djnz INITIALIZE_STARS_LOOP
    pop bc
    ret
ENDP

PROC
; Get screen address
; B = Y pixel position
; C = X pixel position
; Returns address in HL
Get_Pixel_Address
    ld a,b          ; Calculate Y2,Y1,Y0
    and %00000111   ; Mask out unwanted bits
    or %01000000    ; Set base address of screen
    ld h, a         ; Store in H
    ld a, b         ; Calculate Y7,Y6
    rra             ; Shift to position
    rra
    rra
    and %00011000   ; Mask out unwanted bits
    or h            ; OR with Y2,Y1,Y0
    ld h, a         ; Store in H
    ld a, b         ; Calculate Y5,Y4,Y3
    rla             ; Shift to position
    rla
    and %11100000   ; Mask out unwanted bits
    ld l, a         ; Store in L
    ld a, c         ; Calculate X4,X3,X2,X1,X0
    rra             ; Shift into position
    rra
    rra
    and %00011111   ; Mask out unwanted bits
    or l            ; OR with Y5,Y4,Y3
    ld l, a         ; Store in L
    ret
ENDP

PROC
INCLUDE "clear.asm"
ENDP

END start