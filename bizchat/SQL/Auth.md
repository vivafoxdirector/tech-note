-- # Auth
-- # 권한관련 테이블
-- ## ADMIN 사용자
select * from admin;    -- 운영자테이블, mgmtc_tp에서 RLC, DLC구분
select * from admin where login_email = 'tobizuser05';
select distinct mgmtc_tp from admin;
select * from system_user; -- ADMIN, API, CUST
select * from system_user where login_email = 'ysjeon';
select * from user_role_mapp;

-- ## WEB 사용자
select * from system_user where user_nm like 'dev_obiztest';
select appr_dttm, login_dttm from custom_contact where custom_id = 2952;
select * from custom where user_id = 2832;
select * from custom_contact where custom_id = 2832;
update custom_contact set login_fail_cnt = 0 where custom_id = 2832;
commit;
select * from custom_contact where custom_id = 2952;


commit;

select * from

select * from rlc;
select * from dlc;

select * from;

update custom_contact set login_dttm = null where custom_id = 2926;
update custom_contact set appr_dttm = sysdate - 400 where custom_id = 2926;
commit;

SELECT
    user_id, contact_nm, email, contact_tp, custom_id
    , nvl(login_dttm, appr_dttm) AS last_dttm
FROM custom_contact
WHERE join_state_cd IN ('JOIN_SUCC', 'LEAVE_RES', 'LEAVE_RETN')
AND contact_tp = 'ASS'
AND ( (login_dttm IS NULL AND appr_dttm <= SYSDATE - 1)
       OR login_dttm <= SYSDATE - 1
)
UNION ALL
SELECT
    user_id, contact_nm, email, contact_tp, custom_id
    , nvl(login_dttm, appr_dttm) AS last_dttm
FROM custom_contact cu
WHERE join_state_cd IN ('JOIN_SUCC', 'LEAVE_RES', 'LEAVE_RETN')
AND contact_tp = 'CHR'
AND ( (login_dttm IS NULL AND appr_dttm <= SYSDATE - 1)
       OR login_dttm <= SYSDATE - 1
)
AND NOT EXISTS (
    SELECT custom_charge_buy_id
        FROM custom_charge_buy buy
        WHERE buy.custom_id = cu.custom_id
        AND NVL(unsub_dttm, SYSDATE) >= sysdate - 1)

select * from custom_charge_buy where custom_id = 2926;
-- ## role_id가 곧 권한 아이디 (Super Admin: 51)
select * from role; -- 역할
select * from rsrc; -- 자원
select * from rsrc where rsrc_descr like '%특번%';
select * from rsrc where rsrc_id in (593, 594)
select * from role_rsrc_mapp;   -- 역할자원매핑
select * from role_rsrc_mapp where role_id = 51;    -- SuperAdmin 가진 자원


SELECT
	   *
FROM (
	SELECT c.custom_charge_buy_id
			 , b.charge_id
			 , c.custom_id
			 , a.telecom_cd
			 , (SELECT cd_nm FROM com_cd WHERE cd_grp_id = 'TELECOM_CD' AND cd_id = a.telecom_cd) telecom_nm
		 , a.svc_id
			 , a.svc_cl
			 , a.charge_svc_nm
			 , b.charge_nm
			 , NVL(c.use_yn, 'N') use_yn
			 , c.buy_dttm
			 , a.sttl_cl_cd
			 , b.price
			 , b.provide_cnt
			 , b.bill_tp_cd
			 , CASE WHEN a.telecom_cd = 'SKT'
					THEN 1
					WHEN a.telecom_cd = 'KT'
					THEN 2
					WHEN a.telecom_cd = 'LGU'
					THEN 3
			   END ord
	  FROM charge_svc a
			 , charge b
			 , custom_charge_buy c
	 WHERE a.svc_id = b.svc_id
	   AND b.charge_id = c.charge_id
	   AND a.charge_cl = 'MSG'
	   --AND c.custom_id = 2132
	   AND b.use_yn = 'Y'
	   AND c.use_yn = 'Y'
	   AND a.svc_cl = 'OB'
)
ORDER BY ord, price DESC;
select * from charge_svc;



-- ## 비지니스오더(구 SKT ADMIN)
select * from BLC;

-- ## 중계사
select * from RLC;

-- ## 딜러사
select * from DLC;

