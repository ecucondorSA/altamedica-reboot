#!/bin/bash

# Script para redeploy del proyecto doctors después de configurar variables de entorno
# Ejecuta desde el root del monorepo

echo "🚀 Iniciando redeploy del proyecto doctors..."

# Cambiar al directorio de la app doctors
cd apps/doctors

echo "📦 Verificando que estamos en el directorio correcto..."
pwd

echo "🔧 Haciendo redeploy con las nuevas variables de entorno..."
# Usar el token de Vercel que ya tienes configurado
npx vercel --prod --yes

echo "✅ Redeploy completado. Revisando el deployment..."
npx vercel ls

echo "🎯 El proyecto doctors debería estar funcionando con las nuevas variables."
echo "📍 Verifica en: https://doctors-[project-id].vercel.app"
echo ""
echo "⚠️  IMPORTANTE: También necesitas configurar las Redirect URLs en Supabase:"
echo "   1. Ir a Supabase Dashboard → Authentication → URL Configuration"
echo "   2. Agregar en 'Redirect URLs': https://doctors-[project-id].vercel.app/auth/callback"
echo "   3. Agregar en 'Site URL': https://doctors-[project-id].vercel.app"