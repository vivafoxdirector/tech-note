# Thread Dump
## JAVA프로세스 ID 확인
```shell
> ps aux | grep java
or
> $JAVA_HOME/bin/jps
```
## 스레드 덤프 실행 - 1
```shell
> $JAVA_HOME/bin/jstack [pid] > xxxx.txt
```
## 스레드 덤프 실행 - 2
```shell
> kill - 3 [pid]
```

# Thread State
* R - 실행가능
* CW - 대기상태
  * 스레드가 입출력에 의해 블럭되어 있다.
  * wait() 호출되었다
  * join() 호출되어 다른 스레드와 동기중
* S - 중단상태
* Z - 좀비
* P - 보류상태
* B - 블럭상태

# 참조 사이트
## 스레드 덤프 분석 방법
* 내용: 스레드 내용 분석
  * 참조: https://goodjoon.tistory.com/88
* 내용: スレッドダンプの森で覚えた死のロックへの違和感
  * 참조: https://www.atmarkit.co.jp/ait/articles/0809/05/news142.html
* 내용: jstack でスレッドダンプを取る
  * 참조: http://aoking.hatenablog.jp/entry/20120629/1340965676
* 내용: Javaのスレッドダンプの読み方
  * 참조: https://yohei-a.hatenablog.jp/entry/20150101/1420112104
* 내용: スレッドダンプ
  * 참조: http://software.fujitsu.com/jp/manual/manualfiles/M100002/J2UZ9180/02Z2D/tun07/tun00101.htm
* 내용: PDF
  * 참조: https://www.oracle.com/technetwork/jp/ondemand/middleware/application-grid/20100324-weblogic-trouble-255304-ja.pdf