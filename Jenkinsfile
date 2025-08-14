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
              -Dsonar.host.url=http://3.82.99.158:30800 \
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
          http://54.208.219.146:30081/repository/maven-snapshots/com/project/staragile/medicure/0.0.1-SNAPSHOT/medicure-0.0.1-SNAPSHOT.jar
      """
    }
  }
}
    stage('Build Docker Image') {
  steps {
    sh 'docker build -t medicure:latest .'
  }
}

stage('Tag and Push Docker Image to Nexus') {
  steps {
    withCredentials([usernamePassword(credentialsId: 'nexus-creds', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
      sh '''
        docker tag medicure:latest 54.208.219.146:30500/medicure:0.0.1-SNAPSHOT
        echo "$PASSWORD" | docker login 54.208.219.146:30500 -u "$USERNAME" --password-stdin
        docker push  54.208.219.146:30500/medicure:0.0.1-SNAPSHOT
      '''
    }
  }
}
 stage('Update GitOps Repo for Argo CD') {
  steps {
    withCredentials([string(credentialsId: 'github-token', variable: 'GITHUB_TOKEN')]) {
      script {
        def IMAGE_TAG = "0.0.1-${env.BUILD_NUMBER}"
        dir('star-agile-health-care') { deleteDir() }

        sh """
          git clone -b vijaya-dev https://$GITHUB_TOKEN@github.com/Vijaya150/star-agile-health-care.git
          cd star-agile-health-care
          sed -i 's|image:.*|image: 54.208.219.146:30500/medicure:${IMAGE_TAG}|' argocd/medicure.yml
          git config user.email "jenkins@ci"
          git config user.name "Jenkins CI"

          # Only commit and push if there are changes
          if ! git diff --quiet; then
            git commit -am "Update image tag to ${IMAGE_TAG}"
            git push origin vijaya-dev
          fi
        """
      }
    }
  }
}

}
  }
