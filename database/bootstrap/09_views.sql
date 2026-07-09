-- =========================================================================
-- 09_views.sql — Views and materialized views
-- Auto-generated from canonical extraction
-- =========================================================================

-- =========================================================================
-- reporting — VIEW
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: vw_application_timeline; Type: VIEW; Schema: reporting; Owner: -
--

CREATE VIEW reporting.vw_application_timeline AS
 SELECT ah.application_id,
    a.application_number,
    ah.action_type,
    ah.old_value,
    ah.new_value,
    ah.action_by,
    u.username AS action_by_user,
    ah.action_at,
    ah.remarks
   FROM ((core.application_history ah
     JOIN core.applications a ON ((ah.application_id = a.id)))
     LEFT JOIN security.users u ON ((ah.action_by = u.id)))
  ORDER BY ah.action_at DESC;


--

-- Name: vw_committee_members_active; Type: VIEW; Schema: reporting; Owner: -
--

CREATE VIEW reporting.vw_committee_members_active AS
 SELECT c.id AS committee_id,
    c.committee_name_ar,
    cm.user_id,
    u.username,
    (((u.first_name_ar)::text || ' '::text) || (u.last_name_ar)::text) AS full_name_ar,
    cm.membership_start_date,
    cm.membership_end_date,
    cr.role_name AS committee_role
   FROM ((((committee.committee_members cm
     JOIN committee.committees c ON ((cm.committee_id = c.id)))
     JOIN security.users u ON ((cm.user_id = u.id)))
     LEFT JOIN committee.committee_member_roles cmr ON ((cmr.member_id = cm.id)))
     LEFT JOIN committee.committee_roles cr ON ((cmr.role_id = cr.id)))
  WHERE (cm.is_active = true);


--

-- Name: vw_dashboard_application_stats; Type: VIEW; Schema: reporting; Owner: -
--

CREATE VIEW reporting.vw_dashboard_application_stats AS
 SELECT a.current_status,
    s.status_name_ar AS status_name,
    count(*) AS application_count,
    (((count(*))::numeric * 100.0) / NULLIF(sum(count(*)) OVER (), (0)::numeric)) AS percentage,
    count(
        CASE
            WHEN (a.created_at >= (now() - '30 days'::interval)) THEN 1
            ELSE NULL::integer
        END) AS last_30_days,
    count(
        CASE
            WHEN (a.created_at >= (now() - '7 days'::interval)) THEN 1
            ELSE NULL::integer
        END) AS last_7_days
   FROM (core.applications a
     LEFT JOIN reference.application_statuses s ON (((a.current_status)::text = (s.status_code)::text)))
  GROUP BY a.current_status, s.status_name_ar
  ORDER BY (count(*)) DESC;


--

-- Name: vw_dashboard_committee_workload; Type: VIEW; Schema: reporting; Owner: -
--

CREATE VIEW reporting.vw_dashboard_committee_workload AS
 SELECT c.id AS committee_id,
    c.committee_name_ar,
    count(DISTINCT a.id) AS total_applications,
    count(DISTINCT
        CASE
            WHEN ((a.current_status)::text = 'UNDER_REVIEW'::text) THEN a.id
            ELSE NULL::bigint
        END) AS under_review,
    count(DISTINCT
        CASE
            WHEN ((a.current_status)::text = 'SUBMITTED'::text) THEN a.id
            ELSE NULL::bigint
        END) AS pending_review,
    count(DISTINCT cm.id) AS member_count,
    count(DISTINCT mtg.id) AS meeting_count
   FROM (((committee.committees c
     LEFT JOIN core.applications a ON ((a.target_committee_id = c.id)))
     LEFT JOIN committee.committee_members cm ON (((cm.committee_id = c.id) AND (cm.is_active = true))))
     LEFT JOIN committee.committee_meetings mtg ON ((mtg.committee_id = c.id)))
  GROUP BY c.id, c.committee_name_ar;


--

-- Name: vw_dashboard_institution_stats; Type: VIEW; Schema: reporting; Owner: -
--

CREATE VIEW reporting.vw_dashboard_institution_stats AS
 SELECT i.id AS institution_id,
    i.name_ar AS institution_name,
    it.name_ar AS institution_type,
    count(DISTINCT u.id) AS user_count,
    count(DISTINCT p.id) AS project_count,
    count(DISTINCT a.id) AS application_count,
    count(DISTINCT c.id) AS committee_count
   FROM (((((security.institutions i
     LEFT JOIN security.institution_types it ON ((i.institution_type_id = it.id)))
     LEFT JOIN security.users u ON ((u.institution_id = i.id)))
     LEFT JOIN core.projects p ON ((p.institution_id = i.id)))
     LEFT JOIN core.applications a ON ((a.id IN ( SELECT p2.id
           FROM core.projects p2
          WHERE (p2.institution_id = i.id)))))
     LEFT JOIN committee.committees c ON ((c.institution_id = i.id)))
  GROUP BY i.id, i.name_ar, it.name_ar;


