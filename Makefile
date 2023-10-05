login:
	docker compose build --build-arg UID=$(shell id -u) c1
	docker compose up -d
	docker exec -u ${USER} -w /home/${USER}/workspace -it mochi-c1 bash

down:
	docker compose down
