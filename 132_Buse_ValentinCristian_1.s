.section .note.GNU-stack,"",@progbits
.data
    n: .space 4
    descr: .space 4
    dim: .space 4
    op: .space 4
    index: .space 4
    nr_op: .space 4
    index_add: .space 4
    mat: .space 1048576
    format_scan: .asciz "%d"
    format_print: .asciz "%d "
    format_afisare_get: .asciz "((%d, %d), (%d, %d))\n"
    format_printf: .asciz "%d: ((%d, %d), (%d, %d))\n"
    newline: .asciz "\n"
    i: .space 4
    j: .space 4
    len: .space 4
    l: .space 4
    nr_iteratii: .space 4
    col: .long 1024
    row: .long 1023
    var1: .space 4 ##left
    var2: .space 4 ##right
    aux_descr: .space 4
    max: .space 4
    var: .space 4
    cop1: .space 4
    cop2: .space 4
    var1_afis: .space 4
    var2_afis: .space 4
    ok: .space 4

.text

add:
    pushl %ebp
    movl %esp,%ebp

    mov 16(%ebp),%al
    movl 8(%ebp),%edx
    movl %edx,var1
    movl 12(%ebp),%edx
    movl %edx,var2

modificare_interval:
    movl var1,%ecx

    mov %al,(%edi,%ecx,1)

    incl var1
        
    movl var1,%ebx
    cmpl %ebx,var2
    jne modificare_interval
    
    popl %ebp
    ret


afisare_add:
    pushl %ebp
    movl %esp,%ebp

    xorl %eax,%eax
    xorl %edx,%edx
    movl 8(%ebp),%eax
    divl col
    pushl %edx
    pushl %eax

    xorl %eax,%eax
    xorl %edx,%edx
    movl 12(%ebp),%eax
    divl col
    pushl %edx
    pushl %eax

    xorl %eax,%eax
    movl 16(%ebp),%eax

    pushl %eax
    pushl $format_printf
    call printf
    popl %eax
    popl %eax
    popl %eax
    popl %eax
    popl %eax
    popl %eax

    popl %ebp
    ret    


matr:
    movl $0,i 
loop_i:
    movl $0,l
    movl $0,j
loop_j:
    xorl %eax,%eax
    movl i,%eax
    mull col
    addl j,%eax
                
    xorl %ebx,%ebx
    mov (%edi,%eax,1),%bl
                
    push %ebx
    pushl $format_print
    call printf
    popl %ebx
    popl %ebx

verif_loop_j:
    xorl %edx,%edx
    incl j
    mov col,%edx
    cmpl %edx,j
    jne loop_j
        
verif_loop_i:
    pushl $newline
    call printf
    popl %ebx

    xorl %edx,%edx
    incl i
    mov row,%edx
    cmpl %edx,i
    jne loop_i
    
    ret


get:
    pushl %ebp
    movl %esp,%ebp

    movl 8(%ebp),%ebx
    movl %ebx,aux_descr
    movl row,%eax
    mull col
    movl %eax,max
    incl max

    xorl %ecx,%ecx
    movl $0,var1
    movl $0,var2
loop_get:
    mov (%edi,%ecx,1),%al

    cmp aux_descr,%al
    je loop_afis_get

    incl %ecx

    cmpl %ecx,max
    je afisare_get_nula

    jmp loop_get
    
loop_afis_get:
    movl %ecx, var1

search_get1:
    incl %ecx
    mov (%edi,%ecx,1),%al

    cmp %al,aux_descr
    je search_get1
        
    decl %ecx
    movl %ecx,var2

    xorl %eax,%eax
    xorl %edx,%edx
    movl var2,%eax
    divl col
    pushl %edx
    pushl %eax

    xorl %eax,%eax
    xorl %edx,%edx
    movl var1,%eax
    divl col
    pushl %edx
    pushl %eax

    pushl $format_afisare_get
    call printf
    popl %ebx
    popl %ebx
    popl %ebx
    popl %ebx
    popl %ebx

    popl %ebp
    ret
        

afisare_get_nula:
    xorl %ebx, %ebx

    pushl %ebx
    pushl %ebx
    pushl %ebx
    pushl %ebx
    pushl $format_afisare_get
    call printf
    popl %ebx
    popl %ebx
    popl %ebx
    popl %ebx
    popl %ebx

    popl %ebp
    ret
    

del:
    pushl %ebp
    movl %esp,%ebp
    movl 8(%ebp),%ebx
    movl %ebx,aux_descr

    xorl %ecx,%ecx
    movl $0,var1
    movl $0,var2
loop_delete:
    mov (%edi,%ecx,1),%al

    cmp aux_descr,%al
    je search_delete1

    incl %ecx

    cmpl %ecx,max
    je exit_del

    jmp loop_delete
    
search_delete1:
    movl %ecx,var1

init1:
    incl %ecx
    mov (%edi,%ecx,1),%al

    cmp %al,aux_descr
    je init1
        
        
    movl %ecx, var2

    movl var1, %ecx
del_interval:
    mov $0,%al
    mov %al,(%edi,%ecx,1)

    incl %ecx

    cmp %ecx,var2
    jne del_interval
    
