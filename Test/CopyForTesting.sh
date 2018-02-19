#!/bin/bash

# This script is intended to ease some development pains while working on the Jagati. The Mezz_StaticFoundation and
# Mezz_Test packages need to check out from and verify the checksum of the Jagati it gets during this process. When run
# from the Jagati/Test directory this script copies the Jagati into all package build directories so those checks pass.

if [ -z "${MEZZ_PACKAGE_DIR+x}" ] ; then
    echo "MEZZ_PACKAGE_DIR unset not copying Jagati to other projects"
else
    echo "MEZZ_PACKAGE_DIR set to $MEZZ_PACKAGE_DIR, copy to default build dirs"

    cp -v ../Jagati.cmake $MEZZ_PACKAGE_DIR/Mezz_Test-build/
    cp -v ../Jagati.cmake $MEZZ_PACKAGE_DIR/Mezz_StaticFoundation-build/
    cp -v ../Jagati.cmake $MEZZ_PACKAGE_DIR/Mezz_Foundation-build/
fi

#cp ../Jagati.cmake builds/Mezz_Test-build/
#cp ../Jagati.cmake builds/Mezz_StaticFoundation-build/
#cp ../Jagati.cmake builds/Mezz_PackageDirectory/foo/Mezz_Test-build/
#cp ../Jagati.cmake builds/Mezz_PackageDirectory/foo/Mezz_StaticFoundation-build/
