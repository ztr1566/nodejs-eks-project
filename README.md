# AWS 2-Tier VPC Infrastructure with Terraform

This project provisions a secure, 2-tier cloud architecture on Amazon Web Services (AWS) using Terraform. The entire infrastructure is defined as code, following a modular design and best practices for reusability and maintainability.

---
## 🏛️ Architecture

This Terraform configuration deploys the following AWS resources to create a classic web/application-tier setup:

* **A dedicated Virtual Private Cloud (VPC)** to provide an isolated network environment.
* **Two Subnets:**
    * A **Public Subnet** for the web server (Nginx), accessible from the internet.
    * A **Private Subnet** for backend services (e.g., application server, database), completely isolated from direct internet access.
* **Networking Gateways:**
    * An **Internet Gateway** to allow internet traffic to and from the public subnet.
    * A **NAT Gateway** to allow instances in the private subnet to initiate outbound connections (e.g., for software updates) while remaining unreachable from the external internet.
* **Two EC2 Instances:**
    * A public-facing web server with Nginx automatically installed and configured via `user_data`.
    * A private backend server for internal application logic.
* **Security Groups** to act as virtual firewalls, controlling inbound and outbound traffic for the EC2 instances.



---

## 🛠️ Prerequisites

Before you begin, ensure you have the following tools installed and configured:

1.  [**Terraform**](https://developer.hashicorp.com/terraform/downloads) (v1.0 or later).
2.  [**AWS CLI**](https://aws.amazon.com/cli/) installed and configured with your credentials (`aws configure`).
3.  An **SSH Key Pair** already created in your AWS account in the target region.

---

## 📁 Project Structure

The project is organized into logical modules for better separation of concerns and reusability:

* `modules/vpc`: Creates the VPC.
* `modules/network`: Creates the subnets, gateways, and route tables.
* `modules/security`: Creates the security groups.
* `modules/ec2`: Creates the EC2 instances.

---

## 🚀 How to Deploy

1.  **Clone the Repository:**
    ```sh
    git clone <your-repository-url>
    cd terraform-aws-project
    ```

2.  **Create a Variables File:**
    Create a file named `terraform.tfvars` in the root directory. This file will contain your specific configuration values and is ignored by Git to protect sensitive information.
    ```tf
    # terraform.tfvars

    # Your home/office static IP to allow SSH access.
    my_ip = "YOUR_STATIC_IP/32"

    # The name of your existing EC2 Key Pair in AWS.
    key_name = "your-aws-key-name"
    ```

3.  **Initialize Terraform:**
    This command downloads the necessary provider plugins and modules.
    ```sh
    terraform init
    ```

4.  **Plan the Deployment:**
    This command creates an execution plan and shows you what resources will be created, modified, or destroyed. It's a good practice to review the plan before applying it.
    ```sh
    terraform plan
    ```

5.  **Apply the Configuration:**
    This command builds and deploys the resources on AWS.
    ```sh
    terraform apply
    ```
    Terraform will ask for confirmation. Type `yes` to proceed.

---

## 📤 Outputs

After the deployment is complete, Terraform will display the public IP address of the web server. You can also retrieve it at any time by running:
```sh
terraform output public_instance_ip
```
You can use this IP address to connect to the instance via SSH:
```sh
ssh -i "path/to/your-key.pem" ec2-user@<PUBLIC_IP_ADDRESS>
```

---

## 💣 How to Destroy

To tear down all the resources created by this project and avoid incurring further costs, simply run the following command:
```sh
terraform destroy
```