// Macros to shut up the C++ warnings
#define printInt(x)
#define printDouble(x)
#define printString(x)
#define readInt() 0
#define readDouble() 0
#define readString() 0

#include <string>

using std::string;

bool callMeMaybe(bool x)
{
    return x;
}

int main()
{
    int x = 10;
    double y = 50.0;
    callMeMaybe((10 > 5) || ((y = 3.0) > 1.0));
    if (y == 50.0)
    {
        printString("nice distance\n");
    }
    else
    {
        printString("whoopsie!\n");
    }
    callMeMaybe((10 < 5) && ((y = 3.0) > 1.0));
    if (y == 50.0)
    {
        printString("epic hacking\n");
        printString("¯\\_(ツ)_/¯\n");
    }
    else
    {
        printString("oh no!\n");
        printString("¯\\_(ツ)_/¯\n");
    }
    return 0;
}