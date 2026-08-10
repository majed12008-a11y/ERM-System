/*
 * هيكل اختبارات السجلات الدستورية (R1..R11) — اختبارات
 * بنيوية نقية (بدون قاعدة بيانات، بدون سلوك تنفيذي)
 * تتحقق فقط من سلامة الكتالوجات: الأعداد، التفرد،
 * التطابق مع المراجع. مرحلة الأولى: هيكل الاختبار فقط.
 */

import { describe, it, expect } from 'vitest';
import {
  CONSTITUTIONAL_ELEMENT_IDS,
  EXIT_CRITERION_IDS,
  CONSTITUTIONAL_STATE_IDS,
  AGGREGATE_IDS,
} from '../types';
import { REGISTRIES } from '../index';
import { CONSTITUTIONAL_RULES, RULE_REGISTRY } from '../rule.registry';
import { CONSTRAINTS_PRESENT, CONSTRAINT_GAP_COUNT, CONSTRAINT_REGISTRY } from '../constraint.registry';
import { EVIDENCE_ARTIFACTS, EVIDENCE_PRESENT, EVIDENCE_GAP_COUNT, EVIDENCE_REGISTRY } from '../evidence.registry';
import { VERIFICATION_RECORDS, VERIFICATION_REGISTRY } from '../verification.registry';
import { GATES, GATE_ELEMENT_ASSIGNMENTS, GATE_REGISTRY } from '../gate.registry';
import { DECISIONS, DECISION_REGISTRY } from '../decision.registry';
import { SEED_TRACKER_UNTRUSTED, EXECUTION_EVENTS, EXECUTION_REGISTRY } from '../execution.registry';
import { CONSTITUTIONAL_STATES, STATE_TRANSITIONS, STATE_REGISTRY } from '../architecture-state.registry';
import { KNOWN_PRECEDENTS, EXCEPTIONS, EXCEPTION_REGISTRY } from '../exception.registry';
import { AGGREGATES, AGGREGATE_TABLES, OWNERSHIP_REGISTRY } from '../ownership.registry';
import {
  CANONICAL_TERMS,
  ALLOWED_TERMS,
  DEPRECATED_TERMS,
  FORBIDDEN_TERMS,
  TERM_GATE,
  VOCABULARY_REGISTRY,
} from '../vocabulary.registry';

describe('Facade (index.ts)', () => {
  it('exposes all 11 registries in order R1..R11', () => {
    expect(REGISTRIES).toHaveLength(11);
    expect(REGISTRIES.map((r) => r.id)).toEqual([
      'R1', 'R2', 'R3', 'R4', 'R5', 'R6', 'R7', 'R8', 'R9', 'R10', 'R11',
    ]);
  });

  it('every registry declares an owning enforcement domain and authority', () => {
    for (const r of REGISTRIES) {
      expect(r.ownedBy).toMatch(/^D[1-8]$/);
      expect(r.traceability().length).toBeGreaterThan(0);
    }
  });
});

describe('R1 Rule Registry', () => {
  it('registers all 43 constitutional elements', () => {
    expect(CONSTITUTIONAL_RULES).toHaveLength(43);
    expect(CONSTITUTIONAL_ELEMENT_IDS).toHaveLength(43);
    expect(CONSTITUTIONAL_ELEMENT_IDS.filter((id) => /^P\d$/.test(id))).toHaveLength(9);
    expect(CONSTITUTIONAL_ELEMENT_IDS.filter((id) => /^I\d+$/.test(id))).toHaveLength(11);
    expect(CONSTITUTIONAL_ELEMENT_IDS.filter((id) => /^G\d+$/.test(id))).toHaveLength(13);
    expect(CONSTITUTIONAL_ELEMENT_IDS.filter((id) => /^EC\d+$/.test(id))).toHaveLength(10);
  });

  it('lists element ids exactly matching the constitutional catalogs, in P/I/G/EC order', () => {
    const ids = CONSTITUTIONAL_RULES.map((r) => r.id);
    expect(ids).toEqual([...CONSTITUTIONAL_ELEMENT_IDS]);
  });

  it('contains no duplicate element ids', () => {
    const ids = CONSTITUTIONAL_RULES.map((r) => r.id);
    expect(new Set(ids).size).toBe(ids.length);
  });

  it('keeps element type consistent with the id prefix', () => {
    const expectedType = (id: string) =>
      id.startsWith('P') ? 'Principle' : id.startsWith('I') ? 'Invariant' : id.startsWith('G') ? 'Governance' : 'Exit criterion';
    for (const rule of CONSTITUTIONAL_RULES) {
      expect(rule.type).toBe(expectedType(rule.id));
    }
  });

  it('every rule has a non-empty normative statement and a valid link record', () => {
    for (const rule of CONSTITUTIONAL_RULES) {
      expect(rule.rule.length).toBeGreaterThan(0);
      expect(['Mapped', 'Present', 'Present-Partial']).toContain(rule.constraintLink.status);
    }
  });

  it('is owned by D1 with a non-empty entries catalog', () => {
    expect(RULE_REGISTRY.id).toBe('R1');
    expect(RULE_REGISTRY.ownedBy).toBe('D1');
    expect(RULE_REGISTRY.entries.length).toBe(43);
  });
});

