pipeline {
    agent any

    options {
        skipDefaultCheckout(true)
    }

    environment {
        APP_DIR     = "${WORKSPACE}/nodeapp"
        BACKUP_DIR  = "${WORKSPACE}/nodeapp_backup"
        PM2_APP     = "nodeapp"
        NODE_ENV    = "production"
        PORT        = "3000"
    }

    stages {

        stage('Checkout Code') {
            steps {
                sh '''
                rm -rf $APP_DIR
                git clone -b main https://github.com/thatchayaini-p/jan212026.git $APP_DIR
                '''
            }
        }

        stage('Backup Current Version') {
            steps {
                sh '''
                if [ -d "$APP_DIR" ]; then
                    rm -rf $BACKUP_DIR
                    cp -r $APP_DIR $BACKUP_DIR
                    echo "Backup created"
                else
                    echo "First deployment – no backup"
                fi
                '''
            }
        }

        stage('Install Dependencies') {
            steps {
                sh '''
                cd $APP_DIR
                npm install
                '''
            }
        }

        stage('Build App (Optional)') {
            steps {
                sh '''
                cd $APP_DIR
                npm run build || echo "No build script found"
                '''
            }
        }

        stage('Deploy on Port 3000') {
            steps {
                sh '''
                cd $APP_DIR
                echo "PORT=3000" > .env
                echo "NODE_ENV=production" >> .env

                pm2 delete $PM2_APP || true
                pm2 start app.js --name $PM2_APP --update-env
                pm2 save
                pm2 flush
                '''
            }
        }

        stage('Rollback Approval') {
            steps {
                script {
                    def decision = input(
                        message: 'Rollback to previous version?',
                        parameters: [
                            choice(
                                name: 'ROLLBACK',
                                choices: ['No', 'Yes'],
                                description: 'Rollback using backup'
                            )
                        ]
                    )

                    if (decision == 'Yes') {
                        sh '''
                        pm2 delete $PM2_APP || true
                        rm -rf $APP_DIR
                        cp -r $BACKUP_DIR $APP_DIR
                        cd $APP_DIR
                        npm install
                        pm2 start app.js --name $PM2_APP --update-env
                        pm2 save
                        pm2 flush
                        '''
                    } else {
                        echo "Deployment confirmed"
                    }
                }
            }
        }
    }

    post {
        success {
            echo "Node.js app running successfully on PORT 3000"
        }
        failure {
            echo "Deployment failed"
        }
    }
}

