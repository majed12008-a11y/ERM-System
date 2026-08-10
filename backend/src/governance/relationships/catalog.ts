/*
 * كتالوج نماذج العلاقات الدستورية — المجموعة الرسمية للنماذج
 * الوصفية العشرة بترتيب التغطية: الهوية، الربط، التبعيات،
 * التتبع، السلطة، الملكية، ثم نماذج السلسلة (تحقق/بوابة/قرار/
 * استثناء). كتالوج بنيوي سلبي فقط — لا يحتوي أي منطق تنفيذي.
 */
import { MetadataModel } from './types';
import { OBJECT_IDENTITY_MODEL } from './object-identity';
import { LINKING_MODEL } from './linking-model';
import { DEPENDENCY_GRAPH_MODEL } from './dependency-graph';
import { TRACEABILITY_MODEL } from './traceability-graph';
import { AUTHORITY_RESOLUTION_MODEL } from './authority-resolution';
import { EVIDENCE_OWNERSHIP_MODEL } from './evidence-ownership';
import { VERIFICATION_DEPENDENCY_MODEL } from './verification-dependency';
import { GATE_DEPENDENCY_MODEL } from './gate-dependency';
import { DECISION_PROVENANCE_MODEL } from './decision-provenance';
import { EXCEPTION_LINKAGE_MODEL } from './exception-linkage';

/** جميع النماذج الوصفية العشرة بترتيب التغطية. */
export const CONSTITUTIONAL_METADATA_MODELS: ReadonlyArray<MetadataModel> = [
  OBJECT_IDENTITY_MODEL,
  LINKING_MODEL,
  DEPENDENCY_GRAPH_MODEL,
  TRACEABILITY_MODEL,
  AUTHORITY_RESOLUTION_MODEL,
  EVIDENCE_OWNERSHIP_MODEL,
  VERIFICATION_DEPENDENCY_MODEL,
  GATE_DEPENDENCY_MODEL,
  DECISION_PROVENANCE_MODEL,
  EXCEPTION_LINKAGE_MODEL,
];
