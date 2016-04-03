# Jagati

The Jagati is a single CMake script that can be incorporatesd into a C++ build that already uses CMake to provide easy access to all the Mezzanine game engine libraries.

# About

This is a simple packaging tool for the libraries in the Mezzanine. It copies many features from package managers, but really isn't a package manager. This provides ways to get information and easily link against Jagati Packages.

This uses features of CMake and Github to download the source code for different Mezzanine libraries. This sets up about a dozen variables for each library

Packages can change, they can be updated. Any package manager, packaging tool or any other system for handling different pieces of software needs a way to keep up to date on these changes. 

## Usage 

To keep the Jagati as simple as possible it is a single CMakeLists.txt file that is intended to be downloaded dynamically as part of the software build process.

1. Pick the version of the Jagati you want.
2. Get its SHA1 checksum from its SHA1SUM.txt or calculate it yourself with a tool like `sha1sum`.
3. Add something like the following to your CMakeLists.txt to download, verify and run it:

```CMake
set(JagatiChecksum "96252daabd7b82f6e8b1a667246ba252a462e604b055ddf99e5157\
7f7fb77a0ca5a8c7da7ff7bd209efde2b86919cb2130ed657235d00208a53f0646e0e4f5ba")
file(DOWNLOAD
    "https://raw.githubusercontent.com/BlackToppStudios/Jagati/master/Jagati.cmake"
    "${${PROJECT_NAME}_BINARY_DIR}/Jagati.cmake"
    EXPECTED_HASH SHA512=${JagatiChecksum}
)
include("${${PROJECT_NAME}_BINARY_DIR}/Jagati.cmake")
```

Doing this gives you access to several functions and macros that will be documented once the Jagati reaches a Beta like level of quality.
