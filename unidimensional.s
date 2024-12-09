.section .note.GNU-stack,"",@progbits
.data
    vect: .space 1000
    nume: .space 4
    dim: .space 4
    n: .space 4
    len: .long 3
    st: .space 4
    dr: .space 4
    i: .space 4
    j: .space 4
    op1: .space 4
    aux: .space 4
    norm_len: .long 8
    len_vect: .long 1000

    format_scanf: .asciz "%d"
    new_line: .asciz "\n"

    formatprint: .asciz "%d "
    format_printf_add: .asciz "%d: (%d, %d)\n"
    format_printf_get: .asciz "(%d, %d)\n"
.text

add:
    pushl $n
    pushl $format_scanf
    call scanf
    popl %ebx
    popl %ebx

    xorl %ecx, %ecx
main_loop:
    cmpl n, %ecx
    je add_ret

    pushl $nume  ##citesc numele descriptor si dimensiunea lui
    pushl $format_scanf
    call scanf
    popl %ebx
    popl %ebx

    pushl $dim
    pushl $format_scanf
    call scanf
    popl %ebx
    popl %ebx

    ##movl dim, %eax  ##formez lungimea secventei ce trebuie inserata in vect
    ##divl norm_len
    ##movl %eax, len
    ##movl $0, %ebx
    ##cmpl %ebx, %edx 
    ##jg increm_len
    
continuare1:
    xor %bl, %bl
    xorl %edx, %edx
    movl $0, st
    movl $0, dr

loop_i:
    cmpl %edx, len_vect #%edx = i
    je final
    
    cmpb (%edi, %edx, 1), %bl ## trebuie comparat cu bl de un byte
    je cont_if

cont_loop_i:
    incl %edx
    jmp loop_i

cont_if:
    movl %edx, %eax ##%eax = j

loop_j:
    movl $len, %esi
    movl %esi, op1 ##j < len +i -1
    addl %edx, op1
    decl op1 # len+i-1
    cmpl %eax, op1
    jg cond2
    jmp st_dr_if

cond2:
    cmpb (%edi, %eax, 1), %bl ##v[j] = 0
    je increm_j
    jmp st_dr_if

increm_j:
    incl %eax
    jmp loop_j

st_dr_if:
    subl %edx, op1 ##op1 = len -1
    movl %eax, %ebx
    subl %edx, %ebx ##j-i
    cmpl op1, %ebx
    je atrib

increm_i:
    xorl %ebx, %ebx
    incl %edx
    jmp loop_i

atrib:
    movl %edx, st
    movl %eax, dr

    pushl nume
    pushl st
    pushl dr
    pushl $format_printf_add
    call printf
    popl %ebx
    popl %ebx
    popl %ebx
    popl %ebx
    jmp final

final:
    decl n
loop_final:
    cmpl %edx, %eax
    je main_loop

    movl nume, %ebx
    movb %bl, (%edi, %edx, 1)
    incl %edx
    jmp main_loop

increm_len:
    incl len
    jmp continuare1

add_ret:
    ret

get:

del:
    pushl $nume
    pushl $format_scanf
    call scanf
    popl %ebx
    popl %ebx

    xorl %ecx, %ecx
    movl nume, %ebx
loop_del:
    cmpl %ecx, len_vect
    je del_ret

    cmpb (%edi, %ecx, 1), %bl
    je del_elem
    incl %ecx
    jmp loop_del

del_elem:
    movb $0, (%edi, %ecx, 1)
    incl %ecx
    jmp loop_del

del_ret:
    ret
    
.global main
main:

citire:
    xorl %ecx, %ecx
    lea vect, %edi

program: 
    call add

    xorl %ecx, %ecx
    movl $10, n
afisare_vector:
    cmpl n, %ecx
    jge et_exit

    pushl %ecx
    push (%edi, %ecx, 1)
    pushl $formatprint
    call printf
    popl %ebx
    popl %ebx
    popl %ecx

    incl %ecx
    jmp afisare_vector

et_exit:
    pushl $0
    call fflush
    popl %ebx

    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80
