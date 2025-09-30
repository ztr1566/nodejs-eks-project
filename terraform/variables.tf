variable "region" { default = "eu-west-3" }
variable "project_name" { default = "my-tf-project" }
variable "vpc_cidr" { default = "10.0.0.0/16" }
variable "public_subnet_cidr" { default = "10.0.1.0/24" }
variable "private_subnet_cidr" { default = "10.0.2.0/24" }
variable "my_ip" { description = "My public IP" }
variable "key_name" { description = "My key name" }
variable "instance_type" { default = "t3.micro" }
