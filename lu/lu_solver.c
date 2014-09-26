#include <stdio.h>

#define NMAX 3
#define abs(x) (((x) < 0) ? -(x) : (x))
#define eps 1e-16

int lucol(int n, double A[][NMAX], int p[]);
void swap(double *a, double *b);

int main(int argc, char **argv) {
    int p[3];
    int n = 3;
    
    double A[3][3] = {
         {1.0, 2.0, 3.0},
         {0.0, 5.0, 6.0},
         {0.0, 0.0, 9.0}};

    lucol(n, A, p);

    printf("\n\n");
    int i, j;
    for (i = 0; i < n; i++) {
        for (j = 0; j < n; j++)
            printf("%3.2f ", A[i][j]);
        printf("\n");
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
            printf("\nPARA, pois A parece singular");
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
}

void swap(double *a, double *b) {
    double temp = *a;
    *a = *b;
    *b = temp;
}
