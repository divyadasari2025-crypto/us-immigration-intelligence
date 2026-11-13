# Setup and Reproduction Guide

## Prerequisites

- Salesforce Developer Edition with the Agentforce and Data 360 features used in the demo.
- Salesforce CLI and a Salesforce DX-compatible editor.
- Appropriate Salesforce permissions to retrieve/deploy metadata, configure Agentforce, and manage Named Credentials.

## Source checkout

```bash
git clone https://github.com/divyadasari2025-crypto/us-immigration-intelligence.git
cd us-immigration-intelligence
sf org login web --alias ImmigrationDev --set-default
```

## Metadata

The project stores retrieved Salesforce metadata under `force-app/main/default/`. Inspect the actual metadata before deploying: Agentforce metadata types and org feature entitlements can differ between orgs.

To validate a deployment to a suitably provisioned org:

```bash
sf project deploy validate --source-dir force-app --target-org ImmigrationDev
```

A successful metadata deployment **does not** restore uploaded Data Library PDFs, CRM data records, user-specific permission assignments, or external credential secrets.

## Manual provisioning needed for a fresh org

1. Enable and configure Agentforce and Data 360 for that org.
2. Upload the selected USCIS PDFs to an Agentforce Data Library and make sure its generated retrieval action is available.
3. Load the curated Visa Bulletin, Fees, Country Requirement, and Immigration Statistic CSV records into the corresponding custom objects.
4. Configure `Federal_Register` Named Credential with base URL `https://www.federalregister.gov` and a compatible no-authentication external credential/principal.
5. Assign the Agentforce execution user the required object, field, record, Apex-class and external-credential permissions.
6. Connect the Data Library action and Flows to their specialist agents, and confirm connected-subagent references and version states.
7. Validate with Live Test, then commit and activate agent versions as supported.

## Security

Never commit Salesforce authentication data, credential secrets, signed Data Library file links, personal immigration data, or raw debug logs with account identifiers. Keep `*.csv` files derived from public government tables clearly labelled by publication/reporting period.

## Known limitations

- Agentforce and Data 360 entitlements and feature menus may vary between Developer Edition orgs.
- URL trust policy may redact some government URLs in agent answers.
- Source documents and CRM records are provisioned separately from Salesforce metadata.
- This repo does not document a live public-facing Experience Cloud deployment.
