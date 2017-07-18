# © Copyright 2010 - 2017 BlackTopp Studios Inc.
# This file is part of The Mezzanine Engine.
#
#    The Mezzanine Engine is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    The Mezzanine Engine is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with The Mezzanine Engine.  If not, see <http://www.gnu.org/licenses/>.
#
#   The original authors have included a copy of the license specified above in the
#   'Docs' folder. See 'gpl.txt'
#
#   We welcome the use of the Mezzanine engine to anyone, including companies who wish to
#   Build professional software and charge for their product.
#
#   However there are some practical restrictions, so if your project involves
#   any of the following you should contact us and we will try to work something
#   out:
#    - DRM or Copy Protection of any kind(except Copyrights)
#    - Software Patents You Do Not Wish to Freely License
#    - Any Kind of Linking to Non-GPL licensed Works
#    - Are Currently In Violation of Another Copyright Holder's GPL License
#    - If You want to change our code and not add a few hundred MB of stuff to
#        your distribution
#
#   These and other limitations could cause serious legal problems if you ignore
#   them, so it is best to simply contact us or the Free Software Foundation, if
#   you have any questions.
#
#   Joseph Toppi - toppij@gmail.com
#   John Blackwood - makoenergy02@gmail.com

########################################################################################################################
cmake_minimum_required(VERSION 2.8)

# The underscore at the end of this name is just to make the tests easier to read.
project(IdentifyTest_)
message(STATUS "${PROJECT_NAME} - Starting Configuration using CMake ${CMAKE_VERSION}.")

##########################################################################|#############################################
# Don't Download or Verify but setup the Jagati
include("${CMAKE_SOURCE_DIR}/../../Jagati.cmake")

ClaimParentProject()    # Tested Previously
CreateLocationVars()    # Tested Previously
CreateLocations()       # Tested Previously
DecideOutputNames()     # Tested Previously

IdentifyOS()                # Tested by TestIdentify#test_id_os
IdentifyCompiler()          # Tested by TestIdentify#test_id_compiler
IdentifyDebug()             # Tested by TestIdentify#test_id_debug
SetCommonCompilerFlags()    # Tested by TestIdentify#test_set_compiler_flags


# Everything above this line is a reasonable example of use.
##########################################################################|#############################################
# Everything below this lines is kind of crazy and done only for testing.

# Storing some values in the cache for testing. Testing the values of variables sounds off until you
# accept that variables are part of the API.
set(SystemIsLinux   "${SystemIsLinux}"      CACHE INTERNAL "Lifting SystemIsLinux for testing,")
set(SystemIsWindows "${SystemIsWindows}"    CACHE INTERNAL "Lifting SystemIsWindows for testing,")
set(SystemIsMacOSX  "${SystemIsMacOSX}"     CACHE INTERNAL "Lifting SystemIsMacOSX for testing,")
#set(SystemIsIOS     "${SystemIsIOS}"        CACHE INTERNAL "Lifting SystemIsIOS for testing,")

set(Platform32Bit   "${Platform32Bit}"      CACHE INTERNAL "Lifting Platform32Bit for testing,")
set(Platform64Bit   "${Platform64Bit}"      CACHE INTERNAL "Lifting Platform64Bit for testing,")

set(CompilerIsGCC           "${CompilerIsGCC}"         CACHE INTERNAL "Lifting CompilerIsGCC for testing,")
set(CompilerIsClang         "${CompilerIsClang}"       CACHE INTERNAL "Lifting CompilerIsClang for testing,")
set(CompilerIsIntel         "${CompilerIsIntel}"       CACHE INTERNAL "Lifting CompilerIsIntel for testing,")
set(CompilerIsMsvc          "${CompilerIsMsvc}"        CACHE INTERNAL "Lifting CompilerIsMsvc for testing,")
set(CompilerIsEmscripten    "${CompilerIsEmscripten}"  CACHE INTERNAL "Lifting CompilerIsEmscripten for testing,")

set(CompilerDesignNix   "${CompilerDesignNix}"  CACHE INTERNAL "Lifting CompilerDesignNix for testing,")
set(CompilerDesignMS    "${CompilerDesignMS}"   CACHE INTERNAL "Lifting CompilerDesignMS for testing,")

set(CompilerSupportsCoverage    "${CompilerSupportsCoverage}"
        CACHE INTERNAL "Lifting CompilerSupportsCoverage for testing,")
set(CompilerDetected            "${CompilerDetected}"
        CACHE INTERNAL "Lifting CompilerDetected for testing,")

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}"  CACHE INTERNAL "Lifting CMAKE_CXX_FLAGS for testing,")
