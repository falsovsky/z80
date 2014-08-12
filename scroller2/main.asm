org 30000

tv_flag equ $5c3c           ; Variavel das flags da tv
last_k  equ $5c08           ; Variavel que contem a ultima tecla usada
LINHA10 equ $4840           ; Endereço da linha 10 na Memoria Video

o_barbas    db  22,9,0, 16,6, "o_barbas disse:", 255
scroll_udg  db  $8          ; Numero de pixeis já scrollados no UDG#1
                            ; Inicializado a 8 para "pedir" uma nova
                            ; letra quando corre pela primeira vez.

start
    xor a                   ; O mesmo que LD a, 0
    ld (tv_flag), a         ; Faz com que o rst $10 envie output pra tv
    push bc                 ; Guarda BC na stack

    call limpa_ecra         ; Limpa o ecrã
    
    ld hl, o_barbas         ; Le para HL o endereço da string a printar
printa_string
    ld a,(hl)               ; Le para A o valor que esta no endereço em HL
    cp $ff                  ; Se for 255...
    jr z, main_loop         ; então já se imprimiu tudo e é para sair
    rst $10
    inc hl                  ; Incrementa a posição na string
    jr printa_string        ; Volta ao inicio da rotina

main_loop
    ld a, $0
    ld (last_k), a          ; Limpa o valor da ultima tecla pressionada

    ld a, (scroll_udg)      ; Le o numero de pixeis já scrollados no UDG#1
    cp $8                   ; São 8?
    jr nz, main_loop_scroll ; Não? salta
    call obtem_proxima_letra ; Sim, manda meter uma nova letra em UDG#1
    ld a, 0
    ld (scroll_udg), a      ; Reseta o numero de pixeis scrollados no UDG#1

main_loop_scroll
    ld hl, LINHA10
    call scroll_esquerda    ; Scrolla a linha 10

    ld a, (scroll_udg)
    inc a                   ; Incrementa o numero de pixeis já scrollados
    ld (scroll_udg), a
    
    ld a, $1
    call delay              ; Chama a rotina de delay(1)

    ld a, (last_k)          ; Se o valor da ultima tecla pressionada ainda
    cp $0                   ; for 0, é porque ainda não se pressionou nenhuma,
    jr Z, main_loop         ; por isso... repete

exit
    pop bc                  ; Tira o BC da stack
    ret                     ; Sai para o BASIC

INCLUDE "delay.asm"
INCLUDE "limpa.asm"
INCLUDE "texto.asm"
INCLUDE "scroll.asm"

end start
