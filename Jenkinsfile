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
                sh '''
                if npm run | grep -q "build"; then
                  npm run build
                else
                  echo "No build step defined"
                fi
                '''
            }
        }

        stage('Test') {
            steps {
                echo 'Running tests...'
                sh '''
                if npm run | grep -q "test"; then
                  npm test
                else
                  echo "No test step defined"
                fi
                '''
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

