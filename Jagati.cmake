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

# This will be the basic package manager for the Mezzanine, called the Jagati. This will track and download packages
# from git repositories. This will handle centrally locating Mezzanine packages and provide tools for finding and
# linking against them appropriately. This will not be included directly in git repos, but rather a small download
# snippet with ensure this stays up to date.

# # Do something like this to include the Jagati. Try to use the newest version and
# # get the checksum from the repo before using it.
# set(JagatiChecksum "ae061311fcc4ecca287e7e7df38f9f52fbacc2060946f92bdece21\
# d86584f1de152c59a7181992a30365c07bb58772f3dadef38adbb4b15c305429a1b966f314")
# file(DOWNLOAD
#     "https://raw.githubusercontent.com/BlackToppStudios/Jagati/0.12.1/Jagati.cmake"
#     "${${PROJECT_NAME}_BINARY_DIR}/Jagati.cmake"
#     EXPECTED_HASH SHA512=${JagatiChecksum}
# )

########################################################################################################################
########################################################################################################################
# From Here to the next thick banner exist a series of simple checks and variables to act as baseline assumptions for
# the rest of the Jagati, so it can perform complex things confidently.
########################################################################################################################
########################################################################################################################

########################################################################################################################
# Basic Sanity Checks the Jagati enforces

# Break if some fool tries to build in his source directory.
if("${CMAKE_SOURCE_DIR}" STREQUAL "${CMAKE_BINARY_DIR}")
    message(FATAL_ERROR "Prevented in source tree build. Please create a build directory outside of"
                        " the Mezzanine source code and have cmake build from there.")
endif("${CMAKE_SOURCE_DIR}" STREQUAL "${CMAKE_BINARY_DIR}")

# Allow using versions of CMake back to 3.0 even with policy changes.
cmake_minimum_required(VERSION 3.0)
if("${CMAKE_VERSION}" VERSION_GREATER "3.1.0")
    message(STATUS "Setting comparison policy for newer versions of CMake. Using CMP0054.")
    cmake_policy(SET CMP0054 NEW)
else("${CMAKE_VERSION}" VERSION_GREATER "3.1.0")
    message(STATUS "NOT setting comparison policy for newer versions of CMake. Not using CMP0054.")
endif("${CMAKE_VERSION}" VERSION_GREATER "3.1.0")

########################################################################################################################
# Package URLs
set(Mezz_StaticFoundation_GitURL "https://github.com/BlackToppStudios/Mezz_StaticFoundation.git")
set(Mezz_Test_GitURL "https://github.com/BlackToppStudios/Mezz_Test.git")
set(Mezz_Foundation_GitURL "https://github.com/BlackToppStudios/Mezz_Foundation.git")

########################################################################################################################
# Other Variables

set(MEZZ_Copyright
"// © Copyright 2010 - 2017 BlackTopp Studios Inc.\n\
/* This file is part of The Mezzanine Engine.\n\
\n\
    The Mezzanine Engine is free software: you can redistribute it and/or modify\n\
    it under the terms of the GNU General Public License as published by\n\
    the Free Software Foundation, either version 3 of the License, or\n\
    (at your option) any later version.\n\
\n\
    The Mezzanine Engine is distributed in the hope that it will be useful,\n\
    but WITHOUT ANY WARRANTY; without even the implied warranty of\n\
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n\
    GNU General Public License for more details.\n\
\n\
    You should have received a copy of the GNU General Public License\n\
    along with The Mezzanine Engine.  If not, see <http://www.gnu.org/licenses/>.\n\
*/\n\
/* The original authors have included a copy of the license specified above in the\n\
   'Docs' folder. See 'gpl.txt'\n\
*/\n\
/* We welcome the use of the Mezzanine engine to anyone, including companies who wish to\n\
   Build professional software and charge for their product.\n\
\n\
   However there are some practical restrictions, so if your project involves\n\
   any of the following you should contact us and we will try to work something\n\
   out:\n\
    - DRM or Copy Protection of any kind(except Copyrights)\n\
    - Software Patents You Do Not Wish to Freely License\n\
    - Any Kind of Linking to Non-GPL licensed Works\n\
    - Are Currently In Violation of Another Copyright Holder's GPL License\n\
    - If You want to change our code and not add a few hundred MB of stuff to\n\
        your distribution\n\
\n\
   These and other limitations could cause serious legal problems if you ignore\n\
   them, so it is best to simply contact us or the Free Software Foundation, if\n\
   you have any questions.\n\
\n\
   Joseph Toppi - toppij@gmail.com\n\
   John Blackwood - makoenergy02@gmail.com\n\
*/\n\n"
)

########################################################################################################################
# Require external packages.

include(CTest)
include(ExternalProject)

########################################################################################################################
########################################################################################################################
# From Here to the next thick banner exist macros to set variables in the scope of the calling CMakeList Project that
# all Jagati packages should set. The idea is that every variable needed to link or inspect the source will be cleanly
# set and easily inspectable, from just the output of cmake and a sample CMakeLists.txt.
########################################################################################################################
########################################################################################################################

########################################################################################################################
# ClaimParentProject
#
# This is used to determine what the parentmost project is. Whichever project calls this first will be presumed to be
# the parentmost scope and be the only one that doesn't set all of it's variables in its parent's scope.
#
# This is also used to initialize a few internal variable that need to only be initilized once.
#
# Usage:
#   # Be certain to call project() before calling this.
#   # Call this from the main project before calling anything else to insure your project is root.
#   ClaimParentProject()
#
# Result:
#   The ParentProject variable will all be set, made available, printed and other Jagati projects
#   will know not to pollute your namespace:
#
#   This also initializes a the following which are use by sother functions and macros in the
#   jagati and need to be initialized at the root level.
#       JagatiLinkArray

macro(ClaimParentProject)
    if(ParentProject)
        # It is already set so we must be a child.
        message(STATUS "Project '${PROJECT_NAME}' acknowledges '${ParentProject}' as the Parent Project.")
    else(ParentProject)
        message(STATUS "Claiming '${PROJECT_NAME}' as the Parent Project.")
        set(ParentProject "${PROJECT_NAME}" CACHE INTERNAL "Name of the parent project")
        set(JagatiLinkArray ""  CACHE INTERNAL "Am empty list of names to link against")
    endif(ParentProject)
endmacro(ClaimParentProject)

########################################################################################################################
# CreateLocationVars
#
# This will create a number of variables in the Scope of the calling script that correspond to the name of the Project
# so that they can readily be referenced from other project including the caller as a subproject.
#
# Usage:
#   # Be certain to call project before calling this.
#   CreateLocationVars()
#
# Result:
#   The following variables will all be set to some valid folder, made available and printed:
#
#       ${PROJECT_NAME}BinaryDir
#       ${PROJECT_NAME}GenHeadersDir
#       ${PROJECT_NAME}GenSourceDir
#
#       ${PROJECT_NAME}RootDir
#       ${PROJECT_NAME}DoxDir
#       ${PROJECT_NAME}IncludeDir
#       ${PROJECT_NAME}LibDir
#       ${PROJECT_NAME}SourceDir
#       ${PROJECT_NAME}SwigDir
#       ${PROJECT_NAME}TestDir
#

