import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "AutaMedica - Telemedicina Avanzada",
  description: "Plataforma de telemedicina que conecta pacientes con profesionales de la salud a través de tecnología segura y conforme con HIPAA.",
  keywords: "telemedicina, medicina, salud, consultas online, HIPAA, AutaMedica",
  authors: [{ name: "E.M Medicina - UBA" }],
};

export const viewport = {
  width: 'device-width',
  initialScale: 1,
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="es">
      <body>
        {children}
      </body>
    </html>
  );
}