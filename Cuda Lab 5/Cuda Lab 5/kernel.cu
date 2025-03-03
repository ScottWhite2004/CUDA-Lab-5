
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>


int main()
{
    const int heightA = 4;
    const int widthA = 3;
    const int heightB = 3;
    const int widthB = 2;

    const int matrixA[heightA][widthA] = {
        {1,2,3},
        {1,2,3},
        {1,2,3},
        {1,2,3}
    };
    const int matrixB[heightB][widthB] = {
        {1,2},
        {1,2},
        {1,2}
    };
    const int arraySizeC = heightA * widthB;
    int matrixC[heightA][widthB];

    for (int i = 0; i < heightA; i++)
    {
        for (int j = 0; j < widthB; j++)
        {
            matrixC[i][j] = 0;
            for (int idx = 0; idx < widthA; idx++)
            {
                matrixC[i][j] += matrixA[i][idx] * matrixB[idx][j];
            }
        }
    }

    printf("Matrix %d %d %d %d %d %d %d %d", matrixC[0][0], matrixC[0][1], matrixC[1][0], matrixC[1][1], matrixC[2][0], matrixC[2][1], matrixC[3][0], matrixC[3][1]);
    return 0;
}


