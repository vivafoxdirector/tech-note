# AIX

## 디렉토리 용량 확인
```shell
$> du -sm /opt
$> du -sk /opt
```
※k=1kbyte m=1Mbyte

## 현재 디렉토리 이하의 용량 확인
```shell
$> du -m | egrep -v /.+/
```

# curl
* POST
```
curl -X POST -H "Content-Type: application/json" -d '{"Name":"sensuikan1973", "Age":"100"}' localhost:8080/api/v1/users
```

* POST HEADER
curl -X POST -H "Content-Type: application/json" -F 'q={"key":{"code":"auth"},"value":[{"agent_dt":"2020-06-10 17:51:19","cyper_suite_id":"","host_nw_private_ip_addr":"192.168.218.38","lic_id":"11","lic_type":"1","lic_cnt":"1000","version":"0.9.1","ni_dtl_mac":"0a:2e:c6:fa:11:90","sub_dtl_cidr":"172.31.0.0/16"}]}' localhost:8080/agent/auth.ona

curl -X POST -F 'q={"key":{"code":"auth"},"value":[{"agent_dt":"2020-06-10 17:51:19","cyper_suite_id":"","host_nw_private_ip_addr":"172.31.47.251","lic_id":"11","lic_type":"1","lic_cnt":"1000","version":"0.9.1","ni_dtl_mac":"0a:47:8e:9b:fb:4e","sub_dtl_cidr":"172.31.0.0/16"}]}' localhost:8080/agent/auth.ona



curl -X POST -F 'q={"key":{"code":"auth"},"value":[{"agent_dt":"2020-06-10 17:51:19","cyper_suite_id":"","host_nw_private_ip_addr":"192.168.218.180","lic_id":"11","lic_type":"1","lic_cnt":"1000","version":"0.9.1","ni_dtl_mac":"0a:2e:c6:fa:11:90","sub_dtl_cidr":"172.31.0.0/16"}]}' 192.168.218.38:7080/agent/auth.ona


curl -X POST http://192.168.218.38:7080/agent/auth.ona


curl http://192.168.218.38:7080/agent/auth.ona

```

# wget
* 디렉토리 지정
```
wget http://xxx.com/hoge.tar.gz -P /tmp
```
- [wgetの使い方いろいろ](https://qiita.com/katsukii/items/ef251830776cbe108cfb)

# curl
1. [curl コマンド 使い方メモ](https://qiita.com/yasuhiroki/items/a569d3371a66e365316f)
2. [curlコマンドでGET/POSTをサクっと確認](https://qiita.com/tkj/items/7556afb0086fe35551ce)
3. [【curl】超入門(GET/POST/PUT/DELETEでリクエスト)[LINUX]](https://qiita.com/takuyanin/items/949201e3eb100d4384e1)

# jq
2. [jq コマンドの Linux への速攻インストール](https://qiita.com/wnoguchi/items/70a808a68e60651224a4)
1. [jq コマンドを使う日常のご紹介](https://qiita.com/takeshinoda@github/items/2dec7a72930ec1f658af)

# 참고
* 내용: 디렉토리 용량
  * 참조: http://d.hatena.ne.jp/aix_memo/20090206/1233886385
- [初心者向けシェルスクリプトの基本コマンドの紹介](https://qiita.com/zayarwinttun/items/0dae4cb66d8f4bd2a337)
