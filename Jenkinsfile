#!groovy

pipeline {
    agent none
    options {
        buildDiscarder(logRotator(numToKeepStr:'30'))
    }
    stages {
        stage('CheckoutAndTest') {
            parallel {
                stage('FedoraGcc') {
                    agent { label "FedoraGcc" }
                    steps {
                        checkout scm
                        dir('Test') { sh """#!/bin/bash
                            hostname &&ruby RootTest.rb -GNinja
                        """}
                    }
                }
                stage('MacOSAir') {
                    agent { label "MacOSAir" }
                    steps {
                        checkout scm
                        dir('Test') { sh """#!/bin/bash
                            export PATH='$PATH:/usr/local/bin/' && ruby RootTest.rb -GNinja
                        """}
                    }
                }
                stage('Raspbian') {
                    agent { label "Raspbian" }
                    steps {
                        checkout scm
                        dir('Test') { sh """#!/bin/bash
                            ruby RootTest.rb -GNinja
                        """}
                    }
                }
                stage('UbuntuClang') {
                    agent { label "UbuntuClang" }
                    steps {
                        checkout scm
                        dir('Test') { sh """#!/bin/bash
                            export CC=`which clang` &&
                            export CXX=`which clang++` &&
                            ruby RootTest.rb -GNinja
                        """}
                    }
                }
                stage('UbuntuEmscripten') {
                    agent { label "UbuntuEmscripten" }
                    steps {
                        checkout scm
                        dir('Test') { sh """#!/bin/bash
                            source ~/emsdk/emsdk_env.sh &&
                            export CMAKE_TOOLCHAIN_FILE=~/emsdk/upstream/emscripten/cmake/Modules/Platform/Emscripten.cmake &&
                            export CC=`which emcc` &&
                            export CXX=`which em++` &&
                            ruby RootTest.rb -GNinja
                        """}
                    }
                }
                stage('UbuntuGcc') {
                    agent { label "UbuntuGcc" }
                    steps {
                        checkout scm
                        dir('Test') { sh """#!/bin/bash
                            export CC=gcc && export CXX=g++ && ruby RootTest.rb -GNinja
                        """}
                    }
                }
                stage('Windows10Mingw32') {
                    agent { label "Windows10Mingw32" }
                    steps {
                        checkout scm
                        dir('Test') { bat """
                            ruby RootTest.rb -G"Ninja" --force_32
                        """}
                    }
                }
                stage('Windows10Mingw64') {
                    agent { label "Windows10Mingw64" }
                    steps {
                        checkout scm
                        dir('Test') { bat """
                            ruby RootTest.rb -G"Ninja"
                        """}
                    }
                }
                stage('Windows10MSVC') {
                    agent { label "Windows10MSVC" }
                    steps {
                        checkout scm
                        dir('Test') { bat """
                            "C:\\Program Files (x86)\\Microsoft Visual Studio\\2019\\Community\\VC\\Auxiliary\\Build\\vcvarsall.bat" x86_amd64 && ruby RootTest.rb -G"Visual Studio 16 2019"'
                        """}
                    }
                }
            } // parallel
        } // CheckoutAndTest
    } // Stages

}
