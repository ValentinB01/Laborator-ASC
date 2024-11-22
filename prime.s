.section .note.GNU-stack,"",@progbits
.data
    x: .space 4
    d: .long 0 # divizori non primi
    nr: .long 0
    prime_msg: .asciz "Numarul este prim\n"
    not_prime_msg: .asciz "Numarul nu este prim\n"
    formatScanf: .asciz "%d"
    newLine: .asciz "\n"
.text
.global main
main:
    pushl $x
    pushl $formatScanf
    call scanf 
    popl %ebx
    popl %ebx

    pushl $newLine
    call printf
    popl %ebx

    xorl %ebx, %ebx
    movl $2, %ecx
    movl x, %eax
    xorl %edx, %edx
    idiv %ecx
    movl %eax, %ebx
    movl $2, %edx
    cmp x, %edx
    je prim
    movl $3, %edx
    cmp x, %edx
    je prim
    movl $4, %edx
    addl $1, d
    cmp x, %edx
    je afisare
    subl $1, d 
    
etloop:
    cmp %ecx, %ebx
    je afisare
    movl x, %eax
    xorl %edx, %edx
    idiv %ecx
    cmp nr, %edx
    je increm
    xorl %edx, %edx
    addl $1, %ecx
    jmp etloop

increm:
    addl $1, d 
    addl $1, %ecx
    jmp etloop

afisare:
    movl d, %edx
    cmp nr, %edx
    je prim
    movl $4, %eax
    movl $1, %ebx
    movl $not_prime_msg, %ecx
    movl $21, %edx
    int $0x80
    jmp etexit

prim:
    movl $4, %eax
    movl $1, %ebx
    movl $prime_msg, %ecx
    movl $18, %edx
    int $0x80
    jmp etexit

etexit:
    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80
