# Constitutional Object Model

| Field | Value |
|---|---|
| Status | COMPLETE — conceptual object model of the constitution |
| Date | 2026-08-06 |
| Authority | Companion to `constitutional-enforcement-architecture.md` (Section 3). ADR-002 = constitutional; Baseline v2 = frozen; Governance Freeze = active. |
| Constraints honored | READ-ONLY. Documentation only. No implementation. Relationships only. |
| Purpose | Define the conceptual objects that exist inside the constitution and the relationships between them. |

---

## 1. Objects

| Object | Definition | Owning domain |
|---|---|---|
| **Constitutional Rule** | A normative statement that binds future work. Superclass of Principle, Invariant, Governance Rule, and Exit Criterion. | D1 Constitutional Definition |
| **Principle** | A permanent architectural value (P1–P9). | D1 |
| **Invariant** | An architectural rule that must always hold (I1–I11). | D1 |
| **Governance Rule** | A rule governing the process of the constitution itself (G1–G13). | D1 |
| **Exit Criterion** | A certification condition of the transition (EC1–EC10). | D1 / D4 |
| **ADR** | The change instrument by which objects are proposed, amended, replaced, or retired. | D1 |
| **Constraint** | The falsifiable operational predicate of a rule — "what does a violation look like?" | D2 |
| **Evidence** | The artifact a constraint examines. | D3 |
| **Verification** | The objective procedure evaluating evidence against a constraint, producing a binary result. | D4 |
| **Gate** | A binding process point that requires a verification result before an action proceeds. | D5 |
| **Decision** | A recorded outcome with authority (verification result, gate ruling, ADR approval, exception grant). | D6 |
| **Exception** | A sanctioned deviation with authority, scope, and expiry. | D6 |
| **Relationship** | A typed link between objects. | D7 (state) / T3 (traceability) |
| **Lifecycle** | The ordered history of an object's states. | D7 |
| **Ownership** | The single owning body of an object or artifact (P2, I4, G5). | D3 (registry) |
| **Traceability** | The backward chain from decision to evidence to constraint to rule (T3). | D4 / D8 |
| **Baseline** | The set of active constitutional objects (Baseline v2). | D1 |

---

## 2. Relationship map

```
                    Baseline (v2)
                        |
                is composed of
                        |
              +---------+---------+---------+
              |         |         |         |
          Principle  Invariant  Governance  Exit
              |         |         Rule    Criterion
              |         |           |         |
              +----+----+-----------+----+----+
                   |                      |
               Rule subtype              |
                   |                      |
               constrained by             |
                   v                      |
              Constraint --------------> owns (Rule)
                   |                      |
               examines                   |
                   v                      |
              Evidence <----- cited by - Traceability
                   |                          |
               evaluated by                   |
                   v                          |
              Verification ---- produces ---> Decision <---- grants ---- Exception
                   |                              |
               required by                        |
                   v                              |
                Gate ----------------------------> (gate ruling)
                   |
              halts / passes action
```

### 2.1 Rule relationships

| From | Relationship | To | Meaning |
|---|---|---|---|
| Principle | realizes | Invariant | A principle is realized by one or more invariants (e.g., P3 realizes I5). |
| Invariant | derives from | Principle | An invariant is a checkable derivative of a principle. |
| Rule | is constrained by | Constraint | Every rule has at least one operational predicate. |
| Rule | has | Ownership | Exactly one owning body (P2, I4, G5). |
| Rule | has | Lifecycle | Every rule passes through the state machine. |
| Rule | belongs to | Baseline | Active rules compose Baseline v2. |
| Rule | is superseded by | Rule | Via ADR; the old rule is deprecated, the new one traces back (T3). |

### 2.2 Chain relationships

| From | Relationship | To | Meaning |
|---|---|---|---|
| Constraint | constrains | Rule | The predicate that makes the rule falsifiable. |
| Constraint | examines | Evidence | The artifact(s) the predicate operates on. |
| Evidence | is examined by | Constraint | Evidence is inert without a constraint. |
| Evidence | has | Ownership | Single owning body (P2/I4/G5). |
| Verification | evaluates | Evidence | Against the Constraint. |
| Verification | produces | Decision | A binary, recorded outcome. |
| Gate | requires | Verification | A gate binds one or more verifications. |
| Gate | produces | Decision | The gate ruling, recorded. |
| Decision | may grant | Exception | With scope and expiry; never silent. |
| Exception | suspends | Rule | Moves the rule to Suspended for its duration. |
| ADR | proposes/amends/replaces/retires | any object | The only instrument that changes the constitution. |
| ADR | cites | Evidence, Traceability | An ADR must be traceable to its evidence basis (T3). |

### 2.3 Cross-cutting relationships

| From | Relationship | To | Meaning |
|---|---|---|---|
| Lifecycle | attaches to | every object | Every object has a state history. |
| Ownership | attaches to | every artifact/datum | Exactly one owner; shared kernels are declared, not defaulted (P2). |
| Traceability | traverses | Relationship | Decision → Evidence → Constraint → Rule (T3; EC8). |
| Relationship | requires | source + target | A link with no valid source and target is invalid. |

---

## 3. Object validity rules

1. A **Rule** with no **Constraint** is an assertion, not a rule (AEM §3.2: constraints missing for 31 of 43).
2. A **Constraint** with no **Evidence** is uncheckable (AEM: evidence missing for 30 of 43).
3. A **Verification** not registered before running does not exist (AEM: verification missing for 32 of 43).
4. A **Gate** with no required **Verification**, and a **Verification** with no **Gate**, are declarations (AEM: gates missing for 43 of 43).
5. A **Decision** without recorded **Authority** is a note, not a decision (AEM: decisions missing for 43 of 43).
6. An **Exception** not recorded in the Exception Registry is a violation, regardless of intent (I11 bypass precedent).
7. **Ownership** is declared, single, and enforced; a datum with two owners or none is an I4 violation.
8. **Traceability** runs backward to evidence; a decision that cannot be traced to its evidence fails T3.
9. **Archived** objects are immutable (T8) and never authoritative for implementation (closure decision §4).
10. The **Baseline** is the set of active objects; an object not in the Baseline binds nothing.

---

## 4. Relationship to the enforcement chain

The object model is the type system of the enforcement chain from `architecture-enforcement-model.md` §3:

```
Rule (P/I/G/EC)  →  Constraint  →  Evidence  →  Verification  →  Gate  →  Decision
```

Each arrow is a typed relationship (constrained by, examines, evaluated by, required by, produces). The cross-cutting objects (Ownership, Lifecycle, Traceability, Exception) attach to the chain without being part of it. The object model makes the AEM chain statically checkable: a chain with a missing object type is a structural violation of the constitution, independent of any run.
