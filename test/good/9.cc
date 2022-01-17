// Macros to shut up the C++ warnings
#define printInt(x)
#define printDouble(x)
#define printString(x)
#define readInt() 0
#define readDouble() 0
#define readString() 0

#include <iostream>
#include <string>

using std::string;

double shadowMePlz(int x, bool y)
{
    if (y)
    {
        double x = 100.202;
        return x;
    }
    else
    {
        return 6.2352;
    }
    return 4.252;
}

int main()
{
    int x = 10;
    int y = 5;
    double dub = shadowMePlz(x = 2,y >= x);
    printInt(x + y);
    printDouble(dub);
    return 7 - (x + y);
}
