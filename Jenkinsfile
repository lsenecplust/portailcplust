node('docker') {
    withCredentials([[$class: 'VaultUsernamePasswordCredentialBinding',
    passwordVariable: 'PASSWORD',
    usernameVariable: 'USERNAME']]) {
        git branch: 'master',
        credentialsId: 'app-jenkins-r7',
        url: 'https://gitlab.infra.msv/PFS/portail_canalplustelecom_mobile.git'
        sh '''
        ls
        '''
    }
}
