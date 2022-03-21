// Macros to shut up the C++ warnings
#define printInt(x)
#define printDouble(x)
#define printString(x)
#define readInt() 0
#define readDouble() 0
#define readString() 0

int main()
{
    printString("Enter a positive integer:\n");
    int n = readInt();
    if (n <= 0)
    {
        printString("I said *positive*...");
        return 1;
    } else {}

    for (int i = 1; i <= 10; i++)
    {
        printString(n + " * " + i + " = " + n * i + "\n");
    }
    return 0;
}