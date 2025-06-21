.globl my_ili_handler

.text
.align 4, 0x90
# Load saved RIP from trap frame
    mov    (%rsp), %rdi

    # Read first opcode byte
    movb   (%rdi), %al
    cmpb   $0x0F, %al
    jne    one_byte_opcode

    # Two-byte opcode: read second byte
    movb   1(%rdi), %al
    movzbl %al, %edi      # prepare argument for what_to_do
    call   what_to_do
    test   %rax, %rax
    je     no_patch       # if zero, go to original handler
    addq   $2, (%rsp)     # skip two-byte opcode
    jmp    done

one_byte_opcode:
    movzbl %al, %edi      # argument = first byte
    call   what_to_do
    test   %rax, %rax
    je     no_patch       # if zero, go to original
    addq   $1, (%rsp)     # skip one-byte opcode
    jmp    done

no_patch:
    # Jump into the original invalid-opcode handler
    jmp    *old_ili_handler(%rip)

done:
    iretq