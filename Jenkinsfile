node('docker') {
    checkout scmGit(branches: [[name: '*/master']],
    extensions: [submodule(recursiveSubmodules: true, reference: '')],
    userRemoteConfigs: [[
        credentialsId: 'app-jenkins-r7',
        url: 'https://gitlab.infra.msv/PFS/portail_canalplustelecom_mobile.git']])
}
