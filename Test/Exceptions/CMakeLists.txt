# © Copyright 2010 - 2020 BlackTopp Studios Inc.
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
cmake_minimum_required(VERSION 3.13)
project(Exception_Test_)
message(STATUS "${PROJECT_NAME} - Starting Configuration using CMake ${CMAKE_VERSION}.")

##########################################################################|#############################################
# Don't Download or Verify but include and setup the Jagati
include("${CMAKE_SOURCE_DIR}/../../Jagati.cmake")

StandardJagatiSetup()
IncludeJagatiPackage("Test")
IncludeJagatiPackage("StaticFoundation")

# Everything above this line is well tested.
########################################################################################################################

IntializeExceptions()

AddJagatiException("Animal" "Base" "Exception for all animals.")
AddJagatiException("Mammal" "Animal" "Is an animal exception, only warm blooded.")
AddJagatiException("Dog" "Mammal" "An exception for canids which are all mammals.")
AddJagatiException("Cat" "Mammal" "An exception for canids which are all mammals.")
AddJagatiException("Fish" "Animal" "An except for fish which are derived directly from mammal.")
EmitExceptionSource()
AddExceptionSource()


# Everything below this line is well tested.
########################################################################################################################

# Add all the kinds of source files a robust project might have.
AddSourceFile("Hello.cpp")

AddMainSourceFile("Main.cpp")

AddHeaderFile("Hello.h")

AddTestFile("HelloTest.h")

AddJagatiDoxInput("HelloDoc.h")
AddSwigEntryPoint("HelloSwig.h")

# Can the coverage and test stuff consume lists correctly?
ChooseCodeCoverage("OFF")
EmitTestCode()

# Add Useful targets
AddJagatiLibrary()
AddJagatiExecutable()
AddTestTarget()
CreateCoverageTarget(HelloCoverage "Hello.cpp")

# Everything above this line is a reasonable example of use.
##########################################################################|#############################################
# Everything below this lines is kind of crazy and done only for testing.

# Storing some values in the cache for testing. Testing the values of variables sounds off until you
# accept that variables are part of the API.
