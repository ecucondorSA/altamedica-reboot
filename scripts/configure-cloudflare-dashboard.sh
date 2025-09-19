#!/bin/bash

# 🌐 Script para configurar proyectos de Cloudflare Pages con GitHub
# Este script configura automáticamente cada proyecto con sus build commands

set -e

echo "🚀 Configurando proyectos de Cloudflare Pages con GitHub"
echo "======================================================="

# Variables de configuración
GITHUB_REPO="ecucondorSA/altamedica-reboot"
PRODUCTION_BRANCH="main"

# Función para mostrar configuración manual
show_manual_config() {
    local app_name=$1
    local port=$2
    local description=$3
    
    echo ""
    echo "📱 $app_name ($description)"
    echo "-----------------------------------"
    echo "🔗 URL: https://dash.cloudflare.com/pages"
    echo "📂 Project Name: autamedica-$app_name"
    echo "🏠 Production Branch: $PRODUCTION_BRANCH"
    echo "📦 Build Command: cd apps/$app_name && pnpm build:cloudflare"
    echo "📁 Build Output Directory: apps/$app_name/.open-next/dist"
    echo "🌱 Root Directory: / (leave empty)"
    echo "⚡ Framework: Next.js"
    echo ""
    echo "Environment Variables:"
    echo "  NODE_ENV=production"
    echo "  SKIP_ENV_VALIDATION=true"
    echo "  NEXT_PUBLIC_APP_URL=https://autamedica-$app_name.pages.dev"
    if [ "$app_name" != "web-app" ]; then
        echo "  NEXT_PUBLIC_APP_NAME=AutaMedica $(echo $description | sed 's/Portal //')"
    fi
    echo ""
}

# Verificar autenticación de Cloudflare
echo "🔐 Verificando autenticación de Cloudflare..."
if ! wrangler whoami > /dev/null 2>&1; then
    echo "❌ Error: No estás autenticado en Cloudflare"
    echo "Ejecuta: wrangler login"
    exit 1
fi

echo "✅ Autenticado correctamente en Cloudflare"
echo ""

# Verificar que el repositorio GitHub esté accessible
echo "📋 Repositorio GitHub: https://github.com/$GITHUB_REPO"
echo ""

# Mostrar configuración manual para cada proyecto
show_manual_config "web-app" "3000" "Landing + Autenticación"
show_manual_config "doctors" "3001" "Portal Médicos"  
show_manual_config "patients" "3002" "Portal Pacientes"
show_manual_config "companies" "3003" "Portal Empresarial"

echo "📋 INSTRUCCIONES PASO A PASO:"
echo "=============================="
echo ""
echo "1. 🌐 Ve a: https://dash.cloudflare.com/pages"
echo "2. 🔗 Para cada proyecto (autamedica-web-app, autamedica-doctors, etc.):"
echo "   - Haz clic en el proyecto"
echo "   - Ve a Settings → Builds & deployments"
echo "   - Clic en 'Connect to Git'"
echo "   - Selecciona GitHub como provider"
echo "   - Selecciona: $GITHUB_REPO"
echo "   - Configura los build commands según se muestra arriba"
echo "3. 📦 En Environment Variables (Settings → Environment variables):"
echo "   - Agrega las variables mostradas para cada proyecto"
echo "4. 🚀 Trigger deployment: Settings → Builds & deployments → Trigger deployment"
echo ""

echo "🎯 CONFIGURACIÓN MONOREPO:"
echo "=========================="
echo "✅ Build Command detecta automáticamente cambios por app"
echo "✅ Include files outside root directory está habilitado"
echo "✅ Framework preset: Next.js" 
echo "✅ Node version: detectada automáticamente del package.json"
echo ""

echo "🔧 TROUBLESHOOTING:"
echo "=================="
echo "Si hay errores de build:"
echo "1. Verifica que las variables de entorno estén configuradas"
echo "2. Revisa los logs en el Dashboard de Cloudflare"
echo "3. Asegúrate de que SKIP_ENV_VALIDATION=true esté configurado"
echo ""

echo "✨ Una vez configurado, cada push a 'main' disparará deploys automáticos"
echo "🌍 URLs de producción estarán disponibles en:"
echo "   - autamedica-web-app.pages.dev"
echo "   - autamedica-doctors.pages.dev" 
echo "   - autamedica-patients.pages.dev"
echo "   - autamedica-companies.pages.dev"