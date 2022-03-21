// Macros to shut up the C++ warnings
#define printInt(x)
#define printDouble(x)
#define printString(x)
#define readInt() 0
#define readDouble() 0
#define readString() 0

int main()
{
    for (int i = 0; readInt() != 0.0; i++)
    {
        printString(i + "\n");
    }
}