
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>


__global__ void addKernel(int *c, const int *a, const int *b, const int *widthA,const int *widthB)
{
    int i = threadIdx.y;
    int j = threadIdx.x;
    int C_ij = i * blockDim.x + j;

    int tempC = 0;
    for (int k = 0; k < *widthA; k++)
    {
        int i_A = i * *widthA + k;
        int i_B = j + k * *widthB;
        tempC += a[i_A] * b[i_B];
    }
    c[C_ij] = tempC;
    
}

int main()
{
    
    const int heightA = 4;
    const int widthA = 3;
    const int heightB = 3;
    const int widthB = 2;
    const int arraySizeA = heightA * widthA;
    const int arraySizeB = heightB * widthB;
    const int arraySizeC = heightA * widthB;

    const int a[arraySizeA] = { 1,2,3,1,2,3,1,2,3,1,2,3 };
    const int b[arraySizeB] = { 1,2,1,2,1,2 };
    int c[arraySizeC] = { 0 };
    
    int* dev_a, * dev_b, * dev_c;
    int* dev_widA, *dev_widB;

    cudaMalloc(&dev_a, arraySizeA * sizeof(int));
    cudaMalloc(&dev_b, arraySizeB * sizeof(int));
    cudaMalloc(&dev_c, arraySizeC * sizeof(int));
    cudaMalloc(&dev_widA, sizeof(int));
    cudaMalloc(&dev_widB, sizeof(int));

    cudaMemcpy(dev_a, a, arraySizeA * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(dev_b, b, arraySizeB * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(dev_widA, &widthA, arraySizeA * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(dev_widB, &widthB, arraySizeB * sizeof(int), cudaMemcpyHostToDevice);

    addKernel << <8,8>> > (dev_a, dev_b, dev_c, dev_widA, dev_widB);

    cudaMemcpy(c, dev_c, arraySizeC * sizeof(int), cudaMemcpyDeviceToHost);

    cudaDeviceSynchronize();

    printf("Dot product %d", c[1]);

    cudaFree(dev_a);
    cudaFree(dev_b);
    cudaFree(dev_c);
    cudaFree(dev_widA);
    cudaFree(dev_widB);
    
    return 0;
}


