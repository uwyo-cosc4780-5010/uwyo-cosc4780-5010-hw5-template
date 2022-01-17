// Macros to shut up the C++ warnings
#define printInt(x)
#define printDouble(x)
#define printString(x)
#define readInt() 0
#define readDouble() 0
#define readString() 0

int main()
{
    int i = readInt();

    printInt(i);
    printInt(i++);
    printInt(i);
    printInt(++i);
    printInt(i);
}
