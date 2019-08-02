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

[ng serveでモジュールがないというエラー（Error: Cannot find module '@angular-devkit/core'）](http://lighthouse-dev.hatenablog.com/entry/2018/03/21/205300)