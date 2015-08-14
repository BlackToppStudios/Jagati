# © Copyright 2014 - 2015 BlackTopp Studios inc
# Dawkin's Dilemma - A web application to play with the prisoner's
# dilemma as described by Dawkins in the Selfish Gene.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

# Feel free to contact the developers at that following
# Joseph Toppi - toppij@blacktoppstudios.com
# John Blackwood - blackwoodj@blacktoppstudios.com

project(Jagati)
cmake_minimum_required(VERSION 2.8)

message ("${PROJECT_NAME} - Starting Configuration.")

##############################################################################
# Mezzanine helper variables
set(ProjectRootDir ${${PROJECT_NAME}_SOURCE_DIR}/)
Message(STATUS "Using Source From: ${ProjectRootDir}")

set(ProjectBinaryDir ${${PROJECT_NAME}_BINARY_DIR}/)
Message(STATUS "Putting all major output in: ${ProjectBinaryDir}")

##############################################################################
# Source Files

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -pedantic -Wextra -std=c++11")

set(SRC_LIST
    "src/action.cpp"
    "src/actions/exitaction.cpp"
    "src/actions/menuaction.cpp"
    "src/actions/viewpackage.cpp"
    "src/binarybuffer.cpp"
    "src/datatypes.cpp"
    "src/dependency.cpp"
    "src/githubmezzaninepackage.cpp"
    "src/insourcebinarypackage.cpp"
    "src/main.cpp"
    "src/menu.cpp"
    "src/package.cpp"
    "src/resourceutilities.cpp"
    "src/stringtool.cpp"
    "src/tests.cpp"
    "src/version.cpp"
)

set(HEADER_LIST
    "src/action.h"
    "src/actions/exitaction.h"
    "src/actions/menuaction.h"
    "src/actions/viewpackage.h"
    "src/binarybuffer.h"
    "src/crossplatformexport.h"
    "src/datatypes.h"
    "src/dependency.h"
    "src/githubmezzaninepackage.h"
    "src/insourcebinarypackage.h"
    "src/indexer.h"
    "src/main.h"
    "src/package.h"
    "src/resourceutilities.h"
    "src/stringtool.h"
    "src/tests.h"
    "src/version.h"
)

##############################################################################
# Find Mezzanine Packages

File(GLOB Packages "packages/"  "packages/*.h")

message(STATUS "Looking for Packages")
foreach(CurrentFileName ${Packages})
    message(STATUS "   Found - ${CurrentFileName}")
    String(REGEX MATCH "/([^/]*)\\.h$" DirtyName "${CurrentFileName}")
    String(LENGTH ${DirtyName} DirtyNameLength)
    MATH(EXPR TargetLength "${DirtyNameLength} - 3")
    String(SUBSTRING "${DirtyName}" "1" "${TargetLength}" TargetName)
    #message (${TargetLength})
    #message (${DirtyName})
    #message("${TargetName}")
    list(APPEND FoundPackages ${TargetName})
endforeach(CurrentFileName ${Packages})

message(STATUS "Found packages: ")
foreach(CurrentPackage ${FoundPackages})
    message(STATUS "   ${CurrentPackage}")
endforeach(CurrentPackage ${FoundPackages})

message(STATUS "Generating Preparing Source to Load Package Data: ")
foreach(CurrentTest ${FoundPackages})
    set(CppIncludes "${CppIncludes}
    #include \"${CurrentTest}.h\" ")

    set(CppInstantiations "${CppInstantiations}
    ${CurrentTest} ${CurrentTest}Implementation;")

    set(CppNameRegistration "${CppNameRegistration}
            Packages.push_back(&${CurrentTest}Implementation);")
endforeach(CurrentTest ${FoundTests})

configure_file( "${ProjectRootDir}/input/autodetect.h.in"  "${ProjectBinaryDir}/GeneratedHeaders/autodetect.h")
include_directories(
  "${ProjectBinaryDir}/GeneratedHeaders"
  "src/"
  "packages/"
  "src/tclap-1.2.1/include"
)

##############################################################################
# Detect Platform and pass to crossplatformexport

if(${WIN32})
    add_definitions( -DWINDOWS )
endif(${WIN32})

if(${CMAKE_SYSTEM_NAME} MATCHES "Linux")
    add_definitions( -DLINUX )
endif(${CMAKE_SYSTEM_NAME} MATCHES "Linux")

if(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
    add_definitions( -DMACOSX )
endif(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")

##############################################################################
# Defining the one and only Executable

add_executable(${PROJECT_NAME} ${SRC_LIST} ${HEADER_LIST} ${Packages} "${ProjectBinaryDir}/GeneratedHeaders/autodetect.h")
