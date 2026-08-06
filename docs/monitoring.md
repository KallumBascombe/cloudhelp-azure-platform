# Monitoring and Alerting

## Overview

Monitoring and alerting are essential components of the CloudHelp platform, providing operational visibility into the health, performance and security of Azure resources.

The platform uses Azure Monitor, Log Analytics and Azure Diagnostic Settings to collect platform telemetry, analyse resource activity and notify administrators when predefined conditions are met. Together, these services provide a centralised monitoring solution that supports troubleshooting, operational awareness and proactive incident detection.

The monitoring solution has been designed to follow Azure best practices by separating telemetry collection, log storage, alert evaluation and notification into distinct components. This approach allows the monitoring platform to scale as additional Azure resources and services are introduced.

---

## Log Analytics Workspace

The CloudHelp platform uses a dedicated Azure Log Analytics Workspace as the central repository for platform logs and metrics.

Diagnostic data collected from Azure resources is forwarded to the workspace using Azure Diagnostic Settings, allowing telemetry from multiple services to be analysed from a single location using Kusto Query Language (KQL).

The Log Analytics Workspace currently receives telemetry from:

- Azure Key Vault
- Linux App Service
- App Service Plan
- Azure Storage Blob Service

The workspace provides the foundation for:

- Interactive log analysis using KQL.
- Azure Monitor Log Alerts.
- Operational troubleshooting.
- Centralised platform monitoring.

### Configuration

| Setting | Value |
|---------|-------|
| SKU | PerGB2018 |
| Retention Period | 30 Days |
| Daily Ingestion Cap | 0.5 GB |

The retention period and daily ingestion cap have been configured to support a small development environment while providing sufficient historical data for testing, troubleshooting and alert validation. These values can be adjusted as the platform grows and monitoring requirements evolve.

---

## Diagnostic Settings

Azure Diagnostic Settings are responsible for forwarding logs and metrics from Azure resources to the Log Analytics Workspace. Without Diagnostic Settings, Azure resources generate telemetry independently, but that data is not automatically centralised for querying or alerting.

Each monitored resource is configured individually, allowing the platform to collect only the telemetry that is relevant for operational monitoring while avoiding unnecessary data ingestion.

The CloudHelp platform currently has Diagnostic Settings configured for the following resources:

| Azure Resource | Logs | Metrics |
|----------------|------|---------|
| Azure Key Vault | AuditEvent, AzurePolicyEvaluationDetails | AllMetrics |
| Linux App Service | All Logs (Category Group) | AllMetrics |
| App Service Plan | — | AllMetrics |
| Azure Storage Blob Service | StorageRead, StorageWrite, StorageDelete | Capacity, Transaction |

### Data Flow

The telemetry collection process follows the flow below:

```text
Azure Resource
      │
      ▼
Diagnostic Settings
      │
      ▼
Log Analytics Workspace
      │
      ▼
KQL Queries
      │
      ▼
Azure Monitor Alerts
```

This architecture provides a single location for analysing platform activity while allowing Azure Monitor to evaluate both metrics and log data against predefined alert conditions.

---

## Azure Monitor Metric Alerts

Azure Monitor Metric Alerts evaluate Azure platform metrics that are collected directly from supported Azure resources. These alerts provide near real-time monitoring of resource health and performance without requiring KQL queries.

The CloudHelp platform currently uses Metric Alerts to monitor the Linux App Service and App Service Plan.

The following Metric Alerts are configured:

| Alert | Monitored Resource | Purpose |
|--------|--------------------|---------|
| HTTP 5xx Responses | Linux App Service | Detects server-side application errors. |
| High CPU Utilisation | App Service Plan | Detects sustained periods of high processor usage. |
| High Memory Utilisation | App Service Plan | Detects sustained periods of high memory usage. |

Metric Alerts are configured to evaluate Azure platform metrics at regular intervals and trigger when predefined thresholds are exceeded.

### Benefits

Using Metric Alerts provides several advantages:

- Near real-time evaluation of Azure platform metrics.
- No requirement to write or maintain KQL queries.
- Low operational overhead.
- Native integration with Azure Monitor and Action Groups.

Metric Alerts are best suited to monitoring resource performance, availability and utilisation.

---

## Azure Monitor Log Alerts

