# DOCKER for postgres

## COMMAND
1. postgresql  기동중인지 확인
> sudo docker ps -a
2. DataBase List
> \l

### Docker Image
1. image: postgres:9.6
1. container: postgres96
1. password: s0m2th1ng
sudo docker run -d --name postgres96 -e POSTGRES_PASSWORD=s0m2th1ng -p 15432:5432 postgres:9.6

### Docker Container
1. Start and connect postgres with user name postgres
sudo docker run -it --rm --link postgres96:postgres postgres:9.6 psql -h postgres -U postgres

### User
1. enpharos/enpharos
11. > sudo docker run -it --rm --link postgres96:postgres postgres:9.6 psql -h postgres -U enpharos -d enpharosdb
1. hogehoge/hogehoge
11. > sudo docker run -it --rm --link postgres96:postgres postgres:9.6 psql -h postgres -U hogehoge -d hogedb

### POSTGRESQL

#### Create Database
> create user [username] with password '[password]';
> create database enpharosdb;
> drop database enpharosdb;
> alter database enpharosdb owner to enpharos;

#### Table Schema
> \d+ [TABLE_NAME];

### DataBase
|db name|user|
|:-----:|:----:|
|enpharosdb|enpharos|
|hogedb|hogehoge|


## Troubleshoot
1. error
> docker: Error response from daemon: failed to create endpoint db01 on network bridge: COMMAND_FAILED: '/sbin/iptables -t nat -A DOCKER -p tcp -d 0/0 --dport 3306 -j DNAT --to-destination 172.17.0.2:3306 ! -i docker0' failed: iptables: No chain/target/match by that name..
11. solution
> mv /var/lib/docker/network/files /tmp/docker-iptables-err
> systemctl restart docker

## REF
http://kimulla.hatenablog.com/entry/2017/04/01/235355
http://www.lancard.com/blog/2016/08/16/docker%E5%85%AC%E5%BC%8F%E3%82%A4%E3%83%A1%E3%83%BC%E3%82%B8%E3%81%A7%E9%96%8B%E7%99%BA%E7%94%A8rdb%E3%82%92%E3%82%B2%E3%83%83%E3%83%88%E3%81%A0%E3%81%9Cpostgresql%E7%B7%A8/

=docker run 실행시 iptables 오류
https://qiita.com/miwato/items/9770a2a757d3f5e369a4
=해결방법
# mv /var/lib/docker/network/files /tmp/docker-iptables-err
# systemctl restart docker
