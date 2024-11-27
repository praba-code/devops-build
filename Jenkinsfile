pipeline {
    agent any
    environment {
        IMG_NAME = 'my-nx'
        DOCKER_REPO_DEV = 'prabadevops1003/dev'
        DOCKER_REPO_PROD = 'prabadevops1003/prod'
        EC2_IP = '18.139.227.199'  // Replace with actual EC2 IP
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
                sshagent(['ec2-ssh-credentials']) {  // SSH Key stored in Jenkins credentials
                    sh """
                        ssh -o StrictHostKeyChecking=no ubuntu@${EC2_IP} << EOF
			echo "\$DOCKER_PASSWORD" | docker login --username "\$DOCKER_USERNAME" --password-stdin
                        docker pull ${DOCKER_REPO_PROD}:${IMG_NAME}
                        docker stop my-nx|| true
                        docker rm my-nx|| true
                        docker run -d --name my-nx -p 80:80 ${DOCKER_REPO_PROD}:${IMG_NAME}
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


















