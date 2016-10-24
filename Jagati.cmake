# © Copyright 2010 - 2016 BlackTopp Studios Inc.
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

# This will be the basic package manager for the Mezzanine, the Jagati. This will track and download
# packages from git repositories. This will handle centrally locating Mezzanine packages and provide
# tools for finding and linking against them appropriately.

# This will not be included directly in git repos, but rather a small download snippet with ensure
# this stays up to date.


# Basic Sanity Checks the Jagati enforces
if("${CMAKE_SOURCE_DIR}" STREQUAL "${CMAKE_BINARY_DIR}")
    message(FATAL_ERROR "Prevented in source tree build. Please create a build directory outside of"
                        " the Mezzanine source code and have cmake build from there.")
endif("${CMAKE_SOURCE_DIR}" STREQUAL "${CMAKE_BINARY_DIR}")

cmake_minimum_required(VERSION 3.0)
if("${CMAKE_VERSION}" VERSION_GREATER "3.1.0")
    message(STATUS "Setting comparison policy for newer versions of CMake. Using CMP0054.")
    cmake_policy(SET CMP0054 NEW)
else("${CMAKE_VERSION}" VERSION_GREATER "3.1.0")
    message(STATUS "NOT setting comparison policy for newer versions of CMake. Not using CMP0054.")
endif("${CMAKE_VERSION}" VERSION_GREATER "3.1.0")

########################################################################################################################
########################################################################################################################
# From Here to the next thick banner exist macros to set variables in the scope of the calling
# CmakeList Project that all Jagati packages should set. The idea is that every variable needed to
# link or inspect the source will be cleanly set and easily inspectable, from just the output of
# cmake and a sample CMakeLists.txt.
########################################################################################################################
########################################################################################################################
# This is used to determine what the parentmost project is. Whichever project calls this first will
# be the only one that doesn't set all of it's variables in its parent's scope.

# Usage:
#   # Be certain to call project before calling this.
#   # Call this from the main project before calling anything else to insure your project is root.
#   ClaimParentProject()
#
# Result:
#   The following variables will all be set, made available and printed and other Jagati projects
#   will know to pollute your namespace:
#       ParentProject

macro(ClaimParentProject)
    if(ParentProject)
        # It is already set so we must be a child.
        message(STATUS
            "Project '${PROJECT_NAME}' acknowledges '${ParentProject}' as the Parent Project."
        )
    else(ParentProject)
        message(STATUS "Claiming '${PROJECT_NAME}' as the Parent Project.")
        set(ParentProject "${PROJECT_NAME}")
        set(JagatiConfig "")
    endif(ParentProject)
endmacro(ClaimParentProject)

########################################################################################################################
# This will create a number of variables in the Scope of the calling script that correspond to the
# name of the Project so that they can readily be referenced from other project including the caller
# as a a subproject.

# Usage:
#   # Be certain to call project before calling this.
#   CreateLocations()
#
# Result:
#   The following variables will all be set to some valid folder, made available and printed:
#       ${PROJECT_NAME}RootDir
#       ${PROJECT_NAME}BinaryDir
#
#       ${PROJECT_NAME}GenHeadersDir
#       ${PROJECT_NAME}GenSourceFolder
#
#       ${PROJECT_NAME}DoxDir
#       ${PROJECT_NAME}IncludeDir
#       ${PROJECT_NAME}LibDir
#       ${PROJECT_NAME}SourceDir
#       ${PROJECT_NAME}SwigDir
#       ${PROJECT_NAME}TestDir

