pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        TERRAFORM_DIR         = 'terraform'
    }
    stages {
        stage('Terraform Init') {
            steps { dir(TERRAFORM_DIR) { sh 'terraform init' } }
        }
        stage('Terraform Plan') {
            steps { dir(TERRAFORM_DIR) { sh 'terraform plan' } }
        }
        stage('Terraform Apply Approval') {
            steps { input message: 'Apply Terraform changes?', ok: 'Apply' }
        }
        stage('Terraform Apply') {
            steps { dir(TERRAFORM_DIR) { sh 'terraform apply -auto-approve' } }
        }
        stage('Destroy Resources (Optional)') {
            steps {
                input message: 'Do you want to destroy all resources?', ok: 'Destroy'
                dir(TERRAFORM_DIR) { sh 'terraform destroy -auto-approve' }
            }
        }
    }
}
