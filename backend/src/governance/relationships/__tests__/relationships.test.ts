/*
 * هيكل اختبارات نموذج العلاقات الدستورية — اختبارات بنيوية نقية
 * (بدون قاعدة بيانات، بدون سلوك تنفيذي) تتحقق من سلامة كتالوج
 * النماذج العشرة، ومفردات العلاقات، وترابطها المرجعي مع سجلات
 * المرحلة الأولى (R1..R11) ومواصفات المرحلة الثانية (SPEC-*)
 * قراءةً فقط. المرحلة الثالثة: هيكل الاختبار فقط — لا يُنفَّذ
 * أي تحليل أو تقييم أو إنفاذ.
 */
import { describe, it, expect } from 'vitest';
import {
  PHASE_3_SCOPE,
  RELATIONSHIPS_RUNTIME_PROHIBITED,
  CONSTITUTIONAL_OBJECT_KINDS,
  RelationshipKind,
  ConstitutionalObjectKind,
} from '../types';
import { RELATIONSHIP_KINDS } from '../relationship-kinds';
import { CONSTITUTIONAL_ID_RULES, OBJECT_IDENTITY_MODEL } from '../object-identity';
import { LAYER_ARCHITECTURE, LINKING_MODEL, LAYER_ARCHITECTURE_RULE, LAYER_EDGE_KINDS } from '../linking-model';
import { ENFORCEMENT_CHAIN, DEPENDENCY_GRAPH_MODEL, DEPENDENCY_EDGE_KINDS, DEPENDENCY_EDGE_DIRECTIONS } from '../dependency-graph';
import { TRACEABILITY_CHAIN, TRACEABILITY_MODEL } from '../traceability-graph';
import { AUTHORITY_RESOLUTIONS, AUTHORITY_RESOLUTION_MODEL } from '../authority-resolution';
import { EVIDENCE_OWNERSHIP_MODEL } from '../evidence-ownership';
import { VERIFICATION_DEPENDENCY_MODEL } from '../verification-dependency';
import { GATE_DEPENDENCY_MODEL } from '../gate-dependency';
import { DECISION_PROVENANCE_MODEL } from '../decision-provenance';
import { EXCEPTION_LINKAGE_MODEL } from '../exception-linkage';
import { CONSTITUTIONAL_METADATA_MODELS } from '../index';

/* --- مراجع قراءة فقط إلى المرحلة الأولى (السجلات) --- */
import { REGISTRIES } from '../../registries';
import { CONSTITUTIONAL_ELEMENT_IDS } from '../../registries/types';
import { EVIDENCE_ARTIFACTS } from '../../registries/evidence.registry';
import { VERIFICATION_RECORDS } from '../../registries/verification.registry';
import { GATES, GATE_ELEMENT_ASSIGNMENTS } from '../../registries/gate.registry';
import { DECISIONS } from '../../registries/decision.registry';
import { KNOWN_PRECEDENTS } from '../../registries/exception.registry';

/* --- مراجع قراءة فقط إلى المرحلة الثانية (المواصفات) --- */
import { ENFORCEMENT_SPEC_KINDS } from '../../specifications';

/* --- مرجع التحقق من المصدر: جداول constitutional-object-model.md §2.1–§2.3 --- */
/** أنواع مستهدفة خاصة في جداول المصدر (ليست صنف كائن مفرد). */
type SourceTarget = ConstitutionalObjectKind | 'any-object' | 'chain' | 'every';

/**
 * ترميز يدوي مرتجع من جداول المصدر (object-model §2.1–§2.3) إلى
 * مفردات النموذج. `inverted` يشير إلى أن صف المصدر يُعبَّر بالعلاقة
 * المعاكسة (مثال: "Rule has Lifecycle" ⇔ Lifecycle attaches-to Rule).
 * يغطي القرار LOW-2/§2.3: traverses يستهدف سلسلة القرارات (chain).
 * صف §2.3 "Relationship requires source + target" قاعدة وصفية وليست
 * علاقة قابلة للتسجيل — مستثنى عمدًا من الترميز.
 */
