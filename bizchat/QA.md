# 20201016
부장님, 유찬석입니다.
개발기에 사번 로그인 하셔서 쉘 상에서
sudo su - tomcat
명령을 수행하시면 tomcat 로그인이 됩니다.
비번을 물어보면 본인 계정 비번과 동일합니다.

# 20201016
아래 제가 드린 답변에 빠진 내용이 있었네요.
업무에 참고하시기 바랍니다.

1. RCS발송에 따른 염두해 두어야 할 도메인 정보(스팩)가 있는지?
==> 첨부 문서 참고하시기 바랍니다.
==> 연동 API 규격은 여기서 보실 수 있습니다. https://app.swaggerhub.com/apis/MaaP_KR/RCS_Biz_Center/1.1.1
발송 API 규격은 이것 입니다. https://app.swaggerhub.com/apis/MaaP_KR/MaaP_FE_KR/1.1.6

# 20201013
1. 9월 회의록을 살펴보니 아래와 같은 내용이 있었습니다.
- RCS관련 스켈레톤 코드 지원 부분에 대해서 지원 받을 수 있는지요?
- [/wizardlab.co.kr/mail/webmail/cid_img_view/110940448/gabiahiworkscid0]
==> RCS 메시지 발송기 prototyping 일정이 10월말까지 입니다. 그 이후에 skeleton 코드 지원 가능합니다.
==> Skeleton 코드는 메시지 Queue를 통해 접수한 전송 요청을 DB를 조회하여 메시지를 제작하고, REST API 호출을 하여 전송을 하며, 응답에 대한 결과처리를 하는 것까지 포함합니다.
==> 차주에는 RCS 시험발송을 시도해보고, 성공하면 발송만 되는 TEST 코드 공유해드릴 예정입니다.
==> Skeleton 코드는 기존 MMS 발송기와 구조가 유사하니, 기존 코드의 동작을 미리 학습하시라고 요청 드린 겁니다.
==> 또 SKT QA용 RCS와는 빨라야 11월 초에 실제 연동시험 가능한 상황입니다.
2. RCS발송에 따른 염두해 두어야 할 도메인 정보(스팩)가 있는지?
==> 첨부 문서 참고하시기 바랍니다.
==> 연동 API 규격은 여기서 보실 수 있습니다. https://app.swaggerhub.com/apis/MaaP_KR/RCS_Biz_Center/1.1.1
3. RCS에 관련하여 SMS/MMS와 같은 플로우(라이프 사이클)가 있는지?(트랜잭션 사이클)
==> 아직 정리한 Flow는 없습니다. 필요하다면 직접 구현 하시면서 작성 해주셔야 합니다.
==> 현재는 A2P만 개발하니, 시나리오가 간단하지만… Chatbot으로 추가 연동이 되면, 더 복잡해질 수 있습니다.
==> RCS는 자체적으로 통신 3사 연동이 되므로, 기존의 설문서버->MtMgr->발송기 형태가 아닌 설문서버->RCS발송기 형태로 연동 예정입니다.
4. RCS발송
- 단말에 전송 시 (단말 정보, 전문포맷등등) 필요한 것은?
==> 첨부자료 참고하세요. 부족하면 GSMA의 RCS 관련 규격을 찾아서 보시면 됩니다.
- 전송결과를 CRM에 전달해야 하는지?
==> 네, 그렇습니다.

# 20201012
■ 백엔드
1. 9월 회의록을 살펴보니 아래와 같은 내용이 있었습니다.
* RCS관련 스켈레톤 코드 지원 부분에 대해서 지원 받을 수 있는지요?
[/wizardlab.co.kr/mail/webmail/cid_img_view/110940448/gabiahiworkscid0]
2. RCS발송에 따른 염두해 두어야 할 도메인 정보(스팩)가 있는지?
3. RCS에 관련하여 SMS/MMS와 같은 플로우(라이프 사이클)가 있는지?(트랜잭션 사이클)
1) RCS발송
- 단말에 전송시 (단말 정보, 전문포맷등등) 필요한 것은?
- 전송결과를 CRM에 전달해야 하는지?

# 20201007
## 개발관련 문의사항
1. 개발 진행시 특별히 주의해야 하는 사항이나 당부사항
- 개발 코드 포맷 규약 존재여부(패키지,클래스명,명명규칙등등)
==> 패키지 : com.skt.mate 로 시작합니다. 별도의 신규 패키지 제작이 필요한 경우에만 com.skt.mate 에서 분기하시면 됩니다.

==> 클래스 및 기타 변수 Naming Rule : 개발 조직 변경을 두 번 이상 거친 코드라서… 패키지 별로 조금은 다른 구석이 있습니다. 하지만 행간을 보시면 나름 Rule이 있습니다. 대부분의 경우 표준 Java Naming Rule을 준수하시면 됩니다.
==> Mvn 사용합니다. Java 버전은 바꾸시면 안됩니다. Spring 버전은 꼭 필요하면 해당 패키지에 한해서 올리셔도 됩니다.
==> 비즈챗은 5대의 개발기가 일반적인 개발기와는 달리 실제 메시지 수발송이 가능합니다. 또한 작동환경 및 논리적인 형상이 실제 상용기와 동일하여, 개발기와 Staging 서버를 합쳐놓은 것으로 이해하시면 됩니다.

