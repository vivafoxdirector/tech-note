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


> mysql

$ grant all privileges on astrondb.* to astron@localhost identified by 'astron';
$ grant all privileges on astrondb.* to astron@'%' identified by 'astron';

```

> SOURCE $경로$/cretab.sql

# 대소문자 구분 없이 가능하도록 
- [MySQLにおけるテーブル名の大文字／小文字区別について](https://wd3ie.hatenadiary.org/entry/20110309/1299647373)
- [MariaDBで大文字・小文字の区別をしているか確認する](http://osprey-jp.hatenablog.com/entry/2017/06/02/092419)


cat <<EOF > test
line1
line2
line3
EOF
# vi  /etc/my.cnf.d/server.cnf
[mysqld]
bind-address = 0.0.0.0
console = 1
general_log = 1
general_log_file = /var/log/mariadb/mariadb.log
log_error = /var/log/mariadb/error.log
collation-server = utf8_unicode_ci
character-set-server = utf8
datadir = /var/lib/mysql
lower_case_table_names=1

[mysqld_safe]
log_error = /var/log/mariadb/error.log


|TYPE|SIZE(byte）|최대치
|-|-|-|
(Signed/Unsigned)	最大値
(Signed/Unsigned)
TINYINT	1	-128
0	127
255
SMALLINT	2	-32768
0	32767
65535
MEDIUMINT	3	-8388608
0	8388607
16777215
INT	4	-2147483648
0	2147483647
4294967295
BIGINT	8	-9223372036854775808
0	9223372036854775807
18446744073709551615

# 트러블슈팅
* 외부접속이 가능하도록 권한을 부여한다.
- [MySQL を外部接続できるようにする](http://yosugi.hatenablog.jp/entry/2013/06/23/185240)