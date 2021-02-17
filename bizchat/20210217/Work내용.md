# 20210106

# TODO
- [] 20210104 회의 내용 분석

- [X] 유저 생성
	- [X] SKT Admin
		- user: sktadmin01
		- pass: !1qazZAQ!
	- [] 중계사 Admin (중계사 Admin(SKT))
		- user: rlcadmin01
		- pass: !1qazZAQ!

- [] 인증관련 분석
	- [] 관련 테이블
		- [] ROLE : 역할
			- [] ROLE_TP_CD : 역할 유형 코드 (API, SUA, ADM, STM, OPR, DEV, CANONY, CUOP,...) : ????
		- [] RSRC : 자원
			- [] DOMAIN_TP_CD : 도메인 유형 코드(ADMIN, API, CUSTOMER, 3개?) : ????
		- [] ROLE_RSRC_MAPP : 역할자원매핑
		- [] USER_ROLE_MAPP : 사용자역할매핑
	- [] 역할이 가진 고객 조회 관련

	1. system_user 에 로그인 아이디 및 역할이 있다. 역할은 기존 (SuperAdmin, ??,??)등이 있다. 여기서 변경점은 system_user 에 (사업자/중계사/딜러사) 구분이 추가된다.
	2. Admin테이블 user_id(login_email) mgmtc_tp(3가지 타입 :'',RLC,DLC)로 구분되고 있다.
		=> ★ mgmtc_tp에 타입을 사업자로 하나더 추가해야 할지 고민
	3. 중계사/딜러사는 각각 테이블이 존재한다. (RLC, DLC 테이블)
		=> ★ 사업자용도 테이블을 별도로 만들어야 할지 고민
	2. 그러면 롤(역할)이 가진 고객리스트는 어디서 가져오는가?
		
- [] RCS통계 테스트
	- [X] 설문작성(설문명: DEV_RCS_MMS_20210106_1, 기간:13:00~13:30)
	- [] 통계 확인(10건): 내일 확인

- [] Admin권한 영향도
	- [] 테이블 영향
		- [] 사업자 테이블 추가 (테이블명(가제): BLC)
			- [] 사업자 > 중계사 > 딜러사 > 고객 = BLC > RLC > DLC
		- Admin 컬럼 추가 (BLC_ID사업자 추가)
		- Custom 컬럼 추가 (BLC_ID사업자 추가)
		- RLC테이블 컬럼 추가 (BLC_ID사업자 추가)
	- [] 기존 테이블 RLC에 BLC의 참조 ID가지는 컬럼 추가
	- [] Custom 테이블 BLC 컬럼 추가
		- 통계조회시 항상 Custom테이블을 조회한다.
	- [] SKT_ADMIN 일때 중계사 목록 취득시 COM_CD에서 가져오도록 되어있다. 이부분을 로그인한 사업자 BLC가 가진 중계사 RLC로 취득하도록 수정한다. 관련있는 화면들 전부 조사 필요
		=> com_cd에서 들고오지 않는 방향으로 수정이 되어야 할듯하다.  BLC로 들고오도록 한다.
	- [] 기존 테이블 (RLC, DLC)의 상위 테이블 (BLC 사업자)을 추가 및 mgmt_tp (사업자)추가경우할 경우 로직 영향도
		- [] 기존 쿼리 및 로직 영향 (eclipse: getMgmtTp 로 검색하여 약: 108개 내외)
			- AdminInfoMapper::selectAdminRoleList
			- MateController::searchFormInitByAdmin
			- adminUser/UserController
			- billing/BillingController
			- customerManage/CustomerController
			- messageManage/MateController
			- msgServerManage/ChargeMgmtController
			- SpcNumNumMgmgController
			- serviceMgmt/MobileWebController
			- stat/AnalyticsContrller
			- stat/DashboardController
			- stat/StatisticsController
			- survey/SurveyContrlller
		- [] 기존 스키마 영향(rlcId검색 : 16개 파일 148개 항목)
			billing
				billing.sqlmap.xml
			messageManage
				consultBillHist.sqlmap.xml
				surveyHist.sqlmap.xml
			momt/
				mo.sqlmap.xml
				mt.sqlmap.xml
			purchase
				customChargeBuy.sqlmap.xml
				customSpcNum.sqlmap.xml
				customSvcUpdHist.sqlmap.xml
			speparate
				inactiveAccount.sqlmap.xml
			serviceMgmt
				mobileWeb.sqlmap.xml
			statistics
				statistics.sqlmap.xml
			survey
				survey.sqlmap.xml
			user
				adminInfo.sqlmap.xml
				customerManage.sqlmap.xml
				userInfo.sqlmap.xml
			survey-agent/customer
				customer.sqlmap.xml
		


