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
                    echo "✅ Backup created"
                else
                    echo "ℹ️ First deployment – no backup"
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
                if npm run | grep -q "build"; then
                    npm run build
                else
                    echo "ℹ️ No build script"
                fi
                '''
            }
        }

        stage('Deploy New Version') {
            steps {
                sh '''
                pm2 stop $PM2_APP || true
                pm2 start $APP_DIR/app.js --name $PM2_APP
                pm2 save
                '''
            }
        }

        stage('Rollback Approval') {
            steps {
                script {
                    def decision = input(
                        message: '⚠️ Rollback to previous version?',
                        parameters: [
                            choice(
                                name: 'ROLLBACK',
                                choices: ['No', 'Yes'],
                                description: 'Rollback using backup'
                            )
                        ]
                    )

                    if (decision == 'Yes') {
                        echo "🔁 Rolling back..."

                        sh '''
                        pm2 stop $PM2_APP || true
                        rm -rf $APP_DIR
                        cp -r $BACKUP_DIR $APP_DIR
                        pm2 start $APP_DIR/app.js --name $PM2_APP
                        pm2 save
                        '''
                    } else {
                        echo "✅ Deployment confirmed"
                    }
                }
            }
        }
    }

    post {
        success {
            echo "🎉 Node.js deployment successful"
        }
        failure {
            echo "❌ Deployment failed – rollback available"
        }
    }
}

