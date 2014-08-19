; Begin code at $7530
org $7530

; System variables
tv_flag     EQU $5c3c   ; TV flags
last_k      EQU $5c08   ; Last pressed key
clr_screen  EQU $0daf   ; ROM routine to clear the screen

; Star Structure
; X - 1 Byte        $00 - $20
; Xbit - 1 Byte     $7 - $0
; Y - 1 Byte        $00 - $bf
; ----------
; Z - 1 Byte
; ZLoop - 1Byte
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
    ld a, (hl)
    ld e, a
    inc hl
    
    ld a, (hl)
    ld d, a
    
    push hl
    
    call get_screen_address
    call write_pixel
    
    pop hl
    inc hl
    dec c
    jr nz, main
    
    pop bc
    ret


PROC
tbl_origin  db  $0, $1, $2, $3, $4, $5, $6, $7
tbl_dest    db  128, 64, 32, 16, 8, 4, 2, 1

write_pixel
    push hl
    ld de, tbl_origin
    ld hl, tbl_dest
lookup_table_loop
    ld b, a
    ld a, (de)
    cp b
    jr z, lookup_table_found
    inc de
    inc hl
    ld a, b
    jr lookup_table_loop
lookup_table_found
    ld a, (hl)
    ld b, a
    pop hl
    ld a, (hl)
    or b
    ld (hl), a
    ret
ENDP    

PROC
; Calculate the high byte of the screen address and store in H reg.
; On Entry: D reg = X coord,  E reg = Y coord
; On Exit: HL = screen address, A = pixel postion
get_screen_address
	ld a,e
	and %00000111
	ld h,a
	ld a,e
	rra
	rra
	rra
	and %00011000
	or h
	or %01000000
	ld h,a
; Calculate the low byte of the screen address and store in L reg.
	ld a,d
	rra
	rra
	rra
	and %00011111
	ld l,a
	ld a,e
	rla
	rla
	and %11100000
	or l
	ld l,a
; Calculate pixel position and store in A reg.
	ld a,d
	and %00000111
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