/** @type {import('next').NextConfig} */
const nextConfig = {
  transpilePackages: [
    "@autamedica/types",
    "@autamedica/shared",
    "@autamedica/auth",
    "@autamedica/hooks"
  ],
  experimental: {
    // Enable turbopack for faster builds
    turbo: {
      rules: {
        '*.svg': {
          loaders: ['@svgr/webpack'],
          as: '*.js'
        }
      }
    }
  }
};

export default nextConfig;