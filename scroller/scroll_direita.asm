;videoAddr2  equ 4820h       ; Linha 9
;videoAddr2  equ 4920h       ; Faz o mesmo, tenho de entender porque

addractual2  db 0,0
primeiroaddr db 0,0

; Rotina de scroll de texto da esquerda para a direita pixel a pixel
; O endereço inicial tem de vir em HL
scroll_direita
;    ld hl, videoAddr2       ; Endereço de Memoria Video a ser manipulado
    ld c, 8h                ; Numero de vezes que a rotina vai correr
                            ; 8 é o numero de linhas de pixeis a scrollar

; Loop1
scroll_direita_0
    ld (addractual2), hl    ; Guarda o valor de HL em tmp1
    call scroll_direita_1   ; Scrolla
    ld hl, (addractual2)    ; Le o valor de tmp1 para HL

    inc h                   ; Incrementa H, mas como estamos a trabalhar com um
                            ; endereço de 16bits, na realidade vai adicionar 
                            ; $100 a HL
                            ; Isto vai fazer com que a segunda rotina seja
                            ; chamada com os seguintes endereços em tmp1 
                            ; videoAddr, videoAddr+$100 videoAddr+$200,
                            ; ..., videoAddr+$700

    dec c                   ; Decrementa o contador C 
    jr nz, scroll_direita_0 ; Se C != 0 corre novamente o Loop1
    ret

; Segunda rotina 
scroll_direita_1
    ld hl, (addractual2)    ; Le o argumento tmp1 para HL
    ld (primeiroaddr), hl
    ld b, 20h               ; Numero de vezes que vai correr
; Loop2
scroll_direita_2
    ld a, (hl)              ; Faz um rotate right aos 8 pixels no
    rra                     ; endereço de video ram em HL, o bit
                            ; perdido fica na carry
    ld (hl), a              ; Actualiza
    inc hl                  ; Anda uma coluna para a direita
    djnz scroll_direita_2   ; Se ainda nao chegou ao fim, repete

    ld hl, (primeiroaddr)   ; Le o valor do endereço da coluna
    ld a, (hl)              ; mais à esquerda, em A
    
    jr nc, scroll_direita_sem_carry ; Não tem carry? vai para o fim
    or 80h                  ; bit 7 = 1
scroll_direita_sem_carry
    ld (hl), a              ; Actualiza
    ret
