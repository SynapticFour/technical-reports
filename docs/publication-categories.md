# Publication Categories

Taxonomy for classifying Synaptic Four Technical Reports. Set the `report-category` field in report front matter and the `category` field in `catalog.yaml`.

## Categories

### 1. Architecture Reports

**When to use:** Documenting system structure, component boundaries, data flows, and architectural decisions for a platform or major subsystem.

**Typical sections emphasised:** System Architecture, Design trade-offs, Deployment topology.

**Examples:** Ferrum Architecture, Mycelium Architecture, Secure Data Access Architectures.

**Audience:** Data architects, infrastructure teams, senior engineers.

---

### 2. Reference Implementations

**When to use:** Describing a working implementation of a standard, specification, or pattern that others can study or replicate.

**Typical sections emphasised:** Implementation, Deployment, Appendices with configuration.

**Examples:** DRS Implementation Guide, GA4GH Data Connect in Practice.

**Audience:** Research software engineers, standards implementers.

---

### 3. Standards Implementation Reports

**When to use:** Reporting experience implementing GA4GH or other open standards—conformance decisions, gaps discovered, recommendations for standards bodies.

**Typical sections emphasised:** Related Work, Implementation, Interoperability testing, recommendations.

**Examples:** GA4GH Data Connect in Practice, Crypt4GH Integration Patterns.

**Audience:** Standards bodies, interoperability engineers, consortium members.

---

### 4. Design Documents

**When to use:** Proposing or recording design decisions before or during implementation. May precede a full architecture report.

**Typical sections emphasised:** Problem Statement, alternatives considered, decision record.

**Examples:** API design for a new service, metadata schema design.

**Audience:** Engineering teams, collaborators.

**Note:** Design documents may remain at draft status longer than other categories. Publish when decisions are stable enough to be useful.

---

### 5. Benchmark Studies

**When to use:** Presenting reproducible performance measurements, comparisons, or scalability evaluations.

**Typical sections emphasised:** Performance Considerations, methodology, results tables.

**Examples:** Query latency across federated nodes, encryption overhead benchmarks.

**Audience:** Infrastructure teams, researchers evaluating platforms.

---

### 6. Deployment Case Studies

**When to use:** Describing a real-world deployment—context, configuration, outcomes, lessons learned.

**Typical sections emphasised:** Deployment, Limitations, lessons learned.

**Examples:** Lessons Learned Building Research Infrastructure.

**Audience:** Research organisations, operations teams.

---

### 7. Security Analyses

**When to use:** Threat models, security architecture, control implementations, and compliance-relevant analysis.

**Typical sections emphasised:** Security Considerations, threat model, audit findings.

**Examples:** Secure Data Access Architectures.

**Audience:** Security officers, compliance teams, infrastructure architects.

**Note:** Redact sensitive deployment details. Security reports may have restricted review before publication.

---

### 8. Interoperability Guides

**When to use:** Practical guidance for connecting systems via standard APIs, schemas, or protocols.

**Typical sections emphasised:** Implementation, appendices with API examples, troubleshooting.

**Examples:** DRS Implementation Guide, Federated Omics Infrastructure Patterns.

**Audience:** Integration engineers, partner technical teams.

---

### 9. Research Infrastructure Reports

**When to use:** Broad reports on research platform strategy, data management philosophy, or infrastructure programmes.

**Typical sections emphasised:** Background, architecture, governance, FAIR alignment.

**Examples:** FAIR-by-Design Genomics Platforms, Federated Omics Infrastructure Patterns.

**Audience:** Research leaders, funding agencies, data stewards.

---

### 10. Position Papers

**When to use:** Articulating a technical or strategic position on standards, approaches, or industry direction. Less implementation detail, more argument and evidence.

**Typical sections emphasised:** Introduction, Related Work, argument, recommendations.

**Examples:** Open Standards for Translational Research.

**Audience:** Standards bodies, policy audiences, research leadership.

---

## Choosing a Category

| Question | If yes → consider |
|----------|-------------------|
| Is the primary contribution a system design? | Architecture Report |
| Is there runnable code demonstrating a standard? | Reference Implementation |
| Does it feed back to a standards body? | Standards Implementation Report |
| Is it a pre-implementation decision record? | Design Document |
| Are measurable results the main contribution? | Benchmark Study |
| Does it describe a specific deployment? | Deployment Case Study |
| Is security the central topic? | Security Analysis |
| Is it a how-to for integration? | Interoperability Guide |
| Is it strategic breadth over depth? | Research Infrastructure Report |
| Is it an argued position? | Position Paper |

Reports may span categories. Choose the **primary** contribution. Note secondary categories in keywords or abstract.

## Related Documents

- [future-reports.md](future-reports.md)
- [journal-conference-roadmap.md](journal-conference-roadmap.md)
