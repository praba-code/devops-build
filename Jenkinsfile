pipeline {
    agent any
    environment {
        IMG_NAME = 'my-nx'
        DOCKER_REPO_DEV = 'prabadevops1003/dev'
        DOCKER_REPO_PROD = 'prabadevops1003/prod'
        EC2_IP = '18.139.227.199'  // Replace with actual EC2 IP
	EC2_USER = 'ubuntu'
    }
    stages {
        stage('Build') {
            steps {
                script {
                    sh 'docker build -t ${IMG_NAME} .'
                }
            }
        }
        stage('Tag & Push to Dev Repo') {
            when {
                branch 'dev'
            }
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', passwordVariable: 'PSWD', usernameVariable: 'LOGIN')]) {
                    script {
                        sh 'docker tag ${IMG_NAME} ${DOCKER_REPO_DEV}:${IMG_NAME}'
                        sh 'echo ${PSWD} | docker login -u ${LOGIN} --password-stdin'
                        sh 'docker push ${DOCKER_REPO_DEV}:${IMG_NAME}'
                    }
                }
            }
        }
        stage('Tag & Push to Prod Repo') {
            when {
                branch 'main'
            }
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', passwordVariable: 'PSWD', usernameVariable: 'LOGIN')]) {
                    script {
                        sh 'docker tag ${IMG_NAME} ${DOCKER_REPO_PROD}:${IMG_NAME}'
                        sh 'echo ${PSWD} | docker login -u ${LOGIN} --password-stdin'
                        sh 'docker push ${DOCKER_REPO_PROD}:${IMG_NAME}'
                    }
                }
            }
        }
        stage('Deploy to EC2') {
            when {
                branch 'main'
            }
 		steps {
                sshagent(['ec2-ssh-credentials']) {
                    sh """
                        ssh -o StrictHostKeyChecking=no ${EC2_USER}@${EC2_IP} << 'EOF'
                        set -e  # Exit immediately if a command exits with a non-zero status
                        echo "Pulling the latest image..."
                        sudo docker pull ${DOCKER_REPO_PROD}:${IMG_NAME}
                        
                        echo "Checking and stopping any container using port 80..."
                        if sudo lsof -i :80; then
                            sudo docker stop \$(sudo docker ps -q --filter "publish=80") || true
                            sudo docker rm \$(sudo docker ps -aq --filter "publish=80") || true
                        fi

                        echo "Running new container..."
                        sudo docker run -d --name my-nx -p 80:80 ${DOCKER_REPO_PROD}:${IMG_NAME}
                        echo "Deployment completed!"
                        EOF
                    """
                }
            }
        }
    }
    post {
        always {
            echo 'Pipeline execution complete!'
        }
    }
}



















