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
