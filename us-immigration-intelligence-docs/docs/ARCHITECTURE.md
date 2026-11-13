# Solution Architecture

## Architectural pattern

The Salesforce **US Immigration Intelligence Orchestrator** uses Agentforce connected subagents in **Supervisor Mode**. It routes a request to the relevant specialist or specialists, receives their findings, and produces a consolidated response. Unlike handoff routing, the orchestrator can invoke multiple agents in the same turn.

The six specialist agents have separate responsibilities and access different retrieval actions. Some share the same USCIS Data Library; retrieval overlap is intentional, but routing instructions should constrain each specialist to its domain.

## Component map

| Layer | Component | Responsibility |
| --- | --- | --- |
| Conversation | Orchestrator | Intent recognition, delegation and synthesis |
| AI specialization | Six connected agents | Policy, Visa, Application, Fees, Country, Statistics |
| Unstructured retrieval | Agentforce Data Library / Data 360 | Retrieve USCIS PDF passages |
| Structured retrieval | Salesforce Flows | Query the four curated custom objects |
| External retrieval | `FederalRegisterService` and `FederalRegisterAction` Apex | Search government regulatory publications |
| External connectivity | Named Credential `Federal_Register` | Public Federal Register API callout |
| Source control | Salesforce DX | Retrieve and version metadata |

## Implemented custom objects

- `Visa_Bulletin__c`: preference category, chargeability area, chart type, cutoff date, status, source URL, bulletin month.
- `Immigration_Fee__c`: form number, filing method, fee amount, category, schedule reference, source URL.
- `Country_Requirement__c`: country, document type, issuing authority, availability, description, source URL.
- `Immigration_Statistic__c`: fiscal year, form type, category, metric, numerical value, reporting note, source URL.

Field API names may differ if an object was generated through Salesforce's spreadsheet import wizard; inspect retrieved metadata before deploying to a new org.

## Core flows

- `Get_Visa_Bulletin`: filters stored bulletin records by visa category, chargeability area and chart type.
- `Get_USCIS_Filing_Fees`: returns matching filing-fee records for a form.
- `Get_Country_Requirements`: returns country-specific document requirements.
- `Get_Immigration_Statistics`: returns historical records for a requested USCIS form.

The Agentforce execution user must have object, field and record-level read access to each queried dataset. This was a key implementation finding: a Flow can succeed in administrator Debug and return no records when run under the Agentforce user.

## Federal Register integration

1. Agent routes an immigration-regulation question to the Policy specialist.
2. The specialist calls the invocable `FederalRegisterAction`.
3. `FederalRegisterAction` calls `FederalRegisterService`.
4. The service performs an HTTP GET through `callout:Federal_Register`.
5. The returned JSON is summarized into publication title, document type, publication date, abstract, effective date (when available), document number, and official URL.
6. The agent distinguishes proposed rules, final rules and notices without assuming every publication is effective law.

## Implementation notes

- The initial Agent Router was configured for handoff through `DefaultEinsteinHyperClassifier` and `@utils.transition to @connected_subagent`.
- Supervisor orchestration was enabled by removing that classifier override and invoking connected specialists as tools.
- A combined EB-2 India Visa Bulletin plus I-140 fees question verified that two specialists were called and the results synthesized.
- Publication search is keyword-based and limited in result count. It is not a comprehensive legal change detection service.
