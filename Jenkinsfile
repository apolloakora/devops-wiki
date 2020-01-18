pipeline
{
    agent none
    stages
    {
        stage('Build Wiki Docker Image')
        {
            agent
            {
                kubernetes
                {
                    defaultContainer 'kaniko'
                    yamlFile 'pod-image-kaniko.yaml'
                }
            }
            steps
            {
                checkout scm
                sh '/kaniko/executor -f `pwd`/Dockerfile -c `pwd` --destination devops4me/devopswiki.co.uk:latest --cleanup'
            }
        }
        stage('Wiki Url Link Checking')
        {
            agent
            {
                kubernetes
                {
                    defaultContainer 'linkchecker'
                    yamlFile 'pod-image-verify.yaml'
                }
            }
            steps
            {
                sh 'wget https://www.devopswiki.co.uk'
                sh 'echo "sleeping for 30 seconds whilst our wiki wakes"'
                sh 'sleep 30'
                sh 'wget http://localhost:4567/'
                sh 'wget http://localhost:4567'
/*
Maybe there is no CONTAINER PORT 4567 any more but localhost works so
we are just downloading an error - when we learn the filename of this
download do a cat index.html3 (or whatever) to see what is being pulled down.
*/
                sh 'linkchecker http://localhost:4567/'
            }
        }
/*
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
                    sh 'rake install'
                    sh 'export SAFE_TTY_TOKEN=$(safe token) ; cucumber lib'
                }
            }
        }
        stage('Deploy to devopswiki.co.uk')
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
*/

    }
}
