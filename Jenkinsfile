#!groovy

try {
    stage('Checkout') {
        parallel FedoraGcc: { node('FedoraGcc') {
            checkout scm
        } },
        MacOSSierra: { node('MacOSSierra') {
            checkout scm
        } },
        RaspianJessie: { node('RaspianJessie') {
            checkout scm
        } },
        UbuntuClang: { node('UbuntuClang') {
            checkout scm
        } },
        UbuntuEmscripten: { node('UbuntuEmscripten') {
            checkout scm
        } },
        UbuntuGcc: { node('UbuntuGcc') {
            checkout scm
        } },
        windows7Mingw32: { node('windows7Mingw32') {
            checkout scm
        } },
        windows7Mingw64: { node('windows7Mingw64') {
            checkout scm
        } },
        windows7msvc: { node('windows7msvc') {
            checkout scm
        } }
    }

    stage('Test') {
        parallel FedoraGcc: { node('FedoraGcc') {
            dir('Test') { sh 'ruby RootTest.rb' }
        } },
        MacOSSierra: { node('MacOSSierra') {
            dir('Test') { sh 'export PATH=$PATH:/usr/local/bin/ && ruby RootTest.rb' }
        } },
        RaspianJessie: { node('RaspianJessie') {
            dir('Test') { sh 'ruby RootTest.rb' }
        } },
        UbuntuClang: { node('UbuntuClang') {
            dir('Test') { sh 'ruby RootTest.rb' }
        } },
        UbuntuEmscripten: { node('UbuntuEmscripten') {
            dir('Test') { sh 'ruby RootTest.rb' }
        } },
        UbuntuGcc: { node('UbuntuGcc') {
            dir('Test') { sh 'ruby RootTest.rb' }
        } },
        windows7Mingw32: { node('windows7Mingw32') {
            dir('Test') { bat 'ruby RootTest.rb -G "MinGW Makefiles"' }
        } },
        windows7Mingw64: { node('windows7Mingw64') {
            dir('Test') { bat 'ruby RootTest.rb -G "MinGW Makefiles"' }
        } },
        windows7msvc: { node('windows7msvc') {
            dir('Test') {
                bat '"C:\\Program Files (x86)\\Microsoft Visual Studio\\2017\\Community\\VC\\Auxiliary\\Build\\vcvarsall.bat" x86_amd64 && ruby RootTest.rb -G "Visual Studio 15 2017 Win64"'
            }
        } }
    }

    stage('SendMail') {
        notifyMail("Success!", "Testing of Jagati Successful.")
    }
}
catch(buildException) {
    notifyMail("Failure!", "Build of Jagati Failed!\nException: ${buildException}")
    throw buildException
}

def notifyMail (def Status, def ExtraInfo) {
    mail to: 'sqeaky@blacktoppstudios.com, makoenergy@blacktoppstudios.com',
         subject: "${Status} - ${env.JOB_NAME}",
         body: "${Status} - ${env.JOB_NAME} - Jenkins Build ${env.BUILD_NUMBER}\n\n" +
               "${ExtraInfo}\n\n" +
               "Check console output at $BUILD_URL to view the results."
}
