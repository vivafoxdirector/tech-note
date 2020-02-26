# Docker Apache

# DevOps
```
docker pull httpd
docker run -d -p 8080:80 httpd

docker ps

docker stop [containerid]
docker start [containerid]

```
## 볼륨 마운트 옵션
```
docker run -v "마운트 소스 경로:마운트 타겟 경로" 
docker run -d -p 8080:80 -v "/tmp/mypage/:/usr/local/apache2/htdocs/" httpd
docker run -d -p 8080:80 -v "/home/multicg/html/:/usr/local/apache2/htdocs/" --name astronweb0 httpd

```

# 참고사이트
- [Docker 公式 httpd イメージを利用して Docker を体験してみよう](https://weblabo.oscasierra.net/docker-httpd-usage/)