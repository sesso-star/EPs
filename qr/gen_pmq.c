#include <stdio.h>
#include <time.h>
#include <stdlib.h>

#define NMAX 1000

void genRandPol(int n, double pol[]);
void isAlmostLD(int n, double x[], double y[]);
void genPoints(int n, double points[]);
void genMatrix(int n, int m, double matrix[][NMAX]);

int main(int argc, char *argv[]) {
    double pol[NMAX];
    double matrix[NMAX][NMAX];
    double points[NMAX]
    int n = 0, m = 0;
    int npoints = 0;
    int npol = 0;
    int nsolpol = 0;

    if (argc != 4) {
        printf("Uso: ./gen_pmq [grau do polinomio gerador dos pontos] [quantidade de pontos gerados (n)] [grau do polinomio para solucionar o problema (m)]\n");
        return;
    }
    npol = atoi(argv[1]);
    npoints = atoi(argv[2]);
    nsolpol = atoi(argv[3]);

    genRandPol(npol, pol);
    genPoints(npoints, points);
    genMatrix(npoints, nsolpol);
    return 0;
}

void genRandPol(int n, double pol[]) {
    int i;
    for (i = 0; i <= n; i++) {
        double f = rand();
        pol[i] = f / RAND_MAX;
        printf("%lf\n", pol[i]);
    }
}

void genPoints(int n, double points[]) {
    int i;
    for (i = 0; i <= n; i++) {
        points[i] = rand()  / RAND_MAX;
    }
}

void genMatrix(int n, int m, double matrix[][NMAX]) { 
    int i, j;
    for (i = 0; i <= n; i++)
}

void isAlmostLD(int n, double x[], double y[]) {
}
