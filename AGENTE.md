# AGENTE.md - Metodología de Desarrollo para Agentes IA

Esta guía establece la metodología de desarrollo para agentes IA trabajando en el monorepo AltaMedica-Reboot.

## 🎯 **Principio Fundamental: DevAltamedica como Brújula**

**REGLA ORO**: DevAltamedica-Independent (`/home/edu/Devaltamedica-Independent/`) es tu brújula de navegación. Cuando no sepas cómo implementar algo, consulta primero cómo está resuelto ahí.

### 🧭 **Metodología de 3 Pasos**

#### **1. 🔍 EXPLORAR (DevAltamedica como Mapa)**
```bash
# Antes de implementar cualquier funcionalidad nueva:
cd /home/edu/Devaltamedica-Independent
find . -name "*[tema_a_implementar]*" -type f
grep -r "funcionalidad_que_necesito" packages/
ls -la packages/[package_relevante]/src/
```

#### **2. 📝 ANALIZAR (Entender el Por Qué)**
- ¿Por qué DevAltamedica implementó X de esta manera?
- ¿Qué constrains médicos/técnicos/regulatorios influyeron?
- ¿Qué patterns probados usan?
- ¿Qué errores evitan con su implementación?

#### **3. 🏗️ IMPLEMENTAR (Versión Limpia)**
- Tomar la **esencia médica** de DevAltamedica
- Implementar con **arquitectura moderna** en AltaMedica-Reboot
- Preservar **expertise médico** validado
- Limpiar **deuda técnica** identificada

## 🏥 **Arquitectura Médica: Packages Tier 1**

### **⚠️ Packages CRÍTICOS - No Opcionales**

Estos 7 packages son **supervivencia del proyecto**. Sin ellos, no hay producto médico viable:

#### **1. @altamedica/types**
- **Ubicación Mapa**: `/home/edu/Devaltamedica-Independent/packages/interfaces/`
- **Por qué crítico**: 190+ tipos médicos definen el lenguaje común
- **Sin esto**: Meses redefiniendo dominio médico desde cero

#### **2. @altamedica/auth**
- **Ubicación Mapa**: `/home/edu/Devaltamedica-Independent/packages/auth/`
- **Por qué crítico**: Sin autenticación, no hay seguridad HIPAA
- **Sin esto**: No podemos diferenciar roles médicos

#### **3. @altamedica/database**
- **Ubicación Mapa**: `/home/edu/Devaltamedica-Independent/packages/database/`
- **Por qué crítico**: HIPAA compliance + audit trail obligatorios
- **Sin esto**: Violaciones regulatorias desde día 1

#### **4. @altamedica/medical**
- **Ubicación Mapa**: `/home/edu/Devaltamedica-Independent/packages/medical/`
- **Por qué crítico**: Lógica médica validada por profesionales
- **Sin esto**: Errores médicos por cálculos incorrectos

#### **5. @altamedica/telemedicine-core**
- **Ubicación Mapa**: `/home/edu/Devaltamedica-Independent/packages/telemedicine/`
- **Por qué crítico**: Core business - sin videollamadas no hay telemedicina
- **Sin esto**: 6+ meses implementando WebRTC desde cero

#### **6. @altamedica/alta-agent**
- **Ubicación Mapa**: `/home/edu/Devaltamedica-Independent/packages/ai/`
- **Por qué crítico**: Ventaja competitiva única - IA médica 3D
- **Sin esto**: Perdemos diferenciación vs competencia

#### **7. @altamedica/hooks**
- **Ubicación Mapa**: `/home/edu/Devaltamedica-Independent/packages/hooks/`
- **Por qué crítico**: 50+ hooks médicos = 10x velocity desarrollo
- **Sin esto**: Reinventamos la rueda constantemente

## 🚨 **Reglas de Oro para Agentes IA**

### **1. Contract-First Development**
```typescript
// ✅ SIEMPRE - Definir primero en docs/GLOSARIO_MAESTRO.md
export interface Patient {
  id: PatientId;
  createdAt: ISODateString;
}

// ❌ NUNCA - Implementar sin contrato documentado
const patient = { id: "123", date: new Date() };
```

### **2. Zero Technical Debt Policy**
```bash
# ✅ OBLIGATORIO antes de commit
pnpm lint                    # 0 warnings policy
pnpm type-check             # Strict TypeScript
pnpm docs:validate          # Contratos sincronizados
pnpm test                   # Coverage requirements
```

### **3. Import Rules Estrictas**
```typescript
// ✅ PERMITIDO
import { Patient } from "@altamedica/types";
import { ensureEnv } from "@altamedica/shared";

// ❌ PROHIBIDO
import { Patient } from "@altamedica/types/src/entities";
const apiUrl = process.env.API_URL; // Direct process.env
```

