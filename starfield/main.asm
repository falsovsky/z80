; Begin code at $7530
org $7530

; System variables
tv_flag     EQU $5c3c   ; TV flags
last_k      EQU $5c08   ; Last pressed key
clr_screen  EQU $0daf   ; ROM routine to clear the screen

; Screen is 256x192

; Star Structure
; X - 1 Byte    $00 - $ff
; Y - 1 Byte    $00 - $c0
; ----------
; Z - 1 Byte
STAR_SIZE   EQU $4
MAX_STARS   EQU 10

INCLUDE "starrnd.asm"

start
    xor a
    ld (tv_flag), a
    push bc
    call clear_screen

main_start
    ld hl, StarRnd
    ld c, MAX_STARS

main
    ld a, (hl)  ; HL points to X
    dec a
    ld d, a     ; Save X-1 to D
    inc hl

    ld a, (hl)  ; HL now points to Y
    ld e, a     ; Save Y to E

    push hl
    push bc
    call get_screen_address
    ; Video RAM address for those X,Y is now in HL and the bit needed
    ; to be set in that address value is in A
    ld d, $0            ; 0 - Clear pixel
    call write_pixel    ; Uses those values and writes the pixel
    pop bc
    pop hl

    dec hl      ; Get back to X

    ld a, (hl)  ; HL points to X
    ld d, a     ; Save X to D
    inc hl

    ld a, (hl)  ; HL now points to Y
    ld e, a     ; Save Y to E

    push hl
    push bc
    call get_screen_address
    ; Video RAM address for those X,Y is now in HL and the bit needed
    ; to be set in that address value is in A
    ld d, $1            ; 1 - Write pixel
    call write_pixel    ; Uses those values and writes the pixel
    pop bc
    pop hl

    inc hl      ; Next star

    dec c       ; Decrement counter
    jr nz, main ; Repeat if not zero

    push hl
    push bc
    call increment_x    ; Increment X position in each star
    pop bc
    pop hl
    jr main_start   ; Do it all over again

    pop bc
    ret

PROC
; Increment X
increment_x
    push bc
    ld hl, StarRnd
    ld c, MAX_STARS
increment_x_loop
    ld a, (hl)
    cp $ff
    jr z, increment_x_zero
    inc a
increment_x_update
    ld (hl), a
    inc hl
    inc hl
    dec c
    jr nz, increment_x_loop
    pop bc
    ret
increment_x_zero
    ld a, $0
    jr increment_x_update
ENDP

PROC
; Video Ram Address in HL
; Pixel to write in A
write_pixel
    push bc
    ld b, a
    ld c, $0
    scf
write_pixel_loop
    ld a, c
    rra
    ld c, a
    ld a, b
    jr z, write_pixel_do_it
    dec b
    jr write_pixel_loop
write_pixel_do_it
; o bit a settar está em C
    ld a, d
    cp $1
    jr z, write_pixel_set
write_pixel_unset
    ld a, (hl)
    and c
    ld (hl), a
    jr write_pixel_end
write_pixel_set
    ld a, (hl)
    or c
    ld (hl), a
write_pixel_end
    pop bc
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
INCLUDE "clear.asm"
ENDP

END start