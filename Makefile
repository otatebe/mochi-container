login:
	docker exec -u mochi -w /home/mochi/workspace -it mochi-c1 bash

build: env
	docker compose build c1

up: env
	docker compose up -d

down:
	docker compose down

env:
	echo HOST_UID=$(shell id -u) > .env

.PHONY: login build up down env
