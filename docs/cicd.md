# CI/CD Pipeline

## Overview

The CloudHelp platform uses GitHub Actions to automate the validation and deployment of Azure infrastructure provisioned with Terraform. The CI/CD pipeline has been designed to follow modern DevOps practices by validating infrastructure changes before deployment, enforcing code reviews and securely authenticating to Azure using OpenID Connect (OIDC).

The deployment process separates infrastructure validation from infrastructure deployment, ensuring that proposed changes can be reviewed before they are applied. Manual approval gates and branch protection rules provide additional safeguards, helping to prevent unintended infrastructure changes while maintaining a consistent deployment workflow.

---

## Pipeline Architecture

The CloudHelp deployment pipeline consists of two independent GitHub Actions workflows:

- **Continuous Integration (CI)** validates infrastructure changes and generates a Terraform execution plan.
- **Continuous Deployment (CD)** applies approved infrastructure changes to Azure following manual approval.

Separating validation and deployment follows Infrastructure as Code best practices by ensuring that infrastructure changes are reviewed before they are executed.

The deployment workflow is illustrated below:

```text
Developer
      │
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
GitHub Actions (CD)
      │
Manual Environment Approval
      │
Terraform Apply
      │
Azure Infrastructure
```

The platform uses OpenID Connect (OIDC) federation with Microsoft Entra ID to authenticate both workflows, removing the need to store long-lived credentials within GitHub. Terraform state is stored remotely in Azure Blob Storage, providing a shared source of truth for both local development and automated deployments.

---

## Continuous Integration

The Continuous Integration (CI) workflow is responsible for validating infrastructure changes before they are merged into the `main` branch. Every proposed change is automatically checked to ensure that the Terraform configuration is correctly formatted, syntactically valid and capable of generating a successful execution plan.

Automating these validation steps provides rapid feedback during development, reduces the likelihood of deployment failures and helps maintain a consistent Infrastructure as Code (IaC) standard across the project.

### Workflow Trigger

The CI workflow is automatically triggered whenever a Pull Request is opened or updated against the `main` branch.

This ensures that every infrastructure change is validated before it can be reviewed and merged.

### Workflow Stages

The CI pipeline performs the following stages:

| Stage | Purpose |
|--------|---------|
| Repository Checkout | Retrieves the latest repository contents. |
| Azure Authentication | Authenticates to Azure using OpenID Connect (OIDC). |
| Terraform Initialisation | Downloads providers and connects to the remote Terraform backend. |
| Terraform Formatting | Verifies that the Terraform configuration follows a consistent formatting standard using `terraform fmt`. |
| Terraform Validation | Performs static validation of the Terraform configuration using `terraform validate`. |
| Terraform Planning | Generates a Terraform execution plan to identify the proposed infrastructure changes without modifying Azure resources. |

Each stage must complete successfully before the workflow is considered successful.

### Terraform Plan

The Terraform execution plan provides a preview of the infrastructure changes that would be applied to Azure.

Reviewing the execution plan before deployment allows infrastructure changes to be verified, reducing the risk of accidental modifications and providing an opportunity to identify configuration errors before they reach the deployment stage.

The execution plan also serves as an additional review artefact during the Pull Request process, allowing proposed infrastructure changes to be inspected alongside the Terraform code.

### Benefits

Implementing Continuous Integration provides several advantages:

- Automatically validates all Terraform changes.
- Detects configuration errors before deployment.
- Enforces consistent Terraform formatting.
- Generates a reviewable Terraform execution plan.
- Provides confidence that infrastructure changes are deployable before approval.
- Integrates with GitHub Branch Protection to prevent unvalidated changes from being merged.


---

## Continuous Deployment

The Continuous Deployment (CD) workflow is responsible for applying approved infrastructure changes to Azure. Unlike the Continuous Integration workflow, which performs validation only, the deployment workflow modifies Azure resources by executing the previously approved Terraform plan.

