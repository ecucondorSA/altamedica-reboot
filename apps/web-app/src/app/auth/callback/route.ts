/**
 * Route Handler para callback de autenticación - Versión simplificada
 */

export const runtime = 'nodejs';

import { NextRequest, NextResponse } from "next/server";

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);
    const code = searchParams.get("code");
    const returnTo = searchParams.get("returnTo");
    const portal = searchParams.get("portal");
    const error = searchParams.get("error");

    // Manejar errores de autenticación
    if (error) {
      console.error("Auth callback error:", error);
      const loginUrl = new URL("/auth/login", request.url);
      loginUrl.searchParams.set("error", "Error de autenticación");
      if (portal) loginUrl.searchParams.set("portal", portal);
      if (returnTo) loginUrl.searchParams.set("returnTo", returnTo);
      return NextResponse.redirect(loginUrl);
    }

    if (code) {
      // Por ahora, redirigir directamente para probar que el handler funciona
      const targetUrl = returnTo || "/";
      console.log("Callback con código, redirigiendo a:", targetUrl);
      return NextResponse.redirect(targetUrl);
    } else {
      // Sin código, redirigir al login
      const loginUrl = new URL("/auth/login", request.url);
      loginUrl.searchParams.set("error", "Sin código de autorización");
      if (portal) loginUrl.searchParams.set("portal", portal);
      if (returnTo) loginUrl.searchParams.set("returnTo", returnTo);
      return NextResponse.redirect(loginUrl);
    }

  } catch (error) {
    console.error("Error en callback:", error);
    return NextResponse.redirect(new URL("/auth/login", request.url));
  }
}