# Node.js EKS Project 🚀

A comprehensive DevOps project demonstrating the deployment of a Node.js application on Amazon EKS using modern CI/CD practices, infrastructure as code, and container orchestration.

## 📋 Project Overview

This project showcases a complete DevOps pipeline for deploying a Node.js web application to Amazon EKS (Elastic Kubernetes Service). It integrates Express.js with EJS templating, MongoDB connectivity, and follows DevOps best practices including containerization, infrastructure automation, and continuous deployment.

## 🏗️ Architecture

The project follows a modern microservices architecture with:
- **Application Layer**: Node.js/Express.js application with EJS templating
- **Database**: MongoDB integration with Mongoose ODM  
- **Containerization**: Docker multi-stage builds for optimized images
- **Orchestration**: Kubernetes manifests for deployment and service management
- **Infrastructure**: Terraform for AWS resource provisioning
- **CI/CD**: Jenkins pipeline for automated testing, building, and deployment

## 🛠️ Technologies Stack

### Backend & Application
- **Node.js** - Runtime environment
- **Express.js 5.1.0** - Web framework
- **EJS** - Templating engine
- **Mongoose 8.18.1** - MongoDB object modeling
- **Moment.js** - Date manipulation

### DevOps & Infrastructure
- **Docker** - Containerization platform
- **Kubernetes** - Container orchestration
- **Amazon EKS** - Managed Kubernetes service
- **Terraform** - Infrastructure as Code
- **Jenkins** - CI/CD automation
- **ESLint** - Code quality and linting
- **Trivy** - Container security scanning
- **Amazon ECR** - Container registry

## 📁 Project Structure

```
├── app/                          # Node.js application
│   ├── src/                      # Source code
│   ├── views/                    # EJS templates
│   ├── public/                   # Static assets
│   ├── Dockerfile                # Container configuration
│   ├── package.json              # Node.js dependencies
│   └── eslint.config.js          # Linting configuration
├── kubernetes-manifests/         # K8s deployment files
│   ├── deployment.yaml           # Application deployment
│   ├── service.yaml              # Service configuration
│   ├── ingress.yaml              # Ingress controller
│   └── jenkins-rbac-cluster.yaml # Jenkins RBAC permissions
├── terraform/                    # Infrastructure as Code
│   ├── main.tf                   # Main Terraform configuration
│   ├── ecr.tf                    # ECR repository setup
│   ├── iam_github_actions.tf     # IAM roles for CI/CD
│   ├── variables.tf              # Input variables
│   ├── outputs.tf                # Output values
│   └── modules/                  # Terraform modules
├── vars/                         # Jenkins shared variables
├── .github/                      # GitHub workflows
├── Jenkinsfile                   # CI/CD pipeline configuration
└── README.md                     # This file
```

## 🚀 Getting Started

### Prerequisites
- **Node.js** (v18+ recommended)
- **Docker** & Docker Compose
- **kubectl** configured for EKS
- **AWS CLI** configured
- **Terraform** (v1.0+)
- **Jenkins** (for CI/CD)

### Local Development

1. **Clone the repository**
   ```bash
   git clone https://github.com/ztr1566/nodejs-eks-project.git
   cd nodejs-eks-project
   ```

2. **Install dependencies**
   ```bash
   cd app
   npm install
   ```

3. **Start development server**
   ```bash
   npm run watch    # With auto-restart
   # or
   npm start        # Standard start
   ```

4. **Run code linting**
   ```bash
   npm run lint
   ```

### Docker Deployment

1. **Build the application image**
   ```bash
   cd app
   docker build -t nodejs-eks-app .
   ```

2. **Run the container**
   ```bash
   docker run -p 3000:3000 nodejs-eks-app
   ```

## ☁️ AWS EKS Deployment

### Infrastructure Setup

1. **Initialize Terraform**
   ```bash
   cd terraform
   terraform init
   terraform plan
   terraform apply
   ```

2. **Configure kubectl for EKS**
   ```bash
   aws eks update-kubeconfig --region <region> --name <cluster-name>
   ```

