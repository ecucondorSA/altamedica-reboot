#!/usr/bin/env node

/**
 * Watch TypeScript files for type errors in all packages and apps
 * Ejecuta tsc --noEmit --watch para cada tsconfig.json encontrado
 */

import { spawn } from 'node:child_process';
import { readdirSync, statSync } from 'node:fs';
import { join } from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = fileURLToPath(new URL('.', import.meta.url));

function findTsconfigs(root) {
  const list = [];

  // Buscar en apps/ y packages/
  for (const dir of ['apps', 'packages']) {
    const base = join(root, dir);
    try {
      for (const name of readdirSync(base)) {
        const packagePath = join(base, name);
        try {
          if (statSync(packagePath).isDirectory()) {
            const tsconfig = join(packagePath, 'tsconfig.json');
            try {
              statSync(tsconfig);
              list.push({
                config: tsconfig,
                name: `${dir}/${name}`
              });
            } catch {}
          }
        } catch {}
      }
    } catch {}
  }

  return list;
}

function startWatcher(tsconfig, name) {
  console.log(`🔍 Starting TypeScript watcher for ${name}...`);

  const child = spawn('npx', ['tsc', '--noEmit', '--watch', '-p', tsconfig.config], {
    stdio: 'pipe'
  });

  child.stdout.on('data', (data) => {
    const output = data.toString();
    if (output.trim()) {
      console.log(`[${name}] ${output}`);
    }
  });

  child.stderr.on('data', (data) => {
    const output = data.toString();
    if (output.trim()) {
      console.error(`[${name}] ${output}`);
    }
  });

  child.on('exit', (code) => {
    console.log(`[${name}] TypeScript watcher exited with code ${code}`);
  });

  return child;
}

async function main() {
  console.log('🏥 Autamedica - TypeScript Watch Mode\n');

  const root = join(__dirname, '..');
  const tsconfigs = findTsconfigs(root);

  if (tsconfigs.length === 0) {
    console.log('ℹ️  No se encontraron tsconfig.json en apps/ o packages/');
    console.log('💡 Asegúrate de que existan los archivos tsconfig.json en cada package');
    process.exit(0);
  }

  console.log(`📋 Encontrados ${tsconfigs.length} proyectos TypeScript:`);
  tsconfigs.forEach(({ name }) => {
    console.log(`  - ${name}`);
  });
  console.log('');

  const watchers = [];

  // Iniciar watchers para cada proyecto
  for (const tsconfig of tsconfigs) {
    const watcher = startWatcher(tsconfig, tsconfig.name);
    watchers.push(watcher);
  }

  // Manejar señales para limpiar procesos
  process.on('SIGINT', () => {
    console.log('\n🛑 Deteniendo watchers...');
    watchers.forEach(watcher => {
      watcher.kill('SIGTERM');
    });
    process.exit(0);
  });

  process.on('SIGTERM', () => {
    console.log('\n🛑 Deteniendo watchers...');
    watchers.forEach(watcher => {
      watcher.kill('SIGTERM');
    });
    process.exit(0);
  });

  console.log('✅ TypeScript watchers iniciados');
  console.log('💡 Presiona Ctrl+C para detener');
}

main().catch(error => {
  console.error('Error iniciando TypeScript watchers:', error);
  process.exit(1);
});