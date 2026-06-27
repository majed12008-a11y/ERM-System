/*
 * المكون الرئيسي للتطبيق: تعريف المسارات (Routing) باستخدام
 * React Router، إعداد React Query، وإدارة السياق العام.
 * يستخدم التحميل البطيء (Lazy Loading) للصفحات.
 */
import { lazy, Suspense, useEffect } from 'react'
import { BrowserRouter, Routes, Route } from 'react-router-dom'
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { Toaster, toast } from 'sonner'
import i18n from './i18n'
import { AuthProvider } from './context/AuthContext'
import ErrorBoundary from './components/ErrorBoundary'
import ProtectedRoute from './components/ProtectedRoute'
import RootLayout from './layouts/RootLayout'
import PageLoader from './components/PageLoader'

const LoginPage = lazy(() => import('./pages/LoginPage'))
const RegisterPage = lazy(() => import('./pages/RegisterPage'))
const ForgotPasswordPage = lazy(() => import('./pages/ForgotPasswordPage'))
const ResetPasswordPage = lazy(() => import('./pages/ResetPasswordPage'))
const VerifyEmailPage = lazy(() => import('./pages/VerifyEmailPage'))
const Dashboard = lazy(() => import('./pages/Dashboard'))
const ApplicationList = lazy(() => import('./pages/Applications/List'))
const ApplicationCreate = lazy(() => import('./pages/Applications/Create'))
const ApplicationEdit = lazy(() => import('./pages/Applications/Edit'))
const ApplicationDetail = lazy(() => import('./pages/Applications/Detail'))
const ProjectList = lazy(() => import('./pages/Projects/List'))
const ProjectCreate = lazy(() => import('./pages/Projects/Create'))
const ProjectDetail = lazy(() => import('./pages/Projects/Detail'))
const UserList = lazy(() => import('./pages/Users/List'))
const RoleList = lazy(() => import('./pages/Roles/List'))
const MyReviews = lazy(() => import('./pages/Committee/MyReviews'))
const CommitteeMeetings = lazy(() => import('./pages/Committee/Meetings'))
const MeetingDetail = lazy(() => import('./pages/Committee/MeetingDetail'))
const Committees = lazy(() => import('./pages/Committee/Committees'))
const CommitteeDetail = lazy(() => import('./pages/Committee/CommitteeDetail'))
const Notifications = lazy(() => import('./pages/Notifications'))
const RiskRegister = lazy(() => import('./pages/Safety/RiskRegister'))
const AdverseEvents = lazy(() => import('./pages/Safety/AdverseEvents'))
const RiskIncidents = lazy(() => import('./pages/Safety/RiskIncidents'))
const CorrectiveActions = lazy(() => import('./pages/Safety/CorrectiveActions'))
const SavedSearches = lazy(() => import('./pages/System/SavedSearches'))
const RegistryPage = lazy(() => import('./pages/Registry/RegistryPage'))
const ProfilePage = lazy(() => import('./pages/Profile/ProfilePage'))
const DocumentsPage = lazy(() => import('./pages/Documents/DocumentsPage'))
const ReportsPage = lazy(() => import('./pages/Reports/ReportsPage'))
const MessagesPage = lazy(() => import('./pages/Messages/MessagesPage'))
const AdminDashboard = lazy(() => import('./pages/Admin/AdminDashboard'))
const ReviewFormsPage = lazy(() => import('./pages/ReviewForms/ReviewFormsPage'))
const ESignaturesPage = lazy(() => import('./pages/ESignatures/ESignaturesPage'))
const ConsentTemplates = lazy(() => import('./pages/Admin/ConsentTemplates'))
const ConsentTemplateVersions = lazy(() => import('./pages/Admin/ConsentTemplateVersions'))
const NotificationChannels = lazy(() => import('./pages/Admin/NotificationChannels'))
const BackupSettings = lazy(() => import('./pages/Admin/BackupSettings'))
const ReferenceData = lazy(() => import('./pages/Admin/ReferenceData'))
const AccreditationCycles = lazy(() => import('./pages/Accreditation/CyclesList'))
const AccreditationCycleDetail = lazy(() => import('./pages/Accreditation/CycleDetail'))
const AccreditationEvidence = lazy(() => import('./pages/Accreditation/Evidence'))
const AccreditationAssessments = lazy(() => import('./pages/Accreditation/AssessmentsList'))
const AccreditationConditions = lazy(() => import('./pages/Accreditation/ConditionsList'))
const AccreditationDashboard = lazy(() => import('./pages/Accreditation/Dashboard'))