--

-- Name: vw_dashboard_review_times; Type: VIEW; Schema: reporting; Owner: -
--

CREATE VIEW reporting.vw_dashboard_review_times AS
 SELECT sr.application_id,
    a.application_number,
    sr.reviewer_id,
    u.username AS reviewer_username,
    sr.review_type,
    sr.assigned_at,
        CASE
            WHEN ((sr.status_code)::text = 'COMPLETED'::text) THEN (sr.assigned_at + '1 day'::interval)
            ELSE NULL::timestamp with time zone
        END AS completed_at,
    (EXTRACT(epoch FROM (now() - sr.assigned_at)) / (3600)::numeric) AS hours_in_review,
        CASE
            WHEN ((sr.status_code)::text = 'COMPLETED'::text) THEN 'Completed'::character varying
            ELSE sr.status_code
        END AS review_status
   FROM ((committee.review_assignments sr
     JOIN core.applications a ON ((sr.application_id = a.id)))
     JOIN security.users u ON ((sr.reviewer_id = u.id)));


--

-- Name: vw_kpi_approval_rate; Type: VIEW; Schema: reporting; Owner: -
--

CREATE VIEW reporting.vw_kpi_approval_rate AS
 SELECT (date_trunc('month'::text, decision_date))::date AS month,
    count(*) AS total_decisions,
    count(
        CASE
            WHEN ((decision_code)::text = ANY (ARRAY[('APPROVED'::character varying)::text, ('CONDITIONAL_APPROVAL'::character varying)::text])) THEN 1
            ELSE NULL::integer
        END) AS approved,
    (((count(
        CASE
            WHEN ((decision_code)::text = ANY (ARRAY[('APPROVED'::character varying)::text, ('CONDITIONAL_APPROVAL'::character varying)::text])) THEN 1
            ELSE NULL::integer
        END))::numeric * 100.0) / (NULLIF(count(*), 0))::numeric) AS approval_rate_percentage
   FROM ( SELECT a_1.id,
            a_1.submission_date AS decision_date,
            a_1.current_status AS decision_code
           FROM core.applications a_1
          WHERE ((a_1.current_status)::text = ANY (ARRAY[('APPROVED'::character varying)::text, ('CONDITIONAL_APPROVED'::character varying)::text, ('REJECTED'::character varying)::text]))) a
  GROUP BY (date_trunc('month'::text, decision_date))
  ORDER BY ((date_trunc('month'::text, decision_date))::date) DESC;


--

-- Name: vw_kpi_average_review_duration; Type: VIEW; Schema: reporting; Owner: -
--

CREATE VIEW reporting.vw_kpi_average_review_duration AS
 SELECT (a.submission_date)::date AS submission_date,
    'REVIEW'::text AS review_type,
    count(DISTINCT ra.id) AS total_reviews,
    count(DISTINCT
        CASE
            WHEN ((a.current_status)::text = ANY (ARRAY[('APPROVED'::character varying)::text, ('CONDITIONAL_APPROVED'::character varying)::text, ('REJECTED'::character varying)::text])) THEN ra.id
            ELSE NULL::bigint
        END) AS completed_reviews
   FROM (core.applications a
     JOIN committee.review_assignments ra ON ((ra.application_id = a.id)))
  GROUP BY ((a.submission_date)::date)
  ORDER BY ((a.submission_date)::date) DESC;


--

-- Name: vw_pending_sla_tasks; Type: VIEW; Schema: reporting; Owner: -
--

CREATE VIEW reporting.vw_pending_sla_tasks AS
 SELECT wt.id AS task_id,
    wt.task_code,
    wt.task_name,
    wt.due_date,
    (EXTRACT(epoch FROM (now() - wt.due_date)) / (3600)::numeric) AS overdue_hours,
    u.username AS assigned_to_user,
    wi.entity_type,
    wi.entity_id,
    wsla.max_duration_hours
   FROM (((workflow.workflow_tasks wt
     JOIN workflow.workflow_instances wi ON ((wt.workflow_instance_id = wi.id)))
     JOIN workflow.workflow_sla wsla ON (((wsla.workflow_id = wi.workflow_id) AND (wsla.state_id = wi.current_state_id))))
     LEFT JOIN security.users u ON ((wt.assigned_to = u.id)))
  WHERE (((wt.task_status)::text = 'OPEN'::text) AND (wt.due_date < now()))
  ORDER BY wt.due_date;


