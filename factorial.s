.section .note.GNU-stack,"",@progbits
.data
    x: .space 4
    formatScanf: .asciz "%d"
    formatPrintf: .asciz "%d! = %d\n"
.text
fact:
    movl 4(%esp), %ecx
    cmpl $1, %ecx
    jg fact_rec

    ret
fact_rec:
    movl 4(%esp), %ebx

    xorl %edx, %edx
    mul %ebx

    decl %ebx
    pushl %ebx
    call fact
    popl %ebx

    ret
.global main
main:
scan:
    pushl $x
    pushl $formatScanf
    call scanf
    popl %ebx
    popl %ebx

    movl $1, %eax
    pushl x
    call fact
    popl %ebx

print:
    pushl %eax
    pushl x
    pushl $formatPrintf
    call printf
    popl %ebx
    popl %ebx
    popl %ebx

etexit:
    pushl $0
    call fflush
    popl %eax

    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80


## Factorial nerecursiv

.section .note.GNU-stack,"",@progbits
.data
    n: .space 4
    format_scanf: .asciz "%d\n"
    format_print: .asciz "%d! = %d\n"
.text
.global main
main:
scan:
    pushl $n
    pushl $format_scanf
    call scanf
    popl %ebx
    popl %ebx

    movl $2, %ecx
    movl $1, %eax

et_loop:
    cmpl n, %ecx
    jg etexit

    mul %ecx
    incl %ecx
    jmp et_loop

etexit:
    pushl n
    pushl %eax
    pushl $format_print
    call printf
    popl %ebx
    popl %ebx
    popl %ebx

    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80

## Factorial functie
.section .note.GNU-stack,"",@progbits
.data
    n:.space 4
    format_scanf: .asciz "%d"
    format_print: .asciz "%d! = %d\n"
.text
    
fact:
    pushl %ebp
    mov %esp, %ebp

    movl $1, %ecx
    movl $1, %eax
et_loop:
    movl 8(%ebp), %ebx
    cmpl %ebx, %ecx
    jg fact_afisare
    
    xorl %edx, %edx
    mull %ecx
    incl %ecx
    jmp et_loop

fact_afisare:
    popl %ebp
    ret

.global main
main:
citire:
    pushl $n
    pushl $format_scanf
    call scanf
    popl %ebx
    popl %ebx

program:
    pushl n
    call fact
    popl %ebx

etexit:
    pushl %eax
    pushl n
    pushl $format_print
    call printf
    popl %ebx
    popl %ebx
    popl %ebx

    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80
