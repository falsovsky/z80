org 30000

tv_flag     equ $5c3c       ; TV flags variable
last_k      equ $5c08       ; Last pressed key

; Brainfuck Operators
OP_INC_DP   equ ">"         ; $3e - 62
OP_DEC_DP   equ "<"         ; $3c - 60
OP_INC_VAL  equ "+"         ; $2b - 43
OP_DEC_VAL  equ "-"         ; $2d - 45
OP_OUT      equ "."         ; $2e - 46
OP_IN       equ ","         ; $2c - 44
OP_JMP_FWD  equ "["         ; $5b - 91
OP_JMP_BCK  equ "]"         ; $5d - 93

; Hello World
;src   db  "++++++++++[>+++++++>++++++++++>+++>+<<<<-]>++.>+.+++++++..+++.>++.<<+++++++++++++++.>.+++.------.--------.>+.>.", 0
; Arvorezinha
;src   db  "++++[>++++++++++<-]>++.>+++++++++++++.<<++[>.<-]>>.<<+++[>.<-]>>.<<++++[>.<-]>>.<<+++++[>.<-]>>.", 0
; To test the "," operator
;src   db  "++++++++++>+[,<.>.]", 0
; Bad Boy Hello world - crashes most interpreters
src   db  ">++++++++[<+++++++++>-]<.>>+>+>++>[-]+<[>[->+<<++++>]<<]>.+++++++..+++.>>+++++++.<<<[[-]<[-]>]<+++++++++++++++.>>.+++.------.--------.>>+.>++++.", 0

; Variables
memory_pos  db  $0,$80      ; Current memory position
                            ; Contains the address on where the BF memory begins
source_pos  db  $0,$0       ; Current source position
branch_count db $0
lookup_tbl_opcodes  db  OP_INC_DP, OP_DEC_DP, OP_INC_VAL, OP_DEC_VAL, OP_OUT, OP_IN, OP_JMP_FWD, OP_JMP_BCK
lookup_tbl_routines dw  F_INC_DP, F_DEC_DP, F_INC_VAL, F_DEC_VAL, F_OUT, F_IN, F_JMP_FWD, F_JMP_BCK


start
    xor a                   ; a = 0
    ld (tv_flag), a         ; Enables rst $10 output to the TV
    push bc                 ; Save BC on the stack

main
    ld hl, src              ; Get source first position
    ld de, (source_pos)     ; 
    add hl, de              ; First position + current position

    ld a, (hl)              ; Read opcode from source

    cp $0                   ; End of file
    jr z, end_main          ; Jump to the end

    call loopup_table       ; Process opcode

continue
    ld de, (source_pos)     ; Increment source position
    inc de
    ld (source_pos), de

    jr main                 ; Do it again

end_main
    pop bc                  ; Get BC out of the stack
    ret                     ; Exit to BASIC

; -------------------------------------

; opcode comes in A
loopup_table
    pop de                  ; Remove return address from stack
    ld de, lookup_tbl_opcodes ; Start of opcodes_tbl in DE
    ld hl, lookup_tbl_routines ; Start of routines_tbl in HL
    ld c, $9                ; Number of valid opcodes + 1
loopup_table_loop
    ld b, a                 ; B = A (opcode to run)
    push bc                 ; Push BC to the stack
                            ; B = Opcode, C = counter
    ld a, (de)              ; Read item from opcodes_tbl
    cp b                    ; Is it the same?
    jr z, lookup_table_found ; Found it!
    pop bc                  ; Get values from stack
    ld a, b                 ; A = B (opcode to run)
    inc de                  ; Next item in opcodes_tbl
    inc hl
    inc hl                  ; Next item in opcodes_routines              
    dec c                   ; C = C -1
    jr z, lookup_table_default ; Is it 0? Non valid opcode
    jr loopup_table_loop    ; Repeat
lookup_table_found
    pop bc
    jr lookup_table_ret
lookup_table_default
    ld de, continue         ; DE = address to "continue" label
    push de                 ; Send it to the stack
    ret                     ; Return to last item in the stack
lookup_table_ret
    ld e, (hl)              ; Save the address of the routine to
    inc hl                  ; be RETurned in DE
    ld d, (hl)
    push de                 ; Send it to the stack
    ret                     ; Return to last item in the stack

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
    cp $0                   ; "]"
    jr z, SKIP_LOOP
    
    ld de, (source_pos)     ; Save the "[" source position on the
    push de                 ; stack, and continue to next instruction
    jp continue

; Increments the source position until a "]" is found
SKIP_LOOP
    ld a, (branch_count)    ; Increment the number of branches
    inc a
    ld (branch_count), a
SKIP_LOOP_2    
    ld de, (source_pos)     ; Increment source position
    inc de
    ld (source_pos), de

    ld hl, src              ; String first position
    add hl, de              ; First position + current position
    ld a, (hl)              ; Read opcode from source

    cp OP_JMP_FWD           ; Is it a "[" ?
    jr z, F_JMP_FWD         ; Do it again
    
    cp OP_JMP_BCK           ; Is it a "]"?
    jr nz, SKIP_LOOP_2      ; Repeat until found

    ld a, (branch_count)    ; If the number of branches is not 0
    dec a                   ; we need to find the next "]"
    ld (branch_count), a
    cp $0
    jr nz, SKIP_LOOP_2
    jp continue

; -------------------------------------

F_JMP_BCK
    pop de                  ; Set the source_position as the last
    dec de                  ; "[" position saved on the stack 
    ld (source_pos), de     ; minus 1
    jp continue             ; The continue label increments it

; -------------------------------------

end start
