pipeline {
    agent any
    environment {
        IMG_NAME = 'my-nx' // Docker image name
        DOCKER_REPO_DEV = 'prabadevops1003/dev' // Development Docker repository
        DOCKER_REPO_PROD = 'prabadevops1003/prod' // Production Docker repository
        EC2_IP = '18.139.227.199' // Replace with actual EC2 instance IP
        EC2_USER = 'ubuntu' // EC2 username
    }
    stages {
        stage('Build') {
            steps {
                script {
                    echo "Building Docker image..."
                    sh 'docker build -t ${IMG_NAME} .'
                }
            }
        }
        stage('Tag & Push to Dev Repo') {
            when {
                branch 'dev' // Executes only on the dev branch
            }
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', passwordVariable: 'PSWD', usernameVariable: 'LOGIN')]) {
                    script {
                        echo "Tagging and pushing Docker image to the Dev repository..."
                        sh """
                        docker tag ${IMG_NAME} ${DOCKER_REPO_DEV}:${IMG_NAME}
                        echo ${PSWD} | docker login -u ${LOGIN} --password-stdin
                        docker push ${DOCKER_REPO_DEV}:${IMG_NAME}
                        """
                    }
                }
            }
        }
        stage('Tag & Push to Prod Repo') {
            when {
                branch 'main' // Executes only on the main branch
            }
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', passwordVariable: 'PSWD', usernameVariable: 'LOGIN')]) {
                    script {
                        echo "Tagging and pushing Docker image to the Prod repository..."
                        sh """
                        docker tag ${IMG_NAME} ${DOCKER_REPO_PROD}:${IMG_NAME}
                        echo ${PSWD} | docker login -u ${LOGIN} --password-stdin
                        docker push ${DOCKER_REPO_PROD}:${IMG_NAME}
                        """
                    }
                }
            }
        }
        stage('Deploy to EC2') {
            when {
                branch 'main' // Executes only on the main branch
            }
            steps {
                sshagent(['ec2-ssh-credentials']) { // Use Jenkins SSH credentials
                    script {
                        echo "Deploying to EC2 instance..."
                        sh """
                        ssh -o StrictHostKeyChecking=no ${EC2_USER}@${EC2_IP} <<EOF
                        set -e  # Exit on error

                        echo "Pulling the latest Docker image..."
                        sudo docker pull ${DOCKER_REPO_PROD}:${IMG_NAME}

                        echo "Checking and stopping any container using port 80..."
                        sudo docker ps -q --filter "publish=80" | xargs --no-run-if-empty sudo docker stop
                        sudo docker ps -aq --filter "publish=80" | xargs --no-run-if-empty sudo docker rm

                        echo "Running new Docker container..."
                        sudo docker run -d --name my-nx -p 80:80 ${DOCKER_REPO_PROD}:${IMG_NAME}

                        echo "Deployment completed successfully!"
                        EOF
                        """
                    }
                }
            }
        }
    }
    post {
        always {
            echo "Pipeline execution complete!"
        }
        success {
            echo "Pipeline executed successfully."
        }
        failure {
            echo "Pipeline execution failed. Please check the logs."
        }
    }
}

