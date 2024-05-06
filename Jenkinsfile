pipeline {
    agent any
    
    stages {
        stage('Checkout') {
            steps {
                // Checkout your source code repository
                git branch: 'develop', url: 'https://github.com/djoksa4/CICD-helloworld-webapp.git'
            }
        }
        
        stage('Build') {
            steps {
                // Use Maven to compile the Java web application
                sh 'mvn clean package'
            }
        }

        stage('Build Docker Image') {
            steps {
                // Build the Docker image using the provided Dockerfile
                script {
                    docker.build("cicd-helloworld-webapp:latest")
                }
            }
        }

        stage('Save Docker Image Locally') {
            steps {
        // Save Docker image as a tar file
        sh 'docker save -o cicd-helloworld-webapp-latest.tar cicd-helloworld-webapp:latest'
            }
        }

        stage('Copy Docker Image to Remote Server') {
            steps {
        // Copy Docker image to remote server using scp with key-based authentication
        sh 'sudo scp -o StrictHostKeyChecking=no -i /home/ec2-user/.ssh/A4L.pem cicd-helloworld-webapp-latest.tar ec2-user@10.0.0.73:/home/ec2-user'
            }
        }

        stage('Unpack Docker Image') {
            steps {
                sh 'ssh -o StrictHostKeyChecking=no -i /home/ec2-user/.ssh/A4L.pem ec2-user@10.0.0.73 "docker load -i /home/ec2-user/cicd-helloworld-webapp-latest.tar"'
            }
        }
    }
    
    post {
        success {
            // Archive the .war file as an artifact
            archiveArtifacts 'target/*.war'
        }
    }
}