# QA (feat 유매니저님)
중계사 개념이 모호 하다. 아래는 유매니저님과 금일 통화한 내용을 정리한다.
## 중계사
상담비즈챗 중계사 따로
설문(마케팅)비즈챗 중계사 따로

참고) Admin > SuperAdmin로그인 > 메시지관리&통계 > 설문 이력 조회 > 중계사 콤보(5개가 나옴)
이중 4개(SKT제외)는 설문중계사이고, SKT는 상담중계사라고 한다. 

위의 개념들과 함께 고민이 되어야 한다.

## 영향도 화면
비지니스 오너 = 사업자  로 간주한다.

Admin > 통계(비지니스 오너별로)
Admin > 고객사 관리(비지니스 오너가 생김)
Admin > 운영관리(비지니스오너가 생김)
Admin > 서비스관리(슈퍼어드민)
-> 설문관리(비지니스오너가 생김)만 SKT /SKT DATA/ SKT B2B 중계사가 생기되.. 비지니스 오너가 다를것이다.
RLC테이블을 사용하는 테이블은 비지니스 오너 개념이 필요한지... 파악
※ 알림비즈챗, 마케팅비즈챗에는 화면은 나오더라도 아무것도 조회가 되지 않게 하면 된다.

## 오비즈 파악
인포뱅크는 마케팅/오비즈 중계사를 겸할수 있으나.. 마케팅 계정 따로, 오비즈 중계사 따로 만들 예정이다.
사업자 별로 슈퍼 어드민을 가지고 있다.(분류되어야 한다.)
이경우 로그인도 수정이 되어야 한다. 
공통으로 가지고 있는 슈퍼 어드민개념을 가지게 되면 별도의 화면이 개발이 되어야 하는 상황이 된다.


# 메일내용
유찬석 매니저님
안녕하세요. 전용수입니다.

금일 회의에서 Admin권한보완건에 대해서 일정산정 사유를 전달 드립니다.
그리고 맨 아래에 질문사항이 있습니다. 확인 부탁드립니다.

## Admin권한보완건 (추정: 4주)
1. 사업자 Admin 관리 테이블 생성
2. 관련 테이블 변경
	- Custom
	- Admin
	- Rlc
	- role
	- rsrc
3. 로직 영향도(로그인/통계 포함)
	- 로그인 로직 수정
	- 그외 로직 약 108개 항목 부분 수정
	- 로직은 대부분 사업자 Admin과의 조건 처리 추가가 변동사항
4. 쿼리 영향도
	- 쿼리 약 148개 항목 해당 부분 수정
	- 쿼리는 대부분 사업자 Admin 테이블 조인 처리 추가가 변동사항
5. 일정 산정 추정치 내역
	- 1주: 요구사항 정리 및 테이블 설계
	- 2주~3주: 쿼리 영향도 수정 > 로직 영향도 수정
	- 4주: 영향도 관련 있는 항목 테스트 및 테스트 대응 

## 개발사항
1. Admin 권한 보안건 개발 브런치
=> BIZCHAT-1070 최종 버전 => BIZCHAT-1074 브런치를 생성함
=> 관련 프로젝트: mmate-common, mmate-admin

## 참고사항
아래 내용은 일정 산정을 위한 사전 조사한 내역입니다. 참고용도로 보내드립니다.

- [] 테이블 영향
	- [] 사업자 테이블 추가 (테이블명(가제): BLC)
		- [] 사업자 > 중계사 > 딜러사 > 고객 = BLC > RLC > DLC
	- Admin 컬럼 추가 (BLC_ID사업자 추가)
	- Custom 컬럼 추가 (BLC_ID사업자 추가)
	- RLC테이블 컬럼 추가 (BLC_ID사업자 추가)
- [] 기존 테이블 RLC에 BLC의 참조 ID가지는 컬럼 추가
- [] Custom 테이블 BLC 컬럼 추가
	- 통계조회시 항상 Custom테이블을 조회한다.
- [] SKT_ADMIN 일때 중계사 목록 취득시 COM_CD에서 가져오도록 되어있다. 이부분을 로그인한 사업자 BLC가 가진 중계사 RLC로 취득하도록 수정한다. 관련있는 화면들 전부 조사 필요
	=> com_cd에서 들고오지 않는 방향으로 수정이 되어야 할듯하다.  BLC로 들고오도록 한다.
