cmake_minimum_required(VERSION 3.19)
cmake_policy(SET CMP0091 NEW)

# Must be set before project() so all sub-projects (libzmq etc.) inherit it
if(APPLE)
    set(CMAKE_OSX_ARCHITECTURES "x86_64;arm64" CACHE STRING "" FORCE)
endif()
# Max externals require static CRT (/MT) on Windows
if(MSVC)
    set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded" CACHE STRING "" FORCE)
endif()

project(zmq.algebraiceffect LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD_EXTENSIONS OFF)

# --- Suppress tests/examples in all dependencies ---
set(ZMQ_BUILD_TESTS OFF CACHE BOOL "" FORCE)
set(ENABLE_CURVE OFF CACHE BOOL "" FORCE)
set(ENABLE_DRAFTS OFF CACHE BOOL "" FORCE)
set(CPPZMQ_BUILD_TESTS OFF CACHE BOOL "" FORCE)
set(ZMQAE_BUILD_TESTS OFF CACHE BOOL "" FORCE)
set(ZMQAE_BUILD_EXAMPLES OFF CACHE BOOL "" FORCE)
set(JSON_BuildTests OFF CACHE BOOL "" FORCE)
set(BUILD_SHARED OFF CACHE BOOL "" FORCE)

# --- zmq-algebraiceffect (header-only library + C API wrapper) ---
set(ZMQAE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/deps/zmq-algebraiceffect")
add_subdirectory(${ZMQAE_DIR})

# C API static library — links against static libzmq for self-contained Max externals
# We bypass the zmqae INTERFACE library here because it references the shared libzmq
# target which is incompatible with universal binary (fat) builds.
add_library(zmqae_c_api STATIC "${ZMQAE_DIR}/src/c_api.cpp")
target_include_directories(zmqae_c_api PUBLIC
    "${ZMQAE_DIR}/include"
    "${ZMQAE_DIR}/extern/cppzmq"
    "${ZMQAE_DIR}/extern/json/single_include"
    "${ZMQAE_DIR}/extern/spdlog/include"
    "${ZMQAE_DIR}/extern/libzmq/include"
)
target_link_libraries(zmqae_c_api PUBLIC libzmq-static)
# Force static CRT and UTF-8 on MSVC
if(MSVC)
    set_property(TARGET zmqae_c_api PROPERTY MSVC_RUNTIME_LIBRARY "MultiThreaded")
    target_compile_options(zmqae_c_api PRIVATE /utf-8)
    if(MSVC_VERSION GREATER_EQUAL 1914)
        target_compile_options(zmqae_c_api PRIVATE $<$<COMPILE_LANGUAGE:CXX>:/Zc:__cplusplus>)
    endif()
endif()

# --- Load zmqae_add_external() ---
include("${CMAKE_CURRENT_SOURCE_DIR}/cmake/zmqae_external.cmake")

# --- Output directory ---
set(C74_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/externals")

# --- Auto-discover external projects ---
MACRO(SUBDIRLIST result curdir)
    FILE(GLOB children RELATIVE ${curdir} ${curdir}/*)
    SET(dirlist "")
    FOREACH(child ${children})
        IF(IS_DIRECTORY ${curdir}/${child})
            LIST(APPEND dirlist ${child})
        ENDIF()
    ENDFOREACH()
    SET(${result} ${dirlist})
ENDMACRO()

SUBDIRLIST(PROJECT_DIRS "${CMAKE_CURRENT_SOURCE_DIR}/source/projects")
foreach(project_dir ${PROJECT_DIRS})
    if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/source/projects/${project_dir}/CMakeLists.txt")
        message("Generating: ${project_dir}")
        add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/source/projects/${project_dir}")
    endif()
endforeach()

set(CMAKE_SUPPRESS_REGENERATION true)
