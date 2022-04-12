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
    x = 10;
    if (y)
    {
        double x = 100.0;
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
    int y = 24;
    double dub = shadowMePlz(x = 50,(y = 120) >= 100);
    string shadowMePlz = "consider yourself shadowed >:D\n";
    printString(shadowMePlz);
    printInt(x + y);
    {
        int x = 0;
        return x;
    }
    return 100;
}
