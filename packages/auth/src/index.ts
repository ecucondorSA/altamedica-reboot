/**
 * @autamedica/auth - Package de autenticación para Autamedica
 *
 * Este package provee toda la funcionalidad de autenticación con Supabase
 * incluyendo clientes, sesiones, y autenticación por email.
 */

// Clientes Supabase
export { createBrowserClient } from "./client";
export {
  createServerClient,
  createMiddlewareClient,
  createRouteHandlerClient,
} from "./server";

// Manejo de sesiones
export {
  getSession,
  requireSession,
  requirePortalAccess,
  signOut,
  getCurrentUser,
  hasRole,
  hasPortalAccess,
} from "./session";

// Autenticación por email (Magic Links)
export {
  signInWithOtp,
  validateEmailForSignIn,
  getPortalRedirectUrl,
} from "./email";
export type { SignInWithOtpOptions, SignInWithOtpResult } from "./email";

// Contexto y hooks React (TODO: implementar)
// export { AuthProvider, useAuth } from "./react";

// Tipos de autenticación (TODO: implementar)
// export type { AuthState, AuthUser } from "./types";