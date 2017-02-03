# Jagati

The Jagati is a single CMake script that can be incorporatesd into a C++ build that already uses CMake to provide easy access to all the Mezzanine game engine libraries.

# About

This is a simple packaging tool for the libraries in the Mezzanine. It copies many features from package managers, but really isn't a package manager. This provides ways to get information and easily link against Jagati Packages.

This uses features of CMake and Github to download the source code for different Mezzanine libraries. This sets up about a dozen variables for each library

Packages can change, they can be updated. Any package manager, packaging tool or any other system for handling different pieces of software needs a way to keep up to date on these changes. 

## Usage 

To keep the Jagati as simple as possible it is a single CMakeLists.txt file that is intended to be downloaded dynamically as part of the software build process.

1. Pick the version of the Jagati you want.
2. Get its SHA512 checksum from its SHA512SUM.txt or calculate it yourself with a tool like `sha512sum`.
3. Add something like the following to your CMakeLists.txt to download, verify and run it:

```CMake
set(JagatiChecksum "e5282c8924cff5a620b50f8ca5fb84023d27a24f9302dbfaac055b\
022a3a3883f4f541e071e2618edfd2f6b148b9e12823a98ca5b736e57ecf983bf6ece96de2")
file(DOWNLOAD
    "https://raw.githubusercontent.com/BlackToppStudios/Jagati/0.13.1/Jagati.cmake"
    "${${PROJECT_NAME}_BINARY_DIR}/Jagati.cmake"
    EXPECTED_HASH SHA512=${JagatiChecksum}
)
include("${${PROJECT_NAME}_BINARY_DIR}/Jagati.cmake")
```

Doing this gives you access to several functions and macros that will be documented once the Jagati reaches a Beta like level of quality.
