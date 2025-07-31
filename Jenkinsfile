pipeline {
  agent any
     
  tools {
        jdk 'Java_home'         // Name of JDK configured in "Global Tool Configuration"
        maven 'Maven'           // Name of Maven configured in "Global Tool Configuration"
        dockerTool 'Docker'  // Use this only if you configured Docker in Jenkins
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
            sh '''
            kubectl apply -f app-deploy.yml
            kubectl get svc
            '''
      }
        }
         }
  }
}


