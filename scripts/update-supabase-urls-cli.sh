#!/bin/bash

# Script para actualizar URLs de Supabase usando CLI y API directa
# Soluciona el problema de redirección OAuth

echo "🔧 Actualizando URLs de Supabase para el deployment..."
echo ""

PROJECT_REF="hfadsjmdmfqzvtgnqsqr"
ACCESS_TOKEN="sbp_aa74b7707840d07be814d4f92adde20dd35d3c16"

# URLs del deployment de Vercel
VERCEL_URL1="https://médicos-4vjq1iyi1-ecucondor-gmailcoms-proyectos.vercel.app"
VERCEL_URL2="https://doctores-ebon.vercel.app"

echo "📍 Proyecto: $PROJECT_REF"
echo "🔗 URL principal: $VERCEL_URL1"
echo "🔗 URL alternativa: $VERCEL_URL2"
echo ""

# Intentar múltiples métodos para actualizar la configuración

echo "🔄 Método 1: Actualizando Site URL via API REST..."
curl -s -X PATCH \
  "https://api.supabase.com/v1/projects/$PROJECT_REF/config/auth" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"SITE_URL\": \"$VERCEL_URL1\"}" || echo "❌ Método 1 falló"

echo ""
echo "🔄 Método 2: Configurando redirect URLs específicos..."

# Lista completa de URLs permitidas
REDIRECT_URLS="[
  \"https://autamedica.com/auth/callback\",
  \"https://doctors.autamedica.com/auth/callback\",
  \"https://patients.autamedica.com/auth/callback\",
  \"https://companies.autamedica.com/auth/callback\",
  \"$VERCEL_URL1/auth/callback\",
  \"$VERCEL_URL2/auth/callback\",
  \"http://localhost:3000/auth/callback\",
  \"http://localhost:3001/auth/callback\"
]"

curl -s -X PATCH \
  "https://api.supabase.com/v1/projects/$PROJECT_REF/config/auth" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{
    \"SITE_URL\": \"$VERCEL_URL1\",
    \"URI_ALLOW_LIST\": \"$VERCEL_URL1/**,$VERCEL_URL2/**,https://autamedica.com/**,https://doctors.autamedica.com/**,https://patients.autamedica.com/**,https://companies.autamedica.com/**,http://localhost:3000/**,http://localhost:3001/**\"
  }" || echo "❌ Método 2 falló"

echo ""
echo "🔄 Método 3: Usando Management API..."

# Usar el endpoint de management para configuración
curl -s -X PUT \
  "https://api.supabase.com/v1/projects/$PROJECT_REF" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{
    \"auth_site_url\": \"$VERCEL_URL1\",
    \"auth_additional_redirect_urls\": [
      \"$VERCEL_URL1/auth/callback\",
      \"$VERCEL_URL2/auth/callback\",
      \"https://autamedica.com/auth/callback\",
      \"https://doctors.autamedica.com/auth/callback\",
      \"https://patients.autamedica.com/auth/callback\",
      \"https://companies.autamedica.com/auth/callback\"
    ]
  }" || echo "❌ Método 3 falló"

echo ""
echo "✅ Intentos de actualización completados."
echo ""
echo "🎯 URLs que se intentaron configurar:"
echo "   Site URL: $VERCEL_URL1"
echo "   Callbacks:"
echo "   - $VERCEL_URL1/auth/callback"
echo "   - $VERCEL_URL2/auth/callback"
echo "   - https://autamedica.com/auth/callback"
echo "   - https://doctors.autamedica.com/auth/callback"
echo "   - https://patients.autamedica.com/auth/callback"
echo "   - https://companies.autamedica.com/auth/callback"
echo ""
echo "⚠️  Si los métodos CLI fallaron, configura manualmente en:"
echo "   https://supabase.com/dashboard/project/$PROJECT_REF/auth/url-configuration"
echo ""
echo "🔍 Después de configurar, prueba el login en:"
echo "   $VERCEL_URL1"
echo "   $VERCEL_URL2"