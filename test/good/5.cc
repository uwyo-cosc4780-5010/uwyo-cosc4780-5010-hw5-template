// Macros to shut up the C++ warnings
#define printInt(x)
#define printDouble(x)
#define printString(x)
#define readInt() 0
#define readDouble() 0
#define readString() 0

int fib(int n)
{
    int res;
    if (n <= 2)
    {
        res = 1;
    }
    else
    {
        res = fib(n-1) + fib(n-2);
    }
    return res;
}

int main()
{
    printString("Which fibonacci num? ");
    int n = readInt();
    printInt(fib(n));
    return 0;
}
