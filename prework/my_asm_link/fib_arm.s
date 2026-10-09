	.arch armv8-a
	.file	"fib.c"
	.text
	.global	recursive_calls
	.bss
	.align	3
	.type	recursive_calls, %object
	.size	recursive_calls, 8
recursive_calls:
	.zero	8
	.global	program_name
	.section	.rodata
	.align	3
.LC0:
	.string	"Fibonacci Comparison Program"
	.section	.data.rel.local,"aw"
	.align	3
	.type	program_name, %object
	.size	program_name, 8
program_name:
	.xword	.LC0
	.section	.rodata
	.align	3
.LC1:
	.string	"=== %s ===\n"
	.align	3
.LC2:
	.string	"Valid input range: %d ~ %d\n"
	.text
	.align	2
	.global	print_program_info
	.type	print_program_info, %function
print_program_info:
.LFB0:
	.cfi_startproc
	stp	x29, x30, [sp, -16]!
	.cfi_def_cfa_offset 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	mov	x29, sp
	adrp	x0, program_name
	add	x0, x0, :lo12:program_name
	ldr	x0, [x0]
	mov	x1, x0
	adrp	x0, .LC1
	add	x0, x0, :lo12:.LC1
	bl	printf
	mov	w2, 92
	mov	w1, 0
	adrp	x0, .LC2
	add	x0, x0, :lo12:.LC2
	bl	printf
	nop
	ldp	x29, x30, [sp], 16
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE0:
	.size	print_program_info, .-print_program_info
	.align	2
	.global	fib_recursive
	.type	fib_recursive, %function
fib_recursive:
.LFB1:
	.cfi_startproc
	stp	x29, x30, [sp, -48]!
	.cfi_def_cfa_offset 48
	.cfi_offset 29, -48
	.cfi_offset 30, -40
	mov	x29, sp
	str	x19, [sp, 16]
	.cfi_offset 19, -32
	str	w0, [sp, 44]
	adrp	x0, recursive_calls
	add	x0, x0, :lo12:recursive_calls
	ldr	x0, [x0]
	add	x1, x0, 1
	adrp	x0, recursive_calls
	add	x0, x0, :lo12:recursive_calls
	str	x1, [x0]
	ldr	w0, [sp, 44]
	cmp	w0, 1
	bgt	.L3
	ldrsw	x0, [sp, 44]
	b	.L4
.L3:
	ldr	w0, [sp, 44]
	sub	w0, w0, #1
	bl	fib_recursive
	mov	x19, x0
	ldr	w0, [sp, 44]
	sub	w0, w0, #2
	bl	fib_recursive
	add	x0, x19, x0
.L4:
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 48
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE1:
	.size	fib_recursive, .-fib_recursive
	.align	2
	.global	fib_iterative
	.type	fib_iterative, %function
fib_iterative:
.LFB2:
	.cfi_startproc
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	str	w0, [sp, 12]
	ldr	w0, [sp, 12]
	cmp	w0, 1
	bgt	.L6
	ldrsw	x0, [sp, 12]
	b	.L7
.L6:
	str	xzr, [sp, 24]
	mov	x0, 1
	str	x0, [sp, 32]
	mov	w0, 2
	str	w0, [sp, 20]
	b	.L8
.L9:
	ldr	x1, [sp, 24]
	ldr	x0, [sp, 32]
	add	x0, x1, x0
	str	x0, [sp, 40]
	ldr	x0, [sp, 32]
	str	x0, [sp, 24]
	ldr	x0, [sp, 40]
	str	x0, [sp, 32]
	ldr	w0, [sp, 20]
	add	w0, w0, 1
	str	w0, [sp, 20]
.L8:
	ldr	w1, [sp, 20]
	ldr	w0, [sp, 12]
	cmp	w1, w0
	ble	.L9
	ldr	x0, [sp, 32]
.L7:
	add	sp, sp, 48
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE2:
	.size	fib_iterative, .-fib_iterative
	.section	.rodata
	.align	3
.LC3:
	.string	"Enter n: "
	.align	3
.LC4:
	.string	"%d"
	.align	3
.LC5:
	.string	"Invalid input. n must be between %d and %d.\n"
	.align	3
.LC6:
	.string	"Recursive"
	.align	3
.LC7:
	.string	"%s result: %lld\n"
	.align	3
.LC8:
	.string	"Iterative"
	.align	3
.LC9:
	.string	"Recursive function calls: %lld\n"
	.align	3
.LC10:
	.string	"The two implementations produce the same result."
	.align	3
.LC11:
	.string	"The two implementations produce different results."
	.text
	.align	2
	.global	main
	.type	main, %function
main:
.LFB3:
	.cfi_startproc
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	stp	x29, x30, [sp, 32]
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	add	x29, sp, 32
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, #:got_lo12:__stack_chk_guard]
	ldr	x1, [x0]
	str	x1, [sp, 24]
	mov	x1, 0
	bl	print_program_info
	adrp	x0, .LC3
	add	x0, x0, :lo12:.LC3
	bl	printf
	add	x0, sp, 4
	mov	x1, x0
	adrp	x0, .LC4
	add	x0, x0, :lo12:.LC4
	bl	__isoc99_scanf
	ldr	w0, [sp, 4]
	cmp	w0, 0
	blt	.L11
	ldr	w0, [sp, 4]
	cmp	w0, 92
	ble	.L12
.L11:
	mov	w2, 92
	mov	w1, 0
	adrp	x0, .LC5
	add	x0, x0, :lo12:.LC5
	bl	printf
	mov	w0, 1
	b	.L16
.L12:
	ldr	w0, [sp, 4]
	bl	fib_recursive
	str	x0, [sp, 8]
	ldr	w0, [sp, 4]
	bl	fib_iterative
	str	x0, [sp, 16]
	ldr	x2, [sp, 8]
	adrp	x0, .LC6
	add	x1, x0, :lo12:.LC6
	adrp	x0, .LC7
	add	x0, x0, :lo12:.LC7
	bl	printf
	ldr	x2, [sp, 16]
	adrp	x0, .LC8
	add	x1, x0, :lo12:.LC8
	adrp	x0, .LC7
	add	x0, x0, :lo12:.LC7
	bl	printf
	adrp	x0, recursive_calls
	add	x0, x0, :lo12:recursive_calls
	ldr	x0, [x0]
	mov	x1, x0
	adrp	x0, .LC9
	add	x0, x0, :lo12:.LC9
	bl	printf
	ldr	x1, [sp, 8]
	ldr	x0, [sp, 16]
	cmp	x1, x0
	bne	.L14
	adrp	x0, .LC10
	add	x0, x0, :lo12:.LC10
	bl	puts
	b	.L15
.L14:
	adrp	x0, .LC11
	add	x0, x0, :lo12:.LC11
	bl	puts
.L15:
	mov	w0, 0
.L16:
	mov	w1, w0
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, #:got_lo12:__stack_chk_guard]
	ldr	x3, [sp, 24]
	ldr	x2, [x0]
	subs	x3, x3, x2
	mov	x2, 0
	beq	.L17
	bl	__stack_chk_fail
.L17:
	mov	w0, w1
	ldp	x29, x30, [sp, 32]
	add	sp, sp, 48
	.cfi_restore 29
	.cfi_restore 30
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE3:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 11.4.0-1ubuntu1~22.04.3) 11.4.0"
	.section	.note.GNU-stack,"",@progbits