-- ## 고객
select * from custom;

-- ## Admin
select * from admin;

-- ## Noti
select * from noti;

-- ## FAQ
select * from faq;

-- ## 1:1
select * from qna;

-- ## 분리고객?????
select * from sep_custom;

-- ## 공통코드
select * from com_cd;

-- ## 로그인
SELECT
    u.user_id
         , (select blc_cd from blc where blc_id = a.blc_id) as blc_cd
    , u.user_tp_cd
    , u.user_nm
    , u.user_descr
    , a.login_email
    , a.login_pw
    , a.login_dttm
    , NVL(a.login_fail_cnt, 0) AS login_fail_cnt
    , a.login_pw_upd_dt
    , a.email
    , a.cell_phone
    , a.tele_phone
    , a.state_cd
    , a.use_yn
    , a.crt_dttm
    , a.crt_user_id
    , a.crt_prgm_id
    , a.upd_dttm
    , a.upd_user_id
    , a.upd_prgm_id
    , a.crt_user_ip
    , role.role_id          AS role__role_id
    , role.role_tp_cd       AS role__role_tp_cd
    , role.role_nm          AS role__role_nm
    , role.role_descr       AS role__role_desc
    , role.use_yn           AS role__use_yn
    , a.blc_id
    , a.rlc_id
    , a.dlc_id
    , a.mgmtc_tp
FROM system_user u
INNER JOIN admin a
ON      u.user_id = a.user_id
LEFT OUTER JOIN user_role_mapp  mapp
ON      a.user_id = mapp.user_id
LEFT OUTER JOIN role role
ON      mapp.role_id = role.role_id
WHERE u.user_tp_cd = 'ADMIN'
AND a.login_email = 'dobizbadm01';

select role_id from admin a inner join user_role_mapp b on a.user_id = b.user_id where a.login_email = 'ysjeon';
select role_id from user_role_mapp where user_id = 2930;
update user_role_mapp set role_id = 252 where user_id = 2930;
update user_role_mapp set role_id = 251 where user_id = 2834;
commit;

select b.* from role_rsrc_mapp a inner join rsrc b on a.rsrc_id = b.rsrc_id where role_id = 251 and b.use_yn = 'Y' order by b.rsrc_id;
select b.* from role_rsrc_mapp a inner join rsrc b on a.rsrc_id = b.rsrc_id where role_id = 52 and b.use_yn = 'Y' order by b.rsrc_id;
select b.* from role_rsrc_mapp a inner join rsrc b on a.rsrc_id = b.rsrc_id where role_id = 60 and b.use_yn = 'Y' order by b.rsrc_id;
select b.* from role_rsrc_mapp a inner join rsrc b on a.rsrc_id = b.rsrc_id where role_id = 70 and b.use_yn = 'Y' order by b.rsrc_id;


select b.user_id, b.role_id from admin a inner join user_role_mapp b on a.user_id = b.user_id where a.login_email = 'dobizdadm02';
update user_role_mapp set role_id = 270 where user_id = 2911;


select b.* from role_rsrc_mapp a inner join rsrc b on a.rsrc_id = b.rsrc_id where role_id = 55 and b.use_yn = 'Y' order by b.rsrc_id;
commit;


INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 1, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 2, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 3, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 4, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 5, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 6, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 8, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 13, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 21, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 22, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 23, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 25, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 26, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 29, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 30, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 31, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 32, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 34, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 36, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 37, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 49, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 50, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 51, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 52, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 53, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 54, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 55, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 56, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 57, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 58, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 59, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 60, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 61, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 62, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 63, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 64, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 65, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 66, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 67, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 68, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 69, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 75, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 76, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 77, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 78, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 79, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 81, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 91, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 92, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 93, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 94, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 95, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 96, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 97, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 98, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 99, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 100, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 101, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 102, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 103, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 104, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 105, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 106, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 107, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 110, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 111, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 112, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 113, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 114, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 115, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 137, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 141, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 143, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 144, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 145, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 190, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 205, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 235, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 289, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 290, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 2020, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 2021, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 2928, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 2940, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 2941, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 2942, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 2943, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 2944, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 2945, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 2946, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 2947, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 2948, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 2949, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 2950, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 2951, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 2952, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 2972, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 2973, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 2974, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 2975, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 2976, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 2977, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 2978, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 2979, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 2980, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 2981, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 2982, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 2983, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 2984, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 2985, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 2986, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 3010, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 3011, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 3012, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 3013, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 3018, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 3019, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 3114, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(255, 3115, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
commit;

select * from role where role_tp_cd like '%OBIZ%'

select b.* from role_rsrc_mapp a inner join rsrc b on a.rsrc_id = b.rsrc_id where role_id = 200 and b.use_yn = 'Y' order by b.rsrc_id;
select * from rsrc where rsrc_id = 2593;

INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 2593, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 2594, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);

