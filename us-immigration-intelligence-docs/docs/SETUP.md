# Setup and Reproduction Guide

## Prerequisites

- Salesforce Developer Edition with the Agentforce and Data 360 features used in the demo.
- Salesforce CLI and a Salesforce DX-compatible editor.
- Appropriate Salesforce permissions to retrieve/deploy metadata, configure Agentforce, and manage Named Credentials.
- Salesforce CLI Agent plugin for Data Library commands: `sf plugins install @salesforce/plugin-agent`.

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

## Agentforce Data Library: deployment to another org

The existing library is **US Immigration Policy Knowledge** with `sourceType: SFDRIVE` and `indexMode: ENHANCED`. Its configuration was exported for reference to `us-immigration-intelligence-docs/docs/DATA_LIBRARY_CONFIG.json`. This export is **not** an automatically deployable metadata package. Review it and remove org-specific identifiers before publishing it.

Do not run creation commands against the working source org. Use a separate, appropriately provisioned target org.

1. Install or verify the Agent plugin and sign into the **target** org:

   ```powershell
   sf plugins install @salesforce/plugin-agent
   sf org login web --alias TARGET_ORG
   sf agent adl create --help
   ```

2. Create the SFDRIVE library with enhanced indexing. Replace `ACTUAL_DEVELOPER_NAME` with the `developerName` recorded in the sanitized configuration export (or choose a new unique valid API name for the target org):

   ```powershell
   sf agent adl create --target-org TARGET_ORG --name "US Immigration Policy Knowledge" --developer-name ACTUAL_DEVELOPER_NAME --source-type sfdrive --index-mode enhanced
   ```

3. List libraries in the target org and record the **new** library ID:

   ```powershell
   sf agent adl list --target-org TARGET_ORG
   ```

4. Upload the **ten PDFs actually used in the source library** from `us-immigration-intelligence-docs/Uploaded files for Data library and excel records/` using their exact filenames. Example for the first PDF (run from the repository root):

   ```powershell
   sf agent adl upload --target-org TARGET_ORG --library-id TARGET_LIBRARY_ID --file "us-immigration-intelligence-docs/Uploaded files for Data library and excel records/USCIS_EB2_Policy_Chapter5.pdf"
   ```

   Repeat for the other nine PDFs identified in the source library's file inventory. The repository contains additional PDFs that should **not** automatically be assumed to belong to this ten-document library. For subsequent additions to a fully provisioned library, inspect `sf agent adl file add --help`.

5. Verify ingestion and indexing:

   ```powershell
   sf agent adl status --target-org TARGET_ORG --library-id TARGET_LIBRARY_ID --include-artifacts
   sf agent adl file list --target-org TARGET_ORG --library-id TARGET_LIBRARY_ID
   ```

   Confirm the library reaches a ready/indexed state and that the expected ten documents are present.

6. In the target org, inspect and reconnect the generated retrieval action (source org: `File_US_Immigration_Policy_Knowledge`) to the **new** library/retriever. The new library and retriever IDs are org-specific; do not reuse source IDs. Validate grounding responses in Agentforce before activating agents.

**Scope:** Salesforce DX source retrieval does not package or migrate Data 360 index contents. The commands above recreate the source-backed library in the target org; target-org entitlements and the Agent plugin command surface may vary. Salesforce CLI command reference: https://github.com/salesforcecli/plugin-agent#sf-agent-adl-create

## Manual provisioning needed for a fresh org

1. Enable and configure Agentforce and Data 360 for that org.
2. Recreate and populate the SFDRIVE/ENHANCED library as described above; reconnect its generated retrieval action.
3. Load the curated Visa Bulletin, Fees, Country Requirement, and Immigration Statistic CSV records into the corresponding custom objects.
4. Configure `Federal_Register` Named Credential with base URL `https://www.federalregister.gov` and a compatible no-authentication external credential/principal.
5. Assign the Agentforce execution user the required object, field, record, Apex-class and external-credential permissions.
6. Connect the Data Library action and Flows to their specialist agents, and confirm connected-subagent references and version states.
7. Validate with Live Test, then commit and activate agent versions as supported.

## Security

Never commit Salesforce authentication data, credential secrets, signed Data Library file links, personal immigration data, or raw debug logs with account identifiers. Sanitize `DATA_LIBRARY_CONFIG.json` before committing: remove internal Salesforce record IDs, retriever/index IDs, storage URLs, and other tenant-specific identifiers unless they are clearly necessary and safe to share. Keep `*.csv` files derived from public government tables clearly labelled by publication/reporting period.

## Known limitations

- Agentforce and Data 360 entitlements and feature menus may vary between Developer Edition orgs.
- URL trust policy may redact some government URLs in agent answers.
- Source documents and CRM records are provisioned separately from Salesforce metadata.
- This repo does not document a live public-facing Experience Cloud deployment.
