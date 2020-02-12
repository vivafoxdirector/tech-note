# PostgreSQL

## PostgreSQL 제어
* 기동에서 유저 만들기
```shell
$> service postgresql start
(root$> systemctl start postgresql.service)
/var/lib/pgsql/data is missing. Use "service postgresql initdb" to initialize the cluster first.  [실패]
$> service postgresql initdb
데이타베이스를 초기함:                                     [  OK  ]
$> service postgresql start
$> su - postgres
$> psql -l
sql> createuser pharos    <--- 실제 Linux 계정명으로 생성한다.
새 롤을 superuser 권한으로 지정할까요? (y/n) n
이 새 롤에게 데이터베이스를 만들 수 있는 권할을 줄까요? (y/n) y
이 새 롤에게 또 다른 롤을 만들 수 있는 권한을 줄까요? (y/n) n
sql> createdb hogedb -U pharos
FATAL ERROR....
sql> exit
$>su - pharos
pharos$> createdb hogedb   <--- Linux계정명에서 바로 postgresql 명령어를 사용할 수 잇다.
pharos$> psql -l
```

* 연결Port변경
    * 단일패키지
    ```
    $> $POSTGRESQL_HOME$/data/postgresql.conf
    port=5432 <--- 이부분 수정을 하면 됨.
    ```
    * 루트계정에 포함된 패키지
    ```
    $> /var/lib/psql/data/postgresql.conf
    port=5432 <--- 이부분 수정을 하면 됨.
    ```

* PostgreSQL시작
```
pg_ctl start     
```

* PostgreSQL종료
```
pg_ctl stop
pg_ctl -m fast stop  <-- 빨리종료
```

* 데이터베이스 생성
```
create database [database name]
```

* 데이터베이스 삭제
```
drop database [database name]
```

* 버전정보 확인
```
select version();
```

## 사용자 관리
* postgre로 연결
```
psql -U postgres
```

* 유저 권한으로 연결
```
psql -U [username]
psql -U [username] -d [dbname]
```

* 유저 생성
```
> CREATE USER [username] WITH PASSWORD [pwd]
createuser -a -d -U postgres -P [username]
create user [username]
create user [username] with password '[password]'
```

* 유저 리스트 조회
```
select * from pg_shadow;
select * from pg_user;
```

* 유저 삭제
```
drop user [username]
```

* 데이터베이스 권한 설정
```
ALTER DATABASE [database name] OWNER TO [user name]
```

* 디비조회(쉘에서)
```
psql -l
```

*  디비연결
```
$>psql [databasename]
```

* pdadmin권한으로 연결
```
psql -U [suepr user id]
```

## psql 명령어
* 데이터베이스 조회
```
\l
```

* 데이터베이스 선택
```
\c [databasename]
```

* 테이블 리스트 조회 - 1
```
\d
```

* 테이블 리스트 조회 - 2
```
\z
```

* 테이블 상세 조회
```
\d [tablename]
```

* 종료하기
```
\q
```

* SQL파일 실행하기
```
\i xxx.sql
```

# 트러뷸 슈팅
## 오류
* Client접속시 [Access to database denied] 오류발생시 대응
```
$> vi pg_hba.conf
host all all 0.0.0.0 0.0.0.0 trust  로 편집한다
```
- [Postgres クライアントからサーバーへ接続できない](http://kkkw.hatenablog.jp/entry/20081207/1228626082)

# 참조사이트
- [PostgreSql コマンドの覚え書き](http://qiita.com/mm36/items/1801573a478cb2865242)
- [PostgreSQLのよく使うコマンドまとめ](http://dev.classmethod.jp/server-side/db/postgresql-organize-command/)
- [PostgreSQLの管理](http://www.nslabs.jp/postgresql.rhtml)
- [PostgreSQLのユーザ作成、データベース作成等の基本操作](http://www.develop-memo.com/database/postgresql/postgresqloperate.html)
- [PostgreSQLでユーザを追加する方法](http://db.just4fun.biz/?PostgreSQL/PostgreSQL%E3%81%A7%E3%83%A6%E3%83%BC%E3%82%B6%E3%82%92%E8%BF%BD%E5%8A%A0%E3%81%99%E3%82%8B%E6%96%B9%E6%B3%95)