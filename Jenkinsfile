pipeline {
    agent any

    stages {
        stage('Clone Repo') {
            steps {
                echo "Pulling code from GitHub..."
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
    }
}

stage('Deploy to Azure VM') {
    steps {
        sshagent(['deploy-ssh']) {
            sh """
            ssh -o StrictHostKeyChecking=no azureuser@4.229.234.155 '
                docker pull arulaero/myapp:latest &&
                docker stop myapp || true &&
                docker rm myapp || true &&
                docker run -d --name myapp -p 80:80 arulaero/myapp:latest
            '
            """
        }
    }
}
