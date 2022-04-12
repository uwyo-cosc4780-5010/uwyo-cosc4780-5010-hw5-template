// Macros to shut up the C++ warnings
#define printInt(x)
#define printDouble(x)
#define printString(x)
#define readInt() 0
#define readDouble() 0
#define readString() 0

// This program approximates pi and then checks that the approximation is within
// an acceptable bound

double piApprox(double iterations)
{
    double pi = 0.0;
    double factor = 1.0;
    double i = 2.0;
    while (i < iterations)
    {
        pi = pi + factor / (i - 1.0);
        i = i + 2.0;
        factor = factor * (0.0 - 1.0);
    }
    return 4.0 * pi;
}

int main()
{
    printString("How many iterations: ");
    double iterations = readDouble();
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