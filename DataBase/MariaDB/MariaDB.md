# MariaDB
# 계정
* 계정 추가
```sql
$ grant all privileges on hogedb.* to hogehoge@localhost identified by 'hogehoge';
$ grant all privileges on hogedb.* to hogehoge@'%' identified by 'hogehoge';
$ select user, host, password from mysql.user;
$ quit
$ mysql -u hogehoge -phogehoge
$ create database hogedb;
$ show databases;
```

> SOURCE $경로$/cretab.sql

# 대소문자 구분 없이 가능하도록 
- [MySQLにおけるテーブル名の大文字／小文字区別について](https://wd3ie.hatenadiary.org/entry/20110309/1299647373)
- [MariaDBで大文字・小文字の区別をしているか確認する](http://osprey-jp.hatenablog.com/entry/2017/06/02/092419)
- []