macro(CreateLocationVars)
    message(STATUS "Creating Location Variables for '${PROJECT_NAME}'")

    #######################################
    # Derived Output Folders
    set(${PROJECT_NAME}BinaryDir "${${PROJECT_NAME}_BINARY_DIR}/" CACHE INTERNAL "" FORCE)

    set(${PROJECT_NAME}GenHeadersDir "${${PROJECT_NAME}BinaryDir}config/" CACHE INTERNAL "" FORCE)
    set(${PROJECT_NAME}GenSourceDir "${${PROJECT_NAME}BinaryDir}generated_source/" CACHE INTERNAL "" FORCE)

    #######################################
    # Derived Input Folders
    set(${PROJECT_NAME}RootDir "${${PROJECT_NAME}_SOURCE_DIR}/" CACHE INTERNAL "" FORCE)

    set(${PROJECT_NAME}DoxDir "${${PROJECT_NAME}RootDir}dox/" CACHE INTERNAL "" FORCE)
    set(${PROJECT_NAME}IncludeDir "${${PROJECT_NAME}RootDir}include/" CACHE INTERNAL "" FORCE)
    set(${PROJECT_NAME}LibDir "${${PROJECT_NAME}RootDir}lib/" CACHE INTERNAL "" FORCE)
    set(${PROJECT_NAME}SourceDir "${${PROJECT_NAME}RootDir}src/" CACHE INTERNAL "" FORCE)
    set(${PROJECT_NAME}SwigDir "${${PROJECT_NAME}RootDir}swig/" CACHE INTERNAL "" FORCE)
    set(${PROJECT_NAME}TestDir "${${PROJECT_NAME}RootDir}test/" CACHE INTERNAL "" FORCE)

    #######################################
    # Package Directory Variables
    set(MEZZ_PackageDirectory "$ENV{MEZZ_PACKAGE_DIR}" CACHE PATH "Folder for storing Jagati Packages.")
    set(PackageDirectory_Description "Folder for storing Jagati Packages.")
    set(PackageDirectory_Default "${${PROJECT_NAME}BinaryDir}JagatiPackages/")
    set(PackageDirectory_MissingWarning "MEZZ_PackageDirectory is not set or could not be found, this needs to be \
    a valid folder where Mezzanine Libraries can be downloaded to. You can set the Environment variable \
    'MEZZ_PACKAGE_DIR' or set MEZZ_PackageDirectory in CMake, if left unset this will create a folder in the output \
    directory."
    )
    if(EXISTS "$ENV{MEZZ_PACKAGE_DIR}")
        set(MEZZ_PackageDirectory "$ENV{MEZZ_PACKAGE_DIR}" CACHE PATH "${PackageDirectory_Description}" FORCE)
    else(EXISTS "$ENV{MEZZ_PACKAGE_DIR}")
        if(EXISTS "${MEZZ_PackageDirectory}")
            set(MEZZ_PackageDirectory "${MEZZ_PackageDirectory}" CACHE PATH "${PackageDirectory_Description}" FORCE)
        else(EXISTS "${MEZZ_PackageDirectory}")
            message(WARNING "${PackageDirectory_MissingWarning}")
            set(MEZZ_PackageDirectory "${PackageDirectory_Default}" CACHE PATH "${PackageDirectory_Description}" FORCE)
        endif(EXISTS "${MEZZ_PackageDirectory}")
    endif(EXISTS "$ENV{MEZZ_PACKAGE_DIR}")

    if(NOT "${MEZZ_PackageDirectory}" MATCHES "^.*/$") # Append Slash if needed
        set(MEZZ_PackageDirectory "${MEZZ_PackageDirectory}/")
    endif(NOT "${MEZZ_PackageDirectory}" MATCHES "^.*/$")

    #######################################
    message(STATUS "\tVariables for '${PROJECT_NAME}'")

    message(STATUS "\t\tDerived Output folders")
    message(STATUS "\t\t\t'${PROJECT_NAME}BinaryDir' - ${${PROJECT_NAME}BinaryDir}")
    message(STATUS "\t\t\t'${PROJECT_NAME}GenHeadersDir' - ${${PROJECT_NAME}GenHeadersDir}")
    message(STATUS "\t\t\t'${PROJECT_NAME}GenSourceDir' - ${${PROJECT_NAME}GenSourceDir}")

    message(STATUS "\t\tDerived Input folders")
    message(STATUS "\t\t\t'${PROJECT_NAME}RootDir' - ${${PROJECT_NAME}RootDir}")
    message(STATUS "\t\t\t'${PROJECT_NAME}DoxDir' - ${${PROJECT_NAME}DoxDir}")
    message(STATUS "\t\t\t'${PROJECT_NAME}IncludeDir' - ${${PROJECT_NAME}IncludeDir}")
    message(STATUS "\t\t\t'${PROJECT_NAME}LibDir' - ${${PROJECT_NAME}LibDir}")
    message(STATUS "\t\t\t'${PROJECT_NAME}SourceDir' - ${${PROJECT_NAME}SourceDir}")
    message(STATUS "\t\t\t'${PROJECT_NAME}SwigDir' - ${${PROJECT_NAME}SwigDir}")
    message(STATUS "\t\t\t'${PROJECT_NAME}TestDir' - ${${PROJECT_NAME}TestDir}")

    message(STATUS "\t\tMEZZ_PackageDirectory - ${MEZZ_PackageDirectory}")
    message(STATUS "\t\tENV{MEZZ_PACKAGE_DIR} - ${MEZZ_PackageDirectory}")
endmacro(CreateLocationVars)

########################################################################################################################
# CreateLocations
#
# This will use the created location variables to create any needed folders for generated source and include files and
# add default folders to the include path.
#
# Usage:
#   # Be certain to call project before calling this.
#   CreateLocations()
#
# Result:
#   Folders on the filesystem will be created.
#

macro(CreateLocations)
    file(MAKE_DIRECTORY ${${PROJECT_NAME}GenHeadersDir})
    file(MAKE_DIRECTORY ${${PROJECT_NAME}GenSourceDir})
    include_directories(${${PROJECT_NAME}IncludeDir} ${${PROJECT_NAME}GenHeadersDir})
endmacro(CreateLocations)

########################################################################################################################
# DecideOutputNames
#
# This will create a few variables in the Scope of the calling script that correspond to the name of the Project
# so that they can readily be referenced from other project including the caller as a subproject.
#
# Usage:
#   # Be certain to call project before calling this.
#   DecideOutputNames()
#
# Result:
#   The following variables will all be set to some valid folder, made available and printed:
#       ${PROJECT_NAME}BinTarget
#       ${PROJECT_NAME}LibTarget
#       ${PROJECT_NAME}TestTarget
#

macro(DecideOutputNames)
    message(STATUS "Creating Output Executable Variables for '${PROJECT_NAME}'")
    set(${PROJECT_NAME}BinTarget "${PROJECT_NAME}" CACHE INTERNAL "" FORCE)
    set(${PROJECT_NAME}LibTarget "${PROJECT_NAME}" CACHE INTERNAL "" FORCE)
    set(${PROJECT_NAME}TestTarget "${PROJECT_NAME}_Tester" CACHE INTERNAL "" FORCE)
    message(STATUS "\t'${PROJECT_NAME}BinTarget' - ${${PROJECT_NAME}BinTarget}")
    message(STATUS "\t'${PROJECT_NAME}LibTarget' - ${${PROJECT_NAME}LibTarget}")
    message(STATUS "\t'${PROJECT_NAME}TestTarget' - ${${PROJECT_NAME}TestTarget}")
endmacro(DecideOutputNames)

########################################################################################################################
# IdentifyOS
# Clearly CMake knows how to ID the OS without our help, but there are tricks to it and builtin tools are not as well
# identified as the could be. Hopefully this overcomes these minor shortfalls and provide a single source of truth for
# build time platform determination in the Jagati/Mezzanine.
#
# Usage:
#   # Be the parentmost cmake scope or this has no effect.
#   IdentifyOS()
#
# Result:
#   Details about OS are displayed and the following variables are set:
#
#       SystemIsLinux   - ON/OFF
#       SystemIsWindows - ON/OFF
#       SystemIsMacOSX  - ON/OFF
#
#       Platform32Bit - ON/OFF
#       Platform64Bit - ON/OFF
#
#       CatCommand - Some command that can print files when supplied a filename as only argument.
#       PlatformDefinition - LINUX/WINDOWS/MACOSX
#

