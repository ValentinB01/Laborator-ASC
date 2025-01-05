.section .note.GNU-stack,"",@progbits
.data
    vect: .space 1024
    nr_op: .space 4
    n: .space 4
    descr: .space 4
    dim: .space 4
    cod: .space 4
    j: .space 4
    k: .space 4
    len: .space 4
    var1: .space 4
    var2: .space 4
    sz: .long 1023
    siz: .long 1024
    max: .space 4
    cop: .space 4

    format_scanf: .asciz "%d"
    format_print: .asciz "%d: (%d, %d)\n"
    format_print_get: .asciz "(%d, %d)\n"
    format_print_error: .asciz "Eroare de input!\n"

.text

add:
    pushl $descr
    pushl $format_scanf
    call scanf
    popl %ebx
    popl %ebx

    pushl $dim
    pushl $format_scanf
    call scanf
    popl %ebx
    popl %ebx

    xorl %edx, %edx
    movl dim, %eax
    movl $8, %ebx
    divl %ebx
    cmpl $0, %edx
    je continue_add
    incl %eax ## se formeaza lungimea secventei in %eax
    
continue_add:
    xorl %edx, %edx
    lea vect, %edi

    movl %eax, len
    movl $1024, %eax
    cmpl len, %eax
    jl afisare_nula

    subl len, %eax
    movl %eax, max
    addl $1, max
    xorl %ebx, %ebx
    movl %ebx, k

formare_interval:
    movl k, %ebx
    movl %ebx, var1
    addl len, %ebx ##formez capetele intervalului (var1, var2)
    movl %ebx, var2
    movl var1, %ecx
    lea vect, %edi 

verify_interval:
    mov (%edi,%ecx,1),%al

    cmp $0, %al
    jne increm_k

    incl %ecx
    cmpl %ecx, var2
    jne verify_interval

    jmp modificare_interval

modificare_interval:
    movl var1, %ecx
    
actualizare_memorie:
    lea vect, %edi
    mov descr, %al ##actualizez vector-ul
    mov %al, (%edi, %ecx, 1)

    incl %ecx

    cmpl %ecx, var2
    jne actualizare_memorie

    jmp afisare_add

increm_k:
    incl k
    movl k, %ebx

    cmpl %ebx, max
    jg formare_interval

    cmpl %ebx, max
    jle afisare_nula

    jmp add_exit

afisare_nula:
    xorl %eax, %eax

    pushl %eax
    pushl %eax
    pushl descr
    pushl $format_print
    call printf
    popl %ebx
    popl %ebx
    popl %ebx
    popl %ebx
    jmp add_exit

afisare_add:
    decl var2

    pushl var2 ## capat superior
    pushl var1 ## capat inferior
    pushl descr ## descr
    pushl $format_print
    call printf
    popl %ebx
    popl %ebx
    popl %ebx
    popl %ebx

add_exit:
    ret

del:
    pushl $descr
    pushl $format_scanf
    call scanf
    popl %ebx
    popl %ebx

    lea vect, %edi
    xorl %ecx, %ecx

loop_del:
    xorl %eax, %eax
    movb (%edi, %ecx, 1), %al
    cmpl descr, %eax ## verific daca e egal descr cu elem din vect
    jne not_equal 

    xorl %eax, %eax
    movb %al, (%edi, %ecx, 1) ## inlocuiesc elem din vect cu descr resp cu 0
not_equal:
    cmpl sz, %ecx
    je del_exit

    incl %ecx
    jmp loop_del
del_exit:
    ret


defr:
    lea vect, %edi
    xorl %ecx, %ecx
    xorl %edx, %edx
loop_defr:
    movb (%edi, %ecx, 1), %al

    cmp $0, %al
    je increm 

    movb %al, %bl
    mov $0, %bh
    movb %bh, (%edi, %ecx, 1)
    movb %bl, (%edi, %edx, 1)
    incl %edx

increm:
    incl %ecx
    cmpl %ecx, siz
    jne loop_defr

    xorl %ecx, %ecx
    xorl %edx, %edx

defr_exit:
    ret


.global main
main:
    pushl $nr_op
    pushl $format_scanf ## se citeste numarul operatiilor pe care le vom efectua
    call scanf
    popl %ebx
    popl %ebx

    movl $0, j

