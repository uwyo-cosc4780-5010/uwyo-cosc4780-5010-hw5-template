// Macros to shut up the C++ warnings
#define printInt(x)
#define printDouble(x)
#define printString(x)
#define readInt() 0
#define readDouble() 0
#define readString() 0

int main()
{
    int rows, coef;

    coef = 1;

    printString("Enter number of rows:\n");
    rows = readInt();

    for(int i = 0; i < rows; i++)
    {
        for(int space = 1; space <= rows-i; space++)
            printString("  ");

        for(int j = 0; j <= i; j++)
        {
            if (j == 0 || i == 0)
                coef = 1;
            else
                coef = coef*(i-j+1)/j;

            printString(coef + "   ");
        }
        printString("\n");
    }

    return 0;
}