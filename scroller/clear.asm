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
; 01000110 = 70
; 01000000 = 64 - Tudo preto
; 01000111 = 71 - Fundo preto Texto Branco
screen_attribute db 71

; Valor de 0 a 7
border_attribute db 0

clear_screen
    ld a, (screen_attribute)
    ld (23693), a       ; Variavel de sistema que permite definir
                        ; o ink, paper, brightness e flash
    call 3503           ; Chama a função da ROM para fazer clear
                        ; screen

    ld a, (border_attribute)
    call 8859           ; Chama a função da ROM para actualizar 
                        ; a border com o valor que está em A
                        ; O valor fica guardado em 23624
    ret
