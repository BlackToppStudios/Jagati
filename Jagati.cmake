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

####################################################################################################
####################################################################################################
# From Here to the next thick banner exist macros to set variables in the scope of the calling
# CmakeList Project that all Jagati packages should set. The idea is that every variable needed to
# link or inspect the source will be cleanly set and easily inspectable, from just the output of
# cmake and a sample CMakeLists.txt.
####################################################################################################
####################################################################################################
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

####################################################################################################
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
    set(${PROJECT_NAME}RootDir "${${PROJECT_NAME}_SOURCE_DIR}/")
    set(${PROJECT_NAME}BinaryDir "${${PROJECT_NAME}_BINARY_DIR}/")

    #######################################
    # Derived Output Folders
    set(${PROJECT_NAME}GenHeadersDir "${${PROJECT_NAME}BinaryDir}config/")
    set(${PROJECT_NAME}GenSourceFolder "${${PROJECT_NAME}BinaryDir}generated_source/")

    #######################################
    # Derived Input Folders
    set(${PROJECT_NAME}DoxDir "${${PROJECT_NAME}RootDir}dox/")
    set(${PROJECT_NAME}IncludeDir "${${PROJECT_NAME}RootDir}include/")
    set(${PROJECT_NAME}LibDir "${${PROJECT_NAME}RootDir}lib/")
    set(${PROJECT_NAME}SourceDir "${${PROJECT_NAME}RootDir}src/")
    set(${PROJECT_NAME}SwigDir "${${PROJECT_NAME}RootDir}swig/")
    set(${PROJECT_NAME}TestDir "${${PROJECT_NAME}RootDir}test/")

    if("${ParentProject}" STREQUAL "${PROJECT_NAME}")
        message(STATUS "This, ${PROJECT_NAME}, is the root project. Not setting PARENT_SCOPE vars.")
    else("${ParentProject}" STREQUAL "${PROJECT_NAME}")
        #######################################
        # Root as child
        set(${PROJECT_NAME}RootDir "${${PROJECT_NAME}RootDir}" PARENT_SCOPE)
        set(${PROJECT_NAME}BinaryDir "${${PROJECT_NAME}BinaryDir}" PARENT_SCOPE)

        #######################################
        # Derived Output Folders as child
        set(${PROJECT_NAME}GenHeadersDir "${${PROJECT_NAME}GenHeadersDir}" PARENT_SCOPE)
        set(${PROJECT_NAME}GenSourceFolder "${${PROJECT_NAME}GenSourceFolder}" PARENT_SCOPE)

        #######################################
        # Derived Input Folders as child
        set(${PROJECT_NAME}DoxDir "${${PROJECT_NAME}DoxDir}" PARENT_SCOPE)
        set(${PROJECT_NAME}IncludeDir "${${PROJECT_NAME}IncludeDir}" PARENT_SCOPE)
        set(${PROJECT_NAME}LibDir "${${PROJECT_NAME}LibDir}" PARENT_SCOPE)
        set(${PROJECT_NAME}SourceDir "${${PROJECT_NAME}SourceDir}" PARENT_SCOPE)
        set(${PROJECT_NAME}SwigDir "${${PROJECT_NAME}SwigDir}" PARENT_SCOPE)
        set(${PROJECT_NAME}TestDir "${${PROJECT_NAME}TestDir}" PARENT_SCOPE)
    endif("${ParentProject}" STREQUAL "${PROJECT_NAME}")

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

####################################################################################################
# Clearly CMake knows how to ID the OS without our help, but there are tricks to it and builtin
# tools are not as well identified as the could be. Hopefully this overcomes these minor shortfalls.

# Usage:
#   # Be the parentmost cmake scope or this ihas no effect
#   IdentifyOS()
#
# Result:
#   Details about OS are displayed and the following variables are set:
#
#       SystemIsLinux   - ON/OFF
#       SystemIsWindows - ON/OFF
#       SystemIsMacOSX  - ON/OFF
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
    endif("${ParentProject}" STREQUAL "${PROJECT_NAME}")
endmacro(IdentifyOS)

####################################################################################################
# Again, CMake knows how to detect the compiler. It does this in hyper precise detail. For purposes
# of the mezzanine there are really two categories of compiler: visual studio and good compilers.
# this can roughly identify those.

# Usage:
#   # Be the parentmost cmake scope or this ihas no effect
#   IdentifyOS()
#
# Result:
#   Details about compiler are displayed and the following variables are set:
#
#       CompilerIsGCC   - ON/OFF
#       CompilerIsClang - ON/OFF
#       CompilerIsIntel - ON/OFF
#       CompilerIsMsvc  - ON/OFF
#
#       CompilerDesignNix   - ON/OFF
#       CompilerDesignMS    - ON/OFF

