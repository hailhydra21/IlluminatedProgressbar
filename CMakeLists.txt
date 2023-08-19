cmake_minimum_required(VERSION 3.16)

project(IlluminatedProgressbar VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(app_icon_resource_windows "${CMAKE_CURRENT_SOURCE_DIR}/AppProperty.rc")

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick)

########    获取 qml 文件    ########
file(GLOB_RECURSE QML_PATHS ${CMAKE_CURRENT_SOURCE_DIR}/*.qml)

foreach(filepath ${QML_PATHS})
    message(${filepath} "   " ${CMAKE_CURRENT_SOURCE_DIR})
    string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" filename ${filepath}) #.+/(.+)\\\\..*" "\\\\1
    list(APPEND QML_FILE ${filename})
endforeach(filepath)

list(REMOVE_DUPLICATES QML_FILE) #表示删除非第一个重名值

########    获取 img 文件    ########
file(GLOB_RECURSE IMG_PATHS *.ico *.png *.jpg *.jpeg *.svg *.qsb *.frag *.vert)

foreach(filepath ${IMG_PATHS})
    string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" filename ${filepath}) #.+/(.+)\\\\..*" "\\\\1
    list(APPEND IMG_FILES ${filename})
    #message(${filename})
endforeach(filepath)

list(REMOVE_DUPLICATES IMG_FILES)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appIlluminatedProgressbar
    main.cpp
    ${app_icon_resource_windows}
)

qt_add_qml_module(appIlluminatedProgressbar
    URI IlluminatedProgressbar
    VERSION 1.0
    QML_FILES ${QML_FILE}
    RESOURCES ${IMG_FILES}
)

set_target_properties(appIlluminatedProgressbar PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER my.example.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appIlluminatedProgressbar
    PRIVATE Qt6::Quick
)

install(TARGETS appIlluminatedProgressbar
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
