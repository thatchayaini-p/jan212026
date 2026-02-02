pipeline {
    agent any

    environment {
        NODE_ENV = 'production'
    }

    stages {

        stage('Install Dependencies') {
            steps {
                echo 'Installing npm dependencies...'
                sh 'npm install'
            }
        }

        stage('Build') {
            steps {
                echo 'Building the application...'
                // If you have a build step (like webpack, babel)
                sh 'npm run build || echo "No build step defined"'
            }
        }

        stage('Test') {
            steps {
                echo 'Running tests...'
                // Run your test suite, exit if any test fails
                sh 'npm test'
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying application with PM2...'
                sh '''
                /usr/local/bin/pm2 stop nodeapp || true
                /usr/local/bin/pm2 start app.js --name nodeapp
                /usr/local/bin/pm2 save
                '''
            }
        }
    }

    post {
        success {
            echo 'Deployment succeeded!'
        }
        failure {
            echo 'Deployment failed. Check the logs!'
        }
    }
}

