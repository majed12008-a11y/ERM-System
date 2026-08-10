/*
 * هيكل اختبارات مواصفات الإنفاذ الدستوري — اختبارات بنيوية نقية
 * (بدون قاعدة بيانات، بدون سلوك تنفيذي) تتحقق من سلامة كتالوج
 * المواصفات الستة وترابطه المرجعي مع سجلات المرحلة الأولى
 * (R2..R6, R9). المرحلة الثانية: هيكل الاختبار فقط — لا ينفَّذ
 * أي سلوك تحقق أو بوابة أو قرار.
 */
import { describe, it, expect } from 'vitest';
import {
  ENFORCEMENT_SPEC_KIND_IDS,
  PHASE_2_SCOPE,
  SPECIFICATIONS_RUNTIME_PROHIBITED,
  SpecKindDefinition,
} from '../types';
import { ENFORCEMENT_SPEC_KINDS } from '../index';
import { REGISTRIES } from '../../registries';
import { CONSTITUTIONAL_ELEMENT_IDS, EXIT_CRITERION_IDS } from '../../registries/types';
import { CONSTRAINTS_PRESENT } from '../../registries/constraint.registry';
import { EVIDENCE_ARTIFACTS, EVIDENCE_PRESENT } from '../../registries/evidence.registry';
import { VERIFICATION_RECORDS, READY_OUTSIDE_INITIAL_SET } from '../../registries/verification.registry';
import { GATES, GATE_ELEMENT_ASSIGNMENTS } from '../../registries/gate.registry';
import { DECISIONS } from '../../registries/decision.registry';
import { KNOWN_PRECEDENTS } from '../../registries/exception.registry';

const byKind = (kind: string): SpecKindDefinition =>
  ENFORCEMENT_SPEC_KINDS.find((d) => d.kind === kind) as SpecKindDefinition;

describe('Specification catalog (catalog.ts)', () => {
  it('defines exactly the 6 enforcement spec kinds in chain order', () => {
    expect(ENFORCEMENT_SPEC_KINDS).toHaveLength(6);
    expect(ENFORCEMENT_SPEC_KINDS.map((d) => d.kind)).toEqual([
      'Constraint', 'Evidence', 'Verification', 'Gate', 'Decision', 'Exception',
    ]);
  });

  it('kind ids are unique and match the ENFORCEMENT_SPEC_KIND_IDS order', () => {
    const ids = ENFORCEMENT_SPEC_KINDS.map((d) => d.id);
    expect(new Set(ids).size).toBe(ids.length);
    expect(ids).toEqual([...ENFORCEMENT_SPEC_KIND_IDS]);
  });

  it('every definition is scoped as passive constitutional metadata', () => {
    for (const d of ENFORCEMENT_SPEC_KINDS) {
      expect(d.scope).toBe(PHASE_2_SCOPE);
    }
  });

  it('each kind extends the registry that owns its structural record', () => {
    const mapping: ReadonlyArray<[string, string]> = [
      ['Constraint', 'R2'],
      ['Evidence', 'R3'],
      ['Verification', 'R4'],
      ['Gate', 'R5'],
      ['Decision', 'R6'],
      ['Exception', 'R9'],
    ];
    for (const [kind, registry] of mapping) {
      expect(byKind(kind).extends).toBe(registry);
    }
  });

  it('each kind is owned by the enforcement domain defined in the domains catalog', () => {
    const mapping: ReadonlyArray<[string, string]> = [
      ['Constraint', 'D2'],
      ['Evidence', 'D3'],
      ['Verification', 'D4'],
      ['Gate', 'D5'],
      ['Decision', 'D6'],
      ['Exception', 'D6'],
    ];
    for (const [kind, owner] of mapping) {
      expect(byKind(kind).owner).toBe(owner);
    }
  });

  it('every extended registry is a registered Phase 1 registry', () => {
    const registryIds = new Set(REGISTRIES.map((r) => r.id));
    for (const d of ENFORCEMENT_SPEC_KINDS) {
      expect(registryIds.has(d.extends)).toBe(true);
    }
  });
});

