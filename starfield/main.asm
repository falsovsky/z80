; Begin code at $7530
org $7530

; System variables
tv_flag     EQU $5c3c   ; TV flags
last_k      EQU $5c08   ; Last pressed key

; Screen is 256x192

MAX_STARS   EQU 100

; Star Structure
STARS
    REPT MAX_STARS
        db $0   ; X
        db $0   ; Y
        db $0   ; Speed
        db $0   ; Previous X
        db $0   ; Previous Y
    ENDM


start
    xor a
    ld (tv_flag), a
    push bc

    call clear_screen   ; Clear the screen
    call init_stars  ; Initialize the number of stars defined in MAX_STARS

main_start
    ld hl, STARS    ; points to X
    ld c, MAX_STARS ; Set counter value

main
; CLEAR THE LAST POSITION
    push bc     ; save MAX_STARS in the stack

    ld de, $3
    add hl, de  ; skip to PrevX

    ld a, (hl)
    ld d, a     ; Save PrevX to D

    inc hl      ; points to PrevY

    ld a, (hl)
    ld e, a     ; Save PrevY to E

    push hl
    call get_screen_address
    ; Video RAM address for those X,Y is now in HL and the bit needed
    ; to be set in that address value is in A
    call clear_pixel    ; Uses those values and clears the pixel
    pop hl

    ld bc, $4
    sbc hl, bc  ; Go back to X

; WRITES THE PIXEL
    ld a, (hl)  ; HL should point to X
    ld d, a     ; Save X to D

    inc hl      ; points to Y

    ld a, (hl)
    ld e, a     ; Save Y to E

    push hl
    call get_screen_address
    ; Video RAM address for those X,Y is now in HL and the bit needed
    ; to be set in that address value is in A
    call write_pixel    ; Uses those values and writes the pixel
    pop hl

    ld bc, $4
    add hl, bc  ; Skip 4 positions to the next star

    pop bc      ; Remove counter from stack
    dec c       ; Decrement counter

    jr nz, main ; Repeat if not zero

    call increment_x    ; Increment X position in each star
    jr main_start   ; Do it all over again

    pop bc
    ret

PROC
; D = valor minimo
; E = valor maximo
table
    db   82,97,120,111,102,116,20,12

get_rnd
    push bc

get_rnd_loop
    push de
    ld de, 0     ; c,i
    ld b, 0
    ld c, e
    ld hl, table
    add hl, bc

    ld c, (hl)   ; y = q[i]

    push hl

    ld a, e      ; i = ( i + 1 ) & 7
    inc a
    and 7
    ld e, a

    ld h, c      ; t = 256 * y
    ld l, b

    sbc hl, bc    ; t = 255 * y
    sbc hl, bc    ; t = 254 * y
    sbc hl, bc    ; t = 253 * y

    ld c, d
    add hl, bc    ; t = 253 * y + c

    ld d, h      ; c = t / 256

    ld (get_rnd_loop+2), de

    ld a,l      ; x = t % 256
    cpl           ; x = (b-1) - x = -x - 1 = ~x + 1 - 1 = ~x

    pop hl

    ld (hl), a   ; q[i] = x
    
    pop de
    
    ld h, a ; Save A to H

    ld a, e ; Valor maximo em A
    cp h

    jr z, get_rnd_ret   ; É igual
    jr c, get_rnd_loop ; Se for menor

    ld a, d
    cp h

    jr z, get_rnd_ret
    jr c, get_rnd_ret

    jr get_rnd_loop

get_rnd_ret
    ld a, h
    and a   ; Reset carry
    pop bc
    ret
ENDP

PROC
; Initialize stars X, Y and Speed with "random" values
init_stars
    push bc
    ld hl, STARS    ; HL points to X of first star
    ld c, MAX_STARS ; Number of stars to process

init_stars_loop
    push bc

    push hl
    ld d, 0
    ld e, 255
    call get_rnd    ; Get a random value between 0 and 255
    pop hl

    ld (hl), a      ; Set X value

    inc hl          ; points to Y

    push hl
    ld d, 0
    ld e, 191
    call get_rnd    ; Get a random value between 0 and 191
    pop hl

    ld (hl), a      ; Set Y value

    inc hl          ; points to Speed

    push hl
    ld d, 1
    ld e, 10
    call get_rnd    ; Get a random value between 1 and 10
    pop hl

    ld (hl), a      ; Set Speed value

    ld bc, $3
    add hl, bc      ; Skip 3 bytes to the next star

    pop bc
    dec c           ; Decrement counter
    jr nz, init_stars_loop  ; If not zero, do it again

    pop bc
    ret
ENDP

PROC
; Increment X
increment_x
    push bc
    ld hl, STARS
    ld c, MAX_STARS

increment_x_loop
; First lets copy current position to previous position
    ld d, (hl)  ; Save current X to D
    inc hl      ; points to Y
    ld e, (hl)  ; Save current Y to E

    inc hl      ; points to Speed
    inc hl      ; points to PrevX
    ld (hl), d  ; Save X
    inc hl      ; PrevY
    ld (hl), e  ; Save Y

    ld de, $4
    sbc hl, de  ; Go back 4 bytes to X

    ld a, (hl)  ; Is X at $FF - end of screen
    cp $ff
    jr z, increment_x_zero  ; Yes, lets reset it

; Increments X position by speed value
; X = X + Speed
    inc hl      ; points to Y
    inc hl      ; points to Speed

    ld b, (hl)  ; Read speed to B

    dec hl      ; Back to Y
    dec hl      ; Back to X

    add a, b    ; X = X + Speed
    jr c, increment_x_zero ; If carry is set, it passed $ff, lets reset

increment_x_update
; Saves to X the value in A
    ld (hl), a  ; Save X with the value in A

    ld de, $5
    add hl, de  ; Skip 5 bytes to the next star

    dec c       ; Decrement counter
    jr nz, increment_x_loop ; If not zero, do it again

    pop bc
    ret

increment_x_zero
; Sets X to 0 and Y and Speed to random values
    push bc
    inc hl      ; point to Y

    push hl
    ld d, 1
    ld e, 191
    call get_rnd
    pop hl

    ld (hl), a  ; Set Y value

    inc hl      ; point to speed

    push hl
    ld d, 1
    ld e, 10
    call get_rnd
    pop hl

    ld (hl), a  ; Set Speed value

    ld de, $2
    sbc hl, de  ; Get back to X position

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
    ld c, $ff
    and a   ; reset carry
clear_pixel_loop
    ld a, c
    rra
    ld c, a
    ld a, b
    jr z, clear_pixel_do_it
    dec b
    jr clear_pixel_loop
clear_pixel_do_it
    ld a, (hl)
    and c
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

END start