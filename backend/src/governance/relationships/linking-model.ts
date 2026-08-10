/*
 * نموذج الربط بين الطبقات (MODEL-LINKING) — بنية ربط السجلات
 * بالمواصفات وبالنموذج وبمحرك الإنفاذ المستقبلي:
 *
 *   Registry → Specification → Relationship Model → Future Enforcement Engine
 *
 * دون أي اتصال مباشر Registry → Runtime. معمارية البنية تُنفَّذ
 * هنا كبيانات وصفية (حُواف مكتوبة) فقط — لا يوجد سلوك.
 *
 * حُواف الطبقات تُعبَّر بأصناف مخصصة للطبقات (LAYER_EDGE_KINDS:
 * anchors / instantiates / contracts)، لا بإعادة استخدام مفردات
 * العلاقات بين الكائنات الدستورية (object-model §2.1–§2.3) — فمدى
 * تلك المفردات لا يشمل نقاط نهاية الطبقات (قرار المراجعة HIGH-2).
 */
import { MetadataModel } from './types';
import { PHASE_3_SCOPE } from './types';

export type ConstitutionalLayer =
  | 'Registry'
  | 'Specification'
  | 'Relationship Model'
  | 'Enforcement Engine (future)';

/** أصناف حُواف الطبقات المخصصة (ليست أصناف علاقات كائنات دستورية). */
export type LayerEdgeKind = 'anchors' | 'instantiates' | 'contracts';

export interface LayerEdge {
  readonly from: ConstitutionalLayer;
  readonly to: ConstitutionalLayer;
  readonly via: LayerEdgeKind;
  readonly note: string;
}

/** تعريف صنف حافة طبقة: مفردة مخصصة بمدى من/إلى داخل الطبقات. */
export interface LayerEdgeKindDefinition {
  readonly kind: LayerEdgeKind;
  readonly from: ConstitutionalLayer;
  readonly to: ConstitutionalLayer;
  readonly meaning: string;
  readonly source: string;
}

/** كتالوج أصناف حُواف الطبقات المخصصة (قناة الأنابيب بين الطبقات). */
export const LAYER_EDGE_KINDS: ReadonlyArray<LayerEdgeKindDefinition> = [
  {
    kind: 'anchors',
    from: 'Registry',
    to: 'Specification',
    meaning: 'The registries (R1..R11) anchor the specification kinds that govern their records (Phase 2 linking).',
    source: 'layer pipeline (Phase 2); enforcement architecture §2/§7',
  },
  {
    kind: 'instantiates',
    from: 'Specification',
    to: 'Relationship Model',
    meaning: 'The relationship model instantiates the specification-layer structure into passive metadata models (Phase 3).',
    source: 'layer pipeline (Phase 3); RELATIONSHIPS_RUNTIME_PROHIBITED',
  },
  {
    kind: 'contracts',
    from: 'Relationship Model',
    to: 'Enforcement Engine (future)',
    meaning: 'The future enforcement engine is bound by the relationship model as its structural contract (prospective; not implemented in any phase so far).',
    source: 'enforcement architecture §7.3 (prospectus)',
  },
];

/** تدفق الطبقات الأربع — لا حافة مباشرة بين السجلات والمحرك. */
export const LAYER_ARCHITECTURE: ReadonlyArray<LayerEdge> = [
  {
    from: 'Registry',
    to: 'Specification',
    via: 'anchors',
    note: 'Phase 2: each specification kind extends the registry whose records it governs (SPEC-CONSTRAINT extends R2, …). The underlying object-model relationship is `extends` (Specification → Registry); the layer edge expresses the pipeline flow with the dedicated layer kind `anchors`.',
  },
  {
    from: 'Specification',
    to: 'Relationship Model',
    via: 'instantiates',
    note: 'Phase 3: the relationship model is built over the specification layer and references registries read-only.',
  },
  {
    from: 'Relationship Model',
    to: 'Enforcement Engine (future)',
    via: 'contracts',
    note: 'Prospective: the future engine consumes the relationship model as its structural contract. Not implemented in any phase so far.',
  },
];

export const LAYER_ARCHITECTURE_RULE =
  'The layers connect only in order Registry → Specification → Relationship Model → Future Enforcement Engine. A direct Registry → Runtime connection is prohibited (RUNTIME_ENFORCEMENT_PROHIBITED; SPECIFICATIONS_RUNTIME_PROHIBITED; RELATIONSHIPS_RUNTIME_PROHIBITED).';

export const LINKING_MODEL: MetadataModel = {
  scope: PHASE_3_SCOPE,
  id: 'MODEL-LINKING',
  name: 'Registry / Specification Linking Model',
  purpose:
    'Defines the layer pipeline that keeps enforcement infrastructure layered: registries and specifications stay passive, the relationship model connects them structurally, and the future engine consumes the model — never the registries directly. The pipeline edges are expressed by dedicated layer-edge kinds (LAYER_EDGE_KINDS); the only object-model relationship the linking composes is `extends` (Specification → Registry).',
  authority: [
    { document: 'constitutional-enforcement-architecture.md', section: 'Section 2; Section 7; Section 8' },
    { document: 'constitutional-object-model.md', section: 'Section 4' },
    { document: 'ADR-002' },
    { document: 'ADR-001', section: 'Series foundation' },
  ],
  composedOf: ['extends'],
  objectKinds: ['Registry', 'Specification'],
  status:
    'Layer pipeline defined structurally; no runtime edge exists. The layer endpoints Relationship Model and Enforcement Engine (future) are architectural layers, not constitutional object kinds — they are represented in LAYER_ARCHITECTURE, not in objectKinds. Phase 1 registries and Phase 2 specifications remain unmodified.',
};
