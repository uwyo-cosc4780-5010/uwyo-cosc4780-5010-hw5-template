int main()
{
    double x, y, z;
    x = 2.4353;
    {
        int x;
        return x; // x uninitialized
    }
}