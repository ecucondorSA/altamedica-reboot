# Autamedica - Glosario Maestro de Contratos

## 🎯 Objetivo

Este glosario define el **lenguaje común** de Autamedica. Cada tipo exportado debe estar documentado aquí antes de ser implementado.

**Regla de oro**: Solo se exporta lo que está en este glosario.

## 📋 Contratos Core

### Identificadores Únicos

```typescript
export type UUID = string & { readonly brand: "UUID" };
export type PatientId = UUID & { readonly brand: "PatientId" };
export type DoctorId = UUID & { readonly brand: "DoctorId" };
export type AppointmentId = UUID & { readonly brand: "AppointmentId" };
export type FacilityId = UUID & { readonly brand: "FacilityId" };
export type SpecialtyId = UUID & { readonly brand: "SpecialtyId" };
```

### Escalares

```typescript
export type ISODateString = string & { readonly brand: "ISODateString" };
```

### Usuario Base

```typescript
export interface User {
  id: UUID;
  email: string;
  role: "admin" | "staff" | "doctor" | "patient";
  createdAt: ISODateString;
  updatedAt: ISODateString;
}
```

### Paciente

```typescript
export interface Patient {
  id: PatientId;
  firstName: string;
  lastName: string;
  email: string;
  phone?: string;
  dateOfBirth: ISODateString;
  medicalRecordNumber: string;
  emergencyContact?: EmergencyContact;
  createdAt: ISODateString;
  updatedAt: ISODateString;
}

export interface EmergencyContact {
  name: string;
  relationship: string;
  phone: string;
  email?: string;
}
```

### Doctor

```typescript
export interface Doctor {
  id: DoctorId;
  firstName: string;
  lastName: string;
  email: string;
  specialization: string;
  licenseNumber: string;
  isActive: boolean;
  createdAt: ISODateString;
  updatedAt: ISODateString;
}
```

### Cita Médica

```typescript
export interface Appointment {
  id: AppointmentId;
  patientId: PatientId;
  doctorId: DoctorId;
  startTime: ISODateString;
  duration: number; // minutos
  type: "consultation" | "follow-up" | "emergency";
  status: "scheduled" | "in-progress" | "completed" | "cancelled" | "no-show" | "rescheduled";
  notes?: string;
  createdAt: ISODateString;
  updatedAt: ISODateString;
}
```

### Respuestas API

```typescript
export type APIResponse<T = unknown> =
  | { ok: true; data: T; timestamp: ISODateString }
  | { ok: false; error: string; code?: string; timestamp: ISODateString };
```

## 📖 Exports por Package

### @autamedica/types

**Ubicación**: `packages/types/src/index.ts`

```typescript
// Identificadores
export { UUID, PatientId, DoctorId, AppointmentId, FacilityId, SpecialtyId } from "./ids";

// Escalares
export { ISODateString } from "./scalars";

// Entidades core
export { User, Patient, Doctor, Appointment, EmergencyContact } from "./entities";

// API
export type { APIResponse } from "./api";
```

### @autamedica/shared

**Ubicación**: `packages/shared/src/index.ts`

```typescript
// Utilidades de entorno
export {
  ensureEnv,
  ensureClientEnv,
  ensureServerEnv,
  validateEnvironment,
  validateEnvironmentSecurity,
  validateProductionEnvironment
} from "./env";

// Validaciones
export { validateEmail, validatePhone } from "./validators";

// Tipos de entorno
export type { EnvironmentConfig } from "./env";
```

### @autamedica/auth

**Ubicación**: `packages/auth/src/index.ts`

```typescript
// Contexto y hooks React
export { AuthProvider, useAuth } from "./react";

// Tipos de autenticación
export type { AuthState, AuthUser } from "./types";
```

### @autamedica/hooks

**Ubicación**: `packages/hooks/src/index.ts`

```typescript
// Hooks médicos
export { usePatients, useAppointments } from "./medical";

// Hooks de utilidad
export { useAsync, useDebounce } from "./utils";
```

## 🚨 Reglas de Breaking Changes

1. **Cambio de tipo**: Requiere PR + revisión
2. **Eliminación de export**: Requiere deprecation period
3. **Rename de interface**: Requiere alias temporal