macro(IdentifyOS)
    if("${ParentProject}" STREQUAL "${PROJECT_NAME}")
        message(STATUS "\tDetecting OS:")

        set(SystemIsLinux OFF)
        set(SystemIsWindows OFF)
        set(SystemIsMacOSX OFF)

        if("${CMAKE_SYSTEM_NAME}" STREQUAL "Linux")
            message(STATUS "\t\tDetected OS as 'Linux'.")
            set(SystemIsLinux ON)
        endif("${CMAKE_SYSTEM_NAME}" STREQUAL "Linux")

        if("${CMAKE_SYSTEM_NAME}" STREQUAL "Windows")
            message(STATUS "\t\tDetected OS as 'Windows'.")
            set(SystemIsWindows ON)
        endif("${CMAKE_SYSTEM_NAME}" STREQUAL "Windows")

        if("${CMAKE_SYSTEM_NAME}" STREQUAL "Darwin")
            message(STATUS "\t\tDetected OS as 'Mac OS X'.")
            set(SystemIsMacOSX ON)
        endif("${CMAKE_SYSTEM_NAME}" STREQUAL "Darwin")

        message(STATUS "\t\tLinux: ${SystemIsLinux}")
        message(STATUS "\t\tWindows: ${SystemIsWindows}")
        message(STATUS "\t\tMacOSX: ${SystemIsMacOSX}")

        if(SystemIsLinux)
            message(STATUS "\t\tSetting specific variables for 'Linux'.")
            set(CatCommand "cat")
            set(PlatformDefinition "LINUX")
        endif(SystemIsLinux)

        if(SystemIsWindows)
            message(STATUS "\t\tSetting specific variables for 'Windows'.")
            set(CatCommand "type")
            set(PlatformDefinition "WINDOWS")
        endif(SystemIsWindows)

        if(SystemIsMacOSX)
            message(STATUS "\t\tSetting specific variables for 'Mac OS X'.")
            set(CatCommand "cat")
            set(PlatformDefinition "MACOSX")
        endif(SystemIsMacOSX)

        set(Platform32Bit OFF)
        set(Platform64Bit OFF)

        if("${CMAKE_SIZEOF_VOID_P}" EQUAL "8")
            message(STATUS "Detected a 64 bit platform.")
            set(Platform64Bit ON)
        else("${CMAKE_SIZEOF_VOID_P}" EQUAL "8")
            message(STATUS "Detected a 32 bit platform.")
            set(Platform32Bit ON)
        endif("${CMAKE_SIZEOF_VOID_P}" EQUAL "8")

    endif("${ParentProject}" STREQUAL "${PROJECT_NAME}")
endmacro(IdentifyOS)

########################################################################################################################
# IdentifyCompiler
#
# Again, CMake knows how to detect the compiler. It does this in hyper precise detail. For purposes of the Mezzanine
# there are really two categories of compiler: visual studio and good compilers. This can roughly identify those
# categories and provide a single source of truth for each of the 5 supported compilers.
#
# If this fails to detect the compiler this reports a message with status of FATAL_ERROR which may terminate CMake.
#
# Usage:
#   # Be the parentmost cmake scope or this has no effect
#   IdentifyCompiler()
#
# Result:
#   Details about compiler are displayed and the following variables are set:
#
#       CompilerIsClang      - ON/OFF
#       CompilerIsEmscripten - ON/OFF
#       CompilerIsGCC        - ON/OFF
#       CompilerIsIntel      - ON/OFF
#       CompilerIsMsvc       - ON/OFF
#
#       CompilerDesignNix - ON/OFF
#       CompilerDesignMS  - ON/OFF
#
#       CompilerSupportsCoverage - ON/OFF
#
#       CompilerDetected - ON/OFF (FATAL_ERROR when OFF)
#

macro(IdentifyCompiler)
    if("${ParentProject}" STREQUAL "${PROJECT_NAME}")
        message(STATUS "\tDetecting Compiler:")

        # If compiler ID is unset set try to guess it
        if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "")
            if(CMAKE_CXX_COMPILER MATCHES "/em\\+\\+(-[a-zA-Z0-9.])?$")
                set(CMAKE_CXX_COMPILER_ID "Emscripten")
            endif(CMAKE_CXX_COMPILER MATCHES "/em\\+\\+(-[a-zA-Z0-9.])?$")
        endif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "")

        message(STATUS "\t\tCMAKE_CXX_COMPILER_ID: '${CMAKE_CXX_COMPILER_ID}'")

        set(CompilerIsGCC OFF)
        set(CompilerIsClang OFF)
        set(CompilerIsIntel OFF)
        set(CompilerIsMsvc OFF)
        set(CompilerIsEmscripten OFF)

        set(CompilerDesignNix OFF)
        set(CompilerDesignMS OFF)

        set(CompilerSupportsCoverage OFF)

        set(CompilerDetected OFF)

        if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
            message(STATUS "\t\tDetected compiler as 'GCC'.")
            set(CompilerIsGCC ON)
            set(CompilerDesignNix ON)
            set(CompilerDetected ON)
            set(CompilerSupportsCoverage ON)
        endif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")

        if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "AppleClang")
            message(STATUS "\t\tDetected compiler as 'AppleClang' using Clang settings.")
            set(CompilerIsClang ON)
            set(CompilerDesignNix ON)
            set(CompilerDetected ON)
            set(CompilerSupportsCoverage ON)
        endif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "AppleClang")

        if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
            message(STATUS "\t\tDetected compiler as 'Clang'.")
            set(CompilerIsClang ON)
            set(CompilerDesignNix ON)
            set(CompilerDetected ON)
            set(CompilerSupportsCoverage ON)
        endif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")

        if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Intel")
            message(STATUS "\t\tDetected compiler as 'Intel'.")
            set(CompilerIsIntel ON)
            set(CompilerDesignNix ON)
            set(CompilerDetected ON)
        endif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Intel")

        if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Emscripten")
            message(STATUS "\t\tDetected compiler as 'Emscripten'.")
            set(CompilerIsEmscripten ON)
            set(CompilerDesignNix ON)
            set(CompilerDetected ON)
        endif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Emscripten")

        if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")
            message(STATUS "\t\tDetected compiler as 'MSVC'.")
            set(CompilerIsMsvc ON)
            set(CompilerDesignMS ON)
            set(CompilerDetected ON)
        endif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")

        if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC" OR "${CMAKE_GENERATOR}" STREQUAL "Xcode")
            # This stops msvc and xcode from breaking linking and the purpose of output dirs with multiple output dirs.
            set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG "${${PROJECT_NAME}BinaryDir}")
            set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE "${${PROJECT_NAME}BinaryDir}")
            set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_DEBUG "${${PROJECT_NAME}BinaryDir}")
            set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_RELEASE "${${PROJECT_NAME}BinaryDir}")
            set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_DEBUG "${${PROJECT_NAME}BinaryDir}")
            set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_RELEASE "${${PROJECT_NAME}BinaryDir}")
        endif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC" OR "${CMAKE_GENERATOR}" STREQUAL "Xcode")

        if(CompilerDesignNix)
            message(STATUS "\t\tPresuming *nix style compiler.")
        endif(CompilerDesignNix)

        if(CompilerDesignMS)
            message(STATUS "\t\tPresuming ms style compiler.")
        endif(CompilerDesignMS)

        if(NOT CompilerDetected)
            message(FATAL_ERROR "\t\tCompiler not detected, Exiting! This can be supressed by removing check in the\
            Jagati macro IdentifyCompiler.")
        endif(NOT CompilerDetected)
    endif("${ParentProject}" STREQUAL "${PROJECT_NAME}")
endmacro(IdentifyCompiler)

########################################################################################################################
# IdentifyDebug
#
# Again, CMake knows all about the debug state. It also does this in hyper precise detail, and does it implicitly with
# the Build Type. For purposes of the Mezzanine we really want a single boolean yes or no for debugging, it also doesn't
# help that compilers have like 50 different ways to check this each with their own possible ways to fail. Even if half
# of those are great and never fail a single source of truth is still required and this should be it for the Jagati.
#
# To use this, just set the CMAKE_BUILD_TYPE like you normally would and this will use a Regex to identify debug
# settings and notify the code and other build settings that care.
#
# Usage:
#   # Be the parentmost cmake scope or this has no effect
#   IdentifyDebug()
#
# Result:
#   Details about compiler debug symbol generation state are displayed and the following variables are set:
#
#       CompilerDebug    - ON/OFF
#

