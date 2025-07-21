pipeline {
  agent any
     tools {
       maven 'M2_HOME'
           }
     
  stages {
    stage('Git Checkout') {
      steps {
        echo 'This stage is to clone the repo from github'
        git branch: 'master', url: 'https://github.com/Vijaya150/star-agile-health-care.git'
                        }
            }
    stage('Build stage') {
      steps {
        echo 'This stage will compile, test, package my application'
        sh 'mvn clean install'
                          }
            }
    
     stage('Create Docker Image') {
      steps {
        echo 'This stage will Create a Docker image'
        sh 'docker build -t vijayadarshini/healthcare:1.0 .'
                          }
            }
     stage('Docker login & Push') {
    steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
            sh '''
                echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                docker push vijayadarshini/healthcare:1.0
            '''
            }
         }
     }
  
         stage('Deploy to k8s') {
        steps {
            withCredentials([file(credentialsId: 'kubeconfig-prod', variable: 'KUBECONFIG')]) {
            sh '''
            kubectl apply -f app-deploy.yml
            kubectl get svc'
            '''
      }
        }
         }
  }
}


