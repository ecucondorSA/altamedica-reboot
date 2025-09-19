/**
 * Página de login simplificada para testing
 */

export default function LoginPage() {
  return (
    <div className="min-h-screen bg-gray-900 flex items-center justify-center">
      <div className="bg-white p-8 rounded-lg shadow-md">
        <h1 className="text-2xl font-bold mb-4">AutaMedica Login</h1>
        <p>Página de login simplificada para probar route handlers</p>
        <div className="mt-4">
          <a 
            href="/auth/callback?returnTo=https://doctors.com&portal=doctors" 
            className="bg-blue-500 text-white px-4 py-2 rounded"
          >
            Probar Callback con Parámetros
          </a>
        </div>
        <div className="mt-2">
          <a 
            href="/api/ping" 
            className="bg-green-500 text-white px-4 py-2 rounded"
          >
            Probar API Ping
          </a>
        </div>
      </div>
    </div>
  );
}