import { IntegrationRepository } from '../repositories/integration.repository';

export class IntegrationService {
  private repo = new IntegrationRepository();

  async getEvents() { return this.repo.getEvents(); }
  async getLogs() { return this.repo.getLogs(); }
}
