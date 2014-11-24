#include <stdio.h>
#include <time.h>
#include <stdlib.h>

#define NMAX 1000

void genRandPol(int n, float pol[]);

int main(int argc, char *argv[]) {
    float pol[NMAX];
    int npol = 0;
    if (argc != 3) {
        printf("Uso: ./gen_pmq [grau do polinomio gerador dos pontos] [quantidade de pontos gerados (n)] [grau do polinomio para solucionar o problema (m)]\n");
        return;
    }
    npol = atoi(argv[1]);
    genRandPol(npol, pol);
    return 0;
}

void genRandPol(int n, float pol[]) {
    int i;
    for (i = 0; i <= n; i++) {
        pol[i] = rand();
        printf("%f\n", pol[i]);
    }
}
