pipeline
{
    agent none
    stages
    {
        stage('Build Safe Docker Image')
        {
            agent
            {
                kubernetes
                {
                    defaultContainer 'kaniko'
                    yamlFile 'pod-image-builder.yaml'
                }
            }
            steps
            {
                checkout scm
                sh '/kaniko/executor -f `pwd`/Dockerfile -c `pwd` --destination devops4me/safetty:latest --cleanup'
            }
        }
/*
        stage('Reek Static Code Analysis')
        {
            agent
            {
                kubernetes
                {
                    yamlFile 'pod-image-safetty.yaml'
                }
            }
            steps
            {
                container('safettytests')
                {
                    sh 'reek lib || true'
                }
            }
        }
*/
        stage('Cucumber Aruba Tests')
        {
            agent
            {
                kubernetes
                {
                    yamlFile 'pod-image-safetty.yaml'
                }
            }
            steps
            {
                container('safettytests')
                {
                    checkout scm
                    sh 'ls -lah'
                    sh 'ls -lah lib'

/*
                    sh 'chown -R safeci:safeci /home/safeci'
*/

                    sh 'rake install'
                    sh 'export SAFE_TTY_TOKEN=$(safe token) ; cucumber lib'
                }
            }
        }
        stage('Release to RubyGems.org')
        {
            agent
            {
                kubernetes
                {
                    yamlFile 'pod-image-release.yaml'
                }
            }
            when {  environment name: 'GIT_BRANCH', value: 'origin/master' }
            steps
            {
                container('safedeploy')
                {
                    checkout scm
                    sh 'git status'
                    sh 'git remote -v'
                    sh 'git config --global user.email apolloakora@gmail.com'
                    sh 'git config --global user.name "Apollo Akora"'
                    sh 'gem bump minor --tag --push --release --file=$PWD/lib/version.rb'
                }
            }
        }
    }
}
