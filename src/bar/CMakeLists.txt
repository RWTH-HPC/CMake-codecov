include_directories(../libfoo)
add_executable(bar bar.c)
target_link_libraries(bar foo)

add_test(test1 ${CMAKE_CURRENT_BINARY_DIR}/bar)
add_test(test1 ${CMAKE_CURRENT_BINARY_DIR}/bar secondparam)

find_package(codecov)
add_coverage(bar)
