# © Copyright 2010 - 2018 BlackTopp Studios Inc.
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

# This is the basic package manager for the Mezzanine, called the Jagati. This will track and download packages from git
# repositories. This will handle centrally locating Mezzanine packages and provide tools for finding and linking against
# them appropriately. This will not be included directly in git repositories, but rather a small download snippet will
# ensure this stays up to date.

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

# Prevent the Jagati from being loaded twice.
if(JagatiVersion)
    message(STATUS "Already loaded Jagati version '${JagatiVersion}', not loading again.")
    return()
else(JagatiVersion)
    set(JagatiVersion "0.22.4")
    message(STATUS "Preparing Jagati Version: ${JagatiVersion}")
endif(JagatiVersion)

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

# TODO - Move this into an external index file.

set(Mezz_StaticFoundation_GitURL    "https://github.com/BlackToppStudios/Mezz_StaticFoundation.git")
set(Mezz_Test_GitURL                "https://github.com/BlackToppStudios/Mezz_Test.git")
set(Mezz_Foundation_GitURL          "https://github.com/BlackToppStudios/Mezz_Foundation.git")

########################################################################################################################
# Other Variables

set(MEZZ_Copyright
"// © Copyright 2010 - 2018 BlackTopp Studios Inc.\n\
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
# From here to the next thick banner is the Cross-Compiling utilities provided by the Jagati, with a primary focus on
# compiling to Android and iOS.
########################################################################################################################
########################################################################################################################

########################################################################################################################
# EnableIOSCrossCompile
#
# This is used to configure the basic build settings for projects that wish to build on iOS.
# Some projects may want or need to perform additional configuration than what is provided
# here to get a working build.
#
# This attempts to make sane settings for building with either the live OS or simulator in
# mind as possible targets.
#
# Usage:
#   # Be certain to call project() before calling this.  Ideally this should be called
#   # just after downloading the Jagati, prior to any other calls.
#   EnableIOSCrossCompile()
#
# Result:
#   The following options will all be created, made available, and printed:
#      MEZZ_iOSTarget
#      MEZZ_iOSCompanyName
#

macro(EnableIOSCrossCompile)
    if( NOT CMAKE_GENERATOR STREQUAL "Xcode" )
        message(FATAL_ERROR "XCode generator required to cross-compile to iOS.")
    endif( NOT CMAKE_GENERATOR STREQUAL "Xcode" )
    if( NOT LibraryBuildType STREQUAL "STATIC" )
        message(FATAL_ERROR "iOS only permits static builds.")
    endif( NOT LibraryBuildType STREQUAL "STATIC" )

    set(CMAKE_SYSTEM_NAME "AppleIOS")
    if( NOT "$ENV{IOS_SDK_VERSION}" STREQUAL "" )
        set(CMAKE_SYSTEM_VERSION $ENV{IOS_SDK_VERSION})
    endif( NOT "$ENV{IOS_SDK_VERSION}" STREQUAL "" )

    set(CMAKE_SYSTEM_PROCESSOR arm)
    set(CMAKE_CROSSCOMPILING_TARGET IOS)
    set(IOS ON)
    set(UNIX ON)
    set(APPLE ON)

    set(CMAKE_MACOSX_BUNDLE YES)
    set(XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY "iPhoneDeveloper")
    set(XCODE_ATTRIBUTE_CODE_SIGNING_REQUIRED "NO")

    # Required as of cmake 2.8.10
    set(CMAKE_OSX_DEPLOYMENT_TARGET "" CACHE STRING "Force unset of the deployment target for iOS" FORCE)

    # Skip the platform compiler checks for cross compiling
    set(CMAKE_CXX_COMPILER_WORKS TRUE)
    set(CMAKE_C_COMPILER_WORKS TRUE)

    # Set Bundle stuff
    if( NOT DEFINED MEZZ_iOSCompanyName )
        set(MEZZ_iOSCompanyName "BlackToppStudios")
    endif( NOT DEFINED MEZZ_iOSCompanyName )
    set(MEZZ_iOSCompanyName ${MEZZ_iOSCompanyName} CACHE STRING "The name of the company building the iOS target.  Used to generate the Bundle ID.")
    set(MACOSX_BUNDLE_GUI_IDENTIFIER "com.${MEZZ_iOSCompanyName}.\${PRODUCT_NAME:rfc1034identifier}")

    # Determine our target
    option(MEZZ_iOSSimulator "Whether or not to compile iOS binaries to target a simulator. Disable for physical device." ON)
    if( MEZZ_iOSSimulator )
        set(XCODE_IOS_TARGET iphonesimulator)
        set(IOS_ARCH x86_64)
        message(STATUS "Configuring iOS build for Simulator using architecture(s): ${IOS_ARCH}")
    else( MEZZ_iOSSimulator )
        set(XCODE_IOS_TARGET iphoneos)
        set(IOS_ARCH armv7 armv7s arm64)
        message(STATUS "Configuring iOS build for Device using architecture(s): ${IOS_ARCH}")
    endif( MEZZ_iOSSimulator )
    set(CMAKE_OSX_ARCHITECTURES ${IOS_ARCH} CACHE STRING "Build architecture for iOS")

    # We need to find the iOS SDK to use
    execute_process(COMMAND xcodebuild -version -sdk ${XCODE_IOS_TARGET} Path
                    OUTPUT_VARIABLE CMAKE_OSX_SYSROOT
                    ERROR_QUIET OUTPUT_STRIP_TRAILING_WHITESPACE)
    message(STATUS "Using SDK: ${CMAKE_OSX_SYSROOT} for platform: ${MEZZ_iOSTarget}")

    # Hidden visibilty is required for cxx on iOS
    set(CMAKE_C_FLAGS_INIT "")
    set(CMAKE_CXX_FLAGS_INIT "-fvisibility=hidden -fvisibility-inlines-hidden -isysroot ${CMAKE_OSX_SYSROOT}")
endmacro(EnableIOSCrossCompile)

########################################################################################################################
########################################################################################################################
# From here to the next thick banner are macros to set variables in the scope of the calling CMake or cache project that
# all Jagati packages should set. The idea is that every variable needed to link or inspect the source will be cleanly
# set and easy to inspect, from just the output of CMake and a sample CMakeLists.txt.
########################################################################################################################
########################################################################################################################

########################################################################################################################
# ClaimParentProject
#
# This is used to determine what the parent-most project is. Whichever project calls this first will be presumed to be
# the parent-most scope and be the only one that doesn't set all of it's variables in its parent's scope.
#
# This is also used to initialize a few internal variables that need to only be initilized once.
#
# Usage:
#   # Be certain to call project() before calling this.
#   # Call this from the main project before calling anything else to insure your project is root.
#   ClaimParentProject()
#
# Result:
#   The ParentProject variable will all be set, made available, printed, and other Jagati projects
#   will know not to pollute your namespace.
#

macro(ClaimParentProject)
    if(ParentProject)
        # It is already set so we must be a child.
        message(STATUS "Project '${PROJECT_NAME}' acknowledges '${ParentProject}' as the Parent Project.")
    else(ParentProject)
        message(STATUS "Claiming '${PROJECT_NAME}' as the Parent Project.")
        set(ParentProject "${PROJECT_NAME}" CACHE INTERNAL "Name of the parent project")
    endif(ParentProject)
endmacro(ClaimParentProject)

########################################################################################################################
# CreateLocationVars
#
# This will create a number of variables in the scope of the calling script that correspond to the name of the project
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

    # TODO: Figure out the best way to accept already set versions of these if set already.

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
            message(STATUS "${PackageDirectory_MissingWarning}")
            set(MEZZ_PackageDirectory "${PackageDirectory_Default}" CACHE PATH "${PackageDirectory_Description}" FORCE)
        endif(EXISTS "${MEZZ_PackageDirectory}")
    endif(EXISTS "$ENV{MEZZ_PACKAGE_DIR}")

    if(NOT "${MEZZ_PackageDirectory}" MATCHES "^.*/$") # Append Slash if needed
        set(MEZZ_PackageDirectory "${MEZZ_PackageDirectory}/")
    endif(NOT "${MEZZ_PackageDirectory}" MATCHES "^.*/$")

    #######################################
    message(STATUS "Variables for '${PROJECT_NAME}'")

    message(STATUS "Derived Output folders")
    message(STATUS "'${PROJECT_NAME}BinaryDir' - ${${PROJECT_NAME}BinaryDir}")
    message(STATUS "'${PROJECT_NAME}GenHeadersDir' - ${${PROJECT_NAME}GenHeadersDir}")
    message(STATUS "'${PROJECT_NAME}GenSourceDir' - ${${PROJECT_NAME}GenSourceDir}")

    message(STATUS "Derived Input folders")
    message(STATUS "'${PROJECT_NAME}RootDir' - ${${PROJECT_NAME}RootDir}")
    message(STATUS "'${PROJECT_NAME}DoxDir' - ${${PROJECT_NAME}DoxDir}")
    message(STATUS "'${PROJECT_NAME}IncludeDir' - ${${PROJECT_NAME}IncludeDir}")
    message(STATUS "'${PROJECT_NAME}LibDir' - ${${PROJECT_NAME}LibDir}")
    message(STATUS "'${PROJECT_NAME}SourceDir' - ${${PROJECT_NAME}SourceDir}")
    message(STATUS "'${PROJECT_NAME}SwigDir' - ${${PROJECT_NAME}SwigDir}")
    message(STATUS "'${PROJECT_NAME}TestDir' - ${${PROJECT_NAME}TestDir}")

    message(STATUS "MEZZ_PackageDirectory - ${MEZZ_PackageDirectory}")
    message(STATUS "ENV{MEZZ_PACKAGE_DIR} - ${MEZZ_PackageDirectory}")
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
    # Derived Output Folders
    file(MAKE_DIRECTORY ${${PROJECT_NAME}GenHeadersDir})
    file(MAKE_DIRECTORY ${${PROJECT_NAME}GenSourceDir})

    include_directories(${${PROJECT_NAME}IncludeDir} ${${PROJECT_NAME}GenHeadersDir})

    # Derived Input Folders
    file(MAKE_DIRECTORY ${${PROJECT_NAME}DoxDir})
    file(MAKE_DIRECTORY ${${PROJECT_NAME}IncludeDir})
    file(MAKE_DIRECTORY ${${PROJECT_NAME}LibDir})
    file(MAKE_DIRECTORY ${${PROJECT_NAME}SourceDir})
    file(MAKE_DIRECTORY ${${PROJECT_NAME}SwigDir})
    file(MAKE_DIRECTORY ${${PROJECT_NAME}TestDir})
endmacro(CreateLocations)

########################################################################################################################
# DecideOutputNames
#
# This will create a few variables in the scope of the calling script or cache that correspond to the name of the
# project so that they can readily be referenced from other project including the caller as a subproject.
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

    if(${PROJECT_NAME}BinTarget)
        set(${PROJECT_NAME}BinTarget "${${PROJECT_NAME}BinTarget}" CACHE INTERNAL "" FORCE)
    else(${PROJECT_NAME}BinTarget)
        set(${PROJECT_NAME}BinTarget "${PROJECT_NAME}_Main" CACHE INTERNAL "" FORCE)
    endif(${PROJECT_NAME}BinTarget)
    message(STATUS "'${PROJECT_NAME}BinTarget'  - ${${PROJECT_NAME}BinTarget}")

    if(${PROJECT_NAME}LibTarget)
        set(${PROJECT_NAME}LibTarget "${${PROJECT_NAME}LibTarget}" CACHE INTERNAL "" FORCE)
    else(${PROJECT_NAME}LibTarget)
        set(${PROJECT_NAME}LibTarget "${PROJECT_NAME}" CACHE INTERNAL "" FORCE)
    endif(${PROJECT_NAME}LibTarget)
    message(STATUS "'${PROJECT_NAME}LibTarget'  - ${${PROJECT_NAME}LibTarget}")

    if(${PROJECT_NAME}TestTarget)
        set(${PROJECT_NAME}TestTarget "${${PROJECT_NAME}TestTarget}" CACHE INTERNAL "" FORCE)
    else(${PROJECT_NAME}TestTarget)
        set(${PROJECT_NAME}TestTarget "${PROJECT_NAME}_Tester" CACHE INTERNAL "" FORCE)
    endif(${PROJECT_NAME}TestTarget)
    message(STATUS "'${PROJECT_NAME}TestTarget' - ${${PROJECT_NAME}TestTarget}")
endmacro(DecideOutputNames)

########################################################################################################################
# IdentifyCPU
# Clearly CMake knows how to ID the CPU without our help, but there are tricks to it and builtin tools are not as well
# identified as the could be. Hopefully this overcomes these minor shortfalls and provide a single source of truth for
# build time CPU determination in the Jagati/Mezzanine.
#
# Usage:
#   # Be the parentmost cmake scope or this has no effect.
#   IdentifyCPU()
#
# Result:
#   Details about CPU are displayed and the following variables are set:
#
#       CpuIsKnown   - ON/OFF
#       CpuIsX86     - ON/OFF
#       CpuIsAmd64   - ON/OFF
#       CpuIsArm     - ON/OFF
#
#       If CpuIsKnown is set at least one of the other values will betrueas well, otherwise they will all be OFF.

macro(IdentifyCPU)

    # TODO - This may need to detect more CPU types so correct optimizations can be enabled when crosscompiling or
    # targetting older CPUs.

    message(STATUS "Checking CPU information this system.")

    set(CpuIsKnown OFF)
    set(CpuIsX86 OFF)
    set(CpuIsAmd64 OFF)
    set(CpuIsArm OFF)

    if(CMAKE_SYSTEM_PROCESSOR MATCHES "arm")
        set(CpuIsKnown ON)
        set(CpuIsArm ON)
    endif(CMAKE_SYSTEM_PROCESSOR MATCHES "arm")

    if(CMAKE_SYSTEM_PROCESSOR MATCHES "(x86)|(X86)")
        set(CpuIsKnown ON)
        set(CpuIsX86 ON)
    endif(CMAKE_SYSTEM_PROCESSOR MATCHES "(x86)|(X86)")

    if(CMAKE_SYSTEM_PROCESSOR MATCHES "(amd64)|(AMD64)")
        set(CpuIsKnown ON)
        set(CpuIsX86 ON)
        set(CpuIsAmd64 ON)
    endif(CMAKE_SYSTEM_PROCESSOR MATCHES "(amd64)|(AMD64)")

    message(STATUS "'CpuIsKnown' - ${CpuIsKnown}")
    message(STATUS "'CpuIsX86'   - ${CpuIsX86}")
    message(STATUS "'CpuIsAmd64' - ${CpuIsAmd64}")
    message(STATUS "'CpuIsArm'   - ${CpuIsArm}")
endmacro(IdentifyCPU)


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
#       SystemIsIOS     - ON/OFF
#
#       Platform32Bit - ON/OFF
#       Platform64Bit - ON/OFF
#
#       CatCommand - Some command that can print files when supplied a filename as only argument.
#       PlatformDefinition - LINUX/WINDOWS/MACOSX
#

macro(IdentifyOS)
    if("${ParentProject}" STREQUAL "${PROJECT_NAME}")
        message(STATUS "Detecting OS:")

        set(SystemIsLinux OFF)
        set(SystemIsWindows OFF)
        set(SystemIsMacOSX OFF)
        set(SystemIsIOS OFF)

        if("${CMAKE_SYSTEM_NAME}" STREQUAL "Linux")
            message(STATUS "Detected OS as 'Linux'.")
            set(SystemIsLinux ON)
        endif("${CMAKE_SYSTEM_NAME}" STREQUAL "Linux")
        if("${CMAKE_SYSTEM_NAME}" STREQUAL "Windows")
            message(STATUS "Detected OS as 'Windows'.")
            set(SystemIsWindows ON)
        endif("${CMAKE_SYSTEM_NAME}" STREQUAL "Windows")
        if("${CMAKE_SYSTEM_NAME}" STREQUAL "Darwin")
            message(STATUS "Detected OS as 'Mac OS X'.")
            set(SystemIsMacOSX ON)
        endif("${CMAKE_SYSTEM_NAME}" STREQUAL "Darwin")
        if("${CMAKE_SYSTEM_NAME}" STREQUAL "AppleIOS")
            message(STATUS "Detected OS as 'iOS'.")
            set(SystemIsIOS ON)
        endif("${CMAKE_SYSTEM_NAME}" STREQUAL "AppleIOS")
        message(STATUS "'SystemIsLinux'   - ${SystemIsLinux}")
        message(STATUS "'SystemIsWindows' - ${SystemIsWindows}")
        message(STATUS "'SystemIsMacOSX'  - ${SystemIsMacOSX}")
        message(STATUS "'SystemIsIOS'     - ${SystemIsIOS}")

        if(SystemIsLinux)
            message(STATUS "Setting specific variables for 'Linux'.")
            set(CatCommand "cat")
            set(PlatformDefinition "LINUX")
        endif(SystemIsLinux)
        if(SystemIsWindows)
            message(STATUS "Setting specific variables for 'Windows'.")
            set(CatCommand "type")
            set(PlatformDefinition "WINDOWS")
        endif(SystemIsWindows)
        if(SystemIsMacOSX)
            message(STATUS "Setting specific variables for 'Mac OS X'.")
            set(CatCommand "cat")
            set(PlatformDefinition "MACOSX")
        endif(SystemIsMacOSX)
        if(SystemIsIOS)
            message(STATUS "Setting specific variables for 'iOS'.")
            set(CatCommand "cat")
            set(PlatformDefinition "IOS")
        endif(SystemIsIOS)
        message(STATUS "'CatCommand' - ${CatCommand}")

        set(Platform32Bit OFF)
        set(Platform64Bit OFF)

        if("${CMAKE_SIZEOF_VOID_P}" EQUAL "8")
            message(STATUS "Detected a 64 bit platform.")
            set(Platform64Bit ON)
        else("${CMAKE_SIZEOF_VOID_P}" EQUAL "8")
            message(STATUS "Detected a 32 bit platform.")
            set(Platform32Bit ON)
        endif("${CMAKE_SIZEOF_VOID_P}" EQUAL "8")
        message(STATUS "'Platform64Bit' - ${Platform64Bit}")
        message(STATUS "'Platform32Bit' - ${Platform32Bit}")

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
#   # Be the parentmost cmake scope or this has no effect.
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
        message(STATUS "Detecting Compiler:")

        # If compiler ID is unset set try to guess it
        if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "")
            if(CMAKE_CXX_COMPILER MATCHES "/em\\+\\+(-[a-zA-Z0-9.])?$")
                set(CMAKE_CXX_COMPILER_ID "Emscripten")
            endif(CMAKE_CXX_COMPILER MATCHES "/em\\+\\+(-[a-zA-Z0-9.])?$")
        endif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "")

        message(STATUS "CMAKE_CXX_COMPILER_ID: '${CMAKE_CXX_COMPILER_ID}'")

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
            message(STATUS "Detected compiler as 'GCC'.")
            set(CompilerIsGCC ON)
            set(CompilerDesignNix ON)
            set(CompilerDetected ON)
            set(CompilerSupportsCoverage ON)
        endif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")

        if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "AppleClang")
            message(STATUS "Detected compiler as 'AppleClang' using Clang settings.")
            set(CompilerIsClang ON)
            set(CompilerDesignNix ON)
            set(CompilerDetected ON)
            set(CompilerSupportsCoverage ON)
        endif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "AppleClang")

        if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
            message(STATUS "Detected compiler as 'Clang'.")
            set(CompilerIsClang ON)
            set(CompilerDesignNix ON)
            set(CompilerDetected ON)
            set(CompilerSupportsCoverage ON)
        endif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")

        if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Intel")
            message(STATUS "Detected compiler as 'Intel'.")
            set(CompilerIsIntel ON)
            set(CompilerDesignNix ON)
            set(CompilerDetected ON)
        endif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Intel")

        if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Emscripten")
            message(STATUS "Detected compiler as 'Emscripten'.")
            set(CompilerIsEmscripten ON)
            set(CompilerDesignNix ON)
            set(CompilerDetected ON)
        endif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Emscripten")

        if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")
            message(STATUS "Detected compiler as 'MSVC'.")
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
            message(STATUS "Presuming *nix style compiler.")
        endif(CompilerDesignNix)

        if(CompilerDesignMS)
            message(STATUS "Presuming ms style compiler.")
        endif(CompilerDesignMS)

        if(NOT CompilerDetected)
            message(FATAL_ERROR "Compiler not detected, Exiting! This can be supressed by removing check in the\
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
#   # Be the parentmost cmake scope or this has no effect.
#   IdentifyDebug()
#
# Result:
#   Details about compiler debug symbol generation state are displayed and the following variables are set:
#
#       CompilerDebug    - ON/OFF
#

macro(IdentifyDebug)
    if("${ParentProject}" STREQUAL "${PROJECT_NAME}")
        message(STATUS "Detecting Debug:")
        message(STATUS "CMAKE_BUILD_TYPE: '${CMAKE_BUILD_TYPE}'")

        set(CompilerDebug OFF)

        if("${CMAKE_BUILD_TYPE}" MATCHES "[Dd][Ee][Bb]")
            message(STATUS "Detected compiler as creating debug data.")
            set(CompilerDebug ON)
        else("${CMAKE_BUILD_TYPE}" MATCHES "[Dd][Ee][Bb]")
            message(STATUS "Detected compiler as skipping debug data.")
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
#       # Also set the CPU flags set by IdentifyCPU correcting for the platform you are building for.
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

        # Emscripten is a unique beast.
        if(CompilerIsEmscripten)
            # The same warnings as clang.
            set(CMAKE_CXX_FLAGS "-s DISABLE_EXCEPTION_CATCHING=0 ${CMAKE_CXX_FLAGS} -Weverything \
            -Wno-documentation-unknown-command -Wno-c++98-compat")

            # This is exe on windows and nothing on most platforms, but without this emscripten output is... wierd.
            set(CMAKE_EXECUTABLE_SUFFIX ".js")
        else(CompilerIsEmscripten)
            # Store thread library link information for later.
            set(THREADS_PREFER_PTHREAD_FLAG ON)
            find_package(Threads)
            set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${CMAKE_THREAD_LIBS_INIT}")

            # A few checks that are very specific.
            if(CpuIsAmd64 AND Platform64Bit)
                set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -m64")
            endif(CpuIsAmd64 AND Platform64Bit)
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

        if(NOT MEZZ_Debug)
            # TODO - This needs to respect crosscompiling situations.
            set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O2 -mtune=native")
        endif(NOT MEZZ_Debug)

        # Removed -Winline it did not seem useful.
        # He are some flags suggested for use an why they were not used:
        # -Woverloaded-virtual - What did the author of this think virtual methods were for if not
        #                        to be overloaded. This disagrees with explicit design decisions.
        # -Wmisleading-indentation - Help find errors revolving around tabs and control flow. I
        #                            want to enable this, but not until GCC 6.
        # -DDEBUG_DIRECTOR_EXCEPTION  # Used to make swig emit more.
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
            # C4774 - BS warning about some sprintf derivative we never use.
            # C4996 - Attempts to force "_s" versions of standard library methods, not all of which are cross-platform.
            # C5039 - BS warning thrown in the bowels of never included windows headers.
            set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /nologo /Wall /WX /MT \
                /wd4710 /wd4514 /wd4251 /wd4820 /wd4571 /wd4626 /wd4625 /wd5026 /wd5027 /wd4221 /wd4711 \
                /wd4987 /wd4365 /wd4774 /wd4623 /wd4996 /wd5039"
            )
        else(CompilerIsMsvc)
            message(FATAL_ERROR
                "Your compiler is not GCC compatible and not MSVC... Add this mysterious software's flags here."
            )
        endif(CompilerIsMsvc)
    endif(CompilerDesignNix)

    if("${ParentProject}" STREQUAL "${PROJECT_NAME}")
        message(STATUS "C++ compiler and linker flags: ${CMAKE_CXX_FLAGS}")
    endif("${ParentProject}" STREQUAL "${PROJECT_NAME}")
