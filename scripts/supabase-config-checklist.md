# 🔧 Checklist de Configuración Supabase para Deployment

## 📍 **Problema Actual**
El login funciona pero queda en loop porque Supabase no reconoce el nuevo dominio de Vercel como URL autorizada.

## 🎯 **Solución: Configurar Redirect URLs en Supabase**

### **Paso 1: Acceder a Supabase Dashboard**
1. Ir a [Supabase Dashboard](https://supabase.com/dashboard)
2. Seleccionar proyecto: `gtyvdircfhmdjiaelqkg` (AutaMedica)
3. Ir a **Authentication** → **URL Configuration**

### **Paso 2: Agregar Nuevas URLs**

**Site URL (URL principal):**
```
https://doctors-[project-id].vercel.app
```

**Redirect URLs (URLs de callback OAuth):**
```
https://doctors-[project-id].vercel.app/auth/callback
https://doctors.autamedica.com/auth/callback
https://autamedica.com/auth/callback
```

**Additional Redirect URLs (si usas subdominios):**
```
https://doctors-[project-id].vercel.app/**
https://doctors.autamedica.com/**
https://autamedica.com/**
```

### **Paso 3: Verificar Configuración**

**URLs que DEBEN estar configuradas:**
- ✅ `https://autamedica.com/auth/callback` (principal)
- ✅ `https://doctors.autamedica.com/auth/callback` (producción)
- ✅ `https://doctors-[project-id].vercel.app/auth/callback` (Vercel temporal)
- ✅ `http://localhost:3000/auth/callback` (desarrollo)
- ✅ `http://localhost:3001/auth/callback` (desarrollo doctors)

### **Paso 4: Configurar CORS Origins**

En **Settings** → **API** → **CORS Origins**, agregar:
```
https://doctors-[project-id].vercel.app
https://doctors.autamedica.com  
https://autamedica.com
http://localhost:3000
http://localhost:3001
```

## 🔍 **Cómo Obtener el Project ID de Vercel**

Después del deployment, la URL será algo como:
```
https://doctors-abc123def.vercel.app
```

El `abc123def` es tu project ID.

## ⚠️ **Importante**

1. **Orden de configuración:**
   - Primero: Configurar variables en Vercel
   - Segundo: Hacer redeploy
   - Tercero: Agregar URLs en Supabase
   - Cuarto: Probar el login

2. **Cache de Supabase:** Los cambios pueden tardar 1-2 minutos en propagarse

3. **Testing:** Después de todo configurado, probar:
   - Login desde `https://doctors-[project-id].vercel.app`
   - Verificar que redirecciona al dashboard sin loops

## 🚀 **Scripts de Ayuda**

Para redeploy después de configurar variables:
```bash
./scripts/redeploy-doctors.sh
```

Para verificar que las variables están configuradas:
```bash
npx vercel env ls --scope production
```