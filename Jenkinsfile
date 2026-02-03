pipeline {
    agent any

    environment {
        IMAGE_NAME      = "jan212026-node-app:latest"
        STABLE_IMAGE    = "jan212026-node-app:stable"
        CONTAINER_NAME  = "node-app-container"
        APP_PORT        = "3000"
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/thatchayaini-p/jan212026.git'
            }
        }

        stage('Tag Current Image as Stable') {
            steps {
                sh '''
                if docker image inspect $IMAGE_NAME > /dev/null 2>&1; then
                    docker tag $IMAGE_NAME $STABLE_IMAGE
                    echo "✅ Previous version saved as STABLE"
                else
                    echo "ℹ️ First deployment – no stable image"
                fi
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                docker build -t $IMAGE_NAME .
                '''
            }
        }

        stage('Deploy New Version') {
            steps {
                sh '''
                docker rm -f $CONTAINER_NAME || true
                docker run -d \
                  -p $APP_PORT:$APP_PORT \
                  --name $CONTAINER_NAME \
                  $IMAGE_NAME
                '''
            }
        }

        stage('Rollback Approval') {
            steps {
                script {
                    def decision = input(
                        message: '⚠️ Rollback needed?',
                        parameters: [
                            choice(
                                name: 'ROLLBACK',
                                choices: ['No', 'Yes'],
                                description: 'Rollback to previous stable version'
                            )
                        ]
                    )

                    if (decision == 'Yes') {
                        echo "🔁 Rolling back to STABLE image..."

                        sh '''
                        docker rm -f $CONTAINER_NAME || true
                        docker run -d \
                          -p $APP_PORT:$APP_PORT \
                          --name $CONTAINER_NAME \
                          $STABLE_IMAGE
                        '''
                    } else {
                        echo "✅ New version retained"
                    }
                }
            }
        }
    }

    post {
        success {
            echo "🎉 Deployment pipeline completed"
        }
        failure {
            echo "❌ Pipeline failed – check logs"
        }
    }
}

