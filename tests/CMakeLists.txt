# Host verification/dev harness linking the core.
add_executable(soi_harness harness.c)
target_link_libraries(soi_harness PRIVATE soi_core)

set_target_properties(soi_harness PROPERTIES C_STANDARD 17 C_STANDARD_REQUIRED ON)

add_test(NAME harness COMMAND soi_harness)
