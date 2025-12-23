# Matrix_multiplication_on_CUDA
Matrix multiplication on CUDA 
  
## Технологии
**Стек технологий**  
Язык программирования С:  
CUDA  
  
**Ограничения**
Результирующая матрица должна быть размером менее 32X32
  
## Установка и запуск  
Компиляция - nvcc -arch=sm_75 MatrixMul.cu main.cu -o MatrixMul
Запуск - ./MatrixMul
