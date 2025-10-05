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
  - name: trivy
    image: aquasec/trivy:latest
    command: ["cat"]
    tty: true
  - name: grype   # <<< إضافة الكونتينر الجديد
    image: anchore/grype:latest
    command: ["sleep", "infinity"]
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
        ECR_REPOSITORY = 'nodejs-eks-app-repo'
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
                script {
                    def digestFileName = buildAndPush(
                        imageURI: IMAGE_URI,
                        dockerfile: 'app/Dockerfile',
                        context: 'app'
                    )
                    env.DIGEST_FILE_NAME = digestFileName
                }
            }
        }
        
        stage('Security Scan (Grype)') { // <<< مرحلة الفحص باستخدام Grype
            steps {
                container('grype') {
                    // نستخدم نفس طريقة الـ digest المضمونة
                    script {
                        def imageDigest = readFile(env.DIGEST_FILE_PATH).trim()
                        def repositoryUri = IMAGE_URI.tokenize(':')[0]
                        def imageWithDigest = "${repositoryUri}@${imageDigest}"
                        
                        echo "Scanning image with Grype: ${imageWithDigest}"
                        
                        sh "grype ${imageWithDigest} --fail-on high"
                    }
                }
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