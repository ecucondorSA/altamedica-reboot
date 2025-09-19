#!/bin/bash

echo "🔧 Configurando y desplegando aplicaciones en Vercel..."

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Token de Vercel
export VERCEL_TOKEN="bxAttf7rOzTj8sqiu3d1nHgx"

# Configurar cada proyecto con el Root Directory correcto
echo -e "${YELLOW}⚙️ Configurando proyectos en Vercel...${NC}"

# Para cada app, necesitamos que el Root Directory esté en el nivel del monorepo
# y que el buildCommand incluya el path correcto

deploy_app() {
    local app=$1
    local port=$2
    
    echo -e "${YELLOW}📦 Desplegando $app...${NC}"
    
    # Desde el root del monorepo
    cd /root/altamedica-reboot
    
    # Desplegar con configuración específica
    SKIP_ENV_VALIDATION=true npx vercel --prod --yes \
        --token "$VERCEL_TOKEN" \
        --cwd "apps/$app" \
        --build-env SKIP_ENV_VALIDATION=true \
        --build-env NODE_ENV=production
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ $app desplegado exitosamente${NC}"
    else
        echo -e "${YELLOW}⚠️ Error al desplegar $app${NC}"
    fi
    
    echo ""
}

# Desplegar cada aplicación
deploy_app "web-app" "3000"
deploy_app "doctors" "3001" 
deploy_app "patients" "3002"
deploy_app "companies" "3003"

echo -e "${GREEN}🎉 Proceso de deployment completado${NC}"
echo ""
echo "URLs de producción:"
echo "  - Web-App: https://web-app-reina08s-projects.vercel.app"
echo "  - Doctors: https://doctors-reina08s-projects.vercel.app"
echo "  - Patients: https://patients-reina08s-projects.vercel.app"
echo "  - Companies: https://companies-reina08s-projects.vercel.app"