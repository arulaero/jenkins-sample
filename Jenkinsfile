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
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                }
            }
        }

        stage('Docker Build & Push') {
            steps {
                sh 'docker build -t $IMAGE:$TAG .'
                sh 'docker push $IMAGE:$TAG'
            }
        }

        stage('Deploy to Azure VM') {
            steps {
                sshagent(['deploy-ssh']) {
                    sh """
                    ssh -o StrictHostKeyChecking=no ${VM_USER}@${VM_HOST} '
                        docker pull ${IMAGE}:${TAG} &&
                        docker stop myapp || true &&
                        docker rm myapp || true &&
                        docker run -d --name myapp -p 80:80 ${IMAGE}:${TAG}
                    '
                    """
                }
            }
        }
    }
}
