
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

    const int arraySizeA = heightA * heightB;
    const int arraySizeB = heightB * widthB;
    const int arraySizeC = heightA * widthB;



    


    return 0;
}


