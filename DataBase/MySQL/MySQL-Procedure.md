# MySQL Procedure

## 함수/프로시저 신택스
=> [CREATE PROCEDURE and CREATE FUNCTION Syntax](https://dev.mysql.com/doc/refman/8.0/en/create-procedure.html)

## 함수 또는 프로시저 만들 때 
```
CREATE DEFINER=`devDBAdmin`@`%` FUNCTION `fn_Get_DateTime`(

DEFINER : 생성한 user의 권한을 따름
INVOKER : 실행한 user의 권한을 따름

userid@% = allows connection from user 'root' from any host, local or TCP (internet)
userid@localhost = only allows connection from 'root' on the machine running the MySQL server. Hence, LOCALhost. Cannot be accessed from any other computer and/or network using the 'root' user.
```

## 함수에서 리턴할 때 DETERMINISTIC/NOT DETERMINISTIC
=> [Stored function의 NOT DETERMINISTIC 옵션은 무엇이고 쿼리에 어떤 영향을 미칠까?](http://intomysql.blogspot.com/2010/12/stored-function-not-deterministic.html)

## Error Code: 1046. No database selected Select the default DB to be used by double-clicking its name in the SCHEMAS list in the sidebar.
```
sql 실행할 때 사용할 DB를 선택하지 않았을 때 에러, 아래 명령어 사용

use [DB이름]
ex) use AccountDB;
```
## = vs :=
```
SET p_Result := -4;

In a SET statement, both := and = are assignment operators.
In a SELECT statement, := is an assignment operator and = is an equality operator.
```
