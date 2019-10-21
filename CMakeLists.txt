cmake_minimum_required(VERSION 3.15)

project(ASIO-ZMQ CXX)
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED 11)

list(APPEND CMAKE_PREFIX_PATH "/usr/local/boost")
#list(APPEND CMAKE_PREFIX_PATH "/usr/local/libzmq")
#list(APPEND CMAKE_PREFIX_PATH "/usr/local/zeromq")
#find_package(Zmq REQUIRED)
#include_directories(${Zmq_INCLUDE_DIR})
find_package(Zeromq REQUIRED)
include_directories(${Zeromq_INCLUDE_DIR})

add_subdirectory(example)

add_subdirectory(test/performance)

# install(TARGETS ${TARGET} LIBRARY DESTINATION "lib" ARCHIVE DESTINATION "lib")
install(DIRECTORY include/ DESTINATION "include" FILES_MATCHING PATTERN "*.hpp")