macro(IdentifyDebug)
    if("${ParentProject}" STREQUAL "${PROJECT_NAME}")
        message(STATUS "\tDetecting Debug:")
        message(STATUS "\t\tCMAKE_BUILD_TYPE: '${CMAKE_BUILD_TYPE}'")

        set(CompilerDebug OFF)

        if("${CMAKE_BUILD_TYPE}" MATCHES "[Dd][Ee][Bb]")
            message(STATUS "\t\tDetected compiler as creating debug data.")
            set(CompilerDebug ON)
        else("${CMAKE_BUILD_TYPE}" MATCHES "[Dd][Ee][Bb]")
            message(STATUS "\t\tDetected compiler as skipping debug data.")
        endif("${CMAKE_BUILD_TYPE}" MATCHES "[Dd][Ee][Bb]")

    endif("${ParentProject}" STREQUAL "${PROJECT_NAME}")
endmacro(IdentifyDebug)

########################################################################################################################
# SetCommonCompilerFlags
#
# This is one of those things that CMake is simultaneously great and terrible at. It provides over 9000 ways to do this
# and many of them are wrong. Here is one way that seems to work most of the time when we do it:
#
#   Usage:
#       # Be sure the variable CompilerDesignNix is set to "ON" or "OFF".
#       # Be sure that all the CompilerIsXXXX variables are set correctly.
#       # The easiest way to do both of those is to use IdentifyCompiler().
#       SetCommonCompilerFlags()
#
#   Results:
#       Compiler flags are set that do the following:
#           Enable a ton of warnings.
#           Treat warnings as errors are set.
#           Turn off compiler logos.
#           Enable Position independent code or otherwise fix linker issues.
#           Turn on C++14.
#
#       JagatiLinkArray - This variable is set with extra items to link against for use target_link_libraries
#

macro(SetCommonCompilerFlags)
    if(CompilerDesignNix)

        # These warnings work will work on all nix style compilers. Here are the most important flags:
        # -std=c++14 - Set the C++ standard to C++14, might update all the Jagati Packages to 14 soon.
        # -fno-strict-aliasing - Required for linking some of the Mezzanine dependencies correctly.
        # -Wall - Enables "all" compiler warnings, actually abour 2/3rds, including common stuff like bad inits.
        # -Wextra - Enable the rest of the warnings except some sketchy ones.
        # -Werror - Turn all warnings into errors.
        # -pedantic-errors - Warn for accidental use of compiler extensions or undefined behavior.
        #
        # These exist to prevent issues well before they become issues:
        # -Wcast-align - When a cast changes alignment to a larger boundary, added because theorhetical performance.
        # -Wcast-qual - When CV qualifiers are changed, these are almost always bugs.
        # -Wctor-dtor-privacy - All private constructors when they probably ought to be deleted.
        # -Wdisabled-optimization - Code to complex to be optimized, also means code is too complex to be maintained.
        # -Wformat=2 - Adds extra checks for security and y2k and other easily static checkable things.
        # -Wmissing-declarations - Mandate function prototypes.
        # -Wmissing-include-dirs - Directory passed on command line does not exist.
        # -Wold-style-cast - C-style casts are errors, which they should be because they are crazy.
        # -Wredundant-decls - This stops, if you read the name you can probpably guess it, redudant declarations.
        # -Wshadow - A variable in a more local scope has teh same name as one is a larger/higher scope.
        # -Wconversion - Sign conversions and stuff that cause data loss, used to be -Wsign-conversion.
        # -Wsign-promo - Prevent issues with enums and ints choosing a signed version of a datatype when using unsigned.
        # -Wstrict-overflow=2 - When the compiler re-arranges some math that might cause an integer overflow.
        # -Wundef - Fail when undeclared preprocessor macros are used, almost always a bug/platform error.
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} \
        -std=c++14 -Wall -Wextra -Werror -pedantic-errors \
        -Wcast-align -Wcast-qual -Wctor-dtor-privacy -Wdisabled-optimization -Wformat=2 -Wmissing-declarations \
        -Wmissing-include-dirs -Wold-style-cast -Wredundant-decls -Wshadow -Wconversion -Wsign-promo \
        -Wstrict-overflow=2 -Wundef")

        # Emscripten is a unique beast
        if(CompilerIsEmscripten)
            # The same warnings as clang.
            set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Weverything -Wno-documentation-unknown-command -Wno-c++98-compat")

            # This is exe on windows and nothing on most platforms, but without this emscripten output is... wierd.
            set(CMAKE_EXECUTABLE_SUFFIX ".js")
        else(CompilerIsEmscripten)
            # Store thread library link information for later.
            find_package(Threads)
            list(APPEND JagatiLinkArray ${CMAKE_THREAD_LIBS_INIT})
            set(JagatiLinkArray "${JagatiLinkArray}"  CACHE INTERNAL "" FORCE)

            # A few checks that are very specific
            if(Platform64Bit)
                set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -m64")
            endif(Platform64Bit)
            if(SystemIsLinux)
                set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIC")
            endif(SystemIsLinux)
            if(CompilerIsGCC)
                set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wlogical-op -Wnoexcept -Wstrict-null-sentinel")
            endif(CompilerIsGCC)
            if(CompilerIsClang)
                set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Weverything \
                    -Wno-documentation-unknown-command -Wno-c++98-compat")
            endif(CompilerIsClang)
        endif(CompilerIsEmscripten)
        # Removed -Winline it did not seem useful
        # He are some flags suggested for use an why they were not used:
        # -Woverloaded-virtual - What did the author of this think virtual methods were for if not
        #                        to be overloaded. This disagrees with explicit design decisions.
        # -Wmisleading-indentation - Help find errors revolving around tabs and control flow. I
        #                            want to enable this, but not until GCC 6.
        # -DDEBUG_DIRECTOR_EXCEPTION  # Used to make swig emit more
    else(CompilerDesignNix)
        if(CompilerIsMsvc)
            # Used:
            # /nologo - Skips a few lines of microsoft branding.
            # /Wall - Enable all warnings.
            # /WX - treat warnings as errors.
            # /MT - Statically link against the threading capable standard library.

            # Ignoring:
            # C4710 - Failing to inline things in std::string, well that is STL's fault, not mine.
            # C4514 - An unused function was optimized out. Why is the optimizer doing its job a warning?!
            # C4251 - Is safe to ignore per STL
            #   http://stackoverflow.com/questions/24511376/how-to-dllexport-a-class-derived-from-stdruntime-error
            # C4820 - When padding is added for performance reasons.
            # C4987 - A garbage error about "throw(...)" not being standard.
            # C4626, C4625, C4623, C5026, C5027 - BS about implicitly removed default functions, with no workarounds,
            #   because all of these all core parts of C++. It is the moral equivalent of warning on "a=b;" because
            #   could be overwritten and errors will arise if the previous value of "a" is needed.
            # C4365 - This is actually a useful warning about conversions changing signedness, but 50+ are thrown from
            #   the std lib for builds as simple as the just Mezz_StaticFoundation.
            # C4774  - BS warning about some sprintf derivative we never use.
            set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /nologo /Wall /WX /MT \
                /wd4710 /wd4514 /wd4251 /wd4820 /wd4571 /wd4626 /wd4625 /wd5026 /wd5027 /wd4221 /wd4711 \
                /wd4987 /wd4365 /wd4774 /wd4623"
            )
        else(CompilerIsMsvc)
            message(FATAL_ERROR
                "Your compiler is not GCC compatible and not MSVC... Add this mysterious software's flags here."
            )
        endif(CompilerIsMsvc)
    endif(CompilerDesignNix)

    if("${ParentProject}" STREQUAL "${PROJECT_NAME}")
        message(STATUS "\tC++ compiler and linker flags: ${CMAKE_CXX_FLAGS}")
    endif("${ParentProject}" STREQUAL "${PROJECT_NAME}")
endmacro(SetCommonCompilerFlags)

