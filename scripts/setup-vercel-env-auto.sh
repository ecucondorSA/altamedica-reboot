#!/bin/bash

# Script automático para configurar variables de entorno en Vercel CLI
# Usa valores predefinidos del .env.local

echo "🚀 Configurando variables de entorno automáticamente en Vercel..."
echo ""

# Cambiar al directorio de la app doctors
cd apps/doctors

echo "📍 Ubicación actual: $(pwd)"
echo ""

# Verificar que estamos logueados en Vercel
echo "🔐 Verificando autenticación con Vercel..."
if ! npx vercel whoami 2>/dev/null; then
    echo "❌ No estás logueado en Vercel."
    echo "Por favor ejecuta: npx vercel login"
    echo "Luego ejecuta este script nuevamente."
    exit 1
fi

echo "✅ Autenticado con Vercel."
echo ""

# Configurar variables con valores directos (sin input interactivo)
echo "🔧 Configurando variables de entorno críticas automáticamente..."
echo ""

# NEXT_PUBLIC_SUPABASE_URL
echo "📝 NEXT_PUBLIC_SUPABASE_URL..."
echo "https://hfadsjmdmfqzvtgnqsqr.supabase.co" | npx vercel env add NEXT_PUBLIC_SUPABASE_URL production --stdin

# NEXT_PUBLIC_SUPABASE_ANON_KEY
echo "📝 NEXT_PUBLIC_SUPABASE_ANON_KEY..."
echo "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhmYWRzam1kbWZxenZ0Z25xc3FyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjYzNDY1NjEsImV4cCI6MjA0MTkyMjU2MX0.9wl5PXEbX7XRvDC3CjKNtaXj8fGiRCLJY4TIoQ8vKm4" | npx vercel env add NEXT_PUBLIC_SUPABASE_ANON_KEY production --stdin

# NEXT_PUBLIC_APP_URL
echo "📝 NEXT_PUBLIC_APP_URL..."
echo "https://autamedica.com" | npx vercel env add NEXT_PUBLIC_APP_URL production --stdin

# NEXT_PUBLIC_DOCTORS_URL
echo "📝 NEXT_PUBLIC_DOCTORS_URL..."
echo "https://doctors.autamedica.com" | npx vercel env add NEXT_PUBLIC_DOCTORS_URL production --stdin

# NEXT_PUBLIC_PATIENTS_URL
echo "📝 NEXT_PUBLIC_PATIENTS_URL..."
echo "https://patients.autamedica.com" | npx vercel env add NEXT_PUBLIC_PATIENTS_URL production --stdin

# NEXT_PUBLIC_COMPANIES_URL
echo "📝 NEXT_PUBLIC_COMPANIES_URL..."
echo "https://companies.autamedica.com" | npx vercel env add NEXT_PUBLIC_COMPANIES_URL production --stdin

# AUTH_COOKIE_DOMAIN
echo "📝 AUTH_COOKIE_DOMAIN..."
echo ".autamedica.com" | npx vercel env add AUTH_COOKIE_DOMAIN production --stdin

# NODE_ENV
echo "📝 NODE_ENV..."
echo "production" | npx vercel env add NODE_ENV production --stdin

# Variables adicionales para middleware de Supabase
echo "📝 SUPABASE_URL..."
echo "https://hfadsjmdmfqzvtgnqsqr.supabase.co" | npx vercel env add SUPABASE_URL production --stdin

echo "📝 SUPABASE_ANON_KEY..."
echo "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhmYWRzam1kbWZxenZ0Z25xc3FyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjYzNDY1NjEsImV4cCI6MjA0MTkyMjU2MX0.9wl5PXEbX7XRvDC3CjKNtaXj8fGiRCLJY4TIoQ8vKm4" | npx vercel env add SUPABASE_ANON_KEY production --stdin

echo ""
echo "✅ Variables de entorno configuradas automáticamente!"
echo ""

# Mostrar variables configuradas
echo "📋 Verificando variables configuradas..."
npx vercel env ls

echo ""
echo "🚀 Iniciando redeploy automático..."
npx vercel --prod --yes

echo ""
echo "✅ Setup completado automáticamente!"
echo "📍 Revisa tu deployment en: https://vercel.com/dashboard"
echo ""
echo "⚠️  SIGUIENTE PASO: Configurar Redirect URLs en Supabase"
echo "   Obten la URL de deployment y configura en Supabase Dashboard:"
echo "   https://supabase.com/dashboard/project/hfadsjmdmfqzvtgnqsqr/auth/url-configuration"