
* 시작
```shell
$> systemctl start firewalld.service
```

* 종료
```shell
$> systemctl stop firewalld.service
```

* 상태
```shell
$> systemctl status firewalld.service
$> firewall-cmd --state
```

* 서비스 자동 유효화
```shell
$> systemctl enable firewalld.serivce
```
* 서비스 자동 무효화
```shell
$> systemctl disable firewalld.serivce
```

* 추가된 포트번호 확인
```shell
$> firewall-cmd --list-ports --zone=public
```

* 추가된 포트번호 추가
```shell
$> firewall-cmd --add-port=8080/tcp --zone=public
$> firewall-cmd --add-port=60000/udp --zone=public

```

* 참조
- [CentOS 7 firewalld よく使うコマンド](https://qiita.com/kenjjiijjii/items/1057af2dddc34022b09e)
- [CentOs8 Firewallコマンド](https://mebee.info/2019/10/17/post-2369/)
- [サーバー構築の基本 CentOS Linux 8のインストール後に設定する12の項目](https://www.rem-system.com/centos8-first-settings/#2_selinux)