########################################################################################################################
# FindGitExecutable
#
# Find git and put its name in a variable.
#
# Usage:
#   # Call this anytime or just trust
#   FindGitExecutable()
#
# Result:
#   If not already set this will put the git executable into the variable MEZZ_GitExecutable
#

macro(FindGitExecutable)
    if(NOT DEFINED MEZZ_GitExecutable)
        find_program (MEZZ_GitExecutable git DOC "The git executable the Jagati will use to download packages.")
        if(NOT EXISTS "${MEZZ_GitExecutable}")
            message(FATAL_ERROR
                    "Git was not found or specified wrong currently MEZZ_GitExecutable is: ${MEZZ_GitExecutable}")
        endif(NOT EXISTS "${MEZZ_GitExecutable}")
        if(NOT "${ParentProject}" STREQUAL "${PROJECT_NAME}")
            set(MEZZ_GitExecutable "${MEZZ_GitExecutable}" CACHE INTERNAL "" FORCE)
        endif(NOT "${ParentProject}" STREQUAL "${PROJECT_NAME}")
    endif(NOT DEFINED MEZZ_GitExecutable)
endmacro(FindGitExecutable)

########################################################################################################################
# StandardJagatiSetup
#
# This does what several of the above macros (ClaimParentProject, CreateLocationVars, CreateLocations, IdentifyOS,
# etc...) do, but this does it all together.
#
# Usage:
#   # Be certain to call project before calling this.
#   StandardJagatiSetup()
#
# Result:
#   The Parent scope will attempt to be claimed, many variables for compiler, OS, Debug, Git and locations will be set,
#   see above. Compiler Flags will be set.
#

macro(StandardJagatiSetup)
    ClaimParentProject()
    CreateLocationVars()
    CreateLocations()
    DecideOutputNames()
    FindGitExecutable()
    if("${ParentProject}" STREQUAL "${PROJECT_NAME}")
        message(STATUS "Determining platform specific details.")
        IdentifyOS()
        IdentifyCompiler()
        IdentifyDebug()
        SetCommonCompilerFlags()
    endif("${ParentProject}" STREQUAL "${PROJECT_NAME}")
endmacro(StandardJagatiSetup)

########################################################################################################################
# ChooseLibraryType and Internal_ChooseLibraryType
#
# This sets a single variable that all Mezzanine libraries will use when building libraries.
#
# Usage:
#   # Don't. This can easily be controlled via the BuildStaticLibraries cache level option. When used as part any
#   # Mezzanine package. This is already dealt with in the StaticFoundation.
#   ChooseLibraryType("ON")
#   ChooseLibraryType("OFF")
#
# Result:
#   A variable called LibraryBuildType is set with either "STATIC" if true is passed or "SHARED" if false is passed.
#
# Notes:
#   Forcing this into the cache effectively makes it global is that really what we want? For now it seems ok.

function(Internal_ChooseLibraryType TrueForStatic)
    if(TrueForStatic)
        set(LibraryBuildType "STATIC" CACHE INTERNAL "" FORCE)
        set(LibraryInstallationComponent "development" CACHE INTERNAL "" FORCE)
    else(TrueForStatic)
        set(LibraryBuildType "SHARED" CACHE INTERNAL "" FORCE)
        set(LibraryInstallationComponent "runtime" CACHE INTERNAL "" FORCE)
    endif(TrueForStatic)
endfunction(Internal_ChooseLibraryType TrueForStatic)

macro(ChooseLibraryType TrueForStatic)
    Internal_ChooseLibraryType(TrueForStatic)
    if(NOT "${ParentProject}" STREQUAL "${PROJECT_NAME}")
        set(LibraryBuildType "${LibraryBuildType}" CACHE INTERNAL "" FORCE)
    endif(NOT "${ParentProject}" STREQUAL "${PROJECT_NAME}")
    message(STATUS "Building libraries as: ${LibraryBuildType}")
endmacro(ChooseLibraryType TrueForStatic)

# The end of the Functions and Macros that pretty much every package will use.

########################################################################################################################
########################################################################################################################
# Coverage control Macros some tools that can be used to get code coverage numbers.
########################################################################################################################
########################################################################################################################
# Attempt to set code coverage flags.
#
# Usage:
#   # Don't. This can easily be controlled via the CodeCoverage cache level option. When used as part any
#   # Mezzanine package. This is already dealt with in the StaticFoundation.
#   ChooseCodeCoverage("ON")
#   ChooseCodeCoverage("OFF")
#
# Result:
#   Flags will be added to the build that enable code coverage if present otherwise a warning will be printed.
#   Additionally a variable named CompilerCodeCoverage
#

function(Internal_ChooseCodeCoverage TrueForEnabled)
    if("${TrueForEnabled}")
        if(CompilerDesignNix)
            set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} --coverage" PARENT_SCOPE)
            if("${ParentProject}" STREQUAL "${PROJECT_NAME}")
                set(CompilerCodeCoverage "ON" CACHE INTERNAL "" FORCE)
            endif("${ParentProject}" STREQUAL "${PROJECT_NAME}")
        else(CompilerDesignNix)
            message(WARNING "Code coverage not supported on this compiler.")
        endif(CompilerDesignNix)
    else("${TrueForEnabled}")
        set(CompilerCodeCoverage "OFF" CACHE INTERNAL "" FORCE)
    endif("${TrueForEnabled}")
endfunction(Internal_ChooseCodeCoverage TrueForEnabled)

macro(ChooseCodeCoverage TrueForEnabled)
    Internal_ChooseCodeCoverage(${TrueForEnabled})
    if(NOT "${ParentProject}" STREQUAL "${PROJECT_NAME}")
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}" PARENT_SCOPE)
    endif(NOT "${ParentProject}" STREQUAL "${PROJECT_NAME}")
endmacro(ChooseCodeCoverage TrueForEnabled)

########################################################################################################################
# Coverage Control Macros some tools that can be used to get code coverage numbers.
########################################################################################################################
# When you want to support code coverage but already include a project that asks the dev if it is turned on this build
# you should use this.
#
# Usage:
#   # When called after all targets are set up before this will add code coverage support to the build targets.
#   SetCodeCoverage()
#
# Result:
#   Flags will be added to the build that enable code coverage if present otherwise a warning will be printed.
#   Additionally a variable named CompilerCodeCoverage
#

macro(SetCodeCoverage)
    Internal_ChooseCodeCoverage("${MEZZ_CodeCoverage}")
endmacro(SetCodeCoverage)

########################################################################################################################
# Attempt to create a target that builds code coverage metadata.
#
# Usage:
#   # Call it and pass the name of the executable and the list of source to be checked. Be sure to call this after
#   # Calling IdentifyCompiler().
#   CreateCoverageTarget("ExecutableName" "${SourceList}")
#   CreateCoverageTarget(${TestLib} "${TesterSourceFiles}")
#
# Result:
#   A new build target called ${ExecutableName}Coverage will be added that will run copy source files where needed and
#   run gcov to generate profile and coverage notes and data that.
#

macro(CreateCoverageTarget ExecutableName SourceList)
    if(${CompilerSupportsCoverage})
        if(${CompilerCodeCoverage})
            set(SingleTargetDir "${${PROJECT_NAME}BinaryDir}CMakeFiles/${ExecutableName}.dir/src/")
            set(CoveredTargetInputFiles "")
            foreach(SingleSourceFile ${SourceList})
                get_filename_component(SingleSourceFileExtension ${SingleSourceFile} EXT)
                get_filename_component(SingleSourceFileName ${SingleSourceFile} NAME)
                set(SingleTarget "${SingleTargetDir}${SingleSourceFileName}${SingleSourceFileExtension}")
                list(APPEND CoveredTargetInputFiles ${SingleTarget})
                add_custom_command(
                    OUTPUT ${SingleTarget}
                    COMMAND ${CMAKE_COMMAND} -E copy ${SingleSourceFile} ${SingleTarget}
                    COMMAND gcov ${SingleTarget}
                    DEPENDS ${SingleSourceFile}
                )
            endforeach(SingleSourceFile ${SourceList})
            message(STATUS "Adding code coverage target for ${PROJECT_NAME} - ${ExecutableName}Coverage")
            add_custom_target(${ExecutableName}Coverage DEPENDS ${CoveredTargetInputFiles})
        else(${CompilerCodeCoverage})
            message(STATUS "Not producing code coverage target because it was not requested for ${PROJECT_NAME}")
        endif(${CompilerCodeCoverage})
    else(${CompilerSupportsCoverage})
        message(STATUS "Not producing code coverage target despite being requested for ${PROJECT_NAME}")
    endif(${CompilerSupportsCoverage})
