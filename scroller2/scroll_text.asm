text db "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin commodo metus sed orci fermentum, id mattis quam suscipit OI VIVA O BENFICA!!", 0

chars       equ $5c36   ; Endereço 256 ($100) bytes abaixo da fonte (2 bytes)
                        ; Contem $3c00 inicialmente

font_start  equ $3c00   ; Endereço onde começa a fonte, acaba em $3fff
                        ; Começa com o espaço e acaba no ©
                        ; http://en.wikipedia.org/wiki/ZX_Spectrum_character_set

udg         equ $5c7b   ; Endereço do primeiro user-defined graphics (2 bytes)
                        ; Contem $ff58 inicialmente

udg_start   equ $ff58   ; User-defined characters, vai até $ffff
                        ; São acessiveis com o caracter $90 até $a4

text_pos    db  0,0
first_time  db  1

scroll_text
    ld a, (first_time)
    cp $1
    jr nz, other_runs
first_run
    ; Primeira vez a correr, usa a posicao 0 da string
    ld a, 0
    ld (first_time), a  ; first_time = 0
    ld hl, text         ; Endereço do primeiro chr
    jr scroll_text_loop
other_runs
    ; Usa a posição guardada em text_pos
    ld hl, (text_pos)
    
scroll_text_loop
    ; Por exemplo, a primeira letra é um L. No ASCII do 
    ; Spectrum o valor dela é $4C e com esse valor pretendo
    ; chegar a $3E60 que é onde está a font dela

    ld a, (hl)          ; Le chr da string - $4C inicialmente
    push hl             ; Guarda a posição na string na stack

    ld h,0              ; H = 0
    ld l,a              ; L = valor em A

    add hl, hl          ;  $4C +  $4C = $98
    add hl, hl          ;  $98 +  $98 = $130
    add hl, hl          ; $130 + $130 = $260

    ld d, h
    ld e, l             ; DE = HL

    ld hl, font_start
    add hl, de          ; $3C00 + $260 = $3E60

    call copia_para_udg ; Copia a letra para o UDG#1
                        ; O argumento para a rotina é o valor em HL

    ld a, 22
    rst $10
    ld a, 0
    rst $10
    ld a, 0
    rst $10

    ld a, $90           ; Imprime UDG#1
    rst $10

    pop hl              ; Tira a posição na string da stack
    inc hl              ; Anda para a frente
    ld a, (hl)          ; Le o proximo valor
    cp $0               ; Se for 0 estamos no fim da string
    jr z, reset         ; Reset à posição
    jr the_end          ; Continua
reset
    ld a, 1
    ld (first_time), a  ; Manda meter a posicao a 0 da proxima vez
the_end
    ld (text_pos), hl   ; Guarda a posição
    ret

copia_para_udg
    ; Está a contar que o endereço de origem esteja em HL
    ld b, $8            ; Copiar 8 bytes, cada letra são 8x8
    ld de, udg_start    ; Destino
copia_para_udg_loop
    ld a, (hl)          ; Le origem
    ld (de), a          ; Copia para destino
    inc hl              ; Incrementa ambos
    inc de
    djnz copia_para_udg_loop ; b--, se b != 0 salta
    ret
