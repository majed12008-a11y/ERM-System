import { ResolverRegistry } from '../template-resolver-registry';
import { EntityDataRepository } from './entity-data.repository';
import { ApplicationResolver } from './application.resolver';
import { ConditionResolver } from './condition.resolver';
import { UserResolver } from './user.resolver';
import { CommitteeResolver } from './committee.resolver';
import { InstitutionResolver } from './institution.resolver';
import { NotificationResolver } from './notification.resolver';
import { MeetingResolver } from './meeting.resolver';
import { ReviewResolver } from './review.resolver';
import { DocumentResolver } from './document.resolver';
import { ReportResolver } from './report.resolver';
import { CommunicationResolver } from './communication.resolver';
import { SafetyReportResolver } from './safety-report.resolver';

export function registerAllResolvers(registry: ResolverRegistry, entityDataRepo: EntityDataRepository): void {
  registry.register(new ApplicationResolver(entityDataRepo));
  registry.register(new ConditionResolver(entityDataRepo));
  registry.register(new UserResolver(entityDataRepo));
  registry.register(new CommitteeResolver(entityDataRepo));
  registry.register(new InstitutionResolver(entityDataRepo));
  registry.register(new NotificationResolver(entityDataRepo));
  registry.register(new MeetingResolver(entityDataRepo));
  registry.register(new ReviewResolver(entityDataRepo));
  registry.register(new DocumentResolver(entityDataRepo));
  registry.register(new ReportResolver(entityDataRepo));
  registry.register(new CommunicationResolver(entityDataRepo));
  registry.register(new SafetyReportResolver(entityDataRepo));
}

export { EntityDataRepository } from './entity-data.repository';
export { ApplicationResolver } from './application.resolver';
export { ConditionResolver } from './condition.resolver';
export { UserResolver } from './user.resolver';
export { CommitteeResolver } from './committee.resolver';
export { InstitutionResolver } from './institution.resolver';
export { NotificationResolver } from './notification.resolver';
export { MeetingResolver } from './meeting.resolver';
export { ReviewResolver } from './review.resolver';
export { DocumentResolver } from './document.resolver';
export { ReportResolver } from './report.resolver';
export { CommunicationResolver } from './communication.resolver';
export { SafetyReportResolver } from './safety-report.resolver';
