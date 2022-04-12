// Macros to shut up the C++ warnings
#define printInt(x)
#define printDouble(x)
#define printString(x)
#define readInt() 0
#define readDouble() 0
#define readString() 0

int main()
{
    printString("Give me a number: ");
    int x = readInt();
    printString("Psh. You know what's funnier than ");
    printInt(x);
    printString("?\n");
    printInt(x+1);
}