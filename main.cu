#include "stdio.h"

int main() {
  int height, width;
  scanf("%dX%d\n", &height, &width);
  double **matrixA = (double **)malloc(height * (sizeof(double *)) +
                                       height * width * (sizeof(double)));
  double *ptr = (double *)(matrixA + height);
  for (int i = 0; i < height; ++i)
    matrixA[i] = ptr + i * width;

  for (int i = 0; i < height; ++i) {
    for (int j = 0; j < width; ++j) {
      scanf("%lf", &(matrixA[i][j]));
    }
  }

  int height2, width2;
  scanf("%dX%d\n", &height2, &width2);
  double **matrixB = (double **)malloc(height2 * (sizeof(double *)) +
                                       height2 * width2 * (sizeof(double)));
  ptr = (double *)(matrixB + height2);
  for (int i = 0; i < height2; ++i)
    matrixB[i] = ptr + i * width2;

  for (int i = 0; i < height2; ++i) {
    for (int j = 0; j < width2; ++j) {
      scanf("%lf", &(matrixB[i][j]));
    }
  }

  int height3, width3;
  height3 = height;
  width3 = width2;

  double **matrixC = (double **)malloc(height3 * (sizeof(double *)) +
                                       height3 * width3 * (sizeof(double)));
  ptr = (double *)(matrixC + height3);
  for (int i = 0; i < height3; ++i)
    matrixC[i] = ptr + i * width3;

  for (int i = 0; i < height3; ++i) {
    for (int j = 0; j < width3; ++j)
      matrixC[i][j] = 7;
  }

  MatrixMulOnDevice(matrixA, matrixB, matrixC, height3, width3, width);

  printf("MatrixA:\n");
  for (int i = 0; i < height; ++i) {
    for (int j = 0; j < width; ++j)
      printf("%lf ", matrixA[i][j]);
    printf("\n");
  }
  printf("\n\n");

  printf("MatrixB:\n");
  for (int i = 0; i < height2; ++i) {
    for (int j = 0; j < width2; ++j)
      printf("%lf ", matrixB[i][j]);
    printf("\n");
  }
  printf("\n\n");

  printf("MatrixC:\n");
  for (int i = 0; i < height3; ++i) {
    for (int j = 0; j < width3; ++j)
      printf("%lf ", matrixC[i][j]);
    printf("\n");
  }
  printf("\n\n");

  free(matrixA);
  free(matrixB);
  free(matrixC);
}