const RELATIONSHIP_SOURCE_FIXTURE: ReadonlyArray<{
  readonly section: '2.1' | '2.2' | '2.3';
  readonly source: string;
  readonly kind: RelationshipKind;
  readonly from: ConstitutionalObjectKind;
  readonly to: SourceTarget;
  readonly inverted?: true;
}> = [
  /* --- §2.1 rule relationships --- */
  { section: '2.1', source: 'Principle realizes Invariant', kind: 'realizes', from: 'Principle', to: 'Invariant' },
  { section: '2.1', source: 'Invariant derives from Principle', kind: 'derives-from', from: 'Invariant', to: 'Principle' },
  { section: '2.1', source: 'Rule is constrained by Constraint', kind: 'constrained-by', from: 'Rule', to: 'Constraint' },
  { section: '2.1', source: 'Rule has Ownership', kind: 'owns', from: 'Rule', to: 'Ownership' },
  { section: '2.1', source: 'Rule has Lifecycle', kind: 'attaches-to', from: 'Lifecycle', to: 'Rule', inverted: true },
  { section: '2.1', source: 'Rule belongs to Baseline', kind: 'belongs-to', from: 'Rule', to: 'Baseline' },
  { section: '2.1', source: 'Rule is superseded by Rule', kind: 'is-superseded-by', from: 'Rule', to: 'Rule' },

  /* --- §2.2 chain relationships --- */
  { section: '2.2', source: 'Constraint constrains Rule', kind: 'constrains', from: 'Constraint', to: 'Rule' },
  { section: '2.2', source: 'Constraint examines Evidence', kind: 'examines', from: 'Constraint', to: 'Evidence' },
  { section: '2.2', source: 'Evidence is examined by Constraint', kind: 'is-examined-by', from: 'Evidence', to: 'Constraint' },
  { section: '2.2', source: 'Evidence has Ownership', kind: 'owns', from: 'Evidence', to: 'Ownership' },
  { section: '2.2', source: 'Verification evaluates Evidence', kind: 'evaluates', from: 'Verification', to: 'Evidence' },
  { section: '2.2', source: 'Verification produces Decision', kind: 'produces', from: 'Verification', to: 'Decision' },
  { section: '2.2', source: 'Gate requires Verification', kind: 'requires', from: 'Gate', to: 'Verification' },
  { section: '2.2', source: 'Gate produces Decision', kind: 'produces', from: 'Gate', to: 'Decision' },
  { section: '2.2', source: 'Decision may grant Exception', kind: 'grants', from: 'Decision', to: 'Exception' },
  { section: '2.2', source: 'Exception suspends Rule', kind: 'suspends', from: 'Exception', to: 'Rule' },
  { section: '2.2', source: 'ADR proposes any object', kind: 'proposes', from: 'ADR', to: 'any-object' },
  { section: '2.2', source: 'ADR amends any object', kind: 'amends', from: 'ADR', to: 'any-object' },
  { section: '2.2', source: 'ADR replaces any object', kind: 'replaces', from: 'ADR', to: 'any-object' },
  { section: '2.2', source: 'ADR retires any object', kind: 'retires', from: 'ADR', to: 'any-object' },
  { section: '2.2', source: 'ADR cites Evidence, Traceability', kind: 'cites', from: 'ADR', to: 'Evidence' },
  { section: '2.2', source: 'ADR cites Evidence, Traceability', kind: 'cites', from: 'ADR', to: 'Traceability' },

  /* --- §2.3 cross-cutting relationships --- */
  { section: '2.3', source: 'Lifecycle attaches to every object', kind: 'attaches-to', from: 'Lifecycle', to: 'every' },
  { section: '2.3', source: 'Ownership attaches to every artifact/datum', kind: 'attaches-to', from: 'Ownership', to: 'every' },
  { section: '2.3', source: 'Traceability traverses Relationship (backward chain)', kind: 'traverses', from: 'Traceability', to: 'chain' },
];

