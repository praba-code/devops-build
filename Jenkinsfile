pipeline { 
    agent any
    environment {
        IMG_NAME = 'my-nx'
        DOCKER_REPO_DEV = 'prabadevops1003/dev'
        DOCKER_REPO_PROD = 'prabadevops1003/prod'
        EC2_IP = '13.212.254.9'  // Replace with actual EC2 IP
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
                        sh '''
                            docker tag ${IMG_NAME} ${DOCKER_REPO_DEV}:${IMG_NAME}
                            echo ${PSWD} | docker login -u ${LOGIN} --password-stdin
                            docker push ${DOCKER_REPO_DEV}:${IMG_NAME}
                        '''
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
                        sh '''
                            docker tag ${IMG_NAME} ${DOCKER_REPO_PROD}:${IMG_NAME}
                            echo ${PSWD} | docker login -u ${LOGIN} --password-stdin
                            docker push ${DOCKER_REPO_PROD}:${IMG_NAME}
                        '''
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
            sh '''
             
                set -e

                echo "Pulling the latest image..."
                docker pull ${DOCKER_REPO_PROD}:${IMG_NAME}

                echo "Checking if container named my-nx is already running..."
                CONTAINER_ID=$(sudo docker ps -a -q -f name=my-nx)
                if [ ! -n "$CONTAINER_ID" ]; then
                    echo "Stopping the existing container..."
                    docker stop my-nx || true
                    echo "Removing the existing container..."
                    docker rm my-nx || true
                fi

                echo "Running the new container..."
                docker run -d --name my-nx -p 80:80 ${DOCKER_REPO_PROD}:${IMG_NAME}
                echo "Deployment completed!"
		
              '''
                }
            }
        }
    }   
    post {
        always {
            echo 'Pipeline execution complete!'
        }
        success {
            echo 'Deployment successful!'
        }
        failure {
            echo 'Pipeline failed. Please check the logs for more details.'
        }
    }
}
