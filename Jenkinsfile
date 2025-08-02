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
        echo 'Cloning repository...'
        git branch: 'testbranch', url: 'https://github.com/Vijaya150/star-agile-health-care.git'
      }
    }

    stage('Deploy SonarQube to k8s') {
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
              -Dsonar.host.url=http://18.191.14.2:30900 \
              -Dsonar.token=$token
          '''
          echo 'SonarQube analysis completed.'
        }
      }
    }

    stage('Build with Maven') {
      steps {
        sh 'mvn clean install'
        echo 'Maven build completed.'
      }
    }

    stage('Deploy Nexus on k8s') {
      steps {
        withCredentials([file(credentialsId: 'kubeconfig-prod', variable: 'KUBECONFIG')]) {
          sh 'kubectl label node ip-172-31-9-59 workload=nexus --overwrite'
          sh 'kubectl apply -f nexus.yml'
        }
      }
    }

    stage('Upload Artifact to Nexus') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'nexus-creds', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
          sh 'mvn deploy --settings settings.xml'
        }
      }
    }
  }
}