macro(CreateLocations)
    message(STATUS "Creating Location Variables for '${PROJECT_NAME}'")
    set(PROJECT_NAME "${PROJECT_NAME}")

    #######################################
    # Root
    set(${PROJECT_NAME}RootDir "${${PROJECT_NAME}_SOURCE_DIR}/" CACHE INTERNAL "" FORCE)
    set(${PROJECT_NAME}BinaryDir "${${PROJECT_NAME}_BINARY_DIR}/" CACHE INTERNAL "" FORCE)

    #######################################
    # Derived Output Folders
    set(${PROJECT_NAME}GenHeadersDir "${${PROJECT_NAME}BinaryDir}config/" CACHE INTERNAL "" FORCE)
    set(${PROJECT_NAME}GenSourceFolder "${${PROJECT_NAME}BinaryDir}generated_source/" CACHE INTERNAL "" FORCE)

    #######################################
    # Derived Input Folders
    set(${PROJECT_NAME}DoxDir "${${PROJECT_NAME}RootDir}dox/" CACHE INTERNAL "" FORCE)
    set(${PROJECT_NAME}IncludeDir "${${PROJECT_NAME}RootDir}include/" CACHE INTERNAL "" FORCE)
    set(${PROJECT_NAME}LibDir "${${PROJECT_NAME}RootDir}lib/" CACHE INTERNAL "" FORCE)
    set(${PROJECT_NAME}SourceDir "${${PROJECT_NAME}RootDir}src/" CACHE INTERNAL "" FORCE)
    set(${PROJECT_NAME}SwigDir "${${PROJECT_NAME}RootDir}swig/" CACHE INTERNAL "" FORCE)
    set(${PROJECT_NAME}TestDir "${${PROJECT_NAME}RootDir}test/" CACHE INTERNAL "" FORCE)

    #######################################
    message(STATUS "\tVariables for '${PROJECT_NAME}'")

    message(STATUS "\t\tRoot Folders")
    message(STATUS "\t\t\t'${PROJECT_NAME}RootDir' - ${${PROJECT_NAME}RootDir}")
    message(STATUS "\t\t\t'${PROJECT_NAME}BinaryDir' - ${${PROJECT_NAME}BinaryDir}")

    message(STATUS "\t\tDerived Output folders")
    message(STATUS "\t\t\t'${PROJECT_NAME}GenHeadersDir' - ${${PROJECT_NAME}GenHeadersDir}")
    message(STATUS "\t\t\t'${PROJECT_NAME}GenSourceFolder' - ${${PROJECT_NAME}GenSourceFolder}")

    message(STATUS "\t\tDerived Input folders")
    message(STATUS "\t\t\t'${PROJECT_NAME}DoxDir' - ${${PROJECT_NAME}DoxDir}")
    message(STATUS "\t\t\t'${PROJECT_NAME}IncludeDir' - ${${PROJECT_NAME}IncludeDir}")
    message(STATUS "\t\t\t'${PROJECT_NAME}LibDir' - ${${PROJECT_NAME}LibDir}")
    message(STATUS "\t\t\t'${PROJECT_NAME}SourceDir' - ${${PROJECT_NAME}SourceDir}")
    message(STATUS "\t\t\t'${PROJECT_NAME}SwigDir' - ${${PROJECT_NAME}SwigDir}")
    message(STATUS "\t\t\t'${PROJECT_NAME}TestDir' - ${${PROJECT_NAME}TestDir}")
endmacro(CreateLocations)

########################################################################################################################
# Clearly CMake knows how to ID the OS without our help, but there are tricks to it and builtin
# tools are not as well identified as the could be. Hopefully this overcomes these minor shortfalls.

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
# Again, CMake knows how to detect the compiler. It does this in hyper precise detail. For purposes
# of the Mezzanine there are really two categories of compiler: visual studio and good compilers.
# This can roughly identify those categories.

# Usage:
#   # Be the parentmost cmake scope or this has no effect
#   IdentifyCompiler()
#
# Result:
#   Details about compiler are displayed and the following variables are set:
#
#       CompilerIsGCC   - ON/OFF
#       CompilerIsClang - ON/OFF
#       CompilerIsIntel - ON/OFF
#       CompilerIsMsvc  - ON/OFF
#
#       CompilerDesignNix - ON/OFF
#       CompilerDesignMS  - ON/OFF
#
#       CompilerDetected - ON/OFF

