.arch armv8-a

// ============================================================
// Global constants and variables
// ============================================================

.section .rodata
.align 2

N:
    .word 6

LIMIT:
    .word 100


.data
.align 2

bias:
    .word 3


// ============================================================
// Code section
// ============================================================

.text
.align 2

.global transform
.type transform, %function

transform:
    // Allocate 16 bytes of stack space
    // x is stored at [sp, 12]
    // y is stored at [sp, 8]
    sub sp, sp, #16

    // Save parameter x
    // The first int argument is passed in w0
    str w0, [sp, 12]


    // --------------------------------------------------------
    // if (x % 2 == 0)
    // --------------------------------------------------------

    ldr w0, [sp, 12]

    mov w1, #2

    // quotient = x / 2
    sdiv w2, w0, w1

    // remainder = x - quotient * 2
    msub w2, w2, w1, w0

    cmp w2, #0

    b.ne .Ltransform_else


// ------------------------------------------------------------
// Even:
// y = x * 2 + bias
// ------------------------------------------------------------

.Ltransform_then:
    ldr w0, [sp, 12]

    // x * 2
    lsl w0, w0, #1

    // Load global variable bias
    adrp x1, bias
    add x1, x1, :lo12:bias
    ldr w1, [x1]

    // x * 2 + bias
    add w0, w0, w1

    // y = result
    str w0, [sp, 8]

    b .Ltransform_end


// ------------------------------------------------------------
// Odd:
// y = x / 2 - bias
// ------------------------------------------------------------

.Ltransform_else:
    ldr w0, [sp, 12]

    mov w1, #2

    // x / 2
    sdiv w0, w0, w1

    // Load global variable bias
    adrp x1, bias
    add x1, x1, :lo12:bias
    ldr w1, [x1]

    // x / 2 - bias
    sub w0, w0, w1

    // y = result
    str w0, [sp, 8]


// ------------------------------------------------------------
// return y
// ------------------------------------------------------------

.Ltransform_end:
    ldr w0, [sp, 8]

    // Release stack space
    add sp, sp, #16

    ret

.size transform, .-transform

// ============================================================
// int process(int a[], int n)
// x0 = address of array a
// w1 = n
// return value -> w0
// ============================================================

.text
.align 2
.global process
.type process, %function

process:
    // 建立栈帧，同时保存 fp(x29) 和 lr(x30)
    stp x29, x30, [sp, -64]!
    mov x29, sp

    // Stack layout:
    // [sp, 16] : a       (8 bytes)
    // [sp, 24] : n       (4 bytes)
    // [sp, 28] : i       (4 bytes)
    // [sp, 32] : sum     (4 bytes)
    // [sp, 36] : x       (4 bytes)
    // [sp, 40] : value   (4 bytes)

    str x0, [sp, 16]
    str w1, [sp, 24]

    // int i = 0;
    mov w2, #0
    str w2, [sp, 28]

    // int sum = 0;
    mov w2, #0
    str w2, [sp, 32]


// ============================================================
// while (i < n)
// ============================================================

.Lprocess_while_cond:
    ldr w2, [sp, 28]      // i
    ldr w3, [sp, 24]      // n

    cmp w2, w3
    b.ge .Lprocess_while_end


// ============================================================
// x = a[i]
// ============================================================

