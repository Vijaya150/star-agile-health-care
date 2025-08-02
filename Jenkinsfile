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
        echo 'This stage is to clone the repo from GitHub'
        git branch: 'testbranch', url: 'https://github.com/Vijaya150/star-agile-health-care.git'
      }
    }
    stage('Deploy sonarqube to k8s') {
        steps {
            withCredentials([file(credentialsId: 'kubeconfig-prod', variable: 'KUBECONFIG')]) {
            sh 'kubectl apply -f pv-pvc.yml'
            sh 'kubectl apply -f sonarqube.yml'
            }
        }
    }

    stage('SonarQube Analysis') {
      steps {
        withCredentials([string(credentialsId: 'sonar-scanner', variable: 'token')]) {
          sh '''
            mvn clean verify sonar:sonar \
              -Dsonar.projectKey=sonar-analysis \
              -Dsonar.projectName=sonar-analysis \
              -Dsonar.host.url=http://18.191.14.2:30900\
              -Dsonar.token=$token
          '''
          echo 'SonarQube Analysis Completed'
        }
      }
    }
  
  stage('Build with maven') {
    steps {
      sh 'mvn clean install'
       echo 'Maven Build Completed'
    }
  }
stage('Nexus to k8s') {
        steps {
            withCredentials([file(credentialsId: 'kubeconfig-prod', variable: 'KUBECONFIG')]) {
            sh 'kubectl label node ip-172-31-9-59 workload=nexus'
            sh 'kubectl apply -f nexus.yml'
            }
        }
    }
stage('Upload Artifact to Nexus') {
  steps {
    withCredentials([usernamePassword(credentialsId: 'nexus-creds', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
      sh """
        mvn deploy \
          -DaltDeploymentRepository=nexus-ci::default::http://3.135.195.40:30801/repository/maven-ci-releases/ \
          -Dnexus.username=$USERNAME \
          -Dnexus.password=$PASSWORD
      """
    }
  }
}

  }
}
