# FindReadline.cmake
# 查找readline库

find_path(READLINE_INCLUDE_DIR readline/readline.h)
find_library(READLINE_LIBRARY NAMES readline)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Readline
    REQUIRED_VARS READLINE_LIBRARY READLINE_INCLUDE_DIR
)

if(READLINE_FOUND AND NOT TARGET Readline::Readline)
    add_library(Readline::Readline UNKNOWN IMPORTED)
    set_target_properties(Readline::Readline PROPERTIES
        IMPORTED_LOCATION "${READLINE_LIBRARY}"
        INTERFACE_INCLUDE_DIRECTORIES "${READLINE_INCLUDE_DIR}"
    )
endif()

mark_as_advanced(READLINE_INCLUDE_DIR READLINE_LIBRARY)