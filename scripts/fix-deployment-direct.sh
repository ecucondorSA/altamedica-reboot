#!/bin/bash

# Script directo para configurar variables de entorno usando Vercel CLI
# Sin prompts interactivos

echo "🚀 CONFIGURANDO DEPLOYMENT DE DOCTORS APP DIRECTAMENTE"
echo "======================================================="
echo ""

cd apps/doctors

echo "📍 Ubicación: $(pwd)"
echo ""

# Si tienes token de Vercel, úsalo directamente
if [ ! -z "$VERCEL_TOKEN" ]; then
    echo "🔑 Usando VERCEL_TOKEN del entorno"
    TOKEN_FLAG="--token $VERCEL_TOKEN"
else
    echo "⚠️  VERCEL_TOKEN no encontrado"
    echo ""
    echo "📋 OPCIONES:"
    echo "1. Ejecutar manualmente: npx vercel login"
    echo "2. O usar token: export VERCEL_TOKEN=tu_token && ./scripts/fix-deployment-direct.sh"
    echo ""
    echo "🎯 CONFIGURACIÓN MANUAL VÍA DASHBOARD:"
    echo "======================================"
    echo ""
    echo "1. Ir a: https://vercel.com/dashboard"
    echo "2. Seleccionar proyecto: doctors (ecucondor-gmailcoms-projects/doctors)"
    echo "3. Settings → Environment Variables → Production"
    echo "4. Agregar estas variables:"
    echo ""
    echo "NEXT_PUBLIC_SUPABASE_URL=https://gtyvdircfhmdjiaelqkg.supabase.co"
    echo "NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhmYWRzam1kbWZxenZ0Z25xc3FyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjYzNDY1NjEsImV4cCI6MjA0MTkyMjU2MX0.9wl5PXEbX7XRvDC3CjKNtaXj8fGiRCLJY4TIoQ8vKm4"
    echo "NEXT_PUBLIC_APP_URL=https://autamedica.com"
    echo "NEXT_PUBLIC_DOCTORS_URL=https://doctors.autamedica.com"
    echo "NEXT_PUBLIC_PATIENTS_URL=https://patients.autamedica.com"
    echo "NEXT_PUBLIC_COMPANIES_URL=https://companies.autamedica.com"
    echo "AUTH_COOKIE_DOMAIN=.autamedica.com"
    echo "NODE_ENV=production"
    echo "SUPABASE_URL=https://gtyvdircfhmdjiaelqkg.supabase.co"
    echo "SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhmYWRzam1kbWZxenZ0Z25xc3FyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjYzNDY1NjEsImV4cCI6MjA0MTkyMjU2MX0.9wl5PXEbX7XRvDC3CjKNtaXj8fGiRCLJY4TIoQ8vKm4"
    echo ""
    echo "5. Después de agregar variables, hacer redeploy desde Vercel Dashboard"
    echo ""
    echo "6. Ir a Supabase Dashboard:"
    echo "   https://supabase.com/dashboard/project/gtyvdircfhmdjiaelqkg/auth/url-configuration"
    echo ""
    echo "7. Agregar Redirect URL (obtener URL de Vercel después del deploy):"
    echo "   https://doctors-[project-id].vercel.app/auth/callback"
    echo ""
    exit 1
fi

# Configurar variables usando token
echo "🔧 Configurando variables de entorno con token..."

# Array de variables a configurar
declare -A VARS=(
    ["NEXT_PUBLIC_SUPABASE_URL"]="https://gtyvdircfhmdjiaelqkg.supabase.co"
    ["NEXT_PUBLIC_SUPABASE_ANON_KEY"]="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhmYWRzam1kbWZxenZ0Z25xc3FyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjYzNDY1NjEsImV4cCI6MjA0MTkyMjU2MX0.9wl5PXEbX7XRvDC3CjKNtaXj8fGiRCLJY4TIoQ8vKm4"
    ["NEXT_PUBLIC_APP_URL"]="https://autamedica.com"
    ["NEXT_PUBLIC_DOCTORS_URL"]="https://doctors.autamedica.com"
    ["NEXT_PUBLIC_PATIENTS_URL"]="https://patients.autamedica.com"
    ["NEXT_PUBLIC_COMPANIES_URL"]="https://companies.autamedica.com"
    ["AUTH_COOKIE_DOMAIN"]=".autamedica.com"
    ["NODE_ENV"]="production"
    ["SUPABASE_URL"]="https://gtyvdircfhmdjiaelqkg.supabase.co"
    ["SUPABASE_ANON_KEY"]="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhmYWRzam1kbWZxenZ0Z25xc3FyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjYzNDY1NjEsImV4cCI6MjA0MTkyMjU2MX0.9wl5PXEbX7XRvDC3CjKNtaXj8fGiRCLJY4TIoQ8vKm4"
)

# Configurar cada variable
for var in "${!VARS[@]}"; do
    echo "📝 Configurando $var..."
    echo "${VARS[$var]}" | npx vercel env add "$var" production $TOKEN_FLAG --stdin
done

echo ""
echo "🚀 Haciendo redeploy..."
npx vercel --prod --yes $TOKEN_FLAG

echo ""
echo "✅ Deployment configurado!"
echo ""
echo "📍 Siguiente paso: Configurar Supabase URLs"
echo "Ejecutar: ./scripts/setup-supabase-urls.sh"