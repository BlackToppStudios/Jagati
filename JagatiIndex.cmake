#!/usr/bin/cmake
#
# This is a list of packages for the Jagati so the URL of packages can be seperate from all the functional logic. The
# goal is to allow game developers to provide their own package list if desired.
#

# Custom Package lists might include customn macros here to aid in defining packages, those would go here.

#
# Foundational Packages
#

PackageMetadata(
    "Mezz_PackageName"
    "https://github.com/BlackToppStudios/Mezz_PackageName.git"
    "A package that can be copied when creating a new Jagati Package."
)

PackageMetadata(
    "Mezz_StaticFoundation"
    "https://github.com/BlackToppStudios/Mezz_StaticFoundation.git"
    "A number of compile time settings that are likely useful to most applications."
)

PackageMetadata(
    "Mezz_Test"
    "https://github.com/BlackToppStudios/Mezz_Test.git"
    "A unit testing suite that is well integrated into the Mezzanine and Jagati."
)

PackageMetadata(
    "Mezz_Foundation"
    "https://github.com/BlackToppStudios/Mezz_Foundation.git"
    "This package provides the most basic of runtime components and datatypes."
)

PackageMetadata(
    "Mezz_FlowControl"
    "https://github.com/BlackToppStudios/Mezz_FlowControl.git"
    "This package contains advanced structures for controlling logic flow in sophisticated systems."
)

PackageMetadata(
    "Mezz_IOStreams"
    "https://github.com/BlackToppStudios/Mezz_IOStreams.git"
    "This package contains basic helper types for simple I/O."
)

PackageMetadata(
    "Mezz_Filesystem"
    "https://github.com/BlackToppStudios/Mezz_Filesystem.git"
    "This package contains a number of utilities for accessing the local filesystems."
)

PackageMetadata(
    "Mezz_SerializationBackendXML"
    "https://github.com/BlackToppStudios/Mezz_SerializationBackendXML.git"
    "Mezzanine Serialization Implementation serializing to XML."
)

#
# Core Packages
#

#
# Extra Packages
#

#
# Tool Packages
#

PackageMetadata(
    "Mezz_Mezzy"
    "https://github.com/BlackToppStudios/Mezz_Mezzy.git"
    "Tool for running code in each Mezzanine repo."
)
