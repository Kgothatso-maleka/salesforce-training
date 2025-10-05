pipeline {
    agent any

    

    environment {
        // Environment variables for Salesforce org username
        SF_USERNAME = credentials('SF_USERNAME')  // Store your Salesforce username as secret text
    }

    stages {
        stage('Checkout Code') {
            steps {
                // Git checkout (credentials optional if repo is public)
                git branch: 'master', url: 'https://github.com/Kgothatso-maleka/salesforce-training.git'
            }
        }

        stage('Authenticate') {
            steps {
                node {
                    withCredentials([
                        string(credentialsId: 'SF_CONSUMER_KEY', variable: 'SF_CONSUMER_KEY'),
                        file(credentialsId: 'SF_JWT_KEY', variable: '407ebe89-78e4-4b27-a63f-680bdb860ddc')
                    ]) {
                        // Windows batch commands
                        bat """
                        echo %SF_JWT_KEY% > server.key
                        sf org login jwt ^
                          --client-id "%SF_CONSUMER_KEY%" ^
                          --jwt-key-file server.key ^
                          --username "%SF_USERNAME%" ^
                          --instance-url https://login.salesforce.com ^
                          --alias TargetOrg
                        """
                    }
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
                  --wait 10 ^
                  --code-coverage ^
                  --result-format human ^
                  --target-org TargetOrg
                """
            }
        }

        stage('Deploy to Org') {
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
            // Adjust path if your test results are generated elsewhere
            junit 'test-results/test-result-*.xml'
        }
    }
}