describe('R2 Constraint Registry', () => {
  it('registers 12 present constraints and a 31-element gap baseline', () => {
    expect(CONSTRAINTS_PRESENT).toHaveLength(12);
    expect(CONSTRAINT_GAP_COUNT).toBe(31);
  });

  it('the present set is exactly {I1, I11, EC1..EC10}', () => {
    const ids = CONSTRAINTS_PRESENT.map((c) => c.element).sort();
    expect(ids).toEqual([
      'EC1', 'EC10', 'EC2', 'EC3', 'EC4', 'EC5', 'EC6', 'EC7', 'EC8', 'EC9', 'I1', 'I11',
    ]);
  });

  it('is owned by D2', () => {
    expect(CONSTRAINT_REGISTRY.ownedBy).toBe('D2');
  });
});

describe('R3 Evidence Registry', () => {
  it('registers the 7 D3 evidence artifact types', () => {
    expect(EVIDENCE_ARTIFACTS).toHaveLength(7);
    const artifacts = EVIDENCE_ARTIFACTS.map((e) => e.artifact);
    expect(new Set(artifacts).size).toBe(artifacts.length);
    for (const e of EVIDENCE_ARTIFACTS) {
      expect(e.owningBody.length).toBeGreaterThan(0);
    }
  });

  it('registers 13 present evidence sources and a 30-element gap baseline', () => {
    expect(EVIDENCE_PRESENT).toHaveLength(13);
    expect(EVIDENCE_GAP_COUNT).toBe(30);
  });

  it('is owned by D3', () => {
    expect(EVIDENCE_REGISTRY.ownedBy).toBe('D3');
  });
});

describe('R4 Verification Registry', () => {
  it('registers the EC1..EC10 initial verification set', () => {
    expect(VERIFICATION_RECORDS).toHaveLength(10);
    expect(VERIFICATION_RECORDS.map((v) => v.id)).toEqual([...EXIT_CRITERION_IDS]);
  });

  it('classifies 7 Ready and 3 NeedsExtension', () => {
    expect(VERIFICATION_RECORDS.filter((v) => v.readiness === 'Ready')).toHaveLength(7);
    expect(VERIFICATION_RECORDS.filter((v) => v.readiness === 'NeedsExtension')).toHaveLength(3);
  });

  it('records no verification run (NotRegistered)', () => {
    for (const v of VERIFICATION_RECORDS) {
      expect(v.status).toBe('NotRegistered');
    }
  });

  it('is owned by D4', () => {
    expect(VERIFICATION_REGISTRY.ownedBy).toBe('D4');
  });
});

describe('R5 Gate Registry', () => {
  it('defines the 5 constitutional gates with zero element assignments', () => {
    expect(GATES).toHaveLength(5);
    expect(GATE_ELEMENT_ASSIGNMENTS).toHaveLength(0);
    for (const g of GATES) {
      expect(g.requiredVerification).toHaveLength(0);
    }
  });

  it('is owned by D5', () => {
    expect(GATE_REGISTRY.ownedBy).toBe('D5');
  });
});

describe('R6 Decision Registry', () => {
  it('records zero decisions (baseline)', () => {
    expect(DECISIONS).toHaveLength(0);
  });

  it('is owned by D6', () => {
    expect(DECISION_REGISTRY.ownedBy).toBe('D6');
  });
});

describe('R7 Execution Registry', () => {
  it('marks ops.seed_tracker provenance as untrusted (A1)', () => {
    expect(SEED_TRACKER_UNTRUSTED.source).toBe('ops.seed_tracker');
    expect(SEED_TRACKER_UNTRUSTED.status).toBe('Untrusted');
    expect(SEED_TRACKER_UNTRUSTED.disposition).toContain('rebuilt');
  });

  it('records zero execution events (baseline)', () => {
    expect(EXECUTION_EVENTS).toHaveLength(0);
  });

  it('is owned by D8', () => {
    expect(EXECUTION_REGISTRY.ownedBy).toBe('D8');
  });
});