main_loop:
    movl j, %ecx 
    cmpl nr_op, %ecx ## verific daca nr op == operatiile efectuate
    je et_exit

    pushl $cod
    pushl $format_scanf ## citim codificarea operatiei pe care dorim sa o executam
    call scanf
    popl %ebx
    popl %ebx
    movl cod, %edx

    cmpl $1, %edx
    je add_main
    cmpl $2, %edx
    je get_main
    cmpl $3, %edx
    je del_main
    cmpl $4, %edx
    je defr_main

    pushl %ecx
    pushl $format_print_error ## daca citim o codificare care nu exista ne da o eroare
    call printf 
    popl %ebx
    popl %ecx
    jmp main_loop

exit_fct:
    incl j
    jmp main_loop 


add_main:
    pushl $n
    pushl $format_scanf ## citesc numarul de fisiere pe cere vreau sa il adaug
    call scanf
    popl %ebx
    popl %ebx
    xorl %ecx, %ecx
    
loop_add_main:
    cmpl n, %ecx
    je exit_fct

    pushl %ecx
    pushl %eax
    pushl %edx
    call add ##apelez functia de cate ori e nevoie (n ori)
    popl %edx 
    popl %eax
    popl %ecx

    incl %ecx
    jmp loop_add_main


get_main:
    pushl $descr
    pushl $format_scanf
    call scanf
    popl %ebx
    popl %ebx

    xorl %ecx, %ecx
    xorl %eax, %eax
    lea vect, %edi
    movb (%edi, %ecx, 1), %al

get_loop:
    cmpl descr, %eax ##parcurge vect pana gaseste prima poz pe care e descr respectiv
    je continuare_get

    cmpl $1024, %ecx
    je afisare_vida

    incl %ecx
    movb (%edi, %ecx, 1), %al

    jmp get_loop

continuare_get:
    movl %ecx, var2

afisare_get:
    xorl %eax, %eax
    xorl %ebx, %ebx
    movb (%edi, %ecx, 1), %al
    movb 1(%edi, %ecx, 1), %bl

    cmpl %eax, %ebx
    je egale  
        
    movl %ecx, var1

    pushl %ecx
    pushl var1 ## marginea superioara
    pushl var2 ## marginea inferioara
    pushl $format_print_get
    call printf
    popl %ebx
    popl %ebx
    popl %ebx
    popl %ecx

    jmp get_exit

egale:
    incl %ecx
    jmp afisare_get

afisare_vida:
    xorl %eax, %eax

    pushl %eax
    pushl %eax
    pushl $format_print_get
    call printf
    popl %ebx
    popl %ebx
    popl %ebx

get_exit:
    jmp exit_fct



del_main:
    pushl %ecx
    pushl %eax
    pushl %edx
    call del
    popl %edx
    popl %eax
    popl %ecx

    xorl %ecx, %ecx
    lea vect, %edi
    movl $0, var2

afisare_del:
    cmpl $1024, %ecx
    je exit_fct

    xorl %eax, %eax
    xorl %ebx, %ebx
    movb (%edi, %ecx, 1), %al
    movb 1(%edi, %ecx, 1), %bl

    cmpl %eax, %ebx
    je equal_del
    cmpl $0, %eax
    je zero_del

    movl %ecx, var1
    movb (%edi, %ecx, 1), %bl


    pushl %ecx
    pushl var1
    pushl var2
    pushl %ebx
    pushl $format_print
    call printf
    popl %ebx
    popl %ebx
    popl %ebx
    popl %ebx
    popl %ecx

zero_del:
    movl %ecx, var2
    incl var2
equal_del:
    incl %ecx
    jmp afisare_del


defr_main:
    pushl %ecx
    pushl %eax
    pushl %edx
    call defr
    popl %edx
    popl %eax
    popl %ecx

    xorl %ecx, %ecx
    lea vect, %edi
    movl $0, var2

afisare_defr:
    cmpl sz, %ecx
    je exit_fct

    xorl %eax, %eax
    xorl %ebx, %ebx
    movb (%edi, %ecx, 1), %al
    movb 1(%edi, %ecx, 1), %bl

    cmpl %eax, %ebx
    je equal_defr

    movl %ecx, var1
    movb (%edi, %ecx, 1), %bl

    pushl %ecx
    pushl var1
    pushl var2
    pushl %ebx
    pushl $format_print
    call printf
    popl %ebx
    popl %ebx
    popl %ebx
    popl %ebx
    popl %ecx

    movl %ecx, var2
    incl var2

equal_defr:
    incl %ecx
    jmp afisare_defr

et_exit:
    pushl $0
    call fflush
    popl %ebx

    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80
