import { Router } from 'express';
import { TemplateRepository } from '../../repositories/template.repository';
import { TemplateVersionRepository } from '../../repositories/template-version.repository';
import { TemplateCategoryRepository } from '../../repositories/template-category.repository';
import { TemplateAuditRepository } from '../../repositories/template-audit.repository';
import { TemplateOutputRepository } from '../../repositories/template-output.repository';
import { TemplateRenderHistoryRepository } from '../../repositories/template-render-history.repository';
import { TemplateApprovalWorkflowRepository } from '../../repositories/template-approval-workflow.repository';
import { TemplateEngineService } from '../../services/template-engine.service';
import { TemplateResolverService } from '../../services/template-resolver.service';
import { ResolverRegistry } from '../../services/template-resolver-registry';
import { EntityDataRepository } from '../../services/resolvers/entity-data.repository';
import { registerAllResolvers } from '../../services/resolvers';
import { SnapshotService } from '../../services/template-snapshot.service';
import { VersionLifecycleService } from '../../services/template-version-lifecycle.service';
import { TemplateIntegrationService } from '../../services/template-integration.service';
import { TimelineService } from '../../services/template-timeline.service';
import { RollbackService } from '../../services/template-rollback.service';
import { TemplateDocumentService } from '../../services/template-document.service';
import templateRoutes from './template.routes';
import templateVersionRoutes from './template-version.routes';
import templatePreviewRoutes from './template-preview.routes';
import templateRenderRoutes from './template-render.routes';
import templateHistoryRoutes from './template-history.routes';
import templateSnapshotRoutes from './template-snapshot.routes';
import templateRollbackRoutes from './template-rollback.routes';
import templateCategoriesRoutes from './template-categories.routes';
import templateDocumentRoutes from './template-document.routes';

const templateRepo = new TemplateRepository();
const versionRepo = new TemplateVersionRepository();
const categoryRepo = new TemplateCategoryRepository();
const auditRepo = new TemplateAuditRepository();
const outputRepo = new TemplateOutputRepository();
const renderHistoryRepo = new TemplateRenderHistoryRepository();
const approvalRepo = new TemplateApprovalWorkflowRepository();
const entityDataRepo = new EntityDataRepository();

const registry = new ResolverRegistry();
registerAllResolvers(registry, entityDataRepo);

const resolverService = new TemplateResolverService(registry);
const engineService = new TemplateEngineService(versionRepo, resolverService);
const snapshotService = new SnapshotService();

const lifecycleService = new VersionLifecycleService(versionRepo, auditRepo, approvalRepo);
const timelineService = new TimelineService(versionRepo, auditRepo, templateRepo);
const rollbackService = new RollbackService(lifecycleService, timelineService, versionRepo);
const integrationService = new TemplateIntegrationService(engineService, snapshotService, versionRepo);
const documentService = new TemplateDocumentService(integrationService, engineService);

const router = Router();

router.use('/', templateRoutes(templateRepo));
router.use('/', templateVersionRoutes(templateRepo, versionRepo, lifecycleService));
router.use('/', templatePreviewRoutes(engineService));
router.use('/', templateRenderRoutes(integrationService));
router.use('/', templateHistoryRoutes(lifecycleService));
router.use('/', templateSnapshotRoutes(snapshotService));
router.use('/', templateRollbackRoutes(rollbackService));
router.use('/categories', templateCategoriesRoutes(categoryRepo));
router.use('/', templateDocumentRoutes(documentService));

export default router;
