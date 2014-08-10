org 30000
 
tv_flag    equ 5C3Ch

; 16 é para definir o INK
; 17 é para definir o PAPER
; 22 é para definir as Cordenadas Y,X
; 255 Marcador de fim da string
mystr      db  22,10,0, 16, 7, 17, 2, " ", 16,0, 17,1, ".o0O0o.   ", 17, 5, 16, 2, "LOL GORDOS", 17, 1, 16,6, "   .o0O0o.", 16, 7, 17, 2, " ", 255
tmpScroll1 db  0,0
ultimoaddr db  0,0
tmpScroll2 db  0
videoAddr  equ 4840h       ; Endereço de Memoria Video da Linha 10



start
    xor a                  ; O mesmo que LD a, 0
    ld (tv_flag), a        ; Directs rst 10h output to main screen.
    
    push bc                ; Parece que é algum standard guardar o BC 
                           ; na stack, e tirar no fim do programa.

    ld hl, mystr           ; Le para HL o endereço da string a printar
    
printa_ate_255
    ld a,(hl)              ; Le para A o valor que esta no endereço em HL
    cp 255                 ; Se for 255...
    jr z, mainloop         ; então já se imprimiu tudo e é para sair
    
    push hl                ; guarda HL na Stack
                           ; (não sei se é alterado com o RST $10) 
    rst 10h                ; Syscall para imprimir o no ecrã o que estiver em A
    pop hl                 ; Tira o HL da stack
    
    inc hl                 ; Incrementa o valor de HL
                           ; Passa a ter o endereço do proximo caracater da str
                           
    jr printa_ate_255      ; Volta ao inicio da rotina

mainloop
    ld a, 0                ; O endereço $5C08 tem o valor ASCII da ultima tecla
    ld (5C08h), a          ; pressionada, vamos limpar isso
    
;   call scrollaPC         ; Scrolla com a rotina do Paradise Café
    call scrolla           ; Scrolla pixel a pixel
    
    ld a, 1                 
    call delay             ; Chama a rotina de delay(1)
    
    ld a, (5C08h)          ; Se o valor em $5C08 ainda for 0, é porque ainda  
    cp 0                   ; não se pressionou nenhuma tecla, por isso...
    jr Z, mainloop         ; repete
 
exit
    pop bc                 ; Tira o BC da Stack
    ret                    ; Sai para o BASIC
    
;INCLUDE "scroll_pc.asm"
INCLUDE "scroll_pixel.asm"
INCLUDE "delay.asm"

end start
