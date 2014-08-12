org 30000

tv_flag     equ $5c3c       ; Variavel das flags da tv
last_k      equ $5c08       ; Contem a ultima tecla pressionada

OP_INC_DP   equ ">"
OP_DEC_DP   equ "<"
OP_INC_VAL  equ "+"
OP_DEC_VAL  equ "-"
OP_OUT      equ "."
OP_IN       equ ","
OP_JMP_FWD  equ "["
OP_JMP_BCK  equ "]"

;brainfuck   db  "++++++++++[>+++++++>++++++++++>+++>+<<<<-]>++.>+.+++++++..+++.>++.<<+++++++++++++++.>.+++.------.--------.>+.>.", 0
brainfuck   db  "+++++++++++++++++++++++++++++++++.", 0
memory_pos  db  $0,$80

start                       ; Começa em $75a2
    xor a                   ; O mesmo que LD a, 0
    ld (tv_flag), a         ; Faz com que o rst $10 envie output pra tv
    push bc                 ; Guarda BC na stack

main
    ld hl, brainfuck
read_bf
    ld a,(hl)
    push hl

    ; EOF
    cp 0
    jr z, end_main

    ; >
    cp OP_INC_DP
    jr z, F_INC_DP

    ; <
    cp OP_DEC_DP
    jr z, F_DEC_DP

    ; +
    cp OP_INC_VAL
    jr z, F_INC_VAL

    ; -
    cp OP_DEC_VAL
    jr z, F_DEC_VAL

    ; .
    cp OP_OUT
    jr z, F_OUT
    
    ; ,
    cp OP_IN
    jr z, F_IN

continue
    pop hl
    inc hl
    jr read_bf

end_main
    pop bc                  ; Tira o BC da stack
    ret                     ; Sai para o BASIC

F_INC_DP
    ld hl, (memory_pos)
    inc hl
    ld (memory_pos), hl
    jr continue

F_DEC_DP
    ld hl, (memory_pos)
    dec hl
    ld (memory_pos), hl
    jr continue

F_INC_VAL
    ld hl, (memory_pos)
    ld a, (hl)
    inc a
    ld (hl), a
    jr continue

F_DEC_VAL
    ld hl, (memory_pos)
    ld a, (hl)
    dec a
    ld (hl), a
    jr continue

F_OUT
    ld hl, (memory_pos)
    ld a, (hl)
    rst $10
    ld (hl), a
    jr continue

F_IN
    ld a, $0
    ld (last_k), a          ; Limpa o valor da ultima tecla pressionada
F_IN_LOOP
    ld a, (last_k)          ; Se o valor da ultima tecla pressionada ainda
    cp $0                   ; for 0, é porque ainda não se pressionou nenhuma
    jr z, F_IN_LOOP         ; tecla, por isso... repete
    ld hl, (memory_pos)
    ld (hl), a
    jr continue

end start
