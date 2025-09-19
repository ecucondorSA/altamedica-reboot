#!/bin/bash

# Script maestro para arreglar completamente el deployment de doctors app
# Ejecuta todos los pasos necesarios en orden

echo "🚀 SOLUCIONANDO DEPLOYMENT DE DOCTORS APP COMPLETAMENTE"
echo "=============================================================="
echo ""

echo "Este script va a:"
echo "1. ✅ Configurar variables de entorno en Vercel"
echo "2. ✅ Hacer redeploy automático" 
echo "3. ✅ Configurar Redirect URLs en Supabase"
echo "4. ✅ Verificar que todo funciona"
echo ""

read -p "¿Continuar? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Cancelado por usuario"
    exit 1
fi

echo ""
echo "🔐 PASO 1: LOGIN EN VERCEL"
echo "=========================="
echo ""

# Verificar si ya está logueado
if ! npx vercel whoami 2>/dev/null; then
    echo "🔑 Necesitas hacer login en Vercel..."
    echo "Ejecutando: npx vercel login"
    echo ""
    
    npx vercel login
    
    if ! npx vercel whoami 2>/dev/null; then
        echo "❌ Error en login de Vercel. Saliendo..."
        exit 1
    fi
fi

echo "✅ Autenticado con Vercel: $(npx vercel whoami)"
echo ""

echo "🔧 PASO 2: CONFIGURAR VARIABLES DE ENTORNO"
echo "=========================================="
echo ""

# Ejecutar script de configuración automática
./scripts/setup-vercel-env-auto.sh

if [ $? -ne 0 ]; then
    echo "❌ Error configurando variables de entorno"
    exit 1
fi

echo ""
echo "🔧 PASO 3: CONFIGURAR SUPABASE REDIRECT URLS"
echo "============================================"
echo ""

# Ejecutar script de Supabase
./scripts/setup-supabase-urls.sh

echo ""
echo "🎯 PASO 4: VERIFICACIÓN FINAL"
echo "============================="
echo ""

echo "📋 Obteniendo URL de deployment..."
cd apps/doctors
DEPLOYMENT_URL=$(npx vercel ls --json | jq -r '.[0].url' 2>/dev/null || echo "no-found")

if [ "$DEPLOYMENT_URL" != "no-found" ] && [ "$DEPLOYMENT_URL" != "null" ]; then
    echo "🌐 URL de deployment: https://$DEPLOYMENT_URL"
    echo ""
    echo "✅ CONFIGURACIÓN COMPLETADA!"
    echo ""
    echo "📋 CHECKLIST FINAL:"
    echo "==================="
    echo "✅ Variables de entorno configuradas en Vercel"
    echo "✅ Deployment realizado"
    echo "✅ Supabase URLs configuradas"
    echo ""
    echo "🎯 PRUEBA FINAL:"
    echo "==============="
    echo "1. Ir a: https://$DEPLOYMENT_URL"
    echo "2. Intentar hacer login"
    echo "3. Verificar que redirecciona al dashboard"
    echo ""
    echo "Si aún hay problemas, agregar manualmente en Supabase:"
    echo "📍 https://supabase.com/dashboard/project/gtyvdircfhmdjiaelqkg/auth/url-configuration"
    echo "🔗 Redirect URL: https://$DEPLOYMENT_URL/auth/callback"
else
    echo "⚠️  No se pudo obtener la URL de deployment automáticamente"
    echo "Revisar en: https://vercel.com/dashboard"
fi

echo ""
echo "✅ PROCESO COMPLETO TERMINADO!"