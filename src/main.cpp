#include <iostream>
#include "math_utils.h"
#include "config.h"

int main()
{
    std::cout << "Math Program Version: " << VERSION << std::endl;
    std::cout << "3 + 4 = " << add(3, 4) << std::endl;
    std::cout << "3 * 4 = " << multiply(3, 4) << std::endl;
    std::cout << "2^3 = " << power(2, 3) << std::endl;
    return 0;
}