; Begin code at $7530
org $7530

; System variables
tv_flag     EQU $5c3c   ; TV flags
last_k      EQU $5c08   ; Last pressed key
clr_screen  EQU $0daf   ; ROM routine to clear the screen

; Screen is 256x192

; Star Structure
; X         1 Byte  $0 - $ff
; Y         1 Byte  $0 - $c0
; Speed     1 Byte  $1 - $3
MAX_STARS   EQU 10

start
    xor a
    ld (tv_flag), a
    push bc

    call clear_screen
    call initStars

main_start
    ld hl, STARS
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
    call clear_pixel    ; Uses those values and writes the pixel
    pop bc
    pop hl
    
    dec hl

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
    call write_pixel    ; Uses those values and writes the pixel
    pop bc
    pop hl

    inc hl      ; Next star
    inc hl      ; Next star

    dec c       ; Decrement counter
    jr nz, main ; Repeat if not zero

    call increment_x    ; Increment X position in each star
    jr main_start   ; Do it all over again

    pop bc
    ret

PROC
initStars
    push bc
    ld d, MAX_STARS
    ld hl, STARS
initStars_loop
    push hl
    call getRandomX
    pop hl

    ld (hl), a

    inc hl

    push hl
    call getRandomY
    pop hl

    ld (hl), a

    inc hl

    push hl
    call getRandomSpeed
    pop hl

    ld (hl), a

    inc hl

    dec d
    jr nz, initStars_loop

    pop bc
    ret
ENDP

PROC
getRandomX
    push hl
getRandomX_loop
    ld hl, (xrandpos)
    ld a, (hl)
    cp $0
    jr z, getRandomX_reset
    inc hl
    ld (xrandpos), hl
    pop hl
    ret
getRandomX_reset
    ld hl, xranddata
    ld (xrandpos), hl
    jr getRandomX_loop
ENDP

PROC
getRandomY
    push hl
getRandomY_loop
    ld hl, (yrandpos)
    ld a, (hl)
    cp $0
    jr z, getRandomY_reset
    inc hl
    ld (yrandpos), hl
    pop hl
    ret
getRandomY_reset
    ld hl, yranddata
    ld (yrandpos), hl
    jr getRandomY_loop
ENDP

PROC
getRandomSpeed
    push hl
getRandomSpeed_loop    
    ld hl, (speedrandpos)
    ld a, (hl)
    cp $0
    jr z, getRandomSpeed_reset
    inc hl
    ld (speedrandpos), hl
    pop hl
    ret
getRandomSpeed_reset
    ld hl, speedranddata
    ld (speedrandpos), hl
    jr getRandomSpeed_loop
ENDP

PROC
; Increment X
increment_x
    push bc
    ld hl, STARS
    ld c, MAX_STARS
increment_x_loop
    ld a, (hl)
    cp $fc
    jr z, increment_x_zero
    jr nc, increment_x_zero 

    inc hl  ; Skip to Y
    inc hl  ; Skip to Speed

    ld b, (hl)  ; Read speed to B
    add a, b    ; Add speed to X

    dec hl      ; Back to Y
    dec hl      ; Back to X
increment_x_update
    ld (hl), a
    inc hl
    inc hl
    inc hl
    dec c
    jr nz, increment_x_loop
    pop bc
    ret
increment_x_zero
    push bc
    inc hl  ; Set to Y position

    push hl
    call getRandomY
    pop hl

    ld (hl), a  ; Set Y = getRandomY

    inc hl  ; Set to speed position

    push hl
    call getRandomSpeed
    pop hl

    ld (hl), a  ; Set Speed = getRandomSpeed

    dec hl
    dec hl  ; Get back to X position

    ld a, $0    ; X = 0
    pop bc
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
    ld a, (hl)
    or c
    ld (hl), a
    pop bc
    ret
ENDP

PROC
; Video Ram Address in HL
; Pixel to write in A
clear_pixel
    push bc
    ld b, a
    ld c, $0
    scf
clear_pixel_loop
    ld a, c
    rra
    ld c, a
    ld a, b
    jr z, clear_pixel_do_it
    dec b
    jr write_pixel_loop
clear_pixel_do_it
    ld a, (hl)
    or c
    ld (hl), a
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

STARS
    REPT MAX_STARS
        DB $0,$0,$0
    ENDM

INCLUDE "randomvalues.asm"

END start