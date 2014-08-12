org 30000

tv_flag equ $5c3c           ; Endereço que contem flags da tv
last_k  equ $5c08           ; Contem a ultima tecla pressionada
LINHA10 equ $4840

o_barbas    db  22,9,0, 16,6, "o_barbas disse:", 255
scroll_udg  db  $8          ; Numero de pixeis já scrollados no UDG#1
                            ; Inicializado a 8 para "pedir" uma nova
                            ; letra quando corre pela primeira vez.

start
    xor a                   ; O mesmo que LD a, 0
    ld (tv_flag), a         ; Directs rst 10h output to main screen.
    push bc                 ; Parece que é algum standard guardar o BC 
                            ; na stack, e tirar no fim do programa.

    call clear_screen       ; Limpa o ecrã
    
    ld hl, o_barbas         ; Le para HL o endereço da string a printar
printa_ate_255
    ld a,(hl)               ; Le para A o valor que esta no endereço em HL
    cp $ff                  ; Se for 255...
    jr z, main_loop         ; então já se imprimiu tudo e é para sair
    rst $10
    inc hl                  ; Incrementa o valor de HL
                            ; Passa a ter o endereço do proximo caracater da str
    jr printa_ate_255       ; Volta ao inicio da rotina

main_loop
    ld a, $0
    ld (last_k), a          ; Limpa o valor da ultima tecla pressionada

    ld a, (scroll_udg)      ; Le o numero de pixeis já scrollados no UDG#1
    cp $8                   ; São 8?
    jr nz, main_loop_scroll ; Não..
    call obtem_proxima_letra ; Sim, manda meter uma nova letra em UDG#1
    ld a, 0
    ld (scroll_udg), a      ; 0 pixeis ainda scrollados no novo UDG#1

main_loop_scroll
    ld hl, LINHA10
    call scroll_esquerda    ; Scrolla a linha 10
    
    ld a, (scroll_udg)      ; Incrementa o numero de pixeis já scrollados
    inc a                   ; no UDG#1
    ld (scroll_udg), a
    
    ld a, $1
    call delay              ; Chama a rotina de delay(1)

    ld a, (last_k)          ; Se o valor da ultima tecla pressionada ainda
    cp $0                   ; for 0, é porque ainda não se pressionou nenhuma
    jr Z, main_loop         ; tecla, por isso... repete

exit
    pop bc                  ; Tira o BC da Stack
    ret                     ; Sai para o BASIC

INCLUDE "delay.asm"
INCLUDE "clear.asm"
INCLUDE "texto.asm"
INCLUDE "scroll.asm"

end start
