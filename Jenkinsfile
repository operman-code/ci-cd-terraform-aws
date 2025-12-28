pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('aws-access-key-id')   // Jenkins credentials ID
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key') // Jenkins credentials ID
        TERRAFORM_DIR = 'terraform'
    }
    stages {
        stage('Terraform Init') { steps { dir(TERRAFORM_DIR) { sh 'terraform init' } } }
        stage('Terraform Plan') { steps { dir(TERRAFORM_DIR) { sh 'terraform plan' } } }
        stage('Terraform Apply Approval') { steps { input 'Apply Terraform?' } }
        stage('Terraform Apply') { steps { dir(TERRAFORM_DIR) { sh 'terraform apply -auto-approve' } } }
    }
}