2. 전체 개발 프로세스가 있는가
- 예를 들어 GIT 레포지토리 커밋 절차(허가 및 알림)가 별도로 존재 하는지
==> feature/BIZCHAT-XXXX : 필요에 의해 개발자가 생성하는 브랜치로 언제든 커밋 가능
==> feature/survey1.3.0<http://code.skplanet.com/projects/BIZ/repos/mmate-api/compare/commits?sourceBranch=refs%2Fheads%2Ffeature%2Fsurvey1.3.0&targetBranch=refs%2Fheads%2Fmaster> : 개발자가 개발기 빌드배포를 위해 사용하는 Branch 입니다. 언제든 커밋 가능합니다.
==> dev-tobe : feature/survey1.3.0<http://code.skplanet.com/projects/BIZ/repos/mmate-api/compare/commits?sourceBranch=refs%2Fheads%2Ffeature%2Fsurvey1.3.0&targetBranch=refs%2Fheads%2Fmaster>를 통해 개발확인 시험이 완료된 feature들이 상용에 배포되기 전에 일정기간 머무는 장소입니다. 보통은 제가 해당 feature 들을 dev-tobe에 merge 해달라고 별도로 요청을 드립니다.
==> master : 대부분의 경우에, 제가 merge, build 및 배포를 주관합니다.
- Git 각 브런치별 (master/develop/tag/release) 빌드 프로세스 관련여부(실제 사용하는것은 릴리즈, 개발 브런치 별도 여부등등)
==> feature/BIZCHAT-1038<http://code.skplanet.com/projects/BIZ/repos/mmate-api/compare/commits?sourceBranch=refs%2Fheads%2Ffeature%2FBIZCHAT-1038&targetBranch=refs%2Fheads%2Fmaster> : feature 브랜치입니다. 이름과 같은 JIRA 티켓 처리를 위한 별도로 Branch로 master에 최종 merge되면 더 이상 의미가 없습니다.
==> feature/survey1.3.0<http://code.skplanet.com/projects/BIZ/repos/mmate-api/compare/commits?sourceBranch=refs%2Fheads%2Ffeature%2Fsurvey1.3.0&targetBranch=refs%2Fheads%2Fmaster> : 개발기에 빌드/배포를 하기 위한 Branch 입니다. 각 feature 들은 local에서 테스트 한 이후, 이 Branch로 merge 되어, 빌드 후 개발기에 배포하여, 개발확인 시험을 진행하게 됩니다.
==> dev-tobe<http://code.skplanet.com/projects/BIZ/repos/mmate-api/compare/commits?sourceBranch=refs%2Fheads%2Fdev-tobe&targetBranch=refs%2Fheads%2Fmaster> : 실질적인 Codebase 입니다. feature 브랜치는 거의 항상 dev-tobe 브랜치에서 분기합니다. Master에 최종 merge 하기 전에, 빌드가 가능한지 확인하고, 최종 개발확인 시험도 가끔 진행합니다. Staging 형상이라고 보시면 됩니다.
==> master<http://code.skplanet.com/projects/BIZ/repos/mmate-api/compare/commits?sourceBranch=refs%2Fheads%2Fmaster&targetBranch=refs%2Fheads%2Fmaster> : 상용에 적용된 형상입니다. 매월 마지막 주 목요일 정기배포가 완료되면 dev-tobe와 같은 Commit 들을 가지고 있어야 합니다.
==> hotfix<http://code.skplanet.com/projects/BIZ/repos/mmate-api/compare/commits?sourceBranch=refs%2Fheads%2Fhotfix&targetBranch=refs%2Fheads%2Fmaster> : 긴급 patch를 위한 임시 브랜치 입니다. 개발/확인 후, 바로 dev-tobe에 merge 하여, 개발기 테스트를 진행합니다.
==> 별도의 tag는 사용하지 않습니다
- 개발 -> 빌드 -> 테스트계 적용 -> 테스트계 기동/중지 방법
==> Feature가 개발 완료되면, Bitbucket에 로그인하셔서, 해당 feature Branch를 feature/survey1.3.0<http://code.skplanet.com/projects/BIZ/repos/mmate-api/compare/commits?sourceBranch=refs%2Fheads%2Ffeature%2Fsurvey1.3.0&targetBranch=refs%2Fheads%2Fmaster>에 merge 후 JARVIS 통한 빌드와 개발기 배포를 진행 하시면 됩니다.
- 위 절차는 개발자가 임의로 진행해도 되는지 별도의 허가가 필요한지
==> 메시지 전송에 직접 관련되지 않아 현재 JARVIS를 통해 빌드배포가 가능하신 패키지인 사용자 Web 및 Admin Web에 대해서는 언제든 feature 브랜치 생성, 기능구현, feature/survey1.3.0<http://code.skplanet.com/projects/BIZ/repos/mmate-api/compare/commits?sourceBranch=refs%2Fheads%2Ffeature%2Fsurvey1.3.0&targetBranch=refs%2Fheads%2Fmaster> 머지 및 개발기 빌드/배포까지는 개발자 마음대로 하셔도 됩니다.

3. 로컬 컴퓨터에 테스트 베드 구축(전체 모듈을 개발PC에 올려서 테스트) 가능여부 및 필요사항
==> mmate-admin 과 mmate-web 이라면 가능합니다. Oracle XE만 local에 추가로 구성하시면 됩니다.
==> mmate-api 등도 설치 하시려면, Rabbit-mq와 Redis 등도 추가로 설치하셔야 합니다. Windows 인 경우는 비추입니다.
==> Local에 별도의 추가 서버가 없다면, PC 만으로는 Full Set 구성이 어려우니, 참고하세요.

# 20201026
## git branch관련 문의입니다.
JIRA에 BIZCHAT-1070 으로 TASK를 새로 작성하였습니다. (상세 내용은 향후 수정토록 하겠습니다.)
관련 소스는 모듈별 브런치를 작성하려고 합니다. 

대상:
mmate-survey-agent => feature/BIZCHAT-1070
mmate-web => feature/BIZCHAT-1070

문의 내용은 mmate-web 모듈을 tobe 에서 분기하려고 하는데 현재 (개발계) 버전과 차이가 있어보여서입니다.
예를 들어 설문제작 좌측 화면에 과금유형 라디오 버튼이 현재 tobe 브런치에는 반영이 안되어 있는합니다.(스키마 포함) survey1.3.0 브런치에는 있고요..
저번 문의로 tobe에서 분기해야 한다고 하셔서 다시 문의드립니다.

