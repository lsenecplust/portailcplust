node('docker') {
    checkout scm: [
        $class: 'GitSCM',
        branches: [[name: '*/master']],
        userRemoteConfigs: [
            [
                credentialsId: 'app-jenkins-r7',
                url: 'https://gitlab.infra.msv/PFS/portail_canalplustelecom_mobile.git'
            ],
            [
                credentialsId: 'app-jenkins-r7',
                url: 'https://gitlab.infra.msv/PFS/dart/librairies.git'
            ]
        ]
    ]

    sh '''
        ls
    '''
}
