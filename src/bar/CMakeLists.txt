find_package(gcov)

include_directories(../libfoo)
add_executable(bar bar.c)
target_link_libraries(bar foo)

add_test(bar_test ${CMAKE_CURRENT_BINARY_DIR}/bar)

add_coverage(bar)
