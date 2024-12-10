#include <iostream>

int main()
{
    int i;
    for (i = 0; i < 2147483647; i++) {
        int a;
        a++;
    }
    std::cout<<a;

    return 0;
}