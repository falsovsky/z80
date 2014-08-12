; printa numeros de 0 a 9 na linha definida em A
printnumbers
    ld b, a	        ; guarda o valor de A em B
    ld a, $16       ; AT
    rst $10
    ld a, b         ; Y = B
    rst $10
    ld a, $0        ; X = 0
    rst $10

    ld b, $20       ; 32 colunas
    ld h, $30       ; chr "0"

printnumbers_loop
    ld a, h         ; printa o chr em H
    rst $10
    inc h           ; Incrementa
    ld a, h         ; Guarda o valor em A
    cp $3a          ; Compara com chr ":" (a seguir ao "0")
    jr nz, printnumbers_continue
    ld h, $30       ; Volta a meter a "0"
printnumbers_continue
    djnz printnumbers_loop
    ret
