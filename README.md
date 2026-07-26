# CloudHelp Azure Platform

## Overview

CloudHelp is a fictional Software-as-a-Service (SaaS) company that provides a cloud-based help desk platform for small and medium-sized businesses.

This repository documents the infrastructure used to host the CloudHelp platform in Microsoft Azure. The project is being built incrementally using Infrastructure as Code (IaC) and follows engineering best practices, with each new capability added as the project evolves.

The primary goal of this repository is to demonstrate practical Azure and DevOps skills, including Terraform, Git, GitHub Actions, Azure services, automation, monitoring and documentation.

---

## Project Goals

- Build a realistic Azure environment using Terraform.
- Follow Infrastructure as Code best practices.
- Learn DevOps by developing one production-style project over time.
- Demonstrate version control using Git and GitHub.
- Implement CI/CD using GitHub Actions.
- Produce professional documentation and architecture diagrams.

---

## Technology Stack

### Cloud

- Microsoft Azure

### Infrastructure as Code

- Terraform

### DevOps

- Git
- GitHub
- GitHub Actions

### Scripting

- Azure CLI
- PowerShell

### Platform

- Linux
- Docker
- Azure Container Apps

---

## Current Architecture

The current environment consists of:

- Resource Group
- Virtual Network
- App Subnet
- Private Endpoint Subnet
- Network Security Group
- Storage Account
- Blob Container
- Key Vault
- User Assigned Managed Identity
- Azure RBAC

An architecture diagram will be added as the project evolves.

---

## Repository Structure

```
cloudhelp-azure-platform/
│
├── terraform/
├── docs/
├── diagrams/
├── screenshots/
├── powershell/
├── .github/
└── README.md
```

---

## Roadmap
Future milestones will introduce:

### Foundation
- [x] Resource Group
- [x] Virtual Network
- [x] Storage
- [x] Key Vault
- [x] Managed Identity

- [] Application
- [] App Service
- [] Private Endpoint
- [] Application Settings

⬜ Monitoring
    ⬜ Log Analytics
    ⬜ Azure Monitor
    ⬜ Alerts

⬜ DevOps
    ⬜ GitHub Actions
    ⬜ Remote State
    ⬜ CI/CD

⬜ Security
    ⬜ Defender
    ⬜ WAF
    ⬜ Private DNS

**Azure Infrastructure**

✔ Resource Groups
✔ Virtual Networks
✔ Subnets
✔ Storage Accounts
✔ Key Vault
✔ Managed Identity
✔ RBAC

**Infrastructure as Code**

✔ Terraform
✔ State Management
✔ Outputs
✔ Variables
✔ Dependency Management

**DevOps**

✔ Git
✔ Feature Branches
✔ Pull Requests
✔ Code Reviews
✔ Repository Documentation

## Deployment Workflow

```text
Feature Branch
      │
Terraform Development
      │
terraform fmt
      │
terraform validate
      │
terraform plan
      │
terraform apply
      │
Verification
      │
Pull Request
      │
Merge
      │
Sync main
```

This repository is being developed as a long-term Azure DevOps portfolio project and will continue to evolve over time.
