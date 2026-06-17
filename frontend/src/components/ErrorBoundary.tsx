import { Component } from 'react'
import type { ErrorInfo, ReactNode } from 'react'
import { AlertTriangle, RefreshCw, Home } from 'lucide-react'
import i18n from '../i18n'

interface Props {
  children?: ReactNode
  fallback?: ReactNode
  onError?: (error: Error, info: ErrorInfo) => void
}

interface State {
  error: Error | null
  info: ErrorInfo | null
}

export default class ErrorBoundary extends Component<Props, State> {
  constructor(props: Props) {
    super(props)
    this.state = { error: null, info: null }
  }

  static getDerivedStateFromError(error: Error): Partial<State> {
    return { error }
  }

  componentDidCatch(error: Error, info: ErrorInfo): void {
    this.setState({ info })
    console.error('[ErrorBoundary]', error, info.componentStack)
    this.props.onError?.(error, info)
  }

  handleReset = (): void => {
    this.setState({ error: null, info: null })
  }

  handleGoHome = (): void => {
    window.location.href = '/'
  }

  render(): ReactNode {
    if (this.state.error) {
      if (this.props.fallback) return this.props.fallback

      return (
        <div className="flex items-center justify-center min-h-[400px] p-8">
          <div className="max-w-md w-full text-center">
            <AlertTriangle className="mx-auto h-16 w-16 text-red-400 mb-4" />
            <h2 className="text-xl font-semibold text-slate-800 mb-2">
              {i18n.t('errorBoundary.title')}
            </h2>
            <p className="text-slate-500 mb-6 text-sm">
              {this.state.error.message || i18n.t('errorBoundary.unexpected')}
            </p>
            <div className="flex gap-3 justify-center">
              <button
                onClick={this.handleReset}
                className="inline-flex items-center gap-2 px-4 py-2 bg-slate-800 text-white rounded-lg hover:bg-slate-700 transition-colors text-sm"
              >
                <RefreshCw className="h-4 w-4" />
                {i18n.t('errorBoundary.tryAgain')}
              </button>
              <button
                onClick={this.handleGoHome}
                className="inline-flex items-center gap-2 px-4 py-2 border border-slate-300 text-slate-700 rounded-lg hover:bg-slate-100 transition-colors text-sm"
              >
                <Home className="h-4 w-4" />
                {i18n.t('errorBoundary.goHome')}
              </button>
            </div>
            {this.state.info?.componentStack && (
              <details className="mt-6 text-left">
                <summary className="text-xs text-slate-400 cursor-pointer hover:text-slate-600">
                  {i18n.t('errorBoundary.componentStack')}
                </summary>
                <pre className="mt-2 text-xs text-red-500 bg-red-50 p-3 rounded overflow-auto max-h-40">
                  {this.state.info.componentStack}
                </pre>
              </details>
            )}
          </div>
        </div>
      )
    }

    return this.props.children
  }
}
