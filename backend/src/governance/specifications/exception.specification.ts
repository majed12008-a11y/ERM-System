/*
 * مواصفة الاستثناء (SPEC-EXCEPTION) — البنية الهيكلية لتعريف
 * الاستثناء: الانحراف المأذون بسلطته ونطاقه وانتهائه. انحراف غير
 * مسجّل هو مخالفة بغض النظر عن النية. تُعرَّف هنا الحقول البنيوية
 * فقط — لا يُسجَّل أي استثناء جديد. المرجع: R9 (سجل الاستثناءات)
 * و constitutional-enforcement-architecture.md §2/§3.
 */
import { PHASE_2_SCOPE, SpecKindDefinition } from './types';

export const EXCEPTION_SPEC_DEFINITION: SpecKindDefinition = {
  scope: PHASE_2_SCOPE,
  id: 'SPEC-EXCEPTION',
  kind: 'Exception',
  name: 'Exception Specification',
  extends: 'R9',
  owner: 'D6',
  purpose:
    'Structural definition of an exception specification: a sanctioned deviation with authority, scope, and expiry. Exceptions are explicit, bounded, and expiring — never silent. An unrecorded deviation is a violation regardless of intent.',
  shape: [
    { name: 'exceptionId', meaning: 'The exception record identity.', required: true, source: 'enforcement architecture §2 (Exception Registry)' },
    { name: 'targetElement', meaning: 'The constitutional element the exception suspends (R1 reference).', required: true, source: 'constitutional-object-model §2.2 (suspends → Rule)' },
    { name: 'authority', meaning: 'The granting authority (R9 ExceptionStatus: Unrecorded | Recorded | Expired).', required: true, source: 'constitutional-object-model §2.2; R9 ExceptionStatus' },
    { name: 'scope', meaning: 'The bounded deviation scope.', required: true, source: 'enforcement architecture §2 (Exception Registry)' },
    { name: 'expiry', meaning: 'The expiry; exceptions are expiring, never permanent.', required: true, source: 'enforcement architecture §2 (Exception Registry); state-machine §4.3' },
    { name: 'status', meaning: 'The recorded status (R9 ExceptionStatus).', required: true, source: 'R9 ExceptionStatus; constitutional-object-model §3.6' },
  ],
  objectModelRelations: 'is granted by → Decision; suspends → Rule (moves it to Suspended); must reference an ADR or authority',
  stateMachineApplicability:
    'Follows the uniform state machine (constitutional-state-machine §5); an exception is Approved, becomes Active on grant, and is Archived when expired.',
  authority: [
    { document: 'ADR-002', section: 'Canonical Dataset Architecture (D6 Exception; I11 bypass precedent)' },
    { document: 'constitutional-enforcement-architecture.md', section: 'Section 2 (Exception Registry); Section 3' },
    { document: 'constitutional-object-model.md', section: 'Section 2.2; Section 3' },
    { document: 'ADR-001', section: 'Series foundation' },
  ],
  instantiates:
    'R9 registers the I11 SECURITY DEFINER precedent (KNOWN_PRECEDENTS; status Unrecorded, recording deferred with its ADR review).',
};
