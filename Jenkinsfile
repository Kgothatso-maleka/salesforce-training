#!groovy

pipeline {
	agent any

		
	environment {
		SF_USERNAME = credentials('SF_USERNAME')
		SF_CONSUMER_KEY = credentials('SF_CONSUMER_KEY')
		SF_JWT_KEY = credentials('407ebe89-78e4-4b27-a63f-680bdb860ddc')
	}
	
	stages {
		stage('Checkout Code'){
			steps {
				git branch: 'master', url: 'https://github.com/Kgothatso-maleka/salesforce-training.git'
			}
		}
		
		stage('Authenticate'){
			steps {
				bat """
				echo "$SF_JWT_KEY" > server.key
				
				sf org login jwt ^
				 --client_id "%SF_CONSUMER_KEY%" ^
				 --jwt-key-file "%SF_JWT_KEY%" ^
				 --username "%SF_USERNAME%" ^
				 --instance-url https://login.salesforce.com ^
				 --alias TargetOrg
                 """
			}
		}
		
		stage('Code Quality Check'){
			steps {
				sh '''
				sf scanner run --target "force-app" --format table
			}
		}
		
		stage('Run Apex Tests'){
			steps {
				sh '''
			sf apex run test \
				--wait 10 \
				--code-coverage \ 
				--result-format human \
				--target-org TargetOrg
			}
			
		}
		
		stage('Deploy to org'){
			steps {
				sh '''
				sf project deploy start \
					--source-dir force-app \
					--target-org TargetOrg \ 
					--ignore-conflicts
				
			}
		}
	}
	
	post {
	 always {
		junit 'test-results/test-result-*.xml'
	 }
	}
}
