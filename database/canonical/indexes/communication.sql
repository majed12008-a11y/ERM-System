-- =========================================================================
-- communication — INDEX
-- Extracted from live database — auto-generated
-- =========================================================================
-- Name: idx_announcements_active; Type: INDEX; Schema: communication; Owner: -
--

CREATE INDEX idx_announcements_active ON communication.announcements USING btree (is_active);


--

-- Name: idx_message_recipients_created_desc; Type: INDEX; Schema: communication; Owner: -
--

CREATE INDEX idx_message_recipients_created_desc ON communication.message_recipients USING btree (created_at DESC);


--

-- Name: idx_message_recipients_recipient; Type: INDEX; Schema: communication; Owner: -
--

CREATE INDEX idx_message_recipients_recipient ON communication.message_recipients USING btree (recipient_id);


--

-- Name: idx_message_recipients_recipient_created; Type: INDEX; Schema: communication; Owner: -
--

CREATE INDEX idx_message_recipients_recipient_created ON communication.message_recipients USING btree (recipient_id, created_at DESC);


--

-- Name: idx_messages_created_desc; Type: INDEX; Schema: communication; Owner: -
--

CREATE INDEX idx_messages_created_desc ON communication.messages USING btree (created_at DESC);


--

-- Name: idx_messages_sender; Type: INDEX; Schema: communication; Owner: -
--

CREATE INDEX idx_messages_sender ON communication.messages USING btree (sender_id, is_deleted);


--

-- Name: idx_msg_attachments_message; Type: INDEX; Schema: communication; Owner: -
--

CREATE INDEX idx_msg_attachments_message ON communication.message_attachments USING btree (message_id);


--

-- Name: idx_msg_recipients_message; Type: INDEX; Schema: communication; Owner: -
--

CREATE INDEX idx_msg_recipients_message ON communication.message_recipients USING btree (message_id);


--

-- Name: idx_msg_recipients_recipient; Type: INDEX; Schema: communication; Owner: -
--

CREATE INDEX idx_msg_recipients_recipient ON communication.message_recipients USING btree (recipient_id, is_deleted);


--

-- Name: idx_notification_logs_notification; Type: INDEX; Schema: communication; Owner: -
--

CREATE INDEX idx_notification_logs_notification ON communication.notification_logs USING btree (notification_id);


--

-- Name: idx_notifications_active; Type: INDEX; Schema: communication; Owner: -
--

CREATE INDEX idx_notifications_active ON communication.notifications USING btree (id) WHERE (deleted_at IS NULL);


--

-- Name: idx_notifications_created_desc; Type: INDEX; Schema: communication; Owner: -
--

CREATE INDEX idx_notifications_created_desc ON communication.notifications USING btree (created_at DESC);


--

-- Name: idx_notifications_read; Type: INDEX; Schema: communication; Owner: -
--

CREATE INDEX idx_notifications_read ON communication.notifications USING btree (is_read);


--

-- Name: idx_notifications_source; Type: INDEX; Schema: communication; Owner: -
--

CREATE INDEX idx_notifications_source ON communication.notifications USING btree (source_entity_type, source_entity_id);


--

-- Name: idx_notifications_user; Type: INDEX; Schema: communication; Owner: -
--

CREATE INDEX idx_notifications_user ON communication.notifications USING btree (user_id);


--

-- Name: idx_notifications_user_created; Type: INDEX; Schema: communication; Owner: -
--

CREATE INDEX idx_notifications_user_created ON communication.notifications USING btree (user_id, created_at DESC);


--

-- Name: uq_cert_notif_dedup; Type: INDEX; Schema: communication; Owner: -
--

CREATE UNIQUE INDEX uq_cert_notif_dedup ON communication.notifications USING btree (notification_type, user_id, source_entity_id) WHERE ((source_entity_type)::text = 'Certificate'::text);


--


