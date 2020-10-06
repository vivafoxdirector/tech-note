# Architecture(20201006)

## 클린 아키텍처

## 람다 아키텍처
빅 데이터를 실시간 분석에 적합한 아키텍처이다. 람다 아키텍처는 스피드 레이어 + 배치 레이어 조합으로 대용량 데이터에도 실시간 분석을 지원해 줄 수 있다.
### 레이어
1. Batch Layer
시간이 오래 걸리는 집계성 데이터 미리 조합하여 만들어 두는 방식을 취한다. 이에 적합한 솔루션은 Apache Hadoop이다.

2. Speed Layer
배치 처리동안의 중간 데이터는 조회하기 어렵다. 당일 당시간에 필요한 데이터는 실시간으로 집계해야 한다. 스피드 레이어는 배치 레이어에서 생기는 갭을 메꾸는 역할을 한다. 이에 적합한 솔루션은 ApacheStorm, ApacheSpark,SQLstream

3. Serving Layer
배치 레이어 및 스피드 레이어의 아웃풋을 저장한다.
클라이언트는 이 서빙 레이어에 미리 계산된 데이터를 조회하기 때문에 빠른 응답이 가능하다.

# 솔루션 역할
- [ニアリアルタイム見える化ソリューション](https://www.hitachi-solutions.co.jp/iot-spf/)
1. 集める: Kafka
2. 貯める: Apache KUDU
3. 処理する: SparkStreaming
4. 見る: kibana


## 카파 아키텍처
람다 아키텍처를 단순화한 아키텍처

# 실시간 분석 패턴
- [실시간 분석](https://azure.microsoft.com/ko-kr/solutions/architecture/real-time-analytics/)

# 빅 데이터 아키텍처
- [빅 데이터 아키텍처](https://docs.microsoft.com/ko-kr/azure/architecture/data-guide/big-data/)

# 참조사이트
## 아키텍처
### 클린아키텍처
- [clean_architecture.md](https://gist.github.com/mpppk/609d592f25cab9312654b39f1b357c60)
### 람다아키텍처
- [Lambda Architecture](http://lambda-architecture.net/)
- [빅데이타 분석을 위한 람다 아키텍쳐 소개와 이해](https://bcho.tistory.com/984)
- [AWS 기반의 대용량 실시간 스트리밍 데이터 분석 아키텍처 패턴](https://www.slideshare.net/awskorea/analysis-architecture-pattern-for-aws-based-high-volume-live-streaming-data-piljoongkim)
- [람다 아키텍처 정리](https://jhleed.tistory.com/122)
- [빅데이터의 실시간 처리와 람다/카파 아키텍처](https://saintbinary.tistory.com/15)
- [람다 아키텍처](https://gyrfalcon.tistory.com/entry/%EB%9E%8C%EB%8B%A4-%EC%95%84%ED%82%A4%ED%85%8D%EC%B2%98-Lambda-Architecture)
- [람다 아키텍처(Lambda Architecture) 가 뭔가](https://medium.com/@gignac.cha/%EB%9E%8C%EB%8B%A4-%EC%95%84%ED%82%A4%ED%85%8D%EC%B2%98-lambda-architecture-%EA%B0%80-%EB%AD%94%EA%B0%80-4d6bd3370f4c)
- [AWSで実現するLambda Architecture](https://qiita.com/RyotaKatoh/items/a4946c64a1ba7e3f66c0)
- [ニアリアルタイム見える化ソリューション](https://www.hitachi-solutions.co.jp/iot-spf/) <==

### 카파아키텍처
- [](https://jhleed.tistory.com/122)

### 람다/카파 아키텍처
- [LambdaからKappaまで：リアルタイムビッグデータアーキテクチャーのガイド](https://www.talend.com/jp/blog/2017/08/28/lambda-kappa-real-time-big-data-architectures/)
- [람다/카파](http://blog.skby.net/%EB%9E%8C%EB%8B%A4-%EC%B9%B4%ED%8C%8C-%EC%95%84%ED%82%A4%ED%85%8D%EC%B2%98/)
## 솔루션
1. Voldmort
- [](https://www.slideshare.net/laclefyoshi/voldemort-62602490)