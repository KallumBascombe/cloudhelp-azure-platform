ADR-001 — Use Terraform for Infrastructure as Code
Status

Accepted

Context

The CloudHelp platform requires a repeatable and maintainable method for provisioning Azure infrastructure.

Resources could be created manually through the Azure Portal or automated using tools such as Azure CLI, PowerShell, Bicep or Terraform. Manual deployment would make the environment difficult to reproduce, review and maintain as the platform grows.

Decision

Terraform will be used as the primary Infrastructure as Code tool for provisioning and managing the CloudHelp Azure platform.

Azure resources will be defined declaratively within Terraform configuration files and maintained in source control alongside the supporting documentation and GitHub Actions workflows.

Rationale

Terraform was selected because it:

Provides a declarative approach to infrastructure management.
Generates execution plans before infrastructure is modified.
Maintains state to track deployed resources.
Integrates effectively with Azure and GitHub Actions.
Supports reusable modules and multiple environments as the platform grows.
Provides transferable Infrastructure as Code experience across multiple cloud platforms.
Alternatives Considered
Azure Portal: Easy for initial experimentation but difficult to reproduce, review and audit consistently.
Azure CLI or PowerShell: Suitable for automation, but imperative scripts can become difficult to maintain for complete environment provisioning.
Azure Bicep: Provides strong native Azure integration, but Terraform was selected for its wider industry adoption and multi-cloud portability.
Consequences

Positive

Infrastructure changes are version-controlled and reviewable.
Environments can be recreated consistently.
Terraform plans provide visibility into proposed changes.
Infrastructure deployment can be automated through CI/CD.
Manual configuration drift is easier to identify.

Negative

Terraform introduces a state file that must be secured and maintained.
Engineers must understand Terraform syntax, providers and state management.
Provider updates may introduce changes that require configuration maintenance.

---

ADR-002 — Store Terraform State Remotely in Azure Storage
Status

Accepted

Context

Terraform requires a state file to track the infrastructure it manages. By default, this state is stored locally on the machine executing Terraform.

While suitable for experimentation, local state presents several challenges for collaborative development and automated deployments:

State is not shared between developers.
CI/CD pipelines cannot access local state.
Infrastructure changes become difficult to coordinate.
State files can be lost or accidentally modified.

A more robust solution was required to support automated deployments and future platform growth.

Decision

The CloudHelp platform will use an Azure Storage Account and Blob Container as a remote Terraform backend.

The backend infrastructure is deployed separately from the main platform and stores the Terraform state file for all subsequent infrastructure operations.

Rationale

A remote backend was selected because it:

Provides a single source of truth for infrastructure state.
Supports both local development and GitHub Actions deployments.
Enables Azure Blob Storage state locking to prevent concurrent Terraform operations.
Protects the state file from accidental deletion alongside the application infrastructure.
Follows Infrastructure as Code best practices for production environments.
Alternatives Considered
Local State: Simple to configure but unsuitable for collaboration and automated deployments.
Terraform Cloud: Provides managed state and additional collaboration features, but Azure Storage was selected to keep the platform entirely within Azure while reducing external dependencies.
Azure Storage within the Development Resource Group: Considered, but rejected because deleting the development environment could also remove the Terraform state.
Consequences

Positive

Infrastructure state is shared across all deployment environments.
GitHub Actions and local Terraform use the same backend.
State locking prevents concurrent infrastructure modifications.
Backend storage is isolated from the application platform.
Infrastructure deployments become more reliable and repeatable.

Negative

The backend infrastructure must be bootstrapped before Terraform can use it.
Remote backend configuration introduces additional setup complexity.
Appropriate Azure RBAC permissions are required to access the backend.

---

ADR-003 — Separate Continuous Integration and Continuous Deployment
Status

Accepted

Context

Infrastructure changes require validation before they are deployed to Azure. A simple deployment pipeline could perform validation and immediately execute terraform apply whenever changes are pushed to the repository.

While this approach reduces implementation complexity, it also increases deployment risk by allowing infrastructure changes to be applied without formal review or approval.

A deployment process was required that balanced automation with appropriate operational controls.

Decision

The CloudHelp platform separates infrastructure validation and infrastructure deployment into two independent GitHub Actions workflows.

The Continuous Integration (CI) workflow validates Terraform configurations and generates a Terraform execution plan.

The Continuous Deployment (CD) workflow is responsible for applying approved infrastructure changes following manual approval through a protected GitHub Environment.

Rationale

Separating CI and CD provides several operational advantages:

Infrastructure changes are validated before deployment.
Terraform execution plans can be reviewed prior to applying changes.
Deployments require explicit approval before modifying Azure resources.
Validation failures do not risk partially deployed infrastructure.
The deployment process more closely reflects production DevOps practices.
Alternatives Considered
Single GitHub Actions Workflow: Simpler to implement but combines validation and deployment into a single process, reducing deployment control.
Automatic Deployment After Merge: Reduces manual effort but removes the approval gate before infrastructure changes are applied.
Manual Local Terraform Apply: Suitable for experimentation but lacks consistency, auditability and automation.
Consequences

Positive

Validation and deployment are clearly separated.
Infrastructure changes are reviewed before deployment.
Manual approval provides an additional safeguard.
Deployment failures are isolated from validation failures.
The pipeline is easier to maintain and troubleshoot.

Negative

Two workflows require additional configuration and maintenance.
Deployments involve an additional manual approval step.
Workflow artefacts must be shared between validation and deployment stages.

---

ADR-004 — Use OpenID Connect for Azure Authentication
Status

Accepted

Context

GitHub Actions requires authentication to Azure in order to validate and deploy Terraform infrastructure.

A traditional approach would store Azure client secrets or service principal credentials within GitHub Secrets. While functional, this introduces long-lived credentials that must be created, secured, rotated and monitored throughout their lifecycle.

A more secure authentication mechanism was required for the CloudHelp platform.

Decision

The CloudHelp platform uses OpenID Connect (OIDC) federation with Microsoft Entra ID to authenticate GitHub Actions workflows to Azure.

Rather than storing credentials within the repository, GitHub Actions requests a short-lived identity token at runtime. Microsoft Entra ID validates the request and issues a temporary access token that Terraform uses to access Azure resources.

Separate Microsoft Entra applications are used for the Continuous Integration and Continuous Deployment workflows, allowing permissions to be assigned independently.

Rationale

OpenID Connect was selected because it:

Eliminates the need to store long-lived credentials within GitHub.
Uses short-lived access tokens issued only when required.
Integrates natively with Microsoft Entra ID.
Supports the principle of least privilege through separate deployment identities.
Reduces operational overhead by removing secret rotation and management.
Alternatives Considered
Client Secret Authentication: Simple to configure but requires long-lived secrets to be stored and periodically rotated.
Certificate-Based Authentication: More secure than client secrets but introduces additional certificate lifecycle management.
Managed Identity: Not suitable because GitHub-hosted runners execute outside the Azure environment and therefore cannot use Azure Managed Identities directly.
Consequences

Positive

No Azure credentials are stored within the repository.
Authentication is performed using short-lived tokens.
Separate identities provide clearer separation between validation and deployment workflows.
Azure access can be managed centrally through Microsoft Entra ID and Azure RBAC.
The authentication model aligns with current Microsoft security recommendations.

Negative

Initial configuration is more complex than client secret authentication.
OIDC federation requires additional Microsoft Entra configuration.
Troubleshooting authentication failures requires familiarity with federated credentials and token issuance.

---

ADR-005 — Use GitHub Actions for CI/CD Automation
Status

Accepted

Context

The CloudHelp platform requires an automated deployment pipeline to validate Terraform configurations, generate execution plans and deploy approved infrastructure changes to Azure.

Several CI/CD platforms could fulfil these requirements, including GitHub Actions, Azure DevOps Pipelines and Jenkins.

The chosen platform needed to integrate well with the project's source control while supporting modern authentication and Infrastructure as Code workflows.

Decision

GitHub Actions was selected as the CI/CD platform for the CloudHelp project.

All infrastructure validation and deployment workflows are implemented using GitHub Actions and stored alongside the Terraform configuration within the repository.

Rationale

GitHub Actions was selected because it:

Integrates natively with GitHub repositories.
Supports Infrastructure as Code workflows using Terraform.
Provides first-class support for OpenID Connect (OIDC) authentication.
Supports reusable workflows and future pipeline expansion.
Includes GitHub Environments for deployment approvals.
Enables CI/CD configuration to be version controlled alongside the infrastructure code.
Alternatives Considered
Azure DevOps Pipelines: A mature CI/CD platform with strong Azure integration, but GitHub Actions was selected because the source code is already hosted in GitHub and the platform provides a simpler development experience for this project.
Jenkins: Highly flexible and widely adopted, but requires additional infrastructure, maintenance and plugin management.
Manual Deployments: Suitable for experimentation but lacks repeatability, automation and auditability.
Consequences

Positive

CI/CD configuration is version controlled within the repository.
Infrastructure validation and deployment are fully automated.
Native integration with GitHub Pull Requests and Branch Protection.
Seamless integration with OpenID Connect authentication.
Easy to extend as additional deployment environments are introduced.

Negative

The deployment pipeline is coupled to the GitHub platform.
Workflow configuration requires familiarity with GitHub Actions syntax.
Complex workflows can become more difficult to maintain as the platform grows.

---

ADR-006 — Use Azure RBAC Instead of Key Vault Access Policies
Status

Accepted

Context

Azure Key Vault supports two permission models:

Azure Role-Based Access Control (Azure RBAC)
Key Vault Access Policies

Both approaches provide secure access to secrets, keys and certificates, but using multiple authorisation models within the same Azure environment can increase operational complexity and make permission management less consistent.

The CloudHelp platform required a single, scalable authorisation model.

Decision

The CloudHelp platform uses Azure Role-Based Access Control (Azure RBAC) as the sole authorisation model for Azure Key Vault.

Access Policies are not used.

Permissions are assigned through Azure RBAC roles at the appropriate scope, allowing Managed Identities and users to access Key Vault resources using the same authorisation model as the rest of the Azure platform.

Rationale

Azure RBAC was selected because it:

Provides a consistent authorisation model across Azure resources.
Centralises permission management within Microsoft Entra ID and Azure.
Supports the principle of least privilege through built-in Azure roles.
Simplifies long-term administration as the platform grows.
Aligns with Microsoft's recommended approach for new Azure deployments.
Alternatives Considered
Key Vault Access Policies: A mature permission model that remains supported, but it introduces a separate authorisation mechanism alongside Azure RBAC and increases administrative complexity.
Mixed Permission Model: Using Azure RBAC for some resources and Access Policies for Key Vault was considered but rejected because it creates inconsistent access management across the platform.
Consequences

Positive

A single authorisation model is used throughout the Azure environment.
Permissions are managed consistently using Azure RBAC.
Managed Identities integrate naturally with Azure RBAC role assignments.
Future Azure resources can adopt the same permission model without introducing additional access mechanisms.
Permission management is simplified as the platform expands.

Negative

Azure RBAC permissions can take time to propagate after assignment.
Engineers must understand Azure RBAC scopes and built-in roles.
Some legacy documentation and examples continue to reference Access Policies, requiring awareness of both models.

---

ADR-007 — Adopt a Feature Branch Development Workflow
Status

Accepted

Context

Infrastructure changes can be developed directly on the main branch or isolated within feature branches before being merged.

Direct development on the primary branch simplifies the workflow but increases the risk of introducing unreviewed or untested infrastructure changes into the production codebase. As the CloudHelp platform grows, a more structured development process is required to support collaboration, change tracking and controlled deployments.

Decision

All infrastructure changes will be developed on dedicated feature branches.

Completed work will be submitted through a Pull Request, validated using GitHub Actions and merged into the main branch only after successful validation and review.

Direct commits to the protected main branch are not permitted.

Rationale

A feature branch workflow was selected because it:

