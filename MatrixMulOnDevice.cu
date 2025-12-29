#include <cuda_runtime.h>

__global__ void MatrixMulKernel (double *Ad, double *Bd, double *Cd, int height, int width, int common_number) {
  unsigned i = blockDim.x*blockIdx.x + threadIdx.x,
  j = blockDim.y*blockIdx.y + threadIdx.y;

  __shared__ double A_shared[484];
  __shared__ double B_shared[484];
  A_shared[i*common_number + j] = Ad[i*common_number + j];
  B_shared[i*width + j] = Bd[i*width + j];
  __syncthreads();
  Cd[i * width + j] = 0.0;
  for (int k=0; k < common_number; ++k)
    Cd[i * width + j] += A_shared[i * common_number + k] * B_shared[k * width + j];
}

void MatrixMulOnDevice(double **A, double **B, double **C, int height, int width, int common_number) {
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
  dim3 dimBlock(height, width);
  MatrixMulKernel<<<dimGrid, dimBlock>>>(Ad, Bd, Cd, height, width, common_number);
  cudaDeviceSynchronize();


  cudaMemcpy(C[0], Cd, size, cudaMemcpyDeviceToHost);

  cudaFree(Ad); cudaFree(Bd); cudaFree(Cd);

}