#!groovy

try {
    stage('Checkout') {
        parallel UbuntuEmscripten: {
            node('UbuntuEmscripten') {
                checkout scm
            }
        },
        RaspianJessie: {
            node('RaspianJessie') {
                checkout scm
            }
        },
        MacOSSierra: {
            node('MacOSSierra') {
                checkout scm
            }
        },
        FedoraGcc: {
            node('FedoraGcc') {
                checkout scm
            }
        },
        UbuntuGcc: {
            node('UbuntuGcc') {
                checkout scm
            }
        },
        UbuntuClang: {
            node('UbuntuClang') {
                checkout scm
            }
        }
    }

    stage('Test') {
        parallel UbuntuEmscripten: {
            node('UbuntuEmscripten') {
                sh """ cd Test                                                                                        &&
                       ruby RootTest.rb
                """
            }
        },
        RaspianJessie: {
            node('RaspianJessie') {
                sh """ cd Test                                                                                        &&
                       ruby RootTest.rb
                """
            }
        },
        MacOSSierra: {
            node('MacOSSierra') {
                sh """ cd Test                                                                                        &&
                       export PATH=$PATH:/usr/local/bin/                                                              &&
                       ruby RootTest.rb
                """
            }
        },
        FedoraGcc: {
            node('FedoraGcc') {
                sh """ cd Test                                                                                        &&
                       ruby RootTest.rb
                """
            }
        },
        UbuntuGcc: {
            node('UbuntuGcc') {
                sh """ cd Test                                                                                        &&
                       ruby RootTest.rb
                """
            }
        },
        UbuntuClang: {
            node('UbuntuClang') {
                sh """ cd Test                                                                                        &&
                       ruby RootTest.rb
                """
            }
        }
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
