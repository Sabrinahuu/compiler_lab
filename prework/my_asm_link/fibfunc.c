long long fib_iterative(int n){
    if (n <= 1) return n;
    long long a = 0, b = 1;
    for (int i = 2; i <= n; i++) { long long next = a + b; a = b; b = next; }
    return b;
}