/**
 * الزيادات الموثَّقة فوق صفوف المصدر (منفصلة عنها):
 * المعاكسات الأربع (is-owned-by, is-evaluated-by, is-required-by,
 * supersedes)، مشتقة من المصدر؛ records مشتق من بنية الإنفاذ §2
 * (قرار المراجعة MED-4)؛ extends رابط طبقة المرحلة الثانية.
 * الافتراض: مفردات النموذج = صفوف المصدر + هذه الزيادات بالضبط.
 */
const DOCUMENTED_VOCABULARY_EXTRAS: ReadonlyArray<RelationshipKind> = [
  'is-owned-by',
  'is-evaluated-by',
  'is-required-by',
  'supersedes',
  'records',
  'extends',
];

/** أصناف سلسلة الإنفاذ (for traverses target 'chain'). */
const ENFORCEMENT_CHAIN_KINDS: ReadonlyArray<ConstitutionalObjectKind> = [
  'Rule', 'Constraint', 'Evidence', 'Verification', 'Gate', 'Decision',
];

describe('Metadata models catalog (catalog.ts)', () => {
  it('defines exactly the 10 constitutional metadata models', () => {
    expect(CONSTITUTIONAL_METADATA_MODELS).toHaveLength(10);
    const ids = CONSTITUTIONAL_METADATA_MODELS.map((m) => m.id);
    expect(new Set(ids).size).toBe(ids.length);
    expect(ids).toContain('MODEL-IDENTITY');
    expect(ids).toContain('MODEL-LINKING');
    expect(ids).toContain('MODEL-DEPENDENCY-GRAPH');
    expect(ids).toContain('MODEL-TRACEABILITY');
    expect(ids).toContain('MODEL-AUTHORITY-RESOLUTION');
    expect(ids).toContain('MODEL-EVIDENCE-OWNERSHIP');
    expect(ids).toContain('MODEL-VERIFICATION-DEPENDENCY');
    expect(ids).toContain('MODEL-GATE-DEPENDENCY');
    expect(ids).toContain('MODEL-DECISION-PROVENANCE');
    expect(ids).toContain('MODEL-EXCEPTION-LINKAGE');
  });

  it('every model is scoped as passive relationship metadata', () => {
    for (const m of CONSTITUTIONAL_METADATA_MODELS) {
      expect(m.scope).toBe(PHASE_3_SCOPE);
    }
  });

  it('every model cites ADR-002, ADR-001, and the enforcement architecture', () => {
    for (const m of CONSTITUTIONAL_METADATA_MODELS) {
      const docs = m.authority.map((a) => a.document);
      expect(docs.some((d) => d === 'ADR-002')).toBe(true);
      expect(docs.some((d) => d === 'ADR-001')).toBe(true);
      expect(docs.some((d) => d.includes('constitutional-enforcement-architecture.md'))).toBe(true);
    }
  });

  it('every model declares non-empty composed-of kinds, object kinds, and status', () => {
    for (const m of CONSTITUTIONAL_METADATA_MODELS) {
      expect(m.composedOf.length).toBeGreaterThan(0);
      expect(m.objectKinds.length).toBeGreaterThan(0);
      expect(m.status.length).toBeGreaterThan(0);
      expect(m.purpose.length).toBeGreaterThan(0);
    }
  });
});

