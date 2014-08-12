text db "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin commodo metus sed orci fermentum, id mattis quam suscipit.", 0

chars       equ $5c36   ; Endereço 256 ($100) bytes abaixo da fonte (2 bytes)
                        ; Contem $3c00 inicialmente

font_start  equ $3c00   ; Endereço onde começa a fonte, acaba em $3fff
                        ; Começa com o espaço e acaba no ©
                        ; http://en.wikipedia.org/wiki/ZX_Spectrum_character_set

udg         equ $5c7b   ; Endereço do primeiro user-defined graphics (2 bytes)
                        ; Contem $ff58 inicialmente

udg_start   equ $ff58   ; User-defined characters, vai até $ffff
                        ; São acessiveis com o caracter $90 até $a4
                        
letra_pos   db  0,0

scroll_text
    ld hl, text         ; Endereço do primeiro chr
scroll_text_loop
    ; Por exemplo, a primeira letra é um L. No ASCII do 
    ; Spectrum o valor dela é $4C e com esse valor pretendo
    ; chegar a $3E60 que é onde está a font dela
    
    ld a, (hl)          ; Le chr da string - $4C incialmente
    push hl             ; Guarda a posição na string na stack

    ld h,0              ; H = 0
    ld l,a              ; L = valor em A

    add hl, hl          ;  $4C +  $4C = $98
    add hl, hl          ;  $98 +  $98 = $130
    add hl, hl          ; $130 + $130 = $260
    
    ld d, h
    ld e, l             ; DE = HL
    
    ld hl, font_start
    adc hl, de          ; $3C00 + $260 = $3E60   
    
    ld (letra_pos), hl  ; Guarda o valor em letra_pos
    
    call copia_para_udg ; Copia a letra para o UDG#1
    ld a, $90           ; Imprime a primeira letra do UDG
    rst $10
    pop hl              ; Tira a posição da string da stack
    inc hl              ; Anda para a frente
    ld a, (hl)
    cp 0                ; Ve se já estamos no fim
    jr nz, scroll_text_loop ; Repete no proximo chr da string
    ret

copia_para_udg
    ld b, $8            ; Copiar 8 bytes, cada letra são 8x8
    ld hl, (letra_pos)  ; Posição da font da letra a copiar
    ld de, udg_start    ; Destino
copia_para_udg_r
    ld a, (hl)          ; Le origem
    ld (de), a          ; Copia para destino
    inc hl              ; Incrementa ambos
    inc de
    djnz copia_para_udg_r ; b--, se b != 0 salta
    ret
