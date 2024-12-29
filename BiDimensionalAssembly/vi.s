.data
    # =============================== BIDIMENSIONAL!!!! ===================================================================
    #  modif mai tarziu------------------------  ATENTIE ATENTIE ATENTIE ATENTIE ATENTIE
    a: .space 4194304
    n: .long 1048576
    latura: .long 1024
    # -----------------------------------------
    q: .long 0
    task: .long 0
    ct_operatii: .long 0
    # constane
    test: .asciz "--->  %ld\n"
    af_sir: .asciz "%ld  "
    
    af_fisier_stanga: .asciz "%d: ("
    af_fisier_mijloc: .asciz ", "
    af_fisier_dreapta: .asciz ")\n"

    af_get_stanga: .asciz "("
    af_get_mijloc: .asciz ", "
    af_get_dreapta: .asciz ")\n"

    af_conc: .asciz "(%d, %d)\n"

    af_get: .asciz "(%d, %d)\n"
    c_long: .asciz "%ld"
    c_string: .asciz "%s"
    end_of_line: .asciz "\n"
    af_linie_coloana: .asciz "(%d, %d)"

    # var ocazionale
    path_concrete: .asciz ""
    desc: .long 0
    file_desc: .long 0
    desc_size: .long 0
    start: .long 0
    a_st: .long 0
    a_dr: .long 0
    a_size: .long 0
    a_desc: .long 0
    lg: .long 0
    desc_gasit: .long 0
    rand: .long 0
    # fstat
    f_stat: .space 128 
.text

citire_string:
    pushl 4(%esp)
    pushl $c_string
    call scanf
    popl %eax
    popl %eax
ret


apel_flush:
    pushl $0
    call fflush
    popl %eax
ret

afisare_string:
    pushl 4(%esp)
    pushl $c_string
    call printf
    popl %eax
    popl %eax
    call apel_flush
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




final_de_linie:                 # GRIJA SA NU APELEZ ALT CALL DUPA
    movl 4(%esp),%eax  # poz pe care o vf
    xorl %edx,%edx

    inc %eax
    div latura

    cmp $0,%edx
    movl $1,%eax
    
    je exit_final_de_linie 
    movl $0,%eax

#  eax = 0 ->nu e fin de linie
#  eax = 1 ->   e fin de linie
    exit_final_de_linie:
ret

conversie_afisare_linie_coloana:
    movl 4(%esp),%eax  # poz pe care o modif
    xorl %edx,%edx

    div latura

    pushl %edx
    pushl %eax
    pushl $af_linie_coloana
    call printf
    popl %eax
    popl %eax
    popl %eax
    call apel_flush
   
ret



afisare_sir:
    pushl %ebx
    # ebx - i   0 n
    xorl %ebx,%ebx
    afisare_sir_inceput:
        pushl a(,%ebx,4)
        pushl $af_sir
        call printf
        popl %eax
        popl %eax
        call apel_flush

# \n daca e fin de linie
        pushl %ebx
        call final_de_linie
        popl %edx
        cmp $0,%eax        
        je afisare_sir_skip_rand_nou
        call rand_nou
        afisare_sir_skip_rand_nou:

        inc %ebx
        movl n,%eax
        cmp %eax,%ebx
        jne afisare_sir_inceput
    popl %ebx
ret

rand_nou:
    pushl $end_of_line
    call printf
    popl %eax
    call apel_flush
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

afisare_element:
        push desc
        push $af_fisier_stanga
        call printf
        popl %eax
        popl %eax
        call apel_flush

        push a_st
        call conversie_afisare_linie_coloana         
        popl %eax
        call apel_flush

        push $af_fisier_mijloc
        call printf
        popl %eax
        call apel_flush

        push a_dr
        call conversie_afisare_linie_coloana
        popl %eax         
        call apel_flush
    
        push $af_fisier_dreapta
        call printf
        popl %eax
        call apel_flush
ret

Afisare_fisiere:
    pushl %ebx

    xorl %ebx,%ebx

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


        call afisare_element


        skip_afisare_fisiere_inceput: 

        inc %ebx
        cmp n,%ebx
        jne afisare_fisiere_inceput
        
    popl %ebx

ret 

Afisare_Get:

        push $af_get_stanga
        call printf
        popl %eax
        call apel_flush

        push a_st
        call conversie_afisare_linie_coloana         
        popl %eax
        call apel_flush

        push $af_get_mijloc
        call printf
        popl %eax
        call apel_flush

        push a_dr
        call conversie_afisare_linie_coloana
        popl %eax         
        call apel_flush
    
        push $af_get_dreapta
        call printf
        popl %eax
        call apel_flush
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


    call Afisare_Get

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

    # final de linie - reset lg
        pushl %ebx
        call final_de_linie
        popl %ecx
        cmp $0,%eax
        je add_element_skip_reset_final_linie
            xorl %eax,%eax
            movl %eax,lg
        add_element_skip_reset_final_linie:


    inc %ebx
    cmp n,%ebx
    jne Add_parcurgere

    Add_gata:

    call afisare_element

    popl %ebx