### Kubernetes Deployment

1. **Deploy to EKS**
   ```bash
   kubectl apply -f kubernetes-manifests/
   ```

2. **Verify deployment**
   ```bash
   kubectl get pods
   kubectl get services
   kubectl get ingress
   ```

## 🔄 CI/CD Pipeline

The Jenkins pipeline automatically handles:
1. **Code Quality**: ESLint checks and code analysis
2. **Build**: Docker image creation with multi-stage builds
3. **Security Scan**: Container vulnerability scanning with Trivy
4. **Push**: Image push to Amazon ECR
5. **Deploy**: Automated deployment to EKS cluster
6. **Verify**: Health checks and deployment verification

### Pipeline Stages
- **Initialize**: Code checkout and library loading
- **Build & Test**: Dependency installation and testing
- **Build & Push Image**: Docker image build and ECR push
- **Security Scan**: Trivy vulnerability assessment
- **Deploy to EKS**: Kubernetes deployment execution

## 🔧 Configuration

### Environment Variables
- `PORT` - Application port (default: 3000)
- `MONGODB_URI` - MongoDB connection string
- `NODE_ENV` - Environment mode (development/production)
- `AWS_ACCOUNT_ID` - AWS account identifier
- `AWS_REGION` - AWS deployment region
- `ECR_REPOSITORY` - ECR repository name

### Jenkins Configuration
The pipeline uses Kubernetes agents with specialized containers:
- **Node.js container**: For application building and testing
- **Kaniko container**: For Docker image building without Docker daemon
- **AWS CLI container**: For AWS resource management
- **Trivy container**: For security vulnerability scanning

## 📊 Monitoring & Security

### Security Features
- **Container Security**: Non-root user execution in Docker
- **Vulnerability Scanning**: Automated Trivy security scans
- **RBAC**: Kubernetes role-based access control
- **Secret Management**: Kubernetes secrets for sensitive data
- **Network Policies**: Controlled pod-to-pod communication

### Monitoring & Logging
- **Health Checks**: Kubernetes liveness and readiness probes
- **Resource Monitoring**: CPU and memory usage tracking
- **Application Logs**: Centralized logging with CloudWatch
- **Deployment Status**: Real-time deployment monitoring

## 🚦 Testing & Quality

### Code Quality
- **ESLint**: JavaScript code linting and formatting
- **Automated Testing**: Comprehensive test suite execution
- **Code Coverage**: Test coverage reporting
- **Static Analysis**: Code quality metrics

### Container Security
- **Base Image Scanning**: Regular security updates
- **Dependency Checking**: Vulnerable package detection
- **Runtime Security**: Container behavior monitoring
- **Compliance Checks**: Security policy enforcement

## 📈 Performance Optimization

- **Multi-stage Docker Builds**: Optimized container size
- **Resource Limits**: CPU and memory constraints
- **Horizontal Scaling**: Pod auto-scaling configuration
- **Load Balancing**: Traffic distribution across pods
- **Caching Strategies**: Application-level caching

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the ISC License - see the [LICENSE](LICENSE) file for details.

## 👥 Author

**DevOps Engineer** - Specialized in cloud-native applications and container orchestration

## 🔗 Links

- **Repository**: https://github.com/ztr1566/nodejs-eks-project
- **Issues**: https://github.com/ztr1566/nodejs-eks-project/issues
- **Kubernetes Documentation**: https://kubernetes.io/docs/
- **Terraform AWS Provider**: https://registry.terraform.io/providers/hashicorp/aws/latest/docs
- **Jenkins Documentation**: https://www.jenkins.io/doc/

## 🙏 Acknowledgments

- Express.js community for the excellent web framework
- AWS for comprehensive cloud services and EKS
- Kubernetes community for container orchestration
- Jenkins for robust CI/CD automation
- HashiCorp for Terraform infrastructure as code
- Aqua Security for Trivy vulnerability scanner

---

*This project demonstrates modern DevOps practices including containerization, infrastructure as code, automated CI/CD pipelines, and cloud-native deployment strategies using industry-standard tools and best practices.*