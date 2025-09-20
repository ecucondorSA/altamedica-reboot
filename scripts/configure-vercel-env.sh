#!/bin/bash

# Script para configurar variables de entorno en Vercel para todas las apps
# Uso: ./scripts/configure-vercel-env.sh [VERCEL_TOKEN]

set -e

VERCEL_TOKEN=${1:-$VERCEL_TOKEN}

if [[ -z "$VERCEL_TOKEN" ]]; then
    echo "❌ Error: VERCEL_TOKEN no proporcionado"
    echo "Uso: $0 <VERCEL_TOKEN>"
    echo "O exporta VERCEL_TOKEN como variable de entorno"
    exit 1
fi

# Variables de entorno de AutaMedica
SUPABASE_URL="https://gtyvdircfhmdjiaelqkg.supabase.co"
SUPABASE_ANON_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imd0eXZkaXJjZmhtZGppYWVscWtnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTY2Njc4NTUsImV4cCI6MjA3MjI0Mzg1NX0.DeEm08k7QOrKObWaz8AUaOB5N6Z2QZhZHFaUf2siALA"

# Lista de proyectos Vercel
PROJECTS=("web-app" "doctors" "patients" "companies")

echo "🚀 Configurando variables de entorno en Vercel..."

for project in "${PROJECTS[@]}"; do
    echo "📱 Configurando proyecto: $project"
    
    # Variables comunes para todas las apps
    npx vercel env add NEXT_PUBLIC_SUPABASE_URL production --token="$VERCEL_TOKEN" --scope="$project" --value="$SUPABASE_URL" --force
    npx vercel env add NEXT_PUBLIC_SUPABASE_ANON_KEY production --token="$VERCEL_TOKEN" --scope="$project" --value="$SUPABASE_ANON_KEY" --force
    npx vercel env add NEXT_PUBLIC_NODE_ENV production --token="$VERCEL_TOKEN" --scope="$project" --value="production" --force
    npx vercel env add SKIP_ENV_VALIDATION production --token="$VERCEL_TOKEN" --scope="$project" --value="true" --force
    
    # URLs específicas por app
    case $project in
        "web-app")
            npx vercel env add NEXT_PUBLIC_APP_URL production --token="$VERCEL_TOKEN" --scope="$project" --value="https://autamedica.com" --force
            ;;
        "doctors")
            npx vercel env add NEXT_PUBLIC_APP_URL production --token="$VERCEL_TOKEN" --scope="$project" --value="https://doctors.autamedica.com" --force
            ;;
        "patients")
            npx vercel env add NEXT_PUBLIC_APP_URL production --token="$VERCEL_TOKEN" --scope="$project" --value="https://patients.autamedica.com" --force
            ;;
        "companies")
            npx vercel env add NEXT_PUBLIC_APP_URL production --token="$VERCEL_TOKEN" --scope="$project" --value="https://companies.autamedica.com" --force
            ;;
    esac
    
    echo "✅ $project configurado"
done

echo "🎉 Todas las variables de entorno configuradas exitosamente"
echo "🔄 Recuerda hacer redeploy de las aplicaciones para aplicar los cambios"
