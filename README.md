# Jagati

The Jagati is a single CMake script that can be incorporatesd into a C++ build that already uses CMake to provide easy
access to all the Mezzanine game engine libraries.

# About

This is a simple packaging tool for the libraries in the Mezzanine. It copies many features from package managers, but
really isn't a package manager. This provides ways to get information and easily link against Jagati Packages.

This uses features of CMake and Github to download the source code for different Mezzanine libraries. This sets up
about a dozen variables for each library

Packages can change, they can be updated. Any package manager, packaging tool or any other system for handling
different pieces of software needs a way to keep up to date on these changes.

The current Jenkins (Ubuntu Linux, Fedora, Rasberry Pi, Mac) build status is:
[![Build Status](http://blacktopp.ddns.net:8080/job/Jagati/badge/icon)](http://blacktopp.ddns.net:8080/job/Jagati/)

The current Travis CI (Apple and Old Ubuntu) build status is:
[![Build Status](https://travis-ci.org/BlackToppStudios/Jagati.svg?branch=master)](https://travis-ci.org/BlackToppStudios/Jagati)

The current Appveyor (Windows) build status is:
[![Build Status](https://ci.appveyor.com/api/projects/status/github/BlackToppStudios/Jagati?branch=master&svg=true)](https://ci.appveyor.com/project/Sqeaky/Jagati)

## Usage 

To keep the Jagati as simple as possible it is a single CMakeLists.txt file that is intended to be downloaded
dynamically as part of the software build process.

1. Pick the version of the Jagati you want.
2. Get its SHA512 checksum from its SHA512SUM.txt or calculate it yourself with a tool like `sha512sum`.
3. Add something like the following to your CMakeLists.txt to download, verify and run it:

```CMake
set(JagatiChecksum "719ae92582192044914ca5059728a3a8ea7263d01fcf45b793aa5d\
c59361993e2171e9e50c7c3ee7360d596dfe4aa9bd0b15de62e8f36eb97c569e173568703c")
file(DOWNLOAD
    "http://raw.githubusercontent.com/BlackToppStudios/Jagati/0.18.0/Jagati.cmake"
    "${${PROJECT_NAME}_BINARY_DIR}/Jagati.cmake"
    EXPECTED_HASH SHA512=${JagatiChecksum}
)
include("${${PROJECT_NAME}_BINARY_DIR}/Jagati.cmake")
```

Doing this gives you access to several functions and macros that will be documented externally once the Jagati
reaches a Beta like level of quality. Currently every Jagati Feature, function and macro is carefully described
in remarks directly in the file Jagati.cmake.

If you want to control where the package source is download, (if you have multiple projects or just want to make the
source code easy to explore) you should set the MEZZ_PACKAGE_DIR. This sets the CMake variable MEZZ_PackageDirectory
which controls where the Jagati downloads all the Mezzanine Packages. Setting this to in a system or user wide
environment variable has the effect of deduplicating all of your 

This can be set in Bash with:

```Bash
export MEZZ_PACKAGE_DIR=/home/sqeaky/Code/
```

or on windows with:
```Batch
set MEZZ_PACKAGE_DIR=C:\users\sqeaky\code\
```

## Testing

This build tool is sophisticated enough to need unit tests, so it has them. At the time of this writing the tests are
limited, but more will be added as bugs are found or features added. Running them is completely optional for most users,
but if you want a basic sanity check or just to see what they do, you can easily run them. 

To run the tests (which is optional for most users) you will need a Ruby interpretter. These were written using Ruby
Ruby 2.3.3 and tested on JRuby 1.7.26 (which implements Ruby 1.9.3), and no special Ruby features newer than 1.9.3 were
used, so just about any supported Ruby interpretter ought to work. Make sure that Ruby or JRuby is installed and in the
system path, then cd into the "Test" directory and run "RootTest.rb"

```Bash
~/Code/Jagati/$ cd Test
~/Code/Jagati/Test jruby RootTest.rb # Optional
Run options: --seed 48341

# Running tests:

.........

Finished tests in 2.227000s, 4.0413 tests/s, 24.6969 assertions/s.

9 tests, 55 assertions, 0 failures, 0 errors, 0 skips


------------------
~/Code/Jagati/Test$ ruby RootTest.rb # Optional
Run options: --seed 21724

# Running:

.........

Finished in 2.343915s, 3.8397 runs/s, 23.4650 assertions/s.

9 runs, 55 assertions, 0 failures, 0 errors, 0 skips


------------------

```
