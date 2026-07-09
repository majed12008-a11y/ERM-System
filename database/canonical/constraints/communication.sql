-- =========================================================================
-- communication — CONSTRAINT
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: message_attachments message_attachments_pkey; Type: CONSTRAINT; Schema: communication; Owner: -
--

ALTER TABLE ONLY communication.message_attachments
    ADD CONSTRAINT message_attachments_pkey PRIMARY KEY (id);


--

-- Name: message_recipients message_recipients_pkey; Type: CONSTRAINT; Schema: communication; Owner: -
--

ALTER TABLE ONLY communication.message_recipients
    ADD CONSTRAINT message_recipients_pkey PRIMARY KEY (id);


--

-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: communication; Owner: -
--

ALTER TABLE ONLY communication.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--

-- Name: announcements pk_announcements; Type: CONSTRAINT; Schema: communication; Owner: -
--

ALTER TABLE ONLY communication.announcements
    ADD CONSTRAINT pk_announcements PRIMARY KEY (id);


--

-- Name: notification_channels pk_notification_channels; Type: CONSTRAINT; Schema: communication; Owner: -
--

ALTER TABLE ONLY communication.notification_channels
    ADD CONSTRAINT pk_notification_channels PRIMARY KEY (id);


--

-- Name: notification_logs pk_notification_logs; Type: CONSTRAINT; Schema: communication; Owner: -
--

ALTER TABLE ONLY communication.notification_logs
    ADD CONSTRAINT pk_notification_logs PRIMARY KEY (id);


--

-- Name: notification_templates pk_notification_templates; Type: CONSTRAINT; Schema: communication; Owner: -
--

ALTER TABLE ONLY communication.notification_templates
    ADD CONSTRAINT pk_notification_templates PRIMARY KEY (id);


--

-- Name: notifications pk_notifications; Type: CONSTRAINT; Schema: communication; Owner: -
--

ALTER TABLE ONLY communication.notifications
    ADD CONSTRAINT pk_notifications PRIMARY KEY (id);


--

-- Name: notification_channels uq_notification_channels; Type: CONSTRAINT; Schema: communication; Owner: -
--

ALTER TABLE ONLY communication.notification_channels
    ADD CONSTRAINT uq_notification_channels UNIQUE (channel_code);


--

-- Name: notification_templates uq_notification_templates_code; Type: CONSTRAINT; Schema: communication; Owner: -
--

ALTER TABLE ONLY communication.notification_templates
    ADD CONSTRAINT uq_notification_templates_code UNIQUE (template_code);


--

-- Name: user_notification_preferences uq_user_notif_pref; Type: CONSTRAINT; Schema: communication; Owner: -
--

ALTER TABLE ONLY communication.user_notification_preferences
    ADD CONSTRAINT uq_user_notif_pref UNIQUE (user_id, notification_type, channel);


--

-- Name: user_notification_preferences user_notification_preferences_pkey; Type: CONSTRAINT; Schema: communication; Owner: -
--

ALTER TABLE ONLY communication.user_notification_preferences
    ADD CONSTRAINT user_notification_preferences_pkey PRIMARY KEY (id);


--


-- =========================================================================
-- communication — FK_CONSTRAINT
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: announcements fk_announcements_user; Type: FK CONSTRAINT; Schema: communication; Owner: -
--

ALTER TABLE ONLY communication.announcements
    ADD CONSTRAINT fk_announcements_user FOREIGN KEY (created_by) REFERENCES security.users(id);


--

-- Name: notification_logs fk_notification_logs_notification; Type: FK CONSTRAINT; Schema: communication; Owner: -
--

ALTER TABLE ONLY communication.notification_logs
    ADD CONSTRAINT fk_notification_logs_notification FOREIGN KEY (notification_id) REFERENCES communication.notifications(id) ON DELETE CASCADE;


--

-- Name: notifications fk_notifications_user; Type: FK CONSTRAINT; Schema: communication; Owner: -
--

ALTER TABLE ONLY communication.notifications
    ADD CONSTRAINT fk_notifications_user FOREIGN KEY (user_id) REFERENCES security.users(id);


--

-- Name: message_attachments message_attachments_message_id_fkey; Type: FK CONSTRAINT; Schema: communication; Owner: -
--

ALTER TABLE ONLY communication.message_attachments
    ADD CONSTRAINT message_attachments_message_id_fkey FOREIGN KEY (message_id) REFERENCES communication.messages(id) ON DELETE CASCADE;


--

-- Name: message_recipients message_recipients_message_id_fkey; Type: FK CONSTRAINT; Schema: communication; Owner: -
--

ALTER TABLE ONLY communication.message_recipients
    ADD CONSTRAINT message_recipients_message_id_fkey FOREIGN KEY (message_id) REFERENCES communication.messages(id) ON DELETE CASCADE;


--

-- Name: message_recipients message_recipients_recipient_id_fkey; Type: FK CONSTRAINT; Schema: communication; Owner: -
--

ALTER TABLE ONLY communication.message_recipients
    ADD CONSTRAINT message_recipients_recipient_id_fkey FOREIGN KEY (recipient_id) REFERENCES security.users(id);


--

-- Name: messages messages_sender_id_fkey; Type: FK CONSTRAINT; Schema: communication; Owner: -
--

ALTER TABLE ONLY communication.messages
    ADD CONSTRAINT messages_sender_id_fkey FOREIGN KEY (sender_id) REFERENCES security.users(id);


--

-- Name: user_notification_preferences user_notification_preferences_user_id_fkey; Type: FK CONSTRAINT; Schema: communication; Owner: -
--

ALTER TABLE ONLY communication.user_notification_preferences
    ADD CONSTRAINT user_notification_preferences_user_id_fkey FOREIGN KEY (user_id) REFERENCES security.users(id) ON DELETE CASCADE;


--


