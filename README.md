
## Readme GitHub Actions - Pipeline

This document is intended to explain how to automate the  Build and Deployment of a Java applications using GitHub actions.

# Execution Methodology

1. Create the Application and copy to GitHub

	-	Login to the website https://start.spring.io/ and create an application with the below parameters.

                    Project		:	Maven
				language	:	Java
				Springboot	:	3.2.2
				Metadata		:	rak.example.com
				Packaging	:	jar
				Java			:	17
	-	Unzip the package and copy the files to the GitHub repository.
	
2. Write the Dockerfile to containarize the application.
	-	Use multi stage Docker file to reduce the image size and improve the security
	
				# Stage I
				FROM maven:3.8.5-openjdk-17-slim AS BUILD
				COPY pom.xml /tmp/
				COPY src /tmp/src/
				WORKDIR /tmp/
				RUN mvn package
				
				# Stage II
				FROM eclipse-temurin:17
				COPY --from=BUILD /tmp/target/rak-0.0.1-SNAPSHOT.jar /data/rak-0.0.1-SNAPSHOT.jar
				CMD ["java", "-jar", "/data/rak-0.0.1-SNAPSHOT.jar"]
				EXPOSE 8080
				
	-	Maven will build and package the application as executable (.jar) file using the provided application files in the stage I.
		The application will be listening on port 8080.
				
3. Configure GitHub actions for continuos integration
	-	To automate the build process and deployment configure gitHub Actions.
	-	Create a file .github/workflows/actions in the repository and declare the Buils and Deployment steps
	-  Declare the insensitive data as variables as below, Also do modification if necessary
	
				env:
					CONTAINER_REGISTRY: docker.io
					CONTAINER_IMAGE: samplerak
					REPOSITORY_NAME: sharon111edapal
					IMAGE_TAG: ${{ github.run_number }}
					AWS_REGION: ap-south-1
					
		Configure the sensitive data and AWS credetials as secrets under the project. 
				
                Repository --> Secrets & Variables --> Actions --> Repository Secrets
	
    -	Finally deploy the application into EKS with the below configuration
	
				   name: Deploy
						run: |
						aws eks update-kubeconfig --name rak-eks-cluster
						sed -i "s/latest/${{ env.IMAGE_TAG }}/" deployment.yaml
						kubectl apply -f deployment.yaml
						
	-	The deployment file will be creating the below resiurces
	
                    *	A new Aamespace - rak
				*	A Deployment with 1 replicaset 
				*	A NodePort service to expose the application (8080 --> 30000)
				
	-	Naviagate to Actions --> Docker Build --> RUn workflow to create a new run and validate the result.
				
4. Configure sonarqube for Code Analysis.

	-	Configure Sonarqube for codeanalysis on each pull request.
	-	Navigaet to https://sonarcloud.io/ website and create an Organization and Project.
	-	Integrate SonarCloud with Git repo and update pom.xml with sonar property.
	-	Create sonar.yml file under .github/workflows   directory and paste the auto generated content from the sonarCloud.
	-	After each pull reguest check the workflow runs under Actions --> SonalCloud
	
5. Access the application. 
    -	Get the public IP of the Node and access the Application via NodePort (eg : 10.0.1.34:30000)
 

