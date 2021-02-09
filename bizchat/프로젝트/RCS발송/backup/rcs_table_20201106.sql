-- version 0.5
-- RCS 추가 테이블

-- RCS 슬라이드별 정보(SURVEY_SEQ 1개당 최대 6개 슬라이드)
CREATE TABLE SURVEY_RCS(
    RCS_SEQ				    NUMBER(18) NOT NULL,	/* RCS설문 일련번호 */
    SURVEY_SEQ			    NUMBER(18) NOT NULL,    /* SURVEY 일련번호 */
    RCS_MSG_TYPE            NUMBER(10) NOT NULL,    /* RCS 메시지 타입 */
    SLIDE_CNT               NUMBER(10) NOT NULL,    /* 슬라이드 개수 */
    FOOTER_PHONE_NUM        VARCHAR2(20) NOT NULL,  /* 푸터 폰넘버 */  
    TITLE_MSG_1	            VARCHAR2(4000) NULL,    /* 설문동의 메시지 1번째 */
    GUIDE_MSG_1	            VARCHAR2(4000) NULL,    /* 설문 메시지 1번째*/
    IMG_FILE_PATH_1         VARCHAR2(500) NULL,		/* 설문동의 이미지 물리저장PATH (슬라이드이미지) 이미지가 없으면 RCS_LMS, 있으면 RCS_MMS 1 번째 */
    IMG_FILE_URL_1          VARCHAR2(100) NULL,		/* 설문동의 이미지 maaperurl  (물리저장PATH 컬럼으로 대신할 수 있다. 1차적으로 따로 컬럼을 만듬*/
    TITLE_MSG_2	            VARCHAR2(4000) NULL,    
    GUIDE_MSG_2	            VARCHAR2(4000) NULL,    
    IMG_FILE_PATH_2         VARCHAR2(500) NULL,     /* 2 번째 (형태: /OO/OO/OO/이미지.jpg)*/
    IMG_FILE_URL_2          VARCHAR2(100) NULL,     /* 2 번째 (형태: 유니크 64자리 + _2) */
    TITLE_MSG_3	            VARCHAR2(4000) NULL,    /* 3 번째 */
    GUIDE_MSG_3	            VARCHAR2(4000) NULL,
    IMG_FILE_PATH_3         VARCHAR2(500) NULL,
    IMG_FILE_URL_3          VARCHAR2(100) NULL,
    TITLE_MSG_4             VARCHAR2(4000) NULL,    /* 4 번째 */
    GUIDE_MSG_4             VARCHAR2(4000) NULL,
    IMG_FILE_PATH_4         VARCHAR2(500) NULL,
    IMG_FILE_URL_4          VARCHAR2(100) NULL,
    TITLE_MSG_5	            VARCHAR2(4000) NULL,    /* 5 번째 */
    GUIDE_MSG_5	            VARCHAR2(4000) NULL,
    IMG_FILE_PATH_5         VARCHAR2(500) NULL,
    IMG_FILE_URL_5          VARCHAR2(100) NULL,
    TITLE_MSG_6             VARCHAR2(4000) NULL,    /* 6 번째 */
    GUIDE_MSG_6	            VARCHAR2(4000) NULL,
    IMG_FILE_PATH_6         VARCHAR2(500) NULL,
    IMG_FILE_URL_6          VARCHAR2(100) NULL
)
CREATE UNIQUE INDEX PK_SURVEY_RCS ON SURVEY_RCS
(RCS_SEQ   ASC);

ALTER TABLE SURVEY_RCS
	ADD CONSTRAINT  PK_SURVEY_RCS PRIMARY KEY (RCS_SEQ);

-- 슬라이드별 버튼정보(최대 2개)
CREATE TABLE SURVEY_RCS_BTN(
    RCS_BTN_SEQ		    NUMBER(18) NOT NULL,	/* RCS설문버튼 일련번호 */
    RCS_SEQ			    NUMBER(18) NOT NULL,	/* RCS 일련번호  */
    RCS_SLIDE_ORD       NUMBER(3) NOT NULL,     /* RCS슬라이드 순서(1~6) */
    BTN_TYPE_1          VARCHAR2(10) NULL, 	    /* URL/CALL/MAP 1번째*/
    BTN_NAME_1          VARCHAR2(20) NULL,	    /* 버튼명 1번째*/
    ACT_URL_1	        VARCHAR2(100) NULL,	    /* URL 1번째*/
    ACT_PHONE_NUM_1     VARCHAR2(20) NULL,		/* 전화번호 1번째*/
    GEO_NAME_1          VARCHAR2(100) NULL,	    /* 지도 이름 1번째*/
    GEO_URL_1		    VARCHAR2(100) NULL	    /* 지도 URL 1번째*/
    BTN_TYPE_2          VARCHAR2(10) NULL, 	    /* 2번째 */
    BTN_NAME_2		    VARCHAR2(20) NULL,	    /* 2번째 */
    ACT_URL_2	        VARCHAR2(100) NULL,	    /* 2번째 */
    ACT_PHONE_NUM_2     VARCHAR2(20) NULL,		/* 2번째 */
    GEO_NAME_2          VARCHAR2(100) NULL,	    /* 2번째 */
    GEO_URL_2		    VARCHAR2(100) NULL	    /* 2번째 */
)
CREATE UNIQUE INDEX PK_SURVEY_RCS_BTN ON SURVEY_RCS_BTN
(RCS_BTN_SEQ   ASC);

ALTER TABLE SURVEY_RCS_BTN
	ADD CONSTRAINT  PK_SURVEY_RCS_BTN PRIMARY KEY (RCS_BTN_SEQ);