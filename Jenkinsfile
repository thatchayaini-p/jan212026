pipeline {
    agent any

    stages {

        stage('Install Dependencies') {
            steps {
                sh '''
                npm install
                '''
            }
        }

        stage('Run App with PM2') {
            steps {
                sh '''
                /usr/local/bin/pm2 stop nodeapp || true
                /usr/local/bin/pm2 start app.js --name nodeapp
                '''
            }
        }
    }
}

