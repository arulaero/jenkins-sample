pipeline {
    agent any

    environment {
        IMAGE = "arulaero/myapp"
        TAG = "latest"
        VM_USER = "azureuser"
        VM_HOST = "4.229.234.155"
    }

    stages {

        stage('Clone Repo') {
            steps {
                echo "Pulling code from GitHub..."
                checkout scm
            }
        }

        stage('Build') {
            steps {
                echo "Building the project..."
            }
        }

        stage('Test') {
            steps {
                echo "Running tests..."
            }
        }

        stage('Docker Login') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    bat """
                    echo %DOCKER_PASS% | docker login -u %DOCKER_USER% --password-stdin
                    """
                }
            }
        }

        stage('Docker Build & Push') {
            steps {
                bat "docker build -t %IMAGE%:%TAG% ."
                bat "docker push %IMAGE%:%TAG%"
            }
        }

        stage('Deploy to Azure VM') {
            steps {
                sshagent(['deploy-ssh']) {
                    bat """
                    ssh -o StrictHostKeyChecking=no %VM_USER%@%VM_HOST% "docker pull %IMAGE%:%TAG%"
                    ssh -o StrictHostKeyChecking=no %VM_USER%@%VM_HOST% "docker stop myapp || true"
                    ssh -o StrictHostKeyChecking=no %VM_USER%@%VM_HOST% "docker rm myapp || true"
                    ssh -o StrictHostKeyChecking=no %VM_USER%@%VM_HOST% "docker run -d --name myapp -p 80:80 %IMAGE%:%TAG%"
                    """
                }
            }
        }
    }
}