endmacro(CreateCoverageTarget SourceList)

########################################################################################################################
########################################################################################################################
# Optional Macros that not all Jagati packages will use, but could be important for link or other build time activities.
########################################################################################################################
########################################################################################################################

########################################################################################################################
# AddManualJagatiLibrary
#
# Add to a variable that contains an array of all the Jagati Linkable Libraries provided by loaded packages.
#
# Usage:
#   # Be certain to call project before calling this.
#   # Also be certain to have a valid target or library with name matching whatever string is passed.
#   AddManualJagatiLibrary("LinkTarget")
#
# Result:
#   The passed file will be added to a list of libaries. This list can be Accessed through the variable:
#       JagatiLinkArray
#
#   This will also create a variable call ${PROJECT_NAME}lib that will store the filename, so only one library per
#   Jagati package can be shared this way.
#

macro(AddManualJagatiLibrary TargetName)
    list(APPEND JagatiLinkArray "${TargetName}")
    set(${PROJECT_NAME}Lib "${TargetName}" CACHE INTERNAL "" FORCE)
    message(STATUS "\tLib variable: '${PROJECT_NAME}lib' - ${${PROJECT_NAME}lib}")
    if(NOT "${ParentProject}" STREQUAL "${PROJECT_NAME}")
        set(JagatiLinkArray "${JagatiLinkArray}" PARENT_SCOPE)
    endif(NOT "${ParentProject}" STREQUAL "${PROJECT_NAME}")
endmacro(AddManualJagatiLibrary FileName)

########################################################################################################################
# AddJagatiLibrary
#
# Create a linkable libary and add it to a variable that contains an array of all the Jagati Linkable Libraries provided
# by loaded packages.
#
# Usage:
#   # Be certain to call project before calling this and StandardJagatiSetup (or equivalent alternatives), also call
#   # ChooseLibraryType before calling this.
#   AddJagatiLibrary()
#
# Result:
#   The passed file will be added to a list of libaries. This list can be Accessed through the variable:
#       JagatiLinkArray
#
#   This will also create a variable call ${PROJECT_NAME}lib that will store the filename, so only one library per
#   Jagati package can be shared this way.
#

macro(AddJagatiLibrary)
    message(STATUS "Adding Automatic Library - ${${PROJECT_NAME}LibTarget}")
    add_library(
        "${${PROJECT_NAME}LibTarget}"
        ${MEZZ_LibraryBuildType}
        "${${PROJECT_NAME}HeaderFiles}"
        "${${PROJECT_NAME}SourceFiles}"
    )
    target_link_libraries("${${PROJECT_NAME}LibTarget}" ${JagatiLinkArray})
    target_compile_definitions("${${PROJECT_NAME}LibTarget}" PRIVATE -DMEZZ_EXPORT_LIB)
    AddManualJagatiLibrary("${${PROJECT_NAME}LibTarget}")
    install(
        TARGETS "${${PROJECT_NAME}LibTarget}"
        COMPONENT ${LibraryInstallationComponent}
        LIBRARY DESTINATION lib
        ARCHIVE DESTINATION lib
    )
endmacro(AddJagatiLibrary)

########################################################################################################################
# AddJagatiDoxInput
#
# Add input files to list of all files doxygen will scan.
#
# Usage:
#   # Call any time after the parent scope is claimed and when the project is built if doxygen is installed and the
#   # option is chosen then html docs will be generated from all past files.
#   AddJagatiDoxInput("${StaticFoundationConfigFilename}")
#   AddJagatiDoxInput("${DoxFiles}")
#   AddJagatiDoxInput("foo.h")

macro(AddJagatiDoxInput FileName)
    list(APPEND JagatiDoxArray ${FileName})
    set(${PROJECT_NAME}Dox "${FileName}" CACHE INTERNAL "" FORCE)
    message(STATUS "Dox Input: '${PROJECT_NAME}Dox' - ${${PROJECT_NAME}Dox}")
endmacro(AddJagatiDoxInput FileName)

########################################################################################################################
# AddJagatiConfig and Internal_SetRemarks
#
# Some projects have many files that are created at compile time. This can cause issues in the build system as it has to
# manage complexities in the source code. Most software developers want to spend their reasoning about the code and not
# the code that makes or manages the code. In general the Jagati or a specific package should handle meta-programming
# where possible.
#
# A good Jagati config file is simple header containing nothing but literal values in preprocessor macros. Every
# possible variable is included in the config file, but ones that need to be excluded from the build should be remarked
# out. This allows someone inspecting just that file to know what the options could be without needing to inspect the
# CMakeLists.txt for the package. This CMake macro adds one line to the config file for a specific package.
#
# Usage:
#   # Call any time after the parent scope is claimed. The first parameter is the name of a preprocessor macro to
#   # create. The second is the value, "" for no value. The third argument is for determining if the remark should be
#   # enabled(true) or remarked out(false).
#       AddJagatiConfig("FOO" "BAR" ON)
#       AddJagatiConfig("EmptyOption" "" ON)
#       AddJagatiConfig("Remarked_FOO" "BAR" OFF)
#       AddJagatiConfig("EmptyOption_nope" "" OFF)
#
# Result:
#   Adds a preprocessor macro to string that config headers can directly include. Here is the output from the sample
#   above:
#       #define FOO BAR
#       #define EmptyOption
#       //#define Remarked_FOO BAR
#       //#define EmptyOption_nope
#
#   The set variable will be ${PROJECT_NAME}JagatiConfig.
#
#   This sets the variables ${PROJECT_NAME}JagatiConfigRaw to similar contents to ${PROJECT_NAME}JagatiConfig, except
#   the Raw version has no remarks.
#
#   This also writes to the variable "JagatiConfigRemarks" in the parentmost scope as a temporary.
#

# This is an implementaion Detail of AddJagatiConfig, This is needed because macro parameters are neither variables, nor
# constants and cannot be used in if statements checking implicit truthiness.
function(Internal_SetRemarks HowToSet)
    if(HowToSet)
        set(JagatiConfigRemarks "" PARENT_SCOPE)
    else(HowToSet)
        set(JagatiConfigRemarks "//" PARENT_SCOPE)
    endif(HowToSet)
endfunction(Internal_SetRemarks HowToSet)

macro(AddJagatiConfig Name Value RemarkBool)
    Internal_SetRemarks("${RemarkBool}")
    set(${PROJECT_NAME}JagatiConfig
        "${${PROJECT_NAME}JagatiConfig}\n\t${JagatiConfigRemarks}#define ${Name} ${Value}")
    set(${PROJECT_NAME}JagatiConfigRaw "${${PROJECT_NAME}JagatiConfigRaw}\n\t#define ${Name} ${Value}")
    if("${ParentProject}" STREQUAL "${PROJECT_NAME}")
    else("${ParentProject}" STREQUAL "${PROJECT_NAME}")
        set(${PROJECT_NAME}JagatiConfig "${${PROJECT_NAME}JagatiConfig}" PARENT_SCOPE)
        set(${PROJECT_NAME}JagatiConfigRaw "${${PROJECT_NAME}JagatiConfigRaw}" PARENT_SCOPE)
    endif("${ParentProject}" STREQUAL "${PROJECT_NAME}")
endmacro(AddJagatiConfig Name Value RemarkBool)

