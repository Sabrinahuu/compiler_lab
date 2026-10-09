	.file	"fib.c"
	.text
	.globl	recursive_calls
	.bss
	.align 8
	.type	recursive_calls, @object
	.size	recursive_calls, 8
recursive_calls:
	.zero	8
	.globl	program_name
	.section	.rodata
.LC0:
	.string	"Fibonacci Comparison Program"
	.section	.data.rel.local,"aw"
	.align 8
	.type	program_name, @object
	.size	program_name, 8
program_name:
	.quad	.LC0
	.section	.rodata
.LC1:
	.string	"=== %s ===\n"
.LC2:
	.string	"Valid input range: %d ~ %d\n"
	.text
	.globl	print_program_info
	.type	print_program_info, @function
print_program_info:
.LFB0:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	program_name(%rip), %rax
	movq	%rax, %rsi
	leaq	.LC1(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	$92, %edx
	movl	$0, %esi
	leaq	.LC2(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	print_program_info, .-print_program_info
	.globl	fib_recursive
	.type	fib_recursive, @function
fib_recursive:
.LFB1:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$24, %rsp
	.cfi_offset 3, -24
	movl	%edi, -20(%rbp)
	movq	recursive_calls(%rip), %rax
	addq	$1, %rax
	movq	%rax, recursive_calls(%rip)
	cmpl	$1, -20(%rbp)
	jg	.L3
	movl	-20(%rbp), %eax
	cltq
	jmp	.L4
.L3:
	movl	-20(%rbp), %eax
	subl	$1, %eax
	movl	%eax, %edi
	call	fib_recursive
	movq	%rax, %rbx
	movl	-20(%rbp), %eax
	subl	$2, %eax
	movl	%eax, %edi
	call	fib_recursive
	addq	%rbx, %rax
.L4:
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1:
	.size	fib_recursive, .-fib_recursive
	.globl	fib_iterative
	.type	fib_iterative, @function
fib_iterative:
.LFB2:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, -36(%rbp)
	cmpl	$1, -36(%rbp)
	jg	.L6
	movl	-36(%rbp), %eax
	cltq
	jmp	.L7
.L6:
	movq	$0, -24(%rbp)
	movq	$1, -16(%rbp)
	movl	$2, -28(%rbp)
	jmp	.L8
.L9:
	movq	-24(%rbp), %rdx
	movq	-16(%rbp), %rax
	addq	%rdx, %rax
	movq	%rax, -8(%rbp)
	movq	-16(%rbp), %rax
	movq	%rax, -24(%rbp)
	movq	-8(%rbp), %rax
	movq	%rax, -16(%rbp)
	addl	$1, -28(%rbp)
.L8:
	movl	-28(%rbp), %eax
	cmpl	-36(%rbp), %eax
	jle	.L9
	movq	-16(%rbp), %rax
.L7:
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2:
	.size	fib_iterative, .-fib_iterative
	.section	.rodata
.LC3:
	.string	"Enter n: "
.LC4:
	.string	"%d"
	.align 8
.LC5:
	.string	"Invalid input. n must be between %d and %d.\n"
.LC6:
	.string	"Recursive"
.LC7:
	.string	"%s result: %lld\n"
.LC8:
	.string	"Iterative"
	.align 8
.LC9:
	.string	"Recursive function calls: %lld\n"
	.align 8
.LC10:
	.string	"The two implementations produce the same result."
	.align 8
.LC11:
	.string	"The two implementations produce different results."
	.text
	.globl	main
	.type	main, @function
main:
.LFB3:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	call	print_program_info
	leaq	.LC3(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
	leaq	-28(%rbp), %rax
	movq	%rax, %rsi
	leaq	.LC4(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_scanf@PLT
	movl	-28(%rbp), %eax
	testl	%eax, %eax
	js	.L11
	movl	-28(%rbp), %eax
	cmpl	$92, %eax
	jle	.L12
.L11:
	movl	$92, %edx
	movl	$0, %esi
	leaq	.LC5(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	$1, %eax
	jmp	.L16
.L12:
	movl	-28(%rbp), %eax
	movl	%eax, %edi
	call	fib_recursive
	movq	%rax, -24(%rbp)
	movl	-28(%rbp), %eax
	movl	%eax, %edi
	call	fib_iterative
	movq	%rax, -16(%rbp)
	movq	-24(%rbp), %rax
	movq	%rax, %rdx
	leaq	.LC6(%rip), %rax
	movq	%rax, %rsi
	leaq	.LC7(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
	movq	-16(%rbp), %rax
	movq	%rax, %rdx
	leaq	.LC8(%rip), %rax
	movq	%rax, %rsi
	leaq	.LC7(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
	movq	recursive_calls(%rip), %rax
	movq	%rax, %rsi
	leaq	.LC9(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
	movq	-24(%rbp), %rax
	cmpq	-16(%rbp), %rax
	jne	.L14
	leaq	.LC10(%rip), %rax
	movq	%rax, %rdi
	call	puts@PLT
	jmp	.L15
.L14:
	leaq	.LC11(%rip), %rax
	movq	%rax, %rdi
	call	puts@PLT
.L15:
	movl	$0, %eax
.L16:
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L17
	call	__stack_chk_fail@PLT
.L17:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 11.4.0-1ubuntu1~22.04.3) 11.4.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:
