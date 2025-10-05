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
    image: node:24-alpine
    command: ["cat"]
    tty: true
  - name: kaniko
    image: gcr.io/kaniko-project/executor:debug
    command: ["cat"]
    tty: true
    volumeMounts:
    - name: docker-config
      mountPath: /kaniko/.docker
    - name: kaniko-cache-volume
      mountPath: /cache
  - name: deploy
    image: amazon/aws-cli:latest
    command: ["cat"]
    tty: true
  - name: trivy
    image: aquasec/trivy:latest
    command: ["cat"]
    tty: true
    volumeMounts:
    - name: docker-config
      mountPath: /home/jenkins/agent/.docker
  - name: snyk
    image: snyk/snyk:docker
    command: ["cat"]
    tty: true
  volumes:
  - name: docker-config
    secret:
      secretName: ecr-registry-secret
      items:
      - key: .dockerconfigjson
        path: config.json
  - name: kaniko-cache-volume
    emptyDir: {}
"""
        }
    }

    environment {
        AWS_ACCOUNT_ID = credentials('aws-account-id')
        AWS_REGION     = credentials('aws-region')
        ECR_REPOSITORY = 'nodejs-eks-app-repo'
    }

    stages {
        stage('Initialize') { 
            steps {
                checkout scm
                library identifier: 'internal-lib@main', retriever: legacySCM(scm)

                script {
                    env.IMAGE_URI = "${env.AWS_ACCOUNT_ID.trim()}.dkr.ecr.${env.AWS_REGION.trim()}.amazonaws.com/${env.ECR_REPOSITORY}:${env.GIT_COMMIT.take(7)}-${env.BUILD_NUMBER}"
                }
            }
        }

        stage('Security Scan: Code (SAST & SCA)') {
            steps {
                withCredentials([string(credentialsId: 'snyk-token', variable: 'SNYK_TOKEN')]) {
                    container('snyk') {
                        dir('app') {
                            echo "--- Running Snyk SCA (Dependency Scan) ---"
                            sh "snyk test --severity-threshold=high"

                            echo "--- Running Snyk SAST (Code Scan) ---"
                            sh "snyk code test --severity-threshold=high"
                        }
                    }
                }
            }
        }

        stage('Build & Test') {
            steps {
                runTests(appDir: 'app')
            }
        }

        stage('Build & Push Image') {
            steps {
                script {
                    def digestFileName = buildAndPush(
                        imageURI: env.IMAGE_URI,
                        dockerfile: 'app/Dockerfile',
                        context: 'app'
                    )
                    env.DIGEST_FILE_NAME = digestFileName
                }
            }
        }
        
       stage('Security Scan') {
            steps {
                container('trivy') {
                    withEnv(['DOCKER_CONFIG=/home/jenkins/agent/.docker']) {
                        script {
                            def imageDigest = readFile(env.DIGEST_FILE_NAME).trim()
                            def repositoryUri = IMAGE_URI.tokenize(':')[0]
                            def imageWithDigest = "${repositoryUri}@${imageDigest}"

                            echo "Scanning image with Trivy: ${imageWithDigest}"
                            sh "trivy image --exit-code 1 --severity HIGH,CRITICAL ${imageWithDigest}"
                        }
                    }
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                deployToEKS(
                    imageURI: env.IMAGE_URI,
                    manifestPath: 'kubernetes-manifests/deployment.yaml',
                    namespace: 'default'
                )
            }
        }
    }
}