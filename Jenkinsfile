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
                stage('MacOSSierra') {
                    agent { label "MacOSSierra" }
                    steps { checkout scm }
                }
                stage('RaspianJessie') {
                    agent { label "RaspianJessie" }
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
                stage('MacOSSierra') {
                    agent { label "MacOSSierra" }
                    steps {
                        dir('Test') { sh """export PATH='$PATH:/usr/local/bin/' && ruby RootTest.rb -GNinja""" }
                    }
                }
                stage('RaspianJessie') {
                    agent { label "RaspianJessie" }
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
                        dir('Test') { sh 'ruby RootTest.rb -GNinja' }
                    }
                }
                stage('windows7Mingw64') {
                    agent { label "windows7Mingw64" }
                    steps {
                        dir('Test') { sh 'ruby RootTest.rb -GNinja' }
                    }
                }
                stage('windows7msvc') {
                    agent { label "windows7msvc" }
                    steps {
                        dir('Test') { sh 'ruby RootTest.rb -GNinja' }
                    }
                }
            }
        } // BuildTest-Debug


    } // Stages

}