endmacro(SetCommonCompilerFlags)

########################################################################################################################
# SetProjectVariables
#
# Clear a few lists for storing thinks like header, source, and doxygen input files.
#
#   Usage:
#       # Call this anytime or just let StandardJagatiSetup do it.
#       SetProjectVariables()
#
#   Result:
#       This will set a number of source file lists to be empty so that other functions can append to them. Most of
#       these exist as one per project and will be placed in the based scope so that they can be used by any including
#       project. Their different purposes are covered here briefly, see the official docs for a better explanation:
#
#       ${PROJECT_NAME}HeaderFiles     - A variable intended to be used for storing a list of conventional .h files.
#       ${PROJECT_NAME}SourceFiles     - Another variable for storing a list of files, any C++ source files.
#       ${PROJECT_NAME}TestClassList   - A list classes that will be used in tests.
#       ${PROJECT_NAME}TestHeaderFiles - A list of header and other files to go into the test executable.
#       ${PROJECT_NAME}SwigFiles       - The list of all files that are generated by SWIG.
#
#       JagatiDoxArray - This list exist only one build process and it will contain the list of Doxygen input files.
#

macro(SetProjectVariables)
    set(${PROJECT_NAME}HeaderFiles          "")
    set(${PROJECT_NAME}SourceFiles          "")
    set(${PROJECT_NAME}MainSourceFiles      "")
    set(${PROJECT_NAME}TestClassList        "")
    set(${PROJECT_NAME}TestHeaderFiles      "")
    set(${PROJECT_NAME}SwigFiles            "")

    if("${ParentProject}" STREQUAL "${PROJECT_NAME}")
        set(JagatiDoxArray "")
    elseif("${ParentProject}" STREQUAL "${PROJECT_NAME}")
        set(${PROJECT_NAME}HeaderFiles "${${PROJECT_NAME}HeaderFiles}" PARENT_SCOPE)
        set(${PROJECT_NAME}SourceFiles "${${PROJECT_NAME}SourceFiles}" PARENT_SCOPE)
        set(${PROJECT_NAME}MainSourceFiles "${${PROJECT_NAME}MainSourceFiles}" PARENT_SCOPE)
        set(${PROJECT_NAME}TestClassList "${${PROJECT_NAME}TestClassList}" PARENT_SCOPE)
        set(${PROJECT_NAME}TestHeaderFiles "${${PROJECT_NAME}TestHeaderFiles}" PARENT_SCOPE)
        set(${PROJECT_NAME}SwigFiles "${${PROJECT_NAME}SwigFiles}" PARENT_SCOPE)
    endif("${ParentProject}" STREQUAL "${PROJECT_NAME}")
