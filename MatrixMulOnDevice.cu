#include <cuda_runtime.h>

__global__ void MatrixMulKernel(double *Ad, double *Bd, double *Cd, int height,
                                int width, int common_number) {
  unsigned i = threadIdx.x, j = threadIdx.y;
  Cd[i * height + j] = 0.0;
  for (int k = 0; k < common_number; ++k)
    Cd[i * width + j] += Ad[i * common_number + k] * Bd[k * width + j];
}

void MatrixMulOnDevice(double **A, double **B, double **C, int height,
                       int width, int common_number) {
  int sizeA = height * common_number * sizeof(double);
  int sizeB = common_number * width * sizeof(double);
  int size = height * width * sizeof(double);
  double *Ad, *Bd, *Cd;

  cudaMalloc(&Ad, sizeA);
  cudaMemcpy(Ad, A[0], sizeA, cudaMemcpyHostToDevice);
  cudaMalloc(&Bd, sizeB);
  cudaMemcpy(Bd, B[0], sizeB, cudaMemcpyHostToDevice);

  cudaMalloc(&Cd, size);

  dim3 dimGrid(1, 1);
  dim3 dimBlock(height, width);
  MatrixMulKernel<<<dimGrid, dimBlock>>>(Ad, Bd, Cd, height, width,
                                         common_number);
  cudaDeviceSynchronize();

  cudaMemcpy(C[0], Cd, size, cudaMemcpyDeviceToHost);

  cudaFree(Ad);
  cudaFree(Bd);
  cudaFree(Cd);
}