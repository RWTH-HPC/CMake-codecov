include_directories(../libfoo)
add_executable(bar bar.c)
target_link_libraries(bar foo)
