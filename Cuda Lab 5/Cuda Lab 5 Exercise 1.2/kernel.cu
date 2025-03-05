
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>


__global__ void addKernel(int *c, int *a, int *b, int widthA,int widthB)
{
    int i = threadIdx.y;
    int j = threadIdx.x;
    int C_ij = i * blockDim.x + j;

    int tempC = 0;
    for (int k = 0; k < widthA; k++)
    {
        int i_A = i * widthA + k;
        int i_B = j + k * widthB;
        tempC += a[i_A] * b[i_B];
    }
    c[C_ij] = tempC;
}

int main()
{
    
    const int heightA = 4;
    int widthA = 3;
    const int heightB = 3;
    int widthB = 2;
    const int arraySizeA = heightA * widthA;
    const int arraySizeB = heightB * widthB;
    const int arraySizeC = heightA * widthB;

    int* a, * b, * c;

    cudaMallocManaged(&a, arraySizeA * sizeof(int));
    cudaMallocManaged(&b, arraySizeB * sizeof(int));
    cudaMallocManaged(&c, arraySizeC * sizeof(int));

    for (int i = 0; i < arraySizeA; i++)
    {
        a[i] = i;
    }

    for (int i = 0; i < arraySizeB; i++)
    {
        b[i] = i;
    }

    for (int i = 0; i < arraySizeC; i++)
    {
        c[i] = 0;
    }

    addKernel << <1,dim3(2,4) >> > (c, a, b, widthA, widthB);

    cudaDeviceSynchronize();



    printf("Dot product %d %d \n %d %d \n %d %d \n %d %d", c[0], c[1], c[2], c[3], c[4], c[5], c[6], c[7]);

    cudaFree(a);
    cudaFree(b);
    cudaFree(c);


    
    return 0;
}


