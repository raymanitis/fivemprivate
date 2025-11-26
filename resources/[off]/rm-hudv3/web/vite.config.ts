import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

export default defineConfig({
  plugins: [react()],
  base: './',
  define: {
    'import.meta.env.VITE_SPEED_UNIT': JSON.stringify(process.env.VITE_SPEED_UNIT || 'kph')
  },
  build: {
    outDir: 'build',
    chunkSizeWarningLimit: 2000,
  },
});