describe('Specification definitions (structural shape)', () => {
  it('every kind cites ADR-002, ADR-001, and the enforcement architecture', () => {
    for (const d of ENFORCEMENT_SPEC_KINDS) {
      const docs = d.authority.map((a) => a.document);
      expect(docs.some((doc) => doc === 'ADR-002')).toBe(true);
      expect(docs.some((doc) => doc === 'ADR-001')).toBe(true);
      expect(docs.some((doc) => doc.includes('constitutional-enforcement-architecture.md'))).toBe(true);
    }
  });

  it('every kind carries at least 3 shape fields with unique names and non-empty meaning', () => {
    for (const d of ENFORCEMENT_SPEC_KINDS) {
      expect(d.shape.length).toBeGreaterThanOrEqual(3);
      const names = d.shape.map((f) => f.name);
      expect(new Set(names).size).toBe(names.length);
      for (const f of d.shape) {
        expect(f.meaning.length).toBeGreaterThan(0);
        expect(f.source.length).toBeGreaterThan(0);
        expect(typeof f.required).toBe('boolean');
      }
    }
  });

  it('every kind declares purpose, object-model relations, state applicability, and instantiates', () => {
    for (const d of ENFORCEMENT_SPEC_KINDS) {
      expect(d.purpose.length).toBeGreaterThan(0);
      expect(d.objectModelRelations.length).toBeGreaterThan(0);
      expect(d.stateMachineApplicability.length).toBeGreaterThan(0);
      expect(d.instantiates.length).toBeGreaterThan(0);
    }
  });

  it('prohibits runtime wiring with the passive-metadata marker', () => {
    expect(SPECIFICATIONS_RUNTIME_PROHIBITED).toContain('passive');
  });
});

describe('Cross-references into the Phase 1 registries (unchanged)', () => {
  it('R2 constraint present-set is 12 and every element is a registered constitutional element', () => {
    expect(CONSTRAINTS_PRESENT).toHaveLength(12);
    const elementIds = new Set(CONSTITUTIONAL_ELEMENT_IDS);
    for (const c of CONSTRAINTS_PRESENT) {
      expect(elementIds.has(c.element)).toBe(true);
    }
  });

  it('R3 registers 7 artifact types and 13 present evidence sources', () => {
    expect(EVIDENCE_ARTIFACTS).toHaveLength(7);
    expect(EVIDENCE_PRESENT).toHaveLength(13);
  });

  it('R4 registers the EC1..EC10 initial set with 7 Ready / 3 NeedsExtension', () => {
    expect(VERIFICATION_RECORDS.map((v) => v.id)).toEqual([...EXIT_CRITERION_IDS]);
    expect(VERIFICATION_RECORDS.filter((v) => v.readiness === 'Ready')).toHaveLength(7);
    expect(VERIFICATION_RECORDS.filter((v) => v.readiness === 'NeedsExtension')).toHaveLength(3);
  });

  it('R4 registers the two ready checks outside the initial set (I11, G11)', () => {
    expect(READY_OUTSIDE_INITIAL_SET).toHaveLength(2);
    expect(READY_OUTSIDE_INITIAL_SET.map((r) => r.element)).toEqual(['I11', 'G11']);
  });

  it('R5 defines GATE-01..GATE-05 with zero bound verifications (binding is a later phase)', () => {
    expect(GATES).toHaveLength(5);
    expect(GATES.map((g) => g.id)).toEqual(['GATE-01', 'GATE-02', 'GATE-03', 'GATE-04', 'GATE-05']);
    expect(GATE_ELEMENT_ASSIGNMENTS).toHaveLength(0);
    for (const g of GATES) {
      expect(g.requiredVerification).toHaveLength(0);
    }
  });

  it('R6 records zero decisions (baseline)', () => {
    expect(DECISIONS).toHaveLength(0);
  });

  it('R9 records the I11 SECURITY DEFINER precedent as unrecorded and deferred', () => {
    expect(KNOWN_PRECEDENTS).toHaveLength(1);
    expect(KNOWN_PRECEDENTS[0].targetElement).toBe('I11');
    expect(KNOWN_PRECEDENTS[0].status).toBe('Unrecorded');
  });
});