Separating deployment from validation ensures that infrastructure changes are reviewed before being applied, providing greater control over the deployment process and reducing the risk of unintended modifications.

### Workflow Trigger

The deployment workflow is triggered manually through GitHub Actions after infrastructure changes have been reviewed and merged into the `main` branch.

Before deployment begins, the workflow requires approval through a protected GitHub Environment. This approval gate provides an additional safeguard by ensuring that infrastructure changes cannot be applied without explicit authorisation.

### Workflow Stages

The deployment pipeline performs the following stages:

| Stage | Purpose |
|--------|---------|
| Repository Checkout | Retrieves the latest repository contents. |
| Azure Authentication | Authenticates to Azure using OpenID Connect (OIDC). |
| Terraform Initialisation | Connects to the remote Terraform backend and downloads the required providers. |
| Download Terraform Plan | Retrieves the approved execution plan generated during the Continuous Integration workflow. |
| Environment Approval | Waits for manual approval before deployment begins. |
| Terraform Apply | Applies the approved Terraform plan to Azure, creating, updating or removing infrastructure as required. |

Each deployment is executed against the remote Terraform state, ensuring that local development environments and GitHub Actions maintain a consistent view of the deployed infrastructure.

### Deployment Safety

Several controls have been implemented to ensure that infrastructure changes are deployed safely:

- Infrastructure changes must first pass the Continuous Integration workflow.
- Changes must be reviewed through a Pull Request before being merged.
- The deployment workflow requires manual approval before Terraform Apply is executed.
- Terraform uses a remote backend with state locking to prevent concurrent infrastructure modifications.
- Azure authentication is performed using short-lived credentials issued through OpenID Connect (OIDC).

These controls reduce deployment risk while maintaining a repeatable and auditable Infrastructure as Code workflow.

### Benefits

Implementing a dedicated deployment workflow provides several advantages:

- Separates infrastructure validation from deployment.
- Ensures only reviewed infrastructure changes are deployed.
- Introduces manual approval before infrastructure changes are applied.
- Eliminates long-lived credentials through passwordless authentication.
- Uses remote Terraform state to maintain a single source of truth.
- Provides a repeatable and consistent deployment process.


---

## OpenID Connect Authentication

The CloudHelp platform uses OpenID Connect (OIDC) federation with Microsoft Entra ID to securely authenticate GitHub Actions workflows to Azure.

Traditional CI/CD pipelines often rely on long-lived client secrets or service principal credentials stored within the CI/CD platform. The CloudHelp platform instead uses passwordless authentication, allowing GitHub Actions to obtain short-lived access tokens directly from Microsoft Entra ID when a workflow executes.

This approach improves security by eliminating the need to store or manage Azure credentials within the GitHub repository.

### Authentication Flow

The authentication process follows the workflow below:

```text
GitHub Actions
      │
      ▼
OpenID Connect (OIDC)
      │
      ▼
Microsoft Entra ID
      │
      ▼
Short-lived Access Token
      │
      ▼
Azure Resources
```

When a workflow starts, GitHub requests an OpenID Connect identity token. Microsoft Entra ID validates the request against a configured Federated Credential and, if successful, issues a temporary access token that Terraform uses to authenticate to Azure.

The access token is valid only for the duration of the workflow and is never stored within the repository.

### Separate Deployment Identities

The CloudHelp platform uses separate Microsoft Entra applications for the Continuous Integration and Continuous Deployment workflows.

This separation follows the principle of least privilege by allowing each workflow to receive only the permissions required for its specific role.

- **Continuous Integration** performs infrastructure validation and Terraform planning.
- **Continuous Deployment** performs Terraform Apply and modifies Azure resources following manual approval.

Using separate identities reduces the impact of a compromised workflow and provides clearer separation between validation and deployment activities.

### Benefits

Implementing OpenID Connect provides several advantages:

- Eliminates long-lived client secrets.
- Uses short-lived access tokens issued at runtime.
- Reduces credential management overhead.
- Improves the security of automated deployments.
- Integrates natively with Microsoft Entra ID.
- Supports modern passwordless authentication practices.


