login:
	docker exec -u ${USER} -w /home/${USER}/workspace -it mochi-c1 bash

build:
	docker compose build --build-arg UID=$(shell id -u) c1

up:
	docker compose up -d

down:
	docker compose down