## 답변
타 Branch에 개발중인 Commit들은, dev-tobe에 merge되기 전에는 상용 배포가 확정된 Commit들이 아닙니다.
현재 mmate-web과 mmate-admin 리포지토리의 dev-tobe 브랜치 갱신 예정일자는 10월 비즈챗 정기배포일인 10/29(목) 오전입니다.
금주 목요일까지 기다리셨다가 분기하는 방법이 있고,
아니면 지금 먼저 임시 브랜치로 분기했다가 목요일 이후에 dev-tobe에서 분기하고, 임시 브랜치의 중간 작업들을 1070 브랜치로 merge 하는 방법이 있습니다.
어떤 방법을 취하시든, 유지보수 업무를 수행하는 타 feature 브랜치들이 수시로 dev-tobe에 merge 됨으로 인해서,
1070 브랜치를 dev-tobe 브랜치에 병합 시 충돌은 언제나 발생할 수 있습니다.
충돌 해결은 수작업으로 하는 수 밖에는 없고요. 충돌발생 가능성을 최대한 줄이는 방법이 dev-tobe에서 분기하는 것이라고 저는 생각합니다.
이상 업무에 참고하시기 바랍니다.

1.3.0 브랜치는 현재 유지보수 작업을 주로 진행하는 모엔트의 개발자 분들이 주로 사용하는 빌드용 브랜치입니다.
앞으로 1070 브랜치를 빌드 할 때마다 1.3.0 브랜치에 merge하는 것은 머지/빌드/배포 후 원복을 항상 하셔야 하므로 아마도 사용이 불가능 하실 것이니,
1070 브랜치를 빌드의 Target 브랜치로 사용하는 별도의 JARVIS 프로젝트 생성이 필요할 것으로 생각합니다.
별도 JARVIS 프로젝트를 원하시면 생성 요청하시기 바랍니다.

# 20201029
## RCS 방향
## 추가 테이블
```SQL
-- RCS 슬라이드별 정보(SURVEY_SEQ 1개당 최대 6개 슬라이드)
CREATE TABLE SURVEY_RCS(
    RCS_SEQ,                // AUTO INC
    SURVEY_SEQ,             // SURVEY_SEQ
    RCS_AGRE_TITLE_MSG,     // 설문동의 메시지
    RCS_AGRE_GUIDE_MSG,     // 설문 메시지
    RCS_AGRE_IMG_FILE_PATH, // 설문동의 이미지 (슬라이드이미지)
)

-- 슬라이드별 버튼정보(최대 2개)
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
```
* 방법고찰
1. MT_MSG_QUEUE 에 RCS관련 전체 정보를 담는방법
2. MT_MSG_QUEUE 에 더해서 RCS용도 신규테이블 MT_MSG_QUEUE_RCS, MT_MSG_QUEUE_RCS_BTN 을 사용하는 방법

## 답변
금일 비즈챗 정기배포 관계로 바빠서 답변이 늦었습니다.
아래 간단히 커멘트 드리겠습니다. 업무에 참고하시기 바랍니다. 추가 질문 환영합니다.
1.     SURVEY_RCS_BTN 테이블은 필요해 보입니다.
2.     SURVEY_RCS 테이블도 필요하기는 한데… 담을 내용이 더 필요한지 확인이 필요합니다.
3.     설문상태는 Targeting이 끝나면 “PRE_CHECK” 상태이고, 후에 MDN별로 광고수신 동의정보 대사가 끝나야 “APPR”이 됩니다.
4.     지금 설문 Agent가 MT_MGR_REQUEST 큐에 쓰는 메시지 객체는 MtMessage 입니다. 참고하시기 바랍니다.
5.     MT_MSG_QUEUE_RCS 테이블과 MT_RCS_QUEUE_RCS_BTN 테이블은 별 필요가 없어 보입니다.
è  기존 MT_MSQ_QUEUE와 SURVEY_RCS_BTN 테이블을 이용하면 될 듯 합니다. 확인 부탁 드려요.
6.      DB 스키마는 기존 BP 개발자 분께 부탁 드렸습니다. 수령하면 전달 예정입니다.


# 20201113
## 문의사항
0. 일전 미팅때 일반설문 작성 + RCS설문 작성 후 등록시 SURVEY는 2건이 아니라 1건이라는 정보를 토대로 아래 사항을 문의드립니다.
- 참고 기획서(BizChat_Web 화면설계서_v1.3.0) 150페이지에 있는 [일반 Tab 및 RCS Tab 모두 작성시]
1. [WEB]설문등록
- 화면에서 예를들어 일반설문(MMS) & RCS설문(MMS) 둘다 작성하고 등록하였을때 일반MMS도 등록되고, RCS_MMS도 등록이 되는것인가요?
	- 일전 미팅때 SURVEY는 1건의 ROW가 작성되어야 한다고 일전 미팅때 말씀을 들었습니다. 
	- 이때 기획서를 보면(86페이지) [어드민화면 > 메시지관리&통계 > 설문이력조회]시 표시되는 리스트 형태에 [유형]컬럼에는 LMS, MMS, RCS_LMS, RCS_MMS인지를 표시하도록 되어 있습니다.기획서에 나온것으로 봐서는 SURVEY테이블에 2건이 들어가야 하는지 의문이 생깁니다.
2. [ADMIN]전송완료조회
- Elasticsearch를 이용하여 도큐먼트의 내용을 조회해서 전송완료 리스트를 표시하는데요.. 이때 RCS_LMS, RCS_MMS관련 내용도 조회가 되도록 해야하는데.. 
	- Elastic관련해서 수정해야할 항목이 있는지 의문입니다.(엘라스틱 플로우 관련해서는 아직 전체 분석을 못하였습니다.)
