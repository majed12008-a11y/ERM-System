-- Push notification configuration table
CREATE TABLE IF NOT EXISTS system.push_config (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    config_name VARCHAR(200) NOT NULL,
    provider VARCHAR(100) NOT NULL,
    server_key TEXT,
    app_id VARCHAR(200),
    is_active BOOLEAN DEFAULT true NOT NULL,
    created_at TIMESTAMPTZ DEFAULT now() NOT NULL
);

COMMENT ON TABLE system.push_config IS 'إعدادات الإشعارات الفورية / Push Notification Config';
COMMENT ON COLUMN system.push_config.config_name IS 'اسم الإعداد';
COMMENT ON COLUMN system.push_config.provider IS 'المزود (FCM, APNs, ...)';
COMMENT ON COLUMN system.push_config.server_key IS 'مفتاح الخادم';
COMMENT ON COLUMN system.push_config.app_id IS 'معرف التطبيق';
