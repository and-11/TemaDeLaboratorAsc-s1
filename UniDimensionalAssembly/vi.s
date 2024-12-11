.data
    #  modif mai tarziu------------------------  ATENTIE ATENTIE ATENTIE ATENTIE ATENTIE
    a: .space 4096
    n: .long 1024
    # -----------------------------------------
    q: .long 0
    task: .long 0
    ct_operatii: .long 0
    
    # constane
    test: .asciz "--->  %ld\n"
    af_sir: .asciz "%ld:%ld  "
    af_fisier: .asciz "%d: (%d, %d)\n"
    af_get: .asciz "(%d, %d)\n"
    c_long: .asciz "%ld"
    eroare_add: .asciz "(0, 0)\n"

    # var ocazionale
    desc: .long 0
    desc_size: .long 0
    start: .long 0
    a_st: .long 0
    a_dr: .long 0
    lg: .long 0
    desc_gasit: .long 0

.text

apel_flush:
    pushl $0
    call fflush
    popl %eax
ret


testare:
    pushl 4(%esp)
    pushl $test
    call printf
    popl %eax
    popl %eax
    call apel_flush
ret

citire:
    pushl 4(%esp)
    pushl $c_long
    call scanf
    popl %eax
    popl %eax
ret


    # capetele sunt inchise !!!
    # st (%esp,3,4)  %eax
    # dr (%esp,2,4)  %ebx
    # val (%esp,1,4) %edx
# --------------------------------------------------  daca e aceiasi val?
umplere:

    movl $3,%ecx
    movl (%esp,%ecx,4),%eax
    sub $1,%ecx
    movl (%esp,%ecx,4),%ebx
    sub $1,%ecx
    movl (%esp,%ecx,4),%edx

    umplere_inceput:

        movl %edx,a(,%eax,4)
        add $1,%eax
        cmp %eax,%ebx
        jae umplere_inceput
ret

afisare_sir:
    pushl %ebx
    # ebx - i   0 n
    xorl %ebx,%ebx
    afisare_sir_inceput:
        pushl a(,%ebx,4)
        pushl %ebx
        pushl $af_sir
        call printf
        popl %eax
        popl %eax
        popl %eax
        call apel_flush

        inc %ebx
        movl n,%eax
        cmp %eax,%ebx
        jne afisare_sir_inceput
    popl %ebx
ret

tst:
    pushl q
    call testare
    popl %eax
ret

initializare_sir:
    movl n,%eax
    sub $1,%eax
    pushl $0
    pushl %eax
    pushl $0
    call umplere
    popl %ebx
    popl %ebx
    popl %ebx
ret

Afisare_fisiere:

    pushl %ebx

    xorl %ebx,%ebx
    movl %ebx,desc_gasit

    afisare_fisiere_inceput:
        xorl %eax,%eax
        movl a(,%ebx,4),%edx 
        cmp %edx,%eax
        je skip_afisare_fisiere_inceput

        movl %edx,desc
        movl %ebx,a_st

        afisare_fisiere_inceput_parcurgere_termeni_egali:
            inc %ebx
            movl a(,%ebx,4),%edx 
            cmp desc,%edx
            je afisare_fisiere_inceput_parcurgere_termeni_egali
        dec %ebx
        movl %ebx,a_dr

        pushl a_dr
        pushl a_st
        pushl desc
        pushl $af_fisier
        call printf
        popl %eax
        popl %eax
        popl %eax
        popl %eax
        call apel_flush


        skip_afisare_fisiere_inceput: 

        inc %ebx
        cmp n,%ebx
        jne afisare_fisiere_inceput
        
    popl %ebx

ret 

F_Get:
    pushl %ebx

    pushl $desc
    call citire
    popl %eax
    xorl %eax,%eax
    movl %eax,a_st
    movl %eax,a_dr
    movl %eax,desc_gasit

    xorl %ebx,%ebx
    Get_parcurgere:

    movl a(,%ebx,4),%eax
    cmp desc,%eax
    jne get_actualizare_skip

        xorl %eax,%eax
        cmp desc_gasit,%eax
        jne get_st_skip
        movl %ebx,a_st
        get_st_skip:
        movl %ebx,a_dr 
        movl $1,desc_gasit   

    get_actualizare_skip:
    inc %ebx
    cmp n,%ebx
    jne Get_parcurgere

    pushl a_dr
    pushl a_st
    pushl $af_get
    call printf
    popl %eax
    popl %eax
    popl %eax
    call apel_flush

    popl %ebx
    
ret


