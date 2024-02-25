.PHONY: build
build:
	docker compose build

.PHONY: run
run: keys/ssh_key
	docker compose up --build --force-recreate

keys/ssh_key: keys
	ssh-keygen -q -N "" -t rsa -f keys/ssh_key

keys:
	mkdir -p keys
