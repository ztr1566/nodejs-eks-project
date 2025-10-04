pipeline {
    agent any

    tools {
        nodejs 'nodejs-22'
    }

    environment {
        AWS_ACCOUNT_ID = credentials('aws-account-id')
        AWS_REGION     = credentials('aws-region')
        ECR_REPOSITORY = 'my-node-app'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build & Test') {
            steps {
                dir('app') {
                    sh 'npm install'
                    sh 'npm run lint'
                }
            }
        }

        stage('Build & Push to ECR') {
            steps {
                script {
                    def imageName = "${AWS_ACCOUNT_ID.trim()}.dkr.ecr.${AWS_REGION.trim()}.amazonaws.com/${ECR_REPOSITORY}:${env.GIT_COMMIT.take(7)}"
                    def customImage = docker.build(imageName, 'app')
                    docker.withRegistry("https://${AWS_ACCOUNT_ID.trim()}.dkr.ecr.${AWS_REGION.trim()}.amazonaws.com", "ecr:${AWS_REGION.trim()}:aws-credentials") {
                        customImage.push()
                    }
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                withKubeconfig('kubeconfig-file') {
                    script {
                        def imageName = "${AWS_ACCOUNT_ID.trim()}.dkr.ecr.${AWS_REGION.trim()}.amazonaws.com/${ECR_REPOSITORY}:${env.GIT_COMMIT.take(7)}"
                        echo "Deploying image: ${imageName}"
                        sh "sed -i 's|zizoo1566/my-node-app:latest|${imageName}|g' kubernetes-manifests/deployment.yaml"
                        sh "kubectl apply -f kubernetes-manifests/deployment.yaml"
                    }
                }
            }
        }
    }
}