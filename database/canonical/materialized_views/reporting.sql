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


