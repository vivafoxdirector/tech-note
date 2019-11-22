# MariaDB

# MariaDB생성
* 도커생성
```shell
> Usage
docker run -d --name <name> \
             -p 3306:3306 \
             -v /tmp/mariadb:/var/lib/mysql \
             -e ROOT_PASSWORD="password" \
             -e DB_NAME="demodb" \
             -e DB_USER="demo" \
             -e DB_PASSWORD="demopassword" \
             -ti dtanakax/mariadb

> 
docker run -d --name astrondb \
             -p 3306:3306 \
             -v /tmp/mariadb:/var/lib/mysql \
             -e ROOT_PASSWORD="root" \
             -e DB_NAME="astrondb" \
             -e DB_USER="astron" \
             -e DB_PASSWORD="astron" \
             -ti dtanakax/mariadb

```
* 컨테이너 진입
```
$ docker exec -ti <name> bash
$ docker exec -ti <name> /bin/bash
```


# 참고사이트
- [dtanakax/docker-mariadb](https://github.com/dtanakax/docker-mariadb)