endmacro(SetProjectVariables)

########################################################################################################################
# FindGitExecutable
#
# Find git and put its name in a variable.
#
# Usage:
#   # Call this anytime or just trust StandardJagatiSetup to call it.
#   FindGitExecutable()
#
# Result:
#   If not already set this will put the git executable into the variable MEZZ_GitExecutable.
#

macro(FindGitExecutable)
    if(NOT DEFINED MEZZ_GitExecutable)
        find_program(MEZZ_GitExecutable git DOC "The git executable the Jagati will use to download packages.")
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
    SetProjectVariables()
    FindGitExecutable()
    if("${ParentProject}" STREQUAL "${PROJECT_NAME}")
        message(STATUS "Determining platform specific details.")
        IdentifyCPU()
        IdentifyOS()
        IdentifyCompiler()
        IdentifyDebug()
        SetCommonCompilerFlags()
    endif("${ParentProject}" STREQUAL "${PROJECT_NAME}")
endmacro(StandardJagatiSetup)

########################################################################################################################
########################################################################################################################
# Optional Settings Macros
########################################################################################################################
########################################################################################################################

########################################################################################################################
# UseStaticLinking
#
# This sets a single variable that all Mezzanine libraries will use when building libraries.
#
# Usage:
#   # Don't. This can easily be controlled via the BuildStaticLibraries cache level option. When used as part any
#   # Mezzanine package. This is already dealt with in the StaticFoundation.
#   UseStaticLinking("ON")
#   UseStaticLinking("OFF")
#
# Result:
#   A variable called LibraryBuildType is set with either "STATIC" if true is passed or "SHARED" if false is passed.
#
#   A variable intended for internal Jagati use only is set, named LibraryInstallationComponent that is suitable for
#   use in subsequent calls to INSTALL as the COMPENENT parameter.
#
# Notes:
#   Forcing this into the cache effectively makes it global is that really what we want? For now it seems ok.