## 🌍 Variables de Entorno

### Contratos de Variables (Cliente - NEXT_PUBLIC_*)

Variables que pueden ser expuestas al cliente (bundle JavaScript):

```typescript
// URLs y configuración pública
NEXT_PUBLIC_API_URL: string;              // URL base de la API
NEXT_PUBLIC_APP_URL: string;              // URL base de la aplicación web
NEXT_PUBLIC_VERCEL_URL: string;           // URL de Vercel
NEXT_PUBLIC_DOCTORS_URL: string;          // URL de aplicación médicos
NEXT_PUBLIC_PATIENTS_URL: string;         // URL de aplicación pacientes
NEXT_PUBLIC_COMPANIES_URL: string;        // URL de aplicación empresas

// Supabase (cliente)
NEXT_PUBLIC_SUPABASE_URL: string;         // URL de Supabase
NEXT_PUBLIC_SUPABASE_ANON_KEY: string;    // Clave anónima de Supabase

// Monitoring y errores (cliente)
NEXT_PUBLIC_SENTRY_DSN: string;           // Sentry DSN para errores cliente

// reCAPTCHA (cliente)
NEXT_PUBLIC_RECAPTCHA_SITE_KEY: string;           // reCAPTCHA site key web
NEXT_PUBLIC_RECAPTCHA_SITE_KEY_WEB: string;       // reCAPTCHA site key web
NEXT_PUBLIC_RECAPTCHA_SITE_KEY_IOS?: string;      // reCAPTCHA site key iOS
NEXT_PUBLIC_RECAPTCHA_SITE_KEY_ANDROID?: string;  // reCAPTCHA site key Android

// Maps y geolocalización (cliente)
NEXT_PUBLIC_GOOGLE_MAPS_API_KEY: string;  // Google Maps API key
NEXT_PUBLIC_MAPBOX_ACCESS_TOKEN?: string; // Mapbox access token

// WebRTC y telemedicina (cliente)
NEXT_PUBLIC_ICE_SERVERS: string;          // Servidores ICE (JSON string)
NEXT_PUBLIC_STUN_SERVER: string;          // Servidor STUN
NEXT_PUBLIC_WEBRTC_SIGNALING_URL: string; // URL de señalización WebRTC
NEXT_PUBLIC_MEDIASOUP_URL: string;        // URL de MediaSoup

// IA (cliente) - ⚠️ CUIDADO: Evaluar si es necesario exponer
NEXT_PUBLIC_OPENAI_API_KEY?: string;      // OpenAI API key (⚠️ SENSIBLE)

// Feature flags (cliente)
NEXT_PUBLIC_AI_PREDICTOR_ENABLED: string;              // AI predictor
NEXT_PUBLIC_PATIENT_CRYSTAL_BALL_ENABLED: string;     // Crystal ball
NEXT_PUBLIC_DIGITAL_PRESCRIPTION_ENABLED: string;     // Recetas digitales
NEXT_PUBLIC_AI_ASSISTANT_ENABLED: string;             // Asistente IA
NEXT_PUBLIC_MARKETPLACE_ENABLED: string;              // Marketplace
NEXT_PUBLIC_HOSPITAL_REDISTRIBUTION_ENABLED: string;  // Redistribución
NEXT_PUBLIC_WHATSAPP_BUSINESS_ENABLED: string;        // WhatsApp Business
NEXT_PUBLIC_IOT_SENSORS_ENABLED: string;              // Sensores IoT
NEXT_PUBLIC_HOSPITAL_API_ENABLED: string;             // API hospitales
NEXT_PUBLIC_ADMIN_PANEL_ENABLED: string;              // Panel admin
NEXT_PUBLIC_PROMETHEUS_ENABLED: string;               // Prometheus
NEXT_PUBLIC_HIPAA_AUDIT_ENABLED: string;              // Auditoría HIPAA
NEXT_PUBLIC_DATABASE_ADMIN_ENABLED: string;           // Admin DB
NEXT_PUBLIC_AUDIT_LOGS_ENABLED: string;               // Logs auditoría
```

### Contratos de Variables (Servidor - Server-only)

