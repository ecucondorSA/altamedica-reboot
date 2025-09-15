'use client';

import { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';
import { createClient, getRoleRedirectUrl, UserRole } from '@/lib/supabase';

export default function AuthCallbackPage() {
  const router = useRouter();
  const [status, setStatus] = useState('Procesando autenticación...');
  const supabase = createClient();

  useEffect(() => {
    const handleAuthCallback = async () => {
      try {
        // Check if Supabase client is available
        if (!supabase) {
          setStatus('Error de configuración');
          router.push('/auth/login?error=configuration_error');
          return;
        }

        setStatus('Verificando credenciales...');

        // Handle the OAuth callback
        const { data, error } = await supabase.auth.getSession();

        if (error) {
          console.error('Auth callback error:', error);
          setStatus('Error en la autenticación');
          router.push('/auth/login?error=callback_failed');
          return;
        }

        if (!data.session || !data.session.user) {
          console.warn('No session or user found');
          setStatus('Sesión no válida');
          router.push('/auth/login?error=no_session');
          return;
        }

        const user = data.session.user;
        setStatus('Obteniendo perfil de usuario...');

        // Fetch user profile to get role
        const { data: userProfile, error: profileError } = await supabase
          .from('user_profiles')
          .select('role')
          .eq('id', user.id)
          .single();

        if (profileError || !userProfile?.role) {
          console.error('Error fetching user profile:', profileError);
          setStatus('Error obteniendo perfil');
          router.push('/auth/login?error=profile_fetch_failed');
          return;
        }

        const userRole = userProfile.role as UserRole;
        setStatus(`Redirigiendo a portal ${userRole}...`);

        // Redirect based on user role
        const redirectUrl = getRoleRedirectUrl(userRole);

        // Small delay for UX
        await new Promise(resolve => setTimeout(resolve, 1500));

        window.location.href = redirectUrl;

      } catch (error) {
        console.error('Unexpected error in auth callback:', error);
        setStatus('Error inesperado');
        router.push('/auth/login?error=unexpected_error');
      }
    };

    handleAuthCallback();
  }, [router, supabase]);

  return (
    <div className="min-h-screen bg-gradient-to-br from-black via-gray-900 to-black flex items-center justify-center">
      <div className="text-center">
        <div className="w-16 h-16 border-4 border-green-500 border-t-transparent rounded-full animate-spin mx-auto mb-6"></div>

        <h1 className="text-2xl font-bold text-white mb-4">{status}</h1>

        <p className="text-gray-400 mb-8">
          Te redirigiremos a tu portal correspondiente en unos segundos
        </p>

        <div className="bg-gray-800/50 backdrop-blur-lg rounded-xl p-6 border border-gray-700 max-w-md mx-auto">
          <div className="flex items-center justify-center space-x-4 text-sm text-gray-300">
            <div className="flex items-center space-x-2">
              <div className="w-2 h-2 bg-green-500 rounded-full animate-pulse"></div>
              <span>{status}</span>
            </div>
          </div>
        </div>

        <div className="mt-8 text-xs text-gray-500">
          <p>Si no eres redirigido automáticamente,</p>
          <button
            onClick={() => router.push('/')}
            className="text-green-400 hover:text-green-300 underline"
          >
            haz clic aquí para volver al inicio
          </button>
        </div>
      </div>
    </div>
  );
}