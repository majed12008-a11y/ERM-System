/*
 * نقطة الدخول للتطبيق: تهيئة React وتحميل
 * ملفات CSS العامة ونظام التدويل (i18n).
 */
import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import './index.css'
import './i18n'
import { ThemeProvider } from './context/ThemeContext'
import App from './App'

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <ThemeProvider>
      <App />
    </ThemeProvider>
  </StrictMode>,
)
