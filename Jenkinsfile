pipeline {
    agent any

    stages {
        stage('Check Terraform') {
            steps {
                sh 'terraform version'
            }
        }
    }
}
