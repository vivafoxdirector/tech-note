# Go

# Go Module 사용
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
## 에러
* 이슈
```
cmd/go: go mod init fails to determine module path in subdirectory
```
* 해결
```
go mod init `pwd`
```

# 참조사이트
[Go言語の基礎〜Go 1.11 開発環境構築とパッケージバージョン管理〜](https://re-engines.com/2018/10/09/go言語の基礎〜go-1-11-パッケージ管理システムと開発環/)
[Go Modules](https://qiita.com/propella/items/e49bccc88f3cc2407745)
[go1.11のmodulesの使い方について](https://qiita.com/yagi5/items/82989a5ecda70a614c27)