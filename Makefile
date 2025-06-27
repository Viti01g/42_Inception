COMPOSEPATH 		= ./srcs/compose.yaml
MYSQL_NAME 		= mysql
WEBSERVER_NAME 		= webserver
MYSQL_VOLUME		= ${MYSQL_NAME}
WEBSERVER_VOLUME	= ${WEBSERVER_NAME}
DATA_PATH		= /home/${USER}
DATA_DIR		= ${DATA_PATH}/data/
MYSQL_DIR		= ${addprefix ${DATA_DIR}, ${MYSQL_NAME}}
WEBSERVER_DIR		= ${addprefix ${DATA_DIR}, ${WEBSERVER_NAME}}


all:	${DATA_DIR} ${MYSQL_DIR} ${WEBSERVER_DIR}
	docker compose -f  ${COMPOSEPATH} up -d

${MYSQL_DIR}: ${DATA_DIR}
	mkdir -p ${MYSQL_DIR}

${WEBSERVER_DIR}: ${DATA_DIR}
	mkdir -p ${WEBSERVER_DIR}

${DATA_DIR}:
	mkdir -p ${DATA_DIR}

down:
	docker compose -f  ${COMPOSEPATH} down

fclean:
	docker stop $$(docker ps -qa)
	docker rm $$(docker ps -qa)
	docker rmi -f $$(docker images -qa)
	docker volume rm $$(docker volume ls -q)
	docker network rm $$(docker network ls -q) 2>/dev/null

clean:
	docker image prune -a -f

rmdata:
	rm -rf ${MYSQL_DIR}
	rm -rf ${WEBSERVER_DIR}

ps:
	docker compose -f ${COMPOSEPATH} ps

logs:
	docker compose -f ${COMPOSEPATH} logs -f

re: down clean all

.PHONY: all clean fclean re
