# MySQL Command

# 유저 추가 / 삭제
## 유저 추가
* User: hogehoge
* Pass: hogehoge
* Db: hogedb
```
> mysql -u root -pPassword
mysql> grant all privileges on hogedb.* to hogehoge@localhost identified by 'hogehoge';
mysql> grant all privileges on hogedb.* to hogehoge@'%' identified by 'hogehoge';
mysql> select user, host, password from mysql.user;
```

## 유저 삭제
```
> mysql -u root -pPassword
mysql> revoke all privileges on *.* from hogehoge@localhost;
mysql> delete from mysql.user where user='hogehoge' and host='localhost';
mysql> select user, host, password from mysql.user;
```

# 데이터 베이스 조작
## USER 용 데이터 베이스 만들기
```
> mysql -u hogehoge -phogehoge
mysql> create database hogedb;
mysql> show databases;
```

## 데이터 베이스 삭제
```
mysql> drop database hogedb;
mysql> show databases;
```

## 데이터 베이스 접속
```
mysql> use hogedb;
```

# 테이블 조작
## 테이블 만들기
```
mysql> create table testtbl(num int, name varchar(50));
mysql> show tables;
```

## 테이블 삭제
```
mysql> drop table testtbl;
mysql> show tables;
```

# 데이터 조작
## 데이터 입력
```
mysql> insert into testtbl values(1, 'hogehoge');
mysql> select * from testtbl;
```

## 데이터 업데이트
```
mysql> update testtbl set name='higehige' where num = 1;
mysql> select * from testtbl;
```

## 데이터 삭제
```
mysql> delete from testtbl where num = 1;
mysql> select * from testtbl;
```

## 현재 실행중인 SQL표시
```
mysql> show processlist;
```

## 인덱스 조회
```
mysql> show index from 테이블명;
```

# GRANT 권한
## 권한 추가
```
mysql> GRANT CREATE ON 데이터베이스명.* TO 유저명@localhost;
mysql> GRANT DROP ON 데이터베이스명.* TO 유저명@localhost;
mysql> GRANT ALTER ON 데이터베이스명.* TO 유저명@localhost;
```
## 권한 확인
```
mysql> SHOW GRANTS FOR 유저명@localhost \G
```

## 권한 삭제
```
mysql> REVOKE ALL PRIVILEGES ON *.* FROM 유저명@localhost;
mysql> REVOKE 삭제할권한 ON 대상(데이터베이스명.*) FROM 유저명;
```

# MySQL 트러블 슈팅
## 데이터 베이스 백업
```
#> mysqldump -u [mysql user] -p[user password] [Redmine데이터베이스명] > [백업파일명]
```

## root 패스워드를 잊었을때 1번째
1. MySQL 중지
```
root> /etc/init.d/mysql stop
```

2. 패스워드 없이 로그인 할 수 있도록 MySQL기동
```
root> mysqld_safe --skip-grant-tables &
```

3. MySQL 접속해서 패스워드 변경
```
root> mysql -u root mysql
mysql> update user set password=PASSWORD('pass') where user='root' and host='localhost';
mysql> FLUSH PRIVILEGES;
```

4. MySQL 재기동
```
root> /etc/init.d/mysql restart
```

## root 로 연결이 안되는 경우 2번째
```
> mysql -u root
ERROR 1045~
root> service mysqld stop
root> mysqld_safe --skip-grant-tables &
root> mysql -u root
> use mysql;
> select * from user;
> truncate table user;
> flush privileges;
> grant all privileges on *.* to root@localhost identified by 'password' with grant option;
> flush privileges;
> select host, user from user;
> quit
root> service mysql start
```

## allowed to connect to this MySql server 라는 오류가 나오면
```
mysql> grant all privileges on DBNAME.* to USERNAME@'%' identified by 'PASSWORD'; <-- 해당 유저에 권한을 지정해주어야함.
```