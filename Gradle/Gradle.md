## Gradle동영상
https://www.youtube.com/watch?v=5IAahr4TU5Y

## Gradle Project
## Create
* JAVA APPLICATION
```shell
> gradle init --type java-application
```
* JAVA LIBRARY
```shell
$> gradle init --type java-library
```
* SCALA LIBRARY
```shell
$> gradle init --type scala-library
```
* Groovy Library
```shell
$> gradle init --type groovy-library
```

## java플러그인 관련 컴파일
> gradle —daemon [taskname](taskname: build, test, check, 등등)
* 참조 : http://gradle.monochromeroad.com/docs/userguide/java_plugin.html■ Java Compile
* 참조 : http://qiita.com/opengl-8080/items/4c1aa85b4737bd362d9e$> gradle compileJava
  
* Java Clean
```shell
> gradle clean
```

* Create Project
```shell
> gradle init
```

* Create Java Project
```shell
> gradle init —type java-library
```

* Create Scala Project
```shell
> gradle init --type scala-library
```

* Create Groovy Project
```shell
> gradle init --type groovy-library
```

■ Gradle Check (build.gradle문법에 이상이없는지 체크)
```shell
$> gradle check
```

■ Task 확인
```shell
$> gradle tasks
```

■ 의존관계 정보 표시
```shell
$> gradle -q dependencies
```

■ 의존관계 라이브러리 적용
```shell
$> grade build —refresh-dependencies
```

■ 프로퍼티 정보 표시
```shell
$> gradle -q properties
$> gradle -q api:properties
```

■ Task 실행
```shell
task count << {
     5.times { print “$it” }
}
..
```
```shell
$> gradle -q count [-q를 하게되면 로그가 출력되지 않는다]
```
■ Java Test무시하고 싶행
#> gradle build -x test
■ Java Test실행
$> gradle test
■ Java Test실행(Test 지정)
$> gradle test -Dtest.single=[TestClassName]
■ java library 추가
dependencies {
     compile files(‘lib/xxxx.jar’)
..
}
■ java task 추가
task [TaskName](type: JavaExec) {
     args '[argument]'
     classpath = sourceSets.main.runtimeClasspath
     main = '[MainClass]'
}
■ java compile version 확인
buildDir = 'build'
ext {
     javaVersion = '1.7'
}
sourceCompatibility = javaVersion
targetCompatibility = javaVersion
[compileJava, compileTestJava]*.options*.encoding = 'UTF-8'


# 참조사이트
[Gradle4.9で依存ライブラリを含む単一で実行可能なjarを生成する](https://qiita.com/MirrgieRiana/items/d3271f6979c1451207a6)
[Gradle - 依存関係を持つJarファイルを作成する](https://www.codeflow.site/ja/article/gradle__gradle-create-a-jar-file-with-dependencies)
[Gradle使い方メモ](https://qiita.com/opengl-8080/items/4c1aa85b4737bd362d9e)
[Gradle：ビルドスクリプトの基本](https://qiita.com/shoma2da/items/367d0682a1b8c91f5531)
