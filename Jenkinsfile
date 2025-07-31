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
            sh '''
            kubectl apply -f app-deploy.yml
            kubectl get svc
            '''
      }
        }
         }
    stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('ServerNameSonar') {
                    sh '''
                        mvn clean verify sonar:sonar \
                        -Dsonar.projectKey=sonar-analysis \
                        -Dsonar.projectName=sonar-analysis \
                        -Dsonar.host.url=http://16.16.167.86:9001/
                    '''
                    echo 'SonarQube Analysis Completed'
  }
}


