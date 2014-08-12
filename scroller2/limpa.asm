attr_p              equ $5c8d; Endereço que contem as cores permanentes
bordcr              equ $5c48; Endereço que contem a cor da borda
rom_limpa_ecra      equ $0daf; Rotina da ROM que limpa o ecrã
rom_define_borda    equ $2294; Rotina da ROM que define a borda

; Cores
; Numero | Binario | Nome
; 0      | 000     | Preto 
; 1      | 001     | Azul
; 2      | 010     | Vermelho
; 3      | 011     | Roxo
; 4      | 100     | Verde
; 5      | 101     | Cyan
; 6      | 110     | Amarelo
; 7      | 111     | Branco

; 8 bits para definir ink, paper, brightness e flash
; |F |B |P2|P1|P0|I2|I1|I0|
; F Flash
; B Brightness
; P Paper
; I Ink

; Então para definir o flash desligado, o brightness ligado com o
; fundo a preto e o texto a amarelo fica-se com:
; 01000110 = 70 = $46
; 01000000 = 64 = $40 - Tudo preto
; 01000111 = 71 = $47 - Fundo preto Texto Branco
screen_attribute equ $47

; Valor de 0 a 7
border_color     equ $0

limpa_ecra
    ld a, screen_attribute
    ld (attr_p), a      ; Variavel de sistema que permite definir
                        ; o ink, paper, brightness e flash
    call rom_limpa_ecra ; Clear screen

    ld a, border_color  ; Cor do border
    call rom_define_borda+$7
    ; Chama a rotina da ROM para actualizar a borda, mas salta 7
    ; bytes à frente, porque são para ler o valor da borda do 
    ; BASIC. O valor fica guardado em $5c48.
    ret
