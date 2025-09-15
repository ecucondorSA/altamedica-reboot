import js from '@eslint/js';
import tseslint from '@typescript-eslint/eslint-plugin';
import tsparser from '@typescript-eslint/parser';

export default [
  js.configs.recommended,
  {
    files: ['**/*.{ts,tsx}'],
    languageOptions: {
      parser: tsparser,
      parserOptions: {
        ecmaVersion: 'latest',
        sourceType: 'module',
        project: true,
      },
    },
    plugins: {
      '@typescript-eslint': tseslint,
    },
    rules: {
      // Prohibir deep imports
      'no-restricted-imports': [
        'error',
        {
          patterns: [
            {
              group: ['@autamedica/*/src/*'],
              message: 'Deep imports are not allowed. Use package main exports instead.',
            },
          ],
        },
      ],
      // Prohibir process.env directo fuera de @autamedica/shared
      'no-restricted-globals': [
        'error',
        {
          name: 'process',
          message: 'Use ensureEnv from @autamedica/shared instead of direct process.env access.',
        },
      ],
      // TypeScript estricto
      '@typescript-eslint/no-unused-vars': ['error', { argsIgnorePattern: '^_' }],
      '@typescript-eslint/no-explicit-any': 'error',
      '@typescript-eslint/no-non-null-assertion': 'error',
      '@typescript-eslint/prefer-nullish-coalescing': 'error',
      '@typescript-eslint/prefer-optional-chain': 'error',
    },
  },
  {
    files: ['packages/shared/**/*.{ts,tsx}'],
    rules: {
      // Permitir process.env solo en @autamedica/shared
      'no-restricted-globals': 'off',
    },
  },
  {
    files: ['**/*.test.{ts,tsx}', '**/*.spec.{ts,tsx}'],
    rules: {
      // Relax algunas reglas en tests
      '@typescript-eslint/no-explicit-any': 'off',
    },
  },
];