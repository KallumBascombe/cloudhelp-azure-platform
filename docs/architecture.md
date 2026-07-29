# CloudHelp Architecture

## Overview

This document explains the architecture of the CloudHelp Azure platform and the reasoning behind each design decision.

The goal of the project is to demonstrate how Azure infrastructure can be provisioned using Infrastructure as Code (IaC) with Terraform while following Azure security and operational best practices.

![CloudHelp Architecture](../diagrams/architecture.png)

## Resource Group

The CloudHelp infrastructure is deployed into a single Azure Resource Group.

Using a single Resource Group keeps all development resources together, simplifies deployment and deletion, and allows the entire environment to be managed as a single unit.

Future environments such as Test and Production would each use their own dedicated Resource Group.

## Networking

The CloudHelp environment uses a dedicated Azure Virtual Network to provide logical network isolation for application resources.

The Virtual Network contains two subnets:

- **App Subnet**  
  Reserved for application-related networking. A Network Security Group is associated with this subnet to control permitted inbound and outbound traffic.

- **Private Endpoint Subnet**  
  Reserved for private endpoints that will allow Azure services such as Key Vault and Storage to be accessed through private IP addresses rather than their public endpoints.

Separating application resources and private endpoints into different subnets makes the network easier to manage and allows different security controls to be applied to each workload.

At the current stage of the project, the App Service has not yet been integrated with the Virtual Network. This will be implemented in a later phase to enable secure outbound connectivity to resources within the VNet.

## Managed Identity

The CloudHelp application uses an Azure Managed Identity to authenticate securely with Azure services.

Instead of storing credentials, connection strings or client secrets within the application, Azure automatically provides an identity that can be granted access to specific resources through Azure Role-Based Access Control (RBAC).

Using a Managed Identity reduces the risk of credential exposure, removes the need to rotate secrets manually, and follows Microsoft's recommended approach for authenticating Azure applications.

The Managed Identity currently has access to the Key Vault and can be extended in the future to access additional Azure resources if required.

The Managed Identity follows the principle of least privilege by only being granted the permissions required for the application to function.

## Key Vault

Azure Key Vault provides secure storage for application secrets and sensitive configuration values.

Rather than storing secrets within application code, configuration files or source control, sensitive values are stored centrally within Key Vault and accessed securely using the application's Managed Identity.

This approach improves security, simplifies secret management and allows credentials to be rotated without requiring application code changes.

The Key Vault is configured using Azure RBAC instead of legacy access policies to provide consistent access management across the Azure environment.

## Storage Account

The Azure Storage Account provides durable object storage for the CloudHelp application.

Blob Storage is intended for storing user uploaded files, application-generated content and other unstructured data.

The storage account is configured separately from the application to allow storage capacity to scale independently from compute resources while maintaining a secure architecture.

Separating storage from compute allows each service to scale independently while maintaining a loosely coupled architecture.

## Security Decisions

Security has been considered throughout the design of the CloudHelp platform.

Key security decisions include:

- Azure Managed Identity removes the need to store application credentials.
- Azure RBAC is used to manage permissions consistently across Azure resources.
- Azure Key Vault protects sensitive configuration values.
- Dedicated subnets separate application resources from future private endpoints.
- A Network Security Group provides network-level traffic filtering for the application subnet.

These design decisions follow Azure security best practices and provide a foundation that can be extended as the platform grows.

## Planned Improvements

The current implementation represents the foundation of the CloudHelp platform.

Future enhancements include:

- Deploying the Azure App Service.
- Integrating the App Service with the Virtual Network.
- Creating Private Endpoints for Azure Storage and Key Vault.
- Moving Terraform state to a remote Azure Storage backend.
- Implementing GitHub Actions for automated Terraform deployments.
- Implementing Azure Monitor and Log Analytics.
- Configuring diagnostic logging and alerts.
- Adding Microsoft Defender for Cloud recommendations and security monitoring.