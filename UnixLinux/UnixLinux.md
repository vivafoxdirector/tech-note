# AIX

## 디렉토리 용량 확인
```shell
$> du -sm /opt
$> du -sk /opt
```
※k=1kbyte m=1Mbyte

## 현재 디렉토리 이하의 용량 확인
```shell
$> du -m | egrep -v /.+/
```

# 참고
* 내용: 디렉토리 용량
  * 참조: http://d.hatena.ne.jp/aix_memo/20090206/1233886385