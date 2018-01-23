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
project(FileLists_BadSourceRoot_Test_)
message(STATUS "${PROJECT_NAME} - Starting Configuration using CMake ${CMAKE_VERSION}.")

##########################################################################|#############################################
# Don't Download or Verify but setup the Jagati
include("${CMAKE_SOURCE_DIR}/../../Jagati.cmake")

StandardJagatiSetup()


# Everything above this line is well tested.
########################################################################################################################

AddSourceFile("Hello.cpp")
AddSourceFile("${FileLists_BadSourceRoot_Test_RootDir}Hello2.cpp")# This line will fail because its misplaced.

AddHeaderFile("Hello.h")
AddHeaderFile("Hello2.h") 

AddJagatiDoxInput("HelloDoc.h")
AddSwigEntryPoint("HelloSwig.h")
AddTestClass("HelloTest")

# Can the coverage stuff consume lists correctly?
ChooseCodeCoverage("ON")
CreateCoverageTarget(Hello "Hello.cpp")

# Need to add default swig file and test


# Everything above this line is a reasonable example of use.
##########################################################################|#############################################
# Everything below this lines is kind of crazy and done only for testing.

# Storing some values in the cache for testing. Testing the values of variables sounds off until you
# accept that variables are part of the API.

set(${PROJECT_NAME}SourceFiles      "${${PROJECT_NAME}SourceFiles}" CACHE INTERNAL 
                                    "Lifting ${PROJECT_NAME}SourceFiles for testing,")
set(${PROJECT_NAME}HeaderFiles      "${${PROJECT_NAME}HeaderFiles}" CACHE INTERNAL 
                                    "Lifting ${PROJECT_NAME}HeaderFiles for testing,")
set(${PROJECT_NAME}TestClassList    "${${PROJECT_NAME}TestClassList}" CACHE INTERNAL 
                                    "Lifting ${PROJECT_NAME}TestClassList for testing,")
set(${PROJECT_NAME}TestHeaderList   "${${PROJECT_NAME}TestHeaderList}" CACHE INTERNAL 
                                    "Lifting ${PROJECT_NAME}TestHeaderList for testing,")
set(${PROJECT_NAME}SwigFiles        "${${PROJECT_NAME}SwigFiles}" CACHE INTERNAL 
                                    "Lifting ${PROJECT_NAME}SwigFiles for testing,")
set(JagatiDoxArray                  "${JagatiDoxArray}" CACHE INTERNAL 
                                    "Lifting JagatiDoxArray for testing,")
