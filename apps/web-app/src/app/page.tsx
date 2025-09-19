'use client'

import { useEffect } from 'react'
import { useRouter, useSearchParams } from 'next/navigation'
import ResponsiveExperience from '@/components/experience/ResponsiveExperience'
import { Suspense } from 'react'

function HomeContent() {
  const router = useRouter()
  const searchParams = useSearchParams()

  useEffect(() => {
    // Detectar si hay un código OAuth en la URL raíz
    const code = searchParams.get('code')
    
    if (code) {
      console.log('OAuth code detected on root page, redirecting to callback')
      // Redirigir inmediatamente al callback con todos los parámetros
      window.location.href = '/auth/callback' + window.location.search
    }
  }, [searchParams, router])

  return <ResponsiveExperience />
}

export default function HomePage() {
  return (
    <Suspense fallback={<div>Cargando...</div>}>
      <HomeContent />
    </Suspense>
  )
}