node {
    properties([disableConcurrentBuilds(), [$class: 'GithubProjectProperty', displayName: 'Build', projectUrlStr: 'https://github.com/jameswoolfenden/packer-by-example']])

    parameters {
        string(name: 'AWS_REGION', defaultValue: 'eu-west-1', description: 'Specify the AWS Region')
        string(name: 'AWS_ROLE',  description: 'Specify the AWS ROLE')
        string(name: 'AWS_ACCOUNT', description: 'Specify the AWS ACCOUNT')
        string(name: 'ENVIRONMENT', description: 'Specify the AWS ACCOUNT Environment to create the AMI from')
        string(name: 'PACKFILE', description: 'Specify the json packer file to build')
    }

    wrap([$class: 'AnsiColorBuildWrapper', colorMapName: 'xterm']) {
        stage('Clear workspace') {
            step([$class: 'WsCleanup'])
        }

        try {
            sh("eval \$(aws ecr get-login --region eu-west-1 --no-include-email | sed 's|https://||')")
            stage('Pull') {
                checkout scm
            }
            docker.image('jenkins').inside('-v /var/lib/jenkins/.ssh:/var/lib/jenkins/.ssh -v /etc/passwd:/etc/passwd') {
                stage('Build AMI') {
                    sh '''cat <<EOM
                            -----------------------------------------------------------------------------------------------
                            | Build AMI                                                                   |
                            -----------------------------------------------------------------------------------------------
                            EOM'''
                    dir('packer') {
                        echo "AWS_REGION=${params.AWS_REGION} AWS_ROLE=${params.AWS_ROLE}  AWS_ACCOUNT=${params.AWS_ACCOUNT}"
                        sh "eval \$(iam_assume_role.sh ${params.AWS_ROLE} ${params.AWS_ACCOUNT}) && AWS_DEFAULT_REGION=${params.AWS_REGION} PACKFILE=${params.PACKFILE} ENVIRONMENT=${params.ENVIRONMENT} make base"
                    }
                }
            }
        } catch (error) {
            throw error
        }
    }
}
