#include <stdio.h>

#define NMAX 3
#define abs(x) (((x) < 0) ? -(x) : (x))
#define eps 1e-16

int lucol(int n, double A[][NMAX], int p[]);
int sscol(int n, double A[][NMAX], int p[], double b[]);
int lurow(int n, double A[][NMAX], int p[]);
int ssrow(int n, double A[][NMAX], int p[], double b[]);
void swap(double *a, double *b);

int main(int argc, char **argv) {
    int p[3];
    int n = 3;
    
    double A[3][3] = {
         {1.0, 2.0, 3.0},
         {1.0, 5.0, 6.0},
         {1.0, 0.0, 9.0}};

    lurow(n, A, p);

    printf("\n\nA:\n");
    int i, j;
    for (i = 0; i < n; i++) {
        for (j = 0; j < n; j++)
            printf("%3.2f ", A[i][j]);
        printf("\n");
    }
    printf("\n\nP:\n");
    for (i = 0; i < n; i++)
        printf("%d\n", p[i]);

    
    return 0;
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
        if (A[i][i] < eps)
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
        for (i = k + 1; k < n; k++)
            b[i] = b[i] - b[k] * A[i][k];

    for (k = n - 1; k >= 0; k--) {
        if (A[k][k] < eps)
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
