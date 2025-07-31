pipeline {
  agent any
     
  tools {
        jdk 'Java_home'         
        maven 'Maven'           
        dockerTool 'Docker'  
    }
  
  stages {
    stage('Git Checkout') {
      steps {
        echo 'This stage is to clone the repo from github'
        git branch: 'testbranch', url: 'https://github.com/Vijaya150/star-agile-health-care.git'
                        }
            }
  
         stage('Deploy to k8s') {
        steps {
            withCredentials([file(credentialsId: 'kubeconfig-prod', variable: 'KUBECONFIG')]) {
            sh 'kubectl apply -f sonarqube.yml'
      }
        }
         }
  }
}


