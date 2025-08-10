pipeline {
  agent any
     
  stages {
    stage('Git Checkout') {
      steps {
        echo 'This stage is to clone the repo from github'
        git branch: 'master', url: 'https://github.com/Vijaya150/star-agile-health-care.git'
                        }
            }
  
    stage('SonarQube Analysis') {
      steps {
        withCredentials([string(credentialsId: 'sonar-scanner', variable: 'token')]) {
          sh '''
            mvn clean verify sonar:sonar \
              -Dsonar.projectKey=sonar-analysis \
              -Dsonar.projectName=sonar-analysis \
              -Dsonar.host.url=http://54.147.195.218:30800 \
              -Dsonar.token=$token
          '''
          echo 'SonarQube analysis completed.'
        }
      }
    }
   stage('Build with maven') {
      steps {
          sh 'mvn clean install'
      }
    }

    stage('Upload Artifact to Nexus') {
  steps {
    withCredentials([usernamePassword(credentialsId: 'nexus-creds', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
      sh """
        curl -v -u $USERNAME:$PASSWORD \
          --upload-file target/medicure-0.0.1-SNAPSHOT.jar \
          http://13.220.201.91:30081/repository/maven-snapshots/com/project/staragile/medicure/0.0.1-SNAPSHOT/medicure-0.0.1-SNAPSHOT.jar
      """
    }
  }
}
    stage('Build Docker Image') {
  steps {
    sh 'docker build -t 13.220.201.91:30500/medicure:0.0.1-SNAPSHOT .'
  }
}


  }
}


