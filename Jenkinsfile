node('docker') {
    withCredentials([[
        $class: 'VaultUsernamePasswordCredentialBinding',
        credentialsId: 'app-jenkins-r7',
        passwordVariable: 'PASSWORD',
        usernameVariable: 'USERNAME'
    ]]) {
        checkout([
            $class: 'GitSCM',
            branches: [[name: 'master']],
            doGenerateSubmoduleConfigurations: false,
            extensions: [[$class: 'SubmoduleOption', recursiveSubmodules: true]],
            submoduleCfg: [],
            userRemoteConfigs: [[
                credentialsId: 'app-jenkins-r7',
                url: 'git@gitlab.infra.msv:PFS/portail_canalplustelecom_mobile.git'
            ]]
        ])
    }
}