F_Delete:
    pushl %ebx

    pushl $desc
    call citire
    popl %eax
    xorl %ebx,%ebx

    Delete_parcurgere:

    movl a(,%ebx,4),%eax
    cmp desc,%eax
    jne Delete_parcurgere_skip 

    xorl %eax,%eax
    movl %eax,a(,%ebx,4)

    Delete_parcurgere_skip:
    inc %ebx
    cmp n,%ebx
    jne Delete_parcurgere
    
    call Afisare_fisiere
    
    popl %ebx
ret


Add_Element:
    push %ebx

    pushl $desc
    call citire
    popl %eax

    pushl $desc_size
    call citire
    popl %eax

etdebug:
    xorl %edx,%edx
    movl desc_size,%eax
    add $7,%eax
    movl $8,%ebx
    div %ebx
    movl %eax,desc_size

    # desc_size sa fie >=2
    movl $2,%eax
    cmp desc_size,%eax
    jb Add_macar_doi
    movl $2,desc_size
    Add_macar_doi:

    xorl %eax,%eax
    movl %eax,a_st
    movl %eax,a_dr
    movl %eax,lg
    movl %eax,%ebx
# ebx - i       0 n
    Add_parcurgere:
        # a[i]-0
        
        movl lg,%eax
        inc %eax
        movl %eax,lg

        xorl %eax,%eax
        cmp a(,%ebx,4),%eax
        je Add_skip_zero
        xorl %eax,%eax
        movl %eax,lg
        Add_skip_zero:


        movl lg,%eax
        cmp desc_size,%eax
        jne Add_skip_gasit

        movl %ebx,a_dr

        movl %ebx,%eax
        sub desc_size,%eax
        inc %eax
        movl %eax,a_st

        pushl a_st
        pushl a_dr
        pushl desc
        call umplere
        popl %eax
        popl %eax
        popl %eax

        jmp Add_gata


        Add_skip_gasit:

    inc %ebx
    cmp n,%ebx
    jne Add_parcurgere

    Add_gata:
    pushl a_dr        
    pushl a_st  
    pushl desc
    pushl $af_fisier
    call printf
    popl %eax
    popl %eax
    popl %eax
    popl %eax
    call apel_flush            

    popl %ebx
ret

F_Add:
    pushl %ebx

    pushl $ct_operatii
    call citire
    popl %eax

    xorl %ebx,%ebx

    Parcurgere_adduri:

    pushl %ebx
    call Add_Element
    popl %ebx

    inc %ebx
    cmp ct_operatii,%ebx
    jne Parcurgere_adduri

    popl %ebx
ret

F_Defragmentation:
    push %ebx

    xorl %ebx,%ebx              # ebx -  tot sirul
    xorl %ecx,%ecx              # ecx - zerourile

    Defragmentation_parcurgere:
        cmp $0,a(,%ebx,4)
        je Defragmentation_salt_pas 

            movl a(,%ebx,4),%eax
            xorl %edx,%edx
            movl %edx,a(,%ebx,4)

            movl %eax,a(,%ecx,4)
            inc %ecx
        Defragmentation_salt_pas:


    inc %ebx
    cmp n,%ebx
    jne Defragmentation_parcurgere
    call Afisare_fisiere

    popl %ebx
ret

.global main

main:

# TESTE
/*      Teste
    pushl $0
    pushl $0
    pushl $13
    call umplere
    popl %eax
    popl %eax
    popl %eax
    call afisare_sir
*/

                        # daca da eroare vezi daca e buna linia 379 (inca nu am testat.0)
    call initializare_sir                      # daca 100% val initiala a sirului e 0  -> sterge linia asta!
    pushl $q
    call citire
    popl %ebx

    # nu ffa nmc daca 0=q
    xorl %eax,%eax
    cmp q,%eax
    je et_exit


    prelucrare_input:  
        pushl $task
        call citire
        popl %eax
        # ADD ------------------------------------- 1
        movl $1,%eax
        cmp task,%eax
        jne skip_a
        # call Add_Element
        call F_Add
        skip_a:
        # Get ------------------------------------- 2
        movl $2,%eax
        cmp task,%eax
        jne skip_g
        call F_Get
        skip_g:
        # Delete ---------------------------------- 3
        movl $3,%eax
        cmp task,%eax
        jne skip_del
        call F_Delete
        skip_del:
        # DEFRAGMENTATION ------------------------- 4
        movl $4,%eax
        cmp task,%eax
        jne skip_def
        call F_Defragmentation
        skip_def:

        subl $1,q
        xorl %eax,%eax
        cmp q,%eax
        jne prelucrare_input
# modif functiile care au parametri?  -> intrebat lab
# modif lungimea sirului si a n-ului

et_exit:
mov $1, %eax
xor %ebx, %ebx
int $0x80


/*



*/