3. [ADMIN]메시지관리&통계 > 마케팅비즈챗 (전송완료 메시지 조회/MT요청 메시지 조회/설문 이력 조회)
- 해당 메뉴에서 사용하는 테이블이 대략(CUSTOM, SURVEY, SURVEY_PARTCPTN, SURVEY_HIST)들입니다. 통계를 주로 다루는 기능으로써 LMS, MMS, RCS_LMS, RCS_MMS 각각 개별로 통계를 처리하게 되려면 1번질문에 있듯이 일반설문 + RCS설문 으로 하게 되면 레코드가 2개가 되야 하지 않을까 하는 생각이 듭니다.
4. [ADMIN]설문승인
- 설문승인 리스트 조회에도 LMS, MMS, RCS_LMS, RCS_MMS 각각 리스트로 나오게 되어 있습니다.

문의 내용을 다시 정리하면
- Elastic 관련하여 수정사항 및 워크 플로우 문의
- 설문 일반탭&Rcs탭 둘다 작성시 SURVEY는 2건(일반 1건, RCS 1건)이 등록되어야 하는지에 대한 문의입니다.

## 답변
-     Elastic 관련하여 수정사항 및 워크 플로우 문의
è Elastic search는 MT_SND_HIST 테이블과 연동되어 있습니다. MT_SND_HIST 테이블 레코드 생성 시, MSG_TP 필드에 메시지 타입을 RCS_MMS(RC_LMS)로 지정하시면 됩니다.
-     일반탭 & Rcs탭 둘 다 작성 시 SURVEY는 2건(일반 1건, RCS 1건)이 등록되어야 하는지에 대한 문의입니다.
è 하나의 설문에, 하나의 SURVEY 레코드만 유지하는 것이 수월해 보입니다. 하나의 설문에 설문ID(survey_seq)가 두 개가 생기면, 이후에는 모든 결과를 합해서 처리해야 합니다. 두 개의 설문 ID가 동일한 설문을 의미하는지 표시하려면, 모(mother)설문/자(child)설문 개념도 도입되어야 합니다. 설문ID(survey_seq)는 primary key라서, 기존 틀을 바꾸려면 꼭 불가피한 사유가 있어야 합니다.
   => 일반탭 & RCS탭 둘다 작성 시 SURVEY 1건(레코드1건)으로 처리하면, ADMIN에서 설문승인 화면 (기획서 231페이지)에는 승인되어야할 설문리스트가 표시됩니다. 여기서 의문점이 리스트에서 [메시지 유형] 컬럼 표시부분입니다.  해당 메시지 유형은 설문등록시 화면에서 [과금유형] 을 선택한것이 들어갑니다. SURVEY테이블의 SURVEY_MSG_TP 컬럼을 참고합니다. SURVEY_MSG_TP는 현재 LMS아니면 MMS만 등록되도록 되어 있습니다. 
    문제는 일반&RCS 둘다 작성했을 경우 SURVEY_MSG_TP에는 어떤값을 넣어야 하는지 입니다. 둘다 작성하였으니 하나의 컬럼에 두개(LMS/RCS_MMS) 가 표시되어야 하지 않을까 하는 생각이 듭니다. 이렇게 되면 화면에서도 메시지 유형 추가하는 수정이 되어야 할듯하고요, (물론 메시지 유형을 개별로 작성하였다면 개별로 나오고, 둘다 작성했을때는 하나의 컬럼에 두개가 나오는 형태입니다.)
        è 설문의 과금유형과 전송유형을 혼돈하지 마시기 바랍니다.
        è 과금유형은 SURVEY 테이블의 SURVEY_MSG_TP이며 현재는 MMS나 LMS 둘 중 하나입니다.
        è RCS_MMS나 RCS_MMS는 전송 메시지 유형(MSG_TP)의 하나로서 전송 기록에 관한 테이블에서 RCS 메시지임을 일반 메시지와 구분해서 사용하는 ENUM 값 입니다.
è 현재 마케팅 설문수신자 Upload 시, RCS 수신가능 가입자인지 아닌지 구분해서 업로드 하지 않기 때문에, 실제 RCS 전송을 해봐야 알지, 따로 확인할 수 있는 방법은 없습니다.
è 현재로서는 RCS 메시지를 작성하는 설문은, RCS 수신이 가능한 가입자를 포함해서 설문참여 대상자를 Upload 한다고 생각하시면 됩니다. 이 경우에는 RCS 발송 실패 시, 설문서버에서 해당 대상자에 대해서, 일반 MMS/LMS 메시지를 추가로 발송을 시도해야 합니다.
è 내년 이후에, 재전송이 없이 RCS 가입자는 RCS 메시지만 전송하고, 일반 메시지 가입자는 MMS/LMS만 발송하려면, 수신자 Upload 시, RCS 가입자 여부를 입력 받아서, 한번씩만 전송을 시도하도록 하여야, 불필요한 재전송을 최소한으로 할 수 있습니다.
è RCS/Non-RCS 가입자를 동시에 지원하든 안 하든 상관없이, SURVEY_TRGTER 테이블에는 RCS 가입자 여부가 SURVEY_HIST 테이블 등에는 RCS_MMS(RCS_LMS) 메시지 발송 건 수 등 컬럼이 추가되어야 할 것으로 생각됩니다.


# 20201119
## 메일수신 및 질의
- SKT가 아닌 타사 가입자(54001) 및 자사가입자이나 RCS 수신 불가능한 가입자(54002)에 대한 메시지 전송요청은 배달 리포트가 아닌 HTTP Response에 바로 54XXX 코드로 결과가 리턴 됩니다 이런 오류는 통상 전송실패가 아닌 전송요청 실패로 구분해서 부릅니다.
- 전송요청이 성공한 경우, 실제 단말로 배달이 완료된 메시지는 SKT-RCS-CLIENT의 /msgstatus Web_hook으로 배달완료/기타오류 여부가 통상 1~2초 안에 통보됩니다.
  => git에 있는 mmate-rcs-client 관련 테스트 코드를 잠깐 살펴보았습니다. 여기서 노파심에 다시 여쭤보고 싶은것이 client가 RCS메시지를 보낼때 DB(SURVEY_RCS)에 이미 maaperfileId가 존재해야 한다고 하셧지요? maaperfileId는 직접 maaperURL호출해서 나온 결과값으로 해야하고... RCS등록 시점에 maaperURL을 호출하여 돌려받은 값 maaperfileid 를 가져와서 DB에넣으려고 합니다. 이렇게 진행해도 무리가 없겠지요? (swaggerAPI는 mmate-common에 넣어서 사용해야할듯합니다. 의견입니다.)
    ==>  첨부화일을 MaaP FE에 등록하고 maapFileId를 받아오는 시점은 장부장님과 두 분이 상의하셔서 결정하셔야 합니다. 등록 시에 하셔도 되고, 늦추어서 Test 발송을 하는 루틴에서 하셔도 됩니다. 테스트 발송에만 문제가 없으면 됩니다. 의견주신 대로 filePost/fileIdGet API는 service로 wrapping 해서 최종적으로는 mmate-common에 위치시켜야 합니다.
