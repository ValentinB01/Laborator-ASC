.section .note.GNU-stack,"",@progbits
.data
    s: .space 101
    len: .space 4

    formatScanf: .asciz "%s"
    formatEndl: .asciz "\n"
    formatChar: .asciz "%c"
    formatPrint_yes: .asciz "Cuvantul este palindrom\n"
    formatPrint_no: .asciz "Cuvantul nu este palindrom\n"
    formatPrint: .asciz "lenght = %d\n"

.text
palindrom:
    pushl %ebp
    movl %esp, %ebp

    movl 8(%ebp), %eax
    decl %eax

    movl %eax, %ecx
    movl $0, %ebx

par:
    cmpl %ecx, %ebx
    jge is_palindrom

    movb (%edi, %ebx, 1), %dl
    cmpb (%edi, %ecx, 1), %dl
    jne not_palindrom

    incl %ebx
    decl %ecx

    jmp par

not_palindrom:
    pushl $formatPrint_no
    call printf
    popl %eax

    jmp palindrom_ret

is_palindrom:
    pushl $formatPrint_yes
    call printf
    popl %eax

palindrom_ret:
    popl %ebp
    ret

.global main
main:

scan:
    pushl $s
    pushl $formatScanf
    call scanf
    popl %ebx
    popl %ebx

    lea s, %edi
    movl $0, %ecx
    movl $0, %ebx

    movl $0, %ecx
    movl $0, %ebx
    lea s, %edi

lenght_loop:
    cmpb (%edi, %ecx, 1), %bl
    je program

    incl %ecx
    jmp lenght_loop

program:
    movl %ecx, len

    pushl $s
    pushl $0
    pushl len
    call palindrom
    popl %edx
    popl %edx
    popl %edx

et_exit:
    pushl $0
    call fflush
    popl %ebx

    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80
    