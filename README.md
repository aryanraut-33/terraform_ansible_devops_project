# Automated Web Deployment on AWS

### Using Terraform for Infrastructure Provisioning and Ansible for Server Configuration

---

## 📌 Project Overview

This project demonstrates how two widely-used DevOps tools — **Terraform** and **Ansible** — work together to automate the deployment of a simple website on **Amazon Web Services (AWS)**.

- **Terraform** handles the *infrastructure layer*: creating the cloud resources (VPC, subnets, security groups, and EC2 instances).
- **Ansible** handles the *configuration layer*: connecting to those servers, installing software (Nginx), and deploying the website files.

Two separate environments — **Development** and **Production** — are provisioned to illustrate how infrastructure and configuration can be managed across stages of a deployment pipeline.

---

## 🏗️ Architecture
![Project Architecture](image.png)

---

## 🔧 Tools & Technologies

| Tool           | Purpose                                       |
|----------------|-----------------------------------------------|
| **Terraform**  | Infrastructure as Code (IaC) — provisions AWS resources |
| **Ansible**    | Configuration Management — configures servers and deploys applications |
| **AWS EC2**    | Virtual servers hosting the website            |
| **AWS VPC**    | Isolated network environment for the infrastructure |
| **Nginx**      | Lightweight web server serving the static website |
| **Git/GitHub** | Version control and collaboration              |

---

## ⚙️ How It Works

The deployment workflow follows a clear two-phase approach:

### Phase 1 — Infrastructure Provisioning (Terraform)
Terraform reads the `.tf` configuration files and communicates with the AWS API to create:
- A **Virtual Private Cloud (VPC)** with a defined CIDR block
- Two **public subnets** (one for Dev, one for Prod)
- An **Internet Gateway** to allow public internet access
- A **Security Group** permitting SSH (port 22) and HTTP (port 80) traffic
- Two **EC2 instances** (Ubuntu) — one per environment

### Phase 2 — Server Configuration (Ansible)
Once the infrastructure is live, Ansible connects to the EC2 instances over SSH and:
- Updates system packages
- Installs and enables **Nginx**
- Deploys environment-specific website files (different content and styling for Dev vs Prod)

---

## 📁 Project Structure

```text
IA_Terraform_ansible/
├── terraform/              # Infrastructure as Code
│   ├── main.tf             # Provider, VPC, subnets, EC2, security group
│   ├── variables.tf        # Configurable input variables
│   └── outputs.tf          # Outputs (EC2 public IPs)
├── ansible/                # Configuration Management
│   ├── inventory.ini       # Target host definitions
│   └── site.yml            # Playbook for Nginx setup & deployment
├── files/                  # Static website source files
│   ├── dev/                # Dev environment website (HTML, CSS)
│   └── prod/               # Prod environment website (HTML, CSS)
├── .gitignore
└── README.md
```

---

## 🔄 Terraform vs Ansible — Comparison

| Aspect                    | Terraform                     | Ansible                        |
|---------------------------|-------------------------------|--------------------------------|
| **Primary Purpose**       | Infrastructure Provisioning   | Server Configuration           |
| **Language**              | HCL (HashiCorp Configuration Language) | YAML                  |
| **Approach**              | Declarative                   | Procedural (with declarative modules) |
| **State Management**      | Maintains state file (`.tfstate`) | Stateless (no state file)  |
| **Agent Requirement**     | Agentless (API-driven)        | Agentless (SSH-based)          |
| **Creates Cloud Resources** | ✅ Yes                       | ❌ Not designed for this       |
| **Installs Software**     | ❌ Not designed for this      | ✅ Yes                         |
| **Deploys Applications**  | ❌ Not designed for this      | ✅ Yes                         |
| **Idempotent**            | ✅ Yes                        | ✅ Yes                         |
| **Lifecycle Management**  | Create, update, destroy infra | Configure, deploy, maintain    |

### Key Takeaway
> Terraform and Ansible are **complementary**, not competing tools. Terraform excels at creating and managing cloud infrastructure, while Ansible excels at configuring servers and deploying applications. Together, they provide a complete automation pipeline from infrastructure provisioning to application delivery.

---

## 👥 Team

| Name                     | Role              |
|--------------------------|--------------------|
| Aryan Raut               | Developer          |

---

## 📄 License

This project is developed as part of an academic coursework submission for the **DevOps** course (Semester VII) at **K.J. Somaiya College of Engineering**.
