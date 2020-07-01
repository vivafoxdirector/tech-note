
# CloudFormation
## CloudFormation 기본 작성방법 <==
- [【CloudFormation入門】5分と6行で始めるAWS CloudFormationテンプレートによるインフラ構築](https://dev.classmethod.jp/cloud/aws/cloudformation-beginner01/)

## IAM 롤
- [【AWS】CloudFormationでIAM RoleのPolicy定義に変数を用いる【小ネタ】](https://qiita.com/tmiki/items/5ffcc09a20fb49478835)

## EC2 
- [AWS CloudFormationでEC2を構築](https://qiita.com/tyoshitake/items/c5176c0ef4de8d7cf5d8)

# SG
## Ingress
1. 추가
- [authorize-security-group-ingress](https://docs.aws.amazon.com/cli/latest/reference/ec2/authorize-security-group-ingress.html)

# EC2
## Instance
1. 상태
- [InstanceState](https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_InstanceState.html)
- [Class InstanceState](https://docs.aws.amazon.com/AWSJavaSDK/latest/javadoc/com/amazonaws/services/ec2/model/InstanceState.html#setCode-java.lang.Integer-)
2. 라이프 사이클
- [インスタンスのライフサイクル](https://docs.aws.amazon.com/ja_jp/AWSEC2/latest/UserGuide/ec2-instance-lifecycle.html)

# Region
## 설명서
- [리전, 가용 영역 및 로컬 영역](https://docs.aws.amazon.com/ko_kr/AWSEC2/latest/UserGuide/using-regions-availability-zones.html)



# Instance에 파일 올리기
## local => Bastion
```shell
scp -i [pem파일경로] [업로드할 파일 이름] [ec2-user계정명]@[ec2 instance의 public DNS]:~/[경로]
ex> scp -i d:\bastion.pem [경로/파일명] ec2-user@13.125.211.36:~/[경로/파일명]
```

## Bastion => Server
```shell
scp -i [pem파일경로] [업로드할 파일 이름] [ec2-user계정명]@[ec2 instance의 public DNS]:~/[경로]
ex> scp -i d:\bastion.pem [경로/파일명] ec2-user@13.125.211.36:~/[경로/파일명]
```

# Instance연결
## Bastion => Server
```
ssh -i demo.pem centos@192.168.218.38
```

# 참조사이트
1. VPC 제어
- [VPC作成](https://qiita.com/tcsh/items/41e1aa3c77c469c92e84)

2. SG 제어
- [awscliを使って、VPC向けsecurity groupを作成する](https://reiki4040.hatenablog.com/entry/2014/08/31/200001)
- [[aws cli]セキュリティグループへ一時的にパブリックIPアドレスを追加/削除するスクリプト](https://dev.classmethod.jp/cloud/aws/aws-cli-temporary-allow-access-script/)

3. Security Hub
- [Enabling Seamless Security and Compliance with Sumo Logic and AWS Security Hub](https://aws.amazon.com/ko/blogs/apn/enabling-seamless-security-and-compliance-with-sumo-logic-and-aws-security-hub/)
- [AWS Security Hub](https://aws.amazon.com/jp/security-hub/)

4. Monitoring
- [GitHub Sigar](https://github.com/hyperic/sigar)
- [ホスト メトリクス ソース](https://help.sumologic.jp/03Send-Data/Sources/01Sources-for-Installed-Collectors/Host-Metrics-Source)
