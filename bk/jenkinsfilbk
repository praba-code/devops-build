pipeline {
    agent any
    environment {
        DOCKER_DEV_REPO = 'your-dockerhub-username/dev' // Dev repository in Docker Hub
        DOCKER_PROD_REPO = 'your-dockerhub-username/prod' // Prod repository in Docker Hub
        DOCKER_CREDENTIALS_ID = 'docker-hub-credentials' // Docker Hub credentials in Jenkins
    }
    triggers {
        githubPush() // Trigger builds on push events
    }
    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }
        stage('Build and Push Docker Image - Dev') {
            when {
                branch 'dev' // Trigger only on dev branch
            }
            steps {
                script {
                    echo 'Building Docker image for Dev repository'
                    sh '''
                        docker build -t $DOCKER_DEV_REPO:latest .
                        docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD
                        docker push $DOCKER_DEV_REPO:latest
                    '''
                }
            }
        }
        stage('Build and Push Docker Image - Prod') {
            when {
                branch 'main' // Trigger only on master branch
            }
            steps {
                script {
                    echo 'Building Docker image for Prod repository'
                    sh '''
                        docker build -t $DOCKER_PROD_REPO:latest .
                        docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD
                        docker push $DOCKER_PROD_REPO:latest
                    '''
                }
            }
        }
    }
    post {
        success {
            echo 'Build, Push, and Deploy stages executed successfully.'
        }
        failure {
            echo 'Build failed. Check logs for errors.'
        }
    }
}

