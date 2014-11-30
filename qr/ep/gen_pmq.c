#include <stdio.h>
#include <time.h>
#include <stdlib.h>

#define NMAX 1000
#define DISTURB_COEF 0.01

void genRandPol(int npol, double pol[]);
void writeProblem(int npoints, int nsolpol, double A[][NMAX], double b[]);
void genPoints(int npoints, double points[]);
void disturb(int npoints, double b[]);
void genA(int npoints, int nsolpol, double A[][NMAX], double points[], int rank);
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
    int rank = 0;
    int npol = 0;
    int npoints = 0;  /*n*/
    int nsolpol = 0;  /*m*/

    if (argc != 6) {
        printf("Uso: ./gen_pmq [posto da matriz gerada] [grau do polinomio gerador dos pontos] [quantidade de pontos gerados (n)] [grau do polinomio para solucionar o problema (m)] [semente do gerador]\n");
        return 0;
    }
    rank = atoi(argv[1]);
    npol = atoi(argv[2]);
    npoints = atoi(argv[3]);
    nsolpol = atoi(argv[4]);
    srand(atoi(argv[5]));
    
    genRandPol(npol, pol);
    genPoints(npoints, points);
    genA(npoints, nsolpol, A, points, rank);
    fillb(npoints, npol, points, pol, b);
    disturb(npoints, b);
    printf("polinomio gerado: (x esperado)\n");
    printVector(pol, npol + 1);
    /*printf("pontos gerados:\n");
    printVector(points, npoints);*/
    printf("Matrix gerada: \n");
    printMatrix(A, npoints, nsolpol + 1);
    printf("b gerado: \n");
    printVector(b, npoints);
    genPolPlot(npol, pol);
    pointsToFile(npoints, points, b);
    writeProblem(npoints, nsolpol, A, b);
    return 0;
}

void genRandPol(int npol, double pol[]) {
    int i;
    for (i = 0; i <= npol; i++) {
        pol[i] = rand() / (double) (RAND_MAX / 10.0);
        if (rand() > RAND_MAX / 2.0) 
            pol[i] *= -1;
    }
}

void writeProblem(int npoints, int nsolpol, double A[][NMAX], double b[]) {
    int i, j;
    FILE *f = fopen("prob.txt", "w");
    fprintf(f, "%d %d\n", npoints, nsolpol + 1);
    for (i = 0; i < npoints; i++)
        for (j = 0; j <= nsolpol; j++)
            fprintf(f, "%d %d %lf\n", i, j, A[i][j]);
    for (i = 0; i < npoints; i++)
        fprintf(f, "%d %lf\n", i, b[i]);
    fclose(f);
}

void genPoints(int npoints, double points[]) {
    int i;
    for (i = 0; i < npoints; i++) {
        points[i] = rand()  / (double) (RAND_MAX / 10.0);
        if (rand() > RAND_MAX / 2.0) 
            points[i] *= -1;
    }
}

void disturb(int npoints, double b[]) {
    int i;
    for (i = 0; i < npoints; i++) {
        double biggest_disturb = b[i] * DISTURB_COEF;
        double dx = biggest_disturb * (rand() / (float) RAND_MAX);
        //double dx = biggest_disturb;
        if (rand() > RAND_MAX / 2.0)
            dx *= -1;
        b[i] += dx;
    }
}

void genA(int npoints, int nsolpol, double A[][NMAX], double points[], int rank) { 
    int i, j;
    for (i = 0; i < rank; i++) {
        double pot = 1;
        for (j = 0; j <= nsolpol; j++) {
            A[i][j] = pot;
            pot = pot * points[i];
        }
    }
    /*complete the matrix with zeros*/
    for (i = rank; i < npoints; i++) 
        for (j = 0; j <= nsolpol; j++)
            A[i][j] = 0;
}

void fillb(int npoints, double npol, double points[], double pol[], double b[]) {
    int i, j;
    for (i = 0; i < npoints; i++) {
        double img = 0;
        double pot = 1;
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
        double x = pol[i];
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