function(UseStaticLinking TrueForStatic)
    if(TrueForStatic)
        set(LibraryBuildType "STATIC" CACHE INTERNAL "" FORCE)
        set(LibraryInstallationComponent "development" CACHE INTERNAL "" FORCE)
    else(TrueForStatic)
        set(LibraryBuildType "SHARED" CACHE INTERNAL "" FORCE)
        set(LibraryInstallationComponent "runtime" CACHE INTERNAL "" FORCE)
    endif(TrueForStatic)
    message(STATUS "Building libraries as: ${LibraryBuildType}")
endfunction(UseStaticLinking TrueForStatic)


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
#   Additionally a variable named CompilerCodeCoverage.
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
#   Additionally a variable named CompilerCodeCoverage.
#

macro(SetCodeCoverage)
    Internal_ChooseCodeCoverage("${MEZZ_CodeCoverage}")
endmacro(SetCodeCoverage)

########################################################################################################################
########################################################################################################################
# Source Code (and other file) list management
########################################################################################################################
########################################################################################################################

########################################################################################################################
# AddHeaderFile
#
# Append the give header file to the list of header files for this project.
#
# Usage:
#   # Call it and pass the name of the header file to add. This must be called after SetProjectVariables() which is part
#   # of the StandardJagatiSetup.
#   AddHeaderFile("Hello.h")
#
# Result:
#   The variable ${PROJECT_NAME}HeaderFiles in the parent scope will have the file appended.
#
macro(AddHeaderFile FileName)
    set(TempHeaderFileToAdd "") # Prepare for adding this as a dox input too.
    if(EXISTS "${FileName}")
        # It exists, but is it valid?
        if("${FileName}" MATCHES "${${PROJECT_NAME}IncludeDir}")
            # Found it in the include dir.
            set(TempHeaderFileToAdd "${FileName}")
        elseif("${FileName}" MATCHES "${${PROJECT_NAME}GenHeadersDir}")
            # Found it in the generated include dir.
            set(TempHeaderFileToAdd "${FileName}")
        else("${FileName}" MATCHES "${${PROJECT_NAME}IncludeDir}")
            message(SEND_ERROR "Found'${FileName}' outside header directory, move to '${${PROJECT_NAME}IncludeDir}'.\
or '${${PROJECT_NAME}GenHeadersDir}'.")
        endif("${FileName}" MATCHES "${${PROJECT_NAME}IncludeDir}")
    else(EXISTS "${FileName}")
        # File does not exist, so lets search for it in the header folder.
        if(EXISTS "${${PROJECT_NAME}IncludeDir}${FileName}")
            # Found It! Add to list
            set(TempHeaderFileToAdd "${${PROJECT_NAME}IncludeDir}${FileName}")
        elseif(EXISTS "${${PROJECT_NAME}GenHeadersDir}${FileName}")
            # Found It! Add to list
            set(TempHeaderFileToAdd "${${PROJECT_NAME}GenHeadersDir}${FileName}")
        else(EXISTS "${${PROJECT_NAME}IncludeDir}${FileName}")
            # Not Found bail.
            message(SEND_ERROR "Could not find '${FileName}' in header or generated header directory , check \
'${${PROJECT_NAME}IncludeDir}' and '${${PROJECT_NAME}GenHeadersDir}'.")
        endif(EXISTS "${${PROJECT_NAME}IncludeDir}${FileName}")
    endif(EXISTS "${FileName}")

    list(APPEND ${PROJECT_NAME}HeaderFiles "${TempHeaderFileToAdd}")
    # This was another possible way to do this without forcing the cache, but couldn't force through enough scope
    # levels. There are good reasons to not cache this, but they don't "it needs to work".
    #if(NOT "${ParentProject}" STREQUAL "${PROJECT_NAME}")
    #    set(${PROJECT_NAME}HeaderFiles "${${PROJECT_NAME}HeaderFiles}" PARENT_SCOPE)
    #endif(NOT "${ParentProject}" STREQUAL "${PROJECT_NAME}")
    set(${PROJECT_NAME}HeaderFiles "${${PROJECT_NAME}HeaderFiles}" CACHE INTERNAL
        "List of Header files for ${PROJECT_NAME}." FORCE)
    message(STATUS "Header File Added to '${PROJECT_NAME}HeaderFiles' : '${FileName}'")
    AddJagatiDoxInput("${TempHeaderFileToAdd}") # This can subtly different than the input.
