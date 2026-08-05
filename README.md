# CloudHelp Azure Platform
![Terraform](https://img.shields.io/badge/Terraform-v1.15-blue)
![Azure](https://img.shields.io/badge/Azure-IaC-0078D4)
![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-CI/CD-success)
![License](https://img.shields.io/badge/License-MIT-green)

## Overview

CloudHelp is a fictional Software-as-a-Service (SaaS) company that provides a cloud-based help desk platform for small and medium-sized businesses.

This repository documents the Azure infrastructure that hosts the CloudHelp platform. The platform has been built incrementally using Infrastructure as Code (IaC) and follows Azure and DevOps engineering best practices.

The primary goal of this repository is to demonstrate practical Azure and DevOps skills, including Terraform, Git, GitHub Actions, Azure services, automation, monitoring and documentation.

---

## Key Features

- Infrastructure as Code using Terraform
- Secure GitHub Actions CI/CD using OpenID Connect (OIDC)
- Remote Terraform state stored in Azure Storage
- Azure Monitor with Log Analytics, Diagnostic Settings and Alerting
- Production-style Git workflow using feature branches and pull requests
- Infrastructure split into modular Terraform files
- Comprehensive project documentation

---

## Project Goals

- Build and maintain Azure infrastructure using Terraform.
- Implement secure CI/CD using GitHub Actions and OpenID Connect (OIDC).
- Apply Infrastructure as Code and DevOps best practices.
- Demonstrate monitoring, alerting and operational readiness.
- Produce professional documentation and architecture diagrams.

---

## Current Status

CloudHelp Platform v1.0 is an Azure Infrastructure as Code project that provisions, secures, monitors and manages Azure infrastructure using Infrastructure as Code. The project currently includes automated CI/CD, OpenID Connect authentication, Azure Monitor alerts, Log Analytics, diagnostic settings and production-style Git workflows.

---

## Technology Stack

### Cloud

- Microsoft Azure

### Infrastructure as Code

- Terraform
- AzureRM Provider

### DevOps

- Git
- GitHub
- GitHub Actions
- OpenID Connect (OIDC)

### Monitoring

- Azure Monitor
- Log Analytics
- Kusto Query Language (KQL)

### Scripting

- Azure CLI
- PowerShell

### Platform

- Linux App Service

---

### Current Architecture

The current environment consists of:

| Area | Resources |
|------|-----------|
| Networking | Resource Group, Virtual Network, App Subnet, Private Endpoint Subnet, Network Security Group |
| Identity & Security | Azure RBAC, User Assigned Managed Identity, Key Vault, GitHub OIDC Federation |
| Compute | Linux App Service, App Service Plan |
| Storage | Storage Account, Blob Container, Remote Terraform State |
| Monitoring | Log Analytics Workspace, Diagnostic Settings, Azure Monitor Alerts, Action Group |

---

## Repository Structure

```
cloudhelp-azure-platform/

├── .github/
│   └── workflows/
│
├── terraform/
│   ├── app-service.tf
│   ├── identity.tf
│   ├── monitoring.tf
│   ├── app-service.tf
│   ├── networking.tf
│   ├── outputs.tf
│   ├── providers.tf
│   ├── resource-group.tf
│   ├── storage.tf
│   ├── versions.tf
│   ├── key-vault.tf
│   └── variables.tf
│
├── docs/
├── diagrams/
├── screenshots/
├── powershell/
└── README.md
```

---

## CI/CD
CloudHelp uses GitHub Actions to validate, plan and deploy infrastructure changes through separate Continuous Integration (CI) and Continuous Deployment (CD) workflows.

```text
Feature Branch
      │
git push
      │
GitHub Actions (CI)
      │
Terraform fmt
      │
Terraform validate
      │
Terraform plan
      │
Pull Request
      │
Code Review
      │
Merge to main
      │
Manual Environment Approval
      │
GitHub Actions (CD)
      │
Terraform Apply
      │
Azure Infrastructure Updated
```

--- 

**Continuous Integration**
- Terraform formatting validation
- Terraform validation
- Terraform execution plan
- Pull Request status checks

**Continuous Deployment**
- Manual approval using GitHub Environments
- Secure Azure authentication using OIDC
- Terraform Apply
- Infrastructure deployment to Azure

**Security**
- Passwordless authentication using OpenID Connect
- No client secrets stored in GitHub
- Remote Terraform state with Azure Blob Storage
- Branch protection and required status checks

--- 

## Monitoring
CloudHelp uses Azure Monitor and Log Analytics to provide operational visibility across the platform.
Current monitoring includes:

- Log Analytics Workspace
- Diagnostic Settings for Azure resources
- Azure Monitor Metric Alerts
- Azure Monitor Log Alerts using KQL
- Shared Action Group for email notifications

Implemented alerts include:

- HTTP 5xx responses
- High CPU utilisation
- High memory utilisation
- Failed Key Vault requests

---

## Completed
- [x] Azure networking
- [x] Azure storage
- [x] Key Vault
- [x] Managed Identity
- [x] App Service
- [x] Remote Terraform state
- [x] GitHub Actions CI/CD
- [x] OIDC authentication
- [x] Log Analytics
- [x] Azure Monitor
- [x] Azure Alerts
- [x] KQL fundamentals

## Planned
- [ ] Application Insights
- [ ] Azure SQL Database
- [ ] Private Endpoints
- [ ] Azure Front Door
- [ ] Production environment
- [ ] Terraform modules
- [ ] Containerisation
- [ ] Kubernetes

---

## Architecture

The diagram below illustrates the current Azure infrastructure for the CloudHelp platform.

![CloudHelp Architecture](diagrams/architecture.png)

Architecture diagram current as of CloudHelp Platform v1.0.

---

## Development Workflow

```text
Feature Branch
      │
git push
      │
GitHub Actions (CI)
      │
Terraform fmt
      │
Terraform validate
      │
Terraform plan
      │
Pull Request
      │
Code Review
      │
Merge to main
      │
Manual Environment Approval
      │
GitHub Actions (CD)
      │
Terraform Apply
      │
Azure Infrastructure Updated
```

---

## Skills Demonstrated

This project demonstrates practical experience with:

- Azure infrastructure deployment
- Infrastructure as Code (Terraform)
- Azure RBAC and Managed Identities
- Git and GitHub workflows
- GitHub Actions CI/CD
- OpenID Connect authentication
- Azure Monitor and Log Analytics
- Kusto Query Language (KQL)
- Infrastructure monitoring and alerting
- Documentation and architecture design

---

CloudHelp is an evolving Azure DevOps portfolio project. New Azure services, automation, monitoring capabilities and operational practices will continue to be added as the platform evolves.
---