# 测试程序
add_executable(memfake memfake.c)
target_compile_options(memfake PRIVATE -std=gnu99 -Wall)

# 复制测试脚本到构建目录
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/sm_test.sh
               ${CMAKE_CURRENT_BINARY_DIR}/sm_test.sh COPYONLY)
               
# 确保脚本有执行权限
file(CHMOD ${CMAKE_CURRENT_BINARY_DIR}/sm_test.sh
     PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE
                 GROUP_READ GROUP_EXECUTE
                 WORLD_READ WORLD_EXECUTE)

# 添加测试
add_test(NAME sm_test COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/sm_test.sh)