# 🚀 **Guía de Despliegue Seguro - AutaMedica**

## 📋 **Resumen del Sistema Completado**

✅ **Sistema de autenticación completo** con Supabase que cubre:
- Login, registro, recuperación y restablecimiento de contraseña
- Selección de rol y redirección a cada portal

### 🔧 **Cambios Clave Implementados**

#### **1. Autenticación**
- `LoginForm` / `RegisterForm` conectados a `supabase.auth` con validaciones reales (modo demo solo si envs son "dummy")
- Nueva página `reset-password` procesa enlace seguro (hash o code), restaura sesión y ejecuta `supabase.auth.updateUser`
- `LoginPage` muestra mensajes (`Message`) tras registro/reset e invita al forgot password
- Pantalla `select-role` actualiza `user_metadata.role` y redirige usando `/auth/callback` a cada dashboard según `getRoleRedirectUrl`

#### **2. Configuración de Construcción**
- `vercel.json` usa `corepack` y `HUSKY=0 pnpm install --prod=false` necesario para builds en Vercel

## 🛠️ **Comandos de Despliegue Seguro**

### **Preparación del Directorio de Despliegue**
```bash
# En la copia sin .git
cd /root/altamedica-reboot-deploy

# Web principal
npx vercel --prod --yes --token <TOKEN> --cwd apps/web-app

# Doctors (ya desplegado con envs reales)
npx vercel --prod --yes --token <TOKEN> --cwd apps/doctors

# Pacientes / Empresas / Admin (tras configurar root y env vars en Vercel)
npx vercel --prod --yes --token <TOKEN> --cwd apps/patients
npx vercel --prod --yes --token <TOKEN> --cwd apps/companies
npx vercel --prod --yes --token <TOKEN> --cwd apps/admin
```

### **Recuerda antes de cada portal:**
1. **Establecer Root Directory** (`apps/<portal>`) en Vercel
2. **Cargar las envs reales** (Supabase URL/keys, URLs de portales, flags, HUSKY=0, HUSKY_SKIP_INSTALL=1)
3. **Verificar en Supabase** que `https://autamedica.com/auth/reset-password` (y equivalentes por portal) estén en **Allowed Redirect URLs**

## 🔐 **Configuración de Seguridad**

### **Variables de Entorno Críticas**
```bash
# Supabase (Producción)
NEXT_PUBLIC_SUPABASE_URL=https://hfadsjmdmfqzvtgnqsqr.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...

# URLs de Portales
NEXT_PUBLIC_APP_URL=https://autamedica.com
NEXT_PUBLIC_DOCTORS_URL=https://doctors.autamedica.com
NEXT_PUBLIC_PATIENTS_URL=https://patients.autamedica.com
NEXT_PUBLIC_COMPANIES_URL=https://companies.autamedica.com

# Build Configuration
HUSKY=0
HUSKY_SKIP_INSTALL=1
```

### **Configuración DNS Post-Despliegue**
Una vez propaguen los DNS, usar:
```bash
npx vercel alias <deploy> <dominio> --token <TOKEN>
```

Para apuntar:
- `app.autamedica.com`
- `doctor.autamedica.com` 
- `patients.autamedica.com`
- `companies.autamedica.com`

Asegurándote de que cada dominio esté añadido a la cuenta nueva.

## 🔄 **Proceso de Validación**

### **1. Verificar URLs en Supabase**
- Ir a Supabase Dashboard → Authentication → URL Configuration
- Verificar que todas las URLs de redirect estén en **Allowed Redirect URLs**:
  - `https://autamedica.com/auth/reset-password`
  - `https://doctors.autamedica.com/auth/reset-password`
  - `https://patients.autamedica.com/auth/reset-password`
  - `https://companies.autamedica.com/auth/reset-password`

### **2. Probar Flujo Completo**
1. ✅ Login funcional
2. ✅ Registro funcional  
3. ✅ Reset password funcional
4. ✅ Redirección por roles funcional

## 📚 **Arquitectura de Seguridad**

### **Flujo de Autenticación**
```
Usuario → Login/Register → Supabase Auth → Select Role → Portal Específico
                                     ↓
                              Update user_metadata.role
                                     ↓
                              Redirect via /auth/callback
```

### **Estructura de Deployment**
```
/root/altamedica-reboot-deploy/  # Sin .git para deployment seguro
├── apps/
│   ├── web-app/     # Landing + Auth central
│   ├── doctors/     # Portal médicos
│   ├── patients/    # Portal pacientes
│   └── companies/   # Portal empresarial
```

### **Configuración vercel.json**
```json
{
  "installCommand": "corepack enable && corepack prepare pnpm@9.15.2 --activate && cd ../.. && HUSKY=0 pnpm install --prod=false",
  "buildCommand": "cd ../.. && pnpm build:packages && pnpm build --filter @autamedica/<app>",
  "framework": "nextjs",
  "outputDirectory": ".next"
}
```

## ⚠️ **Consideraciones de Seguridad**

1. **Nunca commitear** tokens o keys reales al repositorio
2. **Usar siempre** la copia sin `.git` para deployments
3. **Verificar** que `HUSKY=0` esté configurado en todas las apps
4. **Validar** URLs de redirect en Supabase antes del deployment
5. **Probar** flujo completo en ambiente de staging primero

## 🎯 **Checklist de Deployment**

- [ ] Directorio sin .git preparado
- [ ] Root Directory configurado en Vercel
- [ ] Variables de entorno cargadas
- [ ] URLs de redirect verificadas en Supabase
- [ ] Build commands con HUSKY=0
- [ ] DNS configurado para dominios personalizados
- [ ] Flujo de autenticación probado end-to-end

---

**Última actualización**: Septiembre 18, 2025
**Status**: ✅ Methodology probada y documentada