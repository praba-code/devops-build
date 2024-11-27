pipeline {
    agent any
    environment {
        DOCKER_HUB_CREDENTIALS = credentials('docker-hub-credentials') // Store Docker Hub credentials in Jenkins
        DOCKER_IMAGE = "your_dockerhub_username/dev-repo"
    }
    triggers {
        githubPush()
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'dev', url: 'https://github.com/your-username/your-repo.git'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t ${DOCKER_IMAGE}:${env.BUILD_NUMBER} .'
                }
            }
        }
        stage('Push to Docker Hub') {
            steps {
                script {
                    sh '''
                        echo ${DOCKER_HUB_CREDENTIALS_PSW} | docker login -u ${DOCKER_HUB_CREDENTIALS_USR} --password-stdin
                        docker push ${DOCKER_IMAGE}:${env.BUILD_NUMBER}
                    '''
                }
            }
        }
    }
}

