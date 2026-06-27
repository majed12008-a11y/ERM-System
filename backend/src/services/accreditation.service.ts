/*
 * نظام الاعتماد المؤسسي للجنة الأخلاقيات:
 * إدارة دورات الاعتماد، التقييمات، الشروط،
 * الأدلة، وقرارات الاعتماد.
 */
import { AccreditationCycleRepository } from '../repositories/accreditation-cycle.repository';
import { AccreditationAssessmentRepository } from '../repositories/accreditation-assessment.repository';
import { AccreditationDecisionRepository } from '../repositories/accreditation-decision.repository';
import { AccreditationEvidenceRepository } from '../repositories/accreditation-evidence.repository';
import { AccreditationConditionRepository } from '../repositories/accreditation-condition.repository';
import { canTransition, DECISION_TYPE_STATUS_MAP } from '../shared/accreditation.constants';

export class AccreditationService {
  private cycleRepo = new AccreditationCycleRepository();
  private assessmentRepo = new AccreditationAssessmentRepository();
  private decisionRepo = new AccreditationDecisionRepository();
  private evidenceRepo = new AccreditationEvidenceRepository();
  private conditionRepo = new AccreditationConditionRepository();

  // --- Cycles ---

  async getCycles() {
    return this.cycleRepo.findAll();
  }

  async getCycle(id: number) {
    const cycle = await this.cycleRepo.findById(id);
    if (!cycle) throw Object.assign(new Error('Cycle not found'), { status: 404 });
    return cycle;
  }

  async createCycle(data: { committee_id: number; standard_version_id: number; cycle_number?: number }) {
    const existing = await this.cycleRepo.findActiveByCommittee(data.committee_id);
    if (existing) {
      throw Object.assign(new Error('Committee already has an active cycle. Complete or revoke it first.'), { status: 409 });
    }
    return this.cycleRepo.create(data);
  }

  async updateCycleStatus(id: number, data: {
    to_status: string; decision: string; decided_by: number; decision_reason?: string; notes?: string;
  }) {
    const cycle = await this.cycleRepo.findById(id);
    if (!cycle) throw Object.assign(new Error('Cycle not found'), { status: 404 });

    if (!canTransition(cycle.status as any, data.to_status as any)) {
      throw Object.assign(
        new Error(`Invalid transition from ${cycle.status} to ${data.to_status}`),
        { status: 422 }
      );
    }

    const expectedTo = DECISION_TYPE_STATUS_MAP[data.decision];
    if (expectedTo !== data.to_status) {
      throw Object.assign(
        new Error(`Decision type ${data.decision} maps to status ${expectedTo}, not ${data.to_status}`),
        { status: 422 }
      );
    }

    return this.cycleRepo.updateStatus(id, cycle.status, data.to_status, data.decision, data.decided_by, data.decision_reason, data.notes);
  }

  async deleteCycle(id: number) {
    return this.cycleRepo.softDelete(id);
  }

  // --- Standards ---

  async getStandards(activeOnly = false) {
    if (activeOnly) return this.cycleRepo.getActiveStandards();
    return this.cycleRepo.getStandards();
  }

  // --- Assessments ---

  async getAssessments(cycleId: number) {
    return this.assessmentRepo.findByCycle(cycleId);
  }

  async getAssessment(id: number) {
    const assessment = await this.assessmentRepo.findById(id);
    if (!assessment) throw Object.assign(new Error('Assessment not found'), { status: 404 });
    return assessment;
  }

  async createAssessment(data: {
    cycle_id: number; assessed_by: number; overall_decision: string;
    overall_justification?: string; items?: any[];
  }) {
    const cycle = await this.cycleRepo.findById(data.cycle_id);
    if (!cycle) throw Object.assign(new Error('Cycle not found'), { status: 404 });
    if (cycle.status !== 'UNDER_REVIEW') {
      throw Object.assign(new Error('Can only assess cycles in UNDER_REVIEW status'), { status: 422 });
    }
    return this.assessmentRepo.create(data);
  }

  async updateAssessmentItems(assessmentId: number, items: any[]) {
    const assessment = await this.assessmentRepo.findById(assessmentId);
    if (!assessment) throw Object.assign(new Error('Assessment not found'), { status: 404 });
    return this.assessmentRepo.updateItems(assessmentId, items);
  }

  async deleteAssessment(id: number) {
    return this.assessmentRepo.softDelete(id);
  }

  // --- Evidence ---

  async getEvidence(cycleId: number) {
    return this.evidenceRepo.findByCycle(cycleId);
  }

  async getEvidenceItem(id: number) {
    const evidence = await this.evidenceRepo.findById(id);
    if (!evidence) throw Object.assign(new Error('Evidence not found'), { status: 404 });
    return evidence;
  }

  async createEvidence(data: {
    cycle_id: number; uploaded_by: number; standard_version_id?: number; document_id?: number; notes?: string;
  }) {
    return this.evidenceRepo.create(data);
  }

  async updateEvidenceStatus(id: number, status: string, reviewedBy?: number, reviewNotes?: string) {
    const evidence = await this.evidenceRepo.findById(id);
    if (!evidence) throw Object.assign(new Error('Evidence not found'), { status: 404 });
    return this.evidenceRepo.updateStatus(id, status, reviewedBy, reviewNotes);
  }

  async deleteEvidence(id: number) {
    return this.evidenceRepo.softDelete(id);
  }

  // --- Decisions ---

  async getDecisions(cycleId: number) {
    return this.decisionRepo.findByCycle(cycleId);
  }

  async getDecision(id: number) {
    const decision = await this.decisionRepo.findById(id);
    if (!decision) throw Object.assign(new Error('Decision not found'), { status: 404 });
    return decision;
  }

  async createDecision(data: {
    cycle_id: number; from_status?: string; to_status: string;
    decision: string; decided_by: number; decision_reason?: string; notes?: string;
  }) {
    return this.decisionRepo.create(data);
  }

  // --- Conditions ---

  async getConditions(cycleId: number) {
    return this.conditionRepo.findByCycle(cycleId);
  }

  async getCondition(id: number) {
    const condition = await this.conditionRepo.findById(id);
    if (!condition) throw Object.assign(new Error('Condition not found'), { status: 404 });
    return condition;
  }

  async createCondition(data: {
    cycle_id: number; condition_text: string; due_date: string;
    severity?: string; assessment_id?: number; assessment_item_id?: number; standard_version_id?: number;
  }) {
    const cycle = await this.cycleRepo.findById(data.cycle_id);
    if (!cycle) throw Object.assign(new Error('Cycle not found'), { status: 404 });
    return this.conditionRepo.create(data);
  }

  async resolveCondition(id: number, status: string, resolvedBy?: number) {
    const condition = await this.conditionRepo.findById(id);
    if (!condition) throw Object.assign(new Error('Condition not found'), { status: 404 });
    return this.conditionRepo.updateStatus(id, status, resolvedBy);
  }
}
