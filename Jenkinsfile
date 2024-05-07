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
        sh 'scp -o StrictHostKeyChecking=no -i /var/lib/jenkins/.ssh/A4L.pem cicd-helloworld-webapp-latest.tar ec2-user@10.0.0.73:/home/ec2-user'
            }
        }

        stage('Unpack and Replace Docker Image - Run Container') {
            steps {
                // SSH to remote server and execute all commands
                script {
                    sshScript = '''
                if [ "$(docker ps -q)" ]; then docker stop $(docker ps -q); fi
                docker rm -f $(docker ps -aq) 2>/dev/null || true
                docker rmi cicd-helloworld-webapp:latest 2>/dev/null || true
                docker load -i /home/ec2-user/cicd-helloworld-webapp-latest.tar
                docker run -d -p 8200:8080 cicd-helloworld-webapp:latest
            '''
            sh "ssh -o StrictHostKeyChecking=no -i /var/lib/jenkins/.ssh/A4L.pem ec2-user@10.0.0.73 \"$sshScript\""
        }
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