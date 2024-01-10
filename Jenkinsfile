node('docker') {
    checkout scmGit(branches: [[name: '*/master']],
    extensions: [submodule(recursiveSubmodules: true, trackingSubmodules : true, parentCredentials :true)],
    userRemoteConfigs: [[
        credentialsId: 'app-jenkins-r7',
        url: 'https://gitlab.infra.msv/PFS/portail_canalplustelecom_mobile.git']]) 
            sh '''
                cd librairies
                ls
            '''
}