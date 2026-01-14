#include <iostream>
#include <math_utils.h>

int main()
{
    if (add(2, 3) != 5)
    {
        std::cout << "Test failed: 2 + 3 != 5" << std::endl;
        return 1;
    }
    if (multiply(3, 4) != 12)
    {
        std::cout << "Test failed: 3 * 4 != 12" << std::endl;
        return 1;
    }
    std::cout << "All tests passed!" << std::endl;
    return 0;
}