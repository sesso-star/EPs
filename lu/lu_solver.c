#include <stdio.h>

#define NMAX 1000
#define abs(x) (((x) < 0) ? -(x) : (x))
#define eps 1e-16

int leMatriz(double A[][NMAX], double b[NMAX]);
int lucol(int n, double A[][NMAX], int p[]);
int sscol(int n, double A[][NMAX], int p[], double b[]);
void swap(double *a, double *b);
void printMatrix(double A[][NMAX], int n);

int main(int argc, char **argv) {
    int n = 0;
    int i;
    int p[NMAX];
    double b[NMAX];
    double A[NMAX][NMAX];

    n = leMatriz(A, b);
    lucol(n, A, p);
    sscol(n, A, p, b);
    return 0;
}

int leMatriz(double A[][NMAX], double b[NMAX]) {
    int n, k, i, j;
    scanf("%d", &n);
    for (k = 0; k < n * n; k++) {
        scanf("%d %d", &i, &j);
        scanf("%lf", &A[i][j]);
    }
    for (k = 0; k < n; k++) {
        scanf("%d", &i);
        scanf("%lf", &b[i]);
    }
    return n;
}

int lucol(int n, double A[][NMAX], int p[]) {
    int k, i, j, imax;

    for (k = 0; k < n; k++) {
        imax = k;
        for (i = k + 1; i < n; i++) 
            if (abs(A[i][k]) > abs(A[imax][k])) 
                imax = i;

        if (abs(A[imax][k]) < eps)  {
            printf("Matriz parece ser singular\n");
            return 0;
        }
        if (imax != k)
            for (j = 0; j < n; j++)
                swap(&A[imax][j], &A[k][j]);
        p[k] = imax;
        for (i = k + 1; i < n; i++) {
            A[i][k] = A[i][k] / A[k][k];
            for (j = k + 1; j < n; j++)
                A[i][j] = A[i][j] - A[k][j] * A[i][k];
        }
    }
    return 1;     
}

int sscol(int n, double A[][NMAX], int p[], double b[]) {
    int i, j;
    double temp;

    for (i = 0; i < n; i++) {
        swap(&b[i], &b[p[i]]);
    }

    /*Ly = b*/
    for (j = 0; j < n; j++) 
        for (i = j + 1; i < n; i++)
            b[i] -= A[i][j] * b[j];

    /*Ux = y*/
    for (j = n - 1; j >= 0; j--) {
        if (abs(A[j][j]) < eps) {
            printf("Matriz parece ser singular\n");
            return 0;
        }
        b[j] = b[j] / A[j][j];
        for (i = 0; i < j; i++) {
            b[i] -= b[j] * A[i][j];
        }
    }
    for (i = 0; i < n; i++) {
        printf("%3.2lf\t%d\n", b[i], i);
    }
    return 1;
}

void swap(double *a, double *b) {
    double temp = *a;
    *a = *b;
    *b = temp;
}

void printMatrix(double A[][NMAX], int n) {
    int i, j;
    for (i = 0; i < n; i++) {
        for (j = 0; j < n; j++)
            printf("%3.2f ", A[i][j]);
        printf("\n");
    }
}
