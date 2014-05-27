CMAKE_MINIMUM_REQUIRED(VERSION 2.6)

project(OpenTerra)

SET(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/modules")

file(GLOB Source
  "src/*.cxx"
)

find_package(SFML 2 REQUIRED system window graphics network audio)

include_directories(include)

add_executable(bin/OpenTerra ${Source})

if(SFML_FOUND)
  include_directories(${SFML_INCLUDE_DIR})
  make_directory(bin)
  target_link_libraries(bin/OpenTerra ${SFML_LIBRARIES})
else()
  message("SFML Not found!  Aborting!")
endif()
