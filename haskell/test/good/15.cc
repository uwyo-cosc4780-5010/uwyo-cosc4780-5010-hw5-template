// Macros to shut up the C++ warnings
#define printInt(x)
#define printDouble(x)
#define printString(x)
#define readInt() 0
#define readDouble() 0
#define readString() 0

int main()
{
    int space, rows, i, j;

    printString("Enter number of rows:\n");
    rows = readInt();
    i = 1;
    j = 0;

    while (i <= rows)
    {
        space = 1;
        while (space <= rows - i)
        {
            printString("  ");
            ++space;
        }

        while (j++ != 2 * i - 1)
        {
            printString("* ");
        }
        printString("\n");
        j = 0;
        i++;
    }
    return 0;
}
