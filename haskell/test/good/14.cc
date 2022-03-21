// Macros to shut up the C++ warnings
#define printInt(x)
#define printDouble(x)
#define printString(x)
#define readInt() 0
#define readDouble() 0
#define readString() 0

// This program approximates pi and then checks that the approximation is within
// an acceptable bound

double piApprox(int iterations)
{
    double pi = 0.0;
    double factor = 1;
    int i = 2;
    while (i < iterations)
    {
        pi = pi + factor / (i - 1.0);
        i = i + 2;
        factor = factor * (0 - 1);
    }
    return 4 * pi;
}

int main()
{
    printString("How many iterations: ");
    int iterations = readInt();
    double pi = piApprox(iterations);
    // printDouble(pi);
    if (pi < 3.20 && pi > 3.10)
    {
        printString("pi approximated!\n");
    }
    else
    {
        printString("pi not approximated :,(\n");
    }
}