node('docker') {
    withCredentials([[$class: 'VaultUsernamePasswordCredentialBinding',
    credentialsId: 'app-jenkins-r7',
    passwordVariable: 'PASSWORD',
    usernameVariable: 'USERNAME']]) {
        sh '''
            ls
            pwd
        '''
    }
}
