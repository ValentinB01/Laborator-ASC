## Citire si afisare matrice
.section .note.GNU-stack,"",@progbits
.data
    n: .space 4
    m: .space 4
    matrix: .space 40000
    i: .long 0
    j: .long 0

    format_scanf: .asciz "%d"
    format_printf: .asciz "%d "
    new_line: .asciz "\n"

.text
.global main
main:
    pushl $n
    pushl $format_scanf
    call scanf
    popl %eax
    popl %eax

    pushl $m
    pushl $format_scanf
    call scanf
    popl %eax
    popl %eax

    lea matrix, %edi
    xorl %ecx, %ecx

    movl n, %eax
    mull m
    movl %eax, %ebx # Retinem n * m in %ebx

et_read:
    cmpl %ebx, %ecx
    je et_after_read

    # Salvam %ecx in stiva sa isi pastreze valoarea
    pushl %ecx

    # Calculam adresa matricei[i][j] si o retinem in %eax
    lea (%edi, %ecx, 4), %eax

    # Valoarea introdusa pentru matricea[i][j]
    pushl %eax
    pushl $format_scanf
    call scanf
    popl %eax
    popl %eax

    # Preluam valoarea lui %ecx din stiva
    popl %ecx

    incl %ecx
    jmp et_read

    pushl $new_line
    call printf
    popl %eax

et_after_read:
    movl $0, i
    xorl %ecx, %ecx
    pushl $new_line
    call printf
    popl %ebx

et_print_i:
    # Loop printre linii
    cmpl %ebx, %ecx
    je et_exit

    movl $0, j

et_print_j:
    # Loop printre coloane
    movl j, %edx
    cmpl %edx, m
    je et_incl_i

    pushl %ecx

    # Afisam valoarea matricei[i][j]
    pushl (%edi, %ecx, 4)
    pushl $format_printf
    call printf
    popl %eax
    popl %eax

    popl %ecx

    incl %ecx
    incl j
    jmp et_print_j

et_incl_i:
    pushl %ecx

    pushl $new_line
    call printf
    popl %eax

    popl %ecx

    incl i
    jmp et_print_i

et_exit:
    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80


##Citire si afisare vector
.section .note.GNU-stack,"",@progbits
.data
    vect: .space 800
    n: .space 4
    x: .space 4
    formatscanf: .asciz "%d"
    formatprint: .asciz "%d "
    new_line: .asciz "\n"
.text
.global main
main:
citire:

    pushl $n
    pushl $formatscanf
    call scanf
    popl %ebx
    popl %ebx

    movl $0, %ecx
    lea vect, %edi

citire_vect:

    cmpl n, %ecx
    je gata_citire

    //citesc fiecare element
    pushl %ecx
    pushl $x
    pushl $formatscanf
    call scanf
    popl %ebx
    popl %ebx
    popl %ecx

    //mut fiecare element citit in vector
    movl x, %eax
    movl %eax, (%edi, %ecx, 4)
    incl %ecx
    jmp citire_vect

gata_citire:
    xorl %ecx, %ecx

afisare_vector:

    cmpl n, %ecx
    jge et_exit

    pushl %ecx
    pushl (%edi, %ecx, 4) //afisez elementele pe rand
    pushl $formatprint
    call printf
    popl %ebx
    popl %ebx
    popl %ecx

    incl %ecx
    jmp afisare_vector

et_exit:
    pushl $new_line
    call printf
    popl %ebx

    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80
