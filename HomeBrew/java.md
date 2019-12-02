# JAVA 설치

## JAVA_HOME 확인
```
> /usr/libexec/java_home -V
```

## JDK 바꾸기
* Java SE 12
```shell
export JAVA_HOME=`/usr/libexec/java_home -v "12"`
PATH=${JAVA_HOME}/bin:${PATH}
```
* Java SE 11
```shell
export JAVA_HOME=`/usr/libexec/java_home -v "11"`
PATH=${JAVA_HOME}/bin:${PATH}
```
* Java SE 8
```shell
export JAVA_HOME=`/usr/libexec/java_home -v "1.8"`
PATH=${JAVA_HOME}/bin:${PATH}
```

## JENV 사용
jEnv는 OSX에서 JDK버전을 편리하게 변경해주는 툴이다
* jEnv 설치
```shell
brew install jenv
```
* PATH 설정
```shell
# Shell: bash
$ echo 'export PATH="$HOME/.jenv/bin:$PATH"' >> ~/.bash_profile
$ echo 'eval "$(jenv init -)"' >> ~/.bash_profile
# Shell: zsh
$ echo 'export PATH="$HOME/.jenv/bin:$PATH"' >> ~/.zshrc
$ echo 'eval "$(jenv init -)"' >> ~/.zshrc
```
* 디렉토리 작성
```shell
$ cd ~
$ mkdir ~/.jenv/versions
```
* jEnv에 JDK추가
```shell
$ jenv add `/usr/libexec/java_home -v "1.8"`
```
* jEnv에 추가된 JDK목록 표시
```shell
$ jenv versions
```
* JDK 변경하기
global 과 local이 있다

** global
```shell
$ jenv versions
* system (set by /Users/foxdirector/.jenv/version)
  1.8.0.222
  11.0.2
  13
$ jenv global 1.8.0.222
$ java -version
openjdk version "1.8.0_222"
OpenJDK Runtime Environment (AdoptOpenJDK)(build 1.8.0_222-b10)
OpenJDK 64-Bit Server VM (AdoptOpenJDK)(build 25.222-b10, mixed mode)
```
** local
특정 디렉토리만 적용된다. 
버전 변경 명령어를 실행한 디렉토리에 .java-version파일이 생성되고 지정된 버전을 해당 디렉토리에서 사용가능하다
```shell

```

# 트러블슈팅
## Java11설치시 오류
* 이슈
```
> brew cask install java11
Error: Cask java11 exists in multiple taps:
  homebrew/cask-versions/java11
  caskroom/versions/java11
```
* 해결
```
brew untap homebrew/cask-versions
brew untap caskroom/versions
brew tap homebrew/cask-versions
brew cask install java11
```
# 참조사이트
[MacのBrewで複数バージョンのJavaを利用する + jEnv](https://qiita.com/seijikohara/items/56cc4ac83ef9d686fab2)
[Error when trying to install java11 with brew](https://stackoverflow.com/questions/56685440/error-when-trying-to-install-java11-with-brew)
[OpenJDK8をmacにインストールする](https://qiita.com/t-motoki/items/e015950f89e0d17d22d0)
[Homebrew で openjdk8 インストールの巻](https://qiita.com/thankkingdom/items/044df23bc66a2ca67810)