cmake_minimum_required(VERSION 3.10)
project(scanmem VERSION 0.18.0 LANGUAGES C)

# 设置C标准
set(CMAKE_C_STANDARD 17)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(PACKAGE_BUGREPORT "https://github.com/scanmem/scanmem/issues")
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

if(APPLE)
    # macOS 特定配置
    set(LIBTOOL_COMMAND glibtoolize)
else()
    set(LIBTOOL_COMMAND libtoolize)
endif()

# 编译选项
add_compile_options(-Wall -Wextra)

# 配置选项
option(ENABLE_GUI "Build with GUI support" OFF)
option(ENABLE_PROCMEM "Enable /proc/pid/mem support" ON)

# 检查系统和依赖
include(CheckIncludeFile)
include(CheckFunctionExists)
include(CheckSymbolExists)
include(CheckTypeSize)
include(TestBigEndian)

# 检查必要的头文件
check_include_file(fcntl.h HAVE_FCNTL_H)
check_include_file(limits.h HAVE_LIMITS_H)
check_include_file(stddef.h HAVE_STDDEF_H)
check_include_file(sys/ioctl.h HAVE_SYS_IOCTL_H)
check_include_file(sys/time.h HAVE_SYS_TIME_H)

# 检查函数
check_function_exists(getline HAVE_GETLINE)
check_function_exists(fgetln HAVE_FGETLN)
check_function_exists(secure_getenv HAVE_SECURE_GETENV)

# 检查类型
check_type_size("int8_t" INT8_T)
check_type_size("int16_t" INT16_T)
check_type_size("int32_t" INT32_T)
check_type_size("int64_t" INT64_T)
check_type_size("uint8_t" UINT8_T)
check_type_size("uint16_t" UINT16_T)
check_type_size("uint32_t" UINT32_T)
check_type_size("uint64_t" UINT64_T)
check_type_size("off_t" OFF_T)
check_type_size("pid_t" PID_T)
check_type_size("size_t" SIZE_T)
check_type_size("ssize_t" SSIZE_T)
check_type_size("sighandler_t" HAVE_SIGHANDLER_T)

# 检查大小端
test_big_endian(IS_BIG_ENDIAN)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
# 查找依赖库
find_package(Readline REQUIRED)
find_package(PkgConfig REQUIRED)

# 配置头文件
configure_file(config.h.in ${CMAKE_CURRENT_BINARY_DIR}/config.h)
include_directories(${CMAKE_CURRENT_BINARY_DIR})

# 添加子目录
add_subdirectory(src)
add_subdirectory(test)

if(ENABLE_GUI)
    # add_subdirectory(gui) //todo:添加gui支持
    add_subdirectory(po)
endif()

# # 安装文档
# install(FILES README.md DESTINATION ${CMAKE_INSTALL_DOCDIR})
# install(FILES gpl-3.0.txt lgpl-3.0.txt DESTINATION ${CMAKE_INSTALL_DOCDIR})
# install(FILES scanmem.1 DESTINATION ${CMAKE_INSTALL_MANDIR}/man1)