macro(IdentifyCompiler)
    if("${ParentProject}" STREQUAL "${PROJECT_NAME}")
        message(STATUS "\tDetecting Compiler:")
        message(STATUS "\t\tCMAKE_CXX_COMPILER_ID: '${CMAKE_CXX_COMPILER_ID}'")

        set(CompilerIsGCC OFF)
        set(CompilerIsClang OFF)
        set(CompilerIsIntel OFF)
        set(CompilerIsMsvc OFF)

        set(CompilerDesignNix OFF)
        set(CompilerDesignMS OFF)

        set(CompilerDebug OFF)

        set(CompilerDetected OFF)

        if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
            message(STATUS "\t\tDetected compiler as 'GCC'.")
            set(CompilerIsGCC ON)
            set(CompilerDesignNix ON)
            set(CompilerDetected ON)
        endif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")

        if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "AppleClang")
            message(STATUS "\t\tDetected compiler as 'AppleClang' using Clang settings.")
            set(CompilerIsClang ON)
            set(CompilerDesignNix ON)
            set(CompilerDetected ON)
        endif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "AppleClang")

        if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
            message(STATUS "\t\tDetected compiler as 'Clang'.")
            set(CompilerIsClang ON)
            set(CompilerDesignNix ON)
            set(CompilerDetected ON)
        endif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")

        if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Intel")
            message(STATUS "\t\tDetected compiler as 'Intel'.")
            set(CompilerIsIntel ON)
            set(CompilerDesignNix ON)
            set(CompilerDetected ON)
        endif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Intel")

        if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")
            message(STATUS "\t\tDetected compiler as 'MSVC'.")
            set(CompilerIsMsvc ON)
            set(CompilerDesignMS ON)
            set(CompilerDetected ON)
        endif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")

        if("${CMAKE_BUILD_TYPE}" MATCHES "[Dd][Ee][Bb]")
            message(STATUS "\t\tDetected compiler as creating debug data.")
            set(CompilerDebug ON)
        else("${CMAKE_BUILD_TYPE}" MATCHES "[Dd][Ee][Bb]")
            message(STATUS "\t\tDetected compiler as skipping debug data.")
        endif("${CMAKE_BUILD_TYPE}" MATCHES "[Dd][Ee][Bb]")

        if(CompilerDesignNix)
            message(STATUS "\t\tPresuming *nix style compiler.")
        endif(CompilerDesignNix)

        if(CompilerDesignMS)
            message(STATUS "\t\tPresuming ms style compiler.")
        endif(CompilerDesignMS)

        if(NOT CompilerDetected)
            message(ERROR "\t\tCompiler not detected, Exiting! This can be supressed by removing check in the Jagati\
            macro IdentifyCompiler.")
        endif(NOT CompilerDetected)

    endif("${ParentProject}" STREQUAL "${PROJECT_NAME}")
endmacro(IdentifyCompiler)

########################################################################################################################
# Again, CMake knows all about the debug state. It also does this in hyper precise detail, and does it implicitly with
# the Build Type. For purposes of the Mezzanine we really want a single boolean yes or no for debugging, it also doesn't
# help that compilers have like 50 different ways to check this each with their own possible ways to fail. Even if half
# of those are great and never fail descending

# Usage:
#   # Be the parentmost cmake scope or this has no effect
#   IdentifyDebug()
#
# Result:
#   Details about compiler debug symbol generation state are displayed and the following variables are set:
#
#       CompilerDebug    - ON/OFF

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
# This is one of those things that CMake is simultaneously great and terrible at. It provides like
# a trillion ways to do this and about a billion of them are wrong. Here is one way that seems to
# work most of the time when we do it:

#   Usage:
#       # Be sure the variable CompilerDesignNix is set to "ON" or "OFF"
#       SetCommonCompilerFlags()
#
#   Results:
#       Compiler flags are set that:
#           Enable a ton of warnings.
#           Treat warnings as errors are set.
#           Turn off compiler logos.
#           Enable Position independent code or otherwise fix linker issues.
#           Turn on C++11.
#
#       Set a variable with extra items to link against for use target_link_libraries
#

