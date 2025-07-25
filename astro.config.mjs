// @ts-check
import { defineConfig } from 'astro/config';
import tailwindcss from '@tailwindcss/vite';
import dotenv from 'dotenv';

dotenv.config();

// https://astro.build/config
export default defineConfig({
  site: process.env.PUBLIC_SITE_URL,
  vite: {
    plugins: [tailwindcss()]
  }
});
