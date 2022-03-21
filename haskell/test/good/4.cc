// Macros to shut up the C++ warnings
#define printInt(x)
#define printDouble(x)
#define printString(x)
#define readInt() 0
#define readDouble() 0
#define readString() 0

int main()
{
    int sum = 0;
    int num = 0;
    int x;
    while ((x = readInt()) != 0)
    {
        sum = sum + x;
        num++;
    }
    printInt(sum / num);
}