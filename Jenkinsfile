pipeline {
    agent any
    stages {
        stage('Test') {
            steps {
               script {
                  def customImage = docker.build("paper-cutter:${env.BUILD_ID}")
                  customImage.inside() {
                      dir('test') {
                          sh 'git clone https://git.wmi.amu.edu.pl/filipg/paper-cutter.git'
                          sh 'bash run_tests.sh'
                      }
                  }
               }
            }
       }
   }
}