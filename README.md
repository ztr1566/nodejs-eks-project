# AWS 2-Tier VPC Infrastructure with Terraform (Project still in progress, I will update it soon)

This project provisions a secure, 2-tier cloud architecture on Amazon Web Services (AWS) using Terraform. The entire infrastructure is defined as code, following a modular design and best practices for Infrastructure as Code (IaC).

This project uses **HashiCorp Vault** to manage sensitive or configurable data, such as the AMI ID, preventing it from being hardcoded in the main configuration.

---
## 🏛️ Architecture

This Terraform configuration deploys the following AWS resources:

* **A dedicated Virtual Private Cloud (VPC)** to provide an isolated network environment.
* **Two Subnets:**
    * A **Public Subnet** for the web server (Nginx), accessible from the internet.
    * A **Private Subnet** for backend services (e.g., application server, database), completely isolated from direct internet access.
* **Networking Gateways:**
    * An **Internet Gateway** to allow internet traffic to and from the public subnet.
    * A **NAT Gateway** to allow instances in the private subnet to initiate outbound connections (e.g., for software updates).
* **Two EC2 Instances:**
    * A public-facing web server with Nginx automatically installed via `user_data`.
    * A private backend server for internal application logic.
* **Security Groups** to act as virtual firewalls, controlling inbound and outbound traffic.



---

## 🛠️ Prerequisites

Before you begin, ensure you have the following tools installed and configured:

1.  [**Terraform**](https://developer.hashicorp.com/terraform/downloads) (v1.0 or later).
2.  [**AWS CLI**](https://aws.amazon.com/cli/) installed and configured with your credentials (`aws configure`).
3.  [**HashiCorp Vault**](https://developer.hashicorp.com/vault/downloads) installed.
4.  An **SSH Key Pair** already created in your AWS account in the target region.

---

## 🚀 How to Deploy

Follow these steps to provision the infrastructure.

### Step 1: Clone the Repository
```sh
git clone <your-repository-url>
cd terraform-aws-project
```

### Step 2: Start and Configure Vault
For this project, you can run a local Vault server in development mode.

1.  **Start the Vault Server:**
    Open a **separate terminal** and run the following command. Keep this terminal open.
    ```sh
    vault server -dev
    ```
    Vault will start and print out an **Unseal Key** and a **Root Token**. You will need the **Root Token** for the next step.

2.  **Set Environment Variables:**
    In your **original terminal** (where you cloned the project), set the following environment variables. Terraform will use these to authenticate with Vault.
    ```sh
    export VAULT_ADDR='[http://127.0.0.1:8200](http://127.0.0.1:8200)'
    export VAULT_TOKEN='<paste_the_root_token_here>'
    ```

3.  **Store the AMI ID in Vault:**
    Run the following command to store the Amazon Linux 2023 AMI ID that Terraform will use.
    ```sh
    # Note: You may need to verify this is the latest AL2023 AMI for your target region.
    vault kv put secret/aws/ami ami_id="ami-0c55b159cbfafe1f0"
    ```

### Step 3: Create a Variables File
Create a file named `terraform.tfvars` in the root directory. This file will contain your specific configuration values and is ignored by Git.
```tf
# terraform.tfvars

# Your home/office static IP to allow SSH access.
my_ip = "YOUR_STATIC_IP/32"

# The name of your existing EC2 Key Pair in AWS.
key_name = "your-aws-key-name"
```

### Step 4: Initialize Terraform
This command downloads the necessary provider plugins (for both AWS and Vault) and modules.
```sh
terraform init
```

### Step 5: Plan the Deployment
Review the execution plan to see what resources will be created.
```sh
terraform plan
```

### Step 6: Apply the Configuration
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