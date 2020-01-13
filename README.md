# Jagati

The Jagati is a single CMake script that can be incorporated into a C++ build that already uses CMake to provide easy
access to all the Mezzanine game engine libraries.

# About

This is a  packaging tool for the libraries in the Mezzanine. This should be simple to use because it enforces a few
opinions about what a reasonable C++ package looks like and this allows a bunch of reasonable assumptions to be made
when using those packages. The Jagati copies many features from package managers, but really isn't a package manager.
This provides ways to get information and easily link against Jagati Packages.

This uses features of CMake and Github to download the source code for different Mezzanine libraries. This can be used
with other libraries, but isn't intended for this purpose yet.

# Build Status

The current Travis CI (Apple and Old Ubuntu) build status is:
[![Build Status](https://travis-ci.org/BlackToppStudios/Jagati.svg?branch=master)](https://travis-ci.org/BlackToppStudios/Jagati)

The current Appveyor (Windows) build status is:
[![Build Status](https://ci.appveyor.com/api/projects/status/github/BlackToppStudios/Jagati?branch=master&svg=true)](https://ci.appveyor.com/project/Sqeaky/Jagati)

The current Jenkins, which covers Linux (Emscripten, Rasberry Pi, Ubuntu and Fedora), old Mac OS X (High Sierra) and old windows (7 64 bit msvc and mingw), build status is available on the [BTS Jenkins Instance](http://blacktopp.ddns.net:8080/blue/organizations/jenkins/Jagati/activity). The current status is: [![Build Status](http://blacktopp.ddns.net:8080/job/Jagati/job/master/badge/icon)](http://blacktopp.ddns.net:8080/blue/organizations/jenkins/Jagati/activity)


# Opinions

This software enforces some *opinions* on the software that uses it. These are conventions, artificial restrictions that
allow problems to be reasoned about in easier ways. There is a problem with how free and open a C++ project can be, any
C++ project can be arbitrarily complex and do anything with directories and inclusion or exclusion of code, headers and
dependencies. Our thinking is that some enforced opinions will make working with C++ as software packages easier.

Any opinion can be avoided by using the less restrictive CMake syntax. Some things are impossible to do using just the
Jagati, in these case then of course use normal CMake constructs. If you just want to change how one of the assumptions
works consider if that is worth the cost of losing integration with other packages.

Here is a (partial) summary of opinions

1. Every package should have 1 or 0 primary executable.
2. Every package should have 1 or 0 primary test executable.
3. Every package should have 1 or 0 library.
4. Every executable should link to the library if present.
5. Source files should go into a folder of their own.
6. Header files should go into a folder of their own.
7. Test files should go into a folder of their own.
8. All of these values should be easy to reference with well defined CMake variables.
9. Including a package should make its header folder available for inclusion.
10. Including a package should link to the library it provides.

# Usage

To keep the Jagati as simple as possible it is a single CMakeLists.txt file that is intended to be downloaded
dynamically as part of the software build process.

1. Pick the version of the Jagati you want.
2. Get its SHA512 checksum from its SHA512SUM.txt or calculate it yourself with a tool like `sha512sum`.
3. Add something like the following to your CMakeLists.txt to download, verify and run it:

```CMake
if(NOT JAGATI_File)
    set(JAGATI_File "${${PROJECT_NAME}_BINARY_DIR}/Jagati.cmake" CACHE FILEPATH
        "The file to load the Jagati from and potentially to download it to.")
endif(NOT JAGATI_File)
if(NOT JAGATI_Download)
    option(JAGATI_Download "Should the Jagati be downloaded automatically" ON)
endif(NOT JAGATI_Download)
if(JAGATI_Download)
    set(JAGATI_Checksum "8e4980390f1819721142bf7940238e9e535d20316540fce9bb4\
3287bbffc382020567662e33f31db66d75897042aede72e0b5bb781cafa73834a09aa25340b6f"
        CACHE STRING "Check that when the Jagati is downloaded the right one is used (for consistency and security).")
    set(JAGATI_Url "https://raw.githubusercontent.com/BlackToppStudios/Jagati/0.26.2/Jagati.cmake"
        CACHE STRING "Where to download the Jagati from.")
    file(DOWNLOAD "${JAGATI_Url}" "${JAGATI_File}" EXPECTED_HASH SHA512=${JAGATI_Checksum})
endif(JAGATI_Download)
include("${JAGATI_File}")
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

# Testing

This build tool is sophisticated enough to need unit tests, so it has them. At the time of this writing the tests are
limited, but more will be added as bugs are found or features added. Running them is completely optional for most users,
but if you want a basic sanity check or just to see what they do, you can easily run them.

To run the tests (which is optional for most users) you will need a Ruby interpretter. These were written using Ruby
Ruby 2.3.3 and tested on JRuby 1.7.26 (which implements Ruby 1.9.3), and no special Ruby features newer than 1.9.3 were
used, so just about any supported Ruby interpretter ought to work. Make sure that Ruby or JRuby is installed and in the
system path, then cd into the "Test" directory and run "RootTest.rb"

```Bash
~/Code/Jagati/$ cd Test
~/Code/Jagati/Test$ jruby RootTest.rb
Run options: --seed 58734

# Running:

.............S...S...............

Finished in 45.046677s, 0.7326 runs/s, 8.8797 assertions/s.

33 runs, 400 assertions, 0 failures, 0 errors, 2 skips

You have skipped tests. Run with --verbose for details.

~/Code/Jagati/Test$ ruby RootTest.rb
Run options: --seed 11029

# Running:

.........S...........S...........

Finished in 45.396852s, 0.7269 runs/s, 8.8112 assertions/s.

33 runs, 400 assertions, 0 failures, 0 errors, 2 skips

You have skipped tests. Run with --verbose for details.

```

## Current Test Coverage

Going forward we want to test each API in the Jagati. Each test case occupies its own subdirectory in the Test/
directory. Each directory has a test.rb file with some (hopefully) simple to read ruby code that scrapes CMake caches
and other files CMake leaves around to verify the Jagati works. Tests can be a good source of examples. This is a brief
summary of each test that might be a decent example (The best is FileLists):

   - ClaimParentProject_Parent - Tests for some of the simplest functionality
   - ClaimParentProject_Single - Tests for some of the simplest functionality
   - ConfigFile - Currently Skipped because not entirely implemented
   - Coverage_ExplicitOff - Turn off line coverage
   - Coverage_ExplicitOn - Turn on line coverage
   - Coverage_NotSet - When line coverage is not set it is off.
   - FileLists - A complete example that shows how to add files, include Mezzanine Packages and more
   - Identify - How to get at a bunch of platform detection variables.
   - Libraries_Dynamic - How to set dynamic linking
   - Libraries_Static - How to set static linking
   - LocationVars - How to get at of directory variables.
   - Mezz_PackageDirectory - How the Jagati interacts with environment variables
   - Exceptions - Generation of many types of exceptions

### Failing Cases

Many of the tests are negative case or check error messages, do no use these as examples:

   - FileLists_BadDoxMissing
   - FileLists_BadDoxRoot
   - FileLists_BadHeaderMissing
   - FileLists_BadHeaderRoot
   - FileLists_BadMainSrcMissing
   - FileLists_BadMainSrcRoot
   - FileLists_BadSourceMissing
   - FileLists_BadSourceRoot
   - FileLists_BadSwigMissing
   - FileLists_BadSwigRoot
   - FileLists_BadTestMissing
   - FileLists_BadTestRoot

Note the "Bad" don't copy bad things.

### Testing Tools

These aren't examples either:

   - RootTest.rb - The main test script
   - TestingTools - A bunch of ruby code that makes testing CMake scripts easy.