.Lprocess_while_body:
    ldr x2, [sp, 16]      // address of a
    ldr w3, [sp, 28]      // i

    // a[i] address = a + i * 4
    ldr w4, [x2, w3, sxtw #2]

    // x = a[i]
    str w4, [sp, 36]


// ============================================================
// i = i + 1
// ============================================================

    ldr w2, [sp, 28]
    add w2, w2, #1
    str w2, [sp, 28]


// ============================================================
// if (!(x >= 0))
//     continue;
// Equivalent to: if (x < 0)
// ============================================================

    ldr w2, [sp, 36]

    cmp w2, #0
    b.lt .Lprocess_continue


// ============================================================
// if (x > LIMIT)
//     break;
// ============================================================

    ldr w2, [sp, 36]

    adrp x3, LIMIT
    add  x3, x3, :lo12:LIMIT
    ldr  w3, [x3]

    cmp w2, w3
    b.gt .Lprocess_while_end


// ============================================================
// if ((x >= 10 && x <= 50) || x == 0)
// ============================================================

    // First: x >= 10
    ldr w2, [sp, 36]
    cmp w2, #10

    // 如果 x < 10，则不必再判断 x <= 50
    // 直接检查 x == 0
    b.lt .Lprocess_check_zero

    // x >= 10，现在检查 x <= 50
    cmp w2, #50

    // 10 <= x <= 50
    b.le .Lprocess_transform

    // x > 50，继续检查 x == 0
    b .Lprocess_check_zero


// ============================================================
// Check: x == 0
// ============================================================

.Lprocess_check_zero:
    ldr w2, [sp, 36]

    cmp w2, #0
    b.eq .Lprocess_transform

    b .Lprocess_normal


// ============================================================
// value = transform(x)
// ============================================================

.Lprocess_transform:
    // 第一个 int 参数通过 w0 传递
    ldr w0, [sp, 36]

    bl transform

    // transform 返回值在 w0
    str w0, [sp, 40]

    b .Lprocess_add_sum


// ============================================================
// else:
//     if (x != LIMIT)
//         value = x - 1;
//     else
//         value = x;
// ============================================================

.Lprocess_normal:
    ldr w2, [sp, 36]

    adrp x3, LIMIT
    add  x3, x3, :lo12:LIMIT
    ldr  w3, [x3]

    cmp w2, w3

    b.eq .Lprocess_keep_value


// value = x - 1

.Lprocess_sub_one:
    ldr w2, [sp, 36]

    sub w2, w2, #1

    str w2, [sp, 40]

    b .Lprocess_add_sum


// value = x

.Lprocess_keep_value:
    ldr w2, [sp, 36]

    str w2, [sp, 40]

    b .Lprocess_add_sum


// ============================================================
// sum = sum + value
// ============================================================

.Lprocess_add_sum:
    ldr w2, [sp, 32]      // sum
    ldr w3, [sp, 40]      // value

    add w2, w2, w3

    str w2, [sp, 32]


// ============================================================
// continue
// ============================================================

.Lprocess_continue:
    b .Lprocess_while_cond


// ============================================================
// end of while
// return sum
// ============================================================

.Lprocess_while_end:
    ldr w0, [sp, 32]

    // 恢复 fp 和 lr，同时释放 64 字节栈空间
    ldp x29, x30, [sp], 64

    ret

.size process, .-process

// ============================================================
// int main()
// ============================================================

.text
.align 2
.global main
.type main, %function

main:
    // 建立 64 字节栈帧，并保存 fp(x29) 和 lr(x30)
    stp x29, x30, [sp, -64]!
    mov x29, sp

    // Stack layout:
    // [sp, 16] ~ [sp, 39] : data[6]，共 24 字节
    // [sp, 40]            : i
    // [sp, 44]            : result

    // int i = 0;
    mov w0, #0
    str w0, [sp, 40]


// ============================================================
// while (i < N)
// ============================================================

.Lmain_input_cond:
    ldr w0, [sp, 40]      // i

    adrp x1, N
    add  x1, x1, :lo12:N
    ldr  w1, [x1]         // N = 6

    cmp w0, w1
    b.ge .Lmain_input_end


// ============================================================
// data[i] = getint()
// ============================================================

.Lmain_input_body:
    // SysY runtime: int getint()
    bl getint

    // getint 返回值位于 w0

    // data 数组首地址
    add x2, sp, #16

    // 当前下标 i
    ldr w3, [sp, 40]

    // data[i] = w0
    // 每个 int 占 4 字节
    str w0, [x2, w3, sxtw #2]


// ============================================================
// i = i + 1
// ============================================================

    ldr w3, [sp, 40]
    add w3, w3, #1
    str w3, [sp, 40]

    b .Lmain_input_cond


// ============================================================
// result = process(data, N)
// ============================================================

.Lmain_input_end:
    // 第一个参数：数组首地址 data
    add x0, sp, #16

    // 第二个参数：N
    adrp x1, N
    add  x1, x1, :lo12:N
    ldr  w1, [x1]

    bl process

    // process 返回值位于 w0
    str w0, [sp, 44]


// ============================================================
// putint(result)
// ============================================================

    ldr w0, [sp, 44]
    bl putint


// ============================================================
// putch(10)
// 输出换行符
// ============================================================

    mov w0, #10
    bl putch


// ============================================================
// return 0
// ============================================================

    mov w0, #0

    // 恢复 fp、lr，并释放栈空间
    ldp x29, x30, [sp], 64

    ret

.size main, .-main