########################################################################################################################
# EmitConfig
#
# Emit a config file as constructed by AddJagatiConfig.
#
# Usage:
#   # Call after 0 or more calls to AddJagatiConfig and the parentmost scope has been claimed.
#   EmitConfig()
#
# Result:
#   This will create a config file with all the config item added by AddJagatiConfig in this project and this will set
#   two variables:
#       ${PROJECT_NAME}ConfigFilename - The absolute path and filename of the file writtern, this
#           derived from the variable ${PROJECT_NAME}GenHeadersDir and will contain the project name
#       ${PROJECT_NAME}ConfigContent - The contents of what was emitted in the header file.
#

macro(EmitConfig)
    # Prepare parts to be assembled.
    set(ConfigHeader
        "${MEZZ_Copyright}#ifndef ${PROJECT_NAME}_config_h\n#define ${PROJECT_NAME}_config_h\n\n#ifndef DOXYGEN\n"
    )
    set(DoxygenElse "\n\n#else // DOXYGEN\n")
    set(ConfigFooter "\n\n#endif // DOXYGEN\n\n#endif\n")

    # Assemble the content and notify correct scopes
    set(${PROJECT_NAME}ConfigContent
        "${ConfigHeader}${${PROJECT_NAME}JagatiConfig}${DoxygenElse}${${PROJECT_NAME}JagatiConfigRaw}${ConfigFooter}"
    )
    if(NOT "${ParentProject}" STREQUAL "${PROJECT_NAME}")
        set(${PROJECT_NAME}ConfigContent "${${PROJECT_NAME}ConfigContent}" PARENT_SCOPE)
    endif(NOT "${ParentProject}" STREQUAL "${PROJECT_NAME}")

    # Write the file and notify correct scopes
    set(${PROJECT_NAME}ConfigFilename "${${PROJECT_NAME}GenHeadersDir}${PROJECT_NAME}Config.h")
    if(NOT "${ParentProject}" STREQUAL "${PROJECT_NAME}")
        set(${PROJECT_NAME}ConfigFilename "${${PROJECT_NAME}ConfigFilename}" PARENT_SCOPE)
    endif(NOT "${ParentProject}" STREQUAL "${PROJECT_NAME}")

    message(STATUS "Emitting Config Header File - ${${PROJECT_NAME}ConfigFilename}")
    file(WRITE "${${PROJECT_NAME}ConfigFilename}" "${${PROJECT_NAME}ConfigContent}")
endmacro(EmitConfig)

########################################################################################################################
# AddJagatiCompileOption
#
# This gaurantees that options will wind up in the config file if enabled or not (if disabled they will be remarked
# in the config).
#
# Usage:
#   # Call after project to insure PROJECT_NAME is set.
#   AddJagatiCompileOption("BuildDoxygen" "Create HTML documentation with Doxygen." ON)
#   AddJagatiCompileOption("VariableName" "Help text." TruthyDefaultValue)
#
# Results:
#   This will create a variable named after thee string in the first parameter. This variable will
#   be added to the config file for the current project and as a CMake Option in the GUI (or command
#   prompt).

macro(AddJagatiCompileOption VariableName HelpString DefaultSetting)
    option(
        ${VariableName}
        "${HelpString}"
        ${DefaultSetting}
    )
    AddJagatiConfig("${VariableName}" "" ${${VariableName}})
endmacro(AddJagatiCompileOption VariableName HelpString DefaultSetting)

########################################################################################################################
########################################################################################################################
# Test Main creation
########################################################################################################################
########################################################################################################################

########################################################################################################################
# EmitTestCode
#
# Usage:
#   EmitTestCode()
#
# Results:
#       A file called ${PROJECT_NAME}_tester.cpp is emitted int the build output directory. This can be used to generate
#   a unit test executable
#

macro(EmitTestCode)
    # Everything before Main
    set(TestsHeader "${MEZZ_Copyright}#include \"MezzTest.h\"\n\n")
    set(TestsIncludes "// Start Dynamically Included Headers\n")
    foreach(TestHeader ${${PROJECT_NAME}TestHeaderList})
        set(TestsIncludes "${TestsIncludes}\n    #include \"${TestHeader}\"")
    endforeach(TestHeader ${${PROJECT_NAME}TestHeaderList})
    set(TestsIncludes "${TestsIncludes}\n\n// End Dynamically Included Headers")

    # The main function
    set(TestsMainHeader
        "\n\nint main (int argc, char** argv)\n{\n    Mezzanine::Testing::CoreTestGroup TestInstances;\n\n"
    )

    set(TestsInit "    // Start Dynamically Instanced Tests\n")
    foreach(TestName ${${PROJECT_NAME}TestClassList})
        string(TOLOWER "${TestName}" TestLowerName)
        set(TestsInit "${TestsInit}\n\
        ${TestName} ${TestName}Instance;\n\
        TestInstances[AllLower(${TestName}Instance.Name())] = &${TestName}Instance;\n")
    endforeach(TestName ${${PROJECT_NAME}TestClassList})
    set(TestsInit "${TestsInit}\n    // Start Dynamically Instanced Tests\n\n")

    set(TestsMainFooter
        "    return Mezzanine::Int32(Mezzanine::Testing::MainImplementation(argc, argv, TestInstances)); \n}\n\n"
    )

    # Connect everything
    set(${PROJECT_NAME}TestsContent
        "${TestsHeader}${TestsIncludes}${TestsMainHeader}${TestsInit}${TestsMainFooter}"
    )

    # Write it out and notify the correct scopes.
    set(${PROJECT_NAME}TesterFilename "${${PROJECT_NAME}GenSourceDir}${PROJECT_NAME}_tester.cpp")
    if(NOT "${ParentProject}" STREQUAL "${PROJECT_NAME}")
        set(${PROJECT_NAME}TesterFilename "${${PROJECT_NAME}TestFilename}" PARENT_SCOPE)
    endif(NOT "${ParentProject}" STREQUAL "${PROJECT_NAME}")

    message(STATUS "Emitting Test Source File - ${${PROJECT_NAME}TesterFilename}")
    file(WRITE "${${PROJECT_NAME}TesterFilename}" "${${PROJECT_NAME}TestsContent}")
endmacro(EmitTestCode)

########################################################################################################################
# AddTestTarget
#
# Create a test target that makes and executable to run all the tests added so far.
#
# Usage:
#   # Must call AddJagatiLibrary or AddManualJagatiLibrary first, because this uses ${${PROJECT_NAME}LibTarget}
#   AddTestTarget()
#
# Results:
#   Create a test executable target named ${${PROJECT_NAME}TestTarget}
#

macro(AddTestTarget)
    get_property(dirs DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY INCLUDE_DIRECTORIES)
    message(STATUS "Include dirs for ${CMAKE_CURRENT_SOURCE_DIR}:")
    foreach(dir ${dirs})
        message(STATUS "\t'${dir}'")
    endforeach(dir ${dirs})

    message(STATUS "Adding tester target - ${${PROJECT_NAME}TestTarget} - ${JagatiLinkArray}")
    add_executable(
        ${${PROJECT_NAME}TestTarget}
        "${${PROJECT_NAME}TestHeaderList}"
        "${${PROJECT_NAME}TesterFilename}"
    )
    target_link_libraries(${${PROJECT_NAME}TestTarget} ${JagatiLinkArray})
    add_test("Run${${PROJECT_NAME}TestTarget}" ${${PROJECT_NAME}TestTarget})
endmacro(AddTestTarget)

########################################################################################################################
# AddTestClass
#
# Use this to add test classes to be run with the Mezz_Test Package.
#
# Usage:
#   AddTestClass("TestName")
#
# Results:
#   This will create a list containing the names of all the tests added and a with the filenames of all those tests.
#
#       ${PROJECT_NAME}TestClassList - This is created or appended to and will have all the class names.
#       ${PROJECT_NAME}TestHeaderList - This is created or appended to and will have all the absolute file names.
#
#   The followings lines will be added to the file ${PROJECT_NAME}_tester.cpp (when emitted byEmitTestCode()) :
#
#       In the header section will be added:
#           #include "${TestName}.h"
#
#       In the instantiation section will be added:
#           ${TestName}Tests ${TestName}Instance;
#           TestInstances["${TestName}"] = &${TestName}Instance;
#
#       If you called AddTest("Foo") you would get these lines:
#           #include "Foo.h"
#
#           FooTests FooInstance;
#           TestInstances["Foo"] = &FooInstance;
#
#   You should have a header in your test directory (or other included directory) named exacly what was passed in
#   with a suffix of ".h". In that file there should be a class named exactly what was passed in with a suffix of
#   "Tests" that publicly inherits from Mezzanine::Testing::UnitTestGroup.
#