Azure Monitor Log Alerts evaluate Kusto Query Language (KQL) queries against data stored within the Log Analytics Workspace. Unlike Metric Alerts, Log Alerts allow complex conditions to be detected by analysing diagnostic logs collected from Azure resources.

The CloudHelp platform currently uses a Scheduled Query Rule to monitor failed Azure Key Vault requests.

| Alert | Data Source | Purpose |
|--------|-------------|---------|
| Failed Key Vault Requests | AzureDiagnostics | Detects failed requests made against Azure Key Vault. |

The alert executes a KQL query at scheduled intervals. When the query returns one or more matching results, Azure Monitor triggers the associated Action Group and sends an email notification.

### Benefits

Log Alerts provide greater flexibility than Metric Alerts by allowing telemetry to be filtered, correlated and analysed using Kusto Query Language.

Typical use cases include:

- Security event detection.
- Authentication failures.
- Resource-specific diagnostic events.
- Custom operational monitoring.
- Complex filtering and aggregation.

The Key Vault alert was validated by intentionally generating a failed secret request using the Azure CLI. The resulting diagnostic event was successfully ingested into the Log Analytics Workspace, detected by the scheduled KQL query and triggered an email notification through the configured Action Group, confirming that the complete monitoring pipeline operates as expected.

---

## Action Group

The CloudHelp platform uses a shared Azure Monitor Action Group to provide a central notification mechanism for all alert rules.

Rather than configuring notification settings individually for each alert, all Metric Alerts and Log Alerts are associated with the same Action Group. This simplifies alert management, promotes consistency across the monitoring platform and allows notification methods to be updated from a single location.

The current Action Group is configured to deliver email notifications when an alert is triggered.

### Current Alert Integration

The Action Group is currently linked to the following alert rules:

| Alert | Alert Type |
|--------|------------|
| HTTP 5xx Responses | Metric Alert |
| High CPU Utilisation | Metric Alert |
| High Memory Utilisation | Metric Alert |
| Failed Key Vault Requests | Log Alert |

### Notification Flow

The alert notification process follows the workflow below:

```text
Azure Resource
      │
      ▼
Diagnostic Settings / Azure Metrics
      │
      ▼
Log Analytics Workspace
      │
      ▼
Azure Monitor Alert
      │
      ▼
Action Group
      │
      ▼
Email Notification
```

This design ensures that all monitoring events follow a consistent notification pipeline while allowing additional notification channels, such as Microsoft Teams, SMS or webhooks, to be introduced in the future without modifying individual alert rules.

### Validation

The Action Group configuration was successfully validated during development by generating a failed Azure Key Vault request. The corresponding Log Alert was triggered and an email notification was successfully delivered, confirming that the end-to-end notification workflow operates as expected.

---

## KQL Queries

Kusto Query Language (KQL) is used throughout the CloudHelp platform to analyse telemetry stored within the Log Analytics Workspace. KQL provides a powerful query language for filtering, aggregating and investigating diagnostic data collected from Azure resources.

The queries below represent the most commonly used operational queries for the current platform.

---

### View all available tables

Displays every table currently populated within the Log Analytics Workspace.

```kql
search *
| summarize Count = count() by $table
| order by Count desc
```

---

### Recent Key Vault Activity

Displays recent Azure Key Vault operations.

```kql
AzureDiagnostics
| where ResourceProvider == "MICROSOFT.KEYVAULT"
| project TimeGenerated, OperationName, httpStatusCode_d, ResultSignature
| order by TimeGenerated desc
```

---

### Recent App Service Requests

Displays recent HTTP requests processed by the Linux App Service.

```kql
AppServiceHTTPLogs
| order by TimeGenerated desc
```

---

### HTTP Status Code Summary

Summarises application requests by HTTP status code.

```kql
AppServiceHTTPLogs
| summarize Requests = count() by ScStatus
| order by Requests desc
```

---

### Most Requested URLs

Displays the most frequently requested application endpoints.

```kql
AppServiceHTTPLogs
| summarize Requests = count() by CsUriStem
| order by Requests desc
```

---

### Failed Requests

Displays all HTTP 4xx and 5xx responses.

```kql
AppServiceHTTPLogs
| where ScStatus >= 400
| project TimeGenerated, ScStatus, CsMethod, CsUriStem
| order by TimeGenerated desc
```

---

