# zmqae_add_external — Max/MSP external builder for zmq.algebraiceffect
#
# Adapted from bbb_external.cmake (prefix: zmqae_ instead of bbb_)
#
# usage (in source/projects/<name>/CMakeLists.txt):
#   zmqae_add_external(
#       [MACOS_ONLY]                    # macOS only (skip on Windows)
#       [WIN32_ONLY]                    # Windows only (skip on macOS)
#       [DEPS lib1 lib2 ...]            # extra target_link_libraries
#       [INCLUDES dir1 dir2 ...]        # extra target_include_directories
#       [SOURCES file1.cpp ...]         # extra sources (default: *.cpp glob)
#       [RPATH path]                    # BUILD_RPATH / INSTALL_RPATH
#   )

macro(zmqae_add_external)
    cmake_parse_arguments(ZMQAE_ARG
        "MACOS_ONLY;WIN32_ONLY"
        "RPATH"
        "DEPS;INCLUDES;SOURCES"
        ${ARGN}
    )

    # --- platform guard ---
    set(_zmqae_should_build TRUE)
    if(ZMQAE_ARG_MACOS_ONLY AND NOT APPLE)
        set(_zmqae_should_build FALSE)
    endif()
    if(ZMQAE_ARG_WIN32_ONLY AND NOT WIN32)
        set(_zmqae_should_build FALSE)
    endif()

    if(_zmqae_should_build)

    # --- min-api path resolution ---
    if(NOT DEFINED C74_MIN_API_DIR)
        if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/../../../deps/min-api")
            set(C74_MIN_API_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../../../deps/min-api")
        elseif(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/../../../extern/min-api")
            set(C74_MIN_API_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../../../extern/min-api")
        else()
            message(FATAL_ERROR "zmqae_add_external: C74_MIN_API_DIR not set and min-api not found")
        endif()
    endif()

    # --- output directory ---
    if(NOT DEFINED C74_LIBRARY_OUTPUT_DIRECTORY)
        set(C74_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/../../../externals")
    endif()

    # --- universal binary (macOS) ---
    if(APPLE AND NOT CMAKE_OSX_ARCHITECTURES)
        set(CMAKE_OSX_ARCHITECTURES "x86_64;arm64" CACHE STRING "" FORCE)
    endif()

    # --- collect sources ---
    if(ZMQAE_ARG_SOURCES)
        set(_zmqae_sources ${ZMQAE_ARG_SOURCES})
    else()
        file(GLOB _zmqae_sources CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/*.cpp")
    endif()

    # --- min-api pre-target ---
    include(${C74_MIN_API_DIR}/script/min-pretarget.cmake)

    # --- propagate directory-scope variables to parent scope ---
    foreach(_var CMAKE_MODULE_LINKER_FLAGS CMAKE_SHARED_LINKER_FLAGS
                 CMAKE_EXE_LINKER_FLAGS CMAKE_STATIC_LINKER_FLAGS
                 CMAKE_C_FLAGS CMAKE_CXX_FLAGS CMAKE_MSVC_RUNTIME_LIBRARY
                 CMAKE_LIBRARY_OUTPUT_DIRECTORY CMAKE_RUNTIME_OUTPUT_DIRECTORY
                 CMAKE_ARCHIVE_OUTPUT_DIRECTORY CMAKE_PDB_OUTPUT_DIRECTORY
                 CMAKE_COMPILE_PDB_OUTPUT_DIRECTORY
                 CMAKE_INTERPROCEDURAL_OPTIMIZATION CMAKE_POSITION_INDEPENDENT_CODE
                 CMAKE_OSX_DEPLOYMENT_TARGET)
        if(DEFINED ${_var})
            set(${_var} "${${_var}}" PARENT_SCOPE)
        endif()
        foreach(_config DEBUG RELEASE RELWITHDEBINFO MINSIZEREL
                       ${CMAKE_CONFIGURATION_TYPES} ${CMAKE_BUILD_TYPE})
            string(TOUPPER "${_config}" _config_upper)
            if(DEFINED ${_var}_${_config_upper})
                set(${_var}_${_config_upper} "${${_var}_${_config_upper}}" PARENT_SCOPE)
            endif()
        endforeach()
    endforeach()

    # --- build library ---
    add_library(${PROJECT_NAME} MODULE ${_zmqae_sources})

    # --- MSVC: report correct __cplusplus ---
    if(MSVC AND MSVC_VERSION GREATER_EQUAL 1914)
        target_compile_options(${PROJECT_NAME} PRIVATE $<$<COMPILE_LANGUAGE:CXX>:/Zc:__cplusplus>)
    endif()

    # --- include directories ---
    target_include_directories(${PROJECT_NAME} PRIVATE ${C74_INCLUDES})
    if(ZMQAE_ARG_INCLUDES)
        target_include_directories(${PROJECT_NAME} PRIVATE ${ZMQAE_ARG_INCLUDES})
    endif()

    # --- link dependencies ---
    if(ZMQAE_ARG_DEPS)
        target_link_libraries(${PROJECT_NAME} PRIVATE ${ZMQAE_ARG_DEPS})
    endif()

    # --- rpath ---
    if(ZMQAE_ARG_RPATH)
        set_target_properties(${PROJECT_NAME} PROPERTIES
            BUILD_RPATH "${ZMQAE_ARG_RPATH}"
            INSTALL_RPATH "${ZMQAE_ARG_RPATH}"
        )
    endif()

    # --- min-api post-target ---
    include(${C74_MIN_API_DIR}/script/min-posttarget.cmake)

    endif() # _zmqae_should_build

    # --- cleanup ---
    unset(_zmqae_sources)
    unset(_zmqae_should_build)
    unset(ZMQAE_ARG_MACOS_ONLY)
    unset(ZMQAE_ARG_WIN32_ONLY)
    unset(ZMQAE_ARG_RPATH)
    unset(ZMQAE_ARG_DEPS)
    unset(ZMQAE_ARG_INCLUDES)
    unset(ZMQAE_ARG_SOURCES)
    unset(ZMQAE_ARG_UNPARSED_ARGUMENTS)
    unset(ZMQAE_ARG_KEYWORDS_MISSING_VALUES)
endmacro()
