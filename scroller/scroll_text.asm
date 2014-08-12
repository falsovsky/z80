text db "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin commodo metus sed orci fermentum, id mattis quam suscipit.", 0

chars       equ $5c36   ; Endereço 256 ($100) bytes abaixo da fonte (2 bytes)
                        ; Contem $3c00 inicialmente

font_start  equ $3d00   ; Endereço onde começa a fonte, acaba em $3fff
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
    ; Por exemplo, a primeira letra é um L,  em ASCII do 
    ; Spectrum o valor é $4C e com esse valor pretendo
    ; chegar a $3E60 que é onde está a Font dessa letra
    
    ld a, (hl)          ; Le chr da string - $4C incialmente
    push hl
    ld d, 20h           ; Subtrai $20 
    sbc a,d             ; Fica-se com $2C

    ld h,0              ; H = 0
    ld l,a              ; L = valor em A
    ld d,h
    ld e,l              ; DE = HL
    
    ; Somar DE a HL 7x
    adc hl, de          ;  $2C + $2C = $58
    adc hl, de          ;  $58 + $2C = $84
    adc hl, de          ;  $84 + $2C = $B0
    adc hl, de          ;  $B0 + $2C = $DC
    adc hl, de          ;  $DC + $2C = $108
    adc hl, de          ; $108 + $2C = $134
    adc hl, de          ; $134 + $2C = $160
    
    ld d, h
    ld e, l             ; DE = HL
    
    ld hl, font_start
    adc hl, de          ; $3D00 + $160 = $3E60   
    
    ld (letra_pos), hl  ; Guarda o valor em letra_pos
    
    call copia_para_udg
    ld a, $90
    rst $10
    pop hl
    inc hl
    ld a, (hl)
    cp 0
    jr nz, scroll_text_loop
    ret

copia_para_udg
    push bc
    ld b, $8            ; Vamos copiar 8 bytes, cada letra são 8x8
    ld hl, (letra_pos)  ; Posição da letra a copiar
    ld de, udg_start    ; Le a posicao do destino
copia_para_udg_r
    ld a, (hl)          ; Le origem
    ld (de), a          ; Copia para destino
    inc hl              ; Incrementa ambos
    inc de
    djnz copia_para_udg_r ; b--, se b != 0 salta
    pop bc
    ret
