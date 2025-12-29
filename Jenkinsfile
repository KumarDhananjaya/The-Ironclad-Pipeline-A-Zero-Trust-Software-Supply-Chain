pipeline {
    agent any
    environment {
        VAULT_ADDR = 'http://vault.vault:8200'
        IMAGE_NAME = 'ironclad/demo-app'
    }
    stages {
        stage('Secret Scan') {
            steps {
                sh 'bash scripts/secret-scan.sh'
            }
        }
        stage('SAST') {
            steps {
                echo 'Running SonarQube scan...'
                // Placeholder for SonarQube scan
            }
        }
        stage('Build Image') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:${BUILD_NUMBER} ./app"
            }
        }
        stage('Container Scan') {
            steps {
                echo 'Running Trivy scan...'
                sh "trivy image --severity CRITICAL ${IMAGE_NAME}:${BUILD_NUMBER}"
            }
        }
        stage('Sign Image') {
            steps {
                echo 'Signing image with Cosign...'
                // sh "cosign sign --key vault://secret/cosign-key ${IMAGE_NAME}:${BUILD_NUMBER}"
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying to K8s...'
                sh "kubectl apply -f infrastructure/kubernetes/app-deploy.yaml"
            }
        }
    }
}
