# JVM메모리
## JVM메모리 상태 확인
```shell
> jps -v
> jstat -gcutil [pid] 1000
```
## 스레드 덤프 실행 - 1
```shell
> $JAVA_HOME/bin/jstack [pid] > xxxx.txt
```
## 힙덤프
1. 프로세스 ID 취득
```shell
> jps -v
> jps -v | less -SN
```
2. 힘덤프취득
```shell
> jmap -dump:format=b,file=./heapdump.hprof [pid]
> jmap -F -dump:format=b,file=heapdump.map [pid]
```
-F 는 강제 사출

## 옵션
## -gc
|항목|설명|
|-|-|
|S0C|Survivor영역0 현재 용량(KB)|
|S1C|Survivor영역1 현재 용량(KB)|
|S0U|Survivor영역0 사용률 (KB)|
|S1U|Survivor영역1 사용률 (KB)|
|EC|Eden 영역 현재 용량 (KB)|
|OC|Old 영역 현재 용량 (KB)|
|OU|Old 영역의 사용률 (KB)|
|PC|Permanent 영역 현재 용량 (KB)|
|PU|Permanent 영역 사용률 (KB)|
|YGC|마이너 GCPermanent 영역 사용률 (KB)|
|Bytes|로드된 K바이트 수|
|Unloaded|언로드된 클래스 수|
|Bytes|언로드된 K바이트 수|
|Time|클래스로드나 언로드처리하는데 걸린 시간|


## -class
|항목|설명|
|-|-|
|Loaded|로드된 클래스 수|
|Bytes|로드된 K바이트 수|
|Unloaded|언로드된 클래스 수|
|Bytes|언로드된 K바이트 수|
|Time|클래스로드나 언로드처리하는데 걸린 시간|

## -compile 옵션
|항목|설명|
|-|-|
|Compiled|실행된 컴파일 타스크 수|
|Failed|실패한 컴파일 타스트 수|
|Invalid|무효화된 컴파일 타스크 수|
|Time|컴파일 타스크실행 걸린 시간|
|FailedType|마지막에 컴파일 실패한 컴파일 타입|
|FailedMethod|마지막에 컴파일 실패한 클래스 명과 메소드|

## -compile 옵션
|항목|설명|
|-|-|
|Loaded|로드된 클래스 수|
|Bytes|로드된 K바이트 수|
|Unloaded|언로드된 클래스 수|
|Bytes|언로드된 K바이트 수|
|Time|클래스로드나 언로드처리하는데 걸린 시간|



# 참조사이트
## JSTAT 명령어
* 내용: jstat - Java 仮想マシン統計データ監視ツール
  * 참조: https://docs.oracle.com/javase/jp/6/technotes/tools/share/jstat.html