describe('Relationship kinds (immutable object relationships)', () => {
  it('defines a unique relationship vocabulary', () => {
    const kinds = RELATIONSHIP_KINDS.map((k) => k.kind);
    expect(new Set(kinds).size).toBe(kinds.length);
    for (const k of RELATIONSHIP_KINDS) {
      expect(k.meaning.length).toBeGreaterThan(0);
      expect(k.source.length).toBeGreaterThan(0);
      expect(k.validFrom.length).toBeGreaterThan(0);
      expect(k.validTo.length).toBeGreaterThan(0);
    }
  });

  it('covers the enforcement-chain relationship kinds', () => {
    const kinds = new Set(RELATIONSHIP_KINDS.map((k) => k.kind));
    const expectedKinds: ReadonlyArray<RelationshipKind> = ['constrained-by', 'examines', 'evaluates', 'requires', 'produces', 'records', 'grants', 'suspends', 'owns', 'supersedes', 'cites', 'extends'];
    for (const expected of expectedKinds) {
      expect(kinds.has(expected)).toBe(true);
    }
  });

  it('every model composed-of kind is a defined relationship kind', () => {
    const defined = new Set(RELATIONSHIP_KINDS.map((k) => k.kind));
    for (const m of CONSTITUTIONAL_METADATA_MODELS) {
      for (const c of m.composedOf) {
        expect(defined.has(c)).toBe(true);
      }
    }
  });

  it('every composed-of kind is a valid RelationshipKind literal', () => {
    const defined: ReadonlyArray<RelationshipKind> = [...RELATIONSHIP_KINDS.map((k) => k.kind)];
    for (const m of CONSTITUTIONAL_METADATA_MODELS) {
      for (const c of m.composedOf) {
        expect(defined).toContain(c);
      }
    }
  });

  it('validFrom/validTo use only registered constitutional object kinds', () => {
    const kinds = new Set(CONSTITUTIONAL_OBJECT_KINDS);
    for (const k of RELATIONSHIP_KINDS) {
      for (const from of k.validFrom) expect(kinds.has(from)).toBe(true);
      for (const to of k.validTo) expect(kinds.has(to)).toBe(true);
    }
  });

  it('every model composed-of kind is range-compatible with that model\'s objectKinds (review HIGH-2 / condition C2)', () => {
    const defs = new Map(RELATIONSHIP_KINDS.map((k) => [k.kind, k]));
    for (const m of CONSTITUTIONAL_METADATA_MODELS) {
      const kinds = new Set(m.objectKinds);
      for (const c of m.composedOf) {
        const def = defs.get(c);
        expect(def, `${m.id} composes ${c}`).toBeDefined();
        const fromOverlap = def?.validFrom.some((f) => kinds.has(f));
        const toOverlap = def?.validTo.some((t) => kinds.has(t));
        expect(fromOverlap, `${m.id} composes ${c}: validFrom must overlap objectKinds`).toBe(true);
        expect(toOverlap, `${m.id} composes ${c}: validTo must overlap objectKinds`).toBe(true);
      }
    }
  });

  it('registers constrains (Constraint → Rule), completing the §2.2 chain pair (review MED-5 / condition C4)', () => {
    const def = RELATIONSHIP_KINDS.find((k) => k.kind === 'constrains');
    expect(def).toBeDefined();
    expect(def?.validFrom).toContain('Constraint');
    expect(def?.validTo).toContain('Rule');
    expect(def?.source).toContain('object-model §2.2');
  });

  it('widens belongs-to to Exception and ADR per the §1 Baseline definition (review LOW-3 / condition C4)', () => {
    const def = RELATIONSHIP_KINDS.find((k) => k.kind === 'belongs-to');
    expect(def?.validFrom).toEqual(expect.arrayContaining(['Exception', 'ADR']));
    expect(def?.validTo).toEqual(['Baseline']);
  });

  it('annotates records with the architecture-derived provenance (review MED-4 / condition C5)', () => {
    const def = RELATIONSHIP_KINDS.find((k) => k.kind === 'records');
    expect(def?.source).toContain('enforcement architecture');
  });
});