select * from role_rsrc_mapp where role_id = 200;

-- AND a.login_email like 'dblc%';
SELECT d.DLC_ID, d.RLC_ID
		FROM DLC d, RLC r
		WHERE d.DLC_CD = #{dlcCd}
		AND d.RLC_ID = r.RLC_ID;

select * from dlc;
update dlc set dlc_cd = 'DLC_OBIZ06' where dlc_id = 205;
commit;

select sysdate-100 from dual;
select * from admin where login_email = 'test_vasteam';
select * from admin where blc_id = 10;
-- # 계정정보 조회
-- ## 오비즈 계정 조회
select * from admin where blc_id = 10;
select * from admin where user_id = 2904;
select * from system_user where user_id = 2904;
select * from user_role_mapp where user_id = 2904;

-- ## 오비즈 계정정보 삭제
delete from admin where user_id in (2915, 2916, 2912);
delete from system_user where user_id in (2915, 2916, 2912);
delete from user_role_mapp where user_id in (2915, 2916, 2912);
commit;



SELECT * FROM (
    SELECT ROWNUM AS RNUM, A.* FROM (
    SELECT
    a.user_id
    , a.custom_id
    , sep_cu.blc_id
    , NVL(sys.user_nm, sep_sys.user_nm)  AS custom_nm
    , a.sep_dttm
    FROM sep_custom_contact a
    LEFT OUTER JOIN custom cu ON a.custom_id = cu.user_id
    LEFT OUTER JOIN system_user sys ON cu.user_id = sys.user_id
    LEFT OUTER JOIN sep_custom sep_cu ON a.custom_id = sep_cu.user_id
    LEFT OUTER JOIN sep_system_user sep_sys ON sep_cu.user_id = sep_sys.user_id
    WHERE  a.sep_tp IN ('NME', 'NMI')
ORDER BY sep_dttm desc
) A
);

-- ## 휴면계정 판단
SELECT
    user_id, contact_nm, email, contact_tp, custom_id
    , nvl(login_dttm, appr_dttm) AS last_dttm
FROM custom_contact
WHERE join_state_cd IN ('JOIN_SUCC', 'LEAVE_RES', 'LEAVE_RETN')
AND contact_tp = 'ASS'
AND ( (login_dttm IS NULL AND appr_dttm <= SYSDATE - 1)
       OR login_dttm <= SYSDATE - 1
)
UNION ALL
SELECT
    user_id, contact_nm, email, contact_tp, custom_id
    , nvl(login_dttm, appr_dttm) AS last_dttm
FROM custom_contact cu
WHERE join_state_cd IN ('JOIN_SUCC', 'LEAVE_RES', 'LEAVE_RETN')
AND contact_tp = 'CHR'
AND ( (login_dttm IS NULL AND appr_dttm <= SYSDATE - 1)
       OR login_dttm <= SYSDATE - 1
)
AND NOT EXISTS (
    SELECT custom_charge_buy_id
        FROM custom_charge_buy buy
        WHERE buy.custom_id = cu.custom_id
        AND NVL(unsub_dttm, SYSDATE) >= sysdate - 1)
;

SELECT cdId, cdNm FROM (
                        SELECT A.*, ROWNUM FROM(
                SELECT
                ROLE_tp_cd as cdId,
                ROLE_NM as cdNm
                FROM ROLE
                WHERE DOMAIN_TP_CD = 'ADMIN' AND role_tp_cd IN ('SUA', 'ADM')
                UNION ALL
                SELECT
                RLC_CD as cdId,
                RLC_NM as cdNm
                FROM RLC
                WHERE BLC_ID = 10
                UNION ALL
                SELECT
                DLC_CD as cdId,
                DLC_NM as cdNm
                FROM DLC
                WHERE RLC_ID IN (SELECT RLC_ID FROM RLC WHERE BLC_ID = 10)
                UNION ALL
                                SELECT
                                ROLE_tp_cd as cdId,
                                ROLE_NM as cdNm
                                FROM ROLE
                                WHERE DOMAIN_TP_CD = 'ADMIN' AND role_tp_cd IN ('OPR', 'DEV')
                        ) A
                );