Isolates infrastructure changes during development.
Prevents incomplete work from affecting the primary codebase.
Integrates naturally with Pull Requests and automated validation.
Supports clear change history and traceability.
Aligns with common Git and DevOps development practices.
Alternatives Considered
Direct Development on main: Simpler for a single developer but increases the risk of deploying incomplete or unvalidated infrastructure changes.
Long-Lived Development Branches: Considered but rejected because they increase merge complexity and drift from the primary branch.
Git Flow: A mature branching strategy but unnecessarily complex for a single-platform Infrastructure as Code project.
Consequences

Positive

Infrastructure changes remain isolated until they are complete.
Every change follows a consistent validation and deployment process.
Pull Requests provide a clear history of infrastructure evolution.
Merge conflicts are reduced by keeping feature branches short-lived.
The workflow can scale naturally to multiple contributors in the future.

Negative

Infrastructure changes require additional Git operations, including branch creation and Pull Requests.
Small changes take slightly longer to deploy due to the structured workflow.
Developers must regularly synchronise feature branches with the main branch to minimise divergence.

---

ADR-008 — Use Azure Managed Identities for Application Authentication
Status

Accepted

Context

Applications hosted in Azure often require access to other Azure resources such as Key Vault, Storage Accounts or Azure SQL Database.

A traditional approach is to authenticate using connection strings, client secrets or application credentials stored within configuration files or environment variables. While functional, these credentials must be protected, rotated and managed throughout their lifecycle.

The CloudHelp platform required a secure authentication model that minimised credential management.

Decision

The CloudHelp platform uses a User Assigned Managed Identity to authenticate the Linux App Service to Azure resources.

The Managed Identity is granted only the Azure RBAC permissions required for the application to access Azure services.

No application credentials or client secrets are stored within the application configuration.

Rationale

Managed Identities were selected because they:

Eliminate the need to store credentials within the application.
Support secure authentication through Microsoft Entra ID.
Integrate naturally with Azure RBAC.
Simplify credential management by removing secret rotation.
Follow Microsoft's recommended authentication model for Azure-hosted applications.
Alternatives Considered
Connection Strings: Simple to implement but require sensitive credentials to be stored and protected.
Service Principal with Client Secret: Suitable for automation but introduces long-lived credentials that require lifecycle management.
System Assigned Managed Identity: Considered, but a User Assigned Managed Identity was selected because it can be reused across multiple Azure resources if required in the future.
Consequences

Positive

No credentials are stored within the application.
Authentication is handled natively by Azure.
Azure RBAC provides centralised permission management.
The authentication model scales naturally as additional Azure resources are introduced.
Security is improved by eliminating long-lived application secrets.

Negative

Managed Identities are only available within Azure-hosted workloads.
Developers must understand Azure RBAC role assignments to configure permissions correctly.
Troubleshooting authentication issues requires familiarity with Microsoft Entra ID and Managed Identity behaviour.

---

ADR-009 — Use Azure Monitor and Log Analytics for Centralised Monitoring
Status

Accepted

Context

As the CloudHelp platform grew, a monitoring solution was required to provide visibility into platform health, resource performance and operational events.

Monitoring individual Azure resources independently would make troubleshooting more difficult and provide no central location for analysing telemetry or configuring alerts.

A unified monitoring solution was required to support operational monitoring, diagnostics and alerting across the platform.

Decision

The CloudHelp platform uses Azure Monitor together with Azure Log Analytics as its central monitoring solution.

Azure Diagnostic Settings are configured to forward resource logs and metrics to a dedicated Log Analytics Workspace. Azure Monitor evaluates both platform metrics and KQL queries to generate alerts, with notifications delivered through a shared Action Group.

Rationale

Azure Monitor and Log Analytics were selected because they:

Provide a central repository for platform telemetry.
Support both metric-based and log-based alerting.
Integrate natively with Azure resources.
Enable powerful querying through Kusto Query Language (KQL).
Provide a scalable monitoring architecture as additional Azure services are introduced.
Alternatives Considered
Resource-Specific Monitoring: Azure resources provide individual monitoring capabilities, but these lack centralised analysis and consistent alerting.
Third-Party Monitoring Platforms: External monitoring solutions provide additional capabilities but introduce extra cost, configuration and operational complexity for a project of this scale.
Minimal Monitoring: Basic metrics alone would provide limited operational visibility and make troubleshooting significantly more difficult.
Consequences

