/*
 * دوال مساعدة للواجهة الأمامية.
 * cn(): دمج أسماء كلاسات Tailwind CSS مع معالجة التعارضات.
 */
import { type ClassValue, clsx } from 'clsx'
import { twMerge } from 'tailwind-merge'

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}