SELECT
ROLE_tp_cd as cdId,
ROLE_NM as cdNm
FROM ROLE
WHERE DOMAIN_TP_CD = 'ADMIN' AND role_tp_cd IN ('SUA', 'ADM')
select * from role where domain_tp_cd = 'ADMIN'
update role set role_nm = '사업자 Admin' where role_id = 52;
commit;

select * from custom where rlc_id = 100;

-- # 고객사 조회
SELECT /* [user/userInfo.sqlmap.xml].[selectCustomUserList] by hwkim */
    a.user_id
    , a.user_nm
FROM system_user a
WHERE EXISTS (
    SELECT '1'
    FROM custom b
    WHERE b.user_id = a.user_id
    AND  b.join_state_cd in ('JOIN_SUCC', 'LEAVE_RES')
)
ORDER BY a.user_nm ASC;

select * from admin;

select * from custom;
select * from system_user where user_tp_cd = 'ADMIN'
select * from blc where blc_id = 10;
select * from rlc where rlc_id =100;
select * from system_user;
select * from admin where login_email like 'dobiz%';
update admin set MGMTC_TP = 'BLC' where user_id = 2835;commit
select * from blc;
select * from role;
select * from rlc;
select * from dlc;
select * from system_user;
select * from admin;
select * from user_role_mapp where user_id = 2753;
select * from role; where role_id =51;

select * from rsrc;
select * from role_rsrc_mapp;
select * from admin;

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
-- AND mapp.blc_id = 100
AND rsrc.use_yn             = 'Y'
order by NVL(rsrc.up_rsrc_id, 0), prt_ord;
select * from rsrc;
select * from role_rsrc_mapp;

select * from role;
select * from user_role_mapp where user_id = 2753;
select * from role_rsrc_mapp where role_id = 51;

select * from blc;


>SELECT
                        u.user_id
                        , u.user_tp_cd
                        , u.user_nm
                        , u.user_descr
                        , a.login_email
                        , a.login_pw
                        , a.login_dttm
                        , NVL(a.login_fail_cnt, 0) AS login_fail_cnt
                        , a.login_pw_upd_dt
                        , a.email
                        , a.cell_phone
                        , a.tele_phone
                        , a.state_cd
                        , a.use_yn
                        , a.crt_dttm
                        , a.crt_user_id
                        , a.crt_prgm_id
                        , a.upd_dttm
                        , a.upd_user_id
                        , a.upd_prgm_id
                        , a.crt_user_ip
                        , role.role_id          AS role__role_id
                        , role.role_tp_cd       AS role__role_tp_cd
                        , role.role_nm          AS role__role_nm
                        , role.role_descr       AS role__role_desc
                        , role.use_yn           AS role__use_yn
                        , a.blc_id
                        ,
 (select blc_cd
 from blc
 where blc_id = a.blc_id) as blc_cd
                        , a.rlc_id
                        , a.dlc_id
                        , a.mgmtc_tp
                FROM system_user u
                INNER JOIN admin a
                ON      u.user_id = a.user_id
                LEFT OUTER JOIN user_role_mapp  mapp
                ON      a.user_id = mapp.user_id
                LEFT OUTER JOIN role role
                ON      mapp.role_id = role.role_id
                WHERE u.user_tp_cd = 'ADMIN'
                AND a.login_email = 'dblcadmin01'

select * from admin;
select * from admin where login_email = 'dobizsadmin';
update admin set blc_id = 10 where login_email = 'dobizsadmin';
commit;


		SELECT d.RLC_ID, d.BLC_ID
		FROM RLC d, BLC r
		WHERE d.RLC_CD = #{rlcCd}
		AND d.BLC_ID = r.BLC_ID
