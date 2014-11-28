#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define MAX 1000
#define abs(x) (((x) < 0) ? -(x) : (x))

/** FUNÇÕES PRINCIPAIS **/
void qr(double A[][MAX], double b[], double sigma[], int map[], int n, int m);
void qr_solve(double A[][MAX], double b[], double sigma[], int m);
void getColNorms(double A[][MAX], double sigma[], int n, int m);

/** FUNÇÕES AUXILIARES **/
int readMatrix(double A[][MAX], double b[], int *n, int *m); 
void remap(double b[], int map[], int n);
void printMatrix(double A[][MAX], int n, int m);
void printVector(double b[], int n);
void swapColumns(double A[][MAX], int n, int col1, int col2);
void swap(double *a, double *b); 

int main(int argc, char **argv) {
    int n, m;
    double A[MAX][MAX];
    double b[MAX];
    int map[MAX];
    double sigma[MAX];

    readMatrix(A, b, &n, &m);

    getColNorms(A, sigma, n, m);

    qr(A, b, sigma, map, n, m);
    qr_solve(A, b, sigma, m);
    remap(b, map, m);

//  printMatrix(A, n, m);
//	printVector(sigma, m);
    printVector(b, m);

    return 0;
}

/** FUNÇÕES PRINCIPAIS *****************************************************************/ 

void qr(double A[][MAX], double b[], double sigma[], int map[], int n, int m) {
    int i, j, k, maxI;
    double max, alpha, beta;

    for (j = 0; j < m; j++) {
        /* swap columns */
        max = sigma[j];
        maxI = j;
        for (k = j + 1; k < m; k++)
            if (sigma[k] > max) {
                max = sigma[k];
                maxI = k;
            }
        if (maxI != j) {
            swapColumns(A, n, j, maxI);
            swap(&sigma[j], &sigma[maxI]);
        }
        map[j] = maxI;

        if (A[j][j] < 0)
            sigma[j] = -sigma[j];
        A[j][j] += sigma[j];

        /* Multiplica Q_j por A_j */
        for (k = j + 1; k < m; k++) {
            alpha = 0;
            for (i = j; i < n; i++)
                alpha += A[i][j] * A[i][k];
            for (i = j; i < n; i++)
                A[i][k] -= alpha * A[i][j] / (sigma[j] * A[j][j]);
        }
        
        /* multiplica Q_j por b_j */        
        beta = 0;
        for (i = j; i < n; i++)
            beta += A[i][j] * b[i];
        for (i = j; i < n; i++)
            b[i] -= beta * A[i][j] / (sigma[j] * A[j][j]);

        sigma[j] = -sigma[j];

        for (k = j + 1; k < m; k++)
            sigma[k] = sqrt(sigma[k] * sigma[k] - A[j][k] * A[j][k]);
    }
}

void qr_solve(double A[][MAX], double b[], double sigma[], int m) {
    int i, j;

    for (i = m - 1; i >= 0; i--) {
        for (j = i + 1; j < m; j++)
            b[i] -= A[i][j] * b[j];
        b[i] /= sigma[i];
    }
}

void getColNorms(double A[][MAX], double sigma[], int n, int m) {
    int i, j;
    double max, normalized;
    
    for (j = 0; j < m; j++) {
        /* Norma infinita */
        max = abs(A[1][j]);
        for (i = 1; i < n; i++)
            if (abs(A[i][j] > max))
                max = abs(A[i][j]);

        /* Norma2 da coluna j */
        for (i = 0; i < n; i++) {
            normalized = A[i][j] / max;
            sigma[j] += normalized * normalized;
        }
        sigma[j] = sqrt(sigma[j]);
        sigma[j] *= max;            
    }
}

/** FUNÇÕES AUXILIARES *****************************************************************/

int readMatrix(double A[][MAX], double b[], int *n, int *m) {
    int k, i, j, nm;
    scanf("%d", n);
    scanf("%d", m);
    nm = *n * *m;
    
    // Clear A and b
    for (i = 0; i < *n; i++) {
        for (j = 0; j < *m; j++)
            A[i][j] = 0;
        b[i] = 0;
    }

    for (k = 0; k < nm; k++) {
        scanf("%d %d", &i, &j);
        scanf("%lf", &A[i][j]);
    }
    for (k = 0; k < *n; k++) {
        scanf("%d", &i);
        scanf("%lf", &b[i]);
    }
}

void remap(double b[], int map[], int n) {
    int i;
    for (i = n - 1; i >= 0; i--)
        swap(&b[i], &b[map[i]]);
}

void printMatrix(double A[][MAX], int n, int m) {
    int i, j;

    printf("\nA = \n");
    for (i = 0; i < n; i++) {
        for (j = 0; j < m; j++)
            printf("%lf ", A[i][j]);
        printf("\n");
    }
    printf("\n");
}

void printVector(double b[], int n) {
    int i;
    printf("\nb = \n");
    for (i = 0; i < n; i++)
        printf("%lf\n", b[i]);
    printf("\n");
}

void swapColumns(double A[][MAX], int n, int col1, int col2) {
    int i;

    for (i = 0; i < n; i++) {
        swap(&A[i][col1], &A[i][col2]);
    }
}

void swap(double *a, double *b) {
    double temp = *a;
    *a = *b;
    *b = temp;
}