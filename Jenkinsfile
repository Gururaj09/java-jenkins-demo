pipeline {
    agent any
    
    tools {
        // Ensure you have configured a Maven installation named 'Maven' in Jenkins Global Tool Configuration
        maven 'Maven'
    }
    
    environment {
        // Replace with your actual Docker Hub username or credential ID
        DOCKER_CREDENTIALS_ID = 'docker-hub-credentials'
        IMAGE_NAME = 'gururajaharagi/java-jenkins-demo'
    }
    
    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }
        
        stage('Build and Test') {
            steps {
                // Compile code and execute JUnit tests
                sh 'mvn clean package'
            }
            post {
                always {
                    // Publish JUnit test results to Jenkins dashboard
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }
        
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    // Use the fully qualified plugin coordinates
                    sh 'mvn org.sonarsource.scanner.maven:sonar-maven-plugin:3.10.0.2594:sonar'
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image using the project's Dockerfile
                    app = docker.build("${IMAGE_NAME}:${env.BUILD_NUMBER}")
                }
            }
        }
        
        stage('Push to Docker Hub') {
            steps {
                script {
                    // Push the image using Jenkins credentials store
                    docker.withRegistry('https://registry.hub.docker.com', DOCKER_CREDENTIALS_ID) {
                        app.push("${env.BUILD_NUMBER}")
                        app.push("latest")
                    }
                }
            }
        }
    }
    
    post {
        success {
            echo 'Pipeline completed successfully! Docker image pushed to registry.'
        }
        failure {
            echo 'Pipeline failed. Check logs for details.'
        }
    }
}