Positive

Telemetry is centralised within a single Log Analytics Workspace.
Metric Alerts and Log Alerts provide comprehensive operational monitoring.
KQL enables flexible investigation and troubleshooting.
Alert notifications are standardised through a shared Action Group.
The monitoring platform can expand alongside the Azure environment.

Negative

Diagnostic logs increase Log Analytics data ingestion.
Engineers must develop familiarity with Kusto Query Language (KQL).
Monitoring configuration requires additional operational planning to balance visibility with cost.

---

ADR-010 — Deploy Applications Using Azure App Service
Status

Accepted

Context

The CloudHelp platform required a hosting solution for its web application.

Several Azure compute options were considered, including Virtual Machines, Azure Kubernetes Service (AKS), Azure Container Apps and Azure App Service. The chosen platform needed to support rapid deployment, minimise infrastructure management and integrate with the existing Azure services used throughout the project.

As the primary objective of the project is to demonstrate Azure infrastructure and DevOps practices rather than operating virtual machines or Kubernetes clusters, a managed hosting platform was preferred.

Decision

The CloudHelp platform uses Azure App Service running on Linux as the primary application hosting platform.

Application compute resources are provided through a dedicated App Service Plan, allowing the application to be deployed without managing the underlying operating system or infrastructure.

Rationale

Azure App Service was selected because it:

Is a fully managed Platform as a Service (PaaS) offering.
Eliminates the need to manage virtual machines and operating systems.
Integrates naturally with Managed Identities, Azure Monitor and Log Analytics.
Supports straightforward scaling as application demand increases.
Reduces operational overhead while allowing the project to focus on Infrastructure as Code and DevOps practices.
Alternatives Considered
Azure Virtual Machines: Provide complete operating system control but require ongoing management, patching and maintenance.
Azure Kubernetes Service (AKS): Offers powerful container orchestration but introduces unnecessary operational complexity for the current stage of the project.
Azure Container Apps: A strong option for containerised workloads, but the project currently hosts a single web application that does not require a container platform.
Consequences

Positive

Infrastructure management is simplified through a managed hosting platform.
The application integrates directly with Azure Managed Identity and Azure Monitor.
Scaling can be performed without modifying the application architecture.
Operational effort is reduced compared to managing virtual machines.

Negative

Platform configuration is constrained by App Service capabilities.
Some operating system customisation available with Virtual Machines is not possible.
Future migration to containers would require additional architectural changes.

---

ADR-010 — Organise Terraform Configuration by Functional Responsibility
Status

Accepted

Context

As the CloudHelp platform evolved, the Terraform configuration grew to include networking, storage, application hosting, monitoring, identities and supporting infrastructure.

Maintaining all resources within a small number of Terraform files made the configuration increasingly difficult to navigate and maintain. Finding related resources, reviewing infrastructure changes and extending the platform became more time-consuming as additional Azure services were introduced.

A clearer project structure was required to improve maintainability without changing the deployed infrastructure.

Decision

The Terraform configuration is organised into multiple files based on functional responsibility.

Each file groups related Azure resources into a single logical area, such as networking, storage, monitoring or application hosting, while remaining part of the same Terraform module.

Rationale

Organising the configuration by responsibility:

Improves readability by grouping related resources together.
Makes infrastructure changes easier to locate and review.
Simplifies future expansion as additional Azure services are introduced.
Encourages separation of concerns within the Terraform configuration.
Aligns with common Infrastructure as Code repository structures.
Alternatives Considered
Single main.tf File: Suitable for small projects but becomes increasingly difficult to navigate as the platform grows.
Separate Terraform Modules: Considered for future expansion, but the current platform size does not yet justify the additional complexity.
Consequences

Positive

The Terraform configuration is easier to understand and maintain.
Related infrastructure is grouped logically.
Pull Requests become easier to review because changes are typically isolated to a single functional area.
The repository is well positioned for future migration to reusable Terraform modules.

Negative

Resources may be defined across multiple files, requiring familiarity with the project structure.
Engineers must understand Terraform's behaviour of combining all .tf files within a directory into a single configuration.

---