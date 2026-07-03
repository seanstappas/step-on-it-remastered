# Top-level build for the Step On It! remaster native side.
# Builds the C core (and, later, the C++ godot-cpp bridge). The Godot front-end
# and tooling are built separately.
cmake_minimum_required(VERSION 3.20)
project(step_on_it_remastered C)

add_subdirectory(core)

# Verification/dev harness (host tool that links the core and replays fixtures).
enable_testing()
add_subdirectory(tests)
