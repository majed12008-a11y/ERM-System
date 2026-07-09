-- =========================================================================
-- 01_domains.sql — Custom domains
-- Auto-generated from canonical extraction
-- =========================================================================

-- =========================================================================
-- documents — DOMAIN
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: certificate_status; Type: DOMAIN; Schema: documents; Owner: -
--

CREATE DOMAIN documents.certificate_status AS character varying(20)
	CONSTRAINT certificate_status_check CHECK (((VALUE)::text = ANY (ARRAY[('DRAFT'::character varying)::text, ('GENERATING'::character varying)::text, ('ISSUED'::character varying)::text, ('REVOKED'::character varying)::text, ('SUPERSEDED'::character varying)::text, ('FAILED'::character varying)::text])));


--




