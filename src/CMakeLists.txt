include(GNUInstallDirs)
# 基础编译选项
add_compile_options(-std=gnu99 -Wall)

# 工具库 (对应 libutil.la)
add_library(util STATIC
    common.h
    common.c
    show_message.c
)

# libscanmem (对应 libscanmem.la)
set(LIBSCANMEM_HEADERS
    commands.h
    list.h
    maps.h
    scanmem.h
    scanroutines.h
    show_message.h
    targetmem.h
    value.h
)

set(LIBSCANMEM_SOURCES
    commands.c
    ptrace.c
    handlers.h
    handlers.c
    interrupt.h
    interrupt.c
    licence.h
    maps.c
    scanmem.c
    scanroutines.c
    sets.h
    sets.c
    targetmem.c
    value.c
)

# 条件编译源文件
if(NOT HAVE_GETLINE)
    list(APPEND LIBSCANMEM_SOURCES 
        getline.h
        getline.c
    )
endif()

# 构建共享库
add_library(scanmem SHARED ${LIBSCANMEM_SOURCES})
target_link_libraries(scanmem PRIVATE util)
set_target_properties(scanmem PROPERTIES
    VERSION 1.0.0
    SOVERSION 1
    EXPORT_SYMBOLS_REGEX "^sm_"
)

# CLI程序 (对应 scanmem binary)
set(SCANMEM_SOURCES
    menu.h
    menu.c
    main.c
)

if(NOT WITH_READLINE)
    list(APPEND SCANMEM_SOURCES
        readline.h
        readline.c
    )
endif()

# 构建CLI程序
add_executable(scanmem_cli ${SCANMEM_SOURCES})
target_link_libraries(scanmem_cli PRIVATE util scanmem)
set_target_properties(scanmem_cli PROPERTIES OUTPUT_NAME scanmem)

# 安装配置
install(TARGETS scanmem scanmem_cli
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

# 安装头文件 (对应 libscanmem_la_include_HEADERS)
install(FILES ${LIBSCANMEM_HEADERS}
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/scanmem
)

# 安装手册页
install(FILES 
    ${CMAKE_SOURCE_DIR}/scanmem.1
    DESTINATION ${CMAKE_INSTALL_MANDIR}/man1
)

# 安装项目说明文档
install(FILES 
    ${CMAKE_SOURCE_DIR}/README
    DESTINATION ${CMAKE_INSTALL_DOCDIR}
)