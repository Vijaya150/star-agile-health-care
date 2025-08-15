pipeline {
    agent any

    environment {
        SONARQUBE_SERVER = "http://44.202.13.37:30800"
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
                          -Dsonar.token=$token
                    '''
                }
                echo 'SonarQube analysis completed.'
            }
        }

        stage('Retrieve Last 5 Sonar Reports') {
    steps {
        withCredentials([usernamePassword(credentialsId: 'sonar-admin', usernameVariable: 'SONAR_USER', passwordVariable: 'SONAR_PASS')]) {
            echo "Fetching last 5 SonarQube analyses..."
            sh """
                curl -s -u \$SONAR_USER:\$SONAR_PASS "${SONARQUBE_SERVER}/api/project_analyses/search?project=sonar-analysis" \
                | jq '.analyses | sort_by(.date) | reverse | .[0:5]' > sonar_last_5.json
            """
        }
        echo "Saved last 5 analyses to sonar_last_5.json"
    }
}
      stage('Build with Maven') {
    steps {
        sh 'mvn clean package -DskipTests'
    }
}

pipeline {
    agent any

    environment {
        SONARQUBE_SERVER = "http://44.202.13.37:30800"
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
                          -Dsonar.token=$token
                    '''
                }
                echo 'SonarQube analysis completed.'
            }
        }

        stage('Retrieve Last 5 Sonar Reports') {
    steps {
        withCredentials([usernamePassword(credentialsId: 'sonar-admin', usernameVariable: 'SONAR_USER', passwordVariable: 'SONAR_PASS')]) {
            echo "Fetching last 5 SonarQube analyses..."
            sh """
                curl -s -u \$SONAR_USER:\$SONAR_PASS "${SONARQUBE_SERVER}/api/project_analyses/search?project=sonar-analysis" \
                | jq '.analyses | sort_by(.date) | reverse | .[0:5]' > sonar_last_5.json
            """
        }
        echo "Saved last 5 analyses to sonar_last_5.json"
    }
}
      stage('Build with Maven') {
    steps {
        sh 'mvn clean package -DskipTests'
    }
}

stage('Deploy to Nexus') {
    steps {
        withCredentials([usernamePassword(
            credentialsId: 'nexus-creds',
            usernameVariable: 'USERNAME',
            passwordVariable: 'PASSWORD'
        )]) {
            sh """
                mvn deploy -DskipTests \
                  -DaltDeploymentRepository=nexus::default::http://$USERNAME:$PASSWORD@100.26.183.71:30081/repository/maven-snapshots
            """
        }
    }
}

    }
}

    }
}
        
