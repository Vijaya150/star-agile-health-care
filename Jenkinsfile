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
              -Dsonar.host.url=http://18.191.218.84:30900 \
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
       stage('Deploy Nexus to k8s') {
      steps {
        withCredentials([file(credentialsId: 'kubeconfig-prod', variable: 'KUBECONFIG')]) {
          sh 'kubectl apply -f nexus.yml'
    }
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
          nexusUrl: '3.147.68.3:30081',
          nexusVersion: 'nexus3',
          protocol: 'http',
          repository: 'maven-snapshots',
          version: '0.0.1-SNAPSHOT'
        )
      }
    }

    stage('Download Artifact from Nexus') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'nexus-creds', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
          sh '''
            curl -u $USERNAME:$PASSWORD \
            -o medicure-0.0.1-SNAPSHOT.jar \
            http://3.147.68.3:30081/repository/maven-snapshots/com/project/staragile/medicure/0.0.1-SNAPSHOT/medicure-0.0.1-SNAPSHOT.jar
          '''
        }
      }
    }

    stage('Build Docker Image') {
  steps {
    sh 'docker build -t medicure:0.0.1-SNAPSHOT .'
  }
}

    stage('Push Docker Image to Nexus') {
  steps {
    withCredentials([usernamePassword(credentialsId: 'nexus-creds', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
      sh '''
        echo "$PASSWORD" | docker login 3.147.68.3:30500 -u "$USERNAME" --password-stdin
        docker tag medicure:0.0.1-SNAPSHOT 3.147.68.3:30500/docker-hosted/medicure:0.0.1-SNAPSHOT
        docker push 3.147.68.3:30500/docker-hosted/medicure:0.0.1-SNAPSHOT
      '''
    }
  }
}

    }
}
