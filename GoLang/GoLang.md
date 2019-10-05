# Go

# Go Module 사용
## Module 사용하기
## 순서
1. 일단 환경변수 GO11MODULE=on 을 추가한다. 1.13 부터는 기본적으로 on 이다.
```shell
# 아래추가
export GO11MODULE=on
```

2. 프로젝트 디렉토리 작성
```shell
> source ~/.bash_profile
> mkdir sample
> cd sample
```

3. 모듈 관리 파일 준비
```shell
> go mod init sample
```
* 위 명령어를 실행하면 go.mod파일이 생성된다.
* 실행파일은 go mod init로 지정한 sample이름이 된다.

4. 코드를 작성
```go
package main

import (
    "fmt"
    "golang.org/x/text/width"
)

func main() {
    text := "123XYZ"
    fmt.Println("반각:", text)
    fmt.Println("전각:", width.Widen.String(text))
}
```

5. 의존 모듈 다운로드 한다.
```shell
go get golang.org/x/text/width
```
* 위 명령어를 실행하면 go.sum 이 생성되고, go.mod 에는 의존관계가 추가된다.
* 이 단계를 자동으로 하게 하려면 go build 를 실행하면 된다.

6. 빌드 & 실행
```shell
> go build
> ./sample
```

##  

## Module ?
go 1.11부터 새롭게 적용된 Modules 라는 기능이 생겼다. go mod 명령어로 modules를 관리할 수 있게 되었다.
go언어의 사상으로 dep가 아니라 modules로 dep를 구분한다.

## 이미 dep를 사용하고 있지 않으면
```shell
> export GO111MODULE=on
> cd $GOPATH/src/github.com/mattn/todo
> go mod init
> cat go.mod
module github.com/mattn/todo

> go build
> cat go.mod
> cat go.sum
```
* 패키지를 추가하려면
```shell
> go get github.com/golang/mock
> cat go.sum
> cat go.mod
```
* go get 하지 않고 소스 내부에서 패키지를 추가하였다면 go build를 해주면 된다.
```shell
import "github.com/kataras/golog"
golang.Println("This is a sample log message.")
```
```shell
> go build
> cat go.mod
> cat go.sum
```

# 트러블슈팅
Go 1.11 이후로 GOPATH는 자동으로 설정을 해주게 되고, GO module 이라는 새로운 기능이 포함되어 환경변수에
```
export GO111MODULE=on/off/auto
```
를 지정할 수 있게 되었다.

## 에러
* 이슈
```
cmd/go: go mod init fails to determine module path in subdirectory
```
* 해결
```
go mod init `pwd`
```

## 에러
* 이슈
```
go: cannot determine module path for source directory
```
* 해결
GOPATH를 확인한다.
```
GOPATH=$HOME/go
```

# 참조사이트
* [Go言語の基礎〜Go 1.11 開発環境構築とパッケージバージョン管理〜](https://re-engines.com/2018/10/09/go言語の基礎〜go-1-11-パッケージ管理システムと開発環/)
* [go1.11のmodulesの使い方について](https://qiita.com/yagi5/items/82989a5ecda70a614c27)
* [Go Modules](https://qiita.com/propella/items/e49bccc88f3cc2407745)
* [Go 1.12のmodulesを試す](https://qiita.com/tana6/items/df9a48eecb84576f618d)
* [Golang 1.11でGO111MODULE=onの状態でグローバルにgo getできない時の対処法](https://qiita.com/tobita0000/items/bd7f01e02c24b5e4865a)