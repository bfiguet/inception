FILE=srcs/docker-compose.yml

DATA=./data

all : build

build :
	sudo mkdir -p $(DATA)/mariadb
	sudo mkdir -p $(DATA)/wordpress
	sudo docker-compose -f $(FILE) build
	sudo docker-compose -f $(FILE) up -d

logs:
	sudo docker logs wordpress
	sudo docker logs mariadb
	sudo docker logs nginx

list:
	sudo docker ps

clean :
	sudo docker-compose -f $(FILE) down

fclean : clean
	sudo rm -rf $(DATA)
	sudo docker system prune -af

re : fclean build

