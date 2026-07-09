-- =========================================================================
-- communication — TABLE
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: announcements; Type: TABLE; Schema: communication; Owner: -
--

CREATE TABLE communication.announcements (
    id bigint NOT NULL,
    title character varying(500) NOT NULL,
    announcement_body text NOT NULL,
    start_date date,
    end_date date,
    is_active boolean DEFAULT true NOT NULL,
    created_by bigint,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_communication_announcements_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: message_attachments; Type: TABLE; Schema: communication; Owner: -
--

CREATE TABLE communication.message_attachments (
    id bigint NOT NULL,
    message_id bigint NOT NULL,
    file_name character varying(500) NOT NULL,
    file_path character varying(1000) NOT NULL,
    file_size integer,
    mime_type character varying(100),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_communication_message_attachments_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: message_recipients; Type: TABLE; Schema: communication; Owner: -
--

CREATE TABLE communication.message_recipients (
    id bigint NOT NULL,
    message_id bigint NOT NULL,
    recipient_id bigint NOT NULL,
    is_read boolean DEFAULT false NOT NULL,
    read_at timestamp with time zone,
    is_deleted boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_communication_message_recipients_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: messages; Type: TABLE; Schema: communication; Owner: -
--

CREATE TABLE communication.messages (
    id bigint NOT NULL,
    sender_id bigint NOT NULL,
    subject character varying(500) NOT NULL,
    message_body text,
    related_entity_type character varying(50),
    related_entity_id bigint,
    is_deleted boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_communication_messages_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: notification_channels; Type: TABLE; Schema: communication; Owner: -
--

CREATE TABLE communication.notification_channels (
    id bigint NOT NULL,
    channel_code character varying(50) NOT NULL,
    channel_name character varying(200) NOT NULL,
    is_active boolean DEFAULT true NOT NULL
);


--

-- Name: notification_logs; Type: TABLE; Schema: communication; Owner: -
--

CREATE TABLE communication.notification_logs (
    id bigint NOT NULL,
    notification_id bigint NOT NULL,
    delivery_status character varying(50) NOT NULL,
    provider_reference character varying(500),
    error_message text,
    logged_at timestamp with time zone DEFAULT now() NOT NULL
);


--

-- Name: notification_templates; Type: TABLE; Schema: communication; Owner: -
--

CREATE TABLE communication.notification_templates (
    id bigint NOT NULL,
    template_code character varying(100) NOT NULL,
    template_name character varying(300) NOT NULL,
    channel_type character varying(50) NOT NULL,
    subject_template text,
    body_template text NOT NULL,
    is_active boolean DEFAULT true NOT NULL
);


--

-- Name: notifications; Type: TABLE; Schema: communication; Owner: -
--

CREATE TABLE communication.notifications (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    notification_type character varying(100) NOT NULL,
    channel_id bigint,
    subject character varying(500),
    message_body text NOT NULL,
    priority_level character varying(50) DEFAULT 'NORMAL'::character varying,
    is_read boolean DEFAULT false NOT NULL,
    sent_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    source_entity_type character varying(50),
    source_entity_id bigint,
    CONSTRAINT chk_communication_notifications_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);


--

-- Name: user_notification_preferences; Type: TABLE; Schema: communication; Owner: -
--

CREATE TABLE communication.user_notification_preferences (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    notification_type character varying(100) NOT NULL,
    channel character varying(50) NOT NULL,
    is_enabled boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone,
    CONSTRAINT user_notification_preferences_channel_check CHECK (((channel)::text = ANY (ARRAY[('IN_APP'::character varying)::text, ('EMAIL'::character varying)::text, ('SMS'::character varying)::text, ('PUSH'::character varying)::text])))
);


--


