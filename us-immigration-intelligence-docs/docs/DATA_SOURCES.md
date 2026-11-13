# Government Data Sources and Data Preparation

All substantive immigration reference material is drawn from official U.S. government sources. The portfolio uses **curated samples** for a repeatable demonstration; it does not claim real-time synchronization of all government datasets.

| Data | Official source | Ingestion | Demo scope |
| --- | --- | --- | --- |
| USCIS policy (EB-1, EB-2, EB-3, family-based) | [USCIS Policy Manual](https://www.uscis.gov/policy-manual) | PDF → Agentforce Data Library | Selected chapters |
| USCIS instructions (I-130, I-140, I-485, I-765, I-129, N-400) | [USCIS Forms](https://www.uscis.gov/forms/all-forms) | PDF → Agentforce Data Library | Six form instruction PDFs |
| Visa Bulletin | [Department of State](https://travel.state.gov/content/travel/en/legal/visa-law0/visa-bulletin.html) | CSV → `Visa_Bulletin__c` | November 2026; 30 rows |
| Filing fees | [USCIS G-1055](https://www.uscis.gov/g-1055) | CSV → `Immigration_Fee__c` | 23 selected fee records |
| Civil documents | [State Department Reciprocity](https://travel.state.gov/content/travel/en/us-visas/Visa-Reciprocity-and-Civil-Documents-by-Country.html) | CSV → `Country_Requirement__c` | Four countries; 12 rows |
| Historical processing times | [USCIS historical series](https://egov.uscis.gov/processing-times/historic-pt) | CSV → `Immigration_Statistic__c` | 42 records; FY2021–FY2026 series |
| Regulatory publications | [Federal Register API](https://www.federalregister.gov/developers/documentation/api/v1) | On-demand Apex REST callout | Latest matching documents per keyword |

## Grounding and provenance

The Agentforce Data Library was configured with ten USCIS PDFs and reached **Ready to Use**. Salesforce generated a beta retrieval action, used by the Policy, Visa and Application specialists. Testing showed retrieval of relevant USCIS policy and form instructions.

Retain original `uscis.gov`, `travel.state.gov`, and `federalregister.gov` URLs in any datasets or metadata. Automatically generated Data Library citations can point to temporary Salesforce-managed storage URLs; original publisher URLs are preferred in user-facing responses when verified.

## Important boundaries

- **Visa Bulletin dates:** a November 2026 snapshot, not a live determination of current visa availability.
- **Filing fees:** a selected G-1055 snapshot; applicability depends on filing method and category.
- **Statistics:** historical processing times, not current processing-time estimates, approval probabilities, or case predictions.
- **Regulatory search:** a limited set of Federal Register hits; missing results do not establish that no relevant new rules exist.
- **No source documents/records are included by Salesforce metadata retrieval alone.** Reproduction requires separately provisioning source files and CSV records.