describe('Relationship vocabulary source-of-truth verification (object-model §2.1–§2.3) (review MED-3 / condition C4)', () => {
  const definitions = new Map(RELATIONSHIP_KINDS.map((k) => [k.kind, k]));

  it('encodes every source row with direction fidelity (direct or documented inverse)', () => {
    for (const row of RELATIONSHIP_SOURCE_FIXTURE) {
      const def = definitions.get(row.kind);
      expect(def, `source row "${row.source}" → kind ${row.kind}`).toBeDefined();
      // The fixture expresses each row in the vocabulary direction: the
      // kind's validFrom must cover row.from and validTo must cover row.to.
      // `inverted` is documentary — it marks rows whose SOURCE text reads
      // in the opposite direction (e.g. "Rule has Lifecycle" ⇔ Lifecycle
      // attaches-to Rule); it does not flip the assertion.
      expect(def?.validFrom).toContain(row.from);
      if (row.to === 'any-object') {
        expect(def?.validTo.length).toBeGreaterThan(0);
      } else if (row.to === 'chain') {
        for (const c of ENFORCEMENT_CHAIN_KINDS) expect(def?.validTo).toContain(c);
      } else if (row.to === 'every') {
        for (const c of CONSTITUTIONAL_OBJECT_KINDS) expect(def?.validTo).toContain(c);
      } else {
        expect(def?.validTo).toContain(row.to);
      }
    }
  });

  it('covers the exact vocabulary: source rows + documented extras, disjoint (no row dropped, no bogus kind)', () => {
    const sourceKinds = new Set(RELATIONSHIP_SOURCE_FIXTURE.map((r) => r.kind));
    const extras = new Set(DOCUMENTED_VOCABULARY_EXTRAS);
    for (const extra of DOCUMENTED_VOCABULARY_EXTRAS) {
      expect(sourceKinds.has(extra), `${extra} must be a documented extra, not a source row`).toBe(false);
    }
    const expected = new Set([...sourceKinds, ...extras]);
    const actual = new Set(RELATIONSHIP_KINDS.map((k) => k.kind));
    expect(expected.size).toBe(27);
    expect(actual).toEqual(expected);
  });
});

describe('Constitutional identity model (MODEL-IDENTITY)', () => {
  it('defines id rules for the 13 anchored object kinds', () => {
    expect(CONSTITUTIONAL_ID_RULES).toHaveLength(13);
    const kinds = CONSTITUTIONAL_ID_RULES.map((r) => r.objectKind);
    expect(new Set(kinds).size).toBe(kinds.length);
    for (const r of CONSTITUTIONAL_ID_RULES) {
      expect(r.idPattern.length).toBeGreaterThan(0);
      expect(r.anchor.length).toBeGreaterThan(0);
      expect(r.rule.length).toBeGreaterThan(0);
    }
  });

  it('anchors the Rule id pattern to the 43-element catalog', () => {
    expect(CONSTITUTIONAL_ELEMENT_IDS).toHaveLength(43);
    const ruleRule = CONSTITUTIONAL_ID_RULES.find((r) => r.objectKind === 'Rule');
    expect(ruleRule?.anchor).toBe('R1');
  });

  it('registers an ADR id rule anchored to the ADR series (review MED-2 / condition C3)', () => {
    const adrRule = CONSTITUTIONAL_ID_RULES.find((r) => r.objectKind === 'ADR');
    expect(adrRule?.anchor).toContain('ADR');
    expect(adrRule?.idPattern).toContain('ADR-');
  });

  it('documents the identity scoping (registry-anchored kinds only; Principle/Invariant/Lifecycle/Ownership/Traceability/Baseline deferred)', () => {
    const idRuleKinds = new Set(CONSTITUTIONAL_ID_RULES.map((r) => r.objectKind));
    for (const deferred of ['Principle', 'Invariant', 'Lifecycle', 'Ownership', 'Traceability', 'Baseline'] as const) {
      expect(idRuleKinds.has(deferred)).toBe(false);
    }
    expect(OBJECT_IDENTITY_MODEL.status).toContain('ADR');
  });

  it('is cataloged as MODEL-IDENTITY', () => {
    expect(OBJECT_IDENTITY_MODEL.id).toBe('MODEL-IDENTITY');
  });
});

