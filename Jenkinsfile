pipeline {
    agent {
        docker { image 'fr-1vm-harbor01.infra.msv/domenic/mongo:5.0' }
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