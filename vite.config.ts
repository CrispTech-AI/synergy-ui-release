import { sveltekit } from '@sveltejs/kit/vite';
import { defineConfig } from 'vite';
import { viteStaticCopy } from 'vite-plugin-static-copy';
import path from 'path';
import fs from 'fs';
import os from 'os';

export default defineConfig({
  plugins: [
    sveltekit(),
    viteStaticCopy({
      targets: [
        {
          src: 'node_modules/onnxruntime-web/dist/*.jsep.*',
          dest: 'wasm'
        }
      ]
    })
  ],
  define: {
    APP_VERSION: JSON.stringify(process.env.npm_package_version),
    APP_BUILD_HASH: JSON.stringify(process.env.APP_BUILD_HASH || 'dev-build')
  },
  build: {
    sourcemap: true
  },
  worker: {
    format: 'es'
  },
  resolve: {
    alias: {
      $app: path.resolve('./src/app'),
      $lib: path.resolve('./src/lib'),
      $routes: path.resolve('./src/routes'),
      $components: path.resolve('./src/lib/components'),
      $utils: path.resolve('./src/lib/utils'),
      $stores: path.resolve('./src/lib/stores')
    }
  },
  server: {
    host: true,
    port: 5173,
    fs: {
      strict: false
    },
    https: {
      key: fs.readFileSync(path.resolve(os.homedir(), '.synergy-certs/localhost.key')),
      cert: fs.readFileSync(path.resolve(os.homedir(), '.synergy-certs/localhost.crt'))
    },
    hmr: {
      host: 'localhost',
      port: 5173,
      protocol: 'wss'
    }
  },
  optimizeDeps: {
    exclude: ['svelte-confetti']
  },
  esbuild: {
    pure: process.env.ENV === 'dev' ? [] : ['console.log', 'console.debug', 'console.error']
  }
});
