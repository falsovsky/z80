tmpScroll1 db  0,0
ultimoaddr db  0,0
videoAddr  equ 4840h        ; Endereço de Memoria Video da Linha 10

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
    ld (ultimoaddr), hl
    pop bc

    ;ld b, 1Fh             ; Numero de vezes que a rotina vai correr
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
