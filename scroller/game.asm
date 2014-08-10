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

; Rotina de delay variavel, conforme o valor definido em A antes de a chamar
; Ripada do Paradise Café 
delay
    push bc
delay_start
    ld c, 20
delay_loop2
    ld b, 0
delay_loop1
    djnz delay_loop1       ; b--, se b != 0 corre novamente o loop1
    dec c                  ; c--
    jr nz, delay_loop2     ; Se c != 0 corre o loop2
    dec a                  ; a--
    jr nz, delay_start     ; Se a != 0 volta ao inicio da rotina
    pop bc
    ret

; Rotina de scroll de texto da direita para a esquerda pixel a pixel
scrolla
    ld hl, videoAddr       ; Endereço de Memoria Video a ser manipulado
    ld c, 8                ; Numero de vezes que a rotina vai correr
                           ; 8 é o numero de linhas de pixeis a scrollar

; Loop1     
scrolla_0
    ld (tmpScroll1), hl    ; Guarda o valor de HL em tmp1
    call scrolla_1         ; Scrolla
    ld hl, (tmpScroll1)    ; Le o valor de tmp1 para HL
    
    inc h                  ; Incrementa H, mas como estamos a trabalhar com um
                           ; endereço de 16bits, na realidade vai adicionar 
                           ; $100 a HL
                           ; Isto vai fazer com que a segunda rotina seja
                           ; chamada com os seguintes endereços em tmp1 
                           ; videoAddr, videoAddr+$100 videoAddr+$200,
                           ; ..., videoAddr+$700
                           
    dec c                  ; Decrementa o contador C 
    jr nz, scrolla_0       ; Se C != 0 corre novamente o Loop1
    ret

; Segunda rotina 
scrolla_1
    ld hl, (tmpScroll1)    ; Le o argumento tmp1 para HL
    
    ; Soma $1F ao endereço para começar no fim da linha, tudo à direita
    push bc
    ;ld bc, 1Fh
    ld bc, 20h
    adc hl, bc

    ; Guarda o endereço do fim da linha em (ultimoaddr)
    ld b, h
    ld c, l
    ld (ultimoaddr), bc
    pop bc

    ld b, 1Fh              ; Numero de vezes que a rotina vai correr
    ld b, 21h              ; Numero de vezes que a rotina vai correr
    

; Loop2
scrolla_2
    ld a, (hl)             
    rla
    ld (hl), a
    dec hl
    djnz scrolla_2         
   
    ld hl, (ultimoaddr)
    ld a, (hl)
    rra
    ld (hl), a
    ret

; Antiga

; Rotina de scroll de texto da direita para a esquerda
; Ripada do Paradise Café
scrollaPC
    ld hl, videoAddr       ; Endereço de Memoria Video a ser manipulado 
    ld c, 8                ; Numero de vezes que a rotina vai correr
                           ; 8 porque é o numero de pixels a scrollar

; Loop1     
scrollaPC_0
    ld (tmpScroll1), hl    ; Guarda o valor de HL em tmp1
    call scrollaPC_1       ; Scrolla
    ld hl, (tmpScroll1)    ; Le o valor de tmp1 para HL
    
    inc h                  ; Incrementa H, mas como estamos a trabalhar com um
                           ; endereço de 16bits, na realidade vai adicionar 
                           ; $100 a HL
                           ; Isto vai fazer com que a segunda rotina seja
                           ; chamada com os seguintes endereços em tmp1 
                           ; videoAddr, videoAddr+$100 videoAddr+$200,
                           ; ..., videoAddr+$700
                           
    dec c                  ; Decrementa o contador C 
    jr NZ, scrollaPC_0     ; Se C != 0 corre novamente a Loop1
    ret

; Segunda rotina 
scrollaPC_1
    ld hl, (tmpScroll1)    ; Le o argumento tmp1 para HL
    ld b, 1Fh              ; Numero de vezes que a rotina vai correr
                           ; $1F porque cada linha tem 32 bytes
    
    ld d, h                ; DE = HL
    ld e, l                ;
    
    ld a, (hl)             ; Le o valor dos 8 pixeis no endereço definido em HL
    ld (tmpScroll2), a     ; Guarda o valor em tmp2
                           ; Isto vai guardar o valor dos 8 pixels mais à 
                           ; esquerda, que posteriormente vão ser postos o 
                           ; mais à direita
 
; Loop2
scrollaPC_2
    inc hl                 ; Incrementa a posicao na memoria grafica definida 
                           ; em HL 
    
    ld a, (hl)             ; Le o valor dos proximos 8 pixeis 
    ld (de), a             ; Guarda-os na posição anterior
    inc de                 ; Incrementa DE, fica com o mesmo valor de HL
    djnz scrollaPC_2       ; b--, se b != corre novamente o Loop2
    
    ld a, (tmpScroll2)     ; Le o valor dos 8 pixeis guardados inicialmente 
    ld (de), a             ; Mete-os na posição mais à direita
    ret
 
end start
