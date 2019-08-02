## Java메모리, GC튜닝과 트러블슈팅 대응 방법
[Java메모리, GC튜닝과 트러블슈팅 대응 방법](http://d.hatena.ne.jp/learn/20090218/p1)
### 트러블 슈팅 방법
#### 1. "OutOfMemoryError: PermGen space" 와 같은 에러인 경우
Permanent영역 부족으로 OutOfMemoryError가 발생한 것이다.
대응 방법으로는, -XX:PermSize, -XX:MaxPermSize를 지정하여 OutOfMemoryError가 발생되지 않도록 Permanent영역을 크게 잡아 주는 방법이다. 단, 기본적으로 Permanent영역은, 클래스 정보나 메소드 정보가 저장되어 있는 영역으로, 어플리케이션 기동후에는 거의 증가하거나 줄어들지는 않는다. jstat나 jconsole등으로 Permanent영역 사용상황을 확인하고, 만일 지속적으로 증가가 된다면 Permanent영역의 메모리 릭이 발생될 가능성이 있다. 릭이 발생된 곳을 찾기 위해서는 힙통계 정보나 힙덤프를 몇 번정도 취득하여 비교하거나, 어플리케이션 로그등으로 OutOfMemoryError발생 직전의 실행된 것이 항상 같은 지점인지를 확인 한다.예를 들어서 DI컨테이너는 통상 하나의 어플리케이션에서 하나만 사용되는데, 특정 처리에서 신규 컨테이너를 생성하도록 되어 있고, 그 처리가 실행될 때마다 대량의 Permanent영역을 소비하고, 결국 OutOfMemoryError가 발생되는 사례가 있다.

#### 2. "OutOfMemoryError: Java Heap Space" 와 같은 에러인 경우 ('OutOfMemoryError' 만 나오는 경우도 있음)
힙메모리 부족으로 OutOfMemoryError가 발생되는 경우이다. 우선 -Xmx, -Xmx를 지정하고, OutOfMemoryError가 발생되지 않도록 힙 영역을 늘려주도록 한다. 그리고 세부적인 대응 방법으로는 GC로그를 취득하고, 힙에서 메모리릭이 발생되지 않았는지 확인이 필요하다. GC로그 분석툴 (GCViewer, Excel)등으로 그래프화하여 확인한다. 그래프가 Full GC가 발생되고 그래프가 왼쪽에서 오른쪽으로 상향으로 그래프가 그려지면(오른쪽으로 상향으로 그려지다가 Full GC로 그래프가 다시 하향으로 내려오지만 특정 지점부터 그래프가 내려오지 않는 (몇번의 Full GC발생시 그래프가 아래로 내려가나 이전에 Full GC의 상한선까지 밖에 내려오지 않고 계속 위로 올라가는 형태) 경우는 메모리릭이 발생될 가능성이 높다. 릭이 발생된 원인을 찾으려면 힙 통계정보나 힙덤브를 여러번 취득하여 비교하고, Full GC가 발생되어도 오브젝트의 수가 증가되는 부분을 찾는다. 의심가는 오브젝트를 찾으면 Profiler등을 사용하여 오브젝트를 사용하는 곳을 찾고, 오브젝트 참조를 추적한다.

#### 3. 힙메모리 튜닝방법
운용환경에서 jstat -gcutil이나 jconsole을 사용하여 힙의 각 영역의 사용현황을 확인하면서 Full GC실행 시간을 최소화 하기 위해서는 OutOfMemoryError가 발생되지 않도록 되도록 이면 메모리 사이즈를 JVM옵션 -Xms, -Xmx을 사용하여 지정하고, 또한 Full GC발생빈도를 줄이기 위해
~~~
-Xmn(-XX:NewSize)、-XX:MaxNewSize、-XX:SurvivorRatio、-XX:MaxTenuringThreshold、-XX:TargetSurvivorRatio
~~~
등의 JVM옵션을 조절하고, 되도록 이면 New영역의 마이너GC로 메모리를 해제하도록 하고, Old영역으로 이동되는 빈도와 사이즈를 줄이는 것으로 한다.
마이너GC가 발생하지 않는데 갑자기 Old영역의 사용률이 오르는 경우나, S0, S1, Eden영역이 갑자기 100%가 되는 경우는 오브젝트 사이즈가 S0, S1, Eden영역 사이즈보다 큰 경우라고 볼 수 있다. 엑세스 로그와 더불어 IO를 사용률 높은 URL과 코드를 보면서 URL요청 전후의 힙정보, 힙덤프를 비교하여 사이즈가 큰 오브젝트를 찾는다. 만약 그 오브젝트의 생명주기가 짧은 경우는 -Xmn(-XX:NewSize), -XX:MaxNewSize를 증가시키고, Old영역으로 가지않도록 조절 한다. JVM옵션은 아래의 표를 참조하여 설정을 한다.
<table>
<tr><th>JVM Option</th><th>Setting</th></tr>
<tr><td>-Xmn(-XX:NewSize), -XX:MaxNewSize</td><td>-Xmx사이즈의1/4 - 1/3정도</td></tr>
<tr><td>-XX:SurvivorRatio</td><td>2 - 8정도</td></tr>
<tr><td>-XX:MaxTenuringThreshold</td><td>32정도</td></tr>
<tr><td>-XX:TargetSurvivorRatio </td><td>80 - 90정도</td></tr>
</table>

#### 4. 마이너 GC실행시간이 1초이상인 경우
New영역이 너무 크게 설정될 가능성이 있는 것으로 -Xmn(-XX:NewSize), -XX:MaxNewSize의 사이즈를 줄인다. 그리고 CPU가 여러개가 있는 멀티 코더인 경우 -XX:+UseParallelGC 옵션을 부여하여 병렬 GC를 하도록 한다.
~~~
-XX:+UseParallelGC 마이너GC를 멀티스레드를 이용하여 실행
~~~

#### 5. Full GC실행시간이 1초이상인 경우
먼저 메모리릭이 발생되지 않았는지 확인한다. 확인 방법은 '2. OutOfMemoryError: Java Heap Space'의 기술된 부분을 참조한다.
메모리릭이 발생되지 않은 경우는 Old영역이 너무 크게 설정되어 있을 가능성이 있기 때문에 -Xmx, -Xmx로 설정된 사이즈를 줄인다. 여기서 너무 줄이게 되어 OutOfMemoryError를 발생되는 경우도 발생되기 때문에 주의하여 설정한다. 방법은 '3. 힙메모리 튜닝방법'을 참조한다. 메모리릭이 발생하지 않았고, 이이상 사이즈를 줄이면 Old영역에서 OutOfMemoryError가 발생하게 되는 상황에서 Full GC실행시간이 1초 이상인 경우는 아래와 같은 상황이라고 보면 된다.
  1. 어플리케이션에서 메모리를 많이 사용하지 않는지 확인하고, 그런 경우는 수정을 한다.
  많은 메모리를 소비하는 처리 로직을 찾기 위해서 jstat -gcutil이나 jconsole를 이용하여 힙의 각 영역 사용현황을 감시하고, 사용률이 갑자기 오른 구간에서 실행된 처리를 확인한다. 그담은은 코드를 해석하여 수정한다.
  2. 세션 타임 아웃 시간을 확인
  세션타임아웃 시간이 불필요하게 긴 경우가 있는지 확인한다. 그런 경우는 짧게 되도록 수정한다.
  3. Concurrent GC사용
  되도록 이면 Full GC를 어플리케이션에 영향이 없도록 병렬실행 되도록 Concurrent GC를 사용한다. 아래의 Java기동 옵션을 설정한다.
~~~  
※-Xms -Xmx -XX:NewSize -XX:MaxNewSize, -XX:SurvivorRatio, -XX:MaxTenuringThreshold, -XX:TargetSurvivorRatio는 지정되어 있는거로 전제 한다.
~~~
<table>
<tr><th>JVM Option</th><th>Description</th></tr>
<tr><td>-XX:+UseConcMarkSweepGC</td><td>Concurrent GC 유효</td></tr>
<tr><td>-XX:+CMSParallelRemarkEnabled	</td><td>Full GC의 Remark단계를 멀티스레드로 실행</td></tr>
<tr><td>-XX:+UseParNewGC</td><td>마이너 GC를 멀티스레드로 실행</td></tr>
</table>

#### 6. 어플리케이션 응답이 없는 경우
스레드 덤프를 취득하여 확인한다.

#### 7. StackOverflowError 나오는 경우
StackTrace를 확인하고, 불필요하게 메소드가 재귀호출되는지 확인한다. 또는 아래의 기동 옵션을 설정하고, 스택 사이즈를 증가시킨다.
<table>
<tr><th></th><th>HotSpot VM</th><th>비 HotSpot VM</th></tr>
<tr><td>-Xss</td><td>(Java/Native)스레드 스택 사이즈</td><td>네이티브스레드 스택 사이즈</td></tr>
<tr><td>-Xoss</td><td>효과 없음</td><td>Java스레드 스택 사이즈</td></tr>
</table>

# 참조 사이트
## [Javaパフォーマンス・チューニング]
http://h50146.www5.hpe.com/products/software/oe/hpux/developer/column/tuning/top.html

## [Javaはどのように動くのか～図解でわかるJVMの仕組み]
http://gihyo.jp/dev/serial/01/jvm-arc

## [Javaパフォーマンスチューニング]
http://www.atmarkit.co.jp/ait/series/2353/

## [JavaVMのメモリ管理をマスターする]
http://www.itmedia.co.jp/enterprise/articles/0905/27/news002.html

## [チューニングのためのJava VM講座]
http://www.atmarkit.co.jp/ait/series/2804/

## [Javaのヒープ・メモリ管理の仕組みについて]
http://promamo.com/?p=2828

## [Java8のHotSpotVMからPermanent領域が消えた理由とその影響]
http://equj65.net/tech/java8hotspot/#vmdescript

## [JVMのチューニング]
http://d.hatena.ne.jp/ogin_s57/20120709/1341836704

## [Javaメモリ、GCチューニングとそれにまつわるトラブル対応手順まとめ]
http://d.hatena.ne.jp/learn/20090218/p1

## 原因不明のOutOfMemoryエラー、性能劣化の問題も一挙に解消
https://blogs.oracle.com/wlc/outofmemory