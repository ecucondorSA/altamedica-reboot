#!/bin/bash

# Script para configurar dominios personalizados en Cloudflare Pages
# Requiere API Token con permisos de Zone:Read y Pages:Edit

ACCOUNT_ID="5737682cdee596a0781f795116a3120b"
PROJECT_NAME="autamedica-web-app"
DOMAIN="www.autamedica.com"

echo "🌐 Configurando dominio personalizado para Cloudflare Pages..."
echo "📋 Proyecto: $PROJECT_NAME"
echo "🔗 Dominio: $DOMAIN"

# Usar el ID de zona que proporcionaste
ZONE_ID="ca26c31b73f6542900edb791be66e6f7"

echo "🔗 Zone ID: $ZONE_ID"
echo "💡 Necesitas generar un API token con permisos de Zone:Edit y Pages:Edit"
echo "📝 Ve a: https://dash.cloudflare.com/profile/api-tokens"
echo ""

# Solicitar API token si no está configurado
if [ -z "$CLOUDFLARE_API_TOKEN" ]; then
    echo "⚠️  Variable CLOUDFLARE_API_TOKEN no encontrada"
    echo "💡 Exporta tu API token:"
    echo "   export CLOUDFLARE_API_TOKEN='tu_token_aqui'"
    echo ""
    echo "🔑 O ejecuta este script después de cambiar los nameservers:"
    echo "   CLOUDFLARE_API_TOKEN='tu_token' ./scripts/configure-domains.sh"
    exit 1
fi

API_TOKEN="$CLOUDFLARE_API_TOKEN"

echo "🔑 API Token encontrado"

# Configurar dominio personalizado
echo "📡 Agregando dominio personalizado..."

RESPONSE=$(curl -s -X POST \
  "https://api.cloudflare.com/client/v4/accounts/$ACCOUNT_ID/pages/projects/$PROJECT_NAME/domains" \
  -H "Authorization: Bearer $API_TOKEN" \
  -H "Content-Type: application/json" \
  --data "{\"name\": \"$DOMAIN\"}")

# Verificar respuesta
if echo "$RESPONSE" | grep -q '"success":true'; then
    echo "✅ Dominio agregado exitosamente"
    echo "🔒 SSL se configurará automáticamente en unos minutos"
    echo "🌍 Tu sitio estará disponible en: https://$DOMAIN"
else
    echo "❌ Error al agregar dominio:"
    echo "$RESPONSE" | jq '.' 2>/dev/null || echo "$RESPONSE"
    echo ""
    echo "💡 Alternativas:"
    echo "   1. Configurar manualmente en: https://dash.cloudflare.com"
    echo "   2. Usar URL temporal: https://autamedica-web-app.pages.dev"
fi

echo "🎯 Configuración completada"