endmacro(AddHeaderFile FileName)

########################################################################################################################
# AddSourceFile
#
# Append the given source file to the list of source files for the library part of this project.
#
# Usage:
#   # Call it and pass the name of the source file to add. This must be called after SetProjectVariables() which is part
#   # of the StandardJagatiSetup.
#   AddSourceFile("Hello.cpp")
#
# Result:
#   The variable ${PROJECT_NAME}SourceFiles in the parent scope will have the file appended.
#

macro(AddSourceFile FileName)
    if(EXISTS "${FileName}")
        # It exists but does its location make sense?
        if("${FileName}" MATCHES "${${PROJECT_NAME}SourceDir}")
            # Found it in the Source dir.
            list(APPEND ${PROJECT_NAME}SourceFiles "${FileName}")
        else("${FileName}" MATCHES "${${PROJECT_NAME}SourceDir}")
            message(SEND_ERROR "Found'${FileName}' outside source directory, move to '${${PROJECT_NAME}SourceDir}'.")
        endif("${FileName}" MATCHES "${${PROJECT_NAME}SourceDir}")
    else(EXISTS "${FileName}")
        # File does not exist, so lets search for it in the source folder.
        if(EXISTS "${${PROJECT_NAME}SourceDir}${FileName}")
            # Found It! Add to list.
            list(APPEND ${PROJECT_NAME}SourceFiles "${${PROJECT_NAME}SourceDir}${FileName}")
        else(EXISTS "${${PROJECT_NAME}SourceDir}${FileName}")
            # Not Found bail.
            message(SEND_ERROR "Could not find '${FileName}' in source directory, check '${${PROJECT_NAME}SourceDir}'.")
        endif(EXISTS "${${PROJECT_NAME}SourceDir}${FileName}")
    endif(EXISTS "${FileName}")

    set(${PROJECT_NAME}SourceFiles "${${PROJECT_NAME}SourceFiles}" CACHE INTERNAL
        "List of Source files for ${PROJECT_NAME}." FORCE)
    message(STATUS "Source File Added to '${PROJECT_NAME}SourceFiles' : '${FileName}'")
endmacro(AddSourceFile FileName)

########################################################################################################################
# AddMainSourceFile
#
# Add the source file to the list of those that are part of the main executable but not the library.
#
# Usage:
#   # Call it and pass the name of the source file to add. This must be called after SetProjectVariables() which is part
#   # of the StandardJagatiSetup.
#   AddMainSourceFile("Main.cpp")
#
# Result:
#   The variable ${PROJECT_NAME}MainSourceFiles in the parent scope will have the file appended.
#

macro(AddMainSourceFile FileName)
    if(EXISTS "${FileName}")
        # It exists but does its location make sense?
        if("${FileName}" MATCHES "${${PROJECT_NAME}SourceDir}")
            # Found it in the Source dir.
            list(APPEND ${PROJECT_NAME}MainSourceFiles "${FileName}")
        elseif("${FileName}" MATCHES "${${PROJECT_NAME}TestDir}")
            # Allow stuff in the Test directory but don't advertise it loudly.
            list(APPEND ${PROJECT_NAME}MainSourceFiles "${FileName}")
        else("${FileName}" MATCHES "${${PROJECT_NAME}SourceDir}")
            message(SEND_ERROR "Found'${FileName}' outside source directory, move to '${${PROJECT_NAME}SourceDir}'.")
        endif("${FileName}" MATCHES "${${PROJECT_NAME}SourceDir}")
    else(EXISTS "${FileName}")
        # File does not exist, so lets search for it in the source folder.
        if(EXISTS "${${PROJECT_NAME}SourceDir}${FileName}")
            # Found It! Add to list.
            list(APPEND ${PROJECT_NAME}MainSourceFiles "${${PROJECT_NAME}SourceDir}${FileName}")
        else(EXISTS "${${PROJECT_NAME}SourceDir}${FileName}")
            # Not Found bail.
            message(SEND_ERROR "Could not find '${FileName}' in source directory, check '${${PROJECT_NAME}SourceDir}'.")
        endif(EXISTS "${${PROJECT_NAME}SourceDir}${FileName}")
    endif(EXISTS "${FileName}")

    set(${PROJECT_NAME}MainSourceFiles "${${PROJECT_NAME}MainSourceFiles}" CACHE INTERNAL
        "List of Main Source files for ${PROJECT_NAME}." FORCE)
    message(STATUS "Executable Source File Added: '${FileName}'")
