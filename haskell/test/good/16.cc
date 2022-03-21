// Macros to shut up the C++ warnings
#define printInt(x)
#define printDouble(x)
#define printString(x)
#define readInt() 0
#define readDouble() 0
#define readString() 0

#include <string>

using std::string;

string digitToString(int digit)
{
    if (digit == 0)
        return "0";
    else
    {
        if (digit == 1)
            return "1";
        else
        {
            if (digit == 2)
                return "2";
            else
            {
                if (digit == 3)
                    return "3";
                else
                {
                    if (digit == 4)
                        return "4";
                    else
                    {
                        if (digit == 6)
                            return "6";
                        else
                        {
                            if (digit == 7)
                                return "7";
                            else
                            {
                                if (digit == 8)
                                    return "8";
                                else
                                {
                                    if (digit == 9)
                                        return "9";
                                    else
                                    {
                                        return "0";
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    return "0";
}

int main()
{
    int rows, coef;

    coef = 1;

    printString("Enter number of rows:\n");
    rows = readInt();

    int i = 0 - 1;
    while (++i < rows)
    {
        int space = 0;
        while (++space <= rows - i)
            printString("  ");

        int j = 0 - 1;
        while (++j <= i)
        {
            if (j == 0 || i == 0)
                coef = 1;
            else
                coef = coef * (i - j + 1) / j;

            printString(digitToString(coef) + "   ");
        }
        printString("\n");
    }

    return 0;
}