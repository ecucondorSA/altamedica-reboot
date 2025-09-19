#!/bin/bash

# Script para agregar la URL de patients deployment a Supabase
# Incluye todas las URLs de deployments completados

echo "🔧 Configurando Supabase con todas las URLs de deployment..."
echo ""

PROJECT_REF="hfadsjmdmfqzvtgnqsqr"
ACCESS_TOKEN="sbp_aa74b7707840d07be814d4f92adde20dd35d3c16"

# URLs de todos los deployments
DOCTORS_URL="https://doctors-8cp3hr5fy-ecucondor-gmailcoms-projects.vercel.app"
WEBAPP_URL="https://autamedica-web-f4kjlzrf1-ecucondor-gmailcoms-projects.vercel.app"
PATIENTS_URL="https://autamedica-patients-m7wvcbzgm-ecucondor-gmailcoms-projects.vercel.app"
DOCTORS_ALT="https://médicos-4vjq1iyi1-ecucondor-gmailcoms-proyectos.vercel.app"
DOCTORS_CUSTOM="https://doctores-ebon.vercel.app"

echo "📍 Proyecto: $PROJECT_REF"
echo "🔗 URLs a configurar:"
echo "   - Doctors: $DOCTORS_URL"
echo "   - Web-app: $WEBAPP_URL"
echo "   - Patients: $PATIENTS_URL (NUEVA)"
echo "   - Doctors Alt: $DOCTORS_ALT"
echo "   - Doctors Custom: $DOCTORS_CUSTOM"
echo ""

# Método 1: Configurar Site URL principal
echo "🔄 Configurando Site URL principal..."
curl -s -X PATCH \
  "https://api.supabase.com/v1/projects/$PROJECT_REF/config/auth" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"SITE_URL\": \"$WEBAPP_URL\"}" \
  && echo "✅ Site URL configurado" \
  || echo "⚠️  Site URL requiere configuración manual"

echo ""

# Método 2: Lista completa de redirect URLs
echo "🔄 Configurando todas las redirect URLs..."

ALLOWED_URLS="$WEBAPP_URL/**,$DOCTORS_URL/**,$PATIENTS_URL/**,$DOCTORS_ALT/**,$DOCTORS_CUSTOM/**,https://autamedica.com/**,https://doctors.autamedica.com/**,https://patients.autamedica.com/**,https://companies.autamedica.com/**,http://localhost:3000/**,http://localhost:3001/**,http://localhost:3002/**"

curl -s -X PATCH \
  "https://api.supabase.com/v1/projects/$PROJECT_REF/config/auth" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{
    \"SITE_URL\": \"$WEBAPP_URL\",
    \"URI_ALLOW_LIST\": \"$ALLOWED_URLS\"
  }" \
  && echo "✅ Redirect URLs configuradas" \
  || echo "⚠️  Redirect URLs requieren configuración manual"

echo ""

# Método 3: Configuración mediante Management API
echo "🔄 Intentando configuración avanzada..."

curl -s -X PUT \
  "https://api.supabase.com/v1/projects/$PROJECT_REF" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{
    \"auth_site_url\": \"$WEBAPP_URL\",
    \"auth_additional_redirect_urls\": [
      \"$WEBAPP_URL/auth/callback\",
      \"$DOCTORS_URL/auth/callback\",
      \"$PATIENTS_URL/auth/callback\",
      \"$DOCTORS_ALT/auth/callback\",
      \"$DOCTORS_CUSTOM/auth/callback\",
      \"https://autamedica.com/auth/callback\",
      \"https://doctors.autamedica.com/auth/callback\",
      \"https://patients.autamedica.com/auth/callback\",
      \"https://companies.autamedica.com/auth/callback\"
    ]
  }" \
  && echo "✅ Configuración avanzada aplicada" \
  || echo "⚠️  Configuración avanzada requiere acceso manual"

echo ""
echo "✅ Configuración de Supabase completada"
echo ""
echo "🎯 URLs CONFIGURADAS:"
echo "======================================"
echo "Site URL: $WEBAPP_URL"
echo ""
echo "Redirect URLs:"
echo "✅ $WEBAPP_URL/auth/callback"
echo "✅ $DOCTORS_URL/auth/callback"
echo "✅ $PATIENTS_URL/auth/callback (NUEVA)"
echo "✅ $DOCTORS_ALT/auth/callback"
echo "✅ $DOCTORS_CUSTOM/auth/callback"
echo "✅ https://autamedica.com/auth/callback"
echo "✅ https://doctors.autamedica.com/auth/callback"
echo "✅ https://patients.autamedica.com/auth/callback"
echo "✅ https://companies.autamedica.com/auth/callback"
echo ""
echo "🚀 PRUEBA EL LOGIN EN:"
echo "====================="
echo "• $DOCTORS_URL"
echo "• $PATIENTS_URL"
echo "• $WEBAPP_URL"
echo ""
echo "⚠️  Si algún método falló, configura manualmente en:"
echo "   https://supabase.com/dashboard/project/$PROJECT_REF/auth/url-configuration"