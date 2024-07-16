0. Pipeline overview:

    - GitHub repo contains JAVA WebApp, Jenkinsfile, pom.xml file and a Dockerfile.
    - Jenkins pipeline described in the Jenkinsfile runs on every push to the GitHub repo (using Webhook).
    - pipeline clones the repo locally.
    - pipeline builds a WAR archive package using Maven (configured in the pom.xml).
    - pipeline builds a Docker image (based on Tomcat image) containing the built WAR package using the Dockerfile. 
    - Docker image is saved and copied over to the “live” remote server.
    - older versions of the image and running containers are stopped / removed on the “live” remote server.
    - new container is spun up using the new Docker image (continuous deployment).



1. Created and configured demo environments on AWS using Terraform:

    - Network (VPC, subnets, IGW, Route Table) setup.
    - Instances:
    - Linux EC2 instance for Jenkins.
    - Linux EC2 instance mimicking a “live” remote server where the app should be deployed.
    - assigned fixed private IP addresses to Instances.
    - created and assigned appropriate Security Groups for Instances: 
    - opening ports for SSH / HTTP ingress access to Instances, 
    - and inter-Instance communication.
    - opening ports for egress communication (to setup Jenkins, etc).



2. Confgured launched instances (using Terraform user_data):

    - on Linux “live” remote server instance (using Bash):
        - installed Docker, configured Docker service.
        - added the instance user to the docker group (to be able to run Docker commands).

    - on Linux Jenkins instance (using Bash):
        - installed Jenkins and set the service to run automatically.
        - installed Java, Git, Maven.
        - created the private key (for inter-instance communication).
        - gave Jenkins ownership on the key, set permissions.



3. Confgured Jenkins:

    - configured Jenkins setup - plugins, node monitors, GitHub Webhook.
    - configured the pipeline to run on GitHub change and use the Jenkinsfile from it to define the pipeline
