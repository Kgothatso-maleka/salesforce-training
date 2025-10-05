#!groovy

pipeline {
    agent any

    environment {
        SF_USERNAME     = "malekak97406@agentforce.com"
        SF_CONSUMER_KEY = "3MVG9rZjd7MXFdLiS2SHokImLBVDhXCjp3nDDhrmZkXRZyNYJFNZKBBf_rzHrdBhH2wohoXJMLaOCNpV1mhkv"
        SF_JWT_KEY      = "407ebe89-78e4-4b27-a63f-680bdb860ddc"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'master', url: 'https://github.com/Kgothatso-maleka/salesforce-training.git'
            }
        }

        stage('Authenticate') {
            steps {
                sh '''
                echo "$SF_JWT_KEY" > server.key

                sf org login jwt \
                  --client-id $SF_CONSUMER_KEY \
                  --jwt-key-file server.key \
                  --username $SF_USERNAME \
                  --instance-url https://login.salesforce.com \
                  --alias TargetOrg
                '''
            }
        }

        stage('Code Quality Check') {
            steps {
                sh '''
                sf scanner run --target "force-app" --format table
                '''
            }
        }

        stage('Run Apex Tests') {
            steps {
                sh '''
                sf apex run test \
                  --wait 10 \
                  --code-coverage \
                  --result-format human \
                  --target-org TargetOrg
                '''
            }
        }

        stage('Deploy to Org') {
            steps {
                sh '''
                sf project deploy start \
                  --source-dir force-app \
                  --target-org TargetOrg \
                  --ignore-conflicts
                '''
            }
        }
    }

    post {
    always {
        script {
            junit 'test-results/test-result-*.xml'
        }
    }
}

}