describe('R8 Architecture State Registry', () => {
  it('defines 9 legal states matching the state id catalog', () => {
    expect(CONSTITUTIONAL_STATES).toHaveLength(9);
    expect(CONSTITUTIONAL_STATES.map((s) => s.id)).toEqual([...CONSTITUTIONAL_STATE_IDS]);
  });

  it('defines 15 legal transitions', () => {
    expect(STATE_TRANSITIONS).toHaveLength(15);
  });

  it('Archived is terminal with a single null-destination transition', () => {
    const archived = STATE_TRANSITIONS.filter((t) => t.from === 'Archived');
    expect(archived).toHaveLength(1);
    expect(archived[0].to).toBeNull();
  });

  it('every non-terminal transition has a defined destination and authority', () => {
    for (const t of STATE_TRANSITIONS.filter((t) => t.to !== null)) {
      expect(t.to).not.toBeNull();
      expect(t.authority.length).toBeGreaterThan(0);
    }
  });

  it('is owned by D7', () => {
    expect(STATE_REGISTRY.ownedBy).toBe('D7');
  });
});

describe('R9 Exception Registry', () => {
  it('records the I11 SECURITY DEFINER precedent as unrecorded and deferred', () => {
    expect(KNOWN_PRECEDENTS).toHaveLength(1);
    expect(KNOWN_PRECEDENTS[0].targetElement).toBe('I11');
    expect(KNOWN_PRECEDENTS[0].status).toBe('Unrecorded');
  });

  it('records zero sanctioned exceptions (baseline)', () => {
    expect(EXCEPTIONS).toHaveLength(0);
  });

  it('is owned by D6', () => {
    expect(EXCEPTION_REGISTRY.ownedBy).toBe('D6');
  });
});

describe('R10 Ownership Registry', () => {
  it('maps all 25 aggregates and exactly 234 tables', () => {
    expect(AGGREGATES).toHaveLength(25);
    expect(AGGREGATE_TABLES).toHaveLength(234);
    expect(AGGREGATES.map((a) => a.id)).toEqual([...AGGREGATE_IDS]);
  });

  it('contains no duplicate aggregate ids', () => {
    const ids = AGGREGATES.map((a) => a.id);
    expect(new Set(ids).size).toBe(ids.length);
  });

  it('assigns every table to exactly one defined aggregate', () => {
    const aggregateIds = new Set(AGGREGATES.map((a) => a.id));
    for (const t of AGGREGATE_TABLES) {
      expect(aggregateIds.has(t.aggregate)).toBe(true);
    }
  });

  it('contains no duplicate (schema, table) pairs', () => {
    const keys = AGGREGATE_TABLES.map((t) => `${t.schema}.${t.table}`);
    expect(new Set(keys).size).toBe(keys.length);
  });

  it('every table carries a non-empty ownership declaration', () => {
    for (const t of AGGREGATE_TABLES) {
      expect(t.ownership.length).toBeGreaterThan(0);
    }
  });

  it('is owned by D3 (ownership declared here, enforced by evidence domain)', () => {
    expect(OWNERSHIP_REGISTRY.ownedBy).toBe('D3');
  });
});

describe('R11 Vocabulary Registry', () => {
  it('publishes a non-empty final vocabulary, allowed, deprecated, and forbidden lists', () => {
    expect(CANONICAL_TERMS.length).toBeGreaterThan(0);
    expect(ALLOWED_TERMS.length).toBeGreaterThan(0);
    expect(DEPRECATED_TERMS.length).toBeGreaterThan(0);
    expect(FORBIDDEN_TERMS.length).toBeGreaterThan(0);
  });

  it('every deprecated term has a replacement and a transition period', () => {
    for (const t of DEPRECATED_TERMS) {
      expect(t.replacement && t.replacement.length).toBeGreaterThan(0);
      expect(t.transitionPeriod && t.transitionPeriod.length).toBeGreaterThan(0);
    }
  });

  it('defines the term gate with its constitutional anchors', () => {
    expect(TERM_GATE).toContain('G4');
    expect(TERM_GATE).toContain('G11');
    expect(TERM_GATE).toContain('EC5');
  });

  it('is owned by D1', () => {
    expect(VOCABULARY_REGISTRY.ownedBy).toBe('D1');
  });
});