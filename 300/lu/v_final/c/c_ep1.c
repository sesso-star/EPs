#include <stdio.h>
#include <string.h>

#define NMAX 1000
#define abs(x) (((x) < 0) ? -(x) : (x))
#define eps 1e-16

int lucol(int n, double A[][NMAX], int p[]);
int sscol(int n, double A[][NMAX], int p[], double b[]);
int lurow(int n, double A[][NMAX], int p[]);
int ssrow(int n, double A[][NMAX], int p[], double b[]);

int leMatriz(double A[][NMAX], double b[NMAX]);
void swap(double *a, double *b);
void printMatrix(double A[][NMAX], int n);
void printVector(double v[], int n);

typedef enum { false, true } bool;
int main(int argc, char **argv) {
    int n = 0;
    int i;
    int p[NMAX];
    bool colMode = false;
    bool quietMode = false;

    double b[NMAX];
    double A[NMAX][NMAX];

    for (i = 1; i < argc; i++) {
        if (strcmp(argv[i], "-c") == 0)
            colMode = true;
        else if (strcmp(argv[i], "-q") == 0)
            quietMode = true;
    }
    
    n = leMatriz(A, b);

    /* Calcula orientado a colunas */
    if (colMode) {
        printf("Calculando orientado a colunas\n");
        if (!lucol(n, A, p)) { 
            if (!sscol(n, A, p, b)) {
                if (!quietMode) printVector(b, n);
            } else {
                printf("sscol: A matriz parece singular\n");
                return -1;
            }
        } else {
            printf("lucol: A matriz parece singular\n");
            return -1;
        }
    }
    /* Calcula orientado a linhas */
    else {
        printf("Calculando orientado a linhas\n");
        if (!lurow(n, A, p)) {
            if (!ssrow(n, A, p, b)) {
                if (!quietMode) printVector(b, n);
            } else {
               printf("ssrow: A matriz parece singular\n"); 
               return -1;
            }
        }
        else {
            printf("lurow: A matriz parece singular\n");
            return -1;
        }
    }
    

    return 0;
}

int leMatriz(double A[][NMAX], double b[NMAX]) {
    int n, k, i, j, nsquare;
    scanf("%d", &n);
    nsquare = n * n;
    for (k = 0; k < nsquare; k++) {
        scanf("%d %d", &i, &j);
        scanf("%lf", &A[i][j]);
    }
    for (k = 0; k < n; k++) {
        scanf("%d", &i);
        scanf("%lf", &b[i]);
    }
    return n;
}

int lurow(int n, double A[][NMAX], int p[]) {
    int k, i, j, imax;

    for (k = 0; k < n; k++) {
        imax = k;
        for (i = k + 1; i < n; i++) 
            if (abs(A[i][k]) > abs(A[imax][k])) 
                imax = i;
        if (abs(A[imax][k]) < eps) 
            return -1;
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
    return 0;
}

int ssrow(int n, double A[][NMAX], int p[], double b[]) {
    int i, k;

    for (i = 0; i < n; i++) 
        if (p[i] != i)
            swap(&b[p[i]], &b[i]);

    for (i = 0; i < n; i++)
        for (k = 0; k < i; k++)
            b[i] = b[i] - b[k] * A[i][k];

    for (i = n - 1; i >= 0; i--) {
        for (k = n - 1; k > i; k--)
            b[i] = b[i] - b[k] * A[i][k];
        if (abs(A[i][i]) < eps)
            return -1;
        b[i] = b[i] / A[i][i];
    }

    return 0;
}

int lucol(int n, double A[][NMAX], int p[]) {
    int k, i, j, imax;

    for (k = 0; k < n; k++) {
        imax = k;
        for (i = k + 1; i < n; i++) 
            if (abs(A[i][k]) > abs(A[imax][k])) 
                imax = i;

        if (abs(A[imax][k]) < eps) 
            return -1; 
        if (imax != k)
            for (j = 0; j < n; j++)
                swap(&A[imax][j], &A[k][j]);
        p[k] = imax;


        for (i = k + 1; i < n; i++)
            A[i][k] = A[i][k] / A[k][k];

        for (j = k + 1; j < n; j++)            
            for (i = k + 1; i < n; i++)
                A[i][j] = A[i][j] - A[k][j] * A[i][k];
    }     
    return 0;
}

int sscol(int n, double A[][NMAX], int p[], double b[]) {
    int i, k;

    for (i = 0; i < n; i++)
        if (p[i] != i)
            swap(&b[p[i]], &b[i]);

    for (k = 0; k < n; k++)
        for (i = k + 1; i < n; i++)
            b[i] = b[i] - b[k] * A[i][k];

    for (k = n - 1; k >= 0; k--) {
        if (abs(A[k][k]) < eps)
            return -1;
        b[k] = b[k] / A[k][k];
        for (i = k - 1; i >= 0; i--)
            b[i] = b[i] - b[k] * A[i][k];
    }

    return 0;
}

void swap(double *a, double *b) {
    double temp = *a;
    *a = *b;
    *b = temp;
}

void printMatrix(double A[][NMAX], int n) {
    int i, j;
    printf("\n");
    for (i = 0; i < n; i++) {
        for (j = 0; j < n; j++)
            printf("% 3.2f ", A[i][j]);
        printf("\n");
    }
}

void printVector(double v[], int n) {
    int i;
    printf("\n");
    for (i = 0; i < n; i++)
        printf("% 3.2f\n", v[i]);
}
