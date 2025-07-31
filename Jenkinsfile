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

    stage('SonarQube Analysis') {
      steps {
        withCredentials([string(credentialsId: 'sonar-scanner', variable: 'token')]) {
          sh """
            mvn clean verify sonar:sonar \
              -Dsonar.projectKey=sonar-analysis \
              -Dsonar.projectName=sonar-analysis \
              -Dsonar.host.url=http://18.118.144.205:30900 \
              -Dsonar.token=$token
          """
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
  }
    }