### Recent Platform Events

Displays recent Linux App Service platform events.

```kql
AppServicePlatformLogs
| order by TimeGenerated desc
```

---

### Storage Operations

Displays recent Blob Storage activity.

```kql
StorageBlobLogs
| order by TimeGenerated desc
```

---

### Learning Outcomes

During the implementation of the CloudHelp monitoring platform, several important observations were made:

- Some Azure resources store diagnostic data in dedicated Log Analytics tables rather than the shared `AzureDiagnostics` table.
- Azure Key Vault events are written to the `AzureDiagnostics` table.
- Linux App Service telemetry is written to dedicated tables such as `AppServiceHTTPLogs` and `AppServicePlatformLogs`.
- KQL provides a consistent method of analysing telemetry regardless of the originating Azure resource.
- KQL queries form the basis of Azure Monitor Scheduled Query Alerts.

---

## Testing and Validation

The CloudHelp monitoring platform was validated by generating real platform activity and confirming that telemetry was successfully collected, analysed and used to trigger Azure Monitor alerts.

The validation process was performed incrementally, ensuring that each stage of the monitoring pipeline operated as expected before progressing to the next.

### Log Collection

Diagnostic Settings were configured for the supported Azure resources and verified by generating activity within each service.

Validation confirmed that diagnostic events were successfully ingested into the Log Analytics Workspace and written to the appropriate Log Analytics tables.

### KQL Validation

Kusto Query Language (KQL) queries were used to verify that diagnostic events were being collected correctly.

Validation activities included:

- Confirming diagnostic data was present within the expected Log Analytics tables.
- Verifying Azure Key Vault operations.
- Reviewing Linux App Service HTTP requests.
- Monitoring Blob Storage operations.
- Confirming platform metrics and diagnostic logs were being collected.

### Alert Validation

Each alert was tested using appropriate methods to verify that Azure Monitor correctly evaluated the configured conditions.

| Alert | Validation Method |
|--------|-------------------|
| HTTP 5xx Responses | Generated HTTP requests against the Linux App Service. |
| High CPU Utilisation | Alert configuration verified. |
| High Memory Utilisation | Alert configuration verified. |
| Failed Key Vault Requests | Requested a non-existent secret using Azure CLI to generate a failed request. |

### End-to-End Validation

The failed Azure Key Vault request provided a complete end-to-end validation of the monitoring platform.

The validation confirmed that:

1. Azure Key Vault generated a diagnostic event.
2. Diagnostic Settings forwarded the event to Log Analytics.
3. The event was stored within the `AzureDiagnostics` table.
4. The scheduled KQL query detected the failed request.
5. Azure Monitor triggered the configured Log Alert.
6. The Action Group generated an email notification.

This confirmed that the complete monitoring and alerting pipeline was functioning correctly from telemetry collection through to administrator notification.

### Lessons Learned

Several practical observations were made during implementation:

- Not all Azure services write diagnostic data to the `AzureDiagnostics` table.
- Linux App Service creates dedicated Log Analytics tables such as `AppServiceHTTPLogs` and `AppServicePlatformLogs`.
- Diagnostic Settings determine which telemetry is forwarded to Log Analytics.
- KQL provides an effective method for validating telemetry ingestion and troubleshooting monitoring configurations.
- Testing monitoring configurations is as important as configuring them, ensuring alerts operate as expected before relying on them in production.

---

## Future Improvements

The current monitoring implementation provides a solid operational foundation for the CloudHelp platform. As additional Azure services are introduced, the monitoring solution will continue to evolve to provide greater visibility, improved diagnostics and more advanced alerting capabilities.

Planned enhancements include:

- Integrate Azure Application Insights for application performance monitoring.
- Develop Azure Monitor Workbooks to provide operational dashboards and visualisations.
- Expand Azure Monitor Alerts to cover additional Azure resources and application services.
- Implement Microsoft Defender for Cloud recommendations and security monitoring.
- Introduce Microsoft Teams or webhook notifications alongside email alerts.
- Develop reusable KQL query libraries for common operational and troubleshooting tasks.
- Create custom Azure Monitor dashboards for platform health and performance monitoring.
- Introduce availability monitoring and synthetic transaction testing for the application.
- Review alert thresholds as the platform grows to minimise false positives while maintaining operational awareness.

---