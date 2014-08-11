org 30000

tv_flag equ 5C3Ch

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
    ld a, 0                 ; O endereço $5C08 tem o valor ASCII da ultima tecla
    ld (5C08h), a           ; pressionada, vamos limpar isso

    ld hl, 4820h            ; Linha 9
    call scroll_direita
    ld hl, 4840h            ; Linha 10
    call scroll_esquerda
    ld hl, 4860h            ; Linha 11
    call scroll_direita
    
    ld a, 1
    call delay              ; Chama a rotina de delay(1)

    ld a, (5C08h)           ; Se o valor em $5C08 ainda for 0, é porque ainda  
    cp 0                    ; não se pressionou nenhuma tecla, por isso...
    jr Z, mainloop          ; repete

exit
    pop bc                  ; Tira o BC da Stack
    ret                     ; Sai para o BASIC

INCLUDE "scroll_esquerda.asm"
INCLUDE "scroll_direita.asm"
INCLUDE "delay.asm"
INCLUDE "clear.asm"
INCLUDE "printnumbers.asm"

end start
