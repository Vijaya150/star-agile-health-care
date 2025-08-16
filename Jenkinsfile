pipeline {
    agent any

    environment {
        SONARQUBE_SERVER = "http://44.202.13.37:30800"
        DOCKER_REGISTRY = "100.26.183.71:30091"  // NodePort for Docker registry
        IMAGE_NAME = "medicure-app"
        IMAGE_TAG = "0.0.1"
    }

    stages {

        stage('Git Checkout') {
            steps {
                echo 'Cloning the repo from GitHub...'
                git branch: 'master', url: 'https://github.com/Vijaya150/star-agile-health-care.git'
            }
        }

       stage('SonarQube Analysis') {
    steps {
        withCredentials([string(credentialsId: 'sonar-scanner', variable: 'token')]) {
            echo "Running SonarQube analysis..."
            sh '''
                mvn clean verify sonar:sonar \
                  -Dsonar.projectKey=sonar-analysis \
                  -Dsonar.projectName=sonar-analysis \
                  -Dsonar.host.url=${SONARQUBE_SERVER} \
                  -Dsonar.token=$token \
                  -Dsonar.projectVersion=${BUILD_NUMBER}
            '''
        }
        echo 'SonarQube analysis completed.'
    }
}
        stage('Build with Maven') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Upload Artifact to Nexus') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'nexus-creds', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    sh """
                        curl -u $USERNAME:$PASSWORD \
                          --upload-file target/medicure-0.0.1-SNAPSHOT.jar \
                          http://100.26.183.71:30081/repository/maven-snapshots/com/project/staragile/medicure/0.0.1-SNAPSHOT/medicure-0.0.1-SNAPSHOT.jar
                    """
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t $IMAGE_NAME:$IMAGE_TAG ."
            }
        }

        stage('Tag & Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'nexus-creds', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    sh """
                        docker tag $IMAGE_NAME:$IMAGE_TAG $DOCKER_REGISTRY/$IMAGE_NAME:$IMAGE_TAG
                        echo $PASSWORD | docker login $DOCKER_REGISTRY -u $USERNAME --password-stdin
                        docker push $DOCKER_REGISTRY/$IMAGE_NAME:$IMAGE_TAG
                    """
                }
            }
        }
        stage('Update K8s Manifests for ArgoCD') {
    steps {
        deleteDir() // clean workspace
        withCredentials([usernamePassword(credentialsId: 'k8s-git-creds', usernameVariable: 'GIT_USER', passwordVariable: 'GIT_PASS')]) {
            sh """
                git clone https://$GIT_USER:$GIT_PASS@github.com/Vijaya150/star-agile-health-care.git
                cd star-agile-health-care
                git checkout gitops-manifests
                sed -i 's|image: .*|image: 100.26.183.71:30091/medicure-app:${IMAGE_TAG}|' argocd/medicure-deploy.yml
                git config user.name "Vijaya150"
                git config user.email "vijayadarshini1503@gmail.com"
                git add argocd/medicure-deploy.yml
                git commit -m "Update image to ${IMAGE_TAG} from Jenkins build #${BUILD_NUMBER}"
                git push origin gitops-manifests
            """
        }
    }
}

        }
}