select * from rlc;
select * from blc;
select * from role where role_tp_cd = 'ADM';
SELECT cdId, cdNm FROM (
        SELECT A.*, ROWNUM FROM(
                SELECT
                ROLE_tp_cd as cdId,
                ROLE_NM as cdNm
                FROM ROLE
                WHERE DOMAIN_TP_CD = 'ADMIN' AND role_tp_cd IN ('SUA', 'ADM')
                UNION ALL
                SELECT
                RLC_CD as cdId,
                RLC_NM as cdNm
                FROM RLC
                WHERE substr(rlc_cd, -4) != 'OBIZ'
                UNION ALL
                SELECT
                DLC_CD as cdId,
                DLC_NM as cdNm
                FROM DLC
                WHERE substr(dlc_cd, -4) != 'OBIZ'
                UNION ALL
                SELECT
                ROLE_tp_cd as cdId,
                ROLE_NM as cdNm
                FROM ROLE
                WHERE DOMAIN_TP_CD = 'ADMIN' AND role_tp_cd IN ('OPR', 'DEV')
        ) A
);

SELECT cdId, cdNm FROM (
        SELECT A.*, ROWNUM FROM(
                SELECT
                ROLE_tp_cd as cdId,
                ROLE_NM as cdNm
                FROM ROLE
                WHERE DOMAIN_TP_CD = 'ADMIN' AND role_tp_cd IN ('SUA', 'ADM')
                UNION ALL
                SELECT
                BLC_CD as cdId,
                BLC_NM as cdNm
                FROM BLC
                WHERE substr(blc_cd, -4) != 'OBIZ'
                UNION ALL
                SELECT
                RLC_CD as cdId,
                RLC_NM as cdNm
                FROM RLC
                WHERE substr(rlc_cd, -4) != 'OBIZ'
                UNION ALL
                SELECT
                DLC_CD as cdId,
                DLC_NM as cdNm
                FROM DLC
                WHERE substr(dlc_cd, -4) != 'OBIZ'
                UNION ALL
                SELECT
                ROLE_tp_cd as cdId,
                ROLE_NM as cdNm
                FROM ROLE
                WHERE DOMAIN_TP_CD = 'ADMIN' AND role_tp_cd IN ('OPR', 'DEV')
        ) A
);



SELECT /* [user/customerManage.sqlmap.xml].[selectCustomerManagePageList] by hwKim */
*
FROM (
    SELECT ROWNUM AS RNUM
    , A.*
    FROM (
        SELECT su.user_id
        , su.user_nm
        , cu.join_state_cd
        , cu.system_intf_state_cd
        , cu.use_yn
        , cu.join_state_upd_dttm
        , cu.blc_id
        , cu.rlc_id
        , cu.mgmtc_tp
        , (SELECT dlc_disp_nm
        from dlc d WHERE d.dlc_id=cu.dlc_id) AS dlc_nm
        FROM system_user su, custom cu
        WHERE su.user_id = cu.user_id
        AND     cu.join_state_cd  <>  'LEAVE_SUCC'
        ORDER BY cu.join_state_upd_dttm DESC
    ) A WHERE ROWNUM <= 10
) WHERE RNUM > 0;

select cu.* from system_user su INNER JOIN custom cu ON cu.user_id = su.user_id
where su.user_nm = 'test_vasteam'; -- 2832
update custom set mgmtc_tp = 'RLC' where user_id = 2832;commit
select * from blc;
select * from rlc;

select * from custom;
select * from admin where login_email = 'dblcadmin01'
select * from blc where blc_id = 10;
select * from rlc;
select * from rlc where blc_id = 10;
select * from blc where blc_id = 10;
select * from dlc;
select substr('DLC_OBIZ01', -4) from dual;

select * from (
select 'DLC_OBI01' as code from dual
UNION ALL
select 'DLC_OBI02' as code from dual
UNION ALL
select 'DLC_OBIZ01' as code from dual
UNION ALL
select 'DLC_OBIZ02' as code from dual)
where code like '%OBIZ%';

-- ## 롤에 따른 메뉴정보 조회
-- Super Admin이 가진 자원 조회
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
AND rsrc.use_yn = 'Y'
order by NVL(rsrc.up_rsrc_id, 0), prt_ord;

SELECT
    cd_id
    , cd_grp_id
    , cd_nm
    , cd_desc
    , prt_ord
    , use_yn
    , ref_cd
    , crt_dttm
    , crt_user_id
    , crt_prgm_id
    , upd_dttm
    , upd_user_id
    , upd_prgm_id
