init:
	sudo docker-compose up -d

start:
	sudo docker-compose start

stop:
	sudo docker-compose stop

log:
	sudo docker-compose logs -f

clean: stop
	docker rm `docker ps -a | grep osixia | awk '{print $$1}'` && docker rmi `docker images | grep osixia | awk '{print $$3}'`

add-users:
	ldapadd -x -W -H ldap://localhost:389  -D "cn=admin,dc=mlstr,dc=org"  -f ./users.ldif
