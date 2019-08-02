# SBT

## Setting for Mac
```
$ brew install sbt@1
```

## Compile and Run
```
$> sbt compile
$> sbt run
```

## Make Project

### Make Project folder
```
$> mkdir -p MyProject/src/main/scala
$> mkdir -p MyProject/src/main/java
$> cd MyProject
$> tree
$> vi build.sbt
```

### build.sbt
```
name := "My Project"
version := "1.0"
scalaVersion := "2.10.0"
```

### Make Source
```
$> vi src/main/scala/HelloWorld.scala
```

### Source
```
object HelloWorld extends App {
    println("HelloWorld")
}
```

### Run
```
$> sbt run
```


## Test
```
$> sbt test
```

# REF
* ref: https://www.scala-sbt.org/0.13/docs/ja/index.html
*
* ref: https://kazuhira-r.hatenablog.com/entry/20140816/1408209915
