# PQ-1 / EC-8 — Final Confirmation (Pre-ADR)

> Pre-ADR audit artifact. Resolves the earlier PQ-1 EC-8 "subscriber mismatch" suspension (ADR-INDEX PQ-1). Input to ADR-003+ drafting.

| Field | Value |
|---|---|
| Status | CONFIRMED — Candidate A EXPLICIT in source |
| Date | 2026-08-10 |
| Constraint | No source change (verify-only). ADR-003+ is the Board's action, not this audit. |

---

## 1. Question

Which Candidate does the model surface state for PQ-1 EC-8 (Document aggregate → subscriber/relationship event)?

- **Candidate A:** Document aggregate subscribes to events; relationship/subscriber events are captured through the subscriber endpoint of the Document model (unified endpoint on one aggregate).
- **Candidate B:** A separate relationship aggregate subscribes (split subscribers across multiple aggregates/endpoints).

## 2. Findings

1. `domain-model/object-model.md` §2.3 (EC-8) **line 107** states the Document aggregate provides the subscriber endpoint and that subscriber events reach the Document aggregate — **Candidate A is explicit in source**, contradicting the earlier "subscriber mismatch" inference (document subs page vs subject rules page).

2. The EC-8 candidate is driven by the P3/I5 *contract definition* layer (`enforcement-architecture.md` §1). The contract layer registers the Document model with a unified subscriber endpoint; there is **no separate model that subscribes** in the contract surface.

3. Consequently:
   - Document aggregate = `subscriber` endpoint source of truth (Candidate A).
   - No new domain model is required — the earlier "aggregate B" hypothesis is rejected.
   - No amendment to R1/R2 text is required — the candidate is a *confirmation*, not a contradiction.

## 3. What this confirms for ADR drafting

- ADR-003+ (document-scope EC-8) records: **Candidate A**, as explicitly stated in `object-model.md` §2.3 line 107.
- The earlier ADR-INDEX PQ-1 suspension (`EC-8 subscriber mismatch`) is resolved: no mismatch exists in the authoritative source.
- Phase 4 remains blocked by the same Board decision path as C6 (the formal ADR series and the RLS freeze).

## 4. References

- `domain-model/object-model.md` §2.3 line 107 (Candidate A explicit)
- `docs/architecture-enforcement-model.md` §1 (contract definition layer)
- `domain-model/summary.md` (documents aggregate summary)
- Prior: `ADR-INDEX.md` PQ-1 row; `EC8-candidate-recommendation.md`; `EC8-blocking-discovery.md` (finding — superseded on PQ-1 Candidate by this confirmation)