const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 30 * 1000,
      retry: 1,
      refetchOnWindowFocus: false,
    },
    mutations: {
      onError: (err: any) => {
        const msg = err?.response?.data?.error || err?.message || 'An unexpected error occurred'
        if (err?.response?.status !== 401 && err?.response?.status !== 403) {
          toast.error(msg)
        }
      },
    },
  },
})

export default function App() {
  useEffect(() => {
    const updateDir = () => {
      const lang = i18n.language?.startsWith('ar') ? 'ar' : 'en'
      document.documentElement.lang = lang
      document.documentElement.dir = lang === 'ar' ? 'rtl' : 'ltr'
    }
    updateDir()
    i18n.on('languageChanged', updateDir)
    return () => { i18n.off('languageChanged', updateDir) }
  }, [])

  return (
    <QueryClientProvider client={queryClient}>
      <ErrorBoundary>
      <BrowserRouter>
        <AuthProvider>
          <Toaster richColors position="top-right" />
          <Suspense fallback={<PageLoader />}>
          <Routes>
            <Route path="/login" element={<LoginPage />} errorElement={<ErrorBoundary />} />
            <Route path="/register" element={<RegisterPage />} errorElement={<ErrorBoundary />} />
            <Route path="/forgot-password" element={<ForgotPasswordPage />} errorElement={<ErrorBoundary />} />
            <Route path="/reset-password" element={<ResetPasswordPage />} errorElement={<ErrorBoundary />} />
            <Route path="/verify-email" element={<VerifyEmailPage />} errorElement={<ErrorBoundary />} />
            <Route element={<ProtectedRoute />}>
              <Route element={<RootLayout />} errorElement={<ErrorBoundary />}>
                <Route index element={<Dashboard />} />
                <Route path="/applications" element={<ApplicationList />} />
                <Route path="/applications/create" element={<ApplicationCreate />} />
                <Route path="/applications/:id/edit" element={<ApplicationEdit />} />
                <Route path="/applications/:id" element={<ApplicationDetail />} />
                <Route path="/projects" element={<ProjectList />} />
                <Route path="/projects/create" element={<ProjectCreate />} />
                <Route path="/projects/:id" element={<ProjectDetail />} />
                <Route path="/users" element={<UserList />} />
                <Route path="/roles" element={<RoleList />} />
                <Route path="/committee/reviews" element={<MyReviews />} />
                <Route path="/committee/committees" element={<Committees />} />
                <Route path="/committee/committees/:id" element={<CommitteeDetail />} />
                <Route path="/committee/meetings" element={<CommitteeMeetings />} />
                <Route path="/committee/meetings/:id" element={<MeetingDetail />} />
                <Route path="/notifications" element={<Notifications />} />
                <Route path="/risk-register" element={<RiskRegister />} />
                <Route path="/safety/adverse-events" element={<AdverseEvents />} />
                <Route path="/safety/risk-incidents" element={<RiskIncidents />} />
                <Route path="/safety/corrective-actions" element={<CorrectiveActions />} />
                <Route path="/saved-searches" element={<SavedSearches />} />
                <Route path="/registry" element={<RegistryPage />} />
                <Route path="/profile" element={<ProfilePage />} />
                <Route path="/documents" element={<DocumentsPage />} />
                <Route path="/reports" element={<ReportsPage />} />
                <Route path="/messages" element={<MessagesPage />} />
                <Route path="/admin" element={<AdminDashboard />} />
                <Route path="/admin/notification-channels" element={<NotificationChannels />} />
                <Route path="/admin/backup" element={<BackupSettings />} />
                <Route path="/admin/reference-data" element={<ReferenceData />} />
                <Route path="/admin/consent-templates" element={<ConsentTemplates />} />
                <Route path="/admin/consent-templates/:id/versions" element={<ConsentTemplateVersions />} />
                <Route path="/review-forms" element={<ReviewFormsPage />} />
                <Route path="/e-signatures" element={<ESignaturesPage />} />
                <Route path="/admin/accreditation/cycles" element={<AccreditationCycles />} />
                <Route path="/admin/accreditation/cycles/:id" element={<AccreditationCycleDetail />} />
                <Route path="/admin/accreditation/cycles/:id/evidence" element={<AccreditationEvidence />} />
                <Route path="/admin/accreditation/cycles/:id/assessments" element={<AccreditationAssessments />} />
                <Route path="/admin/accreditation/cycles/:id/conditions" element={<AccreditationConditions />} />
                <Route path="/admin/accreditation/cycles/:id/dashboard" element={<AccreditationDashboard />} />
              </Route>
            </Route>
          </Routes>
          </Suspense>
        </AuthProvider>
      </BrowserRouter>
      </ErrorBoundary>
    </QueryClientProvider>
  )
}
