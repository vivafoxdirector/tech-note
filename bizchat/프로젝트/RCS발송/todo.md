# TODO
## 개발
- [] mmate-api를 로컬로 실행 방법 서치
- [] RabbitMQ 개념 및 사용방법
- [] Redis 개념 및 사용방법

## 요청 과제
- [X] 두 분께 개발기 DBMS 접근권한 부여 중입니다. 금일 중으로 작업완료 됩니다. 사용법은 첨부 참고하세요.
- [X] RCS 메시지 편집기로 제작한 RCS CONTENTS는 기존 MMS CONTENTS와 유사하게 DB 및 NAS에 나누어 저장해야 합니다.
- [] 개발 관련해서는 신규 Repository를 생성하지 마시고, 기존 mmate-web 및 mmate-admin에 feature branch를 생성하여 구현을 진행 해주시기 바랍니다.
    - rcs client 프로젝트가 필요해 보이고, 관련 신규 Repository가 필요해 보임..
    - RCS의존하는 모든 프로젝트들에 대한 수정이 필요해 보임.(MSG Status/Type등등, MSG분기처리)
- [] RCS CONTENTS를 어떤 방법으로 기존 DB TABLE과 신규 DB TABLE에 나누어 저장하실 것인지에 대한 계획을 미리 준비해서 설명해 주세요.


### 변경사항
1. DB사용
1. SMS/MMS 등록
INSERT: SURVEY
    -> *INSERT: SURVEY_TRGTER
    -> +UPDATE: SURVEY_TRGTER
    -> +INSERT: SURVEY_QUST
    -> *INSERT: SURVEY_COUPON (화면 하단의 쿠폰1~ 입력)
    -> +DELETE: SURVEY_COUPON
    -> *INSERT: SURVEY_ANS

1. RCS 등록
INSERT: SURVEY ()
    -> *INSERT: SURVEY_TRGTER
    -> +UPDATE: SURVEY_TRGTER
    -> *INSERT: SURVEY_QUST
    -> *INSERT: SURVEY_COUPON 
    -> +DELETE: SURVEY_COUPON
    -> *INSERT: SURVEY_ANS

### 기존 구조
1. 구조
SurveyVO:SURVEY_QUST = 1:n
SURVEY : MT_SND_REQ : mtMsgQueue = 1 : n : n
=> 결국 QUEUE에 들어가는것은 한 설문에 여러 수신자만큼 QUEUE들어간다.

### 고려사항
설문SEQ 하나에 일반설문, RCS설문이 되어야 하나...
설문1개당 1개의 설문으로 하자... 일반/RCS는 SURVEY테이블을 참조하고, RCS세부정보는 SURVEY_RCS테이블을 이용하자..

1. 설문등록
* SurveyVO에 RCS용 멤버 변수(설문동의 메시지/설문)를 추가하고, RCS용도용 테이블 하나 추가하자
* RCS는 SURVEY_QUST를 사용하지 않는다.
* RCS도 SURVEY_SEQ를 가지도록 한다.
* RCS추가 테이블(2개)외의 정보는 SURVEY를 공유한다.

* 등록시 테이블
    * RCS 슬라이드별 정보(SURVEY_SEQ 1개당 최대 6개 슬라이드)
    SURVEY_RCS(
        RCS_SEQ,                // AUTO INC
        SURVEY_SEQ,             // SURVEY_SEQ
        RCS_AGRE_TITLE_MSG,     // 설문동의 메시지
        RCS_AGRE_GUIDE_MSG,     // 설문 메시지
        RCS_AGRE_IMG_FILE_PATH, // 설문동의 이미지 (슬라이드이미지)
    )

    * 슬라이드별 버튼정보(최대 2개)
    SURVEY_RCS_BTN(
        RCS_BTN_SEQ,
        RCS_SEQ,
        BTN_TYPE,       // URL/전화걸기/지도 보여주기
        BTN_NAME,       // 버튼명
        BTN_URL,        // URL
        BTN_PNUM,       // 전화번호
        BTN_GEO_NAME,   // 
        BTN_GEO_URL
    )

3. ADMIN에서 승인
RCS도 별도의 SEQ로 관리 되므로 고민되어야할 구조는 없어보인다.

4. 스케쥴러 10분
* AsIS
    - 기존 LMS/MMS 분기처리후 MSGQ에 전달한다.
    - 타겟(받는폰번호)별로 번호 할당하고 SND_MSG(MSG_TP: LMS/MMS) / SND_ATTFILE 에 저장한다.
        - ★ 여기서 RCS인경우 저장하도록 하자!!
    - SURVEY는 RUNNING으로 변경

5. 스케쥴러 3분
* AsIS-MMS
    - SND_MSG 에서 MMS이고, SURVEY_SEQ인 리스트 취득 (SEQ하나당 대상자가 많다. 10분 스케쥴에서 처리했음)
    - 타겟(받는폰번호)별로 번호 할당하고 SND_MSG(MSG_TP: LMS/MMS) / SND_ATTFILE 에 저장한다.
        - ★ 여기서 RCS인경우 저장하도록 하자!!
    - SURVEY는 RUNNING으로 변경
    
