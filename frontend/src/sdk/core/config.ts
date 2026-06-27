/*
 * إعدادات SDK: تكوين عنوان URL الأساسي للـ API.
 */
export interface SdkConfig {
  baseURL?: string
}

let _config: SdkConfig = {}

export function configureSdk(config: SdkConfig) {
  _config = config
}

export function getConfig(): SdkConfig {
  return _config
}