macro(IdentifyCompiler)
    if("${ParentProject}" STREQUAL "${PROJECT_NAME}")
        message(STATUS "\tDetecting Compiler:")

        set(CompilerIsGCC OFF)
        set(CompilerIsClang OFF)
        set(CompilerIsIntel OFF)
        set(CompilerIsMsvc OFF)

        set(CompilerDesignNix OFF)
        set(CompilerDesignMS OFF)

        if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
            message(STATUS "\t\tDetected compiler as 'GCC'.")
            set(CompilerIsGCC ON)
            set(CompilerDesignNix ON)
        endif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")

        if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
            message(STATUS "\t\tDetected compiler as 'Clang'.")
            set(CompilerIsClang ON)
            set(CompilerDesignNix ON)
        endif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")

        if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Intel")
            message(STATUS "\t\tDetected compiler as 'Intel'.")
            set(CompilerIsIntel ON)
            set(CompilerDesignNix ON)
        endif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Intel")

        if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")
            message(STATUS "\t\tDetected compiler as 'MSVC'.")
            set(CompilerIsMsvc ON)
            set(CompilerDesignMS ON)
        endif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")

        if(CompilerDesignNix)
            message(STATUS "\t\tPresuming *nix style compiler.")
        endif(CompilerDesignNix)

        if(CompilerDesignMS)
            message(STATUS "\t\tPresuming ms style compiler.")
        endif(CompilerDesignMS)
    endif("${ParentProject}" STREQUAL "${PROJECT_NAME}")
endmacro(IdentifyCompiler)

####################################################################################################
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

macro(SetCommonCompilerFlags)
    if(CompilerDesignNix)
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} \
        -std=c++11 -fno-strict-aliasing -pthread -m64 -fPIC\
        -pedantic -Wall -Wextra -Wcast-align -Wcast-qual -Wctor-dtor-privacy \
        -Wdisabled-optimization -Wformat=2 -Winit-self -Wlogical-op -Wmissing-declarations \
        -Wmissing-include-dirs -Wnoexcept -Wold-style-cast -Wredundant-decls -Wshadow \
        -Wsign-conversion -Wsign-promo -Wstrict-null-sentinel -Wstrict-overflow=2 -Wundef \
        -Wno-unused -Wparentheses -Werror")

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
            /wd4710 /wd4514 /wd4251 /wd4820"
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

####################################################################################################
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
        list(APPEND JagatiPackageNameArray ${PROJECT_NAME})
    else("${ParentProject}" STREQUAL "${PROJECT_NAME}")
        set(JagatiPackageNameArray "${JagatiPackageNameArray}")
        list(APPEND JagatiPackageNameArray ${PROJECT_NAME})
        set(JagatiPackageNameArray "${JagatiPackageNameArray}" PARENT_SCOPE)
    endif("${ParentProject}" STREQUAL "${PROJECT_NAME}")
endmacro(AddJagatiPackage)


####################################################################################################
# This does what the above macros do, but this does it all together.

# Usage:
#   # Be certain to call project before calling this.
#   StandardJagatiSetup()
#
# Result:
#       The Parent scope will attempt to be claimed, many variables for compiler, OS and locations
#       will be set, see above. Compiler Flags will be set.

macro(StandardJagatiSetup)
    ClaimParentProject()
    CreateLocations()
    AddJagatiPackage()
    if("${ParentProject}" STREQUAL "${PROJECT_NAME}")
        message(STATUS "Determining platform specific details.")
        IdentifyOS()
        IdentifyCompiler()
        SetCommonCompilerFlags()
    endif("${ParentProject}" STREQUAL "${PROJECT_NAME}")

endmacro(StandardJagatiSetup)

####################################################################################################
####################################################################################################
# Optional Macros that not all Jagati packages will set, but culd be important for link or other
# build time activities.
####################################################################################################
####################################################################################################
# A variable that contains an array of all the Jagati Linkable Libraries provided by loaded
# packages

# Usage:
#   # Be certain to call project before calling this.
#   AddJagatiLibrary("filename.a")
#
# Result:
#   The passed file weill  be added to a list of libaries. This list can be
#   Accessed through the variable: JagatiLibraryArray
#
#   This will also create a variable call ${PROJECT_NAME}lib that will store the filename

macro(AddJagatiLibary FileName)
    set(${PROJECT_NAME}lib "${FileName}")
    list(APPEND JagatiLibraryArray ${FileName})
    set(${PROJECT_NAME}lib "${FileName}")
    if("${ParentProject}" STREQUAL "${FileName}")
    else("${ParentProject}" STREQUAL "${FileName}")
        set(JagatiLibraryArray "${JagatiLibraryArray}" PARENT_SCOPE)
        set(${PROJECT_NAME}lib "${FileName}" PARENT_SCOPE)
    endif("${ParentProject}" STREQUAL "${FileName}")
    message(STATUS "Lib variable: '${PROJECT_NAME}lib' - ${${PROJECT_NAME}lib}")
endmacro(AddJagatiLibary)

####################################################################################################
# Some projects have many files that are created at compile time. This can cause the build system to
# as complex as the source code. Most software developers want to spend their reasoning about the
# code and not the code that makes the code. In general the Jagati or a specific package should
# handle meta-programming where possible.