### **4. DevAltamedica Navigation Commands**
```bash
# Explorar estructura completa
ls -la /home/edu/Devaltamedica-Independent/packages/

# Buscar implementación específica
grep -r "telemedicine" /home/edu/Devaltamedica-Independent/packages/

# Examinar exports de package
cat /home/edu/Devaltamedica-Independent/packages/auth/package.json

# Ver estructura de archivos
find /home/edu/Devaltamedica-Independent/packages/auth -name "*.ts" -type f
```

## 🔄 **Flujo de Trabajo para Agentes**

### **🎯 Nueva Feature Request**
1. **TodoWrite**: Crear lista de tareas antes de empezar
2. **Consultar Mapa**: ¿Cómo lo hace DevAltamedica?
3. **Documentar Contrato**: Actualizar GLOSARIO_MAESTRO.md
4. **Implementar**: Versión limpia en AltaMedica-Reboot
5. **Validar**: `pnpm health` - health check completo
6. **Completar Todos**: Marcar tareas como completadas

### **🐛 Bug Fix Request**
1. **TodoWrite**: Planificar investigación y fix
2. **Consultar Mapa**: ¿Cómo previene DevAltamedica este bug?
3. **Root Cause**: Identificar causa raíz
4. **Implementar Fix**: Aplicar solución
5. **Prevenir Regresión**: Agregar test si falta
6. **Validar**: Ejecutar suite completa de validaciones

### **📦 Package Migration**
1. **TodoWrite**: Desglosar migración en pasos específicos
2. **Analizar Mapa**: Estudiar package completo en DevAltamedica
3. **Documentar Patterns**: ¿Qué patterns usan y por qué?
4. **Implementar Limpio**: Versión optimizada en AltaMedica-Reboot
5. **Testing**: Verificar funcionalidad completa
6. **Integration**: Integrar con packages existentes

## 🛠 **Comandos Esenciales para Agentes**

### **🚀 Desarrollo**
```bash
pnpm claude                 # Comando principal - inicia sesión completa
pnpm dev                    # Watch mode todos los packages
pnpm build                  # Build completo monorepo
pnpm health                 # Health check completo
```

### **🔍 Validación**
```bash
pnpm lint                   # ESLint strict (--max-warnings=0)
pnpm type-check            # TypeScript validation
pnpm docs:validate         # Contratos vs exports
pnpm pre-deploy            # Validación pre-deployment
```

### **🧪 Testing**
```bash
pnpm test                  # Vitest con coverage
pnpm test:unit            # Unit tests específicos
```

## 📋 **Checklist Pre-Commit para Agentes**

### **✅ Validation Checklist**
- [ ] `pnpm lint` pasa sin warnings
- [ ] `pnpm type-check` pasa completamente
- [ ] `pnpm docs:validate` confirma contratos sincronizados
- [ ] `pnpm build` exitoso para todos los packages
- [ ] Tests escritos para nueva funcionalidad
- [ ] TodoWrite actualizado - tareas completadas marcadas
- [ ] No hay deep imports (`@altamedica/*/src/*`)
- [ ] Variables env via `ensureEnv()` únicamente

### **🏥 Medical Compliance Checklist**
- [ ] Tipos médicos definidos en GLOSARIO_MAESTRO.md
- [ ] Validaciones médicas usando @altamedica/medical
- [ ] Datos PHI manejados según HIPAA
- [ ] Audit trail implementado donde corresponde
- [ ] Formatos médicos consistentes (ISODateString, etc.)

## 🎯 **Patterns Específicos por Área**

### **🔐 Autenticación**
```typescript
// Consultar: /home/edu/Devaltamedica-Independent/packages/auth/
import { requirePortalAccess, getSession } from "@altamedica/auth";

// Pattern: Role-based access control
const session = await requirePortalAccess("medico");

// Pattern: Session management
const user = await requireSession("/auth/login");
```

### **🏥 Lógica Médica**
```typescript
// Consultar: /home/edu/Devaltamedica-Independent/packages/medical/
import { calculateBMI, validateVitalSigns } from "@altamedica/medical";

// Pattern: Medical calculations
const bmi = calculateBMI(weight, height);

// Pattern: Critical value validation
const alerts = validateVitalSigns(vitals);
```

### **📹 Telemedicina**
```typescript
// Consultar: /home/edu/Devaltamedica-Independent/packages/telemedicine/
import { createVideoSession, monitorQoS } from "@altamedica/telemedicine-core";

// Pattern: WebRTC session management
const session = await createVideoSession(config);

// Pattern: Quality monitoring
const metrics = await monitorQoS(sessionId);
```

