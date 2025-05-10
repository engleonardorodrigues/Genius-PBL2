#include<stdio.h>

extern void sum(int* a, int* b, int* result);

int main(){
    int op1 = 31, op2 = 22, result;

    sum(&op1, &op2, &result);

    printf("%d + %d = %d\n", op1, op2, result);

    return 0;
}