Variables que solo pueden ser usadas en server actions/API routes:

```typescript
// JWT y autenticación (servidor)
JWT_SECRET: string;                    // Secreto para firmar JWT tokens
JWT_REFRESH_SECRET: string;            // Secreto para refresh tokens
ENCRYPTION_KEY: string;                // Clave maestra de encriptación
SESSION_SECRET: string;                // Secreto para sesiones
NEXTAUTH_SECRET: string;               // NextAuth.js secret

// Supabase (servidor)
SUPABASE_SERVICE_ROLE_KEY: string;     // Service role key de Supabase
DATABASE_URL: string;                  // URL completa de PostgreSQL

// Cache y Redis (servidor)
REDIS_URL: string;                     // URL de Upstash Redis
UPSTASH_REDIS_REST_URL: string;        // URL REST de Upstash
UPSTASH_REDIS_REST_TOKEN: string;      // Token REST de Upstash

// Monitoring (servidor)
SENTRY_ORG: string;                    // Organización Sentry
SENTRY_PROJECT: string;                // Proyecto Sentry
SENTRY_AUTH_TOKEN: string;             // Token auth Sentry

// Pagos MercadoPago (servidor)
MERCADOPAGO_ACCESS_TOKEN: string;      // Access token producción
MERCADOPAGO_WEBHOOK_SECRET: string;    // Secret para webhooks
MERCADOPAGO_TEST_ACCESS_TOKEN?: string; // Access token test

// IA y servicios externos (servidor)
OPENAI_API_KEY: string;                // OpenAI API key
ANTHROPIC_API_KEY: string;             // Anthropic Claude API key

// WebRTC y telemedicina (servidor)
TURN_USERNAME: string;                 // Usuario TURN server
TURN_PASSWORD: string;                 // Password TURN server
TURN_SECRET: string;                   // Secret TURN server
TURN_REALM: string;                    // Realm TURN server

// Email y comunicaciones (servidor)
SMTP_HOST: string;                     // Host SMTP
SMTP_PORT: string;                     // Puerto SMTP
SMTP_USER: string;                     // Usuario SMTP
SMTP_PASS: string;                     // Contraseña SMTP
WHATSAPP_BUSINESS_TOKEN?: string;      // Token WhatsApp Business
WHATSAPP_PHONE_NUMBER_ID?: string;     // ID número WhatsApp
WHATSAPP_WEBHOOK_VERIFY_TOKEN?: string; // Token verificación webhook

// reCAPTCHA (servidor)
RECAPTCHA_SECRET_KEY: string;          // reCAPTCHA secret key

// Compliance y auditoría (servidor)
AUDIT_HASH_CHAIN_ENABLED: string;     // Cadena hash auditoría
ENCRYPTION_KEY_ROTATION_DAYS: string; // Días rotación claves
DATA_RETENTION_DAYS: string;          // Días retención datos
AUDIT_LOG_RETENTION_DAYS: string;     // Días retención logs

// URLs internas (servidor)
DOMAIN: string;                        // Dominio principal
NEXTAUTH_URL: string;                  // URL NextAuth
ALLOWED_ORIGINS: string;               // Origins CORS permitidos
MERCADOPAGO_WEBHOOK_URL: string;       // URL webhook MercadoPago

// Configuración sistema (servidor)
NODE_ENV: string;                      // Entorno (production/development)
PORT?: string;                         // Puerto aplicación
LOG_LEVEL: string;                     // Nivel de logs
LOG_FORMAT: string;                    // Formato logs
```

### Validación de Variables

**Ubicación**: `packages/shared/src/env.ts`

```typescript
// Cliente - variables públicas accesibles en browser
export function ensureClientEnv(name: string): string;

// Servidor - variables privadas solo en server-side
export function ensureServerEnv(name: string): string;

// Genérica - para compatibilidad hacia atrás
export function ensureEnv(name: string): string;

// Validación de configuración completa
export function validateEnvironment(): EnvironmentConfig;
```

## ✅ Validación Automática

Script en `scripts/validate-exports.mjs` verifica que:
- Todo export tiene documentación en este glosario
- No hay exports no documentados
- Versiones semánticas son respetadas