파일 저장장소:
MtMessageService::saveSendMessage 에서
IMG_ROOT/mt/rcs/이하로 한다.

file.save.root.path = IMG_ROOT
    





# 질문사항
1. AsIS 설문제작 1건마다 DB에서는 SURVEY_SEQ 1개가 부여된다. 
RCS 설문제작 화면요건을 보면은 일반/RCS로 나뉘어져 있다. 이럴때는 SURVEY_SEQ가 2건으로 해야하는지.. 1건으로 해야하는지..
1건으로 처리하게 되면 사이드 이펙트가 발생될 여지가 있어보인다. (소스를 일일이 확인해서 이슈사항이 없는지 조사 필요)
우선 별도로 처리한다면 설문제작 화면에서 임시저장/불러오기를 하게되면 2건(일반/RCS)을 불러오게 된다. (화면 수정필요)

2. 테이블 스키마
SND_MSG


0. 가정
SURVEY 는 그대로 둔다.
SURVEY_RCS 새로 생성
SURVEY_RCS_BTN 새로 생성

1. RCS용 QUEUE생성
MT_MMS_SKT

1. MtMsgQueueVO'
기존 MtMsgQueueVO를 RCS용 멤버변수를 추가하여 MtMsgQeueuVO'만든다.
이는 



MtMessageService::saveSendMessage 에서 RCS분기 처리를 하도록 한다.
- MT_MSG_QUEUE 테이블 수정
    - RCS구분자 기입(MsgTp)
    - RCS용 컬럼추가
        - 복수의 타이틀/내용 기입 (암호여부)

- FILE 디렉토리
    - IMG_ROOT=file.save.root.path 프로퍼티 지정된 디렉토리 이하에 위치한다.
        - IMG_ROOT/mt/rcs/
            예) IMG_ROOT/mt/rcs/[설문커스텀ID]/yyyyMMdd/[설문SEQ]/


# RCS 플로우 및 RCS기능 추가
1. mmate-web
- RCS설문 등록
    - 기존 설문 테이블 SURVEY는 사용하고, 슬라이드와 버튼정보는 새로운 테이블에 저장한다. (SURVEY_RCS/SURVEY_RCS_BTN)
    - 설문상태 REGISTER 로 바꾸고 DB저장한다.

2. mmate-admin
- RCS설문 승인
    - 설문상태 APPR

3. mmate-survey-agent
- 배치(10분)
    - 설문상태 APPR을 조회하고 발송대상자별로 메시지(SND_MSG) 저장한다.
    - 설문상태 APPR을 RUNNING으로 한다.

- 배치(3분)
    - 설문상태 RUNNING을 조회하고한다.
    - RUNNING설문 하나당 메시지(SND_MSG)를 조회하고별로 이정보를 이용하여 큐메시지(MtMsgQueueVO)를 만든다.        
        - MtMsgQueueVO 작성시 RCS용도인 경우 처리를 하도록 한다.
            - RCS관련 정보를 조회하여 MtMsgQueueVO'를 작성하여 MQ 전달 정보를 만든다.
    - MQ:MT_MGR_REQUEST 로 MQ 전달

4. mmate-mt-mgr 모듈
- MQ:MT_MGR_REQUEST 수신후 RCS 분기처리 추가
- RCS SKT CLIENT에 MtMsgQueueVO'

5. mmate-rcs-sk 새모듈
- MQ:MT_MMS_SKT 를 통해 들어오는 message를 이용하여 MtMsgQueueVO' 를 DB(MT_MSG_QUEUE_RCS/MT_MSG_QUEUE_RCS_BTN)를 통해 가져온다.
- MtMsgQueueVO'에서 RCS정보/이미지 정보를 담은 별도의 VO를 만든다.
- 위 별도의 VO를 Delevery용으로 변환후 단말에 포맷에 맞추어 전송한다.

## 추가 테이블
* RCS 슬라이드별 정보(SURVEY_SEQ 1개당 최대 6개 슬라이드)
CREATE TABLE SURVEY_RCS(
    RCS_SEQ,                // AUTO INC
    SURVEY_SEQ,             // SURVEY_SEQ
    RCS_AGRE_TITLE_MSG,     // 설문동의 메시지
    RCS_AGRE_GUIDE_MSG,     // 설문 메시지
    RCS_AGRE_IMG_FILE_PATH, // 설문동의 이미지 (슬라이드이미지)
)

* 슬라이드별 버튼정보(최대 2개)
CREATE TABLE SURVEY_RCS_BTN(
    RCS_BTN_SEQ,
    RCS_SEQ,
    BTN_TYPE,       // URL/전화걸기/지도 보여주기
    BTN_NAME,       // 버튼명
    BTN_URL,        // URL
    BTN_PNUM,       // 전화번호
    BTN_GEO_NAME,   // 
    BTN_GEO_URL
)

* 방법고찰
1. MT_MSG_QUEUE 에 RCS관련 전체 정보를 담는방법
2. MT_MSG_QUEUE 에 더해서 RCS용도 신규테이블 MT_MSG_QUEUE_RCS, MT_MSG_QUEUE_RCS_BTN 을 사용하는 방법