endmacro(AddMainSourceFile FileName)

########################################################################################################################
# AddTestFile
#
# Use this to add test classes to be run with the Mezz_Test Package.
#
# Usage:
#   AddTestFile("TestName.h")
#
# Results:
#   This will create a list containing the names of all the tests added and a with the filenames of all those tests.
#
#       ${PROJECT_NAME}TestClassList - This is created or appended to and will have all the class names.
#       ${PROJECT_NAME}TestHeaderFiles - This is created or appended to and will have all the absolute file names.
#
#   The followings lines will be added to the file ${PROJECT_NAME}_tester.cpp (when emitted byEmitTestCode()) :
#
#       A value, TestName, will be inferred from the passed filename but removing directories andfile extensions.
#
#       In the header section will be added:
#           #include "${TestName}.h"
#
#       In the instantiation section will be added:
#           ${TestName}Tests ${TestName}Instance;
#           TestInstances["${TestName}"] = &${TestName}Instance;
#
#       If you called AddTestFile("Foo.h") you would get these lines:
#           #include "Foo.h"
#
#           FooTests FooInstance;
#           TestInstances["Foo"] = &FooInstance;
#
#   You should have a header in your test directory named exacly what was passed in. In that file there should be a
#   class named exactly what was passed in with a suffix of "Tests" that publicly inherits from
#   Mezzanine::Testing::UnitTestGroup and implements any test methods intended to be executed.
#

macro(AddTestFile FileName)
    if(EXISTS "${FileName}")
        # It exists but does its location make sense?
        if("${FileName}" MATCHES "${${PROJECT_NAME}TestDir}")
            # Found it in the Test dir.
            list(APPEND ${PROJECT_NAME}TestHeaderFiles "${FileName}")
        else("${FileName}" MATCHES "${${PROJECT_NAME}TestDir}")
            message(SEND_ERROR "Found'${FileName}' outside test directory, move to '${${PROJECT_NAME}TestDir}'.")
        endif("${FileName}" MATCHES "${${PROJECT_NAME}TestDir}")
    else(EXISTS "${FileName}")
        # File does not exist, so lets search for it in the source folder.
        if(EXISTS "${${PROJECT_NAME}TestDir}${FileName}")
            # Found It! Add to list.
            list(APPEND ${PROJECT_NAME}TestHeaderFiles "${${PROJECT_NAME}TestDir}${FileName}")
        else(EXISTS "${${PROJECT_NAME}TestDir}${FileName}")
            # Not Found bail.
            message(SEND_ERROR "Could not find '${FileName}' in test directory, check '${${PROJECT_NAME}TestDir}'.")
        endif(EXISTS "${${PROJECT_NAME}TestDir}${FileName}")
    endif(EXISTS "${FileName}")

    get_filename_component(InnerTestName "${FileName}" NAME_WE)
    list(APPEND ${PROJECT_NAME}TestClassList ${InnerTestName})

    set(${PROJECT_NAME}TestClassList "${${PROJECT_NAME}TestClassList}" CACHE INTERNAL
        "List of Test Classes files for ${PROJECT_NAME}." FORCE)
    set(${PROJECT_NAME}TestHeaderFiles "${${PROJECT_NAME}TestHeaderFiles}" CACHE INTERNAL
        "List of Test Header files for ${PROJECT_NAME}." FORCE)
    message(STATUS "Executable Source File Added: '${FileName}'")
endmacro(AddTestFile FileName)


########################################################################################################################
# AddJagatiDoxInput
#
# Add input files to list of all files doxygen will scan. If an existing absolute path isn't passed this presumes the
# file is relative to the dox dir for this project.
#
# Usage:
#   # Call any time after SetProjectVariables(). If doxygen is installed and the option is chosen then html docs will be
#   # generated from all passed files.
#   AddJagatiDoxInput("${StaticFoundationConfigFilename}")
#   AddJagatiDoxInput("${DoxFiles}")
#   AddJagatiDoxInput("foo.h")
#
# Results:
#   The file will be checked for validity and appended to the list JagatiDoxArray.
#

macro(AddJagatiDoxInput FileName)
    if(EXISTS "${FileName}")
        # File exists So we need to check if it is in the right folder.
        if("${FileName}" MATCHES "${${PROJECT_NAME}DoxDir}")
            # File is good it is in the Dox dir.
            list(APPEND JagatiDoxArray "${FileName}")
        elseif("${FileName}" MATCHES "${${PROJECT_NAME}IncludeDir}")
            # Found it in the include dir.
            list(APPEND JagatiDoxArray "${FileName}")
        elseif("${FileName}" MATCHES "${${PROJECT_NAME}GenHeadersDir}")
            # Found it in the generated include dir
            list(APPEND JagatiDoxArray "${FileName}")
        else("${FileName}" MATCHES "${${PROJECT_NAME}DoxDir}")
             message(SEND_ERROR "Found'${FileName}' Outside dox and header directories '${${PROJECT_NAME}DoxDir}'\
 and '${${PROJECT_NAME}IncludeDir}'.")
        endif("${FileName}" MATCHES "${${PROJECT_NAME}DoxDir}")
    else(EXISTS "${FileName}")
        # File does not exist, so lets search for it in the dox folder.
        if(EXISTS "${${PROJECT_NAME}DoxDir}${FileName}")
            # Found It! Add to DoxArray.
            list(APPEND JagatiDoxArray "${${PROJECT_NAME}DoxDir}${FileName}")
        else(EXISTS "${${PROJECT_NAME}DoxDir}${FileName}")
            # Not Found anywhere, bail.
            message(SEND_ERROR "Could not find '${FileName}' in dox directory, check '${${PROJECT_NAME}DoxDir}'.")
        endif(EXISTS "${${PROJECT_NAME}DoxDir}${FileName}")
    endif(EXISTS "${FileName}")

    # File has been added scope and report it.
    set(JagatiDoxArray "${JagatiDoxArray}"  CACHE INTERNAL "List of all Jagati Doxygen inputs" FORCE)
    message(STATUS "Doxygen Input Added: '${FileName}'")
endmacro(AddJagatiDoxInput FileName)

########################################################################################################################
# Append the given source file to the list of files to be used as SWIG inputs.
#
# Usage:
#   # Call it and pass the name of the source file to add. This must be called after SetProjectVariables() which is part
#   # of the StandardJagatiSetup.
#   AddSwigEntryPoint("Hello.h")
#
# Result:
#   The variable ${PROJECT_NAME}SwigFiles in the parent scope will have the file appended.
#
# Todo:
#   This should check paths relative to the project, source dir and swig directory.

