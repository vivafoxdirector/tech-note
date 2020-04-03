# RestFul

# Rest 설계

1. 동사를 사용하지 않고 명사(복수형)를 사용한다.
```
NG: localhost:9090/getMembers   
OK: localhost:9090/members
```
2. Camel or Snake 표기를 한다.
```
Camel표기: localhost:9090/memberId
Snake표기: localhost:9090/member_id
```

## URL
1. http(s)://도메인명(:포트)/(API버전)/식별자
```
https://hogehoge:8080/v1/hoge
```
2. http(s)://도메인명(:포트)/(rest api 식별자)/(API버전)/식별자
```
https://hogehoge:8080/api/v1/hoge
```

## 인터페이스 통일

|처리|HTTP메소드|CRUD조작
|-|-|-|
|등록|POST|CREATE
|취득|GET|READ
|갱신|PUT|UPDATE
|삭제|DELETE|DELETE

```
등록 POST    /calendars/calendarId/events
취득 GET     /calendars/calendarId/events/eventId
갱신 PUT     /calendars/calendarId/events/eventId
삭제 DELETE  /calendars/calendarId/events/eventId
```
## HTTP에러
200: 처리성공
300: 리소스 상태 변경등
400: 에러 (인터페이스에서 오류)
500: 에러 (서버에서 오류)

|코드|상태|설명|
|-|-|-|
|200|OK|정상|
|201|Created|정상 처리 되었고, 정보가 새로 작성됨|
|204|No Content|정상 처리 되었으나, 응답정보가 없음|
|400|Bad Request|서버가 알수 없는 요청|
|401|Unauthorized|인증이 필요|
|403|Forbidden|서버로부터 거부|
|404|Not Found|서버에 존재하지 않는 정보|
|500|Internal Server Error|서버에러|

## 참고사이트
- [REST入門 基礎知識](https://qiita.com/TakahiRoyte/items/949f4e88caecb02119aa)
- [How to design a REST API](https://blog.octo.com/design-a-rest-api/)
- [Rest ful api設計入門](https://www.slideshare.net/MonstarLabInc/rest-ful-api)
- [RestfulなWebAPIの設計](https://qiita.com/kawasukeeee/items/70403129f5a5338cd4ad)