---

## GitHub Environments

GitHub Environments provide an additional approval layer within the CloudHelp deployment pipeline, ensuring that infrastructure changes cannot be deployed without explicit authorisation.

The deployment workflow targets a protected GitHub Environment before executing Terraform Apply. When a deployment reaches this stage, GitHub pauses the workflow and waits for an authorised reviewer to approve the deployment.

This approval process provides an additional safeguard by preventing automatic infrastructure changes from being applied immediately after code is merged into the `main` branch.

### Environment Protection

The CloudHelp deployment environment is configured with protection rules that require manual approval before deployment can continue.

This ensures that infrastructure deployments are:

- Reviewed before execution.
- Explicitly approved by an authorised reviewer.
- Auditable through GitHub deployment history.

### Deployment Workflow

The GitHub Environment forms part of the overall deployment pipeline:

```text
Merge to main
      │
      ▼
GitHub Actions (CD)
      │
      ▼
GitHub Environment
      │
Manual Approval
      │
      ▼
Terraform Apply
      │
      ▼
Azure Infrastructure
```

### Benefits

Using GitHub Environments provides several operational advantages:

- Introduces a manual approval gate before deployment.
- Prevents accidental infrastructure changes.
- Provides an auditable deployment history.
- Supports production-style change management.
- Integrates directly with GitHub Actions workflows.

---

## Branch Protection

The CloudHelp repository uses GitHub Branch Protection Rules to safeguard the `main` branch and ensure that all infrastructure changes follow a consistent development and review process.

Rather than allowing direct commits to the primary branch, all infrastructure changes are developed on feature branches and merged through Pull Requests after successful validation and review.

Branch Protection provides an additional layer of governance by enforcing quality checks before infrastructure changes can become part of the main codebase.

### Protected Workflow

The protected development workflow follows the process below:

```text
Feature Branch
      │
      ▼
Commit Changes
      │
      ▼
Push to GitHub
      │
      ▼
Pull Request
      │
      ▼
GitHub Actions (CI)
      │
Terraform Validation
      │
      ▼
Code Review
      │
      ▼
Merge to main
```

### Current Protection Rules

The CloudHelp repository currently enforces the following protection rules:

- Direct commits to the `main` branch are prohibited.
- Infrastructure changes must be submitted through a Pull Request.
- The Terraform validation workflow must complete successfully before merging.
- Repository history is maintained through the Pull Request workflow.

These controls help ensure that all infrastructure changes are validated, reviewed and recorded before deployment.

### Benefits

Using GitHub Branch Protection provides several operational advantages:

- Prevents direct modification of the production codebase.
- Ensures infrastructure validation is completed before merging.
- Encourages peer review through Pull Requests.
- Improves traceability by recording infrastructure changes through Git history.
- Supports a consistent and repeatable Infrastructure as Code workflow.

---

## Development Workflow

Infrastructure changes to the CloudHelp platform follow a structured development workflow designed to promote consistency, maintain infrastructure quality and reduce deployment risk.

All changes are developed using feature branches and progress through validation, review and deployment before being applied to Azure.

### Workflow Process

The standard development workflow is illustrated below:

```text
Create Feature Branch
        │
        ▼
Develop Infrastructure
        │
        ▼
Local Testing
(terraform fmt / validate / plan)
        │
        ▼
Commit Changes
        │
        ▼
Push Feature Branch
        │
        ▼
Create Pull Request
        │
        ▼
GitHub Actions (CI)
        │
Terraform Validation & Plan
        │
        ▼
Review Changes
        │
        ▼
Merge to main
        │
        ▼
GitHub Actions (CD)
        │
Manual Environment Approval
        │
        ▼
Terraform Apply
        │
        ▼
Verify Deployment
```

### Development Principles

The CloudHelp platform follows several development principles throughout the infrastructure lifecycle:

