-- RCS 슬라이드별 정보(SURVEY_SEQ 1개당 최대 6개 슬라이드)
CREATE TABLE SURVEY_RCS(
    RCS_SEQ				NUMBER(18) NOT NULL,		/* RCS설문 일련번호 */
    SURVEY_SEQ			NUMBER(18) NOT NULL,        /* SURVEY 일련번호 */
	RCS_AGRE_PRT_ORD	NUMBER(3) NOT NULL,			/* 슬라이드 순서 */
    RCS_AGRE_TITLE_MSG	VARCHAR2(4000) NOT NULL,	/* 설문동의 메시지 */
    RCS_AGRE_GUIDE_MSG	VARCHAR2(4000) NOT NULL,	/* 설문 메시지 */


    RCS메시지 타입(엑셀의 번호) 
    10번인경우 카드 수를 알수 있는 컬럼...
    이미지 시퀀스 넘버가 필요한다. 조사.. (SND_MSG_SEQ + "_" + 1, 예) 27008526_0.jpg, 27008526_1.jpg, 
    이미지는 mapperurl: 이 있어야 한다. (등록)

    RCS_AGRE_IMG_FILE_PATH VARCHAR2(500) NULL		/* 설문동의 이미지 (슬라이드이미지) 이미지가 없으면 RCS_LMS, 있으면 RCS_MMS */
)
CREATE UNIQUE INDEX PK_SURVEY_RCS ON SURVEY_RCS
(RCS_SEQ   ASC);

ALTER TABLE SURVEY_RCS
	ADD CONSTRAINT  PK_SURVEY_RCS PRIMARY KEY (RCS_SEQ);

-- 다시 설계하자
SURVEY_SEQ, RCS메시지타입, 카드수, 푸터(무료수신거부번호), 1_TITLE_MSG, 1_GUIDE_MSG, 1_IMG_FILE_PATH, ... , 6_TITLE_MSG, 6_GUIDE_MSG, 6_IMG_FILE_PATH, 
이미지 사이즈도 있어야 할까... 왜냐면 RCS발송시 이미지 전체가 1메가가 한정이다.

-- 슬라이드별 버튼정보(최대 2개)
CREATE TABLE SURVEY_RCS_BTN(
    RCS_BTN_SEQ		NUMBER(18) NOT NULL,		/* RCS설문버튼 일련번호 */
    RCS_SEQ			NUMBER(18) NOT NULL,		/* RCS 일련번호  */
    BTN_TYPE        VARCHAR2(10) NOT NULL, 		/* URL/CALL/MAP */
    BTN_NAME		VARCHAR2(20) NULL,	    	/* 버튼명 */
    BTN_URL	        VARCHAR2(100) NULL,	    	/* URL */
    BTN_PHONE_NUM   VARCHAR2(20) NULL,			/* 전화번호 */
    BTN_GEO_NAME	VARCHAR2(100) NULL,	    	/* 지도 이름 */
    BTN_GEO_URL		VARCHAR2(100) NULL	    	/* 지도 URL */
)
CREATE UNIQUE INDEX PK_SURVEY_RCS_BTN ON SURVEY_RCS_BTN
(RCS_BTN_SEQ   ASC);

ALTER TABLE SURVEY_RCS_BTN
	ADD CONSTRAINT  PK_SURVEY_RCS_BTN PRIMARY KEY (RCS_BTN_SEQ);


-- V2 슬라이드별 버튼정보(최대 2개) 여기에 버튼순서 컬럼을 넣도록 하자. SEQ로 엮는것으로 하지 말자..SEQ는 조회용도
CREATE TABLE SURVEY_RCS_BTN(
    RCS_BTN_SEQ		NUMBER(18) NOT NULL,		/* RCS설문버튼 일련번호 */
    RCS_SEQ			NUMBER(18) NOT NULL,		/* RCS 일련번호  */
    BTN_TYPE        VARCHAR2(10) NOT NULL, 		/* URL/CALL/MAP */
    BTN_NAME		VARCHAR2(20) NULL,	    	/* 버튼명 */
    BTN_URL	        VARCHAR2(100) NULL,	    	/* URL */
    BTN_PHONE_NUM   VARCHAR2(20) NULL,			/* 전화번호 */
    BTN_GEO_NAME	VARCHAR2(100) NULL,	    	/* 지도 이름 */
    BTN_GEO_URL		VARCHAR2(100) NULL	    	/* 지도 URL */
)
CREATE UNIQUE INDEX PK_SURVEY_RCS_BTN ON SURVEY_RCS_BTN
(RCS_BTN_SEQ   ASC);

ALTER TABLE SURVEY_RCS_BTN
	ADD CONSTRAINT  PK_SURVEY_RCS_BTN PRIMARY KEY (RCS_BTN_SEQ);

