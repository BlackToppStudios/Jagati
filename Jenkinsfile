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
                        dir('Test') { sh 'ruby RootTest.rb -GNinja' }
                    }
                }
                stage('MacOSAir') {
                    agent { label "MacOSAir" }
                    steps {
                        checkout scm
                        dir('Test') { sh """export PATH='$PATH:/usr/local/bin/' && ruby RootTest.rb -GNinja""" }
                    }
                }
                stage('Raspbian') {
                    agent { label "Raspbian" }
                    steps {
                        checkout scm
                        dir('Test') { sh 'ruby RootTest.rb -GNinja' }
                    }
                }
                stage('UbuntuClang') {
                    agent { label "UbuntuClang" }
                    steps {
                        checkout scm
                        dir('Test') { sh 'ruby RootTest.rb -GNinja' }
                    }
                }
                stage('UbuntuEmscripten') {
                    agent { label "UbuntuEmscripten" }
                    steps {
                        checkout scm
                        //dir('Test') { sh 'ruby RootTest.rb -GNinja' }
                    }
                }
                stage('UbuntuGcc') {
                    agent { label "UbuntuGcc" }
                    steps {
                        checkout scm
                        dir('Test') { sh 'ruby RootTest.rb -GNinja' }
                    }
                }
                stage('Windows10Mingw32') {
                    agent { label "Windows10Mingw32" }
                    steps {
                        checkout scm
                        dir('Test') { bat 'ruby RootTest.rb -G"MinGW Makefiles"' }
                    }
                }
                stage('Windows10Mingw64') {
                    agent { label "Windows10Mingw64" }
                    steps {
                        checkout scm
                        dir('Test') { bat 'ruby RootTest.rb -G"MinGW Makefiles"' }
                    }
                }
                stage('Windows10MSVC') {
                    agent { label "Windows10MSVC" }
                    steps {
                        checkout scm
                        dir('Test') {
                            bat """
                                "C:\\Program Files (x86)\\Microsoft Visual Studio\\2017\\Community\\VC\\Auxiliary\\Build\\vcvarsall.bat" x86_amd64 && ruby RootTest.rb -G"Visual Studio 15 2017 Win64"'
                            """
                        }
                    }
                }
            }
        } // CheckoutAndTest
    } // Stages

}
