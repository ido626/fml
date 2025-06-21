.globl my_ili_handler

.text
.align 4, 0x90
my_ili_handler:

	movq (%rsp), %rcx
	movq (%rcx), %rcx

  pushq %r15
	pushq %r14
	pushq %r13
	pushq %r12
	pushq %rbx
  pushq %rbp
	movq %rsp, %rcx 

  cmpb $0x0F, %cl
  jne one_byte_opcode

  movb %dh, %al
  movb %al, %dil
  call what_to_do
  cmp $0, %rax
  je no_patch
  
  movq %rax, %rdi
  movq %rbp, %rsp
	popq %rbp
	popq %rbx
	popq %r12
	popq %r13
	popq %r14
	popq %r15
  addq $2, (%rsp)
  jmp done

one_byte_opcode:
  movb %dl, %dil
  call what_to_do
  cmp $0, %rax
  je no_patch

  movq %rax, %rdi
  movq %rbp, %rsp
	popq %rbp
  popq %rbx
	popq %r12
	popq %r13
	popq %r14
	popq %r15
  addq $1, (%rsp)
  jmp done

no_patch:
  movq %rbp, %rsp
	popq %rbp
  popq %rbx
	popq %r12
	popq %r13
	popq %r14
	popq %r15
  
  jmp * old_ili_handler

done:
  iretq