FROM com_cd
WHERE  cd_grp_id = 'ADMIN_STATE_CD'
and use_yn = 'Y'
ORDER BY prt_ord;

-- ## 중계사 목록(콤보박스사용)
SELECT
    cd_id
    , blc_id
    , cd_grp_id
    , cd_nm
    , cd_desc
    , prt_ord
    , use_yn
    , ref_cd
    , crt_dttm
    , crt_user_id
    , crt_prgm_id
    , upd_dttm
    , upd_user_id
    , upd_prgm_id
FROM com_cd
WHERE  cd_grp_id = 'RLC_TP_CD'
and use_yn = 'Y'
ORDER BY prt_ord;

select * from com_cd;
select * from blc;
select * from rlc;
select * from rlc where blc_id = 100;

select * from com_cd where cd_grp_id = 'RLC_TP_CD' and use_yn = 'Y';
INSERT INTO COM_CD (CD_ID, CD_GRP_ID, CD_NM, CD_DESC, PRT_ORD, USE_YN, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, REF_CD, BLC_ID)
SELECT RLC_ID, 'RLC_TP_CD', RLC_NM, RLC_NM, 1, 'Y', SYSDATE, 'INIT', 'INIT', SYSDATE, 'INIT', 'INIT', 'RLC', BLC_ID FROM RLC WHERE BLC_ID =100;
UPDATE COM_CD SET PRT_ORD = 2 WHERE CD_ID = '201';
COMMIT;



SELECT
role.role_id
, role.role_tp_cd
, role.role_nm
, role.role_descr
, role.use_yn
, role.crt_dttm
, role.crt_user_id
, role.crt_prgm_id
, role.upd_dttm
, role.upd_user_id
, role.upd_prgm_id
, rsrc.rsrc_id       AS      rsrc__rsrc_id
, rsrc.up_rsrc_id    AS  rsrc__up_rsrc_id
, rsrc.domain_tp_cd  AS  rsrc__domain_tp_cd
, rsrc.rsrc_nm       AS  rsrc__rsrc_nm
, rsrc.rsrc_descr    AS rsrc__rsrc_desc
, rsrc.rsrc_url      AS  rsrc__rsrc_url
, rsrc.rsrc_tp_cd    AS  rsrc__rsrc_tp_cd
, rsrc.prt_ord       AS  rsrc__prt_ord
, rsrc.prt_lvl       AS  rsrc__prt_lvl
, rsrc.prgm_id       AS  rsrc__prgm_id
, rsrc.use_yn        AS  rsrc__use_yn
, rsrc.crt_dttm      AS  rsrc__crt_dttm
, rsrc.crt_user_id   AS  rsrc__crt_user_id
, rsrc.crt_prgm_id   AS  rsrc__crt_prgm_id
, rsrc.upd_dttm      AS  rsrc__upd_dttm
, rsrc.upd_user_id   AS  rsrc__upd_user_id
, rsrc.upd_prgm_id   AS  rsrc__upd_prgm_id
FROM role role
INNER JOIN role_rsrc_mapp mapp ON role.role_id = mapp.role_id
INNER JOIN rsrc rsrc ON mapp.rsrc_id = rsrc.rsrc_id
WHERE   1=1
AND rsrc.use_yn = 'Y'
AND rsrc.rsrc_url   = '/dashboard';

-- SKT ADMIN 고객조회
SELECT /* [user/userInfo.sqlmap.xml].[selectCustomUserList] by hwkim */
    a.user_id
    , a.user_nm
FROM system_user a
WHERE EXISTS (
    SELECT '1'
    FROM custom b
    WHERE b.user_id = a.user_id
    AND b.join_state_cd in ('JOIN_SUCC', 'LEAVE_RES')
)
ORDER BY a.user_nm ASC;

-- 중계사 Admin 고객조회
SELECT /* [user/userInfo.sqlmap.xml].[selectCustomUserList] by hwkim */
    a.user_id
    , a.user_nm
FROM system_user a
WHERE EXISTS (
    SELECT '1'
    FROM custom b
    WHERE b.user_id = a.user_id
    AND b.rlc_id= 64
    AND mgmtc_tp = 'RLC'
    AND  b.join_state_cd in ('JOIN_SUCC', 'LEAVE_RES')
)
ORDER BY a.user_nm ASC;

