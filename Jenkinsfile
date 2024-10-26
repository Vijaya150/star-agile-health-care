pipeline {
    agent any

    tools {
        maven 'Maven'
    }

    stages {
        stage('Git Checkout') {
            steps {
                echo 'This stage is to clone the repo from GitHub'
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
                echo 'This stage generates Test report using TestNG'
                publishHTML([
                    allowMissing: false,
                    alwaysLinkToLastBuild: false,
                    keepAll: false,
                    reportDir: 'target/surefire-reports',
                    reportFiles: 'index.html',
                    reportName: 'HTML Report',
                    reportTitles: '',
                    useWrapperFileDirectly: true
                ])
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
                withCredentials([usernamePassword(credentialsId: 'dockerloginnew', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh "echo ${DOCKER_PASS} | docker login -u ${DOCKER_USER} --password-stdin"
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
                withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'Awsaccess', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    echo 'Logged into AWS'
                    // Add AWS commands here if needed
                }
            }
        }
       stage('Provision Infrastructure') {
         steps {
        dir('terraform') {  // Ensure this matches your actual Terraform directory
            withCredentials([[
                $class: 'AmazonWebServicesCredentialsBinding',
                credentialsId: 'your-aws-credentials-id'
            ]]) {
                sh '''
                    terraform init
                    terraform apply -auto-approve -var="AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" -var="AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY"
                '''
            }
        }
    }
}

    }
}




