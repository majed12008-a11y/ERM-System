/*
 * سجل المفردات (R11) — المفردات النهائية والمصطلحات
 * الممنوعة وبوابة المصطلح (G4, G11; EC2, EC5). مصطلح غير
 * مسجّل هنا لا يجوز دخوله إلى وثيقة نشطة. المحتوى حي
 * من docs/reference/glossary.md (المفردات النهائية +
 * المصطلحات الممنوعة). مرحلة الأولى تسجيل هيكلي فقط.
 */
import { ConstitutionalRegistry } from './registry';

export type VocabularyTermStatus = 'Canonical' | 'Allowed' | 'Deprecated';

export interface VocabularyTerm {
  readonly term: string;
  readonly status: VocabularyTermStatus;
  readonly definition?: string;
  readonly replacement?: string;
  readonly transitionPeriod?: string;
  readonly source: string;
}

export interface ForbiddenUsage {
  readonly usage: string;
  readonly reason: string;
}

/** المفردات النهائية (Canonical) — glossary.md §1. */
export const CANONICAL_TERMS: ReadonlyArray<VocabularyTerm> = [
  { term: 'Canonical Dataset', status: 'Canonical', definition: 'THE product; the source of truth (P1). The canonical dataset content (Era-2 Yemen lineage) as the single authority.', source: 'T-11; ADR-002 P1' },
  { term: 'Installer History', status: 'Canonical', definition: 'The role of the seed suite: an append-only change ledger; never the product (P1).', source: 'T-12; ADR-002' },
  { term: 'Baseline', status: 'Canonical', definition: 'A versioned, reproducible dataset STATE (I3); never the dump.', source: 'T-13; ADR-002 I3' },
  { term: 'Aggregate', status: 'Canonical', definition: 'The authoritative invariant model (P3, P6, I5, I10); to be added to DOMAIN_MODEL in Phase 1.', source: 'T-14; ADR-002' },
  { term: 'Aggregate Root', status: 'Canonical', definition: 'Named for Application and Condition (Phase 1).', source: 'T-15' },
  { term: 'Runtime-Generated Data', status: 'Canonical', definition: 'Data class (audit, sessions, history, outbox) that is never seeded (I11).', source: 'T-16; ADR-002 I11' },
  { term: 'Scenario Dataset', status: 'Canonical', definition: 'Dataset category: business scenarios over canonical data.', source: 'T-21' },
  { term: 'Fixture', status: 'Canonical', definition: 'Presentation/test data over canonical data; qualified Demo/Pilot/Test.', source: 'T-22' },
  { term: 'Reference Dataset', status: 'Canonical', definition: 'Idempotent, environment-invariant master data.', source: 'T-23' },
  { term: 'Migration', status: 'Canonical', definition: 'Versioned, forward-only schema evolution; distinct from data.', source: 'T-24' },
  { term: 'Provenance', status: 'Canonical', definition: 'Execution evidence that survives restore (I2, I7).', source: 'T-25; ADR-002' },
  { term: 'Dataset Lifecycle', status: 'Canonical', definition: 'Promote, version, deprecate, branch, merge, archive (P5).', source: 'T-26; ADR-002 P5' },
  { term: 'Dataset Construction', status: 'Canonical', definition: 'The construction path for datasets; restoration is not construction (I3).', source: 'T-7; ADR-002 I3' },
];

