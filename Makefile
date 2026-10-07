login:
	docker exec -u mochi -w /home/mochi/workspace -it mochi-c1 bash

build:
	docker compose build --build-arg UID=$(shell id -u) c1

up:
	docker compose up -d

down:
	docker compose down
