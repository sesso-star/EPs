#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define MAX 100
#define abs(x) (((x) < 0) ? -(x) : (x))

/** FUNÇÕES PRINCIPAIS **/
void qr(double A[][MAX], double b[], int n, int m);
void qr_solve(double A[][MAX], double b[], int m);
void prepareMatrix(double A[][MAX], int n, int m);

/** FUNÇÕES AUXILIARES **/
void randMatrix(double A[][MAX], int n, int m);
void randVector(double b[], int n);
void printMatrix(double A[][MAX], int n, int m);
void printVector(double b[], int n);
void swapColumns(double A[][MAX], int n, int col1, int col2);

int main(int argc, char **argv) {
	double A[MAX][MAX];
	double b[MAX];

	int	n = 5; /* Number of lines */
	int	m = 3; /* Number of columns */

	randMatrix(A, n, m);
    randVector(b, n);

    printMatrix(A, n, m);
    printVector(b, n);

	qr(A, b, n, m);
    qr_solve(A, b, m);

    printMatrix(A, n, m);
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

void prepareMatrix(double A[][MAX], int n, int m) {
	int i, j;
	double norm, maxNorm = -1; // impossible
	int maxNormColIdx = -1; // impossible

	for (k = 0; k < m; k++) {
		for (j = k; j < m; j++) {
			norm = 0;
			for (i = j; i < n; i++)
				norm += A[i][j] * A[i][j];
			if (norm > maxNorm) {
				maxNorm = norm;
				maxNormColIdx = j;
			}
		}
		if (maxNormColIdx != k)
			swapColumns(A, n, maxNormColIdx, k) /// AQUI
	}
}

/** FUNÇÕES AUXILIARES *****************************************************************/

/* Generates a random matrix of n lines and m columns with
 * each number in the interval: [0; 100[ */
void randMatrix(double A[][MAX], int n, int m) {
	int i, j;

	srand(time(NULL));

	for (i = 0; i < n; i++)
		for (j = 0; j < m; j++) 
			A[i][j] = (double)rand() / RAND_MAX * 100;
}

void randVector(double b[], int n) {
    int i;

    srand(time(NULL));

    for (i = 0; i < n; i++)
        b[i] = (double)rand() / RAND_MAX * 100;

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
	double aux;

	for (i = 0; i < n; i++) {
		aux = A[i][col1];
		A[i][col1] = A[i][col2];
		A[i][col2] = aux;
	}
}
