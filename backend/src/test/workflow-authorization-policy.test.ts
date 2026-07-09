import { describe, it, expect } from 'vitest';
import { WorkflowAuthorizationPolicy } from '../services/workflow-authorization.policy';

describe('WorkflowAuthorizationPolicy', () => {
  const policy = new WorkflowAuthorizationPolicy();

  describe('requiresOwnership', () => {
    it('returns true when allowed_roles contains RESEARCHER', () => {
      expect(policy.requiresOwnership('Application', { allowed_roles: 'RESEARCHER' })).toBe(true);
    });

    it('returns true when allowed_roles contains RESEARCHER among others', () => {
      expect(policy.requiresOwnership('Application', { allowed_roles: 'RESEARCHER,ETHICS_ADMIN,SUPER_ADMIN' })).toBe(true);
    });

    it('returns false when allowed_roles does not contain RESEARCHER', () => {
      expect(policy.requiresOwnership('Application', { allowed_roles: 'ETHICS_ADMIN,SUPER_ADMIN' })).toBe(false);
    });

    it('returns false when allowed_roles is null', () => {
      expect(policy.requiresOwnership('Application', { allowed_roles: null })).toBe(false);
    });

    it('returns false for non-Application entity types', () => {
      expect(policy.requiresOwnership('Project', { allowed_roles: 'RESEARCHER' })).toBe(false);
    });
  });

  describe('canBypassOwnership', () => {
    it('returns true for SUPER_ADMIN', () => {
      expect(policy.canBypassOwnership({ roles: ['SUPER_ADMIN'] })).toBe(true);
    });

    it('returns true for ETHICS_ADMIN', () => {
      expect(policy.canBypassOwnership({ roles: ['ETHICS_ADMIN'] })).toBe(true);
    });

    it('returns true for COMMITTEE_CHAIR', () => {
      expect(policy.canBypassOwnership({ roles: ['COMMITTEE_CHAIR'] })).toBe(true);
    });

    it('returns false for RESEARCHER only', () => {
      expect(policy.canBypassOwnership({ roles: ['RESEARCHER'] })).toBe(false);
    });

    it('returns true when user has both RESEARCHER and ETHICS_ADMIN', () => {
      expect(policy.canBypassOwnership({ roles: ['RESEARCHER', 'ETHICS_ADMIN'] })).toBe(true);
    });

    it('returns false for empty roles', () => {
      expect(policy.canBypassOwnership({ roles: [] })).toBe(false);
    });
  });
});