>SELECT
                y.SND_RCV_TP || '_' || y.SVC_CL ||  '_' || y.MSG_TP AS mapKey
                ,y.SVC_CL AS svcCl
                ,y.SVC_CL_NM AS svcClNm
                ,y.SND_RCV_TP AS sndRcvTp
                ,y.SND_RCV_TP_NM AS sndRcvTpNm
                ,y.MSG_TP AS msgTp
                ,y.MSG_TP_NM AS msgTpNm
                ,NVL(x.SUCC_CNT, 0) AS succCnt
                ,NVL(x.FAIL_CNT, 0) AS failCnt
                FROM (
                SELECT
                s.SVC_CL
                ,s.SND_RCV_TP
                ,s.MSG_TP
                ,SUM(s.SUCC_CNT) AS SUCC_CNT
                ,SUM(s.FAIL_CNT) AS FAIL_CNT
                FROM STAT_DAYS s, CUSTOM c
                WHERE (s.STAT_DT >= TRUNC(SYSDATE)-1 AND s.STAT_DT < TRUNC(SYSDATE))
                AND s.USER_ID = c.USER_ID
                        AND c.RLC_ID = 64
                        AND c.MGMTC_TP = 'RLC'
                GROUP BY s.SVC_CL, s.SND_RCV_TP, s.MSG_TP
                ) x,
                (
                SELECT
                a.SVC_CL, a.SVC_CL_NM, b.SND_RCV_TP, b.SND_RCV_TP_NM, c.MSG_TP, c.MSG_TP_NM
                FROM
                (
                SELECT CD_ID AS SVC_CL, CD_NM AS SVC_CL_NM FROM COM_CD WHERE CD_GRP_ID = 'SVC_CL_CD' AND USE_YN = 'Y'
                ) a,
                (
                SELECT CD_ID AS SND_RCV_TP, CD_NM AS SND_RCV_TP_NM FROM COM_CD WHERE CD_GRP_ID = 'SND_RCV_TP_CD' AND USE_YN = 'Y'
                ) b,
                (
                SELECT CD_ID AS MSG_TP, CD_NM AS MSG_TP_NM FROM COM_CD WHERE CD_GRP_ID = 'MSG_TP_CD' AND USE_YN = 'Y'
                ) c

                ) y
                WHERE y.SVC_CL = x.SVC_CL(+)
                AND y.SND_RCV_TP = x.SND_RCV_TP(+)
                AND y.MSG_TP = x.MSG_TP(+)

-- # 중계사가 가진 고객(딜러사)
select * from custom where mgmtc_tp = 'RLC';
select * from admin where mgmtc_tp = 'RLC';
select * from custom where rlc_id = 63 and mgmtc_tp = 'DLC'
-- ## 딜러사가 가진 고객
select * from custom where dlc_id = 81;
select * from custom;

SELECT
            cd_id
            , cd_grp_id
            , cd_nm
            , cd_desc
            , prt_ord
            , use_yn
            , ref_cd
            , crt_dttm
            , crt_user_id
            , crt_prgm_id
            , upd_dttm
            , upd_user_id
            , upd_prgm_id
    FROM com_cd
     WHERE  cd_grp_id = 'RLC_TP_CD'
            and use_yn = 'Y'
ORDER BY prt_ord


SELECT /* [user/userInfo.sqlmap.xml].[selectCustomUserList] by hwkim */
                           a.user_id
                         , a.user_nm
                  FROM system_user a
                 WHERE EXISTS (
                                                SELECT '1'
                                                  FROM custom b
                                                 WHERE b.user_id = a.user_id
                                                         AND b.rlc_id= 64
                                                         AND mgmtc_tp = 'RLC'
                                                AND  b.join_state_cd in ('JOIN_SUCC', 'LEAVE_RES')
                                          )
                ORDER BY a.user_nm ASC

select * from custom where rlc_id = 61;
select * from admin;
select * from system_user;


SELECT
                        cd_id
                        , cd_grp_id
                        , cd_nm
                        , cd_desc
                        , prt_ord
                        , use_yn
                        , ref_cd
                        , crt_dttm
                        , crt_user_id
                        , crt_prgm_id
                        , upd_dttm
                        , upd_user_id
                        , upd_prgm_id
                FROM com_cd
                 WHERE  cd_grp_id = 'RLC_TP_CD'
                        and use_yn = 'Y'
            ORDER BY prt_ord;


