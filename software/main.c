#include <stdio.h>

extern void sum(int* a, int* b, int* result);

// Função para imprimir um inteiro em binário (32 bits)
void print_binary(int num) {
    for (int i = 31; i >= 0; i--) {
        printf("%d", (num >> i) & 1);
        if (i % 8 == 0 && i != 0) printf(" "); // separa por byte (opcional)
    }
}

int main() {
    int op1 = 31, op2 = 22, result;

    sum(&op1, &op2, &result);

    printf("Resultado em binário: ");
    print_binary(result);
    printf("\n");

    return 0;
}
