#!/bin/bash

# Script para configurar variables de entorno en Vercel CLI
# Usar después de hacer: vercel login

echo "🚀 Configurando variables de entorno en Vercel para doctors app..."
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

# Listar proyectos para identificar el doctors project
echo "📋 Listando proyectos de Vercel..."
npx vercel ls
echo ""

echo "🔧 Configurando variables de entorno críticas..."
echo ""

# Configurar variables una por una
echo "📝 Configurando NEXT_PUBLIC_SUPABASE_URL..."
npx vercel env add NEXT_PUBLIC_SUPABASE_URL production

echo "📝 Configurando NEXT_PUBLIC_SUPABASE_ANON_KEY..."
npx vercel env add NEXT_PUBLIC_SUPABASE_ANON_KEY production

echo "📝 Configurando NEXT_PUBLIC_APP_URL..."
npx vercel env add NEXT_PUBLIC_APP_URL production

echo "📝 Configurando NEXT_PUBLIC_DOCTORS_URL..."
npx vercel env add NEXT_PUBLIC_DOCTORS_URL production

echo "📝 Configurando NEXT_PUBLIC_PATIENTS_URL..."
npx vercel env add NEXT_PUBLIC_PATIENTS_URL production

echo "📝 Configurando NEXT_PUBLIC_COMPANIES_URL..."
npx vercel env add NEXT_PUBLIC_COMPANIES_URL production

echo "📝 Configurando AUTH_COOKIE_DOMAIN..."
npx vercel env add AUTH_COOKIE_DOMAIN production

echo "📝 Configurando NODE_ENV..."
npx vercel env add NODE_ENV production

echo ""
echo "✅ Variables de entorno configuradas!"
echo ""

echo "🚀 Iniciando redeploy..."
npx vercel --prod --yes

echo ""
echo "✅ Setup completado!"
echo "📍 Revisa tu deployment en: https://vercel.com/dashboard"
echo ""
echo "⚠️  SIGUIENTE PASO: Configurar Redirect URLs en Supabase"
echo "   Usa el script: ./scripts/setup-supabase-urls.sh"