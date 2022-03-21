// Macros to shut up the C++ warnings
#define printInt(x)
#define printDouble(x)
#define printString(x)
#define readInt() 0
#define readDouble() 0
#define readString() 0

int runIt(int start)
{
    return go1(start);
}

int main()
{
    int start = readInt();
    runIt(start);
    return 0;
}

int go1(int x)
{
    printString("go1: ");
    printInt(x);
    if (x < 0)
        return x;
    else
        return go2(x - 2);
    return 0;
}

int go2(int x)
{
    printString("go2: ");
    printInt(x);
    if (x < 0)
        return x;
    else
        return go1(x + 1);
    return 0;
}