-- Admin사업자
CREATE TABLE MMADMIN.BLC (
	BLC_ID NUMBER NOT NULL,				-- Admin사업자ID
	BLC_CD VARCHAR2(20) NOT NULL, 		-- Admin사업자코드
	BLC_NM VARCHAR2(100) NOT NULL, 		-- Admin사업자명
	CRT_DTTM DATE DEFAULT CURRENT_TIMESTAMP NOT NULL, -- 생성일시
	CRT_USER_ID VARCHAR2(20) NOT NULL, 	-- 생성유저ID
	CRT_PRGM_ID VARCHAR2(20) NOT NULL, 	-- 생성프로그램ID
	UPD_DTTM DATE DEFAULT CURRENT_TIMESTAMP NOT NULL, -- 수정일시
	UPD_USER_ID VARCHAR2(20) NOT NULL, 	-- 수정유저ID
	UPD_PRGM_ID VARCHAR2(20) NOT NULL, 	-- 수정프로그램ID
	BLC_DISP_NM VARCHAR2(100) 			-- Admin사업자전시명
)
TABLESPACE TS_TMM_DAT01
STORAGE
(
INITIAL 10M
NEXT 10M
)
NOCOMPRESS;

ALTER TABLE MMADMIN.BLC
ADD CONSTRAINT PK_BLC PRIMARY KEY (BLC_ID);

CREATE SEQUENCE MMADMIN.BLC_ID
START WITH 1
INCREMENT BY 1
MINVALUE 1
MAXVALUE 999999999999999999;

GRANT SELECT ON MMADMIN.BLC_ID TO MMUSER;

GRANT DELETE ON MMADMIN.BLC TO MMUSER;
GRANT UPDATE ON MMADMIN.BLC TO MMUSER;
GRANT SELECT ON MMADMIN.BLC TO MMUSER;
GRANT INSERT ON MMADMIN.BLC TO MMUSER;

CREATE SYNONYM MMUSER.BLC FOR MMADMIN.BLC;
CREATE SYNONYM MMUSER.BLC_ID FOR MMADMIN.BLC_ID;

-- 중계사 테이블 컬럼 추가
ALTER TABLE RLC ADD (
    blc_id	NUMBER -- Admin사업자ID
);

-- 운영자 테이블 컬럼 추가
ALTER TABLE ADMIN ADD (
    blc_id	NUMBER -- Admin사업자ID 
);

-- 고객사 테이블 컬럼 추가
ALTER TABLE CUSTOM ADD (
    blc_id	NUMBER -- Admin사업자ID
);

-- 분리고객사 테이블 컬럼 추가
ALTER TABLE SEP_CUSTOM ADD (
    blc_id	NUMBER -- Admin사업자ID
);

-- 공지사항 테이블 컬럼 추가
ALTER TABLE NOTI ADD (
    blc_id	NUMBER -- Admin사업자ID
);

-- FAQ 테이블 컬럼 추가
ALTER TABLE FAQ ADD (
    blc_id	NUMBER -- Admin사업자ID
);

-- 1:1문의 테이블 컬럼 추가
ALTER TABLE QNA ADD (
    blc_id	NUMBER -- Admin사업자ID
);

-- 공통코드 컬럼 추가
ALTER TABLE COM_CD ADD (
    blc_id	NUMBER -- Admin사업자ID
);

-- 역할자원매핑 테이블 컬럼 추가
ALTER TABLE ROLE_RSRC_MAPP ADD (
     BLC_ID NUMBER -- Admin사업자ID 
);

-- 이벤트 테이블 컬럼 추가
ALTER TABLE EVENT_MGMT ADD (
    BLC_ID NUMBER -- 사업자 ID
);

-- 문서 다운로드 요청 테이블 컬럼 추가
ALTER TABLE DOC_DL_REQ ADD (
    BLC_ID NUMBER -- 사업자 ID
);



-- # DML
1. 오비즈사업 관련 데이터를 입력하기 전에 아래와 같은 설정이 우선되어야 한다.

-- ## BLC 테이블 입력
-- 1. 비즈챗 사업 => BLC_ID : 1
-- 주의사항: 반드시 'BLC_'로 시작하는 문구로 한다. 로직/쿼리와 연관된다.
insert into blc (
    blc_id, blc_cd, blc_nm, crt_dttm, crt_user_id, crt_prgm_id, upd_dttm, upd_user_id, upd_prgm_id, blc_disp_nm
) values (1,'BLC_BIZCHAT','비즈챗(BIZCHAT)',SYSDATE,'INIT','INIT',SYSDATE,'INIT','INIT','비즈챗');
-- 2. 오비즈 사업 => BLC_ID : 10
insert into blc (
    blc_id, blc_cd, blc_nm, crt_dttm, crt_user_id, crt_prgm_id, upd_dttm, upd_user_id, upd_prgm_id, blc_disp_nm
) values (10,'BLC_OBIZ','오비즈(OBIZ)',SYSDATE,'INIT','INIT',SYSDATE,'INIT','INIT','오비즈');

-- ## RLC 테이블
-- 1. 기존 비즈챗 blcid로 전부 세팅한다.
update rlc set blc_id = 1;

-- ## ADMIN 테이블
-- 1. 기존 비즈챗 blcid로 전부 설정
update admin set blc_id = 1;

-- ## CUSTOM 테이블
-- 1. 기존 비즈챗 blcid로 전부 설정
update custom set blc_id = 1;

-- ## SEP_CUSTOM 테이블
-- 1. 기존 비즈챗 blcid로 전부 설정
update sep_custom set blc_id = 1;

-- ## NOTI 테이블
-- 1. 기존 비즈챗 blcid로 전부 설정
update noti set blc_id = 1;

-- ## FAQ 테이블
-- 1. 기존 비즈챗 blcid로 전부 설정
update faq set blc_id = 1;

-- ## QNA 테이블
-- 1. 기존 비즈챗 blcid로 전부 설정
update qna set blc_id = 1;

-- ## COM_CD 테이블
-- 1. 공통 코드에서 코드 종류 'RLC_TP_CD' 인것만 세팅
update com_cd set blc_id = 1 where cd_grp_id = 'RLC_TP_CD'
-- 2. 오비즈 중계사도 입력을 하도록 한다. (주의: blc_id 충돌이 안나야 한다.)

-- ## EVENT_MGMT 테이블
-- 1. 공통 코드에서 코드 종류 'RLC_TP_CD' 인것만 세팅
update EVENT_MGMT set blc_id = 1;

-- ## EVENT_MGMT 테이블
-- 1. 공통 코드에서 코드 종류 'RLC_TP_CD' 인것만 세팅
update DOC_DL_REQ set blc_id = 1;



-- ## ROLE 테이블 (오비즈용 롤 생성)
-- ## RSRC 테이블 (오비즈용 리소스 생성)
-- ## ROLE_RSRC_MAPP 테이블 (오비즈용 맵핑 생성)
