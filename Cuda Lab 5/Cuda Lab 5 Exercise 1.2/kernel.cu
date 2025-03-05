
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
    int heightD = 6;
    int widthD = 4;
    int heightE = 4;
    int widthE = 3;
    const int arraySizeD = heightD * widthD;
    const int arraySizeE = heightE * widthE;
    const int arraySizeF = heightD * widthE;
    const int arraySizeA = heightA * widthA;
    const int arraySizeB = heightB * widthB;
    const int arraySizeC = heightA * widthB;

    int* a, * b, * c, * d, * e, * f;

    cudaMallocManaged(&a, arraySizeA * sizeof(int));
    cudaMallocManaged(&b, arraySizeB * sizeof(int));
    cudaMallocManaged(&c, arraySizeC * sizeof(int));
    cudaMallocManaged(&d, arraySizeD * sizeof(int));
    cudaMallocManaged(&e, arraySizeE * sizeof(int));
    cudaMallocManaged(&f, arraySizeF * sizeof(int));

    for (int i = 0; i < arraySizeA; i++)
    {
        a[i] = i;
    }

    for (int i = 0; i < arraySizeB; i++)
    {
        b[i] = i;
    }
    for (int i = 0; i < arraySizeD; i++)
    {
        d[i] = i;
    }
    for (int i = 0; i < arraySizeE; i++)
    {
        e[i] = i;
    }

    addKernel << <1,dim3(2,4) >> > (c, a, b, widthA, widthB);
    addKernel << <1, dim3(3, 6) >> > (f, d, e, widthD, widthE);

    cudaDeviceSynchronize();



    printf("Dot product Matrix a and b \n%d %d \n%d %d \n%d %d \n%d %d\n", c[0], c[1], c[2], c[3], c[4], c[5], c[6], c[7]);
    printf("Dot product Matrix d and e \n%d %d %d \n%d %d %d \n%d %d %d \n%d %d %d \n%d %d %d \n%d %d %d\n ", f[0], f[1], f[2], f[3], f[4], f[5], f[6], f[7], f[8], f[9], f[10], f[11], f[12], f[13], f[14], f[15], f[16], f[17]);

    cudaFree(a);
    cudaFree(b);
    cudaFree(c);
    cudaFree(d);
    cudaFree(e);
    cudaFree(f);


    
    return 0;
}


