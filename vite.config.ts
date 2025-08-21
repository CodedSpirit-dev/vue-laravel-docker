import { defineConfig } from 'vite';
import vue from '@vitejs/plugin-vue';
import laravel from 'laravel-vite-plugin';
import tailwindcss from '@tailwindcss/vite';
import Components from 'unplugin-vue-components/vite';
import { PrimeVueResolver } from '@primevue/auto-import-resolver';

export default defineConfig({
    plugins: [
        laravel({
            input: ['resources/js/app.ts'],
            ssr: 'resources/js/ssr.ts',
            refresh: true,
            hotFile: 'public/hot',
        }),
        vue({
            template: { transformAssetUrls: { base: null, includeAbsolute: false } },
        }),
        tailwindcss(),
        Components({
            resolvers: [PrimeVueResolver()],
        }),
    ],
    server: {
        host: '0.0.0.0',
        port: 5173,
        hmr: { host: 'localhost' },
    },
});
