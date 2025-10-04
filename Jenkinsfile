pipeline {
    agent {
        kubernetes {
            yaml """
apiVersion: v1
kind: Pod
spec:
  serviceAccountName: jenkins-agent 
  containers:
  - name: node
    image: node:22-alpine
    command:
    - cat
    tty: true
  - name: kaniko
    image: gcr.io/kaniko-project/executor:debug
    command:
    - cat
    tty: true
    volumeMounts:
    - name: docker-config
      mountPath: /kaniko/.docker
  - name: deploy
    image: amazon/aws-cli:latest
    command:
    - cat
    tty: true
  volumes:
  - name: docker-config
    secret:
      secretName: ecr-registry-secret
      items:
      - key: .dockerconfigjson
        path: config.json
"""
        }
    }

    environment {
        AWS_ACCOUNT_ID = credentials('aws-account-id')
        AWS_REGION     = credentials('aws-region')
        ECR_REPOSITORY = 'my-node-app-repo'
        IMAGE_URI = "${AWS_ACCOUNT_ID.trim()}.dkr.ecr.${AWS_REGION.trim()}.amazonaws.com/${ECR_REPOSITORY}:${env.GIT_COMMIT.take(7)}-${env.BUILD_NUMBER}"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Build & Test') {
            steps {
                container('node') {
                    dir('app') {
                        sh 'npm install'
                        sh 'npm run lint'
                    }
                }
            }
        }
        stage('Build & Push with Kaniko') {
            steps {
                container('kaniko') {
                    sh """
                    /kaniko/executor --dockerfile=app/Dockerfile --context=app --destination=${IMAGE_URI} --cache=true
                    """
                }
            }
        }


        stage('Deploy to EKS') {
            steps {
                container('deploy') {
                    script {
                        sh """
                        curl -o kubectl https://s3.us-west-2.amazonaws.com/amazon-eks/1.28.5/2024-01-04/bin/linux/amd64/kubectl
                        chmod +x ./kubectl
                        mv ./kubectl /usr/local/bin/

                        echo "Deploying image: ${IMAGE_URI}"
                        sed -i "s|zizoo1566/my-node-app:latest|${IMAGE_URI}|g" kubernetes-manifests/deployment.yaml
                        
                        kubectl apply -f kubernetes-manifests/deployment.yaml --namespace default
                        """
                    }
                }
            }
        }
    }
}