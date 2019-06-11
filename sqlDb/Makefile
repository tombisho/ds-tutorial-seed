init:
	sudo docker-compose up -d

start:
	sudo docker-compose start

stop:
	sudo docker-compose stop

log:
	sudo docker-compose logs -f

add-users:
	cat sql-realm.sql | docker exec -i sqlrealm mysql -usqlrealm -ppassword sqlrealm
