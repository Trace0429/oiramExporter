cmake_minimum_required (VERSION 2.6)
project (oiramExporter)

#add_definitions(-D_CRT_SECURE_NO_DEPRECATE)

set(CMAKE_DEBUG_POSTFIX "_d")

# http://stackoverflow.com/questions/7747857/in-cmake-how-do-i-work-around-the-debug-and-release-directories-visual-studio-2
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/bin)
foreach( OUTPUTCONFIG ${CMAKE_CONFIGURATION_TYPES} )
    string( TOUPPER ${OUTPUTCONFIG} OUTPUTCONFIG )
    set( CMAKE_RUNTIME_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${PROJECT_BINARY_DIR}/bin )
    set( CMAKE_LIBRARY_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${PROJECT_BINARY_DIR}/lib )
    set( CMAKE_ARCHIVE_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${PROJECT_BINARY_DIR}/lib )
endforeach( OUTPUTCONFIG CMAKE_CONFIGURATION_TYPES )

# TODO: switch max sdk
set(MAX_INC dependencies/MaxSDK/2014/include)
set(MAX_LIB dependencies/MaxSDK/2014/lib/x64/Release)

add_subdirectory(dependencies/FreeImage)
add_subdirectory(dependencies/nvidia-texture-tools)

add_subdirectory(OgreComponent)
add_subdirectory(oiramImpl)

add_dependencies(oiramImpl FreeImage)
add_dependencies(oiramImpl OgreComponent)
add_dependencies(oiramImpl nvtt)