macro(SetCommonCompilerFlags)
    if(CompilerDesignNix)
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} \
        -std=c++11 -fno-strict-aliasing \
        -pedantic -Wall -Wextra -Wcast-align -Wcast-qual -Wctor-dtor-privacy \
        -Wdisabled-optimization -Wformat=2 -Winit-self -Wmissing-declarations \
        -Wmissing-include-dirs -Wold-style-cast -Wredundant-decls -Wshadow \
        -Wsign-conversion -Wsign-promo -Wstrict-overflow=2 -Wundef \
        -Wno-unused -Wparentheses -Werror")

        find_package(Threads)

        list(APPEND JagatiLinkArray ${CMAKE_THREAD_LIBS_INIT})
        set(JagatiLinkArray "${JagatiLinkArray}"  CACHE INTERNAL "" FORCE)

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

        # Removed -Winline it did not seem useful
        # He are some flags suggested for use an why they were not used:
        # -Werror - this is used to force others to resolve errors, when they wouldn't normally, I
        #           am resolving them as I go, but I want to option to run unit tests with warnings
        #           in place.
        # -Woverloaded-virtual - What did the author of this think virtual methods were for if not
        #                      - to be overloaded. This disagrees with explicit design decisions.
        # -Wmisleading-indentation - Help find errors revolving around tabs and control flow. I
        #                            want to enable this, but not until GCC 6.
        # -DDEBUG_DIRECTOR_EXCEPTION  # Used to make swig emit more
    else(CompilerDesignNix)
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /nologo /Wall /WX /MT \
            /wd4710 /wd4514 /wd4251 /wd4820 /wd4571 /wd4626 /wd4221 /wd4711"
        )

        # Used:
        # /nologo - Skips a few lines of microsoft branding.
        # /Wall - Enable all warnings.
        # /WX - treat warnings as errors.
        # /MT - Statically link against the threading capable standard library.

        # Ignoring:
        # C4710 - Failing to inline things in std::string, well that is STL's fault, not mine.
        # C4514 - An unused function was optimized out. Why is the optimizer doing its job a
        # warning?!
        # C4251 - Is safe to ignore per STL
# http://stackoverflow.com/questions/24511376/how-to-dllexport-a-class-derived-from-stdruntime-error
        # C4820 - When padding is added for performance reasons.
    endif(CompilerDesignNix)

    if("${ParentProject}" STREQUAL "${PROJECT_NAME}")
        message(STATUS "\tC++ compiler and linker flags: ${CMAKE_CXX_FLAGS}")
    endif("${ParentProject}" STREQUAL "${PROJECT_NAME}")
endmacro(SetCommonCompilerFlags)

########################################################################################################################
# A variable that contains an array of all the Jagati Packages

# Usage:
#   # Be certain to call project before calling this.
#   AddJagatiPackage()
#
# Result:
#   This package's name will be added to a list of packages currently loaded. This list can be
#   Accessed through the variable: JagatiPackageNameArray

macro(AddJagatiPackage)
    if("${ParentProject}" STREQUAL "${PROJECT_NAME}")
        list(APPEND JagatiPackageNameArray ${PROJECT_NAME} CACHE INTERNAL "" FORCE)
    else("${ParentProject}" STREQUAL "${PROJECT_NAME}")
        list(APPEND JagatiPackageNameArray ${PROJECT_NAME})
        set(JagatiPackageNameArray "${JagatiPackageNameArray}" CACHE INTERNAL "" FORCE)
    endif("${ParentProject}" STREQUAL "${PROJECT_NAME}")
endmacro(AddJagatiPackage)


########################################################################################################################
# This does what the above macros do, but this does it all together.

# Usage:
#   # Be certain to call project before calling this.
#   StandardJagatiSetup()
#
# Result:
#       The Parent scope will attempt to be claimed, many variables for compiler, OS, Debug and locations
#       will be set, see above. Compiler Flags will be set.

macro(StandardJagatiSetup)
    ClaimParentProject()
    CreateLocations()
    AddJagatiPackage()
    if("${ParentProject}" STREQUAL "${PROJECT_NAME}")
        message(STATUS "Determining platform specific details.")
        IdentifyOS()
        IdentifyCompiler()
        IdentifyDebug()
        SetCommonCompilerFlags()
    endif("${ParentProject}" STREQUAL "${PROJECT_NAME}")
endmacro(StandardJagatiSetup)

########################################################################################################################
# This set a single variable that all Mezzanine libraries will use when building libraries.

# Usage:
#   Don't. This can easily be controlled via the BuildStaticLibraries cache level option. When used as part any
#   Mezzanine package.
#   ChooseLibraryType("ON")
#   ChooseLibraryType("OFF")
#
# Result:
#   A variable called LibraryBuildType is set with either "STATIC" if true is passed or
#   "SHARED" if false is passed.
#
# Notes:
#   Forcing this into the effectively makes it global is that really what we want? For now it seems ok.

function(Internal_ChooseLibraryType TrueForStatic)
    if(TrueForStatic)
        set(LibraryBuildType "STATIC" CACHE INTERNAL "" FORCE)
    else(TrueForStatic)
        set(LibraryBuildType "SHARED" CACHE INTERNAL "" FORCE)
    endif(TrueForStatic)
endfunction(Internal_ChooseLibraryType TrueForStatic)

