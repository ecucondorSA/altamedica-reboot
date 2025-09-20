import { createBrowserClient } from '@supabase/ssr'
import { ensureClientEnv } from '@autamedica/shared'

export function createClient() {
  // Only create client on the client side
  if (typeof window === 'undefined') {
    return null
  }

  // For development/testing, use dummy values if not available
  let url: string
  let key: string
  
  try {
    url = ensureClientEnv('NEXT_PUBLIC_SUPABASE_URL')
  } catch {
    url = 'https://dummy.supabase.co'
  }
  
  try {
    key = ensureClientEnv('NEXT_PUBLIC_SUPABASE_ANON_KEY')
  } catch {
    key = 'dummy-key'
  }

  return createBrowserClient(url, key)
}

export type UserRole = 'patient' | 'doctor' | 'company' | 'company_admin' | 'admin' | 'platform_admin'

export interface UserProfile {
  id: string
  email: string
  role: UserRole
  first_name?: string
  last_name?: string
  created_at: string
  updated_at: string
}

export const ROLE_REDIRECTS = {
  patient: {
    development: 'http://localhost:3003/dashboard',
    production: 'https://patients.autamedica.com/dashboard'
  },
  doctor: {
    development: 'http://localhost:3002/dashboard',
    production: 'https://doctors.autamedica.com/dashboard'
  },
  company: {
    development: 'http://localhost:3004/dashboard',
    production: 'https://companies.autamedica.com/dashboard'
  },
  company_admin: {
    development: 'http://localhost:3004/dashboard',
    production: 'https://companies.autamedica.com/dashboard'
  },
  admin: {
    development: 'http://localhost:3005/dashboard',
    production: 'https://admin.autamedica.com/dashboard'
  },
  platform_admin: {
    development: 'http://localhost:3000/admin',
    production: 'https://www.autamedica.com/admin'
  }
} as const

export function getRoleRedirectUrl(role: UserRole): string {
  const environment = (process.env.NEXT_PUBLIC_NODE_ENV ?? 'development') === 'development' ? 'development' : 'production'
  return ROLE_REDIRECTS[role][environment]
}