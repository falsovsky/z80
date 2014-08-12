; Rotina de delay variavel, conforme o valor definido em A antes de a chamar
; Ripada do Paradise Café 
delay
    push bc
delay_start
    ld c, 10
delay_loop2
    ld b, 0
delay_loop1
    djnz delay_loop1       ; b--, se b != 0 corre novamente o loop1
    dec c                  ; c--
    jr nz, delay_loop2     ; Se c != 0 corre o loop2
    dec a                  ; a--
    jr nz, delay_start     ; Se a != 0 volta ao inicio da rotina
    pop bc
    ret
