# Network ACL 제어
NACL 룰 규칙 개수는 인바운드 20개, 아웃바운드 20개까지 입력이 가능하다.
```
API 오류 메시지
The maximum number of network acl entries has been reached.
```

## 네트워크 ACL 확인(필터)
```
$ aws ec2 describe-network-acls
$ aws ec2 describe-network-acls --filters Name=vpc-id,Values=vpc-5af90631
```

## 네트워크 ACL 규측 추가
- AWS규칙 여러건 추가는 아직 안됨.
- aws_cli를 통해서 AWS규칙에 rule-number 100이 이미 있으면 오류가 나지만, SDK에서는 나지 않는다.
- AWS규칙에 rule-number 는 겹치지 않고 정보가 다른 룰과 같다면 추가는 된다.


After you add an entry, you can't modify it; you must either replace it, or create an entry and delete the old one. (추가후 수정은 안되고, 치환하거나 새로 추가하거나 삭제를 해야한다)

```
$ aws ec2 create-network-acl-entry --network-acl-id acl-5fb85d36 --ingress --rule-number 100 --protocol udp --port-range From=53,To=53 --cidr-block 0.0.0.0/0 --rule-action allow

$ aws ec2 create-network-acl-entry --network-acl-id acl-07a73a4670ecc60db --ingress --rule-number 130 --protocol tcp --port-range From=9090,To=9090 --cidr-block 0.0.0.0/0 --rule-action allow

$ aws ec2 create-network-acl-entry --network-acl-id acl-0021a5439745e848c --ingress --rule-number 130 --protocol tcp --port-range From=9090,To=9090 --cidr-block 0.0.0.0/0 --rule-action allow

프로토콜은 tcp, udp등 문자열도 되고, 번호도 된다. (번호로 해야할 듯하다)
$ aws ec2 create-network-acl-entry --network-acl-id acl-0021a5439745e848c --ingress --rule-number 140 --protocol 6 - -port-range From=9090,To=9090 --cidr-block 0.0.0.0/0 --rule-action allow

$ aws ec2 create-network-acl-entry --network-acl-id acl-0b4a4b4092295d2e4 --ingress --rule-number 102 --protocol udp --port-range From=53,To=53 --cidr-block 0.0.0.0/0 --rule-action allow
```



## 네트워크 ACL 규칙 수정
기존의 룰 규칙 번호 수정이다.
```
$ aws ec2 replace-network-acl-entry --network-acl-id acl-5fb85d36 --ingress --rule-number 100 --protocol udp --port-range From=53,To=53 --cidr-block 203.0.113.12/24 --rule-action allow

$ aws ec2 replace-network-acl-entry --network-acl-id acl-07a73a4670ecc60db --ingress --rule-number 100 --protocol tcp --port-range From=8080,To=8080 --cidr-block 0.0.0.0/0 --rule-action allow
```


## 네트워크 ACL 규칙 삭제
```
$ aws ec2 delete-network-acl-entry --network-acl-id acl-5fb85d36 --ingress --rule-number 100

$ aws ec2 delete-network-acl-entry --network-acl-id acl-07a73a4670ecc60db --ingress --rule-number 100
```

# 참조사이트
## 네트워크 ACL 의 사용 설명서
- [네트워크 ACL](https://docs.aws.amazon.com/ko_kr/vpc/latest/userguide/vpc-network-acls.html) <==

## ACL 명령어 개요
VPC에 대한 네트워크 ACL만들기
* [create-network-acl](https://docs.aws.amazon.com/cli/latest/reference/ec2/create-network-acl.html)

한개 이상의 네트워크 ACL에 대해 설명
* [describe-network-acls](https://docs.aws.amazon.com/cli/latest/reference/ec2/describe-network-acls.html)

네트워크 ACL 규칙 추가
* [create-network-acl-entry](https://docs.aws.amazon.com/cli/latest/reference/ec2/create-network-acl-entry.html)
* [CreateNetworkAclEntry](https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_CreateNetworkAclEntry.html)
* [Interface AmazonEC2 - Ver 1.0](https://docs.aws.amazon.com/AWSJavaSDK/latest/javadoc/com/amazonaws/services/ec2/AmazonEC2.html#createNetworkAclEntry-com.amazonaws.services.ec2.model.CreateNetworkAclEntryRequest-)

네트워크 ACL 규칙 기존 규칙 바꾸기
* [replace-network-acl-entry](https://docs.aws.amazon.com/cli/latest/reference/ec2/replace-network-acl-entry.html)

네트워크 ACL 규칙 삭제
* [delete-network-acl-entry](https://docs.aws.amazon.com/cli/latest/reference/ec2/delete-network-acl-entry.html)

네트워크 ACL 연결 바꾸기
* [replace-network-acl-association](https://docs.aws.amazon.com/cli/latest/reference/ec2/replace-network-acl-association.html)

네트워크 ACL 삭제
* [delete-network-acl](https://docs.aws.amazon.com/cli/latest/reference/ec2/delete-network-acl.html)

## AWS
- [AWS CLI Command Reference](https://docs.aws.amazon.com/ko_kr/cli/latest/index.html)
- [](https://qiita.com/t-fujiwara/items/835cccbef7ec6d199251)

## NACL 제어(블로그)
- [AWS NACLの設定をCLIから行ってみた](http://kimutansk.hatenablog.com/entry/2015/09/23/081022)

## NACL 제어 API
- [CreateNetworkAclEntry](https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_CreateNetworkAclEntry.html)
- [API](https://docs.aws.amazon.com/AWSJavaSDK/latest/javadoc/com/amazonaws/services/ec2/AmazonEC2.html#createNetworkAclEntry-com.amazonaws.services.ec2.model.CreateNetworkAclEntryRequest-)
- [Example](https://docs.aws.amazon.com/ja_jp/sdkfornet/v3/apidocs/items/EC2/MEC2CreateNetworkAclEntryCreateNetworkAclEntryRequest.html)


## 자동NACL부여하기 블로그
- [AWS에서 네트워크 공격 자동차단 하기](http://woowabros.github.io/security/2018/02/23/aws-auto-security1.html)