pipeline {
    agent any
    environment {
        AWS_ACCOUNT_ID="933929260845"
        AWS_DEFAULT_REGION="us-east-2" 
        IMAGE_REPO_NAME="jenkis-pipeline"
        CLUSTER_NAME="ecs-jenkins"
        SERVICE_NAME="jenkins-service"
        TASK_DEFINITION_NAME="jenkins-td"
        DESIRED_COUNT="1"
        IMAGE_TAG="${env.BUILD_ID}"
        REPOSITORY_URI = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}"
        registryCredential = "aws-jenkins"
    }
   
    stages {
        
         stage('Logging into AWS ECR') {
            steps {
                script {   
                 sh "aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com"
                }
                 
            }
        }
        
        stage('Cloning Git') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: '', url: 'https://github.com/edgaroban/react-demo.git']]])     
            }
        }
  
    // Building Docker images
    stage('Building image') {
      steps{
        script {
             sh 'pwd'
                    sh 'ls -a'
                    sh 'cat Dockerfile'
            echo "${IMAGE_TAG} version tag" 
          dockerImage = docker.build "${IMAGE_REPO_NAME}:${IMAGE_TAG}"
        }
      }
    }
   
    // Uploading Docker images into AWS ECR
    stage('Pushing to ECR') {
     steps{  
         script {
               sh "docker tag ${IMAGE_REPO_NAME}:${IMAGE_TAG} ${REPOSITORY_URI}:$IMAGE_TAG"
               sh "docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}:${IMAGE_TAG}"
              //sh "docker push ${IMAGE_REPO_NAME}" 
         }
     }
    }
     stage('Deploy') {
     steps{
            withAWS(credentials: registryCredential, region: "${AWS_DEFAULT_REGION}") {
                script {
                    sh 'pwd'
                    sh 'ls -a'
                    sh 'cat Dockerfile'
                    sh "chmod +x -R ${env.WORKSPACE}"
			sh './script.sh'
                }
            } 
        }
      }      
      
    }
}