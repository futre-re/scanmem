# 测试程序
add_executable(memfake memfake.c)
target_compile_options(memfake PRIVATE -std=gnu99 -Wall)

# 添加测试
add_test(NAME sm_test COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/sm_test.sh)