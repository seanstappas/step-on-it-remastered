# bridge/CMakeLists.txt — builds the GDExtension (.dll/.so): godot-cpp + the C
# core + this thin wrapper. Requires godot-cpp cloned into bridge/godot-cpp
# (git submodule) and a C++17 compiler CMake recognizes (MSVC/Clang/GCC).
cmake_minimum_required(VERSION 3.22)
project(soi_bridge CXX C)

# godot-cpp (matched to Godot 4.3)
add_subdirectory(godot-cpp)

# the freestanding C core
add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/../core ${CMAKE_BINARY_DIR}/core)

add_library(soi_bridge SHARED
    src/register_types.cpp
    src/soi_bridge.cpp
)

target_include_directories(soi_bridge PRIVATE ../core/include)
target_link_libraries(soi_bridge PRIVATE godot-cpp soi_core)

set_target_properties(soi_bridge PROPERTIES
    CXX_STANDARD 17
    CXX_STANDARD_REQUIRED ON
    PREFIX ""
    # The .gdextension expects this exact name in godot_project/bin/.
    OUTPUT_NAME "soi_bridge.windows.template_debug.x86_64"
)

# Drop the built extension where the Godot project loads it from.
add_custom_command(TARGET soi_bridge POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_SOURCE_DIR}/../godot_project/bin
    COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:soi_bridge> ${CMAKE_SOURCE_DIR}/../godot_project/bin/
)
