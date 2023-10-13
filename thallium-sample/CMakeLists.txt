cmake_minimum_required(VERSION 3.10)

# set the project name
project(Thallium-App)

find_package(PkgConfig REQUIRED)
pkg_check_modules(THALLIUM REQUIRED IMPORTED_TARGET thallium)
link_libraries(PkgConfig::THALLIUM)
add_compile_options(-O -g -Wall)

set(CMAKE_MACOSX_RPATH 1)
SET(CMAKE_SKIP_BUILD_RPATH FALSE)
SET(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)
SET(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)

# add the executable
add_executable(server server.cc)
add_executable(client client.cc)

install(TARGETS server client)
