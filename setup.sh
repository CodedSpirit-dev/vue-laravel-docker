#!/bin/bash

# Laravel Setup Script
echo "Setting up Laravel application..."

# Stop existing containers
docker-compose down

# Remove old volumes to ensure clean state
docker volume rm $(docker volume ls -q | grep node_modules) 2>/dev/null || true

# Set proper permissions on host
sudo chown -R $USER:$USER .
chmod -R 755 .

# Create necessary directories
mkdir -p storage/logs storage/framework/cache storage/framework/sessions storage/framework/views
mkdir -p bootstrap/cache
mkdir -p public

# Build and start containers
docker-compose build --no-cache
docker-compose up -d

# Wait for containers to be ready
echo "Waiting for containers to start..."
sleep 10

# Install PHP dependencies
docker-compose exec app composer install

# Generate application key if not exists
docker-compose exec app php artisan key:generate

# Run migrations
docker-compose exec app php artisan migrate --force

# Install Node dependencies
docker-compose exec node pnpm install

# Install Inertia.js dependencies
docker-compose exec node pnpm add @inertiajs/core @inertiajs/vue3

# Clear caches
docker-compose exec app php artisan config:clear
docker-compose exec app php artisan cache:clear
docker-compose exec app php artisan route:clear
docker-compose exec app php artisan view:clear

echo "Setup complete! Visit http://localhost:8000"