pipeline {
    agent any
    environment {
        DOCKER_HUB_CREDENTIALS = credentials('docker-hub')
        DOCKER_IMAGE_NAME = "your-dockerhub-username/devops-app"
    }
    stages {
        stage('Clone') {
            steps {
                checkout scm
            }
        }
        stage('Build') {
            steps {
                script {
                    sh 'docker build -t $DOCKER_IMAGE_NAME:dev .'
                }
            }
        }
        stage('Push to Docker Hub') {
            steps {
                script {
                    sh """
                    echo "$DOCKER_HUB_CREDENTIALS_PSW" | docker login -u "$DOCKER_HUB_CREDENTIALS_USR" --password-stdin
                    docker tag $DOCKER_IMAGE_NAME:dev $DOCKER_IMAGE_NAME:${BRANCH_NAME}
                    docker push $DOCKER_IMAGE_NAME:${BRANCH_NAME}
                    """
                }
            }
        }
        stage('Deploy to Server') {
            when {
                branch 'main'
            }
            steps {
                sshagent(['your-ssh-key-id']) {
                    sh """
                    ssh -o StrictHostKeyChecking=no ubuntu@<Application-EC2-IP> <<EOF
                    docker pull $DOCKER_IMAGE_NAME:main
                    docker run -d -p 80:80 $DOCKER_IMAGE_NAME:main
                    EOF
                    """
                }
            }
        }
    }
}

