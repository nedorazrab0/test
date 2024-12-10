#include <iostream>

int main()
{
    int i;
    int a;
    for (i = 0; i < 2147483647; i++) {
        a++;
    }
    std::cout<<a;

    return 0;
}