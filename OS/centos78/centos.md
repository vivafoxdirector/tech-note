# CentOS

## 버전확인
```
$> cat /etc/*-release
```

## 날짜 Time 동기화
Centos7~8 이전에는 ntpdate 를 이용하였으나, 폐기가 되고, chrony를 사용함.
```
* 설치
yum install -y chrony
* 기동
systemctl start chronyd.service
* 확인
chrony sources
* 타임존 변경
timedatectl set-timezone Asia/Seoul

```


# 참조사이트
* 시간변경
- [CentOS 7～8 NTP クライアント時刻同期設定](https://server.etutsplus.com/centos-7-chrony-ntp-client/)
- [CentOS7で時間のずれを調整してみた](https://qiita.com/one-kelvin/items/36c59c674a82ff903143)
- [CentOS7の時刻（同期）設定](https://qiita.com/Pirlo/items/c4c23cc1ba2b1d3c0673)