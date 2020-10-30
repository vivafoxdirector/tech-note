# redis
## Docker compose
- docker-compose.yaml
```yml
version: '3'
services:
  redis:
    image: "redis:latest"
    ports:
      - "6379:6379"
    volumes:
      - "./data/redis:/data"
```

## 설치
```
$ docker-compose up -d
```

## 확인
```
$ docker exec -it [CONTAINER ID] /bin/bash
root@46f68f517bf1:/data# redis-cli
127.0.0.1:6379> keys *
```

## 명령어
|명령어|설명|
|-|-|
|keys *|redis에 등록된 키 일람 표시|
|type [key]|value의 type을 반환|
|get [key]|type의 string값 취득|

<br><br>

# 참조사이트
- [docker-composeでredis環境をつくる](https://qiita.com/uggds/items/5e4f8fee180d77c06ee1)
- [redis-cli コマンド操作まとめ](https://qiita.com/rubytomato@github/items/d66d932959d596876ab5)