# **Very Simple AWS Terraform Project**

This repository contains Infrastructure-as-Code (IaC) scripts written in **Terraform** to deploy a scalable and secure AWS architecture. The project is designed to showcase the use of Terraform for automating cloud infrastructure provisioning. It provides a robust setup for deploying a web application with essential AWS services.

---

## **Features of the Project**

The project includes the following components:

### **1. Virtual Private Cloud (VPC)**
- Creates a logically isolated network for resources.
- Includes private and public subnets for secure and efficient architecture.

### **2. EC2 Instances**
- Private instances host the web application.
- A bastion host (jump server) in the public subnet for secure access to instances in private subnets.

### **3. Networking**
- NAT Gateway to enable outbound internet access from private subnets.
- Internet Gateway (IGW) for public subnet connectivity.
- Routing tables for traffic flow between subnets.

### **4. Auto Scaling Group (ASG)**
- Automatically adjusts the number of EC2 instances based on demand.
- Ensures high availability and scalability.

### **5. S3 Bucket**
- Configured for document storage.
- IAM roles and policies for secure access control.

### **6. IAM Roles**
- Configured for secure access to AWS resources.
- Allows EC2 instances to interact with AWS services securely.

---

## **Project Logic**

To understand the logic of the project, watch the following video:
[**Project Logic Explanation**](https://www.youtube.com/watch?v=uHGwSAEOcNQ&list=PLZmPGUyBFvUo6rHIVCFgJd87Fm8S2S0qo)

---

## **Deployment Guide**

Learn how to deploy this project on the AWS portal by following the video guide:
[**How to Deploy on AWS**](https://www.youtube.com/watch?v=WwoxnIy9seQ&ab_channel=kodEdge)

---

## **Prerequisites**

Before deploying the project, ensure the following:
- **Terraform Installed**: Download Terraform from [Terraform Official Website](https://www.terraform.io/).
- **AWS CLI Installed**: Set up and configure the AWS CLI.
- **Git Installed**: Clone this repository and push changes if needed.
- **AWS Credentials Configured**: Provide access keys for Terraform to interact with AWS.
- **Note**: The access key, secret key and key pair are hashed, please replace them with your own

---
Step 2: Initialize Terraform

Step 3: Apply Terraform Configuration

Step 4: Verify Resources in AWS Console
Check the AWS Management Console to ensure all resources are deployed correctly.


## **Getting Started**

### **Step 1: Clone the Repository**
```bash
git clone https://github.com/Safandy/very-simple-AWS-Terraform-project.git
cd very-simple-AWS-Terraform-project
