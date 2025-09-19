'use client';

import { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import { createClient } from '@/lib/supabase';
import { RoleSelectionForm } from './RoleSelectionForm';

/**
 * Página de selección de rol para usuarios después del registro
 * Client-side para compatibilidad con static export
 */
export default function SelectRolePage() {
  const [user, setUser] = useState<any>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const router = useRouter();
  const supabase = createClient();

  useEffect(() => {
    const checkUser = async () => {
      try {
        if (!supabase) {
          setError('Error de configuración');
          setLoading(false);
          return;
        }

        const { data: { user: supabaseUser }, error: userError } = await supabase.auth.getUser();

        if (userError || !supabaseUser) {
          router.push('/auth/login');
          return;
        }

        // Check if user already has a role
        const hasRole = supabaseUser.user_metadata?.role;
        const pendingRoleSelection = supabaseUser.user_metadata?.pendingRoleSelection;

        if (hasRole && !pendingRoleSelection) {
          router.push('/'); // Redirect to home, middleware will handle role redirection
          return;
        }

        setUser(supabaseUser);
        setLoading(false);
      } catch (err) {
        console.error('Error checking user:', err);
        setError('Error al verificar usuario');
        setLoading(false);
      }
    };

    checkUser();
  }, [router, supabase]);

  if (loading) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-autamedica-negro via-autamedica-secondary to-autamedica-negro flex items-center justify-center p-4">
        <div className="bg-autamedica-negro/50 backdrop-blur-lg rounded-2xl p-8 border border-autamedica-secondary/30 text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-autamedica-primary mx-auto mb-4"></div>
          <p className="text-autamedica-blanco">Verificando usuario...</p>
        </div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-autamedica-negro via-autamedica-secondary to-autamedica-negro flex items-center justify-center p-4">
        <div className="bg-autamedica-negro/50 backdrop-blur-lg rounded-2xl p-8 border border-autamedica-secondary/30 text-center">
          <p className="text-red-400 mb-4">{error}</p>
          <button 
            onClick={() => router.push('/auth/login')}
            className="bg-autamedica-primary text-white px-4 py-2 rounded-lg hover:bg-autamedica-primary-dark transition-colors"
          >
            Ir al Login
          </button>
        </div>
      </div>
    );
  }

  if (!user) {
    return null;
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-autamedica-negro via-autamedica-secondary to-autamedica-negro flex items-center justify-center p-4">
      <div className="max-w-lg w-full bg-autamedica-negro/50 backdrop-blur-lg rounded-2xl shadow-xl p-8 border border-autamedica-secondary/30">
        <div className="text-center mb-8">
          <h1 className="text-3xl font-bold text-autamedica-blanco mb-2">
            ¡Bienvenido a AutaMedica!
          </h1>
          <p className="text-autamedica-text-light">
            Para comenzar, por favor selecciona tu rol en la plataforma
          </p>
        </div>

        <RoleSelectionForm user={user} />

        <div className="mt-8 pt-6 border-t border-autamedica-secondary/30">
          <p className="text-sm text-autamedica-text-light text-center">
            ¿Necesitas ayuda?{' '}
            <a href="/support" className="text-autamedica-primary hover:text-white font-medium">
              Contacta soporte
            </a>
          </p>
        </div>
      </div>
    </div>
  );
}