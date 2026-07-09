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
            <h2 className="text-xl font-semibold text-foreground mb-2">
              {i18n.t('errorBoundary.title')}
            </h2>
            <p className="text-muted-foreground mb-6 text-sm">
              {this.state.error.message || i18n.t('errorBoundary.unexpected')}
            </p>
            <div className="flex gap-3 justify-center">
              <button
                onClick={this.handleReset}
                className="inline-flex items-center gap-2 px-4 py-2 bg-primary text-primary-foreground rounded-lg hover:bg-primary-hover transition-colors text-sm"
              >
                <RefreshCw className="h-4 w-4" />
                {i18n.t('errorBoundary.tryAgain')}
              </button>
              <button
                onClick={this.handleGoHome}
                className="inline-flex items-center gap-2 px-4 py-2 border border-border text-foreground rounded-lg hover:bg-muted transition-colors text-sm"
              >
                <Home className="h-4 w-4" />
                {i18n.t('errorBoundary.goHome')}
              </button>
            </div>
            {this.state.info?.componentStack && (
              <details className="mt-6 text-left">
                <summary className="text-xs text-muted-foreground cursor-pointer hover:text-foreground">
                  {i18n.t('errorBoundary.componentStack')}
                </summary>
                <pre className="mt-2 text-xs text-destructive bg-destructive-light p-3 rounded overflow-auto max-h-40">
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
