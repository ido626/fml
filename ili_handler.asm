.globl my_ili_handler

.text
.align 4, 0x90
my_ili_handler:
  ####### Some smart student's code here #######
    movq    (%rsp), %rdx
    movq (%rdx), %rdx

    pushq   %r15
    pushq   %r14
    pushq   %r13
    pushq   %r12
    pushq   %rbx
    pushq   %rbp
    movq    %rsp, %rbp 

    movb   (%rdx), %al
    cmpb   $0x0F, %al
    jne    one_byte_opcode

    movb   1(%rdx), %al
    movzbl %al, %edi
    call   what_to_do
    test   %rax, %rax
    je     no_patch


    movq    %rbp, %rsp
    popq    %rbp
    popq    %rbx
    popq    %r12
    popq    %r13
    popq    %r14
    popq    %r15
    addq   $2, (%rsp)
    jmp    done

one_byte_opcode:
    movzbl (%rdx), %edi
    call   what_to_do
    test   %rax, %rax
    je     no_patch

    movq    %rbp, %rsp
    popq    %rbp
    popq    %rbx
    popq    %r12
    popq    %r13
    popq    %r14
    popq    %r15
    addq   $1, (%rsp)
    jmp    done

no_patch:
    movq    %rbp, %rsp
    popq    %rbp
    popq    %rbx
    popq    %r12
    popq    %r13
    popq    %r14
    popq    %r15
    jmp    * old_ili_handler

done:
  iretq
