# ili_handler.asm
    .globl my_ili_handler

    .text
    .align 4, 0x90
my_ili_handler:
    mov    (%rsp), %rdi

    movb   (%rdi), %al
    cmpb   $0x0F, %al
    jne    one_byte_opcode

    movb   1(%rdi), %al
    movzbl %al, %edi
    call   what_to_do
    test   %rax, %rax
    je     no_patch
    addq   $2, (%rsp)
    jmp    done

one_byte_opcode:
    movzbl %al, %edi
    call   what_to_do
    test   %rax, %rax
    je     no_patch
    addq   $1, (%rsp)
    jmp    done

no_patch:
    jmp    *old_ili_handler(%rip)

done:
    iretq
