addractual1  db 0,0
ultimoaddr   db 0,0
aids2        db 0

; Rotina de scroll de texto da direita para a esquerda pixel a pixel
; O endereço inicial tem de vir em HL
scroll_esquerda
    ld c, $8                ; Numero de vezes que a rotina vai correr
                            ; 8 é o numero de linhas de pixeis a scrollar

    ld a, 0
    ld (aids2), a
; Loop1
scroll_esquerda_0
    ld (addractual1), hl    ; Guarda o valor de HL em tmp1
    call scroll_esquerda_1  ; Scrolla
    ld hl, (addractual1)    ; Le o valor de tmp1 para HL

    inc h                   ; Incrementa H, mas como estamos a trabalhar com um
                            ; endereço de 16bits, na realidade vai adicionar 
                            ; $100 a HL
                            ; Isto vai fazer com que a segunda rotina seja
                            ; chamada com os seguintes endereços em tmp1 
                            ; videoAddr, videoAddr+$100 videoAddr+$200,
                            ; ..., videoAddr+$700

    ld a, (aids2)
    inc a
    ld (aids2), a
                            
    dec c                   ; Decrementa o contador C 
    jr nz, scroll_esquerda_0; Se C != 0 corre novamente o Loop1
    ret

; Segunda rotina 
scroll_esquerda_1
    ld hl, (addractual1)    ; Le o argumento tmp1 para HL

    push bc
    ld bc, $1f              ; Soma $1f ao endereço para começar
    adc hl, bc              ; no fim da linha, tudo à direita
                            ; Cada linha tem 32 bytes 

    ld (ultimoaddr), hl     ; Guarda o endereço do fim da linha
    pop bc

    ld b, $20               ; Numero de vezes que vai correr

; Loop2
scroll_esquerda_2
    ld a, (hl)              ; Faz um rotate left aos 8 pixels no
    rla                     ; endereço de video ram em HL, o bit
                            ; perdido fica na carry
    ld (hl), a              ; Actualiza
    dec hl                  ; Anda uma coluna para a esquerda
    djnz scroll_esquerda_2  ; Se ainda nao chegou ao fim, repete

    ld a, (aids2)
    ld d, $0
    ld e, a
    ld hl, udg_start
    add hl, de
    ld a, (hl)
    rla
    ld (hl), a
    
    ld hl, (ultimoaddr)     ; Le o valor do endereço da coluna 
    ld a, (hl)              ; mais à direita, em A

    ; Se não tem carry significa que não perdeu pixel nenhum
    ; no ultimo rotate, então não é preciso passar nada para
    ; a coluna mais à direita porque já tem o bit 0 a 0 devido
    ; ao rotate inicial.
    jr nc, scroll_esquerda_sem_carry ; Não tem carry? vai para o fim

    ; Se tem carry é porque se perdeu um pixel no ultimo
    ; rotate, então tem de se settar o bit 0 do coluna mais
    ; à direita a 1
    or $1                   ; bit 0 = 1
scroll_esquerda_sem_carry
    ld (hl), a              ; Actualiza
    ret
