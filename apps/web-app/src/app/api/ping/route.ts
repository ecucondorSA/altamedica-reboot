// Plantilla mínima para verificar que los route handlers funcionan
export const runtime = 'nodejs';
export const dynamic = 'force-static';

export async function GET() {
  return Response.json({ ok: true, message: "Route handlers working" });
}