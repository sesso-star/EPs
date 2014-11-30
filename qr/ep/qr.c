#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define MAX 1000
#define abs(x) (((x) < 0) ? -(x) : (x))
#define eps 1e-16

/** FUNÇÕES PRINCIPAIS **/
int qr(double A[][MAX], double b[], double sigma[], int map[], int n, int m);
void qr_solve(double A[][MAX], double b[], double sigma[], int m, int rank);
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
    int rank;

    readMatrix(A, b, &n, &m);
    getColNorms(A, sigma, n, m);
    printVector(sigma, m);
    rank = qr(A, b, sigma, map, n, m);
    printf("retorno: %d\n", rank);
    printVector(b, n);
    qr_solve(A, b, sigma, m, rank);
    remap(b, map, m);

//  printMatrix(A, n, m);
//  printf("simga:\n");
//	printVector(sigma, m);
	printf("b:\n");
    printVector(b, n);
    return 0;
}

/** FUNÇÕES PRINCIPAIS *****************************************************************/ 

/* Calcula a decomposição QR de uma dada matriz A.
 * Recebe a matriz A que será decomposta em Q*R e a Q_i e R encontradas são retornadas 
 * armazenadas na própria A. Recebe-se o vetor 'b' (Ax = b) e retorna-se nele mesmo
 * o vetor c = Qt * b. Em sigma recebe-se a norma_2 de cada coluna de A e nele retorna-se
 * a diagonal principal de R. Em map retorna-se o vetor que representa as trocas de colunas
 * feitas durante a decomposição. 'n' é o número de linhas da matriz e 'm' é o número de colunas
 * A funcao devolve o inteiro rank que é o posto da matriz A */
int qr(double A[][MAX], double b[], double sigma[], int map[], int n, int m) {
    int i, j, k, maxI;
    double max, alpha, beta;
    int rank = 0;
    for (j = 0; j < m; j++) {
        double w[MAX];
        /* swap columns */
        max = sigma[j];
        maxI = j;
        for (k = j + 1; k < m; k++)
            if (sigma[k] > max) {
                max = sigma[k];
                maxI = k;
            }
        if (abs(max) < eps) {
            printf("A matriz possui posto incompleto\n");
            return rank;
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
        /*w = uT * A*/
        for (i = 0; i < m - j; i++) 
            w[i] = 0;
        for (i = j; i < n; i++) 
            for (k = j + 1; k  < m; k++)  
                w[k - (j + 1)] += A[i][j] * A[i][k];
        /*A -= gama * u * w*/
        for (i = j; i < n; i++) 
            for (k = j + 1; k < m; k++)
                A[i][k] -= (A[i][j] * w[k - (j + 1)])/ (sigma[j] * A[j][j]);


        /* multiplica Q_j por b_j */        
        beta = 0;
        for (i = j; i < n; i++)
            beta += A[i][j] * b[i];
        for (i = j; i < n; i++)
            b[i] -= beta * A[i][j] / (sigma[j] * A[j][j]);
        sigma[j] = -sigma[j];

        printMatrix(A, n, m);
        /* Reajuste das novas normas2 de cada coluna a partir da linha j + 1 */
        for (k = j + 1; k < m; k++) {
            sigma[k] = sigma[k] * sigma[k] - A[j][k] * A[j][k];
            if (sigma[k] < 0)
                sigma[k] = 0;
            sigma[k] = sqrt(sigma[k]);
        }
        rank++;
    }
    return rank;
}

/* Resolve Ax = b, dado a decomposição QR de A.
 * Em A recebe-se a matriz que contem as Q_i e R.
 * Em sigma recebe-se o vetor que contém a diagonal principal de R. m é o número de 
 * colunas de A.
 * Em map recebe-se as permutações de colunas feitas em A.
 * Calcula-se c = Q^t * b e, depois, o 'x' tal que R * x = c */
void qr_solve(double A[][MAX], double b[], double sigma[], int m, int rank) {
    int i, j;
    printf("rank: %d\n", rank);
    for (i = rank - 1; i >= 0; i--) {
        for (j = i + 1; j < m; j++)
            b[i] -= A[i][j] * b[j];
        b[i] /= sigma[i];
    }
    for (i = rank; i < m; i++)
        b[i] = 0;
}

/* devolve em sigma as normas de cada coluna de A. A tem n linhas e m colunas */
void getColNorms(double A[][MAX], double sigma[], int n, int m) {
    int i, j;
    double max, normalized;
    
    for (j = 0; j < m; j++) {
        /* Norma infinita */
        max = abs(A[0][j]); 
        for (i = 1; i < n; i++)
            if (abs(A[i][j] > max))
                max = abs(A[i][j]);
        if (abs(max) < eps) { 
            sigma[j] = 0;
            continue;
        }
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
/* Lê uma matriz A da stdin no seguinte formato:
 * n m
 * linha coluna elemento
 * linha coluna elemento
 * ... */
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

/* A partir de um vetor map, calcula-se as novas posições dos elementos de b */
void remap(double b[], int map[], int n) {
    int i;
    for (i = n - 1; i >= 0; i--)
        swap(&b[i], &b[map[i]]);
}

/* imprime a matriz A */
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

/* Imprime o vetor b */
void printVector(double b[], int n) {
    int i;
    for (i = 0; i < n; i++)
        printf("%lf\n", b[i]);
    printf("\n");
}

/* Troca a coluna col1 pela col2 de A */
void swapColumns(double A[][MAX], int n, int col1, int col2) {
    int i;

    for (i = 0; i < n; i++) {
        swap(&A[i][col1], &A[i][col2]);
    }
}

/* Troca as variaveis a e b */
void swap(double *a, double *b) {
    double temp = *a;
    *a = *b;
    *b = temp;
}
