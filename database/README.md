# AutaMedica Database Schema

Este directorio contiene el esquema de base de datos y políticas RLS para AutaMedica.

## Archivos

- `schema.sql` - Esquema principal con tablas, políticas RLS y triggers
- `README.md` - Esta documentación

## Configuración de Supabase

### Proyecto de Producción
- **Project ID**: `gtyvdircfhmdjiaelqkg`
- **URL**: `https://gtyvdircfhmdjiaelqkg.supabase.co`
- **Region**: US East

### Tablas Principales

#### `public.profiles`
Tabla principal de perfiles de usuario con control de acceso basado en roles.

**Campos:**
- `id` (UUID) - FK a `auth.users`, clave primaria
- `email` (VARCHAR) - Email del usuario
- `role` (VARCHAR) - Rol del usuario (patient, doctor, company, company_admin, admin, platform_admin)
- `first_name` (VARCHAR) - Nombre
- `last_name` (VARCHAR) - Apellido
- `created_at` (TIMESTAMP) - Fecha de creación
- `updated_at` (TIMESTAMP) - Fecha de última actualización

**Políticas RLS:**
1. **Users can view own profile** - Los usuarios pueden ver su propio perfil
2. **Users can update own profile** - Los usuarios pueden actualizar su propio perfil
3. **Users can insert own profile** - Los usuarios pueden crear su propio perfil
4. **Admins can view all profiles** - Los administradores pueden ver todos los perfiles

### Triggers y Funciones

#### `handle_new_user()`
Función que se ejecuta automáticamente cuando se crea un nuevo usuario en `auth.users`.
Crea el perfil correspondiente en `public.profiles` con el rol especificado en los metadatos.

#### `update_updated_at_column()`
Función que actualiza automáticamente el campo `updated_at` cuando se modifica un registro.

### Roles de Usuario

1. **patient** - Pacientes del sistema
2. **doctor** - Médicos profesionales  
3. **company_admin** - Administradores de empresas
4. **admin** - Administradores generales
5. **platform_admin** - Administradores de plataforma

**Roles removidos**: `company` (sustituido por `company_admin` para mayor claridad)

### Redirecciones por Rol

Después de la autenticación, los usuarios son redirigidos según su rol:

- **patient** → `https://patients.autamedica.com/` (dev: `https://autamedica-patients.pages.dev/`)
- **doctor** → `https://doctors.autamedica.com/` (dev: `https://autamedica-doctors.pages.dev/`)
- **company_admin** → `https://companies.autamedica.com/` (dev: `https://autamedica-companies.pages.dev/`)
- **admin/platform_admin** → `/admin` (en web-app)

**Nota**: El rol `company` fue removido para evitar inconsistencias. Solo se usa `company_admin`.

## Aplicar Schema

Para aplicar el schema a un proyecto Supabase:

```bash
# Conectar al proyecto
supabase link --project-ref gtyvdircfhmdjiaelqkg

# Aplicar migraciones
supabase db push

# O aplicar directamente
psql -h db.gtyvdircfhmdjiaelqkg.supabase.co -U postgres -d postgres -f database/schema.sql
```

## Backup y Versionado

Este esquema debe mantenerse sincronizado con el estado de producción:

```bash
# Exportar schema actual
supabase db dump --linked -f database/schema_backup.sql

# Comparar diferencias
diff database/schema.sql database/schema_backup.sql
```

## Seguridad

- **RLS habilitado** en todas las tablas sensibles
- **Políticas restrictivas** por defecto con protección contra auto-promoción de roles
- **Validación segura de roles** en registro (solo permite patient, doctor, company_admin)
- **Triggers de auditoría** para cambios importantes
- **Principio de menor privilegio** en permisos (SELECT, INSERT, UPDATE únicamente)
- **Protección WITH CHECK** contra elevación de privilegios no autorizada

### Vulnerabilidades Corregidas

1. **Auto-promoción de roles**: Los usuarios no pueden cambiar su propio rol a admin
2. **Roles inseguros en registro**: Solo roles seguros permitidos en auto-registro
3. **Permisos excesivos**: Eliminado GRANT ALL, solo permisos mínimos necesarios
4. **Inconsistencia de roles**: Removido rol `company` duplicado

## Próximos Pasos

1. Agregar tablas específicas por dominio (appointments, medical_records, etc.)
2. Implementar auditoría completa de cambios
3. Agregar políticas RLS para compartir datos entre roles
4. Configurar backups automáticos