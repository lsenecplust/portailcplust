node('docker') {
    checkout scmGit(branches: [[name: '*/master']],
    extensions: [], 
    userRemoteConfigs: [[credentialsId: 'app-jenkins-r7',
    url: 'https://gitlab.infra.msv/PFS/portail_canalplustelecom_mobile.git'],
    [
        credentialsId: 'app-jenkins-r7',
        url: 'https://gitlab.infra.msv/PFS/dart/librairies.git']])
        {
            sh '''
            ls
            '''
        }
}
