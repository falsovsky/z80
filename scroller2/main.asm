org 30000

tv_flag equ $5c3c           ; Endereço que contem flags da tv
last_k  equ $5c08           ; Contem a ultima tecla pressionada

k_cur   equ $5c5b           ; Contem a posição do cursor - TODO: Usar isto
                            ; Depois de meter a 10,6 (y,x) fica com
                            ; $5d16

LINHA10 equ $4840
aids    db  $0

start
    xor a                   ; O mesmo que LD a, 0
    ld (tv_flag), a         ; Directs rst 10h output to main screen.

    push bc                 ; Parece que é algum standard guardar o BC 
                            ; na stack, e tirar no fim do programa.

    call clear_screen       ; Limpa o ecrã

    call scroll_text
mainloop
    ld a, $0
    ld (last_k), a          ; Limpa o valor da ultima tecla pressionada

    ld a, (aids)
    cp $8
    jr nz, s_e
    call scroll_text
    ld a, 0
    ld (aids), a

s_e
    ld hl, LINHA10
    call scroll_esquerda
    ld a, (aids)
    inc a
    ld (aids), a
    
    ld a, $1
    call delay              ; Chama a rotina de delay(1)

    ld a, (last_k)          ; Se o valor da ultima tecla pressionada ainda
    cp $0                   ; for 0, é porque ainda não se pressionou nenhuma
    jr Z, mainloop          ; tecla, por isso... repete

exit
    pop bc                  ; Tira o BC da Stack
    ret                     ; Sai para o BASIC

INCLUDE "delay.asm"
INCLUDE "clear.asm"
INCLUDE "scroll_text.asm"
INCLUDE "scroll_esquerda.asm"

end start
