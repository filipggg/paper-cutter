pipeline {
    agent any


    // We'll be running in a custom Docker image, but could be a ready-made
    // image from DockerHub
    //
    // agent {
    //    docker {
    //        image 'loxygen/arch-latex'
    //    }
    // }

    stages {
        stage('Test') {
            steps {
               script {
                  // Custom Docker image, see Dockerfile
                  def customImage = docker.build("paper-cutter:${env.BUILD_ID}")
                  customImage.inside() {
                      dir('test') {
                        // The user under which the job is run does not have a proper home directory (!)
                        sh 'export PATH="$PATH:/usr/bin/vendor_perl"; export fakehomedir=`pwd`/fakehome; rm -rf $fakehomedir; mkdir $fakehomedir; export HOME=$fakehomedir; git config --global user.email "testing@testing.invalid"; git config --global user.name "testing"; bash run_tests.sh'
                      }
                  }
               }
            }
       }
   }
}