macro(ChooseLibraryType TrueForStatic)
    Internal_ChooseLibraryType(TrueForStatic)
    if("${ParentProject}" STREQUAL "${PROJECT_NAME}")
    else("${ParentProject}" STREQUAL "${PROJECT_NAME}")
        set(LibraryBuildType "${LibraryBuildType}" CACHE INTERNAL "" FORCE)
    endif("${ParentProject}" STREQUAL "${PROJECT_NAME}")
endmacro(ChooseLibraryType)

########################################################################################################################
########################################################################################################################
# Coverage Macros some tools that can be used to get code coverage numbers.
########################################################################################################################
########################################################################################################################
# Attempt to set code coverage flags.
#
# Usage:
#   Don't. This can easily be controlled via the CodeCoverage cache level option. When used as part any
#   Mezzanine package.
#   ChooseCodeCoverage("ON")
#   ChooseCodeCoverage("OFF")
#
# Result:
#   Flags will be added to the build that enable code coverage if present otherwise a warning will be printed.
#   Additionally a variable named CompilerCodeCoverage
#

macro(ChooseCodeCoverage TrueForEnabled)
    if(${TrueForEnabled})
        if(CompilerDesignNix)
            set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} --coverage")
            if("${ParentProject}" STREQUAL "${PROJECT_NAME}")
                set(CompilerCodeCoverage "ON" CACHE INTERNAL "" FORCE)
            else("${ParentProject}" STREQUAL "${PROJECT_NAME}")
            endif("${ParentProject}" STREQUAL "${PROJECT_NAME}")
        else(CompilerDesignNix)
            message(WARNING "Code coverage not supported on this compiler.")
            if("${ParentProject}" STREQUAL "${PROJECT_NAME}")
                set(CompilerCodeCoverage "OFF" CACHE INTERNAL "" FORCE)
            else("${ParentProject}" STREQUAL "${PROJECT_NAME}")
            endif("${ParentProject}" STREQUAL "${PROJECT_NAME}")
        endif(CompilerDesignNix)
    else(TrueForEnabled)
        if("${ParentProject}" STREQUAL "${PROJECT_NAME}")
            set(CompilerCodeCoverage "OFF" CACHE INTERNAL "" FORCE)
        else("${ParentProject}" STREQUAL "${PROJECT_NAME}")
        endif("${ParentProject}" STREQUAL "${PROJECT_NAME}")
    endif(${TrueForEnabled})
endmacro(ChooseCodeCoverage TrueForEnabled)

########################################################################################################################
# Attempt to create a target that builds code coverage metadata.
#
# Usage:
#   # Call it and pass the name of the executable and the list of source to be checked.
#   CreateCoverageTarget("ExecutableName" ${SourceList})
#
# Result:
#   A new build target called ${ExecutableName}Coverage will be added that will run copy source files where needed and
#   run gcov to generate profile and coverage notes and data that .
#

macro(CreateCoverageTarget ExecutableName SourceList)
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
    add_custom_target(${ExecutableName}Coverage DEPENDS ${CoveredTargetInputFiles} )
endmacro(CreateCoverageTarget SourceList)

########################################################################################################################
########################################################################################################################
# Optional Macros that not all Jagati packages will set, but culd be important for link or other
# build time activities.
########################################################################################################################
########################################################################################################################
# A variable that contains an array of all the Jagati Linkable Libraries provided by loaded
# packages

# Usage:
#   # Be certain to call project before calling this.
#   AddJagatiLibrary("LinkTarget")
#
# Result:
#   The passed file weill  be added to a list of libaries. This list can be
#   Accessed through the variable: JagatiLibraryArray
#
#   This will also create a variable call ${PROJECT_NAME}lib that will store the filename

macro(AddJagatiLibrary FileName)
    set(${PROJECT_NAME}Lib "${FileName}")
    list(APPEND JagatiLibraryArray ${FileName})
    set(${PROJECT_NAME}Lib "${FileName}" CACHE INTERNAL "" FORCE)
    message(STATUS "Lib variable: '${PROJECT_NAME}lib' - ${${PROJECT_NAME}lib}")
endmacro(AddJagatiLibrary FileName)

########################################################################################################################


macro(AddJagatiDoxInput FileName)
    list(APPEND JagatiDoxArray ${FileName})
    set(${PROJECT_NAME}Dox "${FileName}" CACHE INTERNAL "" FORCE)
    message(STATUS "Dox Input: '${PROJECT_NAME}Dox' - ${${PROJECT_NAME}Dox}")