* 새로 테이블을 작성하는 방법으로 한다.
```SQL
-- RCS 슬라이드 정보
CREATE TABLE MT_MSG_QUEUE_RCS(
    QUEUE_RCS_ID NUMBER(18) NOT NULL, 
    MT_QUEUE_ID NUMBER(18) NOT NULL,
    RCS_AGRE_TITLE_MSG VARCHAR2(4000) NULL,
    RCS_AGRE_GUIDE_MSG CLOB NULL,
    RCS_AGRE_IMG_FILE_PATH VARCHAR2(500) NULL
)
CREATE UNIQUE INDEX PK_MT_MSG_QUEUE_RCS ON MT_MSG_QUEUE_RCS
(QUEUE_RCS_ID ASC);
ALTER TABLE MT_MSG_QUEUE_RCS
	ADD CONSTRAINT  PK_MT_MSG_QUEUE_RCS PRIMARY KEY (QUEUE_RCS_ID);

-- RCS 슬라이드별 버튼정보
CREATE TABLE MT_MSG_QUEUE_RCS_BTN(
    QUEUE_RCS_BTN_ID NUMBER(18) NOT NULL,
    QUEUE_RCS_ID NUMBER(18) NOT NULL,
    BTN_TYPE,       // URL/전화걸기/지도 보여주기
    BTN_NAME,       // 버튼명
    BTN_URL,        // URL
    BTN_PNUM,       // 전화번호
    BTN_GEO_NAME,   // 
    BTN_GEO_URL    
)
CREATE UNIQUE INDEX PK_MT_MSG_QUEUE_RCS_BTN ON MT_MSG_QUEUE_RCS_BTN
(QUEUE_RCS_BTN_ID ASC);
ALTER TABLE MT_MSG_QUEUE_RCS_BTN
	ADD CONSTRAINT  PK_MT_MSG_QUEUE_RCS_BTN PRIMARY KEY (QUEUE_RCS_BTN_ID);
```

## 파일저장
- FILE 디렉토리
    - IMG_ROOT=file.save.root.path 프로퍼티 지정된 디렉토리 이하에 위치한다.
        - IMG_ROOT/mt/rcs/
            예) IMG_ROOT/mt/rcs/[설문커스텀ID]/yyyyMMdd/[설문SEQ]/














# 이전자료
# TODO
* RCS용 파일은 어디에 저장할 것인가?
* RCS용 임시보관/이전 설문 불러오기 작업

* 설문 등록할때 SURVEY 입력은 일반/RCS VO하나로 할것인가.. 따로 할 것인가...
우선은 이를 나중에 고민하고.. 등록 이후 처리를 고민..

- SURVEY 하위에 관리되는 테이블을 만들것인가?
- SURVEY/RCS_SURVEY 를 관리하는 테이블을 만들 것인가.



## TODO
- [X] 두 분께 개발기 DBMS 접근권한 부여 중입니다. 금일 중으로 작업완료 됩니다. 사용법은 첨부 참고하세요.
- [X] RCS 메시지 편집기로 제작한 RCS CONTENTS는 기존 MMS CONTENTS와 유사하게 DB 및 NAS에 나누어 저장해야 합니다.
- [] 개발 관련해서는 신규 Repository를 생성하지 마시고, 기존 mmate-web 및 mmate-admin에 feature branch를 생성하여 구현을 진행 해주시기 바랍니다.
    - rcs client 프로젝트가 필요해 보이고, 관련 신규 Repository가 필요해 보임..
    - RCS의존하는 모든 프로젝트들에 대한 수정이 필요해 보임.(MSG Status/Type등등, MSG분기처리)
- [] RCS CONTENTS를 어떤 방법으로 기존 DB TABLE과 신규 DB TABLE에 나누어 저장하실 것인지에 대한 계획을 미리 준비해서 설명해 주세요.
    - 현재까지 SMS/MMS같이 메시지 타입별로 테이블을 관리하고 있지 않고, 하나의 테이블에 타입으로 구분되어 사용되고 있음.. RCS를 추가하게 되면 테이블이 추가 되는것이 아닌
      컬럼이 메타정보에 따라 추가될 수 있을것으로 보임. (관련테이블: ) ※ ..ing 이부분 상세 조사 필요

- [] 연동 API 규격은 여기서 보실 수 있습니다.  https://app.swaggerhub.com/apis/MaaP_KR/RCS_Biz_Center/1.1.1
- [] 발송 API 규격은 이것 입니다. https://app.swaggerhub.com/apis/MaaP_KR/MaaP_FE_KR/1.1.6
- [] RCS스팩문서 속독
   - 5.1. 챗봇메시지가이드_BestCase_191115
   - 20200630_포멧_리스트_v11.3_메시지_밸리데이션_포함
   - RCC.07-v11.0

- [] RCS 시나리오/도메인 분석
- [] 통계 처리
- [] RCS 설계(워크 플로우/스펙) 착수
- [] RCS 프로젝트 생성

- [X] 이번 프로젝트 범위 (설문/통계/리포트)
- [X] 기존 운영업체가 언제까지인가? 11월 말? (형상관리 관련)