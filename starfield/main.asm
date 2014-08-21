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
; PrevX
; PrevY
MAX_STARS   EQU 60

start
    xor a
    ld (tv_flag), a
    push bc

    call clear_screen   ; Clear the screen
    call initRandom
    call initStars  ; Initialize the number of stars defined in MAX_STARS

main_start
    ld hl, STARS    ; Points to X
    ld c, MAX_STARS

main
; CLEAR THE LAST POSITION
    ld de, $3   ; Skip to PrevX
    add hl, de

    ld a, (hl)
    ld d, a     ; Save PrevX to D
    inc hl      ; PrevY

    ld a, (hl)
    ld e, a     ; Save PrevY to E

    push bc
    push hl
    call get_screen_address
    ; Video RAM address for those X,Y is now in HL and the bit needed
    ; to be set in that address value is in A
    call clear_pixel    ; Uses those values clears the pixel
    pop hl

    ld bc, $4   ; Go back to X
    sbc hl, bc

    pop bc
; WRITES THE PIXEL
    ld a, (hl)  ; HL points to X
    ld d, a     ; Save X to D
    inc hl      ; Y

    ld a, (hl)
    ld e, a     ; Save Y to E

    push bc
    push hl
    call get_screen_address
    ; Video RAM address for those X,Y is now in HL and the bit needed
    ; to be set in that address value is in A
    call write_pixel    ; Uses those values and writes the pixel
    pop hl

    ld bc, $4   ; Jump 4 positions - Next star
    add hl, bc

    pop bc

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
    push bc ; Guarda o valor de RET na stack

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
    pop bc  ; Tira o valor de RET da stack
    ret
ENDP

PROC
initRandom
    push bc


    ; X
    ld b, MAX_STARS*2
    ld hl, xranddata
initRandomX
    
    push hl
    push bc
    ld d, 1
    ld e, 250
    call get_rnd    ; Get a random value <= 255
    pop bc
    pop hl
    
    ld (hl), a
    inc hl

    dec b
    jr nz, initRandomX


    ; Y
    ld b, MAX_STARS*2
    ld hl, yranddata
initRandomY

    push hl
    push bc
    ld d, 1
    ld e, 191
    call get_rnd    ; Get a random value <= 255
    pop bc
    pop hl
    
    ld (hl), a
    inc hl

    dec b
    jr nz, initRandomY


    ; Speed
    ld b, MAX_STARS*2
    ld hl, speedranddata
initRandomSpeed

    push hl
    push bc
    ld d, 1
    ld e, 4
    call get_rnd    ; Get a random value <= 255
    pop bc
    pop hl
    
    ld (hl), a
    inc hl

    dec b
    jr nz, initRandomSpeed

    pop bc
    ret
ENDP

PROC
; Initialize stars X and Y with "random" values
initStars
    push bc
    ld d, MAX_STARS ; Number of stars to process
    ld hl, STARS    ; HL points to X of first start

initStars_loop
    push de

    push hl
    call getRandomX
    pop hl

    ld (hl), a      ; Set X to random value

    inc hl          ; points to Y

    push hl
    call getRandomY
    pop hl

    ld (hl), a      ; Set Y to random value

    inc hl          ; points to Speed

    push hl
    call getRandomSpeed ; Get a random value for Speed | 1 - 4
    pop hl

    ld (hl), a      ; Set Speed to random value

    ld bc, $3       ; Jump to next star
    add hl, bc      ; Skip PrevX and PrevY

    pop de    
    dec d           ; Decrement counter
    jr nz, initStars_loop   ; If not zero, do it again

    pop bc
    ret
ENDP

PROC
; Gets a value a from a list of pre-calculated values
; Returns to begin after 0 is found | TODO: change this
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
; Gets a value a from a list of pre-calculated values
; Returns to begin after 0 is found | TODO: change this
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
; Gets a value a from a list of pre-calculated values
; Returns to begin after 0 is found | TODO: change this
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
    sbc hl, de  ; Go back to X

    ld a, (hl)  ; Is X at $FF - end of screen
    cp $ff
    jr z, increment_x_zero  ; Yes, lets reset

; Increments X position by speed value
; X = X + Y

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

    ld de, $5   ; Skip 5 bytes to the next star
    add hl, de

    dec c       ; Decrement counter
    jr nz, increment_x_loop ; If not zero, do it again

    pop bc
    ret

increment_x_zero
; Sets X to 0 and Y and Speed to random values
    push bc
    inc hl      ; point to Y

    push hl
    call getRandomY
    pop hl

    ld (hl), a  ; Set Y = getRandomY

    inc hl      ; point to speed

    push hl
    call getRandomSpeed ; Get a random Speed value
    pop hl

    ld (hl), a  ; Set Speed = getRandomSpeed

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

STARS
    REPT MAX_STARS
        DB $0,$0, $0, $0,$0
    ENDM

xrandpos        dw xranddata
yrandpos        dw yranddata
speedrandpos    dw speedranddata

xranddata
    REPT (MAX_STARS*2) + 1
        db  $0
    ENDM

yranddata
    REPT (MAX_STARS*2) + 1
        db  $0
    ENDM

speedranddata
    REPT (MAX_STARS*2) + 1
        db  $0
    ENDM

END start