pipeline {
    agent any
    environment {
        DOCKER_HUB_REPO_DEV = 'your-dockerhub-username/dev-app'
        DOCKER_HUB_REPO_PROD = 'your-dockerhub-username/prod-app'
        DOCKER_HUB_CREDENTIALS = 'docker-hub-credentials'  // Replace with your Jenkins credential ID
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Docker Build and Push') {
            steps {
                script {
                    def branch = env.BRANCH_NAME
                    def repo = branch == 'dev' ? "${DOCKER_HUB_REPO_PROD}" : "${DOCKER_HUB_REPO_DEV}"

                    // Login to Docker Hub
                    echo "Logging into Docker Hub"
                    withCredentials([usernamePassword(credentialsId: DOCKER_HUB_CREDENTIALS, usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh "docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD"
                    }

                    // Build Docker image
                    echo "Building Docker image for ${repo}"
                    sh './build.sh'

                    // Tag Docker image
                    sh "docker tag your-dockerhub-username/dev-app:latest ${repo}:latest"
                    
                    // Push Docker image
                    echo "Pushing Docker image to ${repo}"
                    sh "docker push ${repo}:latest"
                }
            }
        }
    }
    post {
        always {
            // Optional: Deploy to server (EC2, Kubernetes, etc.)
            echo "Deploying the app"
            sh './deploy.sh'
        }
    }
}