macro(Internal_AddTest AbsoluteFilename)
    get_filename_component(InnerTestName "${AbsoluteFilename}" NAME_WE)
    list(APPEND ${PROJECT_NAME}TestClassList ${InnerTestName})
    list(APPEND ${PROJECT_NAME}TestHeaderList "${AbsoluteFilename}")
    message(STATUS "\tAdding Test: '${InnerTestName}'")
endmacro(Internal_AddTest AbsoluteFilename)

macro(AddTestClass TestName)
    Internal_AddTest("${${PROJECT_NAME}TestDir}${TestName}.h")
endmacro(AddTestClass TestName)

########################################################################################################################
# AddTestDirectory
#
# Usage:
#   AddTestDirectory("TestDirectory")
#
# Results:
#   This call add test for each header in the passed directory
#

macro(AddTestDirectory TestDir)
    message(STATUS "Adding all tests in: '${TestDir}'")
    file(GLOB TestFileList "${TestDir}*.h")
    foreach(TestFilename ${TestFileList})
        get_filename_component(TestFile "${TestFilename}" ABSOLUTE)
        Internal_AddTest("${TestFile}")
    endforeach(TestFilename ${TestFileList})
endmacro(AddTestDirectory)

########################################################################################################################
########################################################################################################################
# Basic Display Functionality
########################################################################################################################
########################################################################################################################
# ShowList
#
# Tabbed list Printing
#
# Usage:
#   ShowList("Header text" "\t" "${AnyArray}")
#
# Results:
#   The header and array will be printed. Each line except the header will be indented/preceeded
#   by whatever is in Tabbing.

function(ShowList Header Tabbing ToPrint)
    message(STATUS "${Tabbing}${Header}")
    foreach(ListItem ${ToPrint})
        message(STATUS "${Tabbing}\t${ListItem}")
    endforeach(ListItem ${ToPrint})
endfunction(ShowList)

########################################################################################################################
# AddIDEVisibility
#
# Make a default list of source files and every file in the passed list visible by adding to a build target that the IDE
# will see.
#
# Usage:
#   # Call after creating all the default files and populating the default source file lists
#   # ${${PROJECT_NAME}HeaderFiles}, ${${PROJECT_NAME}SourceFiles}, ${${PROJECT_NAME}SwigFiles},
#   # ${${PROJECT_NAME}ConfigFilename}, ${${PROJECT_NAME}DoxFiles}README.md, COPYING.md, .travis.yml, appveyor.yml,
#   # and codecov.yml.
#   AddIDEVisibility("file1.txt;file2.md;file3.ext")
#   # or
#   set(FileList "")
#   list(APPEND FileList "file1.txt")
#   list(APPEND FileList "file2.md")
#   list(APPEND FileList "file3.ext")
#   AddIDEVisibility("${Files}")
#
# Results:
#   A target named ${PROJECT_NAME}_IDE_Visibility is created with every source file and every passed file as a
#   dependency.
#

macro(AddIDEVisibility Files)
add_custom_target(
    ${PROJECT_NAME}_IDE_Visibility
    DEPENDS ${PROJECT_NAME}_Tester
    SOURCES ${${PROJECT_NAME}HeaderFiles}
            ${${PROJECT_NAME}SourceFiles}
            ${${PROJECT_NAME}SwigFiles}
            ${${PROJECT_NAME}ConfigFilename}
            ${${PROJECT_NAME}DoxFiles}
            ${StaticFoundationTestSourceFiles}
            README.md
            COPYING.md
            .travis.yml
            appveyor.yml
            codecov.yml
            "${Files}"
)
endmacro(AddIDEVisibility Files)

########################################################################################################################
########################################################################################################################
# Getting Jagati packages, What URLs and functions can we use to get Jagati Packages and know what Exists?
########################################################################################################################
########################################################################################################################
# GitUpdatePackage
#
# This gets the latest source code for the package specified. This does not touch git branches so features can be tried
# out without interference from the Jagati.
#
# Usage:
#   # MEZZ_GitExecutable must be set, so either set it or call FindGitExecutable().
#   # The argment is a complete package name, in the format of Mezz_PackageName.
#   GitUpdatePackage("Mezz_Test")
#   GitUpdatePackage("Mezz_Foundation")
#
# Results:
#   This will use the MEZZ_PackageDirectory to find or create the directory the source code ought to be. If there is no
#   source git clone gets it, if there is source code git pull is used to update it.
#

function(GitUpdatePackage PackageName)
    set(TargetPackageSourceDir "${MEZZ_PackageDirectory}${PackageName}/")
    if(EXISTS "${TargetPackageSourceDir}CMakeLists.txt")
        execute_process(
            WORKING_DIRECTORY ${TargetPackageSourceDir}
            COMMAND ${MEZZ_GitExecutable} pull ${${PackageName}_GitURL}
        )
    else(EXISTS "${TargetPackageSourceDir}CMakeLists.txt")
        file(MAKE_DIRECTORY "${MEZZ_PackageDirectory}")
        execute_process(
            WORKING_DIRECTORY ${MEZZ_PackageDirectory}
            COMMAND ${MEZZ_GitExecutable} clone ${${PackageName}_GitURL}
        )
    endif(EXISTS "${TargetPackageSourceDir}CMakeLists.txt")
endfunction(GitUpdatePackage PackageName)

########################################################################################################################
# IncludeJagatiPackage
#
# Any package wanting to use another can include it with this function, and this will specify dependency.
#
# Usage:
#   # MEZZ_GitExecutable must be set, so either set it or call FindGitExecutable().
#   # The argment is the packagename, complete of partial.
#   IncludeJagatiPackage("Mezz_Test")
#   IncludeJagatiPackage("Foundation")
#
# Results:
#   This will run all the CMake for the requested package and its dependencies. This should update or retrieve source
#   code, add required linker libraries and required header search folders.
#
macro(IncludeJagatiPackage PassedPackageName)
    # Set name variables so that the name with or without the "Mezz" works.
    if("${PassedPackageName}" MATCHES "MEZZ_.*")
        string(SUBSTRING "${PassedPackageName}" 6 -1 RawPackageName)
        set(PackageName "${PassedPackageName}")
    else("${PassedPackageName}" MATCHES "MEZZ_.*")
        set(RawPackageName "${PassedPackageName}")
        set(PackageName "Mezz_${PassedPackageName}")
    endif("${PassedPackageName}" MATCHES "MEZZ_.*")

    # Bail if this is not a valid git package.
    if("${${PackageName}_GitURL}" STREQUAL "")
        message(FATAL_ERROR "Could not find URL for Package named ${PackageName}.")
    endif("${${PackageName}_GitURL}" STREQUAL "")

    # Setup directory for coming work.
    set(TargetPackageSourceDir "${MEZZ_PackageDirectory}${PackageName}/")
    set(TargetPackageBinaryDir "${MEZZ_PackageDirectory}${PackageName}-build/")
    GitUpdatePackage(${PackageName})

    # If there is no binary dir for the package then we have not added it, so add it now.
    if(NOT DEFINED ${RawPackageName}BinaryDir)
    message("===============================================================================================================================")
        add_subdirectory("${TargetPackageSourceDir}" "${TargetPackageBinaryDir}")
    endif(NOT DEFINED ${RawPackageName}BinaryDir)

    # Make the headers available in this directory.
    include_directories(${${RawPackageName}IncludeDir})
    include_directories(${${RawPackageName}GenHeadersDir})
endmacro(IncludeJagatiPackage PackageName)
