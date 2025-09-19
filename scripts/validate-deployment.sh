#!/bin/bash

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Contadores
ERRORS=0
WARNINGS=0

echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}    VALIDACIÓN COMPLETA DE DEPLOYMENT - ALTAMEDICA REBOOT   ${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo ""

# 1. Verificar estructura de directorios
echo -e "${YELLOW}▶ Verificando estructura de directorios...${NC}"
REQUIRED_APPS=("web-app" "doctors" "patients" "companies" "admin")
for app in "${REQUIRED_APPS[@]}"; do
    if [ -d "apps/$app" ]; then
        echo -e "${GREEN}  ✓ apps/$app existe${NC}"
    else
        echo -e "${RED}  ✗ apps/$app NO EXISTE${NC}"
        ((ERRORS++))
    fi
done
echo ""

# 2. Verificar package.json y dependencias Next.js
echo -e "${YELLOW}▶ Verificando dependencias Next.js...${NC}"
for app in "${REQUIRED_APPS[@]}"; do
    if [ -f "apps/$app/package.json" ]; then
        MISSING_DEPS=""
        
        # Verificar next
        if ! grep -q '"next"' "apps/$app/package.json"; then
            MISSING_DEPS="next"
        fi
        
        # Verificar react
        if ! grep -q '"react"' "apps/$app/package.json"; then
            MISSING_DEPS="$MISSING_DEPS react"
        fi
        
        # Verificar react-dom
        if ! grep -q '"react-dom"' "apps/$app/package.json"; then
            MISSING_DEPS="$MISSING_DEPS react-dom"
        fi
        
        if [ -z "$MISSING_DEPS" ]; then
            echo -e "${GREEN}  ✓ $app: todas las dependencias Next.js presentes${NC}"
        else
            echo -e "${RED}  ✗ $app falta: $MISSING_DEPS${NC}"
            ((ERRORS++))
        fi
    else
        echo -e "${RED}  ✗ $app: package.json no encontrado${NC}"
        ((ERRORS++))
    fi
done
echo ""

# 3. Verificar vercel.json
echo -e "${YELLOW}▶ Verificando configuración Vercel...${NC}"
for app in "${REQUIRED_APPS[@]}"; do
    if [ -f "apps/$app/vercel.json" ]; then
        # Verificar estructura básica
        if grep -q '"installCommand"' "apps/$app/vercel.json" && \
           grep -q '"buildCommand"' "apps/$app/vercel.json" && \
           grep -q '"outputDirectory"' "apps/$app/vercel.json" && \
           grep -q '"framework"' "apps/$app/vercel.json"; then
            echo -e "${GREEN}  ✓ $app: vercel.json completo${NC}"
        else
            echo -e "${YELLOW}  ⚠ $app: vercel.json incompleto${NC}"
            ((WARNINGS++))
        fi
    else
        echo -e "${RED}  ✗ $app: vercel.json NO EXISTE${NC}"
        ((ERRORS++))
    fi
done
echo ""

# 4. Verificar archivos críticos
echo -e "${YELLOW}▶ Verificando archivos críticos...${NC}"
for app in "${REQUIRED_APPS[@]}"; do
    CRITICAL_FILES=(
        "apps/$app/next.config.js"
        "apps/$app/tsconfig.json"
        "apps/$app/tailwind.config.ts"
    )
    
    for file in "${CRITICAL_FILES[@]}"; do
        if [ -f "$file" ]; then
            echo -e "${GREEN}  ✓ $file existe${NC}"
        else
            echo -e "${YELLOW}  ⚠ $file no encontrado${NC}"
            ((WARNINGS++))
        fi
    done
done
echo ""

# 5. Verificar configuración de puertos únicos
echo -e "${YELLOW}▶ Verificando puertos únicos para desarrollo...${NC}"
EXPECTED_PORTS=("web-app:3000" "doctors:3001" "patients:3002" "companies:3003" "admin:3004")
for port_config in "${EXPECTED_PORTS[@]}"; do
    IFS=':' read -r app port <<< "$port_config"
    if [ -f "apps/$app/package.json" ]; then
        if grep -q "\"dev\".*$port" "apps/$app/package.json"; then
            echo -e "${GREEN}  ✓ $app configurado en puerto $port${NC}"
        else
            echo -e "${YELLOW}  ⚠ $app: puerto $port no configurado en dev script${NC}"
            ((WARNINGS++))
        fi
    fi
done
echo ""

# 6. Verificar variables de entorno
echo -e "${YELLOW}▶ Verificando variables de entorno...${NC}"
ENV_VARS=(
    "NEXT_PUBLIC_SUPABASE_URL"
    "NEXT_PUBLIC_SUPABASE_ANON_KEY"
    "SUPABASE_SERVICE_ROLE_KEY"
)

for var in "${ENV_VARS[@]}"; do
    if [ -n "${!var}" ]; then
        echo -e "${GREEN}  ✓ $var está configurada${NC}"
    else
        echo -e "${YELLOW}  ⚠ $var NO está configurada${NC}"
        ((WARNINGS++))
    fi
done
echo ""

# 7. Verificar linkeo con Vercel
echo -e "${YELLOW}▶ Verificando linkeo con Vercel...${NC}"
for app in "${REQUIRED_APPS[@]}"; do
    if [ -f "apps/$app/.vercel/project.json" ]; then
        PROJECT_ID=$(grep -o '"projectId":"[^"]*' "apps/$app/.vercel/project.json" | cut -d'"' -f4)
        if [ -n "$PROJECT_ID" ]; then
            echo -e "${GREEN}  ✓ $app vinculado (ID: ${PROJECT_ID:0:12}...)${NC}"
        else
            echo -e "${YELLOW}  ⚠ $app: project.json sin projectId${NC}"
            ((WARNINGS++))
        fi
    else
        echo -e "${YELLOW}  ⚠ $app: no vinculado con Vercel${NC}"
        ((WARNINGS++))
    fi
done
echo ""

# 8. Verificar build local
echo -e "${YELLOW}▶ Intentando build local de packages...${NC}"
if command -v pnpm &> /dev/null; then
    echo "  Ejecutando: pnpm build:packages"
    if pnpm build:packages > /dev/null 2>&1; then
        echo -e "${GREEN}  ✓ Build de packages exitoso${NC}"
    else
        echo -e "${RED}  ✗ Build de packages falló${NC}"
        ((ERRORS++))
    fi
else
    echo -e "${YELLOW}  ⚠ pnpm no disponible para test de build${NC}"
    ((WARNINGS++))
fi
echo ""

# 9. Verificar Auth0 callbacks (si aplica)
echo -e "${YELLOW}▶ Verificando configuración Auth0...${NC}"
if [ -n "$AUTH0_DOMAIN" ]; then
    echo -e "${GREEN}  ✓ AUTH0_DOMAIN configurado${NC}"
else
    echo -e "${YELLOW}  ⚠ AUTH0_DOMAIN no configurado (usar Supabase Auth)${NC}"
fi
echo ""

# 10. Resumen final
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}                         RESUMEN                             ${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}✅ VALIDACIÓN EXITOSA: Sistema listo para deployment${NC}"
    echo -e "${GREEN}   No se encontraron errores ni advertencias${NC}"
    exit 0
elif [ $ERRORS -eq 0 ]; then
    echo -e "${YELLOW}⚠️  VALIDACIÓN CON ADVERTENCIAS${NC}"
    echo -e "${YELLOW}   Errores: 0 | Advertencias: $WARNINGS${NC}"
    echo -e "${YELLOW}   El deployment puede proceder pero revisa las advertencias${NC}"
    exit 0
else
    echo -e "${RED}❌ VALIDACIÓN FALLIDA${NC}"
    echo -e "${RED}   Errores: $ERRORS | Advertencias: $WARNINGS${NC}"
    echo -e "${RED}   Corrige los errores antes de hacer deployment${NC}"
    exit 1
fi