- [] 기존 테이블 (RLC, DLC)의 상위 테이블 (BLC 사업자)을 추가 및 mgmt_tp (사업자)추가경우할 경우 로직 영향도
	- [] 기존 쿼리 및 로직 영향 (eclipse: getMgmtTp 로 검색하여 약: 108개 내외)
		- AdminInfoMapper::selectAdminRoleList
		- MateController::searchFormInitByAdmin
		- adminUser/UserController
		- billing/BillingController
		- customerManage/CustomerController
		- messageManage/MateController
		- msgServerManage/ChargeMgmtController
		- SpcNumNumMgmgController
		- serviceMgmt/MobileWebController
		- stat/AnalyticsContrller
		- stat/DashboardController
		- stat/StatisticsController
		- survey/SurveyContrlller
	- [] 기존 스키마 영향(rlcId검색 : 16개 파일 148개 항목)
		billing
			billing.sqlmap.xml
		messageManage
			consultBillHist.sqlmap.xml
			surveyHist.sqlmap.xml
		momt/
			mo.sqlmap.xml
			mt.sqlmap.xml
		purchase
			customChargeBuy.sqlmap.xml
			customSpcNum.sqlmap.xml
			customSvcUpdHist.sqlmap.xml
		speparate
			inactiveAccount.sqlmap.xml
		serviceMgmt
			mobileWeb.sqlmap.xml
		statistics
			statistics.sqlmap.xml
		survey
			survey.sqlmap.xml
		user
			adminInfo.sqlmap.xml
			customerManage.sqlmap.xml
			userInfo.sqlmap.xml
		survey-agent/customer
			customer.sqlmap.xml


# 질문사항
1. 오비즈Admin 메뉴 항목 관련해서 질문입니다. 로그인시 메뉴항목들은 어떻게 처리되는지 잠깐 확인을 해보았습니다.
SuperAdmin권한으로 로그인했을경우(roleid: 51) 화면에 표시할 메뉴항목을 rsrc 테이블에서 조회해서 topMenu.jsp에 결과를 전송하여 메뉴를 표시하는듯합니다. 아래는 SuperAdmin의 roleid: 51 인경우 메뉴항목을 가져오는 쿼리입니다. 
```SQL
SELECT
rsrc.rsrc_id
,       rsrc.up_rsrc_id
,       rsrc.domain_tp_cd
,       rsrc.rsrc_nm
,   rsrc.rsrc_descr
,       rsrc.rsrc_url
,       rsrc.rsrc_tp_cd
,       rsrc.prt_ord
,       rsrc.prt_lvl
,       rsrc.prgm_id
,       rsrc.use_yn
,       rsrc.crt_dttm
,       rsrc.crt_user_id
,       rsrc.crt_prgm_id
,       rsrc.upd_dttm
,       rsrc.upd_user_id
,       rsrc.upd_prgm_id
FROM rsrc rsrc
LEFT OUTER JOIN role_rsrc_mapp  mapp    ON      mapp.rsrc_id = rsrc.rsrc_id
WHERE 1 = 1
AND mapp.role_id = 51
AND     rsrc.use_yn             = 'Y'
order by NVL(rsrc.up_rsrc_id, 0), prt_ord;
``` 
```권한별 roleid
select * from role
```
그렇다면 이번 Admin권한 보완에 관련하여 작업이 되어야 할 것이 role id 추가 rsrc 테이블에 해당 role id에 따른 접근 할 수 있는 
메뉴항목이 결과로 나와야 하는듯 보입니다. '사업자Admin'을 기존 SKT Admin (roleid: 52)로 대체해도 된다면 이것을 이용하는 방법을 고려하겠습니다. 

2. 만일 위와 같이 메뉴 항목을 DB조회해서 들고 온다면 오비즈Admin 같은 경우는 UI작업보다는 백엔드쿼리 조건으로 처리가 될듯합니다.
이부분이 저가 파악한것이 맞는지요? 물론 파생되는 UI작업 또한 있을수 있어 보입니다.

이상입니다. 감사합니다.

# 오비즈 분리
## 개발사항
1. 로그인시 오비즈 SuperAdmin/오비즈 고객사(중계사/딜러사/고객) 구분자를 정해서 UI에 넘겨야 한다.
2. 오비즈
- Web
=> BIZCHAT-1070 최종 버전 => BIZCHAT-1074 브런치를 생성함
- Admin
=> BIZCHAT-1070 최종 버전 => BIZCHAT-1074 브런치를 생성함

요금제에는 고객아이디/중계사아이디/딜러사아이디 BLC_ID를 넣어야 할지 파악
QA/1:1문의/공지사항 등이 사업자별로 보여주어야 한다.


