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

double shadowMePlz()
{
    int x = 10;
    {
        double x = 100.0;
        return x;
    }
    return 4.252;
}

int main()
{
    string shadowMePlz = "consider yourself shadowed >:D\n";
    printString(shadowMePlz);
    {
        int x = 0;
        return x;
    }
    return 100;
}
