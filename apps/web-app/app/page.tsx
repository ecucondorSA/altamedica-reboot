"use client";

import { AuthProvider, useAuth } from "@autamedica/auth";
import { usePatients } from "@autamedica/hooks";
import { validateEmail } from "@autamedica/shared";
import styles from "./page.module.css";

function PatientsList() {
  const { patients, loading } = usePatients();
  const { user } = useAuth();

  if (loading) return <div>Cargando pacientes...</div>;

  return (
    <div>
      <h2>Sistema Autamedica</h2>
      <p>Usuario: {user?.email || "No autenticado"}</p>
      <p>Pacientes: {patients.length}</p>
      <p>Email válido: {validateEmail("test@autamedica.com") ? "✓" : "✗"}</p>
    </div>
  );
}

export default function Home() {
  return (
    <AuthProvider>
      <div className={styles.page}>
        <main className={styles.main}>
          <h1>🏥 Autamedica - Monorepo Limpio</h1>
          <PatientsList />

          <div className={styles.ctas}>
            <p>✅ Fase 1: Monorepo foundation - COMPLETADA</p>
            <p>✅ Fase 2: Contratos y glosario - COMPLETADA</p>
            <p>🚧 Siguientes fases: Paquetes core, Apps, CI/CD</p>
          </div>
        </main>
      </div>
    </AuthProvider>
  );
}
