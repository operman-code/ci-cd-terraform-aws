pipeline {
    agent any

    environment {
        TERRAFORM_DIR = 'terraform'
    }

    stages {
        stage('Terraform Init') {
            steps {
                dir(TERRAFORM_DIR) {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir(TERRAFORM_DIR) {
                    sh 'terraform plan'
                }
            }
        }

        stage('Terraform Apply Approval') {
            steps {
                input message: 'Do you want to apply Terraform changes?', ok: 'Apply'
            }
        }

        stage('Terraform Apply') {
            steps {
                dir(TERRAFORM_DIR) {
                    sh 'terraform apply -auto-approve'
                }
            }
        }
    }
}
