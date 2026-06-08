import { SafetyRepository } from '../repositories/safety.repository';
import { AuthUser } from '../shared/types';

export class SafetyService {
  private repo = new SafetyRepository();

  async getRiskRegister(user: AuthUser) { return this.repo.getRiskRegister(user.id, user.roles); }
  async createRisk(data: any, user: AuthUser) { return this.repo.createRisk(data, user.id); }

  async updateRisk(id: number, data: any) {
    const result = await this.repo.updateRisk(id, data);
    if (!result) throw Object.assign(new Error('Risk not found'), { status: 404 });
    return result;
  }

  async softDeleteRisk(id: number) {
    const ok = await this.repo.softDeleteRisk(id);
    if (!ok) throw Object.assign(new Error('Risk not found or already deleted'), { status: 404 });
  }

  async getMitigations(riskId: number) { return this.repo.getMitigations(riskId); }
  async createMitigation(riskId: number, data: any) { return this.repo.createMitigation(riskId, data); }
  async getIncidents() { return this.repo.getIncidents(); }
  async createIncident(data: any, user: AuthUser) { return this.repo.createIncident(data, user.id); }
  async getCorrectiveActions() { return this.repo.getCorrectiveActions(); }
  async createCorrectiveAction(data: any) { return this.repo.createCorrectiveAction(data); }
  async getAdverseEvents(user: AuthUser) { return this.repo.getAdverseEvents(user.id, user.roles); }
  async getSeriousAdverseEvents() { return this.repo.getSeriousAdverseEvents(); }
  async getSafetyReports() { return this.repo.getSafetyReports(); }
}
