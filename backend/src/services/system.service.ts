import { SystemRepository } from '../repositories/system.repository';

export class SystemService {
  private repo = new SystemRepository();

  async getSavedSearches(userId: number) { return this.repo.getSavedSearches(userId); }

  async createSavedSearch(userId: number, data: {
    name: string; search_type: string; criteria: any; is_shared?: boolean;
  }) {
    return this.repo.createSavedSearch({ ...data, user_id: userId });
  }

  async updateSavedSearch(id: number, userId: number, data: {
    name?: string; criteria?: any; is_shared?: boolean;
  }) {
    return this.repo.updateSavedSearch(id, userId, data);
  }

  async deleteSavedSearch(id: number, userId: number) {
    return this.repo.softDeleteSavedSearch(id, userId);
  }

  async getConfig() { return this.repo.getConfig(); }
}
