-- =========================================================================
-- communication — COMMENT
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: COLUMN announcements.created_by; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON COLUMN communication.announcements.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN announcements.created_at; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON COLUMN communication.announcements.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN announcements.updated_at; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON COLUMN communication.announcements.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN announcements.updated_by; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON COLUMN communication.announcements.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN announcements.deleted_at; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON COLUMN communication.announcements.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN announcements.deleted_by; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON COLUMN communication.announcements.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: COLUMN message_attachments.created_at; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON COLUMN communication.message_attachments.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN message_attachments.created_by; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON COLUMN communication.message_attachments.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN message_attachments.updated_at; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON COLUMN communication.message_attachments.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN message_attachments.updated_by; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON COLUMN communication.message_attachments.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN message_attachments.deleted_at; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON COLUMN communication.message_attachments.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN message_attachments.deleted_by; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON COLUMN communication.message_attachments.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: COLUMN message_recipients.created_at; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON COLUMN communication.message_recipients.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN message_recipients.created_by; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON COLUMN communication.message_recipients.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN message_recipients.updated_at; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON COLUMN communication.message_recipients.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN message_recipients.updated_by; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON COLUMN communication.message_recipients.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN message_recipients.deleted_at; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON COLUMN communication.message_recipients.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN message_recipients.deleted_by; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON COLUMN communication.message_recipients.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: COLUMN messages.created_at; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON COLUMN communication.messages.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN messages.created_by; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON COLUMN communication.messages.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN messages.updated_at; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON COLUMN communication.messages.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN messages.updated_by; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON COLUMN communication.messages.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN messages.deleted_at; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON COLUMN communication.messages.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN messages.deleted_by; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON COLUMN communication.messages.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: COLUMN notifications.created_at; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON COLUMN communication.notifications.created_at IS 'Timestamp when the record was created. Set automatically via DEFAULT now().';


--

-- Name: COLUMN notifications.created_by; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON COLUMN communication.notifications.created_by IS 'User ID who created the record. NULL allowed for system-imported records.';


--

-- Name: COLUMN notifications.updated_at; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON COLUMN communication.notifications.updated_at IS 'Timestamp when the record was last modified. Set by application layer.';


--

-- Name: COLUMN notifications.updated_by; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON COLUMN communication.notifications.updated_by IS 'User ID who last modified the record. Set by application layer.';


--

-- Name: COLUMN notifications.deleted_at; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON COLUMN communication.notifications.deleted_at IS 'Timestamp when the record was soft-deleted. NULL = active (not deleted).';


--

-- Name: COLUMN notifications.deleted_by; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON COLUMN communication.notifications.deleted_by IS 'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.';


--

-- Name: COLUMN notifications.source_entity_type; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON COLUMN communication.notifications.source_entity_type IS 'نوع الكيان المصدر (Application, Condition, Certificate)';


--

-- Name: COLUMN notifications.source_entity_id; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON COLUMN communication.notifications.source_entity_id IS 'معرف الكيان المصدر';


--

-- Name: TABLE user_notification_preferences; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON TABLE communication.user_notification_preferences IS 'تفضيلات المستخدم لكل نوع إشعار وقناة توصيل';


--

-- Name: COLUMN user_notification_preferences.user_id; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON COLUMN communication.user_notification_preferences.user_id IS 'معرف المستخدم';


--

-- Name: COLUMN user_notification_preferences.notification_type; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON COLUMN communication.user_notification_preferences.notification_type IS 'نوع الإشعار (مثل APPLICATION_APPROVED)';


--

-- Name: COLUMN user_notification_preferences.channel; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON COLUMN communication.user_notification_preferences.channel IS 'قناة التوصيل (IN_APP, EMAIL, SMS, PUSH)';


--

-- Name: COLUMN user_notification_preferences.is_enabled; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON COLUMN communication.user_notification_preferences.is_enabled IS 'تفعيل الإشعار عبر هذه القناة لهذا النوع';


--

-- Name: POLICY notification_logs_insert ON notification_logs; Type: COMMENT; Schema: communication; Owner: -
--

COMMENT ON POLICY notification_logs_insert ON communication.notification_logs IS 'يسمح للمسؤولين والمستخدمين والتطبيق بإدراج سجلات التوصيل';


--


