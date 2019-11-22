# Linux 설치
## 최신 갱신
```shell
$> yum update
$> yum upgrade
```

## Docker설치
1. 공식 레포지토리 설치
```shell
$> yum install -y yum-utils device-mapper-persistent-data lvm2
$> yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
```

2. DOCKER CE 설치
```shell
$> yum install -y docker-ce docker-ce-cli containerd.io
```

2. DOCKER 기동
- 도커 기동
```shell
$> systemctl start docker
```
- OS기동시 시작
```shell
systemctl enable docker
```

# CentOS8 설치
- [Installing Docker on CentOS 8](https://www.vadmin-land.com/2019/09/installing-docker-on-centos-8/)

## 버전확인
```
$> cat /etc/*-release
```

## 업데이트
```
$> dnf update -y
```
## 필요 패키지 설치
```
$> sudo yum install -y yum-utils device-mapper-persistent-data lvm2
```

## 레포지토리 등록
```
$> sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
```

## 인스툴 가능한 docker확인
```
$> dnf list docker-ce --showduplicates | sort -r
```

## 도커 설치
1. 버전 확인후 설치
```
$> sudo dnf install -y docker-ce-3:18.09.1-3.el7
```

2. 확인 없이 최근 버전 설치
```
$> sudo dnf -y install docker-ce --nobest
```

## 도커 실행 및 기동등록
```
$> sudo systemctl start docker && sudo systemctl enable docker
```

## 도커 정상 동작 테스트
```
$> sudo docker run alpine
```

## 도커그룹 설정 하고 유저 추가하고 실행
1. 도커그룹 추가
```
$> sudo usermod -aG docker $(whoami)
ex> sudo usermod -aG docker mourad
$> id murad
```

2. sudo 없이 실행
```
$> docker run nginx
```

## 도커삭제
```
$> sudo dnf remove docker-ce
$> sudo rm -rf /var/lib/docker
```

# 참고사이트
- [Install Docker on CentOS 7](https://qiita.com/ymasaoka/items/b6c3ffea060bcd237478)
- [Installing Docker on CentOS 8](https://www.vadmin-land.com/2019/09/installing-docker-on-centos-8/)
