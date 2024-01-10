node('docker') {
    withCredentials([[$class: 'VaultUsernamePasswordCredentialBinding',
    credentialsId: 'app-jenkins-r7',
    passwordVariable: 'PASSWORD',
    usernameVariable: 'USERNAME']]) {
        git branch: 'master',
        url: 'git@gitlab.infra.msv:PFS/portail_canalplustelecom_mobile.git'
        sh '''
        ls
        '''
    }
}
