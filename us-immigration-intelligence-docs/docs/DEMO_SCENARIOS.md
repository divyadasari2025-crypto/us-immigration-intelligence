# Demo Scenarios and Validation

Use Agentforce Builder **Live Test** and Interaction Trace to demonstrate action execution. Answers alone are not evidence of grounding: confirm that the relevant retrieval action actually ran.

| Demo | Natural-language question | Expected system behavior |
| --- | --- | --- |
| Pathway research | “I have a master's in computer science and work in AI. What employment-based green card pathways should I research?” | Policy / Visa retrieval with sourced, qualified explanations |
| Forms | “My employer will sponsor me for a green card. What's Form I-140 for?” | Application Agent retrieves I-140 instructions |
| Combined visa and fees | “I'm an EB-2 applicant born in India. What does the November 2026 Visa Bulletin say, and what fees apply to Form I-140?” | Orchestrator calls Visa and Fees specialists and synthesizes outputs |
| Country documents | “What Indian birth and police documents might I need for a U.S. immigrant visa?” | Country Research Flow retrieves relevant records |
| Statistics | “How have historical I-485 processing times changed from 2021 to 2025?” | Statistics Flow retrieves fiscal-year values and describes differences |
| Regulatory research | “I'm on H-1B. Have there been recent federal rule proposals or changes that could affect me?” | Policy Agent invokes Federal Register Apex action, distinguishes proposed/final rules |

## Evidence captured during development

- Policy Agent retrieved the uploaded EB-2 NIW PDF and answered the three-prong question.
- Visa & Green Card Agent returned the stored November 2026 EB-2 India Final Action Date of November 1, 2013.
- The first Visa Bulletin Flow test failed because the Agentforce execution user lacked record access; it worked after permissions were corrected.
- Fees, Country Research, Application, and Statistics specialists were tested and activated.
- Supervisor Mode trace showed **Visa & Green Card** and **Fees & Processing** specialists both invoked for the same query, with a combined response.
- The Policy Agent successfully called the Federal Register API; the Apex action was enhanced to include abstract, effective date, and document number fields.

## Recommended screenshots to add

Save sanitized screenshots under `us-immigration-intelligence-docs\demo screenshots`:

1. `architecture-orchestrator.png` — six connected agents in Builder.
2. `supervisor-trace.png` — two specialist calls in one conversation.
3. `data-library.png` — ten uploaded sources, Ready to Use.
4. `visa-bulletin-flow.png` — Get Records filters and successful Debug.
5. `federal-register-action.png` — Apex action and returned document details.


