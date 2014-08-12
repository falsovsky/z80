scroll_addr  db 0,0     ; Endereço da linha a scrollar - na coluna 0
linha_actual db 0       ; Linha actual
ultima_addr  db 0,0     ; Endereço da coluna mais à direita da linha actual

; O endereço inicial tem de vir em HL
scroll
    ld c, $8                ; Numero de vezes que a rotina vai correr
                            ; 8 é o numero de linhas de pixeis a scrollar

    ld a, $0
    ld (linha_actual), a    ; Começa na linha 0

; Loop1
scroll_loop
    ld (scroll_addr), hl    ; Guarda o valor de HL (argumento da rotina)
    call scrolla_linha      ; Scrolla uma linha
    ld hl, (scroll_addr)    ; Le o valor de tmp1 para HL

    inc h                   ; Incrementa H, mas como estamos a trabalhar com um
                            ; endereço de 16bits, na realidade vai adicionar 
                            ; $100 a HL
                            ; Isto vai fazer com que a segunda rotina seja
                            ; chamada com os seguintes endereços em tmp1 
                            ; videoAddr, videoAddr+$100 videoAddr+$200,
                            ; ..., videoAddr+$700

    ld a, (linha_actual)    ; Incrementa a linha actual
    inc a
    ld (linha_actual), a

    dec c                   ; Decrementa o contador C
    jr nz, scroll_loop      ; Se C != 0 corre novamente o Loop1
    ret

; Scrolla a linha que estiver em scroll_addr
scrolla_linha
    push bc
    ld hl, (scroll_addr)    ; Le linha a scrollar
    ld bc, $1f              ; Soma $1f ao endereço para começar
    add hl, bc              ; no fim da linha, tudo à direita
                            ; Cada linha tem 32 bytes

    ld (ultima_addr), hl    ; Guarda o endereço do fim da linha
    ld b, $20               ; Numero de vezes que vai correr

; Vai começar por fazer um rotate left à coluna mais à direita, e
; guarda o bit que se perde na carry, que vai ser usado como o
; bit 0 do proximo rotate left que for executado.

; Depois faz-se um rotate left à mesma linha do UDG#1 guardado na
; rotina do "scroll_text.asm".
; Se a carry estiver definida faz-se um OR ao bit 0 da coluna mais
; à direita da linha.

; Loop2
scrolla_linha_loop
    ld a, (hl)              ; Faz um rotate left aos 8 pixels no
    rla                     ; endereço de video ram em HL, o bit
                            ; perdido fica na carry
    ld (hl), a              ; Actualiza
    dec hl                  ; Anda uma coluna para a esquerda
    djnz scrolla_linha_loop ; Se ainda nao chegou ao fim, repete
    ; Já processou tudo ate à esquerda, vamos passar o resto do 
    ; UDG#1
    ld a, (linha_actual)    ; Le a linha actual para A
    ld d, $0                ; D = $0
    ld e, a                 ; E = A
    ld hl, udg_start        ; Endereço onde começa o UDG#1
    add hl, de              ; Soma a linha actual

    ld a, (hl)              ; Le o valor da linha do #UDG#1
    rla                     ; Rotate
    ld (hl), a              ; Actualiza
    
    ld hl, (ultima_addr)    ; Le o valor do endereço da coluna
    ld a, (hl)              ; mais à direita em A

    ; Se não tem carry significa que não perdeu pixel nenhum
    ; no ultimo rotate, então não é preciso passar nada para
    ; a coluna mais à direita porque já tem o bit 0 a 0 devido
    ; ao rotate inicial.
    jr nc, scrolla_linha_fim ; Não tem carry? vai para o fim

    ; Se tem carry é porque se perdeu um pixel no ultimo
    ; rotate, então tem de se settar o bit 0 do coluna mais
    ; à direita a 1
    or $1                   ; bit 0 = 1
scrolla_linha_fim
    ld (hl), a              ; Actualiza
    pop bc
    ret
