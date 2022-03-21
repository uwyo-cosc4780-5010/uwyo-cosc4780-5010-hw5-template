// Macros to shut up the C++ warnings
#define printInt(x)
#define printDouble(x)
#define printString(x)
#define readInt() 0
#define readDouble() 0
#define readString() 0

int modulo(int num, int div) {
    return num - div * (num / div);
}

int main()
{
    int n, reversed, remainder, original;
    reversed = 0;
    printString("Enter an integer: ");
    n = readInt();
    original = n;

    while (n != 0)
    {
        remainder = modulo(n, 10);
        reversed = reversed * 10 + remainder;
        n = n / 10;
    }

    if (original == reversed)
        printString("Palindrome! Poggers!\n");
    else
        printString("Is not a palindrome\n");

    return 0;
}