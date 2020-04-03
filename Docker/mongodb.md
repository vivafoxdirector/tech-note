# MongoDB

# Docker compose 이용
- [docker-composeでmongoDB環境を構築して使う](https://qiita.com/mistolteen/items/ce38db7981cc2fe7821a)
## docker-compose.yml
```
# Use root/example as user/password credentials
version: '3.1'

services:

  mongo:
    image: mongo
    restart: always
    environment:
      MONGO_INITDB_ROOT_USERNAME: root
      MONGO_INITDB_ROOT_PASSWORD: example
    ports:
      - 27017:27017
    volumes:
      - /tmp/mongodb/db:/data/db
      - /tmp/mongodb/configdb:/data/configdb

  mongo-express:
    image: mongo-express
    restart: always
    ports:
      - 8081:8081
    environment:
      ME_CONFIG_MONGODB_ADMINUSERNAME: root
      ME_CONFIG_MONGODB_ADMINPASSWORD: example
```




# 참조사이트
- [docker-composeでmongoDB環境を構築して使う](https://qiita.com/mistolteen/items/ce38db7981cc2fe7821a)
- [DockerでMongoDBを起動する](https://qiita.com/tanakaworld/items/68fb4817d24418f32cd8)