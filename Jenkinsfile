pipeline {
    agent any
    tools {
        maven 'M2_HOME'
    }

    stages {
        stage('Git Checkout') {
            steps {
                echo 'This stage is to clone the repo from github'
                git branch: 'master', url: 'https://github.com/Vijaya150/star-agile-health-care.git'
            }
        }

        stage('Create Package') {
            steps {
                echo 'This stage will compile, test, package my application'
                sh 'mvn package'
            }
        }

        stage('Generate Test Report') {
            steps {
                echo 'This stage generates a Test report using TestNG'
                publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: '/var/lib/jenkins/workspace/HealthcareProject/target/surefire-reports', reportFiles: 'index.html', reportName: 'HTML Report', reportTitles: '', useWrapperFileDirectly: true])
            }
        }

        stage('Create Docker Image') {
            steps {
                echo 'This stage will create a Docker image'
                sh 'docker build -t vijayadarshini/healthcare:1.0 .'
            }
        }

        stage('Login to Dockerhub') {
            steps {
                echo 'This stage will log into Dockerhub'
                withCredentials([usernamePassword(credentialsId: 'Docker-login', passwordVariable: 'dockerpass', usernameVariable: 'dockeruser')]) {
                    sh 'docker login -u ${dockeruser} -p ${dockerpass}'
                }
            }
        }

        stage('Docker Push-Image') {
            steps {
                echo 'This stage will push my new image to Dockerhub'
                sh 'docker push vijayadarshini/healthcare:1.0'
            }
        }
       stage('AWS-Login') {
    steps {
        echo 'Logging into AWS'
        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'AWS-ID']]) {
            sh '''
            export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
            export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
            '''
        }
    }
}

stage('Provision Test Environment') {
    steps {
        dir('terraform') {
            sh '''
            terraform init
            terraform apply -auto-approve
            '''
        }
    }
}
    }
}
