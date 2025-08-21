import vue from '@vitejs/plugin-vue';
import laravel from 'laravel-vite-plugin';
import tailwindcss from '@tailwindcss/vite';
import { defineConfig } from 'vite';

export default defineConfig({
    plugins: [
        laravel({
            input: ['resources/js/app.ts'],
            ssr: 'resources/js/ssr.ts',
            refresh: true,
            // The hotFile should be within a gitignored directory.
            // 'public/hot' is fine, but 'storage/vite/hot' is common.
            hotFile: 'public/hot',
        }),
        vue({
            template: {
                transformAssetUrls: {
                    base: null,
                    includeAbsolute: false,
                },
            },
        }),
        // It's a common practice to include tailwindcss as a PostCSS plugin
        // inside the css configuration, but this way works too.
        tailwindcss(),
    ],
    server: {
        // Listen on all network interfaces
        host: '0.0.0.0',
        port: 5173,
        hmr: {
            // This is the address the browser will use to connect to the Vite server
            host: 'localhost',
        },
    },
});
