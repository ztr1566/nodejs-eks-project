# Comprehensive Summary: The Journey of Building and Deploying a Node.js Application on EKS (Still Progress)

## Introduction

This document summarizes the complete phases of building and deploying a modern cloud infrastructure for a Node.js application using a powerful suite of DevOps and Cloud tools. The goal was to simulate a real-world project lifecycle, from building the foundation to automated deployment.

## Phase 1: Building the Foundation (Infrastructure as Code with Terraform)

### What we did
We started by building the core infrastructure on AWS. Using Terraform, we created an isolated network (VPC) containing public and private subnets, internet gateways, and security groups (Security Groups).

### Why we did it
Instead of manual setup, we used the Infrastructure as Code (IaC) principle. This made the build process automated, repeatable, and versionable by storing the code in Git. We later organized the code into professional Modules for easy maintenance.

### The most important problem we faced and its solution
**Problem:** When building the EKS Cluster, we encountered complex dependency errors (Invalid for_each) within the official EKS module, which prevented Terraform from completing the plan.

**Solution:** We learned the importance of Decoupling. We separated the creation of the EKS control plane from the creation of the worker nodes into two distinct steps. This simplified the dependencies and enabled Terraform to build each part in the correct order, providing a professional and permanent solution.

## Phase 2: Containerizing the Application (Containerization with Docker) 📦

### What we did
We wrote a professional Dockerfile using Multi-stage builds to package our Node.js application into a Container.

### Why we did it
To solve the "it works on my machine!" problem. A container ensures the application runs in an identical environment everywhere, eliminating compatibility issues and making it ready for large-scale operation.

### The most important problem we faced and its solution
**Problem:** The application was running but without CSS, JavaScript, or views.

**Solution:** We discovered that the Project Structure was not standard. We organized the application's folders (src, views, public) in the correct way that Express.js expects and modified the code to serve static assets.

## Phase 3: Fleet Management (Orchestration with Kubernetes)

### What we did
We used Terraform to build a managed Kubernetes platform with Amazon EKS. We then wrote Kubernetes Manifests (Deployment, Service, Ingress) to describe how to run our container, provide it with an internal network, and expose it to the internet via an Application Load Balancer (ALB).

### Why we did it
To run our application at scale. Kubernetes automates deployment, scaling, and load balancing. Most importantly, it provides Self-healing; if a container crashes, Kubernetes automatically restarts it.

### The most important problem we faced and its solution
**Problem:** The Ingress was not creating a Load Balancer, and its address was not appearing.

**Solution:** We performed a complete troubleshooting process:
- We verified the IngressClass
- We ensured the correct Tags were on the Subnets (requiring two public subnets)
- We inspected the Logs of the aws-load-balancer-controller

The logs revealed the final, true error: *OperationNotPermitted: This AWS account currently does not support creating load balancers*. The issue was an AWS account-level restriction, not a code problem.

## Immediate Next Steps (After the Account Issue is Resolved)

Once AWS support lifts the restriction on your account, your steps will be simple and direct:

1. **Rebuild the Infrastructure:** Run `terraform apply` to rebuild everything (VPC, EKS, IAM Roles)
2. **Connect kubectl to the Cluster:** Run the command output by Terraform to update your kubeconfig file
3. **Deploy the Application:** Run `kubectl apply -f kubernetes-manifests/` to deploy the application to EKS
4. **Monitor and Verify:** Watch the Ingress status with `kubectl get ingress -w`. Within minutes, the Load Balancer address should appear

## Future Plans and Project Enhancements

The project now represents a strong foundation. To enhance it further, we can add:

### Full Automation (CI/CD Pipeline)
- **Using GitHub Actions:** Build a workflow that automatically builds the Docker image, pushes it to ECR, and deploys it to EKS on every git push
- **Using Jenkins:** Build the same pipeline but with Jenkins, which would require us to use Terraform and Ansible again to build and configure a Jenkins server

### Monitoring & Observability
Use tools like Prometheus and Grafana to collect detailed metrics on application and cluster performance, creating dashboards and alerts.

### Security Hardening
- Integrate tools for Image Scanning to check Docker images for vulnerabilities
- Use a service like AWS Secrets Manager for centralized and more secure password management
