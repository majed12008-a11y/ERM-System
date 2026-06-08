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
const Dashboard = lazy(() => import('./pages/Dashboard'))
const ApplicationList = lazy(() => import('./pages/Applications/List'))
const ApplicationCreate = lazy(() => import('./pages/Applications/Create'))
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
const Notifications = lazy(() => import('./pages/Notifications'))
const RiskRegister = lazy(() => import('./pages/Safety/RiskRegister'))
const SavedSearches = lazy(() => import('./pages/System/SavedSearches'))
const RegistryPage = lazy(() => import('./pages/Registry/RegistryPage'))
const ProfilePage = lazy(() => import('./pages/Profile/ProfilePage'))
const DocumentsPage = lazy(() => import('./pages/Documents/DocumentsPage'))
const ReportsPage = lazy(() => import('./pages/Reports/ReportsPage'))
const MessagesPage = lazy(() => import('./pages/Messages/MessagesPage'))
const AdminDashboard = lazy(() => import('./pages/Admin/AdminDashboard'))
const ReviewFormsPage = lazy(() => import('./pages/ReviewForms/ReviewFormsPage'))
const ESignaturesPage = lazy(() => import('./pages/ESignatures/ESignaturesPage'))

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
            <Route element={<ProtectedRoute />}>
              <Route element={<RootLayout />} errorElement={<ErrorBoundary />}>
                <Route index element={<Dashboard />} />
                <Route path="/applications" element={<ApplicationList />} />
                <Route path="/applications/create" element={<ApplicationCreate />} />
                <Route path="/applications/:id" element={<ApplicationDetail />} />
                <Route path="/projects" element={<ProjectList />} />
                <Route path="/projects/create" element={<ProjectCreate />} />
                <Route path="/projects/:id" element={<ProjectDetail />} />
                <Route path="/users" element={<UserList />} />
                <Route path="/roles" element={<RoleList />} />
                <Route path="/committee/reviews" element={<MyReviews />} />
                <Route path="/committee/committees" element={<Committees />} />
                <Route path="/committee/meetings" element={<CommitteeMeetings />} />
                <Route path="/committee/meetings/:id" element={<MeetingDetail />} />
                <Route path="/notifications" element={<Notifications />} />
                <Route path="/risk-register" element={<RiskRegister />} />
                <Route path="/saved-searches" element={<SavedSearches />} />
                <Route path="/registry" element={<RegistryPage />} />
                <Route path="/profile" element={<ProfilePage />} />
                <Route path="/documents" element={<DocumentsPage />} />
                <Route path="/reports" element={<ReportsPage />} />
                <Route path="/messages" element={<MessagesPage />} />
                <Route path="/admin" element={<AdminDashboard />} />
                <Route path="/review-forms" element={<ReviewFormsPage />} />
                <Route path="/e-signatures" element={<ESignaturesPage />} />
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
