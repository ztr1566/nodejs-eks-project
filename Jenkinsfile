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
    command: ["cat"]
    tty: true
  - name: kaniko
    image: gcr.io/kaniko-project/executor:debug
    command: ["cat"]
    tty: true
    volumeMounts:
    - name: docker-config
      mountPath: /kaniko/.docker
  - name: deploy
    image: amazon/aws-cli:latest
    command: ["cat"]
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
        stage('Initialize') { 
            steps {
                checkout scm
                library identifier: 'internal-lib@main', retriever: legacySCM(scm)
            }
        }

        stage('Build & Test') {
            steps {
                runTests(appDir: 'app')
            }
        }

        stage('Build & Push Image') {
            steps {
                buildAndPush(
                    imageURI: IMAGE_URI,
                    dockerfile: 'app/Dockerfile',
                    context: 'app'
                )
            }
        }

        stage('Deploy to EKS') {
            steps {
                deployToEKS(
                    imageURI: IMAGE_URI,
                    manifestPath: 'kubernetes-manifests/deployment.yaml',
                    namespace: 'default'
                )
            }
        }
    }
}