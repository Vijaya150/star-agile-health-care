pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "vijayadarshini/medicure-app:1.0"
        KUBE_CONTEXT = "my-kubernetes-context"
        DOCKER_REGISTRY = 'https://index.docker.io/v1/'
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/Vijaya150/star-agile-health-care.git'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Test') {
            steps {
                junit 'target/surefire-reports/*.xml'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Make sure dockerhub-credentials exists in Jenkins
                    docker.withRegistry(DOCKER_REGISTRY, 'dockerhub-credentials') {
                        sh "docker build -t ${DOCKER_IMAGE} ."
                        sh "docker push ${DOCKER_IMAGE}"
                    }
                }
            }
        }

        stage('Provision Infrastructure with Terraform') {
            steps {
                script {
                    // Using withCredentials to pass AWS credentials
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', 
                                     accessKeyVariable: 'AWS_ACCESS_KEY_ID', 
                                     secretKeyVariable: 'AWS_SECRET_ACCESS_KEY', 
                                     credentialsId: 'AWS-ID']]) {
                        dir('terraform') {
                            sh 'terraform init'
                            sh 'terraform apply -auto-approve -var="aws_access_key_id=${AWS_ACCESS_KEY_ID}" -var="aws_secret_access_key=${AWS_SECRET_ACCESS_KEY}"'
                        }
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    sh "kubectl --context=${KUBE_CONTEXT} apply -f k8s/deployment.yml"
                    sh "kubectl --context=${KUBE_CONTEXT} apply -f k8s/service.yml"
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}