## 🚫 **Anti-Patterns - NUNCA Hacer**

### **❌ Architectural Anti-Patterns**
1. **Deep imports** de packages internos
2. **Direct process.env** access (usar ensureEnv)
3. **Exports sin documentar** en GLOSARIO_MAESTRO
4. **Date objects** en APIs (usar ISODateString)
5. **Circular dependencies** entre packages

### **❌ Development Anti-Patterns**
1. **Commits con warnings** ESLint
2. **TypeScript errors** ignorados
3. **Tests faltantes** para nueva funcionalidad
4. **Breaking changes** sin actualizar contratos
5. **Implementar sin consultar DevAltamedica primero**

### **❌ Medical Anti-Patterns**
1. **Cálculos médicos** sin validación profesional
2. **Datos PHI** sin encryption
3. **Rangos médicos** hardcoded vs usar @altamedica/medical
4. **Validaciones médicas** faltantes
5. **Audit trail** omitido en cambios críticos

## 🧭 **Navegación DevAltamedica por Casos de Uso**

### **🔍 "¿Cómo implemento autenticación MFA?"**
```bash
cd /home/edu/Devaltamedica-Independent
find packages/auth -name "*mfa*" -o -name "*multi*" -type f
grep -r "multi.*factor" packages/auth/
```

### **🔍 "¿Cómo estructuro componentes médicos?"**
```bash
cd /home/edu/Devaltamedica-Independent
find packages/ui -name "*vital*" -o -name "*patient*" -type f
ls -la packages/ui/src/medical/
```

### **🔍 "¿Cómo manejo estados de videollamada?"**
```bash
cd /home/edu/Devaltamedica-Independent
find packages/telemedicine -name "*state*" -o -name "*session*" -type f
grep -r "VideoCallState" packages/telemedicine/
```

### **🔍 "¿Cómo implemento validaciones médicas?"**
```bash
cd /home/edu/Devaltamedica-Independent
find packages/medical -name "*valid*" -o -name "*check*" -type f
grep -r "validateRange" packages/medical/
```

## 📊 **Métricas de Éxito para Agentes**

### **⚡ Development Velocity**
- **Feature Implementation**: 3x más rápido usando DevAltamedica como mapa
- **Bug Resolution**: 70% reducción usando patterns probados
- **Code Quality**: 0 warnings policy mantenida
- **Test Coverage**: >80% para funcionalidad médica crítica

### **🏥 Medical Quality**
- **HIPAA Compliance**: Day 1 vs 6+ meses desde cero
- **Medical Accuracy**: Validaciones profesionales preservadas
- **Regulatory**: Pre-validado vs proceso nuevo
- **Professional Acceptance**: Patterns familiares para médicos

## 📚 **Referencias Rápidas**

### **🗺️ Mapa DevAltamedica**
- **Ubicación**: `/home/edu/Devaltamedica-Independent/`
- **Packages**: `/home/edu/Devaltamedica-Independent/packages/`
- **Configuración**: `/home/edu/Devaltamedica-Independent/package.json`

### **📖 Documentación Estratégica**
- **CLAUDE.md**: Guía completa para Claude Code
- **DEVALTAMEDICA_GUIDE.md**: Metodología DevAltamedica como mapa
- **DEVELOPMENT_PLAN.md**: Roadmap 7 semanas
- **docs/GLOSARIO_MAESTRO.md**: Contratos centralizados

### **🛠 Scripts Críticos**
- **pnpm claude**: Comando principal desarrollo
- **pnpm health**: Health check completo
- **pnpm docs:validate**: Validar contratos
- **pnpm pre-deploy**: Validación deployment

---

## 💡 **Filosofía para Agentes IA**

**DevAltamedica** = **Años de expertise médico cristalizado en código**
**AltaMedica-Reboot** = **Destino limpio basado en lecciones aprendidas**

Como agente IA, tu rol es ser el **puente inteligente** entre ambos:
- **Preservar** la sabiduría médica de DevAltamedica
- **Modernizar** la implementación en AltaMedica-Reboot
- **Acelerar** el desarrollo usando patterns probados
- **Mantener** calidad médica y compliance

> **"La mejor medicina combina experiencia clínica con tecnología moderna."**

**Tu misión**: Hacer que AltaMedica-Reboot sea la versión 2.0 perfecta de DevAltamedica - manteniendo toda la sabiduría médica, pero con arquitectura limpia y código moderno.

---

**🎯 Recuerda: Cuando tengas dudas, consulta el mapa. DevAltamedica ya resolvió el problema - tu trabajo es implementar la versión mejorada.**