- Develop all infrastructure changes on feature branches.
- Validate Terraform locally before creating a Pull Request.
- Use GitHub Actions to perform automated validation.
- Review infrastructure changes before merging.
- Deploy only reviewed and approved infrastructure.
- Verify successful deployment following Terraform Apply.

Following a consistent workflow helps ensure that infrastructure changes remain predictable, repeatable and fully traceable throughout the development lifecycle.

### Benefits

The development workflow provides several operational advantages:

- Encourages small, focused infrastructure changes.
- Detects configuration issues early through automated validation.
- Maintains a complete history of infrastructure changes.
- Reduces deployment risk through staged validation and approval.
- Supports collaboration by using a consistent development process.
- Promotes Infrastructure as Code best practices throughout the project.

---

## Troubleshooting

During the development of the CloudHelp platform, several common issues were encountered while implementing and validating the CI/CD pipeline. The following guidance documents the most common problems together with their resolutions.

### Terraform Validation Workflow Not Running

**Symptoms**

- Pull Request remains in the **Expected** state.
- Required status check never completes.
- No GitHub Actions workflow is triggered.

**Resolution**

Verify that the workflow trigger matches the repository configuration and that the workflow is configured to run for Pull Requests targeting the `main` branch. Ensure any path filters include the modified files.

---

### OpenID Connect Authentication Failures

**Symptoms**

- Azure authentication fails during workflow execution.
- GitHub Actions cannot obtain an Azure access token.

**Resolution**

Verify that the Microsoft Entra application, Federated Credentials and GitHub repository configuration match the workflow being executed. Confirm that the workflow has permission to request an OpenID Connect identity token.

---

### Terraform Backend Access Issues

**Symptoms**

- Terraform Init fails.
- Remote state cannot be accessed.
- State locking errors occur.

**Resolution**

Verify that the authenticated identity has the required Azure RBAC permissions for the Terraform backend Storage Account and Blob Container. Confirm that no other Terraform operation currently holds the state lock.

---

### Deployment Waiting for Approval

**Symptoms**

- GitHub Actions pauses during deployment.
- Terraform Apply does not begin.

**Resolution**

This behaviour is expected. The deployment workflow is configured to require approval through a protected GitHub Environment before infrastructure changes are applied.

---

### Branch Protection Prevents Pushes

**Symptoms**

- Direct pushes to the `main` branch are rejected.
- Git reports that repository rules have been violated.

**Resolution**

Infrastructure changes should be developed on a feature branch and merged through a Pull Request. Direct commits to the protected `main` branch are intentionally blocked.

---

### General Troubleshooting Process

When investigating CI/CD issues, the following approach is recommended:

1. Review the GitHub Actions workflow logs.
2. Identify the stage where the workflow failed.
3. Review the associated error message.
4. Verify Azure authentication and permissions.
5. Confirm Terraform backend connectivity.
6. Re-run the workflow after resolving the issue.

Following a structured troubleshooting process helps reduce investigation time while ensuring infrastructure deployments remain reliable and repeatable.

---

## Future Improvements

The current CI/CD implementation provides a secure and reliable deployment pipeline for the CloudHelp platform. As the platform evolves, the deployment process will continue to be refined by introducing additional automation, improving deployment safety and supporting multiple deployment environments.

Planned enhancements include:

- Introduce separate Development, Test and Production deployment environments.
- Implement reusable deployment workflows for multiple environments.
- Automate infrastructure drift detection.
- Introduce scheduled Terraform plan validation.
- Expand deployment approvals to support multiple reviewers.
- Implement automated rollback strategies for deployment failures where appropriate.
- Integrate infrastructure security scanning into the Continuous Integration workflow.
- Introduce automated documentation validation and quality checks.
- Expand deployment reporting and workflow notifications.

The long-term objective is to develop a production-style Infrastructure as Code deployment pipeline that follows modern DevOps practices while remaining secure, repeatable and easy to maintain.

---