FROM node:24-bookworm-slim
WORKDIR /var/www/html

RUN corepack enable && corepack prepare pnpm@9 --activate
SHELL ["/bin/bash","-lc"]
EXPOSE 5173

# Instala si no existe el binario y arranca Vite sin usar "run"
CMD if [[ ! -x node_modules/.bin/vite ]]; then \
    CI=1 pnpm install; \
    fi; \
    pnpm exec vite --host 0.0.0.0 --port 5173
