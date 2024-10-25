pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "vijayadarshini/medicure-app:1.0"
        KUBE_CONTEXT = "my-kubernetes-context"
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
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-credentials') {
                        sh "docker build -t ${DOCKER_IMAGE} ."
                        sh "docker push ${DOCKER_IMAGE}"
                    }
                    }
                }
            }
        }

        stage('Provision Infrastructure with Terraform') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve'
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
