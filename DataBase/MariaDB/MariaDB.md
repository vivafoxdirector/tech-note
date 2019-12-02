# MariaDB

> grant all privileges on hogedb.* to hogehoge@localhost identified by 'hogehoge';
> grant all privileges on hogedb.* to hogehoge@'%' identified by 'hogehoge';
> select user, host, password from mysql.user;
> quit

> mysql -u hogehoge -phogehoge
> create database hogedb;
> show databases;

> SOURCE $경로$/cretab.sql