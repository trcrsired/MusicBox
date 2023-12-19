cmake_minimum_required(VERSION 3.22)

project(datasource)

set(CMAKE_CXX_STANDARD 23)

include_directories(${CSV_PARSER_DIR}/single_include)
include_directories(${FAST_IO_DIR}/include)

add_library(parsermain OBJECT src/parser.cc)
target_precompile_headers(parsermain PRIVATE src/pch.hpp)

add_executable(parser
	$<TARGET_OBJECTS:parsermain>)
target_link_libraries(parser ntdll)

install(TARGETS parser)
