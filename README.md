# 🚀 Enterprise DevSecOps Platform

[![Build Status](https://img.shields.io/badge/Build-Passing-brightgreen)](https://github.com/ztr1566/nodejs-eks-project)
[![Security](https://img.shields.io/badge/Security-Trivy%20%2B%20Snyk-blue)](https://github.com/ztr1566/nodejs-eks-project)
[![GitOps](https://img.shields.io/badge/GitOps-ArgoCD-orange)](https://github.com/ztr1566/nodejs-eks-project)
[![Infrastructure](https://img.shields.io/badge/Infrastructure-Terraform-purple)](https://github.com/ztr1566/nodejs-eks-project)
[![Container](https://img.shields.io/badge/Container-Docker-blue)](https://github.com/ztr1566/nodejs-eks-project)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-EKS-326ce5)](https://github.com/ztr1566/nodejs-eks-project)

A **production-ready Node.js application** showcasing enterprise-grade DevOps practices, security scanning, infrastructure as code, and GitOps deployment on Amazon EKS.

## 📋 Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Tech Stack](#tech-stack)
- [DevOps Pipeline](#devops-pipeline)
- [Security & Compliance](#security--compliance)
- [Infrastructure](#infrastructure)
- [GitOps Workflow](#gitops-workflow)
- [Getting Started](#getting-started)
- [Local Development](#local-development)
- [Deployment](#deployment)
- [Monitoring & Observability](#monitoring--observability)
- [Best Practices](#best-practices)
- [Contributing](#contributing)

## 🎯 Overview

This project demonstrates a complete **DevSecOps pipeline** for a Node.js web application with Express.js, MongoDB integration, and EJS templating. The application is containerized using multi-stage Docker builds and deployed to Amazon EKS using GitOps principles with ArgoCD.

### Key Features
- 🏗️ **Production-ready Node.js Express application**
- 🔒 **DevSecOps integration** with vulnerability scanning
- 🚢 **Multi-stage Docker containerization**
- ☁️ **AWS EKS deployment** with Terraform IaC
- 🔄 **GitOps continuous deployment** with ArgoCD
- 🛡️ **Security scanning** with Trivy and Snyk
- 📊 **Infrastructure monitoring** and observability
- 🔧 **Automated CI/CD** with Jenkins pipelines

## 🏗️ Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Developer     │───▶│   GitHub Repo   │───▶│   Jenkins CI    │
│   Git Push      │    │   Source Code   │    │   Pipeline      │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                                        │
                                                        ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   ArgoCD        │◀───│   Container     │◀───│   Security      │
│   GitOps        │    │   Registry      │    │   Scanning      │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                                              │
         ▼                                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                    Amazon EKS Cluster                          │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐            │
│  │   Node.js   │  │  MongoDB    │  │  Monitoring │            │
│  │   Pods      │  │  Atlas      │  │   Stack     │            │
│  └─────────────┘  └─────────────┘  └─────────────┘            │
└─────────────────────────────────────────────────────────────────┘
```

## 🛠️ Tech Stack

### Application Stack
- **Runtime**: Node.js 18+
- **Framework**: Express.js 5.x
- **Template Engine**: EJS
- **Database**: MongoDB Atlas
- **ODM**: Mongoose
- **Development**: Nodemon, LiveReload
- **Code Quality**: ESLint

### DevOps & Infrastructure
- **Containerization**: Docker (Multi-stage builds)
- **Orchestration**: Kubernetes (Amazon EKS)
- **Infrastructure as Code**: Terraform
- **CI/CD**: Jenkins with declarative pipelines
- **GitOps**: ArgoCD
- **Security Scanning**: 
  - **Trivy** - Container and filesystem vulnerability scanning
  - **Snyk** - Dependency vulnerability scanning
- **Container Registry**: Amazon ECR
- **Cloud Provider**: AWS

### Monitoring & Observability
- **Metrics**: Prometheus
- **Visualization**: Grafana
- **Logging**: ELK Stack / CloudWatch
- **Alerting**: Alertmanager

## 🔄 DevOps Pipeline

### CI/CD Workflow

1. **Code Commit** → Developer pushes code to GitHub
2. **Webhook Trigger** → Jenkins pipeline automatically triggered
3. **Security Scanning** → 
   - Snyk scans for dependency vulnerabilities
   - Trivy scans container images and filesystem
4. **Build & Test** → Application built and tested
5. **Containerization** → Multi-stage Docker build
6. **Push to Registry** → Image pushed to Amazon ECR
7. **GitOps Deployment** → ArgoCD syncs changes to EKS cluster
8. **Health Checks** → Application health verification

### Jenkins Pipeline Stages

```groovy
// Jenkinsfile highlights
stages {
    stage('Checkout') { /* Source code checkout */ }
    stage('Dependency Scan') { /* Snyk vulnerability scan */ }
    stage('Build') { /* Docker multi-stage build */ }
    stage('Security Scan') { /* Trivy container scan */ }
    stage('Push') { /* Push to ECR */ }
    stage('Deploy') { /* Update ArgoCD manifests */ }
    stage('Verify') { /* Health check verification */ }
}
```

## 🔒 Security & Compliance

### DevSecOps Implementation

#### Vulnerability Scanning
- **Snyk Integration**: 
  - Scans `package.json` for known vulnerabilities
  - Fails build on high-severity issues
  - Generates security reports
  - Monitors dependencies continuously

- **Trivy Security Scanner**:
  - Container image vulnerability scanning
  - Filesystem scanning for secrets
  - Compliance checks (CIS benchmarks)
  - Multi-format reporting (JSON, SARIF, Table)

#### Security Best Practices
- ✅ Non-root container execution
- ✅ Multi-stage Docker builds (reduced attack surface)
- ✅ Security context constraints in Kubernetes
- ✅ Network policies implementation
- ✅ Secret management with Kubernetes secrets
- ✅ Regular dependency updates
- ✅ Container image signing

### Automated Security Gates

```yaml
# Security pipeline gates
Security Checks:
  - Dependency vulnerabilities (Snyk)
  - Container image scanning (Trivy)
  - License compliance
  - Security policy validation
  - Secret detection
Threshold: Zero high-severity vulnerabilities
```

## 🏗️ Infrastructure

### Terraform Infrastructure as Code

The infrastructure is fully automated using Terraform with modular design:

```
terraform/
├── main.tf              # Main configuration
├── variables.tf         # Input variables
├── outputs.tf          # Output values
├── modules/
│   ├── eks/            # EKS cluster module
│   ├── vpc/            # VPC networking module
│   └── security/       # Security groups module
└── environments/
    ├── dev/            # Development environment
    ├── staging/        # Staging environment
    └── prod/           # Production environment
```

#### Infrastructure Components
- **Amazon EKS Cluster** with managed node groups
- **VPC** with public/private subnets across AZs
- **Internet Gateway** and NAT Gateways
- **Security Groups** with least privilege access
- **IAM Roles** with EKS service permissions
- **ECR Repository** for container images

## 🔄 GitOps Workflow

### ArgoCD Implementation

ArgoCD provides declarative, Git-based continuous deployment:

```
kubernetes-manifests/
├── base/
│   ├── deployment.yaml     # Application deployment
│   ├── service.yaml        # Service definition
│   ├── configmap.yaml      # Configuration
│   └── hpa.yaml           # Horizontal Pod Autoscaler
├── overlays/
│   ├── dev/               # Development overrides
│   ├── staging/           # Staging overrides
│   └── prod/              # Production overrides
└── argocd/
    └── application.yaml   # ArgoCD application definition
```

#### GitOps Benefits
- 🔄 **Automated Deployments**: Changes in Git trigger deployments
- 📊 **Observability**: Real-time deployment status
- 🔄 **Rollbacks**: Easy rollback to previous versions
- 🛡️ **Security**: Git-based audit trail
- 🎯 **Consistency**: Same deployment process across environments

## 🚀 Getting Started

### Prerequisites

- **Node.js** 18+ and npm
- **Docker** and Docker Compose
- **AWS CLI** configured
- **kubectl** for Kubernetes
- **Terraform** v1.0+
- **Jenkins** with required plugins
- **ArgoCD** installed on EKS cluster

### Quick Start

1. **Clone the repository**
   ```bash
   git clone https://github.com/ztr1566/nodejs-eks-project.git
   cd nodejs-eks-project
   ```

2. **Set up environment variables**
   ```bash
   cp .env.example .env
   # Edit .env with your MongoDB Atlas connection string
   ```

3. **Install dependencies**
   ```bash
   cd app
   npm install
   ```

4. **Run locally**
   ```bash
   npm start
   # Or for development with hot reload
   npm run watch
   ```

## 💻 Local Development

### Development Environment

```bash
# Start the application in development mode
npm run watch

# Run linting
npm run lint

# Build Docker image locally
docker build -t nodejs-eks-app:local ./app

# Run with Docker Compose
docker-compose up
```

### Code Quality

- **ESLint**: Enforces coding standards
- **Nodemon**: Auto-restart on file changes
- **LiveReload**: Browser auto-refresh during development

## 🚢 Deployment

### Infrastructure Deployment

1. **Initialize Terraform**
   ```bash
   cd terraform
   terraform init
   terraform plan -var-file="environments/dev/terraform.tfvars"
   terraform apply
   ```

2. **Deploy ArgoCD**
   ```bash
   kubectl create namespace argocd
   kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
   ```

3. **Configure GitOps Application**
   ```bash
   kubectl apply -f kubernetes-manifests/argocd/application.yaml
   ```

### Automated Deployment

Deployments are triggered automatically when code is pushed to the main branch:

1. **Jenkins Pipeline** → Builds and tests
2. **Security Scanning** → Validates security
3. **Container Build** → Creates optimized image
4. **ArgoCD Sync** → Deploys to EKS cluster

## 📊 Monitoring & Observability

### Metrics and Monitoring

- **Application Metrics**: Custom Prometheus metrics
- **Infrastructure Metrics**: Node and pod metrics
- **Business Metrics**: Request latency, error rates
- **Dashboards**: Grafana dashboards for visualization

### Health Checks

- **Liveness Probe**: `/health` endpoint
- **Readiness Probe**: Database connectivity check
- **Startup Probe**: Application initialization

### Alerting Rules

```yaml
Alerts:
  - High CPU usage (>80%)
  - Memory usage (>90%)
  - Application errors (>5%)
  - Database connection failures
  - Security vulnerabilities detected
```

## ✨ Best Practices

### DevOps Best Practices Implemented

- ✅ **Infrastructure as Code** (Terraform)
- ✅ **Immutable Infrastructure** (Container-based)
- ✅ **GitOps Deployment** (ArgoCD)
- ✅ **Security Scanning** (Trivy + Snyk)
- ✅ **Multi-stage Docker Builds**
- ✅ **Automated Testing** (Unit + Integration)
- ✅ **Configuration Management** (ConfigMaps/Secrets)
- ✅ **Monitoring & Alerting** (Prometheus/Grafana)
- ✅ **Horizontal Pod Autoscaling**
- ✅ **Rolling Deployments** with health checks
- ✅ **Resource Limits** and requests
- ✅ **Network Policies** for security
- ✅ **Backup & Disaster Recovery**

### Security Best Practices

- 🔒 **Principle of Least Privilege**
- 🔒 **Secret Management** (Kubernetes secrets)
- 🔒 **Network Segmentation**
- 🔒 **Container Security** (non-root, readonly)
- 🔒 **Vulnerability Management**
- 🔒 **Compliance Scanning**
- 🔒 **Audit Logging**

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. **Fork the repository**
2. **Create a feature branch** (`git checkout -b feature/amazing-feature`)
3. **Commit changes** (`git commit -m 'Add amazing feature'`)
4. **Push to branch** (`git push origin feature/amazing-feature`)
5. **Open a Pull Request**

### Development Guidelines

- Follow ESLint configuration
- Write tests for new features
- Update documentation
- Ensure security scans pass
- Verify deployments work in dev environment

## 📄 License

This project is licensed under the ISC License - see the [LICENSE](LICENSE) file for details.

## 📞 Contact

**Project Maintainer**: [ztr1566](https://github.com/ztr1566)

**Project Link**: [https://github.com/ztr1566/nodejs-eks-project](https://github.com/ztr1566/nodejs-eks-project)

---

## 🏆 Project Highlights

This project showcases:
- 🎯 **Production-Ready Architecture** with enterprise standards
- 🔒 **DevSecOps Integration** with automated security scanning
- ☁️ **Cloud-Native Deployment** on AWS EKS
- 🔄 **GitOps Workflow** with ArgoCD
- 📊 **Comprehensive Monitoring** and observability
- 🛡️ **Security-First Approach** with multiple scanning tools
- 🚀 **Automated CI/CD Pipeline** with Jenkins
- 📈 **Scalable Infrastructure** with auto-scaling capabilities

**Built by ztr1566 | DevOps Engineer & Backend Developer**
