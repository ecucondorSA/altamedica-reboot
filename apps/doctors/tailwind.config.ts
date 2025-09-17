import type { Config } from 'tailwindcss';
import autamedicaPreset from '@autamedica/tailwind-config';

const config: Config = {
  content: [
    './src/pages/**/*.{js,ts,jsx,tsx,mdx}',
    './src/components/**/*.{js,ts,jsx,tsx,mdx}',
    './src/app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  presets: [autamedicaPreset],
};

export default config;