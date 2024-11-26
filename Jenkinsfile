pipeline {
    agent any

    environment {
        DOCKER_HUB_CREDENTIALS = 'docker-hub-credentials' // Update with your Jenkins credentials ID
        DEPLOY_SSH_CREDENTIALS = 'ec2-ssh-credentials'   // Update with your Jenkins credentials ID
        DOCKER_IMAGE_NAME_DEV = 'prabadevops1003/dev'
        DOCKER_IMAGE_NAME_PROD = 'prabadevops1003/prod'
        DEPLOY_SERVER = '13.212.254.19'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Build and Push to Docker Hub') {
            when {
                branch 'dev'
            }
            steps {
                script {
                    sh """
                    docker build -t ${DOCKER_IMAGE_NAME_DEV}:latest .
                    docker login -u ${DOCKER_HUB_CREDENTIALS_USR} -p ${DOCKER_HUB_CREDENTIALS_PSW}
                    docker push ${DOCKER_IMAGE_NAME_DEV}:latest
                    """
                }
            }
        }
        
        stage('Build, Push to Docker Hub, and Deploy to EC2') {
            when {
                branch 'main'
            }
            steps {
                script {
                    sh """
                    docker build -t ${DOCKER_IMAGE_NAME_PROD}:latest .
                    docker login -u ${DOCKER_HUB_CREDENTIALS_USR} -p ${DOCKER_HUB_CREDENTIALS_PSW}
                    docker push ${DOCKER_IMAGE_NAME_PROD}:latest
                    """
                }

                sshagent (credentials: [DEPLOY_SSH_CREDENTIALS]) {
                    sh """
                    ssh -o StrictHostKeyChecking=no ubuntu@${DEPLOY_SERVER} "
                    docker pull ${DOCKER_IMAGE_NAME_PROD}:latest &&
                    docker stop my-app || true &&
                    docker rm my-app || true &&
                    docker run -d --name my-app -p 80:80 ${DOCKER_IMAGE_NAME_PROD}:latest
                    "
                    """
                }
            }
        }
    }
}

