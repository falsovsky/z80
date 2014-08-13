org 30000

tv_flag     equ $5c3c       ; TV flags variable
last_k      equ $5c08       ; Last pressed key

; Brainfuck Operators
OP_INC_DP   equ ">"
OP_DEC_DP   equ "<"
OP_INC_VAL  equ "+"
OP_DEC_VAL  equ "-"
OP_OUT      equ "."
OP_IN       equ ","
OP_JMP_FWD  equ "["
OP_JMP_BCK  equ "]"

; Brainfuck source
;brainfuck   db  "++++++++++[>+++++++>++++++++++>+++>+<<<<-]>++.>+.+++++++..+++.>++.<<+++++++++++++++.>.+++.------.--------.>+.>.", 0
brainfuck   db  "++++[>++++++++++<-]>++.>+++++++++++++.<<++[>.<-]>>.<<+++[>.<-]>>.<<++++[>.<-]>>.<<+++++[>.<-]>>.", 0

; Variables
memory_pos  db  $0,$80      ; Current memory position
                            ; Contains the address on where the BF memory begins
source_pos  db  $0,$0       ; Current source position

start
    xor a                   ; a = 0
    ld (tv_flag), a         ; Enables rst $10 output to the TV
    push bc                 ; Save BC on the stack

main
    ld hl, brainfuck        ; Get source first position
    ld de, (source_pos)     ; 
    add hl, de              ; First position + current position
    
    ld a, (hl)              ; Read opcode from source

    ; EOF
    cp $0                   ; End of file
    jr z, end_main          ; Jump to the end

    ; >
    cp OP_INC_DP
    jp z, F_INC_DP

    ; <
    cp OP_DEC_DP
    jp z, F_DEC_DP

    ; +
    cp OP_INC_VAL
    jp z, F_INC_VAL

    ; -
    cp OP_DEC_VAL
    jp z, F_DEC_VAL

    ; .
    cp OP_OUT
    jp z, F_OUT
    
    ; ,
    cp OP_IN
    jp z, F_IN
    
    ; [
    cp OP_JMP_FWD
    jp z, F_JMP_FWD
    
    ; ]
    cp OP_JMP_BCK
    jp z, F_JMP_BCK

continue
    ld de, (source_pos)     ; Increment source position
    inc de
    ld (source_pos), de
    jr main                 ; Do it again

end_main
    pop bc                  ; Get BC out of the stack
    ret                     ; Exit to BASIC

; -------------------------------------

F_INC_DP
    ld de, (memory_pos)     ; Increment memory position
    inc de
    ld (memory_pos), de
    jp continue

; -------------------------------------

F_DEC_DP
    ld de, (memory_pos)     ; Decrement memory position
    dec de
    ld (memory_pos), de
    jp continue

; -------------------------------------

F_INC_VAL
    ld de, (memory_pos)     ; Increment value at the current
    ld a, (de)              ; memory position
    inc a
    ld (de), a
    jp continue

; -------------------------------------

F_DEC_VAL
    ld de, (memory_pos)     ; Decrement value at the current
    ld a, (de)              ; memory position
    dec a
    ld (de), a
    jp continue

; -------------------------------------

F_OUT
    ld de, (memory_pos)     ; Print value at the current
    ld a, (de)              ; memory position
    cp $a
    jr z, F_OUT_FIX_NEWLINE ; Is it a $a ? Fix it!
    rst $10
    jp continue

; $a is a NEWLINE on the PC but not on the Spectrum, use
; $d instead
F_OUT_FIX_NEWLINE
    ld a, $d
    rst $10
    jp continue
; -------------------------------------

F_IN
    ld a, $0
    ld (last_k), a          ; Clear last pressed key
F_IN_LOOP
    ld a, (last_k)          ; If the value is still 0, repeat
    cp $0
    jr z, F_IN_LOOP
    ld de, (memory_pos)     ; Set the read value at the current
    ld (de), a              ; memory position
    jp continue

; -------------------------------------

F_JMP_FWD
    ld de, (memory_pos)     ; If the value at current memory
    ld a, (de)              ; position is 0, skip until the next
    cp 0                    ; "]"
    jr z, SKIP_LOOP
    
    ld de, (source_pos)     ; Save the "[" source position on the
    push de                 ; stack, and continue to next instruction
    jp continue

; Increments the source position until a "]" is found
SKIP_LOOP
    ld de, (source_pos)     ; Increment source position
    inc de
    ld (source_pos), de

    ld hl, brainfuck        ; String first position
    add hl, de              ; First position + current position
    ld a, (hl)              ; Read opcode from source
    cp OP_JMP_BCK           ; Is it a "]"?
    jr nz, SKIP_LOOP        ; No? Then increment again
    jp continue

; -------------------------------------

F_JMP_BCK
    pop de                  ; Set the source_position as the last
    ld (source_pos), de     ; "[" position saved on the stack
    jp main                 ; Jump to main so that it doesn't increment
                            ; the source_position

; -------------------------------------

end start
