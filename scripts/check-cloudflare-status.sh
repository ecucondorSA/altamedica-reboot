#!/bin/bash

# 📊 Script para verificar estado de deployments en Cloudflare Pages

set -e

echo "📊 Verificando estado de Cloudflare Pages"
echo "========================================="

# Lista de proyectos
projects=("autamedica-web-app" "autamedica-doctors" "autamedica-patients" "autamedica-companies")

echo "🔍 Verificando proyectos existentes..."
echo ""

# Verificar que wrangler esté autenticado
if ! wrangler whoami > /dev/null 2>&1; then
    echo "❌ Error: No estás autenticado en Cloudflare"
    echo "Ejecuta: wrangler login"
    exit 1
fi

# Listar todos los proyectos
echo "📋 Proyectos de Cloudflare Pages:"
wrangler pages project list

echo ""
echo "🌐 URLs de los proyectos:"
echo "========================"

for project in "${projects[@]}"; do
    echo "🚀 $project: https://$project.pages.dev"
done

echo ""
echo "🔧 Comandos útiles:"
echo "=================="
echo ""
echo "📝 Ver deployments de un proyecto:"
echo "   wrangler pages deployment list --project-name=autamedica-web-app"
echo ""
echo "🚀 Hacer deploy manual desde local:"
echo "   cd apps/web-app && pnpm deploy:cloudflare"
echo ""
echo "📊 Ver logs de build en tiempo real:"
echo "   wrangler pages deployment tail --project-name=autamedica-web-app"
echo ""
echo "🌍 Abrir dashboard de un proyecto:"
echo "   https://dash.cloudflare.com/pages/autamedica-web-app"
echo ""

echo "📱 Estado de configuración necesaria:"
echo "====================================="
echo ""
echo "Para completar la configuración, asegúrate de:"
echo "1. ✅ Conectar GitHub repository en cada proyecto"
echo "2. ✅ Configurar build commands por proyecto"  
echo "3. ✅ Agregar variables de entorno"
echo "4. ✅ Hacer primer deployment"
echo ""
echo "📋 Usa el script configure-cloudflare-dashboard.sh para instrucciones detalladas"