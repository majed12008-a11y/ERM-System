import { describe, it, expect } from 'vitest'
import { render, screen } from '@testing-library/react'
import { StatusBadge } from '../components/StatusBadge'

describe('StatusBadge', () => {
  it('renders status text', () => {
    render(<StatusBadge status="SUBMITTED" />)
    expect(screen.getByText('Submitted')).toBeInTheDocument()
  })

  it('renders with replacement for underscores', () => {
    render(<StatusBadge status="UNDER_REVIEW" />)
    expect(screen.getByText('Under Review')).toBeInTheDocument()
  })
})