endmacro(AddJagatiDoxInput FileName)

########################################################################################################################
# Some projects have many files that are created at compile time. This can cause the build system to
# as complex as the source code. Most software developers want to spend their reasoning about the
# code and not the code that makes the code. In general the Jagati or a specific package should
# handle meta-programming where possible.

# Usage:
#   # Call any time after the parent scope is claimed. The first parameter is the name of a
#   # preprocessor to create, and the second is the value, "" for no value and the third argument
#   # is for determining if the remark should be enabled(true) or remarked out(false).
#       AddJagatiConfig("FOO" "BAR" ON)
#       AddJagatiConfig("EmptyOption" "" ON)
#       AddJagatiConfig("Remarked_FOO" "BAR" OFF)
#       AddJagatiConfig("EmptyOption_nope" "" OFF)
#
# Result:
#   Adds a preprocessor macro to string that config headers can directly include. Here is the
#   output from the sample above:
#       #define FOO BAR
#       #define EmptyOption
#       //#define Remarked_FOO BAR
#       //#define EmptyOption_nope
#
#   The set variable will be ${PROJECT_NAME}JagatiConfig
#
#   This sets the variables ${PROJECT_NAME}JagatiConfigRaw to similar contents to
#   ${PROJECT_NAME}JagatiConfig, Except the Raw version has no remarks.
#
#   This also writes to the variable "JagatiConfigRemarks" in the parentmost scope as a temporary.

# This is an implementaion Detail of AddJagatiConfig, This is needed because macro parameters are
# neither variables, nor constants and cannot be used in if statements checking implicit
# truthiness.
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
# Emit a config file

# Usage:
#   # Call after 0 or more calls to AddJagatiConfig and the parentmost scope has been claimed.
#   EmitConfig()
#
# Result:
#   This will create a config file with all the config item added by AddJagatiConfig in this project
#   and this will set two variables:
#       ${PROJECT_NAME}ConfigFilename - The absolute path and filename of the file writtern, this
#           derived from the variable ${PROJECT_NAME}GenHeadersDir and will contain the project name
#       ${PROJECT_NAME}ConfigContent - The contents of what was emitted in the header file.
#

macro(EmitConfig)

