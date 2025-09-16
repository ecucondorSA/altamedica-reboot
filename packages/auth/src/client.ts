/**
 * Cliente Supabase para browser
 *
 * Este módulo provee un cliente Supabase configurado para uso en el browser
 * con autenticación automática y manejo de sesiones.
 */

"use client";

import { createBrowserClient as createSupabaseBrowserClient } from "@supabase/ssr";
import { ensureClientEnv } from "@autamedica/shared";

export function createBrowserClient() {
  return createSupabaseBrowserClient(
    ensureClientEnv("NEXT_PUBLIC_SUPABASE_URL"),
    ensureClientEnv("NEXT_PUBLIC_SUPABASE_ANON_KEY")
  );
}