ret

F_Add:
    pushl %ebx

    pushl $ct_operatii
    call citire
    popl %eax

    xorl %ebx,%ebx

    Parcurgere_adduri:

    pushl $desc
    call citire
    popl %eax

    pushl $desc_size
    call citire
    popl %eax

    call Add_Element

    inc %ebx
    cmp ct_operatii,%ebx
    jne Parcurgere_adduri

    popl %ebx
ret

tst_def:
    pushl a_desc
    call testare
    popl %eax
    pushl a_st
    call testare
    popl %eax
    pushl a_size
    call testare
    popl %eax
    call rand_nou
ret

F_Defragmentation:
# ebx pt parcurgere tot
# edi pt parcurs 0

    pushl %edi
    pushl %ebx

    xorl %ebx,%ebx
    xorl %edi,%edi

    xorl %eax,%eax
    movl %eax,a_st        
    movl %eax,a_desc
    movl %eax,a_size

    Defragmentation_parcurgere:

        # am gasit fisier
        movl $0,%eax
        cmp a(,%ebx,4),%eax
        je Defragmentation_parcurgere_skip
            # obtinere:     a_st          a_size 
            movl %ebx,a_st
            movl a(,%ebx,4),%eax
            movl %eax,a_desc
            # obtinere:     a_desc
            movl $1,a_size

            Defragmentation_parcurgere_acelasi_element:
                xorl %eax,%eax
                movl %eax,a(,%ebx,4)
                inc a_size
                inc %ebx
            movl a(,%ebx,4),%eax
            cmp a_desc,%eax
            je Defragmentation_parcurgere_acelasi_element
            dec a_size
            dec %ebx


            xorl %edx,%edx
            movl %edi,%eax
            div latura
            movl %eax,rand

            xorl %edx,%edx
            movl %edi,%eax
            add a_size,%eax
            dec %eax
            div latura

            cmp rand,%eax 



            jne Defragmentation_linii_diferite
            # intra pe aceiasi linie
                Defragmentation_adaugare_aceiasi_linie:

                    
                    movl a_desc,%eax
                    movl %eax,a(,%edi,4)                  

                    inc %edi
                    dec a_size

                    xorl %eax,%eax
                    cmp a_size,%eax
                jne Defragmentation_adaugare_aceiasi_linie
            jmp Defragmentation_parcurgere_skip
            # nu intra pe aceiasi linie
            Defragmentation_linii_diferite:
                xorl %edx,%edx
                movl %edi,%eax
                div latura
                inc %eax

                xorl %edx,%edx
                mul latura
                movl %eax,%edi
                jmp Defragmentation_adaugare_aceiasi_linie

        Defragmentation_parcurgere_skip:
    inc %ebx
    cmp n,%ebx
    jne Defragmentation_parcurgere


    call Afisare_fisiere        
    popl %ebx    
    popl %edi                           #   ordinea buna? :)
ret

F_Concrete:
    pushl %ebx

    pushl $path_concrete
    call citire_string
    popl %eax

    # open
    movl $5,%eax
    movl $path_concrete,%ebx
    movl $0,%ecx
    xorl %edx, %edx
    int $0x80

et_adter_the_open:
    movl %eax,desc
    movl %eax,file_desc

    
    movl $108,%eax
    movl desc,%ebx
    movl $f_stat,%ecx 
    int $0x80

    movl 20(%ecx),%eax 
    movl %eax,desc_size             
    # close 
    movl $6,%eax
    movl file_desc,%ebx
    int $0x80

/*
*/
    # modif val desc (mod) + apel call
    movl desc,%eax
    xorl %edx,%edx
    movl $256,%ecx
    div %ecx
    movl %edx,desc
    inc desc 
    
    # conversie in kb
    xorl %edx,%edx
    movl desc_size,%eax
    movl $1024,%ebx
    div %ebx
    movl %eax,desc_size

  
  
    pushl desc_size
    pushl desc
    pushl $af_conc
    call printf
    popl %eax
    popl %eax
    popl %eax
    call apel_flush

# /home/jeff/Downloads/17kb_file.txt

   
#                  Eliminare elemente repetate
    xorl %ebx,%ebx
    concrete_verificare_repetare:
        movl a(,%ebx,4),%eax
        cmp desc,%eax
        je concrete_skip
    inc %ebx
    cmp n,%ebx
    jne concrete_verificare_repetare

    call Add_Element
    concrete_skip:                  # afisare (0,0)(0,0)(0,0) in caz de skip ?? ?

    popl %ebx
ret

.global main

main:

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
        # CONCRETE -------------------------------- 5
        movl $5,%eax
        cmp task,%eax
        jne skip_conc
        call F_Concrete
        skip_conc:

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

#                       un fisier bidimensional are nev de doua spatii ?
