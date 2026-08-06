# Constitutional State Machine

| Field | Value |
|---|---|
| Status | COMPLETE — legal states and transitions for constitutional objects |
| Date | 2026-08-06 |
| Authority | Companion to `constitutional-enforcement-architecture.md` (Section 5) and `constitutional-object-model.md`. |
| Constraints honored | READ-ONLY. Documentation only. No implementation. |
| Purpose | Define the legal states for constitutional rules and the legal transitions between them. |

---

## 1. States

| State | Meaning | Binding effect |
|---|---|---|
| **Draft** | Written; not constitutional. | Binds nothing. |
| **Proposed** | Submitted for ADR approval; under review. | Binds nothing; pending a decision. |
| **Approved** | Accepted as constitutional; not yet bound to verification. | Governs in principle; no enforcement attached. |
| **Active** | Binding; linked to constraint, evidence, and verification. | Governs all future work; verification attached. |
| **Verified** | Active and last verification passed. | Governs; usable at gates. |
| **Violated** | Active and last verification failed, or a violation was detected. | Governs but is in breach; may not bind a gate. |
| **Suspended** | Active obligations deferred by a recorded Exception. | Obligations deferred; may not bind a gate. |
| **Deprecated** | Superseded; creates no new obligations; history preserved. | Binds nothing new; existing obligations carry through replacement (T6). |
| **Archived** | Retired; immutable history. | Terminal for normal use; never authoritative for implementation (closure decision §4). |

---

## 2. Transition table

| # | From | To | Condition | Authority |
|---|---|---|---|---|
| 1 | Draft | Proposed | Submitted to the ADR board. | Owner (D1) |
| 2 | Proposed | Approved | ADR accepted. | ADR board |
| 3 | Proposed | Draft | Rejected or returned for revision. | ADR board |
| 4 | Approved | Active | Verification bound; gate assigned. | ADR board + owner of verification (D4) |
| 5 | Approved | Deprecated | Superseded before activation. | ADR board |
| 6 | Active | Verified | Verification passed. | Verification (D4) |
| 7 | Active | Violated | Verification failed or violation detected. | Verification (D4) |
| 8 | Verified | Violated | Subsequent verification failed. | Verification (D4) |
| 9 | Violated | Verified | Remediation passed re-verification. | Verification (D4) |
| 10 | Violated | Suspended | Exception granted with scope and expiry. | ADR board / recorded authority (D6) |
| 11 | Violated | Deprecated | Replaced by ADR while violated. | ADR board |
| 12 | Suspended | Active | Exception expired or lifted. | Authority that granted the exception |
| 13 | Suspended | Deprecated | Replaced while suspended. | ADR board |
| 14 | Deprecated | Archived | Retirement executed; archive manifest recorded. | Owner (D1/D7) |
| 15 | Archived | (none) | Terminal. Revival requires a new ADR (a new object). | — |

---

## 3. State machine

```
                  +--------------+
                  |    Draft     |<-----------------+
                  +--------------+                  |
                        | submit                    | reject / revise
                        v                           |
                  +--------------+                  |
                  |   Proposed   |------------------+
                  +--------------+
                        | accept
                        v
                  +--------------+
                  |   Approved   |-- supersede before activation --> +-------------+
                  +--------------+                                    | Deprecated  |
                        | bind verification                          +------+------+
                        v                                                  | retire
                  +--------------+                                          v
                  |    Active    |                                    +-------------+
                  +--------------+                                    |  Archived   |
                   |     |       |                                     +-------------+
       verification|     |       | verification
        passed     |     |       | failed
                   v     v       v
              +-------+  +------------+
              |Verified|  | Violated   |
              +-------+  +------------+
                            |     |     |
                 remediation|     |     | exception
                            |     |     v
                            |     | +------------+
                            |     | | Suspended  |
                            |     | +------------+
                            |     |      | exception expired/lifted
                            |     |      v
                            |     |  +-------+
                            |     +->| Active |
                            |        +-------+
                            | replaced while violated/suspended
                            v
                        Deprecated
```

---

## 4. Rules of the state machine

1. **No binding without Active.** A rule in Draft, Proposed, or Approved binds nothing. Activation is the moment a rule acquires enforcement.
2. **No gate on a breach.** A rule in **Violated** or **Suspended** may not bind a Gate (D5): no action may pass a gate on a violated or suspended rule.
3. **Exceptions are recorded and expiring.** The Suspended state is entered only through a recorded Exception with scope and expiry (D6); a Suspended rule without an exception record is a state violation.
4. **No silent retirement.** An object cannot reach Archived without passing through Deprecated and recording an archive manifest (T6, T8). Archived objects are immutable.
5. **Archived is terminal.** Normal use of an Archived rule is impossible; revival requires a new ADR creating a new object. History is never edited, only extended.
6. **Every transition has an authority.** A transition without a recorded authority (D6) is not a transition; it is an undocumented state change and therefore a violation of the state machine.
7. **State is observable.** The current state of every constitutional object is held in the Architecture State Registry (D7). A claim about a rule's state that the registry does not support is itself a violation.

---

## 5. Application to non-rule objects

Constraints, evidence sources, verification procedures, gates, decisions, exceptions, and ADRs follow the same state machine, with the verification-specific states (Verified/Violated) applying to constraints and verification procedures, and decisions/exceptions moving straight from Approved to Active to Archived (a decision is recorded, becomes active on record, and is archived when superseded). The uniform machine ensures that no constitutional object exists outside a legal state.
