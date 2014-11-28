#include <stdio.h>
#include <time.h>
#include <stdlib.h>

#define NMAX 1000

void genRandPol(int n, double pol[]);
void genPoints(int n, double points[]);
void genA(int npoints, int nsolpol, double A[][NMAX], double points[]);
void fillb(int npoints, double npol, double points[], double pol[], double b[]);
void isAlmostLD(int n, double x[], double y[]);
void genPolPlot(int npol, double pol[]);
void pointsToFile(int npoints, double points[], double b[]);

void printMatrix(double A[][NMAX], int n, int m);
void printVector(double b[], int n);


int main(int argc, char *argv[]) {
    double pol[NMAX];
    double A[NMAX][NMAX];
    double b[NMAX];
    double points[NMAX];
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
    genA(npoints, nsolpol, A, points);
    fillb(npoints, npol, points, pol, b);
    printf("polinomio gerado: \n");
    printVector(pol, npol + 1);
    printf("pontos gerados:(x esperado) \n");
    printVector(points, npoints);
    printf("Matrix gerada: \n");
    printMatrix(A, npoints, nsolpol);
    printf("b gerado: \n");
    printVector(b, npoints);
    genPolPlot(npol, pol);
    pointsToFile(npoints, points, b);
    return 0;
}

void genRandPol(int npol, double pol[]) {
    int i;
    for (i = 0; i <= npol; i++) {
        pol[i] = rand() / (double) (RAND_MAX / 10.0);
    }
}

void genPoints(int npoints, double points[]) {
    int i;
    for (i = 0; i < npoints; i++) {
        points[i] = rand()  / (double) (RAND_MAX / 10.0);
    }
}

void genA(int npoints, int nsolpol, double A[][NMAX], double points[]) { 
    int i, j;
    for (i = 0; i < npoints; i++) {
        float pot = points[i];
        for (j = 0; j <= nsolpol; j++) {
            A[i][j] = pot;
            pot = pot * points[i];
        }
    }
}

void fillb(int npoints, double npol, double points[], double pol[], double b[]) {
    int i, j;
    for (i = 0; i < npoints; i++) {
        float img = 0;
        float pot = 1;
        for (j = 0; j <= npol; j++) {
            img += pot * pol[j];
            pot *= points[i];
        }
        b[i] = img;
    }
}

void isAlmostLD(int n, double x[], double y[]) {
}

void genPolPlot(int npol, double pol[]) {
    int i;
    FILE *f;
    f = fopen("./data/plotpol", "w");
    fprintf(f, "f(x) = ");
    for (i = 0; i <= npol; i++) {
        float x = pol[i];
        char str[NMAX];
        sprintf(str, "%lf * x ** %d", pol[i], i);
        fprintf(f, "%s", str);
        fprintf(f, " + ");
    }
    fprintf(f, "0\n");
    fprintf(f, "plot [-10:10] f(x)\n");
    fprintf(f, "pause -1");
    fclose(f);
}

void pointsToFile(int npoints, double points[], double b[]) {
    int i;
    FILE *points_f;
    FILE *script_f;
    points_f = fopen("./data/gentd_points", "w");
    script_f = fopen("./data/plotpoints", "w");
    for (i = 0; i < npoints; i++) 
        fprintf(points_f, "%lf %lf\n", points[i], b[i]);
    fprintf(script_f, "plot 'gentd_points'\n pause -1");
    fclose(points_f);
    fclose(script_f);  
}



/*Funcoes auxiliares*/
void printMatrix(double A[][NMAX], int n, int m) {
    int i, j;
    for (i = 0; i < n; i++) {
        for (j = 0; j < m; j++)
	    printf("%lf ", A[i][j]);
	printf("\n");
    }
    printf("\n");
}

void printVector(double b[], int n) {
    int i;
    for (i = 0; i < n; i++)
        printf("%lf ", b[i]);
    printf("\n");
}
