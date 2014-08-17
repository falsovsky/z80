; Begin code at $7530
org $7530

; System variables
tv_flag     EQU $5c3c   ; TV flags
last_k      EQU $5c08   ; Last pressed key
clr_screen  EQU $0daf   ; ROM routine to clear the screen

; Star Structure
; X - 1 Byte - $00 - $ff
; Y - 1 Byte - $00 - $bf
; Z - 1 Byte
; Color - 1 Byte
STAR_SIZE   EQU $4
MAX_STARS   EQU 10

INCLUDE "starrnd.asm"

start
    xor a
    ld (tv_flag), a
    push bc

    call clear_screen

    ld hl, StarRnd
    ld c, MAX_STARS
main
    push bc
    ld a, (hl)
    ld d, a
    inc hl
    ld a, (hl)
    ld e, a
    call calculate_screen_address
    ld a, (de)
    set 0, a
    ld (de), a
    pop bc
    inc hl
    dec c
    jr nz, main
    
    pop bc
    ret

PROC
;Input:
; D = Y Coordinate
; E = X Coordinate
;
;Output:
; DE = Screen Address
;
calculate_screen_address
    ld a,d
    rla
    rla
    and 224
    or e
    ld e,a
    ld a,d
    rra
    rra
    or 128
    rra
    xor d
    and 248
    xor d
    ld d,a
    ret
ENDP

PROC
;Input:
; DE = Current screen address
;
;Output:
; DE = (Y + 1) screen address
;
increment_y
    inc d
    ld a,d
    and 7
    ret nz
    ld a,e
    add a,32
    ld e,a
    ret c
    ld a,d
    sub 8
    ld d,a
    ret
ENDP

PROC
INCLUDE "clear.asm"
ENDP

END start