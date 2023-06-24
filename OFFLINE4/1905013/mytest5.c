int foo(int x)
{
if(x==1)
    return 1;
else 
    return foo(x-1)*x;
}
int main()
{
    int x;
    x=5;
    x=foo(x);
    return 0;
}
