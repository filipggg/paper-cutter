pipeline {
    agent any
    stages {
        stage('Test') {
            steps {
               script {
                  def customImage = docker.build("paper-cutter:${env.BUILD_ID}")
                  customImage.inside() {
                      dir('test') {
                          sh 'bash run_tests.sh'
                      }
                  }
               }
            }
       }
   }
}