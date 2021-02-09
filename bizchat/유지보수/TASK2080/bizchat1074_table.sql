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
