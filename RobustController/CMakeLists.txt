cmake_minimum_required(VERSION 3.17)
project(RobustController C)

set(CMAKE_C_STANDARD 99)

set(SOURCE_FILES main.c robust_controller.c)
add_executable(RobustController ${SOURCE_FILES})