#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define MAX 100
#define abs(x) (((x) < 0) ? -(x) : (x))

/** FUNÇÕES PRINCIPAIS **/
void qr(double A[][MAX], double b[], int n, int m);
void qr_solve(double A[][MAX], double b[], int m);
void prepareMatrix(double A[][MAX], int map[], int n, int m);

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

	readMatrix(A, b, &n, &m);

//	printMatrix(A, n, m);
//	system("sleep 5");
	prepareMatrix(A, map, n, m);
//	printMatrix(A, n, m);
//	system("sleep 10");

//  printMatrix(A, n, m);
//  printVector(b, n);

	qr(A, b, n, m);
    qr_solve(A, b, m);
	remap(b, map, n);

//  printMatrix(A, n, m);
    printVector(b, n);

	return 0;
}

/** FUNÇÕES PRINCIPAIS *****************************************************************/ 

void qr(double A[][MAX], double b[], int n, int m) {
	int i, j, k;
	double max, sigma, alpha, beta, gama;

	for (j = 0; j < m; j++) {
		/* Acha o máximo na coluna j a partr do indice i */
		max = abs(A[j][j]);
		for (i = j + 1; i < n; i++)
			if (abs(A[i][j]) > max)
				max = abs(A[i][j]);

		/* Calcula a Q_i e o gama */
		if (max == 0)
			gama = 0;
		else {
			sigma = 0;
			for (i = j; i < n; i++) {
				A[i][j] /= max;
				sigma += A[i][j] * A[i][j];
			}
			sigma = sqrt(sigma);

			if (A[j][j] < 0)
				sigma = -sigma;
			A[j][j] += sigma;

			gama = 1 / (sigma * A[j][j]);
			sigma *= max;
		}
		
		/* Multiplica Q_j por A_j */
		for (k = j + 1; k < m; k++) {
			alpha = 0;
			for (i = j; i < n; i++)
				alpha += A[i][j] * A[i][k];
			for (i = j; i < n; i++)
				A[i][k] -= gama * alpha * A[i][j];
		}
		
		/* multiplica Q_j por b_j */		
		beta = 0;
		for (i = j; i < n; i++)
			beta += A[i][j] * b[i];
for (i = j; i < n; i++)
			b[i] -= gama * beta * A[i][j];

		A[j][j] = -sigma;
	}
}

void qr_solve(double A[][MAX], double b[], int m) {
    int i, j;

    for (i = m - 1; i >= 0; i--) {
        for (j = i + 1; j < m; j++)
            b[i] -= A[i][j] * b[j];
        if (A[i][i] == 0)
            printf("qr_solve: Division by 0");
        b[i] /= A[i][i];
    }
}

void prepareMatrix(double A[][MAX], int map[], int n, int m) {
	int i, j, k;
	double norm, maxNorm = -1; // impossible
	int maxNormColIdx = -1; // impossible

	for (k = 0; k < m; k++) {
		maxNorm = 0;
		maxNormColIdx = k;
		for (j = k; j < m; j++) {
			norm = 0;
			for (i = k; i < n; i++) 
				norm += A[i][j] * A[i][j];
			if (norm > maxNorm) {
				maxNorm = norm;
				maxNormColIdx = j;
			}
		}
		
		if (maxNormColIdx != k) 
			swapColumns(A, n, maxNormColIdx, k);

		map[k] = maxNormColIdx;
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
	for (i = 0; i < n; i++)
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
