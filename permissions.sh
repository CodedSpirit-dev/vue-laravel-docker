#!/bin/bash

echo "🔐 Setting up permissions after Docker build..."

# Wait a bit for containers to fully start
sleep 5

echo "📁 Creating Laravel directories..."
docker-compose exec app mkdir -p storage/logs
docker-compose exec app mkdir -p storage/framework/cache  
docker-compose exec app mkdir -p storage/framework/sessions
docker-compose exec app mkdir -p storage/framework/views
docker-compose exec app mkdir -p bootstrap/cache

echo "🔓 Setting permissions..."
docker-compose exec app chmod -R 777 storage
docker-compose exec app chmod -R 777 bootstrap/cache

echo "📝 Creating .env file..."
docker-compose exec -T app sh -c 'if [ ! -f .env ]; then
  cat > .env <<EOF
APP_NAME=Laravel
APP_ENV=local
APP_KEY=
APP_DEBUG=true
APP_URL=http://localhost:8000

LOG_CHANNEL=stack
LOG_DEPRECATIONS_CHANNEL=null
LOG_LEVEL=debug

DB_CONNECTION=pgsql
DB_HOST=db
DB_PORT=5432
DB_DATABASE=laravel
DB_USERNAME=laravel
DB_PASSWORD=secret
CACHE_DRIVER=database

CACHE_DRIVER=file
QUEUE_CONNECTION=sync
SESSION_DRIVER=file
SESSION_LIFETIME=120

MAIL_MAILER=smtp
MAIL_HOST=mailpit
MAIL_PORT=1025
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=null
MAIL_FROM_ADDRESS="no-reply@example.com"
MAIL_FROM_NAME="\${APP_NAME}"

VITE_HOST=0.0.0.0
EOF
fi'

docker-compose exec app chmod 664 .env
docker-compose exec app chown www-data:www-data .env
sudo chown $(whoami):$(whoami) .env

docker-compose exec app chmod 664 .env

echo "🚀 Setting up Laravel..."
docker-compose exec app php artisan key:generate --force
docker-compose exec app php artisan migrate --force
docker-compose exec app php artisan config:clear
docker-compose exec app php artisan cache:clear
docker-compose exec app php artisan view:clear

echo "🔑 Fixing Git ownership..."
docker-compose exec app git config --global --add safe.directory /var/www/html

echo "📦 Installing Composer dependencies..."
docker-compose exec app composer install --optimize-autoloader

echo "📦 Setting up Node dependencies..."
docker-compose exec -u root node pnpm install
docker-compose exec -u root node pnpm add @inertiajs/core @inertiajs/vue3

echo "✅ Setup complete!"
echo "🌐 Laravel: http://localhost:8000"
echo "🔥 Vite: http://localhost:5173"

echo ""
echo "📊 Container status:"
docker-compose ps
