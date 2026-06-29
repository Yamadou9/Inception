COMPOSE_FILE	= srcs/docker-compose.yml
ENV_FILE		= srcs/.env
DATA_DIR		= /home/$(shell whoami)/data

all:
	mkdir -p $(DATA_DIR)/wordpress_data
	mkdir -p $(DATA_DIR)/mariadb_data
	docker compose -f $(COMPOSE_FILE) --env-file $(ENV_FILE) up -d --build

down:
	docker compose -f $(COMPOSE_FILE) --env-file $(ENV_FILE) down

stop:
	docker compose -f $(COMPOSE_FILE) --env-file $(ENV_FILE) stop

start:
	docker compose -f $(COMPOSE_FILE) --env-file $(ENV_FILE) start

clean:
	docker compose -f $(COMPOSE_FILE) --env-file $(ENV_FILE) down --rmi all

fclean: clean
	docker volume rm $(shell docker volume ls -q) 2>/dev/null || true
	sudo rm -rf $(DATA_DIR)

re: fclean all

logs:
	docker compose -f $(COMPOSE_FILE) --env-file $(ENV_FILE) logs -f

ps:
	docker compose -f $(COMPOSE_FILE) --env-file $(ENV_FILE) ps

.PHONY: all down stop start clean fclean re logs ps