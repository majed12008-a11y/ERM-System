# ADR-<NNN> — <Short Title>

> This template is **binding** for every ADR in the formal series (ADR-001 §2.2; ADR-002 §7).
> An ADR is part of the series only if it follows this template and is registered in `docs/architecture/adr/ADR-INDEX.md`.
> Fill in every field and every section; do not leave placeholders in an APPROVED ADR.

| Field | Value |
|---|---|
| Number | ADR-<NNN> |
| Status | PROPOSED \| APPROVED \| SUPERSEDED |
| Date | YYYY-MM-DD |
| Author | <role or person> |
| Provenance | <ADR-002 clause; transition-plan phase/task; governance-freeze section> — every ADR must trace to the constitution |
| Constraints honored | <what is NOT changed by this ADR; read-only scope notes> |
| Purpose | <one-sentence intent> |
| Supersedes | <nothing, or ADR-XXX> |

---

## 1. Context

Why this decision exists. What problem the constitution or the system presents that this ADR addresses. Cite ADR-002 elements (P/I/G/EC identifiers) where relevant.

## 2. Decision

The decision itself, stated as the binding outcome. Use numbered subsections for multiple clauses. No ambiguity: a reader must be able to verify compliance.

## 3. Alternatives considered

What was rejected and why (brief). If no alternatives existed, say so explicitly. Not optional — the ADR board requires the decision rationale.

## 4. Consequences

1. Forward obligations created by this ADR.
2. What is now forbidden or deprecated.
3. Verification implications (how compliance with this ADR will be checked).

## 5. References

- `docs/architecture/adr/ADR-002-canonical-dataset-architecture.md` (constitution)
- Any other ADRs, transition-plan sections, or evidence documents this ADR depends on.