exit_del:
    popl %ebx
    ret

afisare_intervale:
    movl row,%eax
    mull col
    movl %eax,max
    incl max
    movl $0,var1
    movl $0,var2
    xorl %ecx,%ecx
search_val:
    mov (%edi,%ecx,1),%al
    mov %al,var

    cmpl $0,var
    jne afis_val

    mov max,%ebx
    cmpl %ecx,%ebx
    je exit_afis

    incl %ecx
    jmp search_val

afis_val:

    movl %ecx,var1

search_dr:

    incl %ecx

    movl max,%ebx
    cmpl %ecx,%ebx
    je max_dr

    mov (%edi,%ecx,1),%al

    cmp %al,var
    je search_dr

    movl %ecx,var2
    jmp et_afisare

max_dr:
    movl max,%ebx
    movl %ebx,var2
                
et_afisare:
    movl %ecx,i
    cmpl $0,var2
    je et_incl
    decl var2

    movl %ebx,cop1
    movl %ecx,cop2
    xorl %eax,%eax
    xorl %edx,%edx
    movl var2,%eax
    divl col
    pushl %edx
    pushl %eax

    xorl %eax, %eax
    xorl %edx, %edx
    movl var1, %eax
    divl col
    pushl %edx
    pushl %eax

    pushl var
    pushl $format_printf
    call printf
    popl %eax
    popl %eax
    popl %eax
    popl %eax
    popl %eax
    popl %eax
    movl cop1,%ebx
    movl cop2,%ecx

    jmp search_val
            
et_incl:
    incl var2
    jmp et_afisare

exit_afis:
    ret

reset:
    mov $0,%al
    xorl %ecx,%ecx
    movl $1048576,%ebx

loop_init:
    mov %al,(%esi,%ecx,1)
    incl %ecx
    cmpl %ecx,%ebx
    jne loop_init
    
    ret

.global main
main:

citire_nr_op:
    pushl $nr_iteratii
    pushl $format_scan
    call scanf
    popl %ebx
    popl %ebx

    lea mat,%edi

    movl $0,index
loop_iteratii:
    incl index

    pushl $op
    pushl $format_scan
    call scanf
    popl %ebx
    popl %ebx

    cmpl $1,op
    je add_main

    cmpl $2,op
    je get_main

    cmpl $3,op
    je del_main


verif_nr_op:
    movl index,%ebx
    cmpl %ebx,nr_iteratii
    jne loop_iteratii
        
    jmp et_exit

add_main:
    pushl $nr_op
    pushl $format_scan
    call scanf
    popl %ebx
    popl %ebx

    movl $0,index_add
loop_op1:
    incl index_add

    pushl $descr
    pushl $format_scan
    call scanf
    popl %ebx
    popl %ebx

    pushl $dim
    pushl $format_scan
    call scanf
    popl %ebx
    popl %ebx

    xorl %edx,%edx
    movl dim,%eax
    addl $7,%eax
    movl $8,%ebx
    divl %ebx
    movl %eax,len

    movl $0,i
    movl $0,ok
main_loop_i:
    movl $0, l
    movl $0,j
main_loop_j:
    xorl %eax,%eax
    movl i,%eax
    mull col
    addl j,%eax

    mov (%edi,%eax,1),%bl
    cmp $0,%bl
    jne init_curr_size_0

    incl l

    movl l,%ebx
    cmpl len,%ebx
    jne et_verif_j

    xorl %edx,%edx
    movl %eax,%edx
    subl len,%edx
    incl %edx

    movl %eax,%ebx
    incl %ebx

    movl %edx,var1_afis
    movl %ebx,var2_afis
    decl var2_afis

    pushl descr
    pushl %ebx
    pushl %edx
    call add
    popl %ebx
    popl %ebx
    popl %ebx

    movl $1,ok
    pushl descr
    pushl var1_afis
    pushl var2_afis
    call afisare_add
    popl %ebx
    popl %ebx
    popl %ebx

    jmp  verif_loop_1
                
init_curr_size_0:
    movl $0,l

et_verif_j:
    xorl %edx,%edx
    incl j
    movl col,%edx
    cmpl %edx,j
    jne main_loop_j
        
verif_loopi:
    xorl %edx,%edx
    incl i
    movl row,%edx
    cmpl %edx,i
    jne main_loop_i

    cmpl $0,ok
    jne verif_loop_1

afis_nula:
    pushl descr
	pushl $0
    pushl $0
	call afisare_add
    popl %ebx
	popl %ebx 
	popl %ebx
        
verif_loop_1:
    movl index_add,%ebx                                                                         
    cmpl %ebx,nr_op
    jne loop_op1
        
    jmp verif_nr_op   


get_main:
    pushl $descr
    pushl $format_scan
    call scanf
    popl %ebx
    popl %ebx

    pushl descr
    call get
    popl %ebx

    jmp verif_nr_op

del_main:
    pushl $descr
    pushl $format_scan
    call scanf
    popl %ebx
    popl %ebx

    pushl descr
    call del
    popl %ebx

    call afisare_intervale

    jmp verif_nr_op

et_exit:

    pushl $0
    call fflush
    popl %ebx
    
    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80