describe('Layer linking model (MODEL-LINKING)', () => {
  it('connects the four layers in order without a direct Registry → Engine edge', () => {
    expect(LAYER_ARCHITECTURE).toHaveLength(3);
    expect(LAYER_ARCHITECTURE[0].from).toBe('Registry');
    expect(LAYER_ARCHITECTURE[0].to).toBe('Specification');
    expect(LAYER_ARCHITECTURE[1].from).toBe('Specification');
    expect(LAYER_ARCHITECTURE[1].to).toBe('Relationship Model');
    expect(LAYER_ARCHITECTURE[2].from).toBe('Relationship Model');
    expect(LAYER_ARCHITECTURE[2].to).toBe('Enforcement Engine (future)');
    const edges = LAYER_ARCHITECTURE.map((e) => `${e.from}->${e.to}`);
    expect(edges).not.toContain('Registry->Enforcement Engine (future)');
  });

  it('prohibits a direct Registry → Runtime connection', () => {
    expect(LAYER_ARCHITECTURE_RULE).toContain('Registry → Specification → Relationship Model → Future Enforcement Engine');
    expect(LAYER_ARCHITECTURE_RULE).toContain('prohibited');
  });

  it('types the layer edges with dedicated layer kinds whose from/to match each edge (review HIGH-2 / condition C2)', () => {
    const kinds = new Map(LAYER_EDGE_KINDS.map((k) => [k.kind, k]));
    expect(LAYER_EDGE_KINDS).toHaveLength(3);
    expect(new Set(LAYER_EDGE_KINDS.map((k) => k.kind)).size).toBe(3);
    for (const edge of LAYER_ARCHITECTURE) {
      const def = kinds.get(edge.via);
      expect(def, `layer edge ${edge.from}→${edge.to} via ${edge.via}`).toBeDefined();
      expect(def?.from).toBe(edge.from);
      expect(def?.to).toBe(edge.to);
    }
    const viaKinds = LAYER_ARCHITECTURE.map((e) => e.via);
    expect(viaKinds).toEqual(['anchors', 'instantiates', 'contracts']);
    expect(viaKinds).not.toContain('attaches-to');
    expect(viaKinds).not.toContain('traverses');
  });

  it('keeps MODEL-LINKING composed-of and objectKinds range-consistent (only extends within Registry/Specification)', () => {
    expect(LINKING_MODEL.composedOf).toEqual(['extends']);
    expect(LINKING_MODEL.objectKinds).toEqual(['Registry', 'Specification']);
  });

  it('is cataloged as MODEL-LINKING', () => {
    expect(LINKING_MODEL.id).toBe('MODEL-LINKING');
  });
});

describe('Dependency graph model (MODEL-DEPENDENCY-GRAPH)', () => {
  it('defines the enforcement chain in order with registry anchors R1..R6', () => {
    expect(ENFORCEMENT_CHAIN.map((n) => n.kind)).toEqual([
      'Rule', 'Constraint', 'Evidence', 'Verification', 'Gate', 'Decision',
    ]);
    expect(ENFORCEMENT_CHAIN.map((n) => n.anchor)).toEqual(['R1', 'R2', 'R3', 'R4', 'R5', 'R6']);
  });

  it('declares an explicit per-edge direction contract relative to the enforcement flow (review HIGH-1 / condition C1)', () => {
    expect(DEPENDENCY_EDGE_KINDS).toEqual(['constrained-by', 'examines', 'evaluates', 'requires', 'produces']);
    expect(DEPENDENCY_EDGE_DIRECTIONS).toEqual({
      'constrained-by': 'forward',
      'examines': 'forward',
      'evaluates': 'backward',
      'requires': 'backward',
      'produces': 'forward',
    });
  });

  it('is cataloged as MODEL-DEPENDENCY-GRAPH', () => {
    expect(DEPENDENCY_GRAPH_MODEL.id).toBe('MODEL-DEPENDENCY-GRAPH');
  });
});

describe('Traceability model (MODEL-TRACEABILITY)', () => {
  it('defines the backward traceability chain decision → evidence → constraint → rule', () => {
    expect(TRACEABILITY_CHAIN.map((n) => n.kind)).toEqual(['Decision', 'Evidence', 'Constraint', 'Rule']);
  });

  it('is cataloged as MODEL-TRACEABILITY', () => {
    expect(TRACEABILITY_MODEL.id).toBe('MODEL-TRACEABILITY');
  });
});