# 20210118(주간회의)
## 오비즈Admin 테스트
인포뱅키가 사용하는 기존 CID를 상담비즈챗이다. 마케팅 비즈챗용도 CID는 별도로 신청을 해야 한다.(MMS/SMS용 CID 2개) 
- 서비스가 다르면 중계사가 달라야 한다.
- 기존 중계사 인포뱅크는 상담비즈챗용이다. 마케팅 비즈챗용 ID를 새로 하나 만들어서 해야 한다.

# 20200125
## WORK
- [X] custom 테이블에 기존 RLC/DLC 아이디는 어떻게 업뎃 하였는가?
	- 1. web사용자를 회원가입으로 입력하면 CUSTOM/SYSTEM_USER 테이블에 저장이 된다.
	- 2. Admin에서 Web사용자를 승인하면 CUSTOM테이블 갱신한다.
		- 이때 BLC/RLC/DLC가 UI에서 넘어와야 하는듯 한데.. 안넘어오게 처리되었다. 이는 수동으로 입력해야 하는것으로 보인다. (★질문사항1)
		- 승인시 role 정보를 조회는 BLC인경우 판단해야 하는데... role_rsrc_mapp 테이블의 키값은 role_id + rsrc_id 이다. blc_id 가 포함이 되면 키는
		  role_id + rsrc_id + blc_id 가 되어야 하지 않을...(★질문사항2) (※ 이는 OBIZ Admin도 마찬가지이다.)
			- 방법 2가지 중하나
				★ 1. role 를 새로 생성하는 방법(Web:101, ADM:51) 이방법을 사용해보자
					- role_rsrc_mapp 에도 새로 발급된 role_id에 따라 생성
					- 수정 ★
						1. [X] Admin::CustomerService.java ::: CUAD ==> OBIZ_CUAD 로직 수정
						2. [X] role 테이블에 OBIZ_CUAD 추가
						3. [X] 오비즈 사용자 user_role_mapp 에 roleId 수정
				2. role_rsrc_mapp (키값: role_id + rsrc_id + blc_id)로 구분해서 하는 방법

# 20200131
## 분석
- [X] 비즈챗Admin 에서 관리자 추가 분석 (UserController::save)
	- [X] 테이블 저장
		- system_user
		- admin
		- sep_user_role_mapp (SuperAdmin/SKTADMIN/중계사/딜러사에 따라 롤을 부여하도록 되어 있다.)
	- [X] 로그인
		- 1. 로그인시 system_user/user_role_mapp/admin/role 에서 모든 role에 관련된 정보를 가져온다.
		- 2. role정보에 roleid를 이용하여 rsrc/rsrc_role_mapp 조회하여 메뉴정보를 조회한다.

- [X] 오비즈용인지 판별
	- Admin계정이면 Admin테이블에 저장된다.
		- 이경우 오비즈Admin 을 판별하는 방법은 
		1. 우선 최초에 오비즈용SuperAdmin 계정이 있어야 한다. (수동으로 insert)
		2. 아래 쿼리를 이용하여 해당 blc_id가 오비즈이면 오비즈의 SuperAdmin계정인것이다.
		select blc_id from system_user a inner join admin b on a.user_id = b.user_id;

		3. 그리고, 오비즈의 사업자Admin 비지니스아이디(BLC테이블의 BLC_ID)는 한개이다.
	- Web계정이면 custom_contact테이블에 저장된다.
		- 오비즈Web 계정이면 custom_contact 를 조회해서 custom테이블에 blc_id를 보고 해당 오비즈blc_id이면 오비즈web계정으로 판단한다.

	- [X] 정리하기 위해서
		- [X] 오비즈Admin용 슈퍼어드민이 있다. BLC_ID도 있는것을 인지해야 한다.
		- [X] 오비즈Web같은 경우는 이미 오비즈 용도의 롤이나/BlcID 를 가지고 있을 것이다. 이부분은 파악해야함.

	- [X] OBIZ_CUST/OBIZ_API 로 디비에 저장한것은 원복하도록 한다. / 로직도 원복 하도록 한다.

- [X] 현재까지 관리자등록시 들고오는  아이디 유형에 OBIZ인경우 OBIZ만 들고오도록 하였다.
	- [X] 이를 위해선 오비즈 중계사/딜러사 명칭에는 '_OBIZ' 가 붙어야 한다.
		- [X] mapper 와  bybatis에서 String인경우 오류가 나서 @Param("keyWord") 했더니 되더라
