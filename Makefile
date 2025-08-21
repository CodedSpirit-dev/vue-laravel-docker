up:
	docker compose up -d --build

down:
	docker compose down

bash:
	docker exec -it app bash

node-bash:
	docker exec -it node sh

key:
	docker exec -it app php artisan key:generate

migrate:
	docker exec -it app php artisan migrate

seed:
	docker exec -it app php artisan db:seed

opt:
	docker exec -it app php artisan optimize:clear
