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
sudo docker run -d --name astrondb \
             -p 3306:3306 \
             -v /tmp/mariadb:/var/lib/mysql \
             -e ROOT_PASSWORD="root" \
             -e DB_NAME="astrondb" \
             -e DB_USER="astron" \
             -e DB_PASSWORD="astron" \
             -ti dtanakax/mariadb

docker run --name astrondb -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mariadb:tag
docker run --name astrondb -e MYSQL_ROOT_PASSWORD=mariadb -p 3306:3306 -d mariadb:10.1.16

```sql
> mysql -u root -proot
grant all privileges on astrondb.* to astron@localhost identified by 'astron';
grant all privileges on astrondb.* to astron@'%' identified by 'astron';
select user, host, password from mysql.user;
quit
mysql -u astron -pastron
create database astrondb;
show databases;
```

```
* 컨테이너 진입
```
$ docker exec -ti <name> bash
$ docker exec -ti <name> /bin/bash
```

* Util 인스툴
```
// ps
$ apt-get update && apt-get install procps
```

* 스키마 대소문자 구분없이 (for Docker) 
```
cd /etc/mysql

```


# 참고사이트
- [dtanakax/docker-mariadb](https://github.com/dtanakax/docker-mariadb)

# 대소문자 구분 없이 가능하도록 
- [MySQLにおけるテーブル名の大文字／小文字区別について](https://wd3ie.hatenadiary.org/entry/20110309/1299647373)
- [MariaDBで大文字・小文字の区別をしているか確認する](http://osprey-jp.hatenablog.com/entry/2017/06/02/092419)
