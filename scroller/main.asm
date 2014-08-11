org 30000

tv_flag equ 5c3ch           ; Endereço que contem flags da tv
last_k  equ 5c08h           ; Contem a ultima tecla pressionada
k_cur   equ 5c5bh           ; Contem a posição do cursor - TODO: Usar isto
    
; Video RAM
LINHA9  equ 4820h
LINHA10 equ 4840h
LINHA11 equ 4860h

; 16 é para definir o INK
; 17 é para definir o PAPER
; 22 é para definir as Cordenadas Y,X
; 255 Marcador de fim da string
mystr db 22,10,0, 16,1, " ", 16,6, ".o0O0o.   LOL GORDOS   .o0O0o.", 16,1, " ", 255

start
    xor a                   ; O mesmo que LD a, 0
    ld (tv_flag), a         ; Directs rst 10h output to main screen.

    push bc                 ; Parece que é algum standard guardar o BC 
                            ; na stack, e tirar no fim do programa.

    call clear_screen       ; Limpa o ecrã

    ; Flood de numeros em todas as linhas
    ld a, 0                 ; Começa na linha 0
    ld b, 22                ; Repete nas 22 linhas
lol_flood
    ld c, a                 ; Guarda o A em C e o B em D porque
    ld d, b                 ; são alterados no call
    call printnumbers
    ld a, c                 ; Le o A de volta
    inc a                   ; Proxima linha
    ld b, d                 ; Le o B de volta
    djnz lol_flood          ; B-- , se for != 0 salta

    ld hl, mystr            ; Le para HL o endereço da string a printar
printa_ate_255
    ld a,(hl)               ; Le para A o valor que esta no endereço em HL
    cp 255                  ; Se for 255...
    jr z, mainloop          ; então já se imprimiu tudo e é para sair
    rst 10h                 ; Syscall para imprimir o no ecrã o que estiver em A
    inc hl                  ; Incrementa o valor de HL
                            ; Passa a ter o endereço do proximo caracater da str
    jr printa_ate_255       ; Volta ao inicio da rotina

mainloop
    ld a, 0
    ld (last_k), a          ; Limpa o valor da ultima tecla pressionada

    ld hl, LINHA9
    call scroll_direita
    ld hl, LINHA10
    call scroll_esquerda
    ld hl, LINHA11
    call scroll_direita
    
    ld a, 1
    call delay              ; Chama a rotina de delay(1)

    ld a, (last_k)          ; Se o valor da ultima tecla pressionada ainda
    cp 0                    ; for 0, é porque ainda não se pressionou nenhuma
    jr Z, mainloop          ; tecla, por isso... repete

exit
    pop bc                  ; Tira o BC da Stack
    ret                     ; Sai para o BASIC

INCLUDE "scroll_esquerda.asm"
INCLUDE "scroll_direita.asm"
INCLUDE "delay.asm"
INCLUDE "clear.asm"
INCLUDE "printnumbers.asm"

end start
