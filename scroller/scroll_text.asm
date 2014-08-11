text db "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin commodo metus sed orci fermentum, id mattis quam suscipit.", 0

chars       equ 5c36h   ; Endereço 256 ($100) bytes abaixo da fonte (2 bytes)
                        ; Contem $3c00 inicialmente

font_start  equ 3d00h   ; Endereço onde começa a fonte, acaba em $3fff
                        ; Começa com o espaço e acaba no ©
                        ; http://en.wikipedia.org/wiki/ZX_Spectrum_character_set

udg         equ 5c7bh   ; Endereço do primeiro user-defined graphics (2 bytes)
                        ; Contem $ff58 inicialmente

udg_start   equ ff58h   ; User-defined characters, vai até $ffff
                        ; São acessiveis com o caracter $90 até $a4