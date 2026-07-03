# Core static library — freestanding, deterministic C game core.
cmake_minimum_required(VERSION 3.20)

add_library(soi_core STATIC
    src/soi_rng.c
    src/soi_grid.c
    src/soi_physics.c
    src/soi_enemies.c
    src/soi_state.c
)

target_include_directories(soi_core PUBLIC include)

set_target_properties(soi_core PROPERTIES
    C_STANDARD 17
    C_STANDARD_REQUIRED ON
)

if (MSVC)
    target_compile_options(soi_core PRIVATE /W4)
else()
    target_compile_options(soi_core PRIVATE -Wall -Wextra -Wpedantic)
endif()
