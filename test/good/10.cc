// Macros to shut up the C++ warnings
#define printInt(x)
#define printDouble(x)
#define printString(x)
#define readInt() 0
#define readDouble() 0
#define readString() 0

int factr(int n)
{
    if (n < 2)
        return 1;
    else
        return (n * factr(n - 1));
    return 0;
}

int main()
{
    int i = factr(8);
    printInt(i);
    return 0;
}
