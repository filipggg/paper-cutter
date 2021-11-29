pipeline {
    agent {
        docker {
            image 'loxygen/autozoil'
        }
    }
    stages {
        stage('Test') {
            steps {
                  dir('test') {
                     sh 'bash run_tests.sh'
                  }
            }
       }
   }
}