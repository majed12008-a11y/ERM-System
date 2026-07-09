export class WorkflowAuthorizationPolicy {
  private ownerRoles: ReadonlySet<string> = new Set(['RESEARCHER']);
  private adminRoles: ReadonlySet<string> = new Set([
    'SUPER_ADMIN',
    'ETHICS_ADMIN',
    'COMMITTEE_CHAIR',
  ]);

  requiresOwnership(entityType: string, transition: { allowed_roles: string | null }): boolean {
    if (entityType !== 'Application') return false;
    if (!transition.allowed_roles) return false;
    const roles = transition.allowed_roles.split(',').map(r => r.trim());
    return roles.some(r => this.ownerRoles.has(r));
  }

  canBypassOwnership(user: { roles: string[] }): boolean {
    return user.roles.some(r => this.adminRoles.has(r));
  }
}
