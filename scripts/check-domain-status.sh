#!/bin/bash

# Script para verificar el estado de configuración del dominio

DOMAIN="autamedica.com"
SUBDOMAIN="www.autamedica.com"

echo "🌐 Verificando estado de configuración de dominio..."
echo "📋 Dominio: $DOMAIN"

echo ""
echo "1️⃣ Verificando Nameservers actuales:"
echo "🔍 Consultando nameservers de $DOMAIN..."
dig +short NS $DOMAIN

echo ""
echo "2️⃣ Verificando si Cloudflare está activo:"
echo "🔍 Consultando IP de $SUBDOMAIN..."
CURRENT_IP=$(dig +short $SUBDOMAIN)
echo "IP actual: $CURRENT_IP"

if echo "$CURRENT_IP" | grep -E '^(104\.16\.|172\.64\.|104\.17\.|172\.67\.|104\.18\.|104\.19\.|104\.20\.|104\.21\.|104\.22\.|104\.23\.|104\.24\.|104\.25\.|104\.26\.|104\.27\.|104\.28\.|104\.29\.|104\.30\.|104\.31\.|172\.65\.|172\.66\.|172\.68\.|172\.69\.|172\.70\.|172\.71\.)'; then
    echo "✅ Cloudflare está activo (IP de Cloudflare detectada)"
    CLOUDFLARE_ACTIVE=true
else
    echo "⏳ Cloudflare no está activo todavía (IP no es de Cloudflare)"
    CLOUDFLARE_ACTIVE=false
fi

echo ""
echo "3️⃣ Verificando acceso HTTPS:"
echo "🔍 Probando conexión a https://$SUBDOMAIN..."

if curl -s -I --max-time 10 "https://$SUBDOMAIN" | grep -q "HTTP.*200\|HTTP.*301\|HTTP.*302"; then
    echo "✅ HTTPS funciona correctamente"
    echo "🌍 Sitio accesible en: https://$SUBDOMAIN"
else
    echo "❌ HTTPS no funciona todavía"
    echo "💡 URL temporal: https://autamedica-web-app.pages.dev"
fi

echo ""
echo "📊 Resumen:"
if [ "$CLOUDFLARE_ACTIVE" = true ]; then
    echo "✅ Cloudflare: Activo"
    echo "🎯 Siguiente paso: Configurar dominio en Pages"
    echo "💻 Ejecuta: CLOUDFLARE_API_TOKEN='tu_token' ./scripts/configure-domains.sh"
else
    echo "⏳ Cloudflare: Pendiente activación"
    echo "🎯 Siguiente paso: Cambiar nameservers en GoDaddy"
    echo "📝 Nameservers Cloudflare:"
    echo "   - davina.ns.cloudflare.com"
    echo "   - randall.ns.cloudflare.com"
fi

echo ""
echo "🔗 Enlaces útiles:"
echo "   • GoDaddy DNS: https://account.godaddy.com"
echo "   • Cloudflare Dashboard: https://dash.cloudflare.com"
echo "   • Site temporal: https://autamedica-web-app.pages.dev"