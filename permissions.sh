#!/bin/bash

echo "🔐 Setting up permissions after Docker build..."

# Wait a bit for containers to fully start
sleep 5

echo "📁 Creating Laravel directories..."
# Create Laravel directories inside the app container
docker-compose exec app mkdir -p storage/logs
docker-compose exec app mkdir -p storage/framework/cache  
docker-compose exec app mkdir -p storage/framework/sessions
docker-compose exec app mkdir -p storage/framework/views
docker-compose exec app mkdir -p bootstrap/cache

echo "🔓 Setting permissions..."
# Set proper permissions (777 for development)
docker-compose exec app chmod -R 777 storage
docker-compose exec app chmod -R 777 bootstrap/cache

echo "🚀 Setting up Laravel..."
# Laravel setup commands
docker-compose exec app php artisan key:generate --force
docker-compose exec app php artisan config:clear
docker-compose exec app php artisan cache:clear
docker-compose exec app php artisan view:clear

# FIX: Add the git safe directory configuration
echo "🔑 Fixing Git ownership..."
docker-compose exec app git config --global --add safe.directory /var/www/html

# Install Composer dependencies if needed
docker-compose exec app composer install --optimize-autoloader

echo "📦 Setting up Node dependencies..."
# FIX: Run pnpm commands as the root user to avoid permission errors
docker-compose exec -u root node pnpm install

# Install Inertia.js if you're using it
docker-compose exec -u root node pnpm add @inertiajs/core @inertiajs/vue3

echo "✅ Setup complete!"
echo "🌐 Laravel: http://localhost:8000"
echo "🔥 Vite: http://localhost:5173"

# Show container status
echo ""
echo "📊 Container status:"
docker-compose ps