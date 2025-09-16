# CLAUDE.md - Guía para Claude Code

Esta guía ayuda a futuras instancias de Claude Code a trabajar efectivamente en el monorepo de Autamedica.

## 🏥 Arquitectura del Proyecto

**Autamedica** es una plataforma médica moderna construida como monorepo con Turborepo.

```
autamedica-reboot/
├── apps/
│   └── web-app/               # Next.js 15 app principal
├── packages/
│   ├── @autamedica/types      # Contratos TypeScript centralizados
│   ├── @autamedica/shared     # Utilidades compartidas
│   ├── @autamedica/auth       # React Context + hooks auth
│   └── @autamedica/hooks      # React hooks médicos
├── docs/
│   └── GLOSARIO_MAESTRO.md    # FUENTE DE VERDAD para contratos
└── scripts/
    ├── validate-exports.mjs   # Validación contratos vs exports
    └── health-check.mjs       # Health check completo
```

## 🚨 Reglas Críticas

### 1. Contract-First Development

- **TODO export DEBE estar en `docs/GLOSARIO_MAESTRO.md` PRIMERO**
- Ejecutar `pnpm docs:validate` para validar contratos vs exports
- Usar `ISODateString` en lugar de `Date` para APIs
- `APIResponse<T>` como discriminated union obligatorio

### 2. Zero Technical Debt

- El usuario enfatizó: **"no generes deuda tecnica por favor"**
- Strict TypeScript, ESLint sin warnings (`--max-warnings=0`)
- Tests obligatorios con Vitest
- Pre-commit hooks con husky + lint-staged

### 3. Import Rules Estrictas

```typescript
// ✅ PERMITIDO
import { Patient } from "@autamedica/types";
import { ensureEnv } from "@autamedica/shared";

// ❌ PROHIBIDO - Deep imports
import { Patient } from "@autamedica/types/src/entities";
const env = process.env.API_URL; // Direct process.env access
```

## 🛠 Comandos Principales

### 🚀 Comando Principal para Claude

```bash
pnpm claude                  # Inicia sesión completa de desarrollo con Claude
# o
pnpm start-claude           # Alias del comando anterior
# o
./start-claude              # Script directo ejecutable
```

**Este comando único ejecuta automáticamente:**

- ✅ Validación inicial de políticas del monorepo
- 🔄 TypeScript watch mode para todos los packages
- 🚀 Dev server con hot reload (Turbo)
- 🔍 ESLint watch mode (si está disponible)
- 📊 Monitoring en tiempo real de errores

### Desarrollo Manual

```bash
pnpm dev                     # Todos los packages en watch mode
pnpm dev --filter web-app    # Solo la app web
```

### Build y Validación

```bash
pnpm build:packages         # Solo packages (@autamedica/*)
pnpm build:apps            # Solo apps (./apps/*)
pnpm type-check            # TypeScript check
pnpm lint                  # ESLint check (strict, no warnings)
pnpm docs:validate         # Validar exports vs GLOSARIO_MAESTRO
pnpm health               # Health check completo
```

### Deployment y Validación

```bash
pnpm vercel:validate        # Validar configuración Vercel deployment
pnpm pre-deploy            # Validación completa pre-deployment
pnpm security:check        # Validaciones de seguridad
pnpm security:full         # Audit + security check completo
```

### Testing

```bash
pnpm test:unit            # Vitest con coverage
pnpm test                 # Run all tests
```

## 📦 Package Architecture

### Dependencias Estrictas

```
@autamedica/types (base - branded types, contratos)
    ↓
@autamedica/shared (utilities, validations, ensureEnv)
    ↓
@autamedica/auth + @autamedica/hooks
    ↓
apps/web-app
```

## 🔐 Sistema de Autenticación

### Implementación Completa de Supabase Auth

**✅ IMPLEMENTADO** - Sistema de autenticación robusto con magic links:

- **@autamedica/auth**: Package completo con Supabase wrapper
- **Magic Links**: Autenticación sin contraseña via email
- **Roles**: `patient`, `doctor`, `company_admin`, `platform_admin`
- **Portales**: Redirección automática basada en rol
- **Middleware**: Protección automática de rutas
- **Session Management**: Funciones `getSession`, `requireSession`, `signOut`

### Archivos Clave de Autenticación

```typescript
// @autamedica/auth package
packages/auth/src/
├── client.ts          // Browser client
├── server.ts          // Server clients (middleware, route handlers)
├── session.ts         // Session management
├── email.ts           // Magic link authentication
└── index.ts           // Exports centralizados

// App routes
apps/web-app/src/app/
├── auth/login/page.tsx       // Login form con portal params
├── auth/callback/route.ts    // OAuth callback handler
└── middleware.ts             // Route protection
```

### Uso de Autenticación

```typescript
// Client-side
import { createBrowserClient } from "@autamedica/auth";
const supabase = createBrowserClient();

// Server actions
import { getSession, requireSession } from "@autamedica/auth";
const session = await getSession();
const user = await requireSession("/auth/login");

// Portal access control
import { requirePortalAccess } from "@autamedica/auth";
const session = await requirePortalAccess("medico");
```

