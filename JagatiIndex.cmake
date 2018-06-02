#!/usr/bin/cmake
#
# This script serves as a list of packages for the Jagati so the URL of packages can be serperate
# from all the functional logic. The goal is to allow game developers to provide their own package
# list if desired.
#

# To add a package use the Following Synax:
# AddJagatiPackage(PackageName Url DocString)

# Move this to the Jagati in the next Upgrade and fully document it.
function(AddJagatiPackage PackageName Url DocString)
    # Consider Adding JagatiPackagesAvailable lists to allowing enumerating all URLs
    set("${PackageName}_GitURL" "${Url}" CACHE STRING "${DocString}")
endfunction(AddJagatiPackage PackageName Url DocString)

AddJagatiPackage(
    "Mezz_Foundation"
    "https://github.com/BlackToppStudios/Mezz_Foundation.git"
    "This package provides the most basic of runtime components and datatypes."
)

AddJagatiPackage(
    "Mezz_PackageName"
    "https://github.com/BlackToppStudios/Mezz_PackageName.git"
    "A package that can be copied when creating a new Jagati Package."
)

AddJagatiPackage(
    "Mezz_StaticFoundation"
    "https://github.com/BlackToppStudios/Mezz_StaticFoundation.git"
    "A number of compile time settings that are likely useful to most applications."
)

AddJagatiPackage(
    "Mezz_Test"
    "https://github.com/BlackToppStudios/Mezz_Test.git"
    "A unit testing suite that is well integrated into the Mezzanine and Jagati."
)

AddJagatiPackage(
    "Mezz_SerializationBackendXML"
    "https://github.com/BlackToppStudios/Mezz_SerializationBackendXML.git"
    "Mezzanine Serialization Implementation serializing to XML."
)
