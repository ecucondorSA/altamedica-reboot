import type { Config } from "tailwindcss";
import autamedicaPreset from "@autamedica/tailwind-config";

const config: Config = {
  // Usar el preset compartido de AutaMedica
  presets: [autamedicaPreset],

  // Paths de contenido específicos para patients
  content: [
    "./pages/**/*.{js,jsx,tsx,mdx}",
    "./components/**/*.{js,jsx,tsx,mdx}",
    "./app/**/*.{js,jsx,tsx,mdx}",
    "./src/**/*.{js,jsx,tsx,mdx}",
    // Incluir packages compartidos solo para componentes UI (evitar TypeScript files)
    "../../packages/ui/**/*.{js,jsx,tsx,mdx}",
    "../../packages/components/**/*.{js,jsx,tsx,mdx}",
  ],

  // Extensiones específicas para patients (si las hay)
  theme: {
    extend: {
      // Aquí se pueden agregar personalizaciones específicas de patients
      // que no estén en el preset compartido
    },
  },

  plugins: [],
};

export default config;