set(ConfigHeader
"// © Copyright 2010 - 2016 BlackTopp Studios Inc.\n\
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
*/\n\
#ifndef ${PROJECT_NAME}_config_h\n\
#define ${PROJECT_NAME}_config_h\n\
\n\
#ifndef DOXYGEN\n")


    set(DoxygenElse "\n\n#else // DOXYGEN\n")
    set(ConfigFooter "\n\n#endif // DOXYGEN\n\n#endif\n")

    set(${PROJECT_NAME}ConfigFilename "${${PROJECT_NAME}GenHeadersDir}${PROJECT_NAME}Config.h")
    if("${ParentProject}" STREQUAL "${PROJECT_NAME}")
    else("${ParentProject}" STREQUAL "${PROJECT_NAME}")
        set(${PROJECT_NAME}ConfigFilename "${${PROJECT_NAME}ConfigFilename}" PARENT_SCOPE)
    endif("${ParentProject}" STREQUAL "${PROJECT_NAME}")

    set(${PROJECT_NAME}ConfigContent "${ConfigHeader}${${PROJECT_NAME}JagatiConfig}\
${DoxygenElse}${${PROJECT_NAME}JagatiConfigRaw}${ConfigFooter}")
    if("${ParentProject}" STREQUAL "${PROJECT_NAME}")
    else("${ParentProject}" STREQUAL "${PROJECT_NAME}")
        set(${PROJECT_NAME}ConfigContent "${${PROJECT_NAME}ConfigContent}" PARENT_SCOPE)
    endif("${ParentProject}" STREQUAL "${PROJECT_NAME}")

    file(WRITE "${${PROJECT_NAME}ConfigFilename}" "${${PROJECT_NAME}ConfigContent}")
endmacro(EmitConfig)

########################################################################################################################
########################################################################################################################
# Test Main creation
########################################################################################################################
########################################################################################################################

# Usage:
#   EmitTestCode()
#
# Results:
#       A file called ${PROJECT_NAME}_tester.cpp is emitted int the build output directory. This can be used to generate
#   a unit test executable
macro(EmitTestCode)
    set(TestsHeader
"// © Copyright 2010 - 2016 BlackTopp Studios Inc.\n\
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
*/\n\
\n\
#include \"mezztest.h\"\n\
\n")

    set(TestsIncludes "// Start Dynamically Included Headers\n")
    foreach(TestName ${${PROJECT_NAME}TestList})
        set(TestFile "${TestName}.h")
        set(TestsIncludes "${TestsIncludes}\n    #include \"${TestFile}\"")
    endforeach(TestName ${${PROJECT_NAME}TestList})
    set(TestsIncludes "${TestsIncludes}\n\n// End Dynamically Included Headers")

    set(TestsMainHeader
"\n\n\
int main (int argc, char** argv)\n\
{\n\
    Mezzanine::Testing::CoreTestGroup TestInstances;\n\n")

    set(TestsInit "    // Start Dynamically Instanced Tests\n")
    foreach(TestName ${${PROJECT_NAME}TestList})
        set(TestsInit "${TestsInit}\n\
        ${TestName}Tests ${TestName}Instance;\n\
        TestInstances[\"${TestName}\"] = &${TestName}Instance;\n")
    endforeach(TestName ${${PROJECT_NAME}TestList})
    set(TestsInit "${TestsInit}\n    // Start Dynamically Instanced Tests\n\n")

    set(TestsMainFooter "\
    return Mezzanine::Testing::MainImplementation(argc, argv, TestInstances); \n\
}\n\
\n")

    set(${PROJECT_NAME}TestsContent
        "${TestsHeader}${TestsIncludes}${TestsMainHeader}${TestsInit}${TestsMainFooter}"
    )

    set(${PROJECT_NAME}TesterFilename "${${PROJECT_NAME}GenSourceFolder}${PROJECT_NAME}_tester.cpp")
    if("${ParentProject}" STREQUAL "${PROJECT_NAME}")
    else("${ParentProject}" STREQUAL "${PROJECT_NAME}")
        set(${PROJECT_NAME}TesterFilename "${${PROJECT_NAME}TestFilename}" PARENT_SCOPE)
    endif("${ParentProject}" STREQUAL "${PROJECT_NAME}")

    file(WRITE "${${PROJECT_NAME}TesterFilename}" "${${PROJECT_NAME}TestsContent}")
endmacro(EmitTestCode)

########################################################################################################################

# Not added to API yet, do not use
macro(AddTestTarget ExtraSourceFiles)
    include_directories("${TestTestDir}")

    set(HeaderFilesWithTests "")
    foreach(TestName ${${PROJECT_NAME}TestList})
        set(TestFile "${TestName}.h")
        list(APPEND HeaderFilesWithTests "${TestTestDir}/${TestFile}")
    endforeach(TestName ${${PROJECT_NAME}TestList})

    add_library(
        ${TestLib}
        ${LibraryBuildType}
        ${TesterHeaderFiles}
        ${TesterSourceFiles}
        ${ExtraSourceFiles}
        ${HeaderFilesWithTests}
    )

    target_link_libraries(${TestLib} ${StaticFoundationLib})
    add_executable(Test_Tester ${HeaderFiles} ${TestSourceFiles} ${${PROJECT_NAME}TesterFilename})
    target_link_libraries(Test_Tester ${StaticFoundationLib} ${TestLib})
endmacro(AddTestTarget ExtraSourceFiles)

########################################################################################################################
# Usage:
#   AddTest("TestName")
#
# Results:
#   This will create a list containing the names of all the tests added.
#       ${PROJECT_NAME}TestList - This is created or appended too.
#
#   The followings lines will be added to the file ${PROJECT_NAME}_tester.cpp:
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
macro(AddTest TestName)
    list(APPEND ${PROJECT_NAME}TestList ${TestName})
    set(${PROJECT_NAME}TestList "${${PROJECT_NAME}TestList}")
    message(STATUS "  Adding Test: '${TestName}'")
endmacro(AddTest TestName)

########################################################################################################################
# Usage:
#   AddTestDirectory("TestDirectory")
#
# Results:
#   This call add test for each header in the passed directory

macro(AddTestDirectory TestDir)
    include_directories(${TestDir})
    message(STATUS "Adding all tests in: '${TestDir}'")
    file(GLOB TestFileList "${TestDir}*.h")
    foreach(TestFilename ${TestFileList})
        message(STATUS "  Adding test File: '${TestFilename}'")
        get_filename_component(TestName "${TestFilename}" NAME_WE)
        AddTest("${TestName}")
    endforeach(TestFilename ${TestFileList})
endmacro(AddTestDirectory)


########################################################################################################################
########################################################################################################################
# Basic Display Functionality
########################################################################################################################
########################################################################################################################
# Tabbed list Printing

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
# Basic Option Tools

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
# Getting Jagati packages, What URLs and functions can we use to get Jagati Packages and know what
# Exists?
########################################################################################################################
########################################################################################################################

# Package URLs

set(Mezz_StaticFoundation_GitURL "https://github.com/BlackToppStudios/Mezz_StaticFoundation.git")
set(Mezz_Test_GitURL "https://github.com/BlackToppStudios/Mezz_Test.git")

########################################################################################################################
# Package Download experiment

set(JagatiPackageDirectory "$ENV{JAGATI_DIR}" CACHE PATH "Folder for storing Jagati Packages.")
if(EXISTS "${JagatiPackageDirectory}")
else(EXISTS "${JagatiPackageDirectory}")
    message(WARNING " JagatiPackageDirectory is not set, this needs to be a valid folder \
where Mezzanine Libraries can be downloaded to. You set the Environment variable 'JAGATI_DIR' or \
set it in CMake, if left unset this will create a folder in the output directory.")
    set(JagatiPackageDirectory "{${PROJECT_NAME}BinaryDir}JagatiPackages/" CACHE
        PATH "Folder for storing Jagati Packages.")
endif(EXISTS "${JagatiPackageDirectory}")

# To insure that all the packages are downloaded this can be added as a dependencies to any target.

if("${ParentProject}" STREQUAL "${FileName}")
    add_custom_target(
        Download
        COMMENT "Checking for Jagati Packages to Download"
    )
endif("${ParentProject}" STREQUAL "${FileName}")

########################################################################################################################
# Any package wanting to use another can include it with this function
function(IncludeJagatiPackage PackageName)
    include(ExternalProject)

    if("${PackageName}" MATCHES "MEZZ_.*")
    else("${PackageName}" MATCHES "MEZZ_.*")
        set(PackageName "Mezz_${PackageName}")
    endif("${PackageName}" MATCHES "MEZZ_.*")

    find_program (GitExecutable git DOC "The git executable the Jagati will use to download packages." )
    if(NOT EXISTS "${GitExecutable}")
        message(FATAL_ERROR "Git was not found or specified wrong currently GitExecutable is: ${GitExecutable}")
    endif(NOT EXISTS "${GitExecutable}")

    set(GitURL "${${PackageName}_GitURL}")
    if("${GitURL}" STREQUAL "")
        message(FATAL_ERROR "Could not find Package named ${PackageName}")
    endif("${GitURL}" STREQUAL "")

    if("${JagatiPackageDirectory}" STREQUAL "")
        #message(FATAL_ERROR "Could not find Package named ${PackageName}")
        set(JagatiPackageDirectory "${${ParentProject}BinaryDir}JagatiPackages/")
    endif("${JagatiPackageDirectory}" STREQUAL "")

    set(TargetPackageSourceDir "${JagatiPackageDirectory}${PackageName}/")
    set(TargetPackageBinaryDir "${JagatiPackageDirectory}${PackageName}-build/")

    if(EXISTS "${TargetPackageSourceDir}CMakeLists.txt")
        execute_process(
            WORKING_DIRECTORY ${TargetPackageSourceDir}
            COMMAND ${GitExecutable} pull ${GitURL}
        )
    else(EXISTS "${TargetPackageSourceDir}CMakeLists.txt")
        file(MAKE_DIRECTORY "${JagatiPackageDirectory}")
        execute_process(
            WORKING_DIRECTORY ${JagatiPackageDirectory}
            COMMAND ${GitExecutable} clone ${GitURL}
        )
    endif(EXISTS "${TargetPackageSourceDir}CMakeLists.txt")

    add_subdirectory(
        "${TargetPackageSourceDir}"
        "${TargetPackageBinaryDir}"
        EXCLUDE_FROM_ALL
    )

    #add_dependencies(Download "${PackageName}")
endfunction(IncludeJagatiPackage PackageName)