macro(AddSwigEntryPoint FileName)
    if(EXISTS "${FileName}")
        # It exists but does its location make sense?
        if("${FileName}" MATCHES "${${PROJECT_NAME}SwigDir}")
            # Found it in the Swig dir.
            list(APPEND ${PROJECT_NAME}SwigFiles "${FileName}")
        else("${FileName}" MATCHES "${${PROJECT_NAME}SwigDir}")
            message(SEND_ERROR "Found'${FileName}' outside swig directory, move to '${${PROJECT_NAME}SwigDir}'.")
        endif("${FileName}" MATCHES "${${PROJECT_NAME}SwigDir}")
    else(EXISTS "${FileName}")
        # File does not exist, so lets search for it in the source folder.
        if(EXISTS "${${PROJECT_NAME}SwigDir}${FileName}")
            # Found It! Add to list.
            list(APPEND ${PROJECT_NAME}SwigFiles "${${PROJECT_NAME}SwigDir}${FileName}")
        else(EXISTS "${${PROJECT_NAME}SwigDir}${FileName}")
            # Not Found bail.
            message(SEND_ERROR "Could not find '${FileName}' in swig directory, check '${${PROJECT_NAME}SwigDir}'.")
        endif(EXISTS "${${PROJECT_NAME}SwigDir}${FileName}")
    endif(EXISTS "${FileName}")

    set(${PROJECT_NAME}SwigFiles "${${PROJECT_NAME}SwigFiles}" CACHE INTERNAL
        "List of Swig files for ${PROJECT_NAME}." FORCE)
    message(STATUS "Swig Entry File Added: '${FileName}'")
endmacro(AddSwigEntryPoint FileName)

########################################################################################################################
########################################################################################################################
# Target Creation Macros, for libs, tests and executables
########################################################################################################################
########################################################################################################################


########################################################################################################################
# AddManualJagatiLibrary
#
# Add to a variable that contains an array of all the Jagati Linkable Libraries provided by loaded packages. This
# doesn't create a library it just adds one to Jagati tracking. Avoid using this unless what you need to to is well
# outside the normals bounds of package creation.
#
# Usage:
#   # Be certain to call project before calling this.
#   # Also be certain to have a valid target or library with name matching whatever string is passed.
#   AddManualJagatiLibrary("LinkTarget")
#
# Result:
#   The passed file will be added to a list of libaries. This list can be accessed through the variable:
#       JagatiLinkLibraryArray
#
#
#   This will also create a variable call ${PROJECT_NAME}lib that will store the filename, so only one library per
#   Jagati package can be shared this way.
#

macro(AddManualJagatiLibrary TargetName)
    list(APPEND JagatiLinkLibraryArray "${TargetName}")
    list(REMOVE_DUPLICATES JagatiLinkLibraryArray)

    set(${PROJECT_NAME}Lib "${TargetName}" CACHE INTERNAL "" FORCE)
    set(JagatiLinkLibraryArray "${JagatiLinkLibraryArray}"  CACHE INTERNAL "" FORCE)

    message(STATUS "Link libs: 'JagatiLinkLibraryArray'- ${JagatiLinkLibraryArray}")
    message(STATUS "Lib variable: '${PROJECT_NAME}lib' - ${${PROJECT_NAME}lib}")
endmacro(AddManualJagatiLibrary FileName)

########################################################################################################################
# AddJagatiLibrary
#
# Create a linkable libary and add it to a variable that contains an array of all the Jagati Linkable Libraries provided
# by loaded packages.
#
# Usage:
#   # Be certain to call project before calling this and StandardJagatiSetup (or equivalent alternatives) and call
#   # UseStaticLinking before calling this.
#   AddJagatiLibrary()
#
# Result:
#   The passed file will be added to a list of libaries and the current binary output dir will be included in the linker
#   search list. These lists can be accessed through the variable:
#       JagatiLinkLibraryArray
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
    AddManualJagatiLibrary("${${PROJECT_NAME}LibTarget}")
    target_compile_definitions("${${PROJECT_NAME}LibTarget}" PRIVATE -DMEZZ_EXPORT_LIB)

    set(LocalLinkArray "${JagatiLinkLibraryArray}")
    list(REMOVE_ITEM LocalLinkArray "${${PROJECT_NAME}LibTarget}")
    target_link_libraries("${${PROJECT_NAME}LibTarget}" ${LocalLinkArray})

    install(
        TARGETS "${${PROJECT_NAME}LibTarget}"
        COMPONENT ${LibraryInstallationComponent}
        LIBRARY DESTINATION lib
        ARCHIVE DESTINATION lib
    )
endmacro(AddJagatiLibrary)

########################################################################################################################
# CreateCoverageTarget
#
# Attempt to create a target that builds code coverage metadata for a given list of source code or the default lists.
#
# Usage:
#   # Call it and pass the name of the executable and the list of source to be checked. Be sure to call this after
#   # Calling IdentifyCompiler().
#   CreateCoverageTarget("ExecutableName" "${SourceList}")
#   CreateCoverageTarget(${TestLib} "${TesterSourceFiles}")
#
#   # Call it and pass just the name of the executable and it will use the default source and header list. Be sure to
#   # call this after Calling IdentifyCompiler().
#   CreateDefaultCoverageTarget("ExecutableName")
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

macro(CreateDefaultCoverageTarget ExecutableName)
    CreateCoverageTarget(${ExecutableName} "${${PROJECT_NAME}HeaderFiles};${${PROJECT_NAME}SourceFiles}")
endmacro(CreateDefaultCoverageTarget ExecutableName)

########################################################################################################################
# AddJagatiExecutable
#
# Add the default executable based on the Main source list that is linked to the default library made by the other
# source and header lists.
#
# Usage:
#   # Call this after all source files have been passed into the source list creation macros.
#   AddJagatiExecutable()
#
# Results#
#   A target named after the conents of variable ${PROJECT_NAME}BinTarget is created with all the files in the list
#   ${PROJECT_NAME}MainSourceFiles then that target is linked to all the libraries in the JagatiLinkLibraryArray and
#   will include .
#

macro(AddJagatiExecutable)
    add_executable("${${PROJECT_NAME}BinTarget}" "${${PROJECT_NAME}MainSourceFiles}")
    target_link_libraries(${${PROJECT_NAME}BinTarget} ${JagatiLinkLibraryArray})
endmacro(AddJagatiExecutable)


########################################################################################################################
########################################################################################################################
# Config File Tools
########################################################################################################################
########################################################################################################################

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
# These can be used, but AddJagatiCompileOption should be preferred to these. AddJagatiConfig should be reserved for
# situations were a configuration value is created, but not specified for the person building the software.
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

# This is an implementation detail of AddJagatiConfig. This is needed because macro parameters are neither variables, nor
# constants, and cannot be used in if statements checking implicit truthiness.
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
    if(NOT "${ParentProject}" STREQUAL "${PROJECT_NAME}")
        set(${PROJECT_NAME}JagatiConfig "${${PROJECT_NAME}JagatiConfig}" PARENT_SCOPE)
        set(${PROJECT_NAME}JagatiConfigRaw "${${PROJECT_NAME}JagatiConfigRaw}" PARENT_SCOPE)
    endif(NOT "${ParentProject}" STREQUAL "${PROJECT_NAME}")
endmacro(AddJagatiConfig Name Value RemarkBool)

