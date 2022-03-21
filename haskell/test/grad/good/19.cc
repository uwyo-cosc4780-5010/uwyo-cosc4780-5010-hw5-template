// Macros to shut up the C++ warnings
#define printInt(x)
#define printDouble(x)
#define printString(x)
#define readInt() 0
#define readDouble() 0
#define readString() 0

int modulo(int num, int div) {
    return num - div * (num / div);
}

int main()
{
    int n1, n2, hcf;
    printString("Enter two numbers:\n");
    n1 = readInt();
    n2 = readInt();

    // swapping variables n1 and n2 if n2 is greater than n1.
    if (n2 > n1)
    {
        int temp = n2;
        n2 = n1;
        n1 = temp;
    } else {}

    for (int i = 1; i <= n2; ++i)
    {
        if (modulo(n1, i) == 0 && modulo(n2, i) == 0)
        {
            hcf = i;
        } else {}
    }

    printString("HCF = " + hcf + "\n");

    return 0;
}