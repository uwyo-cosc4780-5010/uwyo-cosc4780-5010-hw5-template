bool wantBoolPlz(bool x) {
    return x;
}

int main()
{
    bool x;
    wantBoolPlz(x); // x uninitialized
    return 0;
}