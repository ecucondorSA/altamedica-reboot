import Link from 'next/link';

export default function TermsPage() {
  return (
    <div className="min-h-screen bg-gray-50 py-12">
      <div className="max-w-4xl mx-auto px-6">
        <div className="text-center mb-8">
          <Link href="/" className="text-2xl font-bold text-gray-900 hover:text-green-600 transition-colors">
            AltaMedica
          </Link>
        </div>

        <div className="bg-white rounded-lg shadow-sm border p-8">
          <h1 className="text-3xl font-bold text-gray-900 mb-8">Términos de Servicio</h1>

          <div className="prose prose-gray max-w-none">
            <p className="text-gray-600 mb-6">
              Última actualización: {new Date().toLocaleDateString('es-ES')}
            </p>

            <section className="mb-8">
              <h2 className="text-xl font-semibold text-gray-900 mb-4">1. Aceptación de Términos</h2>
              <p className="text-gray-700 leading-relaxed">
                Al acceder y utilizar AltaMedica, aceptas estar legalmente vinculado por estos términos de servicio.
                Si no estás de acuerdo con alguno de estos términos, no debes usar nuestros servicios.
              </p>
            </section>

            <section className="mb-8">
              <h2 className="text-xl font-semibold text-gray-900 mb-4">2. Descripción del Servicio</h2>
              <p className="text-gray-700 leading-relaxed">
                AltaMedica es una plataforma de telemedicina que conecta pacientes con profesionales de la salud
                a través de tecnología digital segura y conforme con HIPAA.
              </p>
            </section>

            <section className="mb-8">
              <h2 className="text-xl font-semibold text-gray-900 mb-4">3. Privacidad y Protección de Datos</h2>
              <p className="text-gray-700 leading-relaxed">
                Tu privacidad es fundamental. Cumplimos con todas las regulaciones HIPAA y utilizamos encriptación
                de extremo a extremo para proteger tu información médica personal.
              </p>
            </section>

            <section className="mb-8">
              <h2 className="text-xl font-semibold text-gray-900 mb-4">4. Responsabilidades del Usuario</h2>
              <ul className="list-disc list-inside text-gray-700 space-y-2">
                <li>Proporcionar información precisa y actualizada</li>
                <li>Mantener la confidencialidad de tus credenciales de acceso</li>
                <li>Usar el servicio solo para fines médicos legítimos</li>
                <li>No compartir información médica de otros usuarios</li>
              </ul>
            </section>

            <section className="mb-8">
              <h2 className="text-xl font-semibold text-gray-900 mb-4">5. Limitación de Responsabilidad</h2>
              <p className="text-gray-700 leading-relaxed">
                AltaMedica facilita la comunicación entre pacientes y profesionales de la salud, pero no reemplaza
                el juicio clínico profesional ni asume responsabilidad por decisiones médicas tomadas por los usuarios.
              </p>
            </section>

            <section className="mb-8">
              <h2 className="text-xl font-semibold text-gray-900 mb-4">6. Emergencias Médicas</h2>
              <div className="bg-red-50 border-l-4 border-red-400 p-4 rounded">
                <p className="text-red-700 font-medium">
                  ⚠️ IMPORTANTE: En caso de emergencia médica, contacta inmediatamente a los servicios de emergencia
                  locales (911 o tu número de emergencia local). AltaMedica no debe usarse para emergencias médicas.
                </p>
              </div>
            </section>

            <section className="mb-8">
              <h2 className="text-xl font-semibold text-gray-900 mb-4">7. Modificaciones</h2>
              <p className="text-gray-700 leading-relaxed">
                Nos reservamos el derecho de modificar estos términos. Los cambios significativos serán comunicados
                con al menos 30 días de anticipación.
              </p>
            </section>

            <section className="mb-8">
              <h2 className="text-xl font-semibold text-gray-900 mb-4">8. Contacto</h2>
              <p className="text-gray-700 leading-relaxed">
                Para preguntas sobre estos términos, contáctanos en:
                <br />
                Email: legal@autamedica.com
                <br />
                Desarrollado por E.M Medicina - UBA
              </p>
            </section>
          </div>

          <div className="mt-8 pt-6 border-t border-gray-200">
            <Link
              href="/"
              className="inline-flex items-center text-green-600 hover:text-green-700 font-medium"
            >
              ← Volver al inicio
            </Link>
          </div>
        </div>
      </div>
    </div>
  );
}