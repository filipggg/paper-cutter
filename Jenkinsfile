pipeline {
    agent any
    stages {
        stage('Test') {
            steps {
               script {
                  def customImage = docker.build("paper-cutter:${env.BUILD_ID}")
                  customImage.inside() {
                      dir('test') {
                        sh 'export PATH="$PATH:/usr/bin/vendor_perl"; export fakehomedir=`pwd`/fakehome; rm -rf $fakehomedir; mkdir $fakehomedir; export HOME=$fakehomedir; git config --global user.email "testing@testing.invalid"; git config --global user.name "testing"; bash run_tests.sh'
                      }
                  }
               }
            }
       }
   }
}