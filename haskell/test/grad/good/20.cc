// Macros to shut up the C++ warnings
#define printInt(x)
#define printDouble(x)
#define printString(x)
#define readInt() 0
#define readDouble() 0
#define readString() 0

#include <string>
using std::string;

int main()
{
    string x = readInt();
    printString(x + "\n");
    x = readDouble();
    printString(x + "\n");
    x = readString();
    printString(x + "\n");
    return readInt();
}