/** مصطلحات مسموحة بقيود الاستخدام — glossary.md §2. */
export const ALLOWED_TERMS: ReadonlyArray<VocabularyTerm> = [
  { term: 'Seed (as historical artifact)', status: 'Allowed', definition: 'The 79 files in backend/seed/ when describing history; qualified as "seed file (historical)".', source: 'T-5' },
  { term: 'Runtime (engine)', status: 'Allowed', definition: 'Form Runtime = the schema-driven form ENGINE; distinct from Runtime-Generated Data.', source: 'T-17' },
  { term: 'Domain', status: 'Allowed', definition: 'Must be qualified: Bounded Context (DOMAIN_MODEL) / Domain Module (backend) / Domain Schema (DB).', source: 'T-18' },
  { term: 'Canonical Lineage', status: 'Allowed', definition: 'Canonical Dataset content (Era-2 Yemen).', source: 'T-19' },
  { term: 'Canonical Schema', status: 'Allowed', definition: 'Schema authority (database/canonical/); distinct from Canonical Dataset.', source: 'T-20' },
  { term: 'Gate-0', status: 'Allowed', definition: 'Historical milestone / dump referent; not a forward construct.', source: 'T-27' },
  { term: 'Era-1/2/3', status: 'Allowed', definition: 'Epoch labels for the installer history.', source: 'T-28' },
  { term: 'Dump', status: 'Allowed', definition: 'Carrier/mechanism artifact that reproduces a state by restoration; not the dataset (C2).', source: 'registry #20; ADR-002 C2' },
];

/** مصطلحات موقوفة مع بديلها — glossary.md §3. */
export const DEPRECATED_TERMS: ReadonlyArray<VocabularyTerm> = [
  { term: 'Canonical Seed', status: 'Deprecated', replacement: 'Canonical Dataset', transitionPeriod: 'Phase 0–5', source: 'T-1' },
  { term: 'Seed Suite (as product)', status: 'Deprecated', replacement: 'Installer History / Canonical Dataset', transitionPeriod: 'Phase 0–5', source: 'T-2' },
  { term: 'Seed (as future construct unit)', status: 'Deprecated', replacement: 'Migration / Reference Dataset / Scenario Dataset / Fixture', transitionPeriod: 'Phase 0–5', source: 'T-3' },
  { term: 'Validation Dataset', status: 'Deprecated', replacement: 'Canonical Dataset', transitionPeriod: 'Phase 2', source: 'T-6' },
  { term: 'Baseline-restore (as install path)', status: 'Deprecated', replacement: 'Dataset Construction', transitionPeriod: 'Phase 0–5', source: 'T-7' },
  { term: 'Dump / Gate-0 baseline (as source of truth)', status: 'Deprecated', replacement: 'Baseline (dataset state) / Dump (carrier)', transitionPeriod: 'Phase 0–5', source: 'T-8' },
  { term: 'seed-status [OK] as readiness proof', status: 'Deprecated', replacement: 'Provenance evidence', transitionPeriod: 'Phase 4', source: 'T-9' },
  { term: 'Business Object', status: 'Deprecated', replacement: 'Business Entity (DOMAIN_MODEL) / Aggregate (ADR)', transitionPeriod: 'Phase 1', source: 'T-10' },
];

/** استعمالات ممنوعة في الوثائق النشطة — glossary.md §4. */
export const FORBIDDEN_TERMS: ReadonlyArray<ForbiddenUsage> = [
  { usage: '"Canonical Seed"', reason: 'a dataset is never a kind of seed' },
  { usage: '"Seed Suite is the source of truth" / "the seed suite is the deliverable"', reason: 'contradicts P1' },
  { usage: '"keep the dump as single source of truth"', reason: 'contradicts P1, C2' },
  { usage: '"validation dataset" as a separate product', reason: 'contradicts the single-dataset model' },
  { usage: '"seed-status [OK] proves deployment"', reason: 'contradicts I2' },
  { usage: '"Business Object" as a defined model term', reason: 'undefined; conflicts with the terminology constitution' },
];

/** بوابة المصطلح (G4, G11; EC2, EC5). */
export const TERM_GATE =
  'A term not registered in this vocabulary may not enter an active document (G4, G11; EC2, EC5). Terms are governed by the final vocabulary above.';

export const VOCABULARY_REGISTRY = new ConstitutionalRegistry<VocabularyTerm>(
  'R11',
  'Vocabulary Registry',
  'D1',
  [
    { document: 'reference/glossary.md', section: 'Final vocabulary + forbidden terms' },
    { document: 'ADR-002', section: 'G4 / G11; EC2 / EC5' },
  ],
  [...CANONICAL_TERMS, ...ALLOWED_TERMS, ...DEPRECATED_TERMS],
);
