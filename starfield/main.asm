; Begin code at $7530
org $7530

; System variables
tv_flag     equ $5c3c   ; TV flags
last_k      equ $5c08   ; Last pressed key
clr_screen  equ $0daf   ; ROM routine to clear the screen

; Video RAM
LINHA9  equ $4820
LINHA10 equ $4840
LINHA11 equ $4860   

; Star Structure
; X - 1 Byte
; Y - 1 Byte
; Z - 1 Byte
; Color - 1 Byte
STAR_SIZE   equ $4
MAX_STARS   equ 10
STARS       ds STAR_SIZE * MAX_STARS, 0


start
    xor a                   ; a = 0
    ld (tv_flag), a         ; Enables rst $10 output to the TV
    push bc                 ; Save BC on the stack

    call clear_screen
    ;call INITIALIZE_STARS

    ld hl, LINHA9+$FF
    ld a, (hl)
    set 0,a
    ld (hl), a

    pop bc                  ; Get BC out of the stack
    ret                     ; Exit to BASIC

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

INCLUDE "clear.asm"

end start