그리고, survey-agent가 RCS 설문을 처리하는 방식에 약간의 변화가 있어야 할 것으로 생각됩니다.
-       현재 Targeting 대상자 Upload 시, RCS/Non-RCS 구분이 안되기 때문에, RCS Tab이 있는 설문은 먼저 RCS 메시지 발송을 시도하게 됩니다.
-       이전 미팅에서 survey-agent가 해당 RCS 메시지를 MT_MSG_QUEUE에 넣고, MtMessage를 MT_MGR_REQUEST에 포스트 하는 방식으로 이야기 했었습니다. 
     => 참고로 현재 진행중인 플로우는 아래와 같습니다.
        => survey-agent -> 3초스케쥴러 -> RCS메시지 -> 큐명:MT_MGR_REQUEST -> MtMgr
        ==>  네, 그대로 하시면 됩니다.
-       메시지를 받은 MtMgr가 하는 역할은 해당 메시지를 MT_RCS_SKT 큐로 전송하는 것입니다.
        => MT_RCS_LMS_SKT / MT_RCS_MMS_SKT 2개로 진행중입니다.(1070 커밋됨) 말씀주신 MT_RCS_SKT 하나로 해도 될까요?
        ==> 꼭, 하나로 하셔야 합니다. SKT-RCS-CLIENT가 LMS/MMS/Carousel 모두 전송합니다.
-       mtMgr은 SMS/MMS 3사 연동을 하고, MT_SND_HIST 테이블을 관리하는 것이 주 업무입니다. 하지만 SKT-RCS는 3사 연동과는 무관하고 또한 RCS 수신불능 가입자가 50% 이상인 관계로, 발송실패가 많이 발생할 것으로 예상됩니다. 그리고 RCS 발송요청 실패 시, mtMgr가 해야 하는 역할은 하나밖에 없습니다. SKT-RCS_CLIENT가 MT_MGR_RESULT 큐에 쓴 전송실패 내역을 survey-agent에 빨리 알리는 것입니다.
        => 네 이부분 확인하겠습니다.
-       기존 mtMgr은 발송실패를 보고하려면 비교적 느린 절차인 API_CALLBACK 큐를 거쳐 API 서버를 통해 survey-agent로 HTTP POST를 하였습니다. 현재 survey-agent는 MT Report를 받고, SUCCESS인 경우에만 할 일을 수행합니다. 하지만 이제부터는 전송 FAILURE 시에 해당 메시지가 RCS인 경우에는 MMS Tab이 존재하는 설문이면, RCS 메시지를 MMS로 대체해서 재차 전송 시도하는 루틴이 들어가야 합니다. 즉 MT_MSG_QUEUE에 있는 발송대상 메시지를 RCS 형식에서 MMS 형식으로 내용을 변경하고, MtMessage를 MT_MGR_REQUEST에 다시 포스트 해야 합니다,
        => 발송에 대한 응답처리 분석을 현재 진행중에 있습니다. 해당 내용 확인해보겠습니다.
-       RCS 전송요청 실패 후 변경해서 요청한 MMS 전송요청을, mtMgr은 신규 요청으로 인식할 수 있기 때문에, MT_SND_HIST에는 두개의 RECORD가 생성될 수도 있습니다. 메시지 전송자 입장에서는 메시지 포맷이 바뀌지만, 하나의 연결된 전송요청이므로 하나의 RECORD로 처리하는 것이 모두에게 유리합니다, RCS와 MMS 같은 하부 전송 채널별 시도 내역은 MT_SND_ACTION_HIST 테이블에 각각의 RECORD로 존재하게 됩니다. 기존의 mtMgr의 처리 로직 확인 부탁 드립니다..
        => 네 확인해보고, 의문점이 있으면 문의하겠습니다.
-       종합하면, 최초 RCS 메시지를 보낼 때, 기존에 협의된 방식대로 mtMgr를 통해 전송을 하되, 전송요청이 실패한 경우에 실패결과 전송 시에는 기존과 같이 mtMgr가 API_CALLBACK 큐를 태워서 API 서버를 통한 전송을 하지 말고, 별도의 MT_RCS_RESULT(가칭 : SKT-RCS-CLIENT가 survey-agent에게 발송 요청의 실패만 알리는 전용 Queue) 큐에 직접 쓰고 survey-agent가 해당 큐에서 직접 읽고, 실패 시 MMS로 변경 발송하는 방식으로 변경을 검토 하였으면 합니다. 기존에는 전송요청 실패가 통상 1% 정도이기 때문에, 처리에 성능적인 문제가 없었지만, RCS 발송의 경우 많은 메시지 교환이 필요할 것으로 예상되기 때문입니다.
        => 정리하면 RCS 실패시 기존 사용하던 [큐명:MT_MGR_RESULT] 사용하지 말고 [신규큐명:MT_RCS_RESULT] 를 이용한다. 그러면 survey-agent에 큐리스너(MT_RCS_RESULT)를 만들어야 하는 형태 같네요... 해당 리스너는 위 설명대로 MMS 처리를 해야겠고요..
        ==> SKT-RCS-CLIENT가 MtMgr에게는 기존과 동일하게 MT_MGR_RESULT로 실패내역을 회신해야 되지요. 그 이후에 MtMgr이 MT_RCS_RESULT를 이용해서 API를 거치지 않고 survey-agent와 직접 통신하면 성능 측면에서 유리하니 구현여부를 검토해 달라는 요청 이었습니다. 아무래도 올해는 기존과 같이 API로 경유해서 실패내역을 회신하는 방식을 유지하고, 내년 초에 성능을 개선하는 쪽으로 가야 될 것 같습니다. 이 건은 검토는 안 하셔도 됩니다.