########################################################################################################################
# AddJagatiCompileOption
#
# This guarantees that options will wind up in the config file if enabled or not (if disabled they will be remarked
# in the config).
#
# Usage:
#   # Call after project to insure PROJECT_NAME is set.
#   AddJagatiCompileOption("BuildDoxygen" "Create HTML documentation with Doxygen." ON)
#   AddJagatiCompileOption("VariableName" "Help text." TruthyDefaultValue)
#
# Results:
#   This will create a variable named after the string in the first parameter. This variable will
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
# EmitConfig
#
# Emit a config file as constructed by AddJagatiConfig and add the file name to the header list.
#
# Usage:
#   # Call after 0 or more calls to AddJagatiConfig and the parentmost scope has been claimed and SetProjectVariables
#   # has initialized the file lists.
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

    # Assemble the content and notify correct scopes.
    set(${PROJECT_NAME}ConfigContent
        "${ConfigHeader}${${PROJECT_NAME}JagatiConfig}${DoxygenElse}${${PROJECT_NAME}JagatiConfigRaw}${ConfigFooter}"
    )
    if(NOT "${ParentProject}" STREQUAL "${PROJECT_NAME}")
        set(${PROJECT_NAME}ConfigContent "${${PROJECT_NAME}ConfigContent}" PARENT_SCOPE)
    endif(NOT "${ParentProject}" STREQUAL "${PROJECT_NAME}")

    # Write the file and notify correct scopes.
    set(${PROJECT_NAME}ConfigFilename "${${PROJECT_NAME}GenHeadersDir}${PROJECT_NAME}Config.h")
    if(NOT "${ParentProject}" STREQUAL "${PROJECT_NAME}")
        set(${PROJECT_NAME}ConfigFilename "${${PROJECT_NAME}ConfigFilename}" PARENT_SCOPE)
    endif(NOT "${ParentProject}" STREQUAL "${PROJECT_NAME}")

    message(STATUS "Emitting Config Header File - ${${PROJECT_NAME}ConfigFilename}")
    file(WRITE "${${PROJECT_NAME}ConfigFilename}" "${${PROJECT_NAME}ConfigContent}")

    AddHeaderFile("${${PROJECT_NAME}ConfigFilename}")
endmacro(EmitConfig)


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
#   a unit test executable.
#

macro(EmitTestCode)
    # Everything before Main
    set(TestsHeader "${MEZZ_Copyright}#include \"MezzTest.h\"\n\n")
    set(TestsIncludes "// Start Dynamically Included Headers\n")
    foreach(OneHeader ${${PROJECT_NAME}TestHeaderFiles})
        set(TestsIncludes "${TestsIncludes}\n    #include \"${OneHeader}\"")
    endforeach(OneHeader ${${PROJECT_NAME}TestHeaderFiles})
    set(TestsIncludes "${TestsIncludes}\n\n// End Dynamically Included Headers")

    # The main function.
    set(TestsMainHeader
        "\n\nint main (int argc, char** argv)\n{\n    Mezzanine::Testing::CoreTestGroup TestInstances;\n\n"
    )

    set(TestsInit "    // Start Dynamically Instanced Tests\n")
    foreach(TestName ${${PROJECT_NAME}TestClassList})
        string(TOLOWER "${TestName}" TestLowerName)
        set(TestsInit "${TestsInit}\n\
        ${TestName} ${TestName}Instance;\n\
        TestInstances[Mezzanine::Testing::AllLower(${TestName}Instance.Name())] = &${TestName}Instance;\n")
    endforeach(TestName ${${PROJECT_NAME}TestClassList})
    set(TestsInit "${TestsInit}\n    // Start Dynamically Instanced Tests\n\n")

    set(TestsMainFooter
        "    return Mezzanine::Int32(Mezzanine::Testing::MainImplementation(argc, argv, TestInstances)); \n}\n\n"
    )

    # Connect everything.
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
#   # Must call AddJagatiLibrary or AddManualJagatiLibrary first, because this uses ${${PROJECT_NAME}LibTarget}.
#   AddTestTarget()
#
# Results:
#   Create a test executable target named ${${PROJECT_NAME}TestTarget}.
#

macro(AddTestTarget)
    get_property(dirs DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY INCLUDE_DIRECTORIES)
    ShowList("Include dirs for ${CMAKE_CURRENT_SOURCE_DIR}" "" "${dirs}")

    message(STATUS "Adding tester target - ${${PROJECT_NAME}TestTarget} - ${JagatiLinkLibraryArray}")
    add_executable(
        ${${PROJECT_NAME}TestTarget}
        "${${PROJECT_NAME}TestHeaderFiles}"
        "${${PROJECT_NAME}TesterFilename}"
        "${${PROJECT_NAME}SourceFiles}"
    )
    target_link_libraries(${${PROJECT_NAME}TestTarget} ${JagatiLinkLibraryArray})

    add_test("Run${${PROJECT_NAME}TestTarget}" ${${PROJECT_NAME}TestTarget})
endmacro(AddTestTarget)

########################################################################################################################
# AddTestDirectory
#
# Usage:
#   AddTestDirectory("TestDirectory")
#
# Results:
#   This call add test for each header in the passed directory.
#

macro(AddTestDirectory TestDir)
    message(STATUS "Adding all tests in: '${TestDir}'")
    file(GLOB TestFileList "${TestDir}*.h")
    foreach(TestFilename ${TestFileList})
        get_filename_component(TestFile "${TestFilename}" ABSOLUTE)
        AddTestFile("${TestFile}")
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
#   # Call after creating all the default files and populating the default source file lists.
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
            ${${PROJECT_NAME}MainSourceFiles}
            ${${PROJECT_NAME}SwigFiles}
            ${${PROJECT_NAME}ConfigFilename}
            ${${PROJECT_NAME}TestHeaderFiles}
            ${JagatiDoxArray}
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
    set(StdOut "")
    set(StdErr "")
    message(STATUS "Updating ${PackageName}...")
    if(EXISTS "${TargetPackageSourceDir}CMakeLists.txt")
        message(STATUS "Pulling with git")
        execute_process(
            WORKING_DIRECTORY ${TargetPackageSourceDir}
            COMMAND ${MEZZ_GitExecutable} pull ${${PackageName}_GitURL}
            OUTPUT_VARIABLE StdOut
            ERROR_VARIABLE StdErr
        )
    else(EXISTS "${TargetPackageSourceDir}CMakeLists.txt")
        message(STATUS "Cloning with git")
        file(MAKE_DIRECTORY "${MEZZ_PackageDirectory}")
        execute_process(
            WORKING_DIRECTORY ${MEZZ_PackageDirectory}
            COMMAND ${MEZZ_GitExecutable} clone ${${PackageName}_GitURL}
            OUTPUT_VARIABLE StdOut
            ERROR_VARIABLE StdErr
        )
    endif(EXISTS "${TargetPackageSourceDir}CMakeLists.txt")
    message(STATUS "Output: ${StdOut}")
    message(STATUS "Error Text: ${StdErr}")
    message(STATUS "Updating ${PackageName} completed successfully.")
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

    message(STATUS "============================================================================================")
    add_subdirectory("${TargetPackageSourceDir}" "${TargetPackageBinaryDir}")

    # Make the headers available in this directory.
    include_directories(${${RawPackageName}IncludeDir})
    include_directories(${${RawPackageName}GenHeadersDir})
    link_directories(${${RawPackageName}BinaryDir})
endmacro(IncludeJagatiPackage PackageName)
