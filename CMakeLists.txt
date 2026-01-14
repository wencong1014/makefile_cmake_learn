cmake_minimum_required(VERSION 3.10)
project(MathProject VERSION 1.0.0)

# 设置C++标准
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 包含目录
include_directories(include)

# 添加可执行文件
add_executable(math_app 
    src/main.cpp
    src/math_utils.cpp
)

# 添加测试可执行文件
add_executable(math_test
    tests/test_math.cpp
    src/math_utils.cpp
)