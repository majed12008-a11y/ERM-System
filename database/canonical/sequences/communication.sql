-- =========================================================================
-- communication — DEFAULT
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: message_attachments id; Type: DEFAULT; Schema: communication; Owner: -
--

ALTER TABLE ONLY communication.message_attachments ALTER COLUMN id SET DEFAULT nextval('communication.message_attachments_id_seq'::regclass);


--

-- Name: message_recipients id; Type: DEFAULT; Schema: communication; Owner: -
--

ALTER TABLE ONLY communication.message_recipients ALTER COLUMN id SET DEFAULT nextval('communication.message_recipients_id_seq'::regclass);


--

-- Name: messages id; Type: DEFAULT; Schema: communication; Owner: -
--

ALTER TABLE ONLY communication.messages ALTER COLUMN id SET DEFAULT nextval('communication.messages_id_seq'::regclass);


--


-- =========================================================================
-- communication — SEQUENCE
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: announcements_id_seq; Type: SEQUENCE; Schema: communication; Owner: -
--

ALTER TABLE communication.announcements ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME communication.announcements_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: message_attachments_id_seq; Type: SEQUENCE; Schema: communication; Owner: -
--

CREATE SEQUENCE communication.message_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--

-- Name: message_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: communication; Owner: -
--

ALTER SEQUENCE communication.message_attachments_id_seq OWNED BY communication.message_attachments.id;


--

-- Name: message_recipients_id_seq; Type: SEQUENCE; Schema: communication; Owner: -
--

CREATE SEQUENCE communication.message_recipients_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--

-- Name: message_recipients_id_seq; Type: SEQUENCE OWNED BY; Schema: communication; Owner: -
--

ALTER SEQUENCE communication.message_recipients_id_seq OWNED BY communication.message_recipients.id;


--

-- Name: messages_id_seq; Type: SEQUENCE; Schema: communication; Owner: -
--

CREATE SEQUENCE communication.messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--

-- Name: messages_id_seq; Type: SEQUENCE OWNED BY; Schema: communication; Owner: -
--

ALTER SEQUENCE communication.messages_id_seq OWNED BY communication.messages.id;


--

-- Name: notification_channels_id_seq; Type: SEQUENCE; Schema: communication; Owner: -
--

ALTER TABLE communication.notification_channels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME communication.notification_channels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: notification_logs_id_seq; Type: SEQUENCE; Schema: communication; Owner: -
--

ALTER TABLE communication.notification_logs ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME communication.notification_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: notification_templates_id_seq; Type: SEQUENCE; Schema: communication; Owner: -
--

ALTER TABLE communication.notification_templates ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME communication.notification_templates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: notifications_id_seq; Type: SEQUENCE; Schema: communication; Owner: -
--

ALTER TABLE communication.notifications ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME communication.notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--

-- Name: user_notification_preferences_id_seq; Type: SEQUENCE; Schema: communication; Owner: -
--

ALTER TABLE communication.user_notification_preferences ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME communication.user_notification_preferences_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--


