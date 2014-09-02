text db "\"SEM QUERER MAGOAR O MEU BENFICA SO SABE GANHAR VIVA O BENFICA\" \"DA TRAFARIA ATE AO JAMOR O MEU BENFICA MOSTRA SEMPRE O SEU ESPLENDOR VIVA O BENFICA\" \"MANHA DE NEVOEIRO TARDE DE SOL SOALHEIRO BENFICA SEMPRE O PRIMEIRO VIVA O BENFICA\" \"DUAS VIAGENS SEGUIDAS PARA A ITALIA DAQUI A BOCADO MAIS VALE ABRIR UM BARBAS EM TURIM VIVA O BENFICA\" ", 0

chars       equ $5c36       ; Endereço 256 ($100) bytes abaixo da fonte (2 bytes)
                            ; Contem $3c00 inicialmente

font_start  equ $3c00       ; Endereço onde começa a fonte, acaba em $3fff
                            ; Começa com o espaço e acaba no ©
                            ; http://en.wikipedia.org/wiki/ZX_Spectrum_character_set

udg         equ $5c7b       ; Endereço do primeiro user-defined graphics (2 bytes)
                            ; Contem $ff58 inicialmente

udg_start   equ $ff58       ; User-defined characters, vai até $ffff
                            ; São acessiveis com o caracter $90 até $a4

posicao_addr    db  0,0     ; Contem o endereço da posição actual na string
reset_posicao   db  1       ; Se estiver a 1 a posição é resetada a 0

obtem_proxima_letra
    ld a, (reset_posicao)
    cp $1                   ; Se não for para meter a posição a 0 salta
    jr nz, proxima_letra_sem_reset
    ; o reset_posicao está a 1, meter a posicao na string a 0
    ld a, 0
    ld (reset_posicao), a   ; reset_posicao = 0
    ld hl, text             ; Endereço do primeiro chr
    jr proxima_letra_loop
proxima_letra_sem_reset
    ; Usa a posição guardada em posicao_addr
    ld hl, (posicao_addr)

proxima_letra_loop
    ; Por exemplo, a primeira letra é um L. No ASCII do 
    ; Spectrum o valor dela é $4C e com esse valor pretendo
    ; chegar a $3E60 que é onde está a font dela

    ld a, (hl)              ; Le chr da string - $4C inicialmente
    push hl                 ; Guarda a posição na string na stack

    ld h,$0                 ; H = $0
    ld l,a                  ; L = A

    add hl, hl              ;  $4C +  $4C = $98
    add hl, hl              ;  $98 +  $98 = $130
    add hl, hl              ; $130 + $130 = $260

    ld d, h
    ld e, l                 ; DE = HL

    ld hl, font_start
    add hl, de              ; $3C00 + $260 = $3E60

    call proxima_letra_udg  ; Copia a letra para o UDG#1
                            ; O argumento para a rotina é o valor em HL

    pop hl                  ; Tira a posição na string da stack
    inc hl                  ; Anda para a frente
    ld a, (hl)              ; Le o proximo valor
    cp $0                   ; Se for 0 estamos no fim da string
    jr z, proxima_letra_set_reset ; Manda fazer reset à posição
    jr proxima_letra_fim    ; Senão continua
proxima_letra_set_reset
    ld a, $1                ; Manda meter a posicao a 0 na proxima
    ld (reset_posicao), a   ; iteração
proxima_letra_fim
    ld (posicao_addr), hl   ; Guarda a posição
    ret

; copia a letra para o UDG#1
proxima_letra_udg
    ; Está a contar que o endereço de origem esteja em HL
    ld b, $8                ; Copiar 8 bytes, cada letra são 8x8
    ld de, udg_start        ; Destino
proxima_letra_udg_loop
    ld a, (hl)              ; Le origem
    ld (de), a              ; Copia para destino
    inc hl                  ; Incrementa ambos
    inc de
    djnz proxima_letra_udg_loop ; b--, se b != 0 salta
    ret
