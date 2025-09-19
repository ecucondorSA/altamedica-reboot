#!/bin/bash

# Script para configurar URLs de redirección en Supabase
# Resuelve el error flow_state_not_found

echo "🔧 Configurando URLs de redirección en Supabase..."

# URLs de las aplicaciones desplegadas
WEB_APP="https://altamedica-reboot-5axhhunde-reina08s-projects.vercel.app"
DOCTORS="https://doctors-reina08s-projects.vercel.app"
PATIENTS="https://patients-reina08s-projects.vercel.app"
COMPANIES="https://companies-reina08s-projects.vercel.app"

# URLs de callback que necesitan estar configuradas en Supabase
REDIRECT_URLS=(
  "${WEB_APP}/auth/callback"
  "${DOCTORS}/auth/callback"
  "${PATIENTS}/auth/callback"
  "${COMPANIES}/auth/callback"
  "http://localhost:3000/auth/callback"
  "http://localhost:3001/auth/callback"
  "http://localhost:3002/auth/callback"
  "http://localhost:3003/auth/callback"
)

echo "🌐 URLs de redirección a configurar:"
for url in "${REDIRECT_URLS[@]}"; do
  echo "  - $url"
done

echo ""
echo "🔑 Para configurar en Supabase Dashboard:"
echo "1. Ir a https://supabase.com/dashboard/project/gtyvdircfhmdjiaelqkg"
echo "2. Ir a Authentication > URL Configuration"
echo "3. En 'Redirect URLs', agregar todas las URLs listadas arriba"
echo "4. En 'Site URL', configurar: ${WEB_APP}"
echo ""
echo "🚨 IMPORTANTE: Sin estas URLs configuradas, se producirá el error 'flow_state_not_found'"
echo ""

# También podemos usar la API de Supabase para configurar automáticamente
echo "💡 Alternativa: Usar API de Supabase para configurar automáticamente"
echo "   (Requiere configuración adicional de API keys)"