--

-- Name: vw_upcoming_meetings; Type: VIEW; Schema: reporting; Owner: -
--

CREATE VIEW reporting.vw_upcoming_meetings AS
 SELECT mtg.id AS meeting_id,
    mtg.meeting_number,
    mtg.meeting_date,
    mtg.meeting_status,
    mtg.location,
    c.committee_name_ar,
    c.id AS committee_id,
    count(DISTINCT ag.id) AS agenda_items_count,
    count(DISTINCT att.id) AS attendees_count
   FROM (((committee.committee_meetings mtg
     JOIN committee.committees c ON ((mtg.committee_id = c.id)))
     LEFT JOIN committee.meeting_agendas ag ON ((ag.meeting_id = mtg.id)))
     LEFT JOIN committee.attendance_logs att ON ((att.meeting_id = mtg.id)))
  WHERE (mtg.meeting_date >= now())
  GROUP BY mtg.id, mtg.meeting_number, mtg.meeting_date, mtg.meeting_status, mtg.location, c.committee_name_ar, c.id;


--

-- Name: vw_user_applications; Type: VIEW; Schema: reporting; Owner: -
--

CREATE VIEW reporting.vw_user_applications AS
 SELECT a.id,
    a.application_number,
    a.application_type,
    a.current_status,
    s.status_name_ar AS status_name,
    a.submission_date,
    a.created_at,
    p.title_ar AS project_title,
    p.project_code,
    i.name_ar AS institution_name,
    u.username AS submitted_by_user,
    COALESCE(( SELECT sr.recommendation
           FROM committee.scientific_reviews sr
          WHERE ((sr.application_id = a.id) AND (sr.completed_at IS NOT NULL))
         LIMIT 1), 'Pending'::character varying) AS scientific_recommendation
   FROM ((((core.applications a
     LEFT JOIN reference.application_statuses s ON (((a.current_status)::text = (s.status_code)::text)))
     LEFT JOIN core.projects p ON ((a.project_id = p.id)))
     LEFT JOIN security.institutions i ON ((p.institution_id = i.id)))
     LEFT JOIN security.users u ON ((a.submitted_by = u.id)));


--



-- =========================================================================
-- reporting — MATERIALIZED_VIEW
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: mv_committee_performance; Type: MATERIALIZED VIEW; Schema: reporting; Owner: -
--

CREATE MATERIALIZED VIEW reporting.mv_committee_performance AS
 SELECT c.id AS committee_id,
    c.committee_name_ar,
    (date_trunc('month'::text, a.created_at))::date AS month,
    count(DISTINCT a.id) AS applications_received,
    count(DISTINCT
        CASE
            WHEN ((a.current_status)::text = ANY (ARRAY[('APPROVED'::character varying)::text, ('CONDITIONAL_APPROVED'::character varying)::text, ('REJECTED'::character varying)::text])) THEN a.id
            ELSE NULL::bigint
        END) AS applications_decided,
    (avg(
        CASE
            WHEN ((a.current_status)::text = ANY (ARRAY[('APPROVED'::character varying)::text, ('CONDITIONAL_APPROVED'::character varying)::text, ('REJECTED'::character varying)::text])) THEN (EXTRACT(epoch FROM (a.updated_at - a.created_at)) / (86400)::numeric)
            ELSE NULL::numeric
        END))::numeric(10,2) AS avg_days_to_decision,
    count(DISTINCT mtg.id) AS meetings_held
   FROM ((committee.committees c
     LEFT JOIN core.applications a ON ((a.target_committee_id = c.id)))
     LEFT JOIN committee.committee_meetings mtg ON (((mtg.committee_id = c.id) AND (date_trunc('month'::text, mtg.meeting_date) = date_trunc('month'::text, a.created_at)))))
  GROUP BY c.id, c.committee_name_ar, (date_trunc('month'::text, a.created_at))
  WITH NO DATA;


--

-- Name: mv_daily_application_snapshot; Type: MATERIALIZED VIEW; Schema: reporting; Owner: -
--

CREATE MATERIALIZED VIEW reporting.mv_daily_application_snapshot AS
 SELECT CURRENT_DATE AS snapshot_date,
    a.current_status,
    s.status_name_ar,
    count(*) AS count
   FROM (core.applications a
     LEFT JOIN reference.application_statuses s ON (((a.current_status)::text = (s.status_code)::text)))
  GROUP BY a.current_status, s.status_name_ar
  WITH NO DATA;


--




