# AWS VPC PEERING
# **This is ReadMe process for creating resources with Terraform**
## _This repository contains the configuaration files for create two VPCs in two differents region in the same account, then realize a peering of both vpcs and launch an Amazon Linux 2 EC2 instance in two private subnets of each vpcs and test the link.

---
To create an infrastructure on AWS using Terraform you must follow these steps: 
- Create the configuration file with extention .tf then save it in a loacal folder
- Initialize the folder by typing the CLI command 'terraform init'
* Validate the code with command 'terraform validate'
* View all resources created with the commad 'terraform plan'
- build the resource with thecommand 'terraform apply'

---
The configuration file is structured:
- Creation of the terraform block: Choose the provider
- Enter the provider: AWS
- Creation of the resource : VPCs, subnets, route tables, IGW, NatGateway, vpc peering, route of peering, EC2s
- Testing of the connection between both vpcs

 This project is maintain by : Joseph Mbatchou