describe('Authority resolution model (MODEL-AUTHORITY-RESOLUTION)', () => {
  it('resolves exactly the 8 enforcement domains D1..D8 once each', () => {
    expect(AUTHORITY_RESOLUTIONS).toHaveLength(8);
    const owners = AUTHORITY_RESOLUTIONS.map((r) => r.owner);
    expect(new Set(owners).size).toBe(owners.length);
    for (const r of AUTHORITY_RESOLUTIONS) {
      expect(r.owner).toMatch(/^D[1-8]$/);
      expect(r.authorityBody.length).toBeGreaterThan(0);
      expect(r.authorityDocuments.length).toBeGreaterThan(0);
      expect(r.basis.length).toBeGreaterThan(0);
    }
  });

  it('is cataloged as MODEL-AUTHORITY-RESOLUTION', () => {
    expect(AUTHORITY_RESOLUTION_MODEL.id).toBe('MODEL-AUTHORITY-RESOLUTION');
  });
});

describe('Cross-references into Phase 1 registries and Phase 2 specs (unchanged)', () => {
  it('the 11 registries are intact', () => {
    expect(REGISTRIES.map((r) => r.id)).toEqual([
      'R1', 'R2', 'R3', 'R4', 'R5', 'R6', 'R7', 'R8', 'R9', 'R10', 'R11',
    ]);
  });

  it('R3 keeps 7 evidence artifact types (referenced by MODEL-EVIDENCE-OWNERSHIP)', () => {
    expect(EVIDENCE_ARTIFACTS).toHaveLength(7);
    expect(EVIDENCE_OWNERSHIP_MODEL.id).toBe('MODEL-EVIDENCE-OWNERSHIP');
    expect(EVIDENCE_OWNERSHIP_MODEL.objectKinds).toContain('Evidence');
  });

  it('R4 keeps the EC1..EC10 initial verification set unexecuted', () => {
    expect(VERIFICATION_RECORDS).toHaveLength(10);
    for (const v of VERIFICATION_RECORDS) {
      expect(v.status).toBe('NotRegistered');
    }
    expect(VERIFICATION_DEPENDENCY_MODEL.id).toBe('MODEL-VERIFICATION-DEPENDENCY');
  });

  it('R5 keeps 5 gates with zero bindings (referenced by MODEL-GATE-DEPENDENCY)', () => {
    expect(GATES).toHaveLength(5);
    expect(GATE_ELEMENT_ASSIGNMENTS).toHaveLength(0);
    expect(GATE_DEPENDENCY_MODEL.id).toBe('MODEL-GATE-DEPENDENCY');
  });

  it('R6 keeps zero decisions (referenced by MODEL-DECISION-PROVENANCE)', () => {
    expect(DECISIONS).toHaveLength(0);
    expect(DECISION_PROVENANCE_MODEL.id).toBe('MODEL-DECISION-PROVENANCE');
  });

  it('R9 keeps the I11 precedent unrecorded (referenced by MODEL-EXCEPTION-LINKAGE)', () => {
    expect(KNOWN_PRECEDENTS).toHaveLength(1);
    expect(KNOWN_PRECEDENTS[0].targetElement).toBe('I11');
    expect(KNOWN_PRECEDENTS[0].status).toBe('Unrecorded');
    expect(EXCEPTION_LINKAGE_MODEL.id).toBe('MODEL-EXCEPTION-LINKAGE');
  });

  it('the 6 Phase 2 specification kinds are intact and referenced by the identity model', () => {
    expect(ENFORCEMENT_SPEC_KINDS).toHaveLength(6);
    expect(CONSTITUTIONAL_ID_RULES.some((r) => r.objectKind === 'Specification')).toBe(true);
  });
});

describe('Runtime prohibition', () => {
  it('marks the relationship model as passive metadata', () => {
    expect(RELATIONSHIPS_RUNTIME_PROHIBITED).toContain('passive');
  });
});
