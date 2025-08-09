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
              -Dsonar.host.url=http://35.170.192.171:30800 \
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
        nexusArtifactUploader(
          artifacts: [[
            artifactId: 'medicure',
            classifier: '',
            file: 'target/medicure-0.0.1-SNAPSHOT.jar',
            type: 'jar'
          ]],
          credentialsId: 'nexus-creds',
          groupId: 'com.project.staragile',
          nexusUrl: '54.88.56.91:30081',
          nexusVersion: 'nexus3',
          protocol: 'http',
          repository: 'maven-snapshots',
          version: '0.0.1-SNAPSHOT'
        )
      }
    }

  }
}


