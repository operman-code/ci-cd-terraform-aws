CI/CD Pipeline with Terraform, AWS & Jenkins ok

This repository demonstrates a full CI/CD pipeline using Jenkins, Terraform, and AWS, with automatic pipeline triggers from GitHub push events. The pipeline provisions AWS resources (e.g., EC2 instances) using Terraform and includes manual approval before applying changes.

Features

Automatic pipeline trigger on GitHub push to main branch

Terraform infrastructure provisioning on AWS

Manual approval stage before applying changes

Destroy stage to safely remove resources via Jenkins

AWS credentials handled securely through Jenkins credentials

Extensible for any Terraform-managed infrastructure

Architecture

GitHub → Stores Terraform code and Jenkinsfile

GitHub Webhook → Triggers Jenkins pipeline automatically

Jenkins → Pulls latest code, runs Terraform plan, waits for approval, applies resources

Terraform + AWS → Provisions resources defined in .tf files

Prerequisites

AWS Account with IAM credentials (or EC2 instance with IAM Role)

Terraform v1.14+ installed on Jenkins host

Jenkins v2.500+ installed

GitHub repository access

EC2 Security Group allowing access to Jenkins (port 8080)

Setup Instructions
1. Jenkins Configuration

Create a New Item → Pipeline in Jenkins

Use Pipeline script from SCM:

Repository URL: https://github.com/<your-username>/ci-cd-terraform-aws.git

Branch: main

Script Path: Jenkinsfile

Enable GitHub hook trigger for GITScm polling under Build Triggers

2. AWS Credentials

Add Jenkins Credentials:

ID: aws-access-key-id → Secret Text → AWS Access Key ID

ID: aws-secret-access-key → Secret Text → AWS Secret Access Key

Jenkins will inject these credentials into the pipeline environment automatically.

3. GitHub Webhook

Go to Settings → Webhooks → Add webhook

Payload URL: http://<JENKINS_PUBLIC_IP>:8080/github-webhook/

Content type: application/json

Event: Just the push event

Secret: Optional (configure in Jenkins if used)

Active: 

Usage

Push code changes to the main branch

Jenkins pipeline triggers automatically

Pipeline stages:

Terraform Init → Initializes Terraform

Terraform Plan → Shows planned changes

Terraform Apply Approval → Manual approval stage

Terraform Apply → Applies infrastructure changes

Destroy Resources (Optional) → Manual approval to destroy all resources

Terraform Folder Structure
terraform/
├── main.tf           # Define EC2, Security Groups, etc.
├── variables.tf      # Input variables
├── outputs.tf        # Outputs for resources
├── terraform.tfstate # Auto-generated state file
└── terraform.tfvars  # Variable values

Pipeline Jenkinsfile
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

Notes

The manual approval ensures you don’t accidentally apply or destroy resources

Always use IAM Roles for Jenkins EC2 in production for secure credential management

You can extend this pipeline to multi-region deployments, S3 buckets, RDS, etc.
