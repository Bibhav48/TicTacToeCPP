cmake_minimum_required(VERSION 3.10)
project(tictactoe)

# Set the C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# --- KEY CHANGE ---
# This line tells CMake to build a "universal" static library that works
# on both Apple Silicon (arm64) and Intel (x86_64) Macs.
set(CMAKE_OSX_ARCHITECTURES "arm64;x86_64")

# Add the source files to create the static library
add_library(tictactoe STATIC
    src/tictactoe.cpp
    src/tictactoe_c_api.cpp
)

# Make the 'src' directory available for header lookups
target_include_directories(tictactoe PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/src)
