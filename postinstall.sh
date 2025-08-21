# 1) Asegura SESSION_DRIVER=file
grep -q '^SESSION_DRIVER=file' .env || echo 'SESSION_DRIVER=file' >> .env

# 2) Crear dirs y fijar dueños/permiso desde el contenedor
docker compose exec -u root app sh -lc '
  mkdir -p storage/framework/{sessions,cache,views} bootstrap/cache &&
  chown -R www-data:www-data storage bootstrap/cache &&
  find storage -type d -exec chmod 775 {} \; &&
  find storage -type f -exec chmod 664 {} \; &&
  chmod -R 775 bootstrap/cache
'

# 3) (Opcional) si sigues con EACCES, limpia sesiones viejas
docker compose exec -u root app sh -lc "rm -f storage/framework/sessions/* || true"
