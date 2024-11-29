pipeline { 
    agent any
    environment {
        IMG_NAME = 'my-nx'
        TAG = "${env.BUILD_NUMBER}"
        DOCKER_REPO_DEV = 'prabadevops1003/dev'
        DOCKER_REPO_PROD = 'prabadevops1003/prod'
        EC2_IP = '54.169.85.62'  // Replace with actual EC2 IP
        EC2_USER = 'ubuntu'
    }
    stages {
        stage('Build') {
            steps {
                script {
                    sh 'docker build -t ${IMG_NAME}:${TAG} .'
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
                            docker tag ${IMG_NAME}:${TAG} ${DOCKER_REPO_DEV}:${TAG}
                            echo ${PSWD} | docker login -u ${LOGIN} --password-stdin
                            docker push ${DOCKER_REPO_DEV}:${TAG}
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
                            docker tag ${IMG_NAME}:${TAG} ${DOCKER_REPO_PROD}:${TAG}
                            echo ${PSWD} | docker login -u ${LOGIN} --password-stdin
                            docker push ${DOCKER_REPO_PROD}:${TAG}
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
                    sh """
                        ssh -o StrictHostKeyChecking=no ${EC2_USER}@${EC2_IP} << 'EOF'
                        docker pull ${DOCKER_REPO_PROD}:${TAG}
                        CONTAINER_ID=$(docker ps -a -q -f name=my-nx)
                        if [ -n "$CONTAINER_ID" ]; then
                            docker stop my-nx || true
                            docker rm my-nx || true
                        fi
                        docker run -d --name my-nx -p 80:80 ${DOCKER_REPO_PROD}:${TAG}
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
        success {
            echo 'Deployment successful!'
        }
        failure {
            echo 'Pipeline failed. Please check the logs for more details.'
        }
    }
}
