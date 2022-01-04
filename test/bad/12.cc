#include <string>

using std::string;

string hello(string x)
{
    {
        string x = "hey";
        return 5;
    }
    return x;
}

int main()
{
    return 0;
}
