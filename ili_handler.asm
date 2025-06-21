.globl my_ili_handler
.text
.align 4, 0x90
my_ili_handler:
    # 1) Load pointer-to-RIP from the stack, then load the RIP itself:
    movq    (%rsp),  %rdx       # %rdx = address-of-[RIP] (לפי השערתך)
    movq    (%rdx),  %rdx       # %rdx = actual RIP

    # 2) שמירת כל הרגיסטרים הקלצים
    pushq   %r15
    pushq   %r14
    pushq   %r13
    pushq   %r12
    pushq   %rbx
    pushq   %rbp
    movq    %rsp,   %rbp       # frame pointer

    # 3) בודקים אם אופקוד דו-בתי או חד-ביתי
    movb    (%rdx), %al
    cmpb    $0x0F, %al
    jne     one_byte_opcode

    #–––– 2-byte opcode path –––––––––
    movb    1(%rdx),  %al
    movzbl  %al,     %edi
    call    what_to_do
    test    %rax,    %rax
    je      no_patch

    # 4) שחזור סטאק וכתובת חזרה – במקרה של תיקון
    movq    %rbp, %rsp
    popq    %rbp
    popq    %rbx
    popq    %r12
    popq    %r13
    popq    %r14
    popq    %r15

    # 5) הוספת 2 ל־RIP שמאוחסן בכתובת (%rsp)
    addq    $2, (%rsp)
    jmp     done

one_byte_opcode:
    #–––– 1-byte opcode path –––––––––
    movzbl  (%rdx), %edi
    call    what_to_do
    test    %rax,   %rax
    je      no_patch

    movq    %rbp, %rsp
    popq    %rbp
    popq    %rbx
    popq    %r12
    popq    %r13
    popq    %r14
    popq    %r15

    addq    $1, (%rsp)
    jmp     done

no_patch:
    #–––– ללא תיקון, דילוג ל־old handler –––––––––
    movq    %rbp, %rsp
    popq    %rbp
    popq    %rbx
    popq    %r12
    popq    %r13
    popq    %r14
    popq    %r15
    jmp    *old_ili_handler

done:
    iretq
