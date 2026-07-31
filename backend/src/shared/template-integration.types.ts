import type { RenderSnapshot } from './template-snapshot.types';
import type { RenderResult } from './template-render.types';

export interface RenderDocumentRequest {
  templateCode: string;
  version: string;
  variables: Record<string, unknown>;
  renderedBy: number;
  locale?: string;
  entityType?: string;
  entityId?: number;
  userContext?: { userId?: number; userRoles?: string[]; locale?: string };
  correlationId?: string;
}

export interface RenderDocumentResult {
  html: string;
  renderResult: RenderResult;
  snapshot: RenderSnapshot;
  snapshotHash: string;
  correlationId: string;
}

export interface ModuleDocumentConfig {
  templateCode: string;
  version: string;
  entityType: string;
}

export const MODULE_DOCUMENTS: Record<string, ModuleDocumentConfig> = {
  'application.submission':       { templateCode: 'protocol-full',         version: '1.0.0', entityType: 'Application' },
  'application.receipt':          { templateCode: 'protocol-full',         version: '1.0.0', entityType: 'Application' },
  'application.correction':       { templateCode: 'protocol-full',         version: '1.0.0', entityType: 'Application' },
  'application.approval':         { templateCode: 'certificate-approval',  version: '1.0.0', entityType: 'Application' },
  'application.conditional':      { templateCode: 'condition-letter',      version: '1.0.0', entityType: 'Application' },
  'application.rejection':        { templateCode: 'decision-standard',     version: '1.0.0', entityType: 'Application' },
  'application.withdrawal':       { templateCode: 'protocol-full',         version: '1.0.0', entityType: 'Application' },
  'meeting.agenda':               { templateCode: 'meeting-minutes',       version: '1.0.0', entityType: 'Meeting' },
  'meeting.minutes':              { templateCode: 'meeting-minutes',       version: '1.0.0', entityType: 'Meeting' },
  'committee.review':             { templateCode: 'decision-standard',     version: '1.0.0', entityType: 'Committee' },
  'committee.decision':           { templateCode: 'decision-standard',     version: '1.0.0', entityType: 'Committee' },
  'accreditation.decision':       { templateCode: 'accreditation-cert',    version: '1.0.0', entityType: 'Institution' },
  'accreditation.conditional':    { templateCode: 'accreditation-cert',    version: '1.0.0', entityType: 'Institution' },
  'accreditation.suspension':     { templateCode: 'accreditation-cert',    version: '1.0.0', entityType: 'Institution' },
  'accreditation.revocation':     { templateCode: 'accreditation-cert',    version: '1.0.0', entityType: 'Institution' },
  'accreditation.expiration':     { templateCode: 'accreditation-cert',    version: '1.0.0', entityType: 'Institution' },
  'accreditation.certificate':    { templateCode: 'accreditation-cert',    version: '1.0.0', entityType: 'Institution' },
  'consent.form':                 { templateCode: 'consent-standard',      version: '1.0.0', entityType: 'Application' },
  'safety.report':                { templateCode: 'safety-report',         version: '1.0.0', entityType: 'Application' },
  'risk.assessment':              { templateCode: 'risk-assessment',       version: '1.0.0', entityType: 'Application' },
  'notification.status':          { templateCode: 'notification-status-change', version: '1.0.0', entityType: 'Notification' },
  'email.generic':                { templateCode: 'email-generic',         version: '1.0.0', entityType: 'Committee' },
  'report.annual':                { templateCode: 'report-annual',         version: '1.0.0', entityType: 'Application' },
};