# Usage:
#   # Call any time after the parent scope is claimed. The first parameter is the name of a
#   # preprocessor to create, and the second is the value, "" for no value and the third argument
#   # is for determining if the remark should be enabled(true) or remarked out(false).
#       AddJagatiConfig("MEZZ_FOO" "BAR" ON)
#       AddJagatiConfig("MEZZ_EmptyOption" "" ON)
#       AddJagatiConfig("MEZZ_Remarked_FOO" "BAR" OFF)
#       AddJagatiConfig("MEZZ_EmptyOption_nope" "" OFF)
#
# Result:
#   Adds a preprocessor macro to string that config headers can directly include. Here is the
#   output from the sample above:
#       #define MEZZ_FOO BAR
#       #define MEZZ_EmptyOption
#       //#define MEZZ_Remarked_FOO BAR
#       //#define MEZZ_EmptyOption_nope
#
#   The set variable will be ${PROJECT_NAME}JagatiConfig
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
        "${${PROJECT_NAME}JagatiConfig}\n${JagatiConfigRemarks}#define ${Name} ${Value}")
    if("${ParentProject}" STREQUAL "${PROJECT_NAME}")
    else("${ParentProject}" STREQUAL "${PROJECT_NAME}")
        set(${PROJECT_NAME}JagatiConfig "${${PROJECT_NAME}JagatiConfig}" PARENT_SCOPE)
    endif("${ParentProject}" STREQUAL "${PROJECT_NAME}")
endmacro(AddJagatiConfig Name Value RemarkBool)

####################################################################################################
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
#ifndef Mezz_${PROJECT_NAME}_config_h\n\
#define Mezz_${PROJECT_NAME}_config_h\n\
\n\n")

    set(ConfigFooter "\n\n#endif")

    set(${PROJECT_NAME}ConfigFilename "${${PROJECT_NAME}GenHeadersDir}${PROJECT_NAME}Config.h")
    if("${ParentProject}" STREQUAL "${PROJECT_NAME}")
    else("${ParentProject}" STREQUAL "${PROJECT_NAME}")
        set(${PROJECT_NAME}ConfigFilename "${${PROJECT_NAME}ConfigFilename}" PARENT_SCOPE)
    endif("${ParentProject}" STREQUAL "${PROJECT_NAME}")

    set(${PROJECT_NAME}ConfigContent "${ConfigHeader}${${PROJECT_NAME}JagatiConfig}${ConfigFooter}")
    if("${ParentProject}" STREQUAL "${PROJECT_NAME}")
    else("${ParentProject}" STREQUAL "${PROJECT_NAME}")
        set(${PROJECT_NAME}ConfigContent "${${PROJECT_NAME}ConfigContent}" PARENT_SCOPE)
    endif("${ParentProject}" STREQUAL "${PROJECT_NAME}")

    file(WRITE "${${PROJECT_NAME}ConfigFilename}" "${${PROJECT_NAME}ConfigContent}")

endmacro(EmitConfig)

####################################################################################################
####################################################################################################
# Basic Display Functionality
####################################################################################################
####################################################################################################
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

####################################################################################################
# Basic Option Tools

# Usage:
#   # Call after project to insure PROJECT_NAME is set.
#   AddJagatiCompileOption("Mezz_BuildDoxygen" "Create HTML documentation with Doxygen." ON)
#   AddJagatiCompileOption("VariableName" "Help text." TruthyDefaultValue)
#
# Results:
#   This will create a variable named after thee string in the first parameter. This var(iable will
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

####################################################################################################
####################################################################################################
# Getting Jagati packages, What URLs and functions can we use to get Jagati Packages and know what
# Exists?
####################################################################################################
####################################################################################################

# Package URLs

set(StaticFoundation_GitURL "git@github.com:BlackToppStudios/Mezz_StaticFoundation.git")

####################################################################################################
# Package Download experiment

set(Mezz_JagatiPackageDirectory "$ENV{JAGATI_DIR}" CACHE PATH "Folder for storing Jagati Packages.")

# To insure that all the packages are downloaded this can be added as a dependencies to any target.

if("${ParentProject}" STREQUAL "${FileName}")
    add_custom_target(
        Download
        COMMENT "Checking for Jagati Packages to Download"
    )
endif("${ParentProject}" STREQUAL "${FileName}")


####################################################################################################
# Any package wanting to use another can include it with this function
function(IncludeJagatiPackage PackageName)
    if("${PackageName}_GitURL" STREQUAL "")
        message(FATAL_ERROR "Could not find Package named ${PackageName}")
    else("${PackageName}_GitURL" STREQUAL "")
        set(GitURL "${PackageName}_GitURL")
    endif("${PackageName}_GitURL" STREQUAL "")

    ExternalProject_Add(
      "${PackageName}"
      PREFIX "${Mezz_JagatiPackageDirectory}/${PackageName}"
      GIT_REPOSITORY "${GitURL}"
      GIT_TAG master
      CONFIGURE_COMMAND ""
      BUILD_COMMAND ""
      TEST_COMMAND ""
      INSTALL_COMMAND ""
    )

    add_dependencies(Download "${PackageName}")
endfunction(IncludeJagatiPackage PackageName)

