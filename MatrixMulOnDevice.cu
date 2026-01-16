#include <cuda_runtime.h>
#include "stdio.h"

__global__ void MatrixMulKernel (double *Ad, double *Bd, double *Cd, int height, int width, int common_number) {
  unsigned i = blockDim.x*blockIdx.x + threadIdx.x,
  j = blockDim.y*blockIdx.y + threadIdx.y;
  double sum = 0;

  for (int k=0; k < common_number; ++k)
    sum += Ad[i * common_number + k] * Bd[k * width + j];
  Cd[i * width + j] = sum;
}

void MatrixMulOnDevice(double **A, double **B, double **C, int height, int width, int common_number) {
  cudaEvent_t start, stop;
  float milliseconds = 0;

  cudaEventCreate(&start);
  cudaEventCreate(&stop);
  
  int sizeA = height * common_number * sizeof(double);
  int sizeB = common_number * width * sizeof(double);
  int size = height * width * sizeof(double);
  double *Ad, *Bd, *Cd;

  cudaMalloc(&Ad, sizeA);
  cudaMemcpy(Ad, A[0], sizeA, cudaMemcpyHostToDevice);
  cudaMalloc(&Bd, sizeB);
  cudaMemcpy(Bd, B[0], sizeB, cudaMemcpyHostToDevice);

  cudaMalloc(&Cd, size);

  dim3 blockSize(22, 22);
  dim3 dimGrid(height/blockSize.x + 1, width/blockSize.y +1);
  //dim3 dimBlock(height, width);

  cudaEventRecord(start);

  MatrixMulKernel<<<dimGrid, blockSize>>>(Ad, Bd, Cd, height, width, common_number);
  cudaDeviceSynchronize();

  cudaEventRecord(stop);

  cudaEventSynchronize(stop);
  cudaEventElapsedTime(&milliseconds, start, stop);

  cudaEventDestroy(start);
  cudaEventDestroy(stop);

  cudaMemcpy(C[0], Cd, size, cudaMemcpyDeviceToHost);

  cudaFree(Ad); cudaFree(Bd); cudaFree(Cd);

  printf("Time of GPU processing: %f\n", milliseconds);

}