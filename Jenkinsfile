#!groovy

pipeline {
    agent none
    options {
        buildDiscarder(logRotator(numToKeepStr:'30'))
    }
    stages {
        stage('Checkout') {
            parallel {
                stage('FedoraGcc') {
                    agent { label "FedoraGcc" }
                    steps { checkout scm }
                }
                stage('MacOSAir') {
                    agent { label "MacOSAir" }
                    steps { checkout scm }
                }
                stage('Raspbian') {
                    agent { label "Raspbian" }
                    steps { checkout scm }
                }
                stage('UbuntuClang') {
                    agent { label "UbuntuClang" }
                    steps { checkout scm }
                }
                stage('UbuntuEmscripten') {
                    agent { label "UbuntuEmscripten" }
                    steps { checkout scm }
                }
                stage('UbuntuGcc') {
                    agent { label "UbuntuGcc" }
                    steps { checkout scm }
                }
                stage('windows7Mingw32') {
                    agent { label "windows7Mingw32" }
                    steps { checkout scm }
                }
                stage('windows7Mingw64') {
                    agent { label "windows7Mingw64" }
                    steps { checkout scm }
                }
                stage('windows7msvc') {
                    agent { label "windows7msvc" }
                    steps { checkout scm }
                }
            }
        } // Checkout

        stage('Test') {
            parallel {
                stage('FedoraGcc') {
                    agent { label "FedoraGcc" }
                    steps {
                        dir('Test') { sh 'ruby RootTest.rb -GNinja' }
                    }
                }
                stage('MacOSAir') {
                    agent { label "MacOSAir" }
                    steps {
                        dir('Test') { sh """export PATH='$PATH:/usr/local/bin/' && ruby RootTest.rb -GNinja""" }
                    }
                }
                stage('Raspbian') {
                    agent { label "Raspbian" }
                    steps {
                        dir('Test') { sh 'ruby RootTest.rb -GNinja' }
                    }
                }
                stage('UbuntuClang') {
                    agent { label "UbuntuClang" }
                    steps {
                        dir('Test') { sh 'ruby RootTest.rb -GNinja' }
                     }
                }
                // Emscripten needs custom commands not supported in the test suite.
                //stage('UbuntuEmscripten') {
                //    agent { label "UbuntuEmscripten" }
                //    steps {
                //        dir('Test') { sh 'ruby RootTest.rb -GNinja' }
                //    }
                //}
                stage('UbuntuGcc') {
                    agent { label "UbuntuGcc" }
                    steps {
                        dir('Test') { sh 'ruby RootTest.rb -GNinja' }
                    }
                }
                stage('windows7Mingw32') {
                    agent { label "windows7Mingw32" }
                    steps {
                        dir('Test') { bat 'ruby RootTest.rb -G"MinGW Makefiles"' }
                    }
                }
                stage('windows7Mingw64') {
                    agent { label "windows7Mingw64" }
                    steps {
                        dir('Test') { bat 'ruby RootTest.rb -G"MinGW Makefiles"' }
                    }
                }
                stage('windows7msvc') {
                    agent { label "windows7msvc" }
                    steps {
                        dir('Test') {
                            bat """
                                "C:\\Program Files (x86)\\Microsoft Visual Studio\\2017\\Community\\VC\\Auxiliary\\Build\\vcvarsall.bat" x86_amd64 && ruby RootTest.rb -G"Visual Studio 15 2017 Win64"'
                            """
                        }
                    }
                }
            }
        } // BuildTest-Debug


    } // Stages

}
