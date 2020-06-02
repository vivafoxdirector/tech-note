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

## recursive with 구문
탐색기 부모 또는 자식 리스트 취득
- [木構造の親または子を再帰的に取得する](https://qiita.com/neko_the_shadow/items/d401e0c23892b0d53c2a)


# 트러블슈팅
* 외부접속이 가능하도록 권한을 부여한다.
- [MySQL を外部接続できるようにする](http://yosugi.hatenablog.jp/entry/2013/06/23/185240)

# 참조사이트
* Recursive(With구문)
- [木構造の親または子を再帰的に取得する](https://qiita.com/neko_the_shadow/items/d401e0c23892b0d53c2a)
- [[PostgreSQL 8.4+] WITH RECURSIVEの動作を理解する](https://qiita.com/anqooqie/items/fac5aeb74169f1634c87)
- [PostgreSQL Recursive Queries](https://medium.com/@josephharwood_62087/postgresql-recursive-queries-610a16e772b8)
- [A Definitive Guide To MySQL Recursive CTE](https://www.mysqltutorial.org/mysql-recursive-cte/)
- [WITH問い合わせ（共通テーブル式）](https://www.postgresql.jp/document/9.6/html/queries-with.html)
- [WITH RECURSIVEの使用](https://qiita.com/SE-studying-now/items/18a7c1305f552718cec0)

* Timezone 변경
- [MySQLのTimeZoneをJSTからUTCに変更する](https://qiita.com/saicologic/items/4bc72dc53f25412ca112)

* 사용자 변수
- [ユーザー定義変数](https://dev.mysql.com/doc/refman/5.6/ja/user-variables.html)

* 날짜계산 및 날짜 출력 & 달력 만들기
- [月末の日付を取得する](http://mysql.javarou.com/dat/000849.html)
- [【MySQL】日時の計算（加算・減算）](https://qiita.com/azusanakano/items/f33bce0664d851a88666)
- [SQLを使って日別で集計する](https://blog.ch3cooh.jp/entry/20140113/1389588740)
- [会員数の推移を把握したい場合の例](https://kanetann.hatenablog.com/entry/2014/10/23/182440)
- [MySQL 日時ごとの集計まとめ](https://qiita.com/yakatsuka/items/2906011803500ebd4390)
- [SQL Server 日付と時刻の関数一覧](https://johobase.com/sqlserver-datetime-function/)
- [MySQLでの日付型の加算と減算](https://qiita.com/sakura1116/items/3fef2ca5b5280eae22e8)
- [データを期間別に集計する](http://skill-note.net/post-405/)
- [「状態遷移図の書き方」と「状態遷移表からのテスト抽出方法」](https://www.wakuwakubank.com/posts/290-design-state/)
- [SQLでカレンダーを取得する (WITH CTE) [SQLServer, MySQL]](https://johobase.com/select-calendar-sql/)
- [SELECT文だけでカレンダーデータを作成する](https://sqlite-date.com/calendar)
- [SQL Server でカレンダーテーブルを作る方法](https://www.kwbtblog.com/entry/2019/06/27/003656)
- [日付範囲から日ごとのデータを作成する](https://sql55.com/query/date-range-to-list-of-dates.php)
- [MySQLでカレンダーテーブルを作る](https://kuniaki12.hatenablog.com/entry/2017/08/17/122826)
- [MySQL クエリで連続した日付の仮想表を作成する](https://symfoware.blog.fc2.com/blog-entry-1713.html)
- [MySQLで当月のカレンダーを作成する方法](https://lightgauge.net/database/mysql/5402/)

* EXISTS
- [SQL select文のinとexistsの違いがわかっていなかった問題](https://qiita.com/darkimpact0626/items/5a5d03c27ae7c849566f)
- [5分でわかる！ EXISTSでサブクエリを扱う方法](https://www.sejuku.net/blog/73615)