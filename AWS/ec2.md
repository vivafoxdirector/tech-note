# EC2 제어

## EC2 상태 확인
```
aws ec2 describe-instance-status --instance-id i-06e031f2fe9bb288d
```



# 참조사이트
* EC2상태값
- [InstanceState](https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_InstanceState.html)

* EC2 관리
- [Amazon EC2 インスタンスの管理](https://docs.aws.amazon.com/ja_jp/sdk-for-java/v2/developer-guide/examples-ec2-instances.html)
- [今更ながらAWSをAWS SDK for PHPで制御](https://www.nalabo.net/blog/2016/03/07/691)
- [AWS SDK for PHP バージョン 3 を使用した Amazon EC2 インスタンスの管理](https://docs.aws.amazon.com/ja_jp/sdk-for-php/v3/developer-guide/ec2-examples-managing-instances.html)
- [EC2インスタンスを特定の時間に起動・停止](https://qiita.com/ot-nemoto/items/0e148bed48bd0d0900f2)
- [【AWS】EC2をリソースレベルでアクセス許可してみた](https://dev.classmethod.jp/cloud/aws/resource-permissions-for-ec2/)
- [IAM ユーザーのアクセスを特定の Amazon EC2 リソースに制限できますか?](https://aws.amazon.com/jp/premiumsupport/knowledge-center/restrict-ec2-iam/)
- [AWS CLI または AWS SDK で使用するサンプルポリシー](https://docs.aws.amazon.com/ja_jp/AWSEC2/latest/UserGuide/ExamplePolicies_EC2.html#iam-example-runinstances)


## 예제
- [StartStopInstance.java](https://github.com/awsdocs/aws-doc-sdk-examples/blob/master/java/example_code/ec2/src/main/java/aws/example/ec2/StartStopInstance.java)