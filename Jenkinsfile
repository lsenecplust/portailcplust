pipeline {
    agent {
        docker { image 'node:18.18.0-alpine3.18' }
    }
    stages {
        stage('Install') {
            steps {
                sh 'npm install'
            }
        }
        stage('Build') {
            steps {
                sh 'npm run build'
            }
        }
        stage('Test') {
            steps {
                sh 'Username is $LOGIN_CREDS_USR'
                sh 'npm run test'
            }
        }
    }
}