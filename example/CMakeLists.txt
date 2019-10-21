project(asio-zmq-examples)
cmake_minimum_required(VERSION 2.8)

# if (${CMAKE_CXX_COMPILER_ID} STREQUAL "Clang")
if( NOT ${CMAKE_COMPILER_IS_GNUCXX} )
  set(CMAKE_CXX_FLAGS "-Wall -std=c++11 -stdlib=libc++")
else ()
  set(CMAKE_CXX_FLAGS "-Wall -std=c++11")
endif ()

add_definitions(-DBOOST_ASIO_HAS_STD_CHRONO)

find_package(Boost REQUIRED COMPONENTS system)
# find_library(ZMQ_LIBRARY zmq REQUIRED)

file(GLOB example_SRCS "*.cpp")

include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}/../include
    ${Boost_INCLUDE_DIRS}
    )

foreach(SRC ${example_SRCS})
  get_filename_component(EXE ${SRC} NAME_WE)
  add_executable(${EXE} ${SRC})
  target_link_libraries(${EXE} ${Zeromq_LIBRARY} ${Boost_LIBRARIES} pthread)
endforeach()