SELECT * FROM ( /* [operatesvc/downloadMgmt.sqlmap.xml].[selectDownloadMgmtPageList] by hwkim */
SELECT ROWNUM AS RNUM
    , A.*
FROM (
    SELECT
        a.dl_id
        , a.title
        , a.att_file_nm
        , a.att_file_path
        , b.login_email
        , a.crt_dttm
        , a.public_yn
        , a.dl_cnt
    FROM dl_mgmt a, admin b
    WHERE a.del_yn = 'N'
    AND a.crt_user_id = b.user_id(+)
    AND del_yn = 'N'
    ORDER BY crt_dttm DESC
    ) A WHERE ROWNUM <= 10
) WHERE RNUM > 0;


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

select * from role;




SELECT DISTINCT
                        rsrc.rsrc_id
                        ,       rsrc.up_rsrc_id
                        ,       NVL(rsrc.up_rsrc_id, 0) AS      up_rsrc_id
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
                INNER JOIN      role_rsrc_mapp  rmapp   ON      rmapp.rsrc_id = rsrc.rsrc_id
        INNER JOIN  role role ON role.role_id = rmapp.role_id
        LEFT OUTER JOIN user_role_mapp  umapp   ON      umapp.role_id = role.role_id
        INNER JOIN system_user suser ON suser.user_id = umapp.user_id
                WHERE 1 = 1
                AND suser.user_id = 2133
                AND     rsrc.use_yn             = 'Y'
                order by NVL(rsrc.up_rsrc_id, 0), prt_ord;

-- ## WEB 로그인시 접근 가능 리소스(URL) 유저아이디: skp_cust
select * from system_user where user_id = 2133;
select * from user_role_mapp where user_id = 2133;
select * from role where role_id = 101;

-- # 롤별 리소스 정보
-- ## 계정 롤이 가진 리소스정보(SuperAdmin)
select b.* from role_rsrc_mapp a inner join rsrc b on a.rsrc_id = b.rsrc_id where role_id = 51 and b.use_yn = 'Y' order by b.rsrc_id;
select * from rsrc order by rsrc_id desc;

select * from role_rsrc_mapp;



SELECT    role.role_id
,       role.role_tp_cd
,       role.role_nm
,       role.role_descr
,       role.use_yn
,       role.crt_dttm
,       role.crt_user_id
,       role.crt_prgm_id
,       role.upd_dttm
,       role.upd_user_id
,       role.upd_prgm_id

,       rsrc.rsrc_id            AS      rsrc__rsrc_id
,       rsrc.up_rsrc_id     AS  rsrc__up_rsrc_id
,       rsrc.domain_tp_cd   AS  rsrc__domain_tp_cd
,       rsrc.rsrc_nm        AS  rsrc__rsrc_nm
,   rsrc.rsrc_descr      AS rsrc__rsrc_desc
,       rsrc.rsrc_url       AS  rsrc__rsrc_url
,       rsrc.rsrc_tp_cd     AS  rsrc__rsrc_tp_cd
,       rsrc.prt_ord        AS  rsrc__prt_ord
,       rsrc.prt_lvl        AS  rsrc__prt_lvl
,       rsrc.prgm_id        AS  rsrc__prgm_id
,       rsrc.use_yn         AS  rsrc__use_yn
,       rsrc.crt_dttm       AS  rsrc__crt_dttm
,       rsrc.crt_user_id    AS  rsrc__crt_user_id
,       rsrc.crt_prgm_id    AS  rsrc__crt_prgm_id
,       rsrc.upd_dttm       AS  rsrc__upd_dttm
,       rsrc.upd_user_id    AS  rsrc__upd_user_id
,       rsrc.upd_prgm_id    AS  rsrc__upd_prgm_id

FROM                    role                    role
INNER JOIN      role_rsrc_mapp  mapp    ON      role.role_id = mapp.role_id
INNER JOIN      rsrc                    rsrc    ON      mapp.rsrc_id = rsrc.rsrc_id
WHERE   1=1
AND             rsrc.use_yn             = 'Y'
AND             rsrc.rsrc_url   = '/main';


