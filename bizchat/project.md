# RCS from SKP
# RCS?
## RCS??
- [RCS（Rich Communication Services）とは](https://k-tai.watch.impress.co.jp/docs/column/keyword/1108597.html)

## 기사내용
- [RCS기반 기업메세징으로 변화하다](http://www.hkbs.co.kr/news/articleView.html?idxno=589534)
- [통신 3사 “‘채팅+’ 기반 RCS 활용한 기업 메시징 상품 첫 출시”](http://www.segye.com/newsView/20200915515084?OutUrl=daum)

# 소스분석
## 3rd파티
1. RabbitMQ
    - erlang 설치(https://www.erlang.org/downloads)
2. Redis
3. Spring
4. myBatis
5. GSON
6. Site Mesh

# 프로젝트 개요
## Application
1. Web: 웹페이지(상품소개, 서비스관리,리포트,구매,이벤트,고객센터,마이페이지)
    - MobileWeb Hosting
2. Admin: 메시지 관리 & 통계: (알림비즈챗/CS비즈챗/마케팅비즈챗, 통계), 고객사관리, 운영 관리:(공지사항 관리, FAQ관리, 1:1문의, 다운로드 관리, 이벤트관리), 과금현황(전체/상품별현황, 특번과금현황), 서비스 관리(CID관리, 특번관리, 상품관리, 모바일웹 관리), 관리자 & 관리자 권한 관리
3. OpenAPI: 고객사가 비즈챗 서버로의 MT(발송)/MO(수신) 제공(동보 전송, 전송 결과조회, 전송결과 Noti)

## 내부 프로세스
1. MT Manager: Open API와 SMS/MMS Client 프로세스간 통신 중계, SMS,MMS서버로부터 전송결과 수신 및 MO수신시 Open API서버로 중계
2. SKT SMS Client(SKT VSMSS서버와 연동)
    - SKT VSMSS 서버로의 SMS MT 발송/MO 수신
3. SKT MMS Client(SKT VMG 서버 및 tRelay서버와 연동)
    - SKT VMG 서버로의 LMS/MMS MT발송 및 전송결과 수신
    - SKT tRelay 서버로부터 LMS/MMS MO 수신
4. Batch: crontab구동, 통계집계, 사용금액 정산등, 메시지관리, 리포트, 과금/정산, 특번관리, 사용자 관리
6. Agent: 

# 프로젝트 분석
## MO/MT 설명
MT: (서버 -> 사용자) 발송
MO: (사용자 -> 서버) 수신
- [X][BizChat] 기술규격서_v1.0
- [X][BizChat] 운영자 매뉴얼_v0.1.

## 서비스 시나리오(플로우)
- [X][BizChat] 기술규격서_v1.0
- [X][BizChat] 상위 설계서

## Queue플로우
- [X][BizChat] 상위 설계서

## 전문포맷
- [X][BizChat] Open API 연동 규격서_v0.9

## 메시지 상태
- [X][BizChat] 상위 설계서
CommonCode.MessageStatus

## 메시지 발송(MT)
0. RabbitMQListener/Template 생성
SpringMessageQueueConfig 에서 생성한다.

1. SMS 발송 요청(MQ발송 요청/DB요청 데이터 저장)
① (MT플로우 그림에서 6번까지이다)
MtController::sendSms->MtSendReqService::createMtSmsSndReq->MtMapper::insertMtSndReq->INSERT(MT_SND_REQ)
                                                          ->MtMapper::insertMtMsgQueue->INSERT(MT_MSG_QUEUE)
                     ->ApiSender::sendMtMgrRequest-> MSG_STATUS(WAIT) -> MQ:PUSH
② (MT매니저-요청 플로우 그림 7번까지)
MtMgrRequestQueueListener::onMessage -> MSG_STATUS(WAIT)
                    -> MtMgrService::modifyMtMsgQueue(메시지 상태변경) -> UPDATE(MT_MSG_QUEUE)
                    -> RlcAgentService::saveInfoBackMtMessage (Agent 경유)
                    -> MtMgrService::sendMsgReq (메시지별 직접 통신사 송신)
                        -> SMS:MtSmsSender::sendMtSmsSktRequest -> MSG_STATUS(WAIT) -> MQ:PUSH
                        -> LMS:MtMmsSender::sendMtMmsSktRequest -> MSG_STATUS(WAIT) -> MQ:PUSH
                        -> MMS:MtMmsSender::sendMtMmsSktRequest -> MSG_STATUS(WAIT) -> MQ:PUSH

②-1 (통신사 SMS클라이언트 수신)
...ing...

③ (MT매니저-수신 플로우 그림 8번)
MtMgrResultQueueListener::onMessage 
                    -> MtMgrService::searchOpenApiSendResultNotification (DB 전송결과조회)


# 프로젝트 아키텍쳐 지식
1. Rabbit MQ
2. Redis
- 위치: D:\work\project\비즈쳇\svn\trunk\document\05.산출물\최종 검수\04.개발

## Open API
* [BizChat] Open API Agent 매뉴얼_v0.9
트랜잭션별 시스템 플로우가 기술되어 있다.

* [BizChat] Open API 연동 규격서_v0.9
전문에 관한 상세 내용 기술되어 있다.
    - bizchat-access-key 라는것을 HTTP헤더에 포함되어야 한다.
    => MtController.java/OpenApiCommonFilter.java

## 전체 플로우
[BizChat] 기술규격서_v1.0
[BizChat] 상위 설계서

## RabbitMQ/Redis구성
D:\work\project\비즈쳇\svn\trunk\document\03.구현\인수인계
## 스키마/테이블
D:\work\project\비즈쳇\svn\trunk\document\02.설계\01.erd

### 고려사항
1. SMS 요청시 먼저 dofilter에서 인증을 한다. 인증 절차는 CashServer(redis)에 접근해서 조회한다. 
=> 여기서 redis의 스키마는 CustomerInfo.java 이다 (customerRepository)

2. SMS 송신시 메시지 큐에 넣고 큐에있는것을 가져오는 것은
MtMgrRequestQueueListener.java 가 하는듯하다.

## 소스 분석
1. MSGQUEUE상태 업데이트
mt.sqlmap.xml:updateMtMsgQueue
MmsSendManager::callBackResponse

## 라이브러리 사용
1. sitemesh사용(mmate-web)
- [초기설정 방법 & 설정](https://airlueos.tistory.com/127)
- [Sitemesh 설정, 사용방법](https://cofs.tistory.com/273)


# 개발영향
## 수정프로젝트
1. mmate-mq
QueueName 수정, RCS관련 Queue 클래스 추가

## git branch
```
-- 리모트 반영
mmate-web
git push origin feature/BIZCHAT-1070

mmate-admin
git push origin feature/BIZCHAT-1070

mmate-mt-mgr
git push origin feature/BIZCHAT-1070

mmate-survey-agent
git push origin feature/BIZCHAT-1070

mmate-common
git push origin feature/BIZCHAT-1070

mmate-cache
git push origin feature/BIZCHAT-1070

mmate-mq
git push origin feature/BIZCHAT-1070
```

# 참조
## Spring AMQP 참조
- [Spring AMQP](https://spring.io/projects/spring-amqp#overview)
- [Spring AMQP Sample](https://github.com/spring-projects/spring-amqp-samples)
- [Spring AMQPの使い方](https://blog.mookjp.io/memo/spring-amqp%E3%81%AE%E4%BD%BF%E3%81%84%E6%96%B9/)
- [Spring-AMQPとRabbitMQことはじめ(随時更新)](https://qiita.com/alpha_pz/items/9d44c65cc1c470080064)
- [RabbitMQ でメッセージング](https://spring.pleiades.io/guides/gs/messaging-rabbitmq/)
- [SpringBootでRabbitMQ](https://qiita.com/MariMurotani/items/d87055dbafa11a5f23b0)
- [Spring Boot AMQP](https://spring.io/projects/spring-amqp#overview) <== Template

## Redis 참조
- [【入門】Redis](https://qiita.com/wind-up-bird/items/f2d41d08e86789322c71)
- [SpringBoot + Redis 簡単に作るデモ](https://qiita.com/Hyman1993/items/4ae9bc500f5b5cdfa095)
- [Spring Data Redisの紹介](https://www.codeflow.site/ja/article/spring-data-redis-tutorial)

## Netty 참조
Netty (SKT Client Channel) 
- [Nettyの紹介](https://www.codeflow.site/ja/article/netty)

## Tika 참조
- [Apache Tika](https://tika.apache.org/)