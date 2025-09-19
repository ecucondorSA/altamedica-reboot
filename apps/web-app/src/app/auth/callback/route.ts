/**
 * Static callback route handler for OAuth - Compatible with static export
 */

export const dynamic = 'force-static';

export async function GET() {
  // Return static HTML that handles OAuth callback on client side
  return new Response(`
    <!DOCTYPE html>
    <html>
      <head>
        <title>Autenticando...</title>
        <meta charset="utf-8">
        <style>
          body {
            font-family: -apple-system, BlinkMacSystemFont, sans-serif;
            background: linear-gradient(135deg, #0F172A 0%, #1E293B 50%, #0F172A 100%);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            margin: 0;
          }
          .container {
            text-align: center;
            background: rgba(15, 23, 42, 0.5);
            backdrop-filter: blur(16px);
            border-radius: 16px;
            padding: 2rem;
            border: 1px solid rgba(51, 65, 85, 0.3);
          }
          .spinner {
            border: 2px solid rgba(255, 255, 255, 0.1);
            border-top: 2px solid #10B981;
            border-radius: 50%;
            width: 32px;
            height: 32px;
            animation: spin 1s linear infinite;
            margin: 0 auto 16px;
          }
          @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
          }
          h1 { margin: 0 0 8px; font-size: 1.5rem; }
          p { margin: 0; color: rgba(255, 255, 255, 0.7); }
        </style>
      </head>
      <body>
        <div class="container">
          <div class="spinner"></div>
          <h1>AutaMedica</h1>
          <p>Procesando autenticación...</p>
        </div>
        <script>
          console.log('Static callback - redirecting to client callback');
          window.location.href = '/auth/callback-client' + window.location.search;
        </script>
      </body>
    </html>
  `, {
    headers: {
      'Content-Type': 'text/html',
    },
  });
}