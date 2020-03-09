# Windows

## 프로세스
1. 포트를 사용하는 프로세스(pid) 찾기
```
netstat -ano | find ":8080"
```
2. 프로세스 죽이기
```
taskkill /F /PID [pid]
```

# 참조사이트
- [[TIPS]Windowsで、あるポート番号をListenしているプロセスを調べてkillする](https://qiita.com/riversun/items/ac70cd4b9cef8140236c)