-       RCS 발송요청이 성공한 경우에, 배달의 완료를 알려주는 RCS의 Delivery Report는 mtMgr와 상관없이, 각각의 발송기가 받아서 API_CALLBACK 큐를 태워서 API 서버를 통해 survey-agent로  전달을 수행합니다. 이 경우에는 항상 SUCCESS인 결과가 리턴 되겠습니다. 혼돈하지 마세요.
        => 네 상기 내용 확인해보겠습니다.

추가 문의
1. COM_CD 테이블에 RCS관련 코드(RCS_LMS, RCS_MMS) 추가시 주의해야 할 내용이 있나요?
(참고로, SND_MSG 의 MSG_TP에 RCS_LMS, RCS_MMS 코드가 추가될것입니다.)
=> 네, 특별한 주의사항 없습니다. 그냥 2개 순서대로 추가만 하시면 됩니다.

# 20201124
빌드가 필요한 앱/웹별로 “[DEV] BIZCHAT WEB 1070” 형태로 빌드/배포 프로젝트를 제가 금일 중으로 생성하고 권한부여 하겠습니다.
현재 설문동의메시지 쿠폰은 하나의 설문에 하나만 설정할 수 있습니다. Card하나 또는 Card별로 다른 쿠폰코드를 넣으려면 아래와 같은 변화가 필요합니다.
-       SURVEY_AGRE_COUPON 테이블에 두 개 이상의 다른 Category의 RANDOM COUPON이 저장될 수 있어야 함. CATEGORY 분류하는 KEY 추가 등..
-       설문서버의 동의안내 메시지 발송기에 기존 [코드삽입]이 아닌 [코드#1]/[코드#2] 등의 새로운 치환 KEYWORD 사용법이 구현 되어야 합니다.
-       사용자 Web에서 동의안내메시지에 두 개 이상의 쿠폰 파일 Upload가 가능하여야 합니다. [코드#3]가 존재하면, [코드#1][코드#2]가 있는지도 확인해야 하며, 설문 제작 후 저장 시, 필요한 테스트 쿠폰이 3개 CATEGORY별로 각각 모두 Upload 되었는지도 확인해야 합니다.
-       또한 RCS는 동의안내 메시지가 여러 개의 Card로 이루어 지므로, RCS에서 다중 쿠폰코드를 지원하려면, 카드별로 각각 치환을 추가로 수행해야 합니다.
지금 기능을 구현하기는 어렵지 않으나, 성능면에서 초당 100건 이상 전송이 가능해야 하는데… RANDOM 쿠폰을 하나가 아니고 여러 개 치환해야 하는 경우에는, 성능문제가 우려됩니다. 내년 초에 해결하시면 될 것 같습니다.
따라서 현재로서는 RCS 메시지의 각 Card별로 존재 가능한 “[코드삽입]” 키워드에 그 설문에서 사용 가능한 하나의 동의메시지 쿠폰을 일관성 있게 할당해야 합니다. 
예) 슬라이드 3장/코드:1234 인경우
1) 설문등록
=> 1장 "내용 [코드삽입]"
=> 2장 "내용 [코드삽입]"
=> 3장 "내용 [코드삽입]"
2) 쿠폰적용
=> 1장 "내용 1234"
=> 2장 "내용 1234"
=> 3장 "내용 1234"

[코드삽입] 키워드가 하나의 Card 내에서 2번 이상 사용될 수 있습니다. 그 때는 처음 키워드만 치환합니다.
예) 슬라이드 3장/코드:1234 인경우
1) 설문등록
=> 1장 "내용 [코드삽입]...[코드삽입]"
=> 2장 "내용 [코드삽입]...[코드삽입]"
=> 3장 "내용 [코드삽입]...[코드삽입]"
2) 쿠폰적용
=> 1장 "내용 1234...[코드삽입]"
=> 2장 "내용 1234...[코드삽입]"
=> 3장 "내용 1234...[코드삽입]"

그리고 여러 카드를 통틀어서 [코드삽입] 키워드가 두 번 이상 사용 되더라도 그 치환 값은 해당 MDN에 미리 지정되거나
=> 웹화면 등록시 'MDN지정쿠폰사용' ON 했을때 전화번호와 쿠폰이 매칭된 수신자 엑셀파일을 참조해서 쿠폰코드가 지정된다.

, 혹은 RANDOMLY 동적 할당된 쿠폰 값으로 항상 동일하게 치환 되어야 합니다.
=> 비지니스 적으로 랜덤 동적 할당은 어느시점인지 알려주실수 있나요?

# 20201130
## 문의/답변
그리고, 브라우저에서 개발계IP (172.21.85.185, 186)으로 접근해서 확인이 가능한가요? (내부아이피, 외부아이피 존재유무)
=> 개발기 Web URL 밀씀하시는 것이면… https://www-dev.bizchatservice.co.kr/ 사용하시면 됩니다. 혹 다른 요청이면 질문의 의도를 잘 모르겠습니다.
=> 비즈챗 개발기는 SKT 챗봇서비스가 수시로 Staging 시험을 하는 개발기 겸 Staging 장비입니다. 별도의 사전 공지가 없으면 9시~18시 사이에는 API/MtMgr/mms-skt/skt-sms-client 는 항상 올바르게 작동하여야 합니다. 위 네 개 서버의 새로운 기능을 시험 하시려면 항상 18시 이후에 배포->시험->원복 절차를 거치셔야 합니다. 업무에 참고하시기 바랍니다.


# 20201204
## 미팅준비
1. [코드삽입] 같은 경우는 어느시점에 작업이 진행되어야 하는지 논의필요. 기존에는 3초 스케쥴러에서 RUNNING설문을 조회하여 타겟넘버와 쿠폰번호 매핑해서 치환작업을 진행하였다.
RCS같은 경우는 별도의 테이블에 내용이 존재 하기때문에 어느시점에서 진행을 해야 하는지.... 고민한 방법은 아래와 같다.
        - MsgQueueVO에 서브 VO에다가 넣는방법
        - 그외...
2. 전체 플로우가 끝나고 나서 SURVEY 삭제 처리 하는 부분은 어느부분인지....
3. 리모트 디버그 사용가능여부...
        - 결국 안된다. 들어오는 아이피를 열어주어야 한다고 한다. 절차가 복잡하다고함.

## 미팅내용
1. 15일 이전에 테스트가 완료가 되어야 한다.
2. 차주 화요일 테스트 유매니저님과 같이..
3. MT_MSG_QUEUE 에 MSG_ID, RCS_SEQ 가 있어야 한다.
        - msg_id 이면 메시지의 유니크한 값을 말한다.
        - SND_MSG 에서 message시퀀스가 곧 msg_id가 되도록 해서 mt_msg_queue에 넣으면 될듯하다
        - bizchat에서 발송기에 msgId보내도록 되어 있다. (유매니저님은 임의로 bizchat_[epochtime]으로 해서 테스트하고 있다고 한다.)
        => 잘못 알앗다 msg_id가 아니고, customer_req_id이다. 이는 MT_MSG_QUEUE에 해당 컬럼이 있다. 현재 custom_req_id에는 값이 들어가도록 되어 있다. 위의 msg_id 설명이  snd_msg:msg_seq 가 customer_req_id 가 맞느냐?
4. 오류코드
        403, 329: 리트라이한다. (오류코드는 엑셀 파일 참조)
        500: 리트라이
        54001: 이면 그냥 끝내고 된다.
        54002: 이면 MMS/LMS 보내야 하는 코드이다.
        54004: 리트라이를 해야하는지... 54001과 같게 처리되도록 한다.
5. 설문 등록시 이미지는 NAS에 전송하도록한다.
        => NAS저장
        => maaper fileid 확인 요청시 응답에 expired date가 있다. 이를 start_survey_dttm 과 비교해서 해야하는 처리가 있어야 할듯...
        => 테스트 전송은 maaperurl이 하고
        => 이후 테스트 스케쥴러가 하루전에 maaper를 읽어서 mapperurl을 가져와서 넣는 방법을 생각해 볼 수 있다.
6. 일반설문 + RCS설문이면 SND_MSG는 한개가 되어야 한다.
        - RCS를 먼저 보내고... 54002 오류가 났을때 일반설문이 SND_MSG 업데이트 되도록 되어야한다. 고민해야한다... 어떻게 처리가 되어야 할지....
7. SURVEY 테이블 '동의 안내 메시지'는 not null 에서 null 로 바뀌어야 할듯하다. RCS only인경우가 있기때문..
8. survey-agent 설명
        - ReceiveMsgHandler => MT 
                => modifyMtRcvInfo(성공실패결정)
                        -> snd_msg(fail_cd, fail_cont)
                        -> rcvVO에 헤더, 바디 ResultNotificationVO::transactionId === CUSTOMER_ID이고, SND_MSG의 MSG_ID?일 것이다.)
                => 성공했을때의 처리가 있다. 지금까지 성공에 대해서만 있다. 
                => 이제는 실패을경우의 처리가 있어야 한다.
                        => RCS 오류코드를 봐서 LMS/MMS 용도로 같은 SEQ에 SND_MSG를 업데이트 해야 한다.
                                => MT_MSG_REQUET 로 보내면 될듯하다......
                                => 관련테이블
                                        MT_MGR: MT_SND_HIST, MT_SND_ACTION_HIST
                                        SURVEY-AGENT: SND_MSG, MT_MSG_QUEUE
                        => 3초 스케쥴로 보내도록 한다. (코드치환 때문이다) 
                                => MT_MSG_QUEUE 에 INSERT UPDATE 하도록 한다.
                                
9. 설문2서버에서 배치가 동작되고 있다고 한다.
        => 설문 몇시간 전에 maaperUrl하도록 하면 어떠한지 생각..
10. 테스트기계는 신규번호로 해야한단다.
11. MMS는 빼고.. 차주 월요일즈음에 LMS발송 테스트할 수 있도록 6시이후에...
12. rabbitmq에서 MT_MGR_REQUEST 는 항상 0건이어야 한다.!!!!!!!!! 

13. 설문등록시 이미지는 NAS에 저장
14. SND_MSG에 MSG_CONT를 넣어야 한다.

# 20201215
- 금주 금요일(12/18)에 1차 개발확인 시험을 SKP 내부에서 진행하기를 원합니다. 따라서 내일부터 양일간 위자드랩의 자체 개발시험 및 Debug를 진행해 주셨으면 합니다. 아래 일정에 이견이 있으시면 금일 중으로 해당 사유와 함께 메일회신 부탁 드립니다. 이틀간 시험 진행 시, 모든 발송에 관한 문제는 제게 문의 해주시기 바랍니다.
- 1차 개발확인 시험이 PASS하면 본 개발과제는 종료된 것으로 간주됩니다. 1차에서 실패 시 2차 시험은 차주 월요일(12/21)에 진행합니다.
- 12/23(수)까지 개발관련 산출물 초안을 제게 제출해 주시기 바랍니다. 필수로 포함되어야 할 내용은 아래와 같습니다.
n  요구사항 분석서
n  개정 ERD
n  프로그램 설계서
n  개발확인 시험 절차서
- 12/24(목)까지 제게 확인을 받은 본 과제의 개발 산출물을 포함하여, 검사요청서를 Open2U를 통해 제출 해주시기 바랍니다.

