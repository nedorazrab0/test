#include <stdio.h>

int main()
{
    int i;
    for (i = 0; i < 2147483647; i++) {
        int a;
        a++;
    }
    printf("%d\n", i);

    return 0;
}