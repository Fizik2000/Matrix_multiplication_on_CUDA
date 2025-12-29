# Matrix_multiplication_on_CUDA
Matrix multiplication on CUDA 

## О проекте
Запуск кода осуществляется на нескольких блоках  
Формат входных данных - файл inputMatrix.txt  
Формат выходных данных - стандартный поток stdout  
  
## Технологии
**Стек технологий**  
Язык программирования С:  
CUDA  
  
**Ограничения**
Отсутствует проверка на входные параметры
  
## Установка и запуск  
Компиляция - nvcc -arch=sm_75 MatrixMul.cu main.cu -o MatrixMul
Запуск - ./MatrixMul
