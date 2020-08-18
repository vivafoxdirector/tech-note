# MySQL Command

## 유저 추가 / 삭제
### 유저 추가
* User: hogehoge
* Pass: hogehoge
* Db: hogedb
```
> mysql -u root -pPassword
mysql> grant all privileges on hogedb.* to hogehoge@localhost identified by 'hogehoge';
mysql> grant all privileges on hogedb.* to hogehoge@'%' identified by 'hogehoge';
mysql> select user, host, password from mysql.user;
```

### 유저 삭제
```
> mysql -u root -pPassword
mysql> revoke all privileges on *.* from hogehoge@localhost;
mysql> delete from mysql.user where user='hogehoge' and host='localhost';
mysql> select user, host, password from mysql.user;
```

## 데이터 베이스 조작
### USER 용 데이터 베이스 만들기
```
> mysql -u hogehoge -phogehoge
mysql> create database hogedb;
mysql> show databases;
```

### 데이터 베이스 삭제
```
mysql> drop database hogedb;
mysql> show databases;
```

### 데이터 베이스 접속
```
mysql> use hogedb;
```

## 테이블 컨트롤
1. 테이블 만들기
```
mysql> create table testtbl(num int, name varchar(50));
mysql> show tables;
```

2. 테이블 삭제
```
mysql> drop table testtbl;
mysql> show tables;
```

3. 데이터 입력
```
mysql> insert into testtbl values(1, 'hogehoge');
mysql> select * from testtbl;
```
4. 데이터 업데이트
```
mysql> update testtbl set name='higehige' where num = 1;
mysql> select * from testtbl;
```

5. 데이터 삭제
```
mysql> delete from testtbl where num = 1;
mysql> select * from testtbl;
```

6. 현재 실행중인 SQL표시
```
mysql> show processlist;
```

7. 인덱스 조회
```
mysql> show index from 테이블명;
```

## 테이블 수정
1. 테이블 명 변경
```
RENAME TABLE [변경전 테이블명] TO [변경후 테이블명]
=> RENAME TABLE table1 TO table2;
=> RENAME TABLE table3 TO table4, table2 TO table3, table1 TO table2;
```

2. 컬럼 추가
```sql
-- 컬럼추가
ALTER TABLE [table name] ADD [column name] [column type];
-- 위치 지정 추가
ALTER TABLE [table name] ADD [column name] [column type] AFTER [추가컬럼 바로 앞의 컬럼명지정];

alter table juve add mid_name varchar(25) after fir_name;
```

3. 컬럼명 수정
```
ALTER TABLE tbl_name CHANGE [COLUMN] old_col_name new_col_name column_definition
=> alter table staff change id staffid bigint unique;
```

4. 컬럼 삭제
```
ALTER TABLE tbl_name DROP [COLUMN] col_name
=> alter table staff drop col_name
```

5. 컬럼 정의 수정
```
ALTER TABLE tbl_name MODIFY [COLUMN] col_name column_definition
```

## GRANT 권한
### 권한 추가
```
mysql> GRANT CREATE ON 데이터베이스명.* TO 유저명@localhost;
mysql> GRANT DROP ON 데이터베이스명.* TO 유저명@localhost;
mysql> GRANT ALTER ON 데이터베이스명.* TO 유저명@localhost;
```

### 권한 확인
```
mysql> SHOW GRANTS FOR 유저명@localhost \G
```

### 권한 삭제
```
mysql> REVOKE ALL PRIVILEGES ON *.* FROM 유저명@localhost;
mysql> REVOKE 삭제할권한 ON 대상(데이터베이스명.*) FROM 유저명;
```

## MySQL 트러블 슈팅

### 프로세스 보기
```
> show processlist;
```

### Lock 목록 출력
SELECT * FROM information_schema.innodb_locks;

### 프로세스 목록 출력
```
select concat('KILL ',id,';') from information_schema.processlist where user='astron' limit 5000;
```

### 프로세스 죽이기
```
kill [번호];
> kill 30;
```

### 데이터 베이스 백업
```
#> mysqldump -u [mysql user] -p[user password] [Redmine데이터베이스명] > [백업파일명]
```

### root 패스워드를 잊었을때 1번째
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

### root 로 연결이 안되는 경우 2번째
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

### allowed to connect to this MySql server 라는 오류가 나오면
```
mysql> grant all privileges on DBNAME.* to USERNAME@'%' identified by 'PASSWORD'; <-- 해당 유저에 권한을 지정해주어야함.
```

### 백업
* 특정 데이타 베이스 덤프
```
mysqldump --single-transaction -u [DB유저명] -p [DB명] > [출력 파일명]
> mysqldump --single-transaction -u astron -p astrondb > astrondb.dump
```

### Host is not allowed to connect to this MySQL server
* 외부접속 가능하도록 권한 부여
```
GRANT ALL PRIVILEGES ON *.* TO root@'192.168.%' IDENTIFIED BY 'root패스워드' WITH GRANT OPTION;
> GRANT ALL PRIVILEGES ON *.* TO root@'192.168.%' IDENTIFIED BY 'root' WITH GRANT OPTION;
```
# 참조사이트
- [テーブル構造を変更する(ALTER TABLE文)](https://www.dbonline.jp/mysql/table/index18.html)
- [MySQLでテーブル名を変更する「RENAME TABLE」](https://uxmilk.jp/50822)
## JOIN
- [【INNER JOIN, LEFT JOIN , RIGHT JOIN】テーブル結合の挙動をまとめてみた【SQL】](https://qiita.com/ngron/items/db4947fb0551f21321c0)
## DELETE
- [DELETE文の書き方：サンプル多数あり](https://oreno-it.info/archives/2282)

## 외부접속 권한부여
- [MySQL を外部接続できるようにする](http://yosugi.hatenablog.jp/entry/2013/06/23/185240)
- [外部データベースサーバの追加時に "Host is not allowed to connect to this MySQL server" というエラーが発生します](https://support.plesk.com/hc/ja/articles/213361969--%E5%A4%96%E9%83%A8%E3%83%87%E3%83%BC%E3%82%BF%E3%83%99%E3%83%BC%E3%82%B9%E3%82%B5%E3%83%BC%E3%83%90%E3%81%AE%E8%BF%BD%E5%8A%A0%E6%99%82%E3%81%AB-Host-is-not-allowed-to-connect-to-this-MySQL-server-%E3%81%A8%E3%81%84%E3%81%86%E3%82%A8%E3%83%A9%E3%83%BC%E3%81%8C%E7%99%BA%E7%94%9F%E3%81%97%E3%81%BE%E3%81%99)