#include "math_utils.h"

int add(int a, int b)
{
    return a + b;
}

int multiply(int a, int b)
{
    return a * b;
}

double power(double base, int exp)
{
    if (exp == 0)
        return 1.0;
    double result = 1.0;
    for (int i = 0; i < exp; ++i)
    {
        result *= base;
    }
    return result;
}
