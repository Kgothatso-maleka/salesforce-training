pipeline {
    agent any

    environment {
        SF_USERNAME = credentials('SF_USERNAME')
        SF_CONSUMER_KEY = credentials('SF_CONSUMER_KEY')
        PATH = "C:\\Program Files\\sf\\bin;${env.PATH}"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'master', url: 'https://github.com/Kgothatso-maleka/salesforce-training.git'
            }
        }

        stage('Authenticate') {
            steps {
                withCredentials([file(credentialsId: 'JWT_FILE', variable: 'JWT_FILE')]) {
                    bat """
                    sf org login jwt ^
                      --client-id "%SF_CONSUMER_KEY%" ^
                      --jwt-key-file "%JWT_FILE%" ^
                      --username "%SF_USERNAME%" ^
                      --instance-url https://login.salesforce.com ^
                      --alias TargetOrg
                    """
                }
            }
        }

        stage('Code Quality Check') {
            steps {
                bat """
                sf scanner run --target "force-app" --format table
                """
            }
        }

        stage('Run Apex Tests') {
            steps {
                bat """
                sf apex run test ^
                  --target-org TargetOrg ^
                  --result-format junit ^
                  --output-dir test-results ^
                  --wait 10
                """
            }
        }

        stage('Deploy to org') {
            steps {
                bat """
                sf project deploy start ^
                  --source-dir force-app ^
                  --target-org TargetOrg ^
                  --ignore-conflicts
                """
            }
        }
    }

    post {
        always {
            junit 'test-results/*.xml'
        }
    }
}
