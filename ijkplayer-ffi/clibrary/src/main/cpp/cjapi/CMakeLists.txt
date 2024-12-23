# the minimum version of CMake.
cmake_minimum_required(VERSION 3.4.1)
project(ijkplayer)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wno-int-conversion")

add_definitions(-DOHOS_PLATFORM)

add_library(ijkplayer_cjapi SHARED
            ijkplayer_cjapi.cpp
            )

include_directories(${CMAKE_CURRENT_SOURCE_DIR})
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/napi)

target_link_libraries(ijkplayer_cjapi PUBLIC ijkplayer_napi)

