'use client'

import { useState } from 'react'
import { useRouter, useSearchParams } from 'next/navigation'
import { createClient } from '@/lib/supabase'

export function LoginForm() {
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const router = useRouter()
  const searchParams = useSearchParams()
  const supabase = createClient()
  
  // Capturar parámetros de URL para pasarlos al callback
  const returnTo = searchParams.get('returnTo')
  const portal = searchParams.get('portal')

  const buildCallbackUrl = () => {
    const callbackUrl = new URL('/auth/callback', window.location.origin)
    if (returnTo) callbackUrl.searchParams.set('returnTo', returnTo)
    if (portal) callbackUrl.searchParams.set('portal', portal)
    return callbackUrl
  }

  const handleEmailLogin = async (e: React.FormEvent) => {
    e.preventDefault()
    setLoading(true)
    setError(null)

    // Check if we're in development mode with dummy credentials
    const isDummyMode = (process.env.NEXT_PUBLIC_SUPABASE_URL ?? 'https://dummy.supabase.co') === 'https://dummy.supabase.co'

    if (isDummyMode) {
      // Simulate login in development mode
      setTimeout(() => {
        if (email === 'demo@autamedica.com' && password === 'demo123') {
          setError(null)
          router.push('/') // Redirect to home
        } else {
          setError('Modo demo: Usa email "demo@autamedica.com" y contraseña "demo123"')
        }
        setLoading(false)
      }, 1000) // Simulate network delay
      return
    }

    if (!supabase) {
      setError('Error de configuración. Por favor recarga la página.')
      setLoading(false)
      return
    }

    try {
      const { error: authError } = await supabase.auth.signInWithPassword({
        email,
        password,
      })

      if (authError) {
        if (authError.message.includes('Invalid login credentials')) {
          setError('Credenciales incorrectas. Verifica tu email y contraseña.')
        } else {
          setError(authError.message || 'Error al iniciar sesión')
        }
        setLoading(false)
        return
      }

      // Redirect will be handled by middleware
      router.push('/')
    } catch (err) {
      setError('Error inesperado. Por favor intenta nuevamente.')
      setLoading(false)
    }
  }

  const handleMagicLinkLogin = async () => {
    if (!email) {
      setError('Por favor ingresa tu email para enviar el magic link')
      return
    }

    setLoading(true)
    setError(null)

    const isDummyMode = (process.env.NEXT_PUBLIC_SUPABASE_URL ?? 'https://dummy.supabase.co') === 'https://dummy.supabase.co'

    if (isDummyMode) {
      setTimeout(() => {
        setError(null)
        alert('Modo demo: Magic link enviado (simulado)')
        setLoading(false)
      }, 1000)
      return
    }

    if (!supabase) {
      setError('Error de configuración. Por favor recarga la página.')
      setLoading(false)
      return
    }

    try {
      const callbackUrl = buildCallbackUrl()

      const { error } = await supabase.auth.signInWithOtp({
        email,
        options: {
          emailRedirectTo: callbackUrl.toString()
        }
      })

      if (error) {
        setError('Error al enviar magic link')
        setLoading(false)
        return
      }

      alert('Magic link enviado! Revisa tu email.')
      setLoading(false)
    } catch (err) {
      setError('Error inesperado. Por favor intenta nuevamente.')
      setLoading(false)
    }
  }

  return (
    <>
      {error && (
        <div className="bg-red-900/20 border border-red-700/50 rounded-lg p-4 mb-6">
          <div className="flex items-center space-x-3">
            <svg className="w-5 h-5 text-red-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-2.5L13.732 4c-.77-.833-1.964-.833-2.732 0L3.732 16.5c-.77.833.192 2.5 1.732 2.5z" />
            </svg>
            <p className="text-red-400 text-sm">{error}</p>
          </div>
        </div>
      )}

      <form onSubmit={handleEmailLogin} className="space-y-6">
        <div>
          <label htmlFor="email" className="block text-sm font-medium text-white mb-2">
            Email
          </label>
          <input
            type="email"
            id="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            className="w-full px-4 py-3 bg-autamedica-negro/20 border border-autamedica-secondary/30 rounded-lg text-autamedica-blanco placeholder-autamedica-text-light focus:outline-none focus:ring-2 focus:ring-autamedica-primary focus:border-transparent"
            placeholder="tu@email.com"
            required
            disabled={loading}
            autoComplete="email"
            autoFocus
          />
        </div>
        
        <div>
          <label htmlFor="password" className="block text-sm font-medium text-white mb-2">
            Contraseña
          </label>
          <input
            type="password"
            id="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            className="w-full px-4 py-3 bg-autamedica-negro/20 border border-autamedica-secondary/30 rounded-lg text-autamedica-blanco placeholder-autamedica-text-light focus:outline-none focus:ring-2 focus:ring-autamedica-primary focus:border-transparent"
            placeholder="••••••••"
            required
            disabled={loading}
            autoComplete="current-password"
          />
        </div>

        <button
          type="submit"
          className="w-full bg-gradient-to-r from-autamedica-primary to-autamedica-primary-dark text-white py-3 px-4 rounded-lg font-semibold hover:from-autamedica-primary-dark hover:to-autamedica-beige transition-all duration-200 transform hover:scale-105 disabled:opacity-50 disabled:cursor-not-allowed disabled:transform-none"
          disabled={loading}
        >
          {loading ? 'Iniciando sesión...' : 'Iniciar Sesión'}
        </button>
      </form>

      {/* Separador */}
      <div className="my-6 flex items-center">
        <div className="flex-1 border-t border-autamedica-secondary/30"></div>
        <span className="px-4 text-autamedica-text-light text-sm">o</span>
        <div className="flex-1 border-t border-autamedica-secondary/30"></div>
      </div>

      {/* Magic Link Button */}
      <button
        onClick={handleMagicLinkLogin}
        className="w-full bg-autamedica-secondary/20 border border-autamedica-secondary/30 text-autamedica-blanco py-3 px-4 rounded-lg font-semibold hover:bg-autamedica-secondary/30 hover:border-autamedica-primary/50 disabled:opacity-50 disabled:cursor-not-allowed transition-colors transform hover:scale-105 disabled:transform-none flex items-center justify-center gap-2"
        disabled={loading}
      >
        <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
        </svg>
        {loading ? 'Enviando...' : 'Enviar Magic Link'}
      </button>

      {/* Links */}
      <div className="mt-6 text-center space-y-4">
        <a 
          href="/auth/forgot-password"
          className="text-autamedica-primary hover:text-white text-sm font-medium transition-colors"
        >
          ¿Olvidaste tu contraseña?
        </a>
        
        <div className="text-autamedica-text-light text-sm">
          ¿No tienes cuenta?{' '}
          <a 
            href="/auth/register"
            className="text-autamedica-primary hover:text-white font-medium transition-colors"
          >
            Crear cuenta
          </a>
        </div>
      </div>
    </>
  )
}

// Export as default for backward compatibility
export default LoginForm