# 백업
# 20201119
## 문의
1. COM_CD 테이블에 RCS관련 코드 추가 해도 되나요?

RCS설문 이미지의 fileId가 전송되기 전에 SURVEY_RCS에 들어가 있어야 하는 전제로
설문 등록시에 이미지 마다 maaper요청으로 fileId를 가져오려고 합니다.

1. mmate-rcs-skt 를 확인해보니 swaggerAPI를 참조하시고 계신데요. (file올리는 테스트는 해보았습니다.)이부분 코드를 참조하면 되는지요?
2. 참조 가능하다면 swaggerAPI를 mmate-web 에서도 사용하려고 합니다. mmate-common으로 swaggerAPI를 옮겨도 되는지요? 

## 주요 코드 추가
아래와 같이 1070에 일부 정보를 커밋하였습니다. client작성시 참조하시면 됩니다.
1. mmate-common
=> 메시지 서브타입 추가
```
CommonCode.java
public enum MessageSubType {SMS, LMS, MMS, RCS_LMS, RCS_MMS}
```

2. mmate-mq
=> MQ 추가
RCS_LMS: MT_RCS_LMS_SKT
RCS_MMS: MT_RCS_MMS_SKT

의견주십시요. 감사합니다.


# 20210107
유찬석 매니저님 안녕하세요
위자드랩 전용수입니다.

사용자 웹화면 통계관련해서 질문이 있습니다.
통계 수치가 안맞아서 저가 정상적으로 확인한것인지 궁금해서 입니다. 우선은 순차적으로 설명을 드리겠습니다.

## 문제 내용
1. 관련화면: 사용자웹 > 리포트 > 마케팅비즈챗 > 통계 (상세팝업)
2. 검색 내용
- 프로젝트: F_1229
- 설문명: #1_MSG_SENDING
- (설문기간)날짜: 20201229 ~ 20210105
★ 해당 설문은 RCS_LMS입니다.

3. 리스트 문제 내용
- 확인: 응답완료(3) > 클릭 > 상세화면
- 문제내용: RCS_LMS 뿐만 아니라 RCS_MMS에도 카운트가 되어 있는것을 확인 (RCS_MMS는 0건이어야 함!!)

## 이슈 분석
1. 설문번호: 4941
2. 설문히스토리 조회
```
select * from survey_hist where survey_seq = 4941;
```
=> 조회 했더니 RCS_MMS에 카운트되어 있는 것을 확인함.
3. 설문배치 쿼리 확인
소스: surveyHist.sqlmap.xml => updateSurveyHistBatch
4. 설문배치 쿼리 일부 확인(설문번호: 4941로 조회)
```SQL
...
...

SELECT
    SURVEY_HIST_ID
    , 'MT' AS SND_RCV_TP
    , MSG_TP
    , m.user_id
    , SND_STATE
    , '' AS CUSTOM_SEND_SUCC_YN
FROM SURVEY_HIST s, survey_partcptn p, MT_SND_HIST m
WHERE s.survey_seq = 4941
AND s.survey_seq = p.survey_seq
AND s.mdn = p.rcver_phone_num
AND m.svc_cl = 'SV'
AND m.req_rcv_dttm >= to_date('20201229 1100', 'yyyymmdd hh24mi')
AND m.req_rcv_dttm <= p.upd_dttm +1/24/60/60*5
AND s.user_id = m.user_id
AND s.spc_num_num = m.snd_mdn
AND s.mdn = m.rcv_mdn

...
...

```
5. 위 쿼리만 조회 하였을경우 RCS_LMS뿐만 아니라 RCS_MMS도 조회되었음.. 제가 생각하기엔 RCS_MMS는 안나와야 하는게 정상같은데 ... 쿼리가 잘못된것인지 위의 쿼리를 조금 수정해보았습니다. 실제로 위의 mt_snd_hist에 설문번호 4941외에도 다른 설문번호를 포함한것이 조회된 것이 아닐까 하고 아래와 같이 수정해서 확인해 보았습니다.
```SQL
select distinct survey_seq from snd_msg where msg_seq in (
SELECT
    m.custom_req_id
FROM SURVEY_HIST s, survey_partcptn p, MT_SND_HIST m
WHERE s.survey_seq = 4941
AND s.survey_seq = p.survey_seq
AND s.mdn = p.rcver_phone_num
AND m.svc_cl = 'SV'
AND m.req_rcv_dttm >= to_date('20201229 1100', 'yyyymmdd hh24mi')
AND m.req_rcv_dttm <= p.upd_dttm +1/24/60/60*5
AND s.user_id = m.user_id
AND s.spc_num_num = m.snd_mdn
AND s.mdn = m.rcv_mdn);
```
```결과
4943
4941
4937
4940
4942
```

위 처럼 설문번호 4941외에  다른 설문번호를 포함하여 통계처리가 되고 있는것이 아닌가 하는 추측을 해봅니다.

질문은 아래와 같습니다.
1. 그럼 일배치 통계 쿼리(surveyHist.sqlmap.xml::updateSurveyHistBatch)가 조회 조건이 잘못된것인가? (개선안: mt_snd_his와 survey_hist 강결합이 되도록 수정) 
2. 쿼리가 잘못된 것이 아니면... 12월 당시 발송기 테스트하기위해 SURVEY_TRGTER, SURVEY_PARTCPTN 테이블의 일부 정보를 삭제하면서 테스트를 하였었습니다. 일일 통계시 SURVEY_PARTCPTN 테이블의 내용도 영향도가 있는것을 확인하였는데요. 이부분이 통계에 미치는 영향때문에 12월 당시의 통계가 어그러 진것인가?

위와 같습니다. 내용이 많이 기네요. 유선으로도 설명할 수 있습니다.

확인 부탁드립니다.

이상입니다. 감사합니다.

