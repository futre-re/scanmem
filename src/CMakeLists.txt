# 工具库，静态链接到sm和libsm
add_library(util STATIC
    common.h
    common.c
    show_message.c
)

# libscanmem
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

# 如果没有getline函数，添加我们自己的实现
if(NOT HAVE_GETLINE)
    list(APPEND LIBSCANMEM_SOURCES getline.h getline.c)
endif()

add_library(scanmem SHARED ${LIBSCANMEM_SOURCES})
target_link_libraries(scanmem PRIVATE util)
set_target_properties(scanmem PROPERTIES
    VERSION 1.0.0
    SOVERSION 1
    EXPORT_SYMBOLS_REGEX "^sm_"
)

# 安装头文件
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

install(FILES ${LIBSCANMEM_HEADERS} DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/scanmem)

# scanmem CLI
set(SCANMEM_SOURCES
    menu.h
    menu.c
    main.c
)

# 如果没有readline，添加我们自己的实现
if(NOT WITH_READLINE)
    list(APPEND SCANMEM_SOURCES readline.h readline.c)
endif()

add_executable(scanmem_cli ${SCANMEM_SOURCES})
target_link_libraries(scanmem_cli PRIVATE util scanmem ${READLINE_LIBRARIES})
set_target_properties(scanmem_cli PROPERTIES OUTPUT_NAME scanmem)

# 安装
install(TARGETS scanmem scanmem_cli
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)