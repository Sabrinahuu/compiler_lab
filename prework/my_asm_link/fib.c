#include <stdio.h>

/* ---------- 宏定义 ---------- */

/* Fibonacci 数允许的最大输入 */
#define MAX_N 92

/* Fibonacci 数允许的最小输入 */
#define MIN_N 0

/* 函数式宏：计算两个数之和 */
#define ADD(x, y) ((x) + (y))

/* 输出结果的宏 */
#define PRINT_RESULT(name, value) \
    printf("%s result: %lld\n", name, value)


/* ---------- 全局变量与常量 ---------- */

/* 全局变量：记录递归函数的调用次数 */
long long recursive_calls = 0;

/* 全局字符串常量：程序名称 */
const char *program_name = "Fibonacci Comparison Program";


/* ---------- 函数声明 ---------- */

/* 递归方式计算 Fibonacci 数 */
long long fib_recursive(int n);

/* 迭代方式计算 Fibonacci 数 */
long long fib_iterative(int n);

/* 输出程序基本信息 */
void print_program_info(void);


/* ---------- 函数定义 ---------- */

/* 输出程序名称以及允许的输入范围 */
void print_program_info(void)
{
    printf("=== %s ===\n", program_name);
    printf("Valid input range: %d ~ %d\n", MIN_N, MAX_N);
}


/* 递归实现 Fibonacci 数计算 */
long long fib_recursive(int n)
{
    /* 每调用一次递归函数，计数器加 1 */
    recursive_calls++;

    /* 递归终止条件 */
    if (n <= 1)
        return n;

    /* 递归计算前两个 Fibonacci 数之和 */
    return ADD(
        fib_recursive(n - 1),
        fib_recursive(n - 2)
    );
}


/* 迭代实现 Fibonacci 数计算 */
long long fib_iterative(int n)
{
    /* 特殊情况直接返回 */
    if (n <= 1)
        return n;

    /* 初始化前两个 Fibonacci 数 */
    long long a = 0;
    long long b = 1;

    /* 通过循环逐步计算后续 Fibonacci 数 */
    for (int i = 2; i <= n; i++) {
        long long next = ADD(a, b);
        a = b;
        b = next;
    }

    return b;
}


/* ---------- 主函数 ---------- */

int main(void)
{
    int n;

    /* 输出程序基本信息 */
    print_program_info();

    /* 条件编译：仅在定义 DEBUG 宏时保留该代码 */
#ifdef DEBUG
    printf("Debug mode enabled.\n");
#endif

    /* 获取用户输入 */
    printf("Enter n: ");
    scanf("%d", &n);

    /* 检查输入是否合法 */
    if (n < MIN_N || n > MAX_N) {
        printf("Invalid input. n must be between %d and %d.\n",
               MIN_N, MAX_N);
        return 1;
    }

    /* 分别使用递归和迭代方式计算 Fibonacci 数 */
    long long result_recursive = fib_recursive(n);
    long long result_iterative = fib_iterative(n);

    /* 输出两种实现得到的结果 */
    PRINT_RESULT("Recursive", result_recursive);
    PRINT_RESULT("Iterative", result_iterative);

    /* 输出递归函数的调用次数 */
    printf("Recursive function calls: %lld\n", recursive_calls);

    /* 检查两种实现得到的结果是否一致 */
    if (result_recursive == result_iterative)
        printf("The two implementations produce the same result.\n");
    else
        printf("The two implementations produce different results.\n");

    return 0;
}