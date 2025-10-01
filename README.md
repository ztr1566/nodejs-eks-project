# 🏛️ Architecture

This project provisions a secure and scalable 2-tier architecture on AWS:

- **Networking Layer:** A custom VPC with public and private subnets across two Availability Zones for high availability.
- **Orchestration Layer:** An Amazon EKS cluster with managed node groups running in the private subnets.
- **Application Layer:** The Node.js application, containerized with Docker, runs in Pods managed by a Kubernetes Deployment.
- **Exposure Layer:** An AWS Application Load Balancer (ALB) is automatically provisioned by the AWS Load Balancer Controller to expose the application to the internet via a Kubernetes Ingress.
- **Database:** The application is configured to connect to a MongoDB Atlas cluster (managed externally).

## ✨ Features

- **Infrastructure as Code (IaC):** The entire AWS infrastructure is defined and managed with Terraform.
- **Containerized:** The Node.js application is packaged into a lightweight, portable Docker image using multi-stage builds.
- **Orchestrated:** Deployed on Kubernetes for high availability, self-healing, and scalability.
- **Modular & Organized:** The project is structured with separate folders for the application (`app`), infrastructure (`terraform`), and Kubernetes configuration (`kubernetes-manifests`).
- **Secure:** Uses private subnets for worker nodes, IAM Roles for Service Accounts (IRSA) for secure permissions, and Kubernetes Secrets for database credentials.

## 🛠️ Prerequisites

Before you begin, ensure you have the following tools installed and configured:

- Terraform (v1.0+)
- AWS CLI (configured with your credentials via `aws configure`)
- Docker
- kubectl
- Helm

## 📁 Project Structure

```
.
├── app/                    # Node.js application source code and Dockerfile
├── terraform/              # All Terraform code (modules, main files)
├── kubernetes-manifests/   # Kubernetes YAML files (Deployment, Service, Ingress)
└── README.md               # This file
```

## 🚀 Deployment Steps

**Note:** These steps assume you have already created the necessary infrastructure by following the project's tutorial. The `terraform/` directory should contain a complete and working configuration.

### 1. Build and Push the Docker Image

After provisioning the infrastructure with Terraform, you must build your application's Docker image and push it to the Amazon ECR repository that was created.

**Get the ECR repository URL from Terraform output:**

```
cd terraform
terraform output ecr_repository_url
```

**Log in to ECR:**

```
aws ecr get-login-password --region <your-region> | docker login --username AWS --password-stdin <your-aws-account-id>.dkr.ecr.<your-region>.amazonaws.com
```

**Build, Tag, and Push the image (from the root project directory):**

```
# Build
docker build -t my-node-app ./app

# Tag
docker tag my-node-app:latest <PASTE_ECR_REPOSITORY_URL_HERE>:latest

# Push
docker push <PASTE_ECR_REPOSITORY_URL_HERE>:latest
```

### 2. Update Kubernetes Manifests

Before deploying, you must update the `deployment.yml` file to use your new ECR image.

- Open `kubernetes-manifests/deployment.yml`.
- Find the `image:` line and replace the placeholder with the full ECR repository URL.

### 3. Configure kubectl

Run the command output by Terraform to connect kubectl to your EKS cluster.

```
# Run from the terraform/ directory
terraform output configure_kubectl_command

# Copy and run the outputted 'aws eks update-kubeconfig ...' command
```

### 4. Create the Database Secret

Create a Kubernetes Secret to securely store your MongoDB Atlas connection string.

```
kubectl create secret generic mongodb-secret --from-literal=MONGO_URI='<YOUR_MONGODB_ATLAS_URI>'
```

### 5. Deploy the Application to EKS

Apply the Kubernetes manifests to deploy your application.

```
# Run from the root project directory
kubectl apply -f kubernetes-manifests/
```

## 🌐 Accessing the Application

It will take 2-5 minutes for the AWS Load Balancer to be provisioned. You can watch its status:

```
kubectl get ingress -w
```

Once the `ADDRESS` field is populated, copy the DNS name and paste it into your web browser.

## 💣 Destroying the Infrastructure

To avoid ongoing costs, destroy all resources.

**Delete the Kubernetes resources:**

```
kubectl delete -f kubernetes-manifests/
```

**Destroy the AWS infrastructure:**

```
cd terraform
terraform destroy
```

## ⚠️ Important Note: AWS Account Limits

Some new AWS accounts have a default restriction that prevents the creation of Application Load Balancers, resulting in an `OperationNotPermitted` error in the AWS Load Balancer Controller logs. If your Ingress address does not appear after several minutes and troubleshooting, you will need to contact AWS Support and request that this service limit be lifted from your account.
```

You can now select all the text above (from the first triple backtick + "markdown" to the last triple backtick) and copy it as a single block. This is the complete formatted README file ready to paste directly into your README.md file.[5][11][12][13]
