# Project 시작
## 인스툴
```
npm install -g @angular/cli
```

## 어플리케이션 작성
```
ng new my-app
```

## 서버기동
```
cd my-app
ng serve
```

# Error
## Error 내용
```
Error: Cannot find module '@angular-devkit/core'
```
1. npm업데이터
```
npm update -g
```

2. node_modules 풀더 삭제
```
rm -r node_modules
```

3. angular-cli버전 확인
```
ng -v
```

4. 3번 angular-cli버전에 맞게 package.json수정
5. npm 인스툴 실행
6. 확인
```
ng serve
```
- [ng serveでモジュールがないというエラー（Error: Cannot find module '@angular-devkit/core'）](http://lighthouse-dev.hatenablog.com/entry/2018/03/21/205300)

7. Apache2사용시 NotFoundError 대응 (도커이용시)
## httpd(8085)
유저 multicg 디렉토리가 마운트 볼륨으로 한다.
1. 기동
```
# apache2
docker run -d -p 8085:80 -v "/home/multicg/html/:/usr/local/apache2/htdocs/" --name astronweb0 httpd

# nginx
docker run --name astronweb1 -v /home/multicg/html:/usr/share/nginx/html:ro -d -p 8085:80  nginx
```
2. 설정파일
```
* apache2
/usr/local/apache2/conf/httpd.conf
```
* httpd.conf 아래항목 수정
```
- 주석제거
LoadModule rewrite_module modules/mod_rewrite.so

<Directory "/var/www/html">
#   Options Indexes FollowSymLinks
    Options FollowSymLinks


#   AllowOverride None
    AllowOverride All

    Require all granted
</Directory>
```
* .htaccess (html이 있는 홈디렉토리)
```
<IfModule mod_rewrite.c>
    RewriteEngine On
    RewriteRule ^index\.html$ - [L]
    RewriteCond %{REQUEST_FILENAME} !-f
    RewriteCond %{REQUEST_FILENAME} !-d
    RewriteRule . index.html [L]
</IfModule>
```


# 참조사이트
1. Apache2 연동시 404에러
- [サーバー設定手順 6. Angular](https://mi12cp.hatenablog.com/entry/2018/08/25/224149)
- [Optimal htaccess file for angular apps](https://gist.github.com/julianpoemp/bcf277cb56d2420cc53ec630a04a3566)
- [.htaccess - Angular 2をApacheサーバーにデプロイする](https://tutorialmore.com/questions-1719808.htm)
- [Angularで作ったアプリをApacheサーバーにUPして公開する](https://qiita.com/agajo/items/d355b1fd54a35749d49e)