### @autamedica/types

- Branded types: `PatientId`, `DoctorId`, `UUID`
- `ISODateString` para fechas
- `APIResponse<T>` discriminated union
- **Ubicación**: `packages/types/src/index.ts`

### @autamedica/shared

- `ensureEnv()` para variables de entorno
- `validateEmail()`, `validatePhone()`
- **Único package que puede usar `process.env`**

### @autamedica/auth

- React Context + useAuth hook
- AuthProvider para apps

### @autamedica/hooks

- Hooks médicos: `usePatients`, `useAppointments`
- Hooks utilidad: `useAsync`, `useDebounce`

## 🔧 Configuración Técnica

### ESLint Configuration

- ESLint 9.x con configuración estricta (`--max-warnings=0`)
- Reglas personalizadas para monorepo:
  - `no-restricted-imports`: Prohibe deep imports de packages
  - `no-restricted-globals`: Prohibe `process.env` directo (solo en @autamedica/shared)
  - `vercel-deployment-config/validate-config`: **Valida configuración de Vercel deployment**
- Auto-validación que previene problemas de deployment

### TypeScript

- Version: 5.9.2
- Strict mode enabled
- `moduleResolution: "Bundler"`
- Paths apuntan a `dist/` files

### Build System

- **Turborepo 2.5.6** con cache distribuido
- **Next.js 15.5.0** con Turbopack beta
- **PNPM** como package manager
- Builds paralelos con dependencias

### CI/CD

- **GitHub Actions** con jobs separados:
  - lint (ESLint strict)
  - typecheck (TypeScript)
  - build (packages → apps)
  - contracts (validar exports)
  - test (Vitest con coverage)
- **Pre-commit**: ESLint auto-fix + Prettier

## 🚀 Comandos de Despliegue

### Vercel (Configurado)

- Root Directory: `apps/web-app`
- Build Command: `pnpm -w build --filter @autamedica/web-app...`
- Framework: Next.js
- Node version: >=18

### Variables de Entorno

- Usar `ensureEnv()` de `@autamedica/shared`
- **NO** acceso directo a `process.env`

## 🧪 Testing Standards

### Vitest Configuration

- Coverage con V8
- Tests en `*.test.ts` files
- Ejemplo: `packages/shared/src/validators.test.ts`

### Test Structure

```typescript
import { describe, it, expect } from "vitest";

describe("validateEmail", () => {
  it("should accept valid email", () => {
    expect(validateEmail("user@example.com")).toBe(true);
  });
});
```

## 🐛 Troubleshooting Common Issues

### Build Errors

```bash
# Limpiar cache completo
rm -rf node_modules dist .next .turbo
pnpm install
pnpm build
```

### TypeScript Errors

```bash
# Check específico por package
pnpm --filter @autamedica/types typecheck

# Global check
pnpm type-check
```

### Import/Export Errors

```bash
# Validar contratos vs exports
pnpm docs:validate

# Health check completo
pnpm health
```

### Deployment Errors

```bash
# Validar configuración de Vercel
pnpm vercel:validate

# Diagnóstico completo de deployment
./collect_vercel_diagnostics.sh

# Validación pre-deployment
pnpm pre-deploy
```

## ⚠️ Cosas que NUNCA hacer

1. **Deep imports** de packages internos
2. **process.env** directo (usar `ensureEnv`)
3. **Exports sin documentar** en GLOSARIO_MAESTRO
4. **Date objects** en APIs (usar `ISODateString`)
5. **Warnings en ESLint** (configurado con `--max-warnings=0`)
6. **Commits sin tests** para nueva funcionalidad
7. **Breaking changes** sin actualizar GLOSARIO_MAESTRO
8. **Configuración incorrecta de deployment** (validada por regla ESLint)

## 🎯 Flujo de Trabajo Recomendado

1. **Planificar**: Definir contratos en `GLOSARIO_MAESTRO.md`
2. **Implementar**: Crear types en `@autamedica/types`
3. **Validar**: `pnpm docs:validate`
4. **Desarrollar**: Usar types en packages/apps
5. **Testing**: Escribir tests con Vitest
6. **Quality**: `pnpm lint && pnpm type-check`
7. **Build**: `pnpm build`
8. **Deploy**: Vercel automático en merge

## 📚 Referencias Clave

- **Contratos**: `docs/GLOSARIO_MAESTRO.md`
- **Deployment**: `docs/VERCEL_DEPLOYMENT.md`
- **Package.json**: Scripts y dependencias root
- **Turbo.json**: Task definitions y cache config
- **ESLint config**: `eslint.config.mjs` (strict rules)

## 🤝 Principios del Proyecto

1. **Contract-First**: Types definidos antes que implementación
2. **Zero Circular Dependencies**: Arquitectura unidireccional
3. **Export Validation**: Solo exports documentados
4. **Environment Safety**: Variables validadas centralmente
5. **Quality Gates**: CI/CD estricto sin warnings
6. **Performance**: Cache distribuido y builds paralelos

---

**Nota para Claude**: Este proyecto prioriza calidad sobre velocidad. Siempre validar contratos, ejecutar tests, y mantener architecture clean.
