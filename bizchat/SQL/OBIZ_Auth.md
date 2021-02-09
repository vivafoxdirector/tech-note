-- # OBIZ Web

-- ## OBIZ로그인
SELECT
    u.user_id
    , u.user_tp_cd
    , u.user_nm
    , u.user_tp_cd
    , u.user_descr
    , c.custom_id
    , c.login_id
    , c.pw
    , c.contact_nm
    , c.contact_tp
    , c.depart
    , c.rank
    , c.email
    , c.cell_phone1
    , c.cell_phone2
    , c.cell_phone3
    , c.tele_phone1
    , c.tele_phone2
    , c.tele_phone3
    , c.fax1
    , c.fax2
    , c.fax3
    , c.addr
    , c.sms_agre_yn
    , c.email_agre_yn
    , c.join_state_cd
    , c.state_cd
    , c.login_fail_cnt
    , c.pw_upd_yn
    , c.pw_upd_dttm
    , c.login_dttm
    , c.user_join_dttm
    , c.appr_dttm
    , c.crt_dttm
    , c.crt_user_id
    , c.crt_prgm_id
    , c.upd_dttm
    , c.upd_user_id
    , c.upd_prgm_id
    ,'' as join_state_nm
    ,'' as state_nm
    , (SELECT user_nm FROM system_user x WHERE x.user_id = c.custom_id) custom_nm
    , (SELECT rlc_id FROM CUSTOM cu WHERE cu.user_id=c.custom_id) as rlc_id
    , role.role_id          AS role__role_id
    , role.role_tp_cd       AS role__role_tp_cd
    , role.role_nm          AS role__role_nm
    , role.role_descr       AS role__role_desc
    , role.use_yn           AS role__use_yn
FROM system_user u
INNER JOIN custom_contact c ON u.user_id = c.user_id
LEFT OUTER JOIN user_role_mapp mapp ON c.user_id = mapp.user_id
LEFT OUTER JOIN role role ON mapp.role_id = role.role_id
WHERE u.user_tp_cd = 'CUST'
AND     c.login_id = 'test_vasteam';
select * from custom_contact  where user_id = 2929;
select * from custom where user_id = 2928;

select * from role;
select * from role_rsrc_mapp mapp inner join role role on role.role_id = mapp.role_id
where role.role_id =51;

select * from custom where blc_id != 10;
select * from rlc;
update custom set blc_id = 1 where blc_id != 10;
commit;

SELECT /* [user/userInfo.sqlmap.xml].[selectCustomUserList] by hwkim */
                           a.user_id
                         , a.user_nm
                  FROM system_user a
                 WHERE EXISTS (
                                                SELECT '1'
                                                  FROM custom b
                                                 WHERE b.user_id = a.user_id
                                                        AND b.rlc_id= 100
                                                AND  b.join_state_cd in ('JOIN_SUCC', 'LEAVE_RES')
                                          )
                ORDER BY a.user_nm ASC;

select * from role;
select * from rlc;
commit;

SELECT * FROM (
                        SELECT ROWNUM AS RNUM, A.* FROM (
                                SELECT
                                        u.user_id
                                        , u.user_tp_cd
                                        , u.user_nm
                                        , u.user_descr
                                        , a.login_email
                                        , a.cell_phone
                                        , a.email
                                        , a.login_dttm
                                        , a.use_yn
                                        , a.state_cd
                                        , a.crt_user_ip
                                        , role.role_id                  AS role__role_id
                                        , role.role_tp_cd       AS role__role_tp_cd
                                        , role.role_nm          AS role__role_nm
                                        , role.role_descr               AS role__role_desc
                                        , a.blc_id
                    , a.rlc_id
                                        , a.dlc_id
                                        , blc.blc_nm
                                        , rlc.rlc_nm
                                        , dlc.dlc_nm
                                        , a.mgmtc_tp

                FROM system_user u
                INNER JOIN admin a
                ON      u.user_id = a.user_id
                LEFT OUTER JOIN user_role_mapp  mapp
                ON      a.user_id = mapp.user_id
                LEFT OUTER JOIN role role
                ON      mapp.role_id = role.role_id
                LEFT OUTER JOIN blc
                ON blc.blc_id = a.blc_id
                LEFT OUTER JOIN rlc
                ON rlc.rlc_id = a.rlc_id
                LEFT OUTER JOIN dlc
                ON dlc.dlc_id = a.dlc_id
                 WHERE  blc.blc_id = 10

                                ORDER BY a.crt_dttm DESC
                        ) A WHERE ROWNUM <= 10
                ) WHERE RNUM > 0;

select * from role;

-- # 고객/관리자 사용자 정보 조회 (CUST, ADMIN, API)
select
    cu.user_id
    , c.custom_id
    , u.user_tp_cd
    , cu.blc_id
    , cu.rlc_id
    , cu.dlc_id
    , cu.mgmtc_tp
from system_user u
inner join custom_contact c on u.user_id = c.user_id
inner join custom cu on c.custom_id = cu.user_id
where 1=1
AND c.login_id = 'dev_obiztest'
-- AND u.user_tp_cd = 'CUST';

select * from custom where user_id = 2832;

select * from system_user where user_id = 2753;
select su.user_tp_cd, cu.* from system_user su inner join custom_contact co on su.user_id = co.user_id
inner join custom cu on cu.user_id = co.custom_id;

select
    *
from system_user su
inner join custom cu on cu.user_id = su.user_id
where su.user_id = 2832;


SELECT /* [user/userInfo.sqlmap.xml].[selectCustomUserList] by hwkim */
                           a.user_id
                         , a.user_nm
                  FROM system_user a
                 WHERE EXISTS (
                                                SELECT '1'
                                                  FROM custom b
                                                 WHERE b.user_id = a.user_id
                                                         AND b.blc_id= 10
                                                         AND mgmtc_tp = 'BLC'
                                                AND  b.join_state_cd in ('JOIN_SUCC', 'LEAVE_RES')
                                          )
                ORDER BY a.user_nm ASC;

select * from blc;
select * from custom where user_id = 2832;
-- # OBIZ 시스템 신규 유저
select * from system_user where user_id = 2833;
select * from custom_contact where user_id = 2833;
select * from user_role_mapp where user_id = 2833;
select * from role where role_id = 101;
select
update user_role_mapp set role_id = 200 where user_id = 2833;

select * from custom where user_id = 2832;
select * from custom where corp_req_num = '222222-2222222';

select * from COM_CD where CD_GRP_ID = 'SVC_CL_CD';
select * from charge;
select * from charge_svc;

select * from rlc;
select * from custom;
-- # 사업자 정보 조회
SELECT
    d.BLC_CD
FROM SYSTEM_USER a
INNER JOIN CUSTOM_CONTACT b ON a.USER_ID = b.USER_ID
INNER JOIN CUSTOM c ON b.CUSTOM_ID = c.USER_ID
INNER JOIN BLC d ON d.BLC_ID = c.BLC_ID
where a.USER_ID = 2833;

-- ## Web OBIZ유저 롤 리소스
SELECT DISTINCT
rsrc.rsrc_id
, role.role_id
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
AND suser.user_id = 2833
AND     rsrc.use_yn             = 'Y'
order by NVL(rsrc.up_rsrc_id, 0), prt_ord;

-- # 고객사 관리자 롤 조회
select
rmapp.*
from role_rsrc_mapp  rmapp
INNER JOIN  role role ON role.role_id = rmapp.role_id
WHERE role.role_id = 101;

-- 1. OBIZ WEB 용 role 추가
select * from role order by role_id;
insert into role (role_id, role_tp_cd, prt_ord, role_nm, role_descr, use_yn, crt_dttm, crt_user_id, crt_prgm_id, upd_dttm, upd_user_id, upd_prgm_id, domain_tp_cd)
select 200, 'OBIZ_CUAD', prt_ord, '오비즈고객사 관리자', '오비즈고객사 관리자', use_yn, crt_dttm, crt_user_id, crt_prgm_id, upd_dttm, upd_user_id, upd_prgm_id, domain_tp_cd from role where role_id = 101;
commit;
update user_role_mapp set role_id = 200 where user_id = 2833;

-- 3.
select
    mapp.*
from rsrc rsrc INNER JOIN role_rsrc_mapp mapp on rsrc.rsrc_id = mapp.rsrc_id
where 1=1
and rsrc.use_yn = 'Y'
and mapp.role_id = 102;
select * from roe_rsrc_mapp where role_id = 102;
select * from rsrc order by rsrc_id;

-- 2. role_rsrc_mapp 추가
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 500, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 501, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 502, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 503, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 504, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 505, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 506, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 507, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 508, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 509, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 510, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 511, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 512, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 513, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 514, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 515, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 516, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 517, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 518, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 519, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 520, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 521, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 522, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 523, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 524, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 525, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 526, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 527, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 528, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 529, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 536, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 537, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 538, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 539, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 540, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 541, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 542, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 543, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 544, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 545, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 546, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 547, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 548, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 549, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 550, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 551, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 552, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 553, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 554, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 555, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 556, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 557, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 558, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 559, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 560, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 561, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 562, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 563, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 564, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 565, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 566, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 567, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 568, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 569, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 570, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 571, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 572, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 573, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 574, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 575, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 576, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 577, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 578, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 579, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 580, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 581, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 582, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 583, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 584, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 585, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 586, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 587, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 588, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 589, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 590, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 591, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 592, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 593, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 594, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 595, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 596, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 597, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 598, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 599, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 600, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 601, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 602, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 603, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 604, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 605, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 606, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 607, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 608, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 609, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 610, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 611, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 612, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 613, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 614, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 615, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 616, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 617, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 618, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 619, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 620, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 621, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 622, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 623, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 624, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 625, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 626, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 627, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 628, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 629, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 630, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 631, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 632, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 633, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 634, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 635, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 636, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 637, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 638, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 639, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 640, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 641, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 642, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 643, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 644, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 645, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 646, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 647, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 648, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 649, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 650, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 651, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 652, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 653, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 654, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 655, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 656, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 657, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 658, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 659, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 660, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 661, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 662, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 663, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 664, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 665, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 666, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 2002, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 2003, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 2004, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 2005, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 2006, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 2007, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 2008, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 2009, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 2014, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 2015, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 2016, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 2017, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 2101, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 2102, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 2103, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 2104, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 2105, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 2106, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 2107, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 2108, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 2112, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 2113, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 2118, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 2119, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 2121, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 2122, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 2123, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 2124, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 2125, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 2126, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 2128, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 2129, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
commit;
select * from role_rsrc_mapp where role_id = 200;

INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(202, 500, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(202, 501, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(202, 505, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(202, 508, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(202, 509, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(202, 517, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(202, 518, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(202, 519, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(202, 557, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(202, 558, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(202, 559, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(202, 560, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(202, 561, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(202, 564, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(202, 607, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(202, 608, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(202, 633, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(202, 2649, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
commit;
select * from role_rsrc_mapp where role_id = 202;
-- 592, 593
select * from rsrc where rsrc_id = 592;



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
AND mapp.role_id = 202
AND     rsrc.use_yn             = 'Y'
order by NVL(rsrc.up_rsrc_id, 0), prt_ord;

delete from role_rsrc_mapp where role_id = 200 and rsrc_id in (508,509,511,512,536,537,538,541,542,543,544,545,546,547,548,549,550,551,552,553,554,610,611,612,613,614,615,616,617,618,620,621,622,623,624,625,626,627,628,629,630,631,632,641)
commit;
delete from role_rsrc_mapp where role_id = 202 and rsrc_id in (509, 508);
commit;

INSERT INTO RSRC (RSRC_ID, UP_RSRC_ID, RSRC_NM, RSRC_DESCR, RSRC_URL, RSRC_TP_CD, DOMAIN_TP_CD, PRT_ORD, PRT_LVL, USE_YN, PRGM_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID) VALUES(2649, 501, '마케팅오비즈', '상품소개 > 설문비즈챗', '/main#bizChatGuideSv', 'M', 'CUSTOMER',4,2,'Y', NULL,SYSDATE, 'INIT', 'INIT', SYSDATE, 'INIT', 'INIT');
INSERT INTO RSRC (RSRC_ID, UP_RSRC_ID, RSRC_NM, RSRC_DESCR, RSRC_URL, RSRC_TP_CD, DOMAIN_TP_CD, PRT_ORD, PRT_LVL, USE_YN, PRGM_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID) VALUES(2651, 502, '마케팅오비즈', '리포트 > 설문비즈챗', '/statistics/main/sv', 'M', 'CUSTOMER',4,2,'Y', NULL,SYSDATE, 'INIT', 'INIT', SYSDATE, 'INIT', 'INIT');
INSERT INTO RSRC (RSRC_ID, UP_RSRC_ID, RSRC_NM, RSRC_DESCR, RSRC_URL, RSRC_TP_CD, DOMAIN_TP_CD, PRT_ORD, PRT_LVL, USE_YN, PRGM_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID) VALUES(2652, 2651, '설문통계(상세 리포트)', '리포트 > 설문비즈챗 > 설문통계(상세 리포트)', '/statistics/detail/report/sv', 'P', 'CUSTOMER',1,3,'Y', NULL,SYSDATE, 'INIT', 'INIT', SYSDATE, 'INIT', 'INIT');
INSERT INTO RSRC (RSRC_ID, UP_RSRC_ID, RSRC_NM, RSRC_DESCR, RSRC_URL, RSRC_TP_CD, DOMAIN_TP_CD, PRT_ORD, PRT_LVL, USE_YN, PRGM_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID) VALUES(2653, 2651, '설문통계(상세 리포트) 엑셀 다운로드', '리포트 > 설문비즈챗 > 설문통계(상세 리포트) > 엑셀 다운로드', '/statistics/detail/excel/sv', 'F', 'CUSTOMER',2,3,'Y', NULL,SYSDATE, 'INIT', 'INIT', SYSDATE, 'INIT', 'INIT');
INSERT INTO RSRC (RSRC_ID, UP_RSRC_ID, RSRC_NM, RSRC_DESCR, RSRC_URL, RSRC_TP_CD, DOMAIN_TP_CD, PRT_ORD, PRT_LVL, USE_YN, PRGM_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID) VALUES(2654, 2651, '설문통계(설문 이력 조회)', '리포트 > 설문비즈챗 > 설문통계(설문 이력 조회)', '/statistics/detail/hist/sv', 'P', 'CUSTOMER',3,3,'Y', NULL,SYSDATE, 'INIT', 'INIT', SYSDATE, 'INIT', 'INIT');
INSERT INTO RSRC (RSRC_ID, UP_RSRC_ID, RSRC_NM, RSRC_DESCR, RSRC_URL, RSRC_TP_CD, DOMAIN_TP_CD, PRT_ORD, PRT_LVL, USE_YN, PRGM_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID) VALUES(2655, 2651, '설문통계(설문 이력 조회) 엑셀 다운로드', '리포트 > 설문비즈챗 > 설문통계(설문 이력 조회) > 엑셀 다운로드', '/statistics/detail/hist/excel/sv', 'F', 'CUSTOMER',4,3,'Y', NULL,SYSDATE, 'INIT', 'INIT', SYSDATE, 'INIT', 'INIT');
INSERT INTO RSRC (RSRC_ID, UP_RSRC_ID, RSRC_NM, RSRC_DESCR, RSRC_URL, RSRC_TP_CD, DOMAIN_TP_CD, PRT_ORD, PRT_LVL, USE_YN, PRGM_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID) VALUES(2658, 2651, '발신문자 실패 내역 통계', '리포트 > 설문비즈챗 > 실패 내역 통계', '/statistics/fail/sv/mt', 'P', 'CUSTOMER',7,3,'Y', NULL,SYSDATE, 'INIT', 'INIT', SYSDATE, 'INIT', 'INIT');
INSERT INTO RSRC (RSRC_ID, UP_RSRC_ID, RSRC_NM, RSRC_DESCR, RSRC_URL, RSRC_TP_CD, DOMAIN_TP_CD, PRT_ORD, PRT_LVL, USE_YN, PRGM_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID) VALUES(2659, 2651, '수신문자 실패 내역 통계', '리포트 > 설문비즈챗 > 실패 내역 통계', '/statistics/fail/sv/mo', 'P', 'CUSTOMER',8,3,'Y', NULL,SYSDATE, 'INIT', 'INIT', SYSDATE, 'INIT', 'INIT');
INSERT INTO RSRC (RSRC_ID, UP_RSRC_ID, RSRC_NM, RSRC_DESCR, RSRC_URL, RSRC_TP_CD, DOMAIN_TP_CD, PRT_ORD, PRT_LVL, USE_YN, PRGM_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID) VALUES(2660, 2651, '실패 내역 엑셀다운로드', '리포트 > 설문비즈챗 > 실패 내역 엑셀다운로드', '/statistics/fail/excel/sv/mt', 'F', 'CUSTOMER',9,3,'Y', NULL,SYSDATE, 'INIT', 'INIT', SYSDATE, 'INIT', 'INIT');
INSERT INTO RSRC (RSRC_ID, UP_RSRC_ID, RSRC_NM, RSRC_DESCR, RSRC_URL, RSRC_TP_CD, DOMAIN_TP_CD, PRT_ORD, PRT_LVL, USE_YN, PRGM_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID) VALUES(2661, 2651, '실패 내역 엑셀다운로드', '리포트 > 설문비즈챗 > 실패 내역 엑셀다운로드', '/statistics/fail/excel/sv/mo', 'F', 'CUSTOMER',10,3,'Y', NULL,SYSDATE, 'INIT', 'INIT', SYSDATE, 'INIT', 'INIT');
INSERT INTO RSRC (RSRC_ID, UP_RSRC_ID, RSRC_NM, RSRC_DESCR, RSRC_URL, RSRC_TP_CD, DOMAIN_TP_CD, PRT_ORD, PRT_LVL, USE_YN, PRGM_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID) VALUES(2662, 2651, '설문 리스트 불러오기', '리포트 > 설문비즈챗 > 설문리스트 불러오기', '/statistics/sv/survey/list', 'F', 'CUSTOMER',5,3,'Y', NULL,SYSDATE, 'INIT', 'INIT', SYSDATE, 'INIT', 'INIT');
INSERT INTO RSRC (RSRC_ID, UP_RSRC_ID, RSRC_NM, RSRC_DESCR, RSRC_URL, RSRC_TP_CD, DOMAIN_TP_CD, PRT_ORD, PRT_LVL, USE_YN, PRGM_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID) VALUES(2591, 506, '발신번호 관리', '마이페이지 > 발신번호 관리', '/myPage/callerIdManage', 'P', 'CUSTOMER',5,2,'Y', NULL,SYSDATE, 'INIT', 'INIT', SYSDATE, 'INIT', 'INIT');

INSERT INTO RSRC (RSRC_ID, UP_RSRC_ID, RSRC_NM, RSRC_DESCR, RSRC_URL, RSRC_TP_CD, DOMAIN_TP_CD, PRT_ORD, PRT_LVL, USE_YN, PRGM_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID) VALUES(2524, 506, '나의 1:1 문의', '마이페이지 > 나의 1:1 문의', '/myPage/qnaList', 'M', 'CUSTOMER',5,2,'Y', NULL,SYSDATE, 'INIT', 'INIT', SYSDATE, 'INIT', 'INIT');

select * from rsrc order by rsrc_id desc;
select * from rsrc where up_rsrc_id = 506;
commit;
update rsrc set prt_ord = 5 where rsrc_id = 2524;
update rsrc set rsrc_tp_cd = 'M' where rsrc_id = 2591;
commit;

INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 2649, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 2651, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 2652, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 2653, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 2654, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 2655, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 2658, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 2659, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 2660, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 2661, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 2662, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 2591, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(200, 2524, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
commit;


select * from role;
select * from rsrc where rsrc_descr like '%특번%' and domain_tp_cd = 'CUSTOMER' and rsrc_id = 591;

-- # 발신번호 신청
select skt_register_state from custom_spc_num;
select * from custom_spc_num_svc;

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
		WHERE cd_grp_id = 'SVC_CL_CD'
		AND use_yn = 'Y'
	    ORDER BY prt_ord;

select * from custom_spc_num_svc;



SELECT /* [purchase/customSpcNum.sqlmap.xml].[getCustomSpcNumTotalCount] by hwkim */
COUNT(*)
FROM (
SELECT m.custom_spc_num_id
, m.user_id
, m.spc_num_num
, LISTAGG(m.cd_nm, ', ') WITHIN GROUP (ORDER BY m.svc_cl) svc_cl_nm
, LISTAGG(m.svc_cl, ', ') WITHIN GROUP (ORDER BY m.svc_cl) svc_cl
, m.state_cd
, m.crt_dttm
, (SELECT user_nm FROM system_user d WHERE d.user_id = m.user_id) user_nm
, m.crt_user_id
, (SELECT rlc_id FROM custom c WHERE c.user_id=m.user_id) rlc_id
, (SELECT user_nm FROM system_user e WHERE e.user_id = m.crt_user_id) crt_user_nm
, (SELECT user_nm FROM system_user f WHERE f.user_id = m.appr_user_id) appr_user_nm
, reject_reason
, del_appr_yn
FROM (
SELECT a.custom_spc_num_id
, a.user_id
, a.spc_num_num
, a.state_cd
, DECODE(a.state_cd, 'RUN', a.appr_proc_dttm , a.appr_req_dttm) crt_dttm
, b.svc_cl
, (SELECT cd_nm FROM com_cd WHERE cd_grp_id = 'SVC_CL_CD' AND cd_id = b.svc_cl) cd_nm
, a.crt_user_id
, a.appr_user_id
, a.reject_reason
, a.del_appr_yn
FROM custom_spc_num a
, custom_spc_num_svc b
, custom c
WHERE a.custom_spc_num_id = b.custom_spc_num_id
AND a.state_cd  <>  'DEL'
AND a.state_cd = 'RUN'
AND a.user_id = 2832
AND a.USER_ID = c.USER_ID
) m
GROUP BY custom_spc_num_id, user_id, spc_num_num, state_cd, crt_dttm, crt_user_id, appr_user_id, reject_reason, del_appr_yn
) A
WHERE 1=1;
--AND A.svc_cl LIKE '%' || 'SV' || '%';


SELECT /* [user/userInfo.sqlmap.xml].[selectCustomUserList] by hwkim */
                           a.user_id
                         , a.user_nm
                  FROM system_user a
                 WHERE EXISTS (
                                                SELECT '1'
                                                  FROM custom b
                                                 WHERE b.user_id = a.user_id




                                                        AND b.blc_id= 10





                                                AND  b.join_state_cd in ('JOIN_SUCC', 'LEAVE_RES')
                                          )
                ORDER BY a.user_nm ASC



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
                                and blc_id = 10
            ORDER BY prt_ord;



>SELECT /* [purchase/customSpcNum.sqlmap.xml].[selectCustomSpcNumPageList] by hwkim */
                           *
                  FROM (
                                SELECT ROWNUM AS RNUM
                                         , A.*
                                  FROM (
                                                SELECT m.custom_spc_num_id
                                                         , m.user_id
                                                         , m.spc_num_num
                                                         , LISTAGG(m.cd_nm, ', ') WITHIN GROUP (ORDER BY m.svc_cl) svc_cl_nm
                                                         , LISTAGG(m.svc_cl, ', ') WITHIN GROUP (ORDER BY m.svc_cl) svc_cl
                                                         , m.state_cd
                                                         , m.appr_req_dttm
                                                         , m.appr_proc_dttm
                                                         , m.crt_dttm
                                                         , (SELECT user_nm FROM system_user d WHERE d.user_id = m.user_id) user_nm
                                                         , m.crt_user_id
                                                         , (SELECT r.rlc_disp_nm FROM custom c, rlc r WHERE c.user_id=m.user_id
 and c.rlc_id=r.rlc_id) as rlc_nm
                                                         , (SELECT d.dlc_disp_nm FROM custom c, dlc d WHERE c.user_id=m.user_id
 and c.dlc_id=d.dlc_id) as dlc_nm
                                                         , (SELECT user_nm FROM system_user e WHERE e.user_id = m.crt_user_id) crt_user_nm
                                                         , (SELECT user_nm FROM system_user f WHERE f.user_id = m.appr_user_id) appr_user_nm
                                                         , reject_reason
                                                         , del_appr_yn
                                                  FROM (
                                                                SELECT a.custom_spc_num_id
                                                                         , a.user_id
                                                                         , a.spc_num_num
                                                                         , a.state_cd
                                                                         , a.appr_req_dttm appr_req_dttm
                                                                         , DECODE(a.state_cd, 'RUN', a.appr_proc_dttm, null) appr_proc_dttm
                                                                         , DECODE(a.state_cd, 'RUN', a.appr_proc_dttm , a.appr_req_dttm) crt_dttm
                                                                         , b.svc_cl
                                                                         , (SELECT cd_nm FROM com_cd WHERE cd_grp_id = 'SVC_CL_CD' AND cd_id = b.svc_cl) cd_nm
                                                                         , a.crt_user_id
                                                                         , a.appr_user_id
                                                                         , a.reject_reason
                                                                         , a.del_appr_yn
                                                                  FROM custom_spc_num a
                                                                         , custom_spc_num_svc b
                                                                         , custom c
                                                                 WHERE a.custom_spc_num_id = b.custom_spc_num_id
                                                                   AND a.state_cd  <>  'DEL'
                                                                   AND a.USER_ID = c.USER_ID











                AND a.user_id = 2832




                                                        ) m
                                                 GROUP BY custom_spc_num_id, user_id, spc_num_num, state_cd, appr_req_dttm, appr_proc_dttm, crt_dttm, crt_user_id, appr_user_id, reject_reason, del_appr_yn

                                                                ORDER BY crt_dttm DESC

                                        ) A WHERE ROWNUM <= 20



                        ) WHERE RNUM > 0;

select * from custom_spc_num_svc where svc_cl = 'OB';
update custom_spc_num_svc set svc_cl = 'SV' where svc_cl = 'OB';
commit;

SELECT /* [purchase/customChargeBuy.sqlmap.xml].[selectCustomChargeBuyList] by hwkim */
       *
FROM (
    SELECT c.custom_charge_buy_id
             , b.charge_id
             , c.custom_id
             , a.telecom_cd
             , (SELECT cd_nm FROM com_cd WHERE cd_grp_id = 'TELECOM_CD' AND cd_id = a.telecom_cd) telecom_nm
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
             , d c
     WHERE a.svc_id = b.svc_id
       AND b.charge_id = c.charge_id
       AND a.charge_cl = 'MSG'
       AND c.custom_id = 2832
       AND b.use_yn = 'Y'
       AND c.use_yn = 'Y'
       AND a.svc_cl = 'SV'
)
ORDER BY ord, price DESC;


select * from com_cd where cd_grp_id = 'SVC_CL_CD';

select * from custom_charge_buy;



INSERT INTO COM_CD (CD_ID, CD_GRP_ID, CD_NM, CD_DESC, PRT_ORD, USE_YN, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, REF_CD, BLC_ID)
VALUES('OB', 'SVC_CL_CD', '마케팅오비즈', '마케팅오비즈', 1, 'Y', SYSDATE, 'INIT', 'INIT', SYSDATE, 'INIT', 'INIT', null, 10);
commit;
select * from com_cd where cd_grp_id = 'SVC_CL_CD';
select * from rsrc where rsrc_url like '%htm%';
select * from role_rsrc_mapp where role_id = 102;

select * from rsrc order by rsrc_id desc;



>SELECT      role.role_id
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
                AND             rsrc.rsrc_url   = '/term1.html';

select * from rsrc where rsrc_url like '%htm%';
select * from role_rsrc_mapp where role_id = 202 and rsrc_id = 2200;
select * from custom_spc_num;
select * from
SELECT /* [user/userInfo.sqlmap.xml].[selectCustomUserAndRlcList] by hwkim */
                a.user_id
                , a.user_nm
                , b.blc_id
                , b.rlc_id
                , (SELECT r.rlc_disp_nm FROM rlc r WHERE r.rlc_id=b.rlc_id) as rlc_nm
                , (SELECT d.dlc_disp_nm FROM dlc d WHERE d.dlc_id=b.dlc_id) as dlc_nm
                FROM system_user a, custom b
                WHERE b.user_id = a.user_id
                        AND b.blc_id= 10
                AND  b.join_state_cd in ('JOIN_SUCC', 'LEAVE_RES')
                ORDER BY a.user_nm ASC

INSERT INTO RSRC (RSRC_ID, UP_RSRC_ID, RSRC_NM, RSRC_DESCR, RSRC_URL, RSRC_TP_CD, DOMAIN_TP_CD, PRT_ORD, PRT_LVL, USE_YN, PRGM_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID) VALUES(2200, NULL, '테스트', '테스트', '/term1.html', 'P', 'CUSTOMER',1,1,'Y', NULL,SYSDATE, 'INIT', 'INIT', SYSDATE, 'INIT', 'INIT');
INSERT INTO RSRC (RSRC_ID, UP_RSRC_ID, RSRC_NM, RSRC_DESCR, RSRC_URL, RSRC_TP_CD, DOMAIN_TP_CD, PRT_ORD, PRT_LVL, USE_YN, PRGM_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID) VALUES(2201, NULL, '테스트', '테스트', '/term2.html', 'P', 'CUSTOMER',2,1,'Y', NULL,SYSDATE, 'INIT', 'INIT', SYSDATE, 'INIT', 'INIT');
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(202, 2200, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
INSERT INTO ROLE_RSRC_MAPP (ROLE_ID, RSRC_ID, CRT_DTTM, CRT_USER_ID, CRT_PRGM_ID, UPD_DTTM, UPD_USER_ID, UPD_PRGM_ID, BLC_ID) VALUES(202, 2201, SYSDATE, 'init', 'init', SYSDATE, 'init', 'init', 10);
commit;

-- # 사용자 역할 매핑 파악
SELECT
    rmapp.*
FROM rsrc rsrc
INNER JOIN      role_rsrc_mapp  rmapp   ON      rmapp.rsrc_id = rsrc.rsrc_id
INNER JOIN  role role ON role.role_id = rmapp.role_id
LEFT OUTER JOIN user_role_mapp  umapp   ON      umapp.role_id = role.role_id
INNER JOIN system_user suser ON suser.user_id = umapp.user_id
WHERE 1 = 1
AND suser.user_id = 2833
AND     rsrc.use_yn             = 'Y'
order by NVL(rsrc.up_rsrc_id, 0), prt_ord;

select * from role;
select * from role_rsrc_mapp;

SELECT
       distinct
    rsrc.*
FROM rsrc rsrc
INNER JOIN role_rsrc_mapp rmapp ON rmapp.rsrc_id = rsrc.rsrc_id
INNER JOIN role role ON role.role_id = rmapp.role_id
WHERE 1 = 1
AND     rsrc.use_yn             = 'Y'
AND rmapp.role_id = 51;

-- # TEST
SELECT /* [user/customerContact.sqlmap.xml].[selectCustomerContactMainUserInfo] by hwKim */
			   user_id
			 , custom_id
			 , login_id
			 , pw
			 , contact_nm
			 , contact_tp
			 , depart
			 , rank
			 , email
			 , cell_phone1
			 , cell_phone2
			 , cell_phone3
			 , tele_phone1
			 , tele_phone2
			 , tele_phone3
			 , fax1
			 , fax2
			 , fax3
			 , addr
			 , sms_agre_yn
			 , email_agre_yn
			 , join_state_cd
			 , state_cd
			 , login_fail_cnt
			 , pw_upd_yn
			 , pw_upd_dttm
			 , login_dttm
			 , user_join_dttm
			 , appr_dttm
			 , crt_dttm
			 , crt_user_id
			 , crt_prgm_id
			 , upd_dttm
			 , upd_user_id
			 , upd_prgm_id
			 ,'' as join_state_nm
			 ,'' as state_nm
			 , (SELECT user_nm FROM system_user b WHERE b.user_id = a.custom_id) user_nm
		  FROM custom_contact a
		 WHERE contact_tp = 'CHR'
		   AND custom_id = 2832;

-- # UserId를 가지고 BLC정보 조회
select
    d.*
from system_user a
INNER JOIN custom_contact b ON a.user_id = b.user_id
INNER JOIN custom c ON b.custom_id = c.user_id
INNER JOIN BLC d ON d.blc_id = c.blc_id
where a.user_id = 2833;

-- # OBIZ 사업자 Admin 추가
select * from blc;
select * from rlc;

insert into blc (
    blc_id, blc_cd, blc_nm, crt_dttm, crt_user_id, crt_prgm_id, upd_dttm, upd_user_id, upd_prgm_id, blc_disp_nm
) values (10,'BLC_OBIZ','사업자 Admin(오비즈)',SYSDATE,'INIT','INIT',SYSDATE,'INIT','INIT','오비즈');
commit;

select * from rlc;
insert into rlc (
    rlc_id, rlc_cd, rlc_nm, crt_dttm, crt_user_id, crt_prgm_id, upd_dttm, upd_user_id, upd_prgm_id, rlc_disp_nm, blc_id
) values (100,'RLC_OBIZ','중계사 Admin(오비즈)',SYSDATE,'INIT','INIT',SYSDATE,'INIT','INIT','오비즈 중계사', 10);
commit;
-- 사업자+중계사id 조회
SELECT d.RLC_ID, d.BLC_ID
FROM RLC d, BLC r
WHERE d.RLC_CD = 'RLC_OBIZ'
AND d.BLC_ID = r.BLC_ID


		SELECT	role.role_id
			,	role.role_tp_cd
			,	role.role_nm
			,	role.role_descr
			,	role.use_yn
			,	role.crt_dttm
			,	role.crt_user_id
			,	role.crt_prgm_id
			,	role.upd_dttm
			,	role.upd_user_id
			,	role.upd_prgm_id
		FROM			role			role
		WHERE	1=1
		AND		role.role_tp_cd	= 'DLC'
		ORDER BY PRT_ORD;

select * from role;


select * from custom;
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
				UNION ALL
				SELECT
				DLC_CD as cdId,
				DLC_NM as cdNm
				FROM DLC
				UNION ALL
				SELECT
				ROLE_tp_cd as cdId,
				ROLE_NM as cdNm
				FROM ROLE
				WHERE DOMAIN_TP_CD = 'ADMIN' AND role_tp_cd IN ('OPR', 'DEV')
			) A
		);

select * from admin;

select * from role;
select * from role_rsrc_mapp where role_id = 101;
select * from rsrc;
select * from role where role_tp_cd = 'API'
select * from user_role_mapp where user_id = 2833;


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
                AND suser.user_id = 2833
                AND     rsrc.use_yn             = 'Y'
                order by NVL(rsrc.up_rsrc_id, 0), prt_ord;


-- ## 시스템 유저 (user_tp_cd)
select distinct user_tp_cd from system_user;
select * from system_user;
select * from admin;
select * from custom;


-- ## 회원가입후 조회
select * from custom where biz_reg_num = '222-22-22222';
select * from system_user where user_id = 2832;
update system_user set user_tp_cd = 'OBIZ_CUST' where user_id = 2833;commit;
update system_user set user_tp_cd = 'OBIZ_API' where user_id = 2832;commit;
select * from custom_contact where user_id = 2832;
select * from custom_contact;

select * from custom_contact where login_id = 'test_vasteam'
select * from custom where user_id = 2928;
select * from system_user where user_id = 2133;


-- ## OBIZ 로그인
SELECT
    u.user_id
    , u.user_tp_cd
    , u.user_nm
    , u.user_tp_cd
    , u.user_descr
    , c.custom_id
    , c.login_id
    , c.pw
    , c.contact_nm
    , c.contact_tp
    , c.depart
    , c.rank
    , c.email
    , c.cell_phone1
    , c.cell_phone2
    , c.cell_phone3
    , c.tele_phone1
    , c.tele_phone2
    , c.tele_phone3
    , c.fax1
    , c.fax2
    , c.fax3
    , c.addr
    , c.sms_agre_yn
    , c.email_agre_yn
    , c.join_state_cd
    , c.state_cd
    , c.login_fail_cnt
    , c.pw_upd_yn
    , c.pw_upd_dttm
    , c.login_dttm
    , c.user_join_dttm
    , c.appr_dttm
    , c.crt_dttm
    , c.crt_user_id
    , c.crt_prgm_id
    , c.upd_dttm
    , c.upd_user_id
    , c.upd_prgm_id
    ,'' as join_state_nm
    ,'' as state_nm
    , (SELECT user_nm FROM system_user x WHERE x.user_id = c.custom_id) custom_nm
    , (SELECT blc_id FROM CUSTOM cu WHERE cu.user_id=c.custom_id) as blc_id
    , (SELECT rlc_id FROM CUSTOM cu WHERE cu.user_id=c.custom_id) as rlc_id
    , role.role_id          AS role__role_id
    , role.role_tp_cd       AS role__role_tp_cd
    , role.role_nm          AS role__role_nm
    , role.role_descr       AS role__role_desc
    , role.use_yn           AS role__use_yn
FROM system_user u
INNER JOIN custom_contact c
ON      u.user_id = c.user_id
LEFT OUTER JOIN user_role_mapp  mapp
ON      c.user_id = mapp.user_id
LEFT OUTER JOIN role role
ON      mapp.role_id = role.role_id
WHERE u.user_tp_cd = 'CUST'
AND     c.login_id = 'dev_obiztest';

select * from custom_contact; -- chr, subid로 어시스턴트 -- custom_id/
select * from system_user a inner join admin b on a.user_id = b.user_id;
select * from admin;
select * from blc;
select * from rlc;

SELECT /* [purchase/customChargeBuy.sqlmap.xml].[selectCustomChargeBuyList] by hwkim */
                           *
                  FROM (
                        SELECT c.custom_charge_buy_id
                                 , b.charge_id
                                 , c.custom_id
                                 , a.telecom_cd
                                 , (SELECT cd_nm FROM com_cd WHERE cd_grp_id = 'TELECOM_CD' AND cd_id = a.telecom_cd) telecom_nm
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
                           AND c.custom_id = 2832
                           AND b.use_yn = 'Y'
                           AND c.use_yn = 'Y'
                           AND a.svc_cl = 'MK'


                  )
                 ORDER BY ord, price DESC;


		SELECT /* [user/customerContact.sqlmap.xml].[selectCustomerContactMainUserInfoByBizReNum] by hwKim */
			   a.user_id
		     , b.user_id
		     , b.biz_reg_num
			 , a.custom_id
			 , a.login_id
			 , a.pw
			 , a.contact_nm
			 , a.contact_tp
			 , a.depart
			 , a.rank
			 , a.email
			 , a.cell_phone1
			 , a.cell_phone2
			 , a.cell_phone3
			 , a.tele_phone1
			 , a.tele_phone2
			 , a.tele_phone3
			 , a.fax1
			 , a.fax2
			 , a.fax3
			 , a.addr
			 , a.sms_agre_yn
			 , a.email_agre_yn
			 , a.join_state_cd
			 , a.state_cd
			 , a.login_fail_cnt
			 , a.pw_upd_yn
			 , a.pw_upd_dttm
			 , a.login_dttm
			 , a.user_join_dttm
			 , a.appr_dttm
			 , a.crt_dttm
			 , a.crt_user_id
			 , a.crt_prgm_id
			 , a.upd_dttm
			 , a.upd_user_id
			 , a.upd_prgm_id
			 , '' as join_state_nm
			 , '' as state_nm
		FROM custom_contact a
		INNER JOIN custom b on b.user_id = a.custom_id --AND b.biz_reg_num = #{bizRegNum}
		WHERE contact_tp = 'CHR'
AND b.biz_reg_num = '222-22-22222';




-- ## 발신번호
SELECT /* [purchase/customSpcNum.sqlmap.xml].[selectCustomSpcNumPageList] by hwkim */
*
FROM (
    SELECT ROWNUM AS RNUM
    , A.*
    FROM (
        SELECT m.custom_spc_num_id
        , m.user_id
        , m.spc_num_num
        , LISTAGG(m.cd_nm, ', ') WITHIN GROUP (ORDER BY m.svc_cl) svc_cl_nm
        , LISTAGG(m.svc_cl, ', ') WITHIN GROUP (ORDER BY m.svc_cl) svc_cl
        , m.state_cd
        , m.appr_req_dttm
        , m.appr_proc_dttm
        , m.crt_dttm
        , (SELECT user_nm FROM system_user d WHERE d.user_id = m.user_id) user_nm
        , m.crt_user_id
        , (SELECT r.rlc_disp_nm FROM custom c, rlc r WHERE c.user_id=m.user_id
        and c.rlc_id=r.rlc_id) as rlc_nm
        , (SELECT d.dlc_disp_nm FROM custom c, dlc d WHERE c.user_id=m.user_id
        and c.dlc_id=d.dlc_id) as dlc_nm
        , (SELECT user_nm FROM system_user e WHERE e.user_id = m.crt_user_id) crt_user_nm
        , (SELECT user_nm FROM system_user f WHERE f.user_id = m.appr_user_id) appr_user_nm
        , reject_reason
        , del_appr_yn
        FROM (
            SELECT a.custom_spc_num_id
            , a.user_id
            , a.spc_num_num
            , a.state_cd
            , a.appr_req_dttm appr_req_dttm
            , DECODE(a.state_cd, 'RUN', a.appr_proc_dttm, null) appr_proc_dttm
            , DECODE(a.state_cd, 'RUN', a.appr_proc_dttm , a.appr_req_dttm) crt_dttm
            , b.svc_cl
            , (SELECT cd_nm FROM com_cd WHERE cd_grp_id = 'SVC_CL_CD' AND cd_id = b.svc_cl) cd_nm
            , a.crt_user_id
            , a.appr_user_id
            , a.reject_reason
            , a.del_appr_yn
            FROM custom_spc_num a
            , custom_spc_num_svc b
            , custom c
            WHERE a.custom_spc_num_id = b.custom_spc_num_id
            AND a.state_cd  <>  'DEL'
            AND a.USER_ID = c.USER_ID
            AND a.user_id = 2832
        ) m
        GROUP BY custom_spc_num_id, user_id, spc_num_num, state_cd, appr_req_dttm, appr_proc_dttm, crt_dttm, crt_user_id, appr_user_id, reject_reason, del_appr_yn
        ORDER BY crt_dttm DESC
    ) A WHERE ROWNUM <= 10
) WHERE RNUM > 0


SELECT /* [purchase/customSpcNum.sqlmap.xml].[getCustomSpcNumTotalCount] by hwkim */
                           COUNT(*)
                  FROM (
                                SELECT m.custom_spc_num_id
                                         , m.user_id
                                         , m.spc_num_num
                                         , LISTAGG(m.cd_nm, ', ') WITHIN GROUP (ORDER BY m.svc_cl) svc_cl_nm
                                         , LISTAGG(m.svc_cl, ', ') WITHIN GROUP (ORDER BY m.svc_cl) svc_cl
                                         , m.state_cd
                                         , m.crt_dttm
                                         , (SELECT user_nm FROM system_user d WHERE d.user_id = m.user_id) user_nm
                                         , m.crt_user_id
                                         , (SELECT rlc_id FROM custom c WHERE c.user_id=m.user_id) rlc_id
                                         , (SELECT user_nm FROM system_user e WHERE e.user_id = m.crt_user_id) crt_user_nm
                                         , (SELECT user_nm FROM system_user f WHERE f.user_id = m.appr_user_id) appr_user_nm
                                         , reject_reason
                                         , del_appr_yn
                                  FROM (
                                                SELECT a.custom_spc_num_id
                                                         , a.user_id
                                                         , a.spc_num_num
                                                         , a.state_cd
                                                         , DECODE(a.state_cd, 'RUN', a.appr_proc_dttm , a.appr_req_dttm) crt_dttm
                                                         , b.svc_cl
                                                         , (SELECT cd_nm FROM com_cd WHERE cd_grp_id = 'SVC_CL_CD' AND cd_id = b.svc_cl) cd_nm
                                                         , a.crt_user_id
                                                         , a.appr_user_id
                                                         , a.reject_reason
                                                         , a.del_appr_yn
                                                  FROM custom_spc_num a
                                                         , custom_spc_num_svc b
                                                         , custom c
                                                 WHERE a.custom_spc_num_id = b.custom_spc_num_id
                                                   AND a.state_cd  <>  'DEL'


                AND a.state_cd = 'RUN'




                AND a.user_id = 2969



                                                   AND a.USER_ID = c.USER_ID






                                        ) m
                                 GROUP BY custom_spc_num_id, user_id, spc_num_num, state_cd, crt_dttm, crt_user_id, appr_user_id, reject_reason, del_appr_yn
                        ) A
                        WHERE 1=1;


SELECT /*[user/customerContact.sqlmap.xml].[selectCustomerContactList] by hwKim*/
                           user_id
                         , '' AS user_nm
                         , custom_id
                         , login_id
                         , pw
                         , contact_nm
                     , contact_tp
                     , depart
                     , rank
                     , email
                     , cell_phone1
                     , cell_phone2
                     , cell_phone3
                     , tele_phone1
                     , tele_phone2
                     , tele_phone3
                     , fax1
                     , fax2
                     , fax3
                     , addr
                     , sms_agre_yn
                     , email_agre_yn
                     , join_state_cd
                     , state_cd
                     , login_fail_cnt
                     , pw_upd_yn
                     , pw_upd_dttm
                     , login_dttm
                     , user_join_dttm
                     , appr_dttm
                         ,'' as join_state_nm
                         ,'' as state_nm
                         , reject_reason
                  FROM custom_contact
                 WHERE custom_id = 2969
                 ORDER BY user_id;



SELECT /* [purchase/customChargeBuy.sqlmap.xml].[selectUsingFreeChargePageList] by hwkim */
                           *
                  FROM (
                                SELECT ROWNUM AS RNUM
                                         , A.*
                                  FROM (
                                                SELECT *
                                                  FROM (

                                                                SELECT c.custom_charge_buy_id
                                                                         , c.custom_id
                                                                     , d.user_nm custom_nm
                                                                     , a.telecom_cd
                                                                     , a.svc_cl
                                                                     , b.free_provide_period
                                                                     , c.buy_dttm
                                                                     , c.buy_dttm + TO_NUMBER(b.free_provide_period)-1 svc_end_dttm
                                                                     , (SELECT x.user_nm FROM system_user x WHERE x.user_id = c.buy_user_id) buy_user_nm
                                                                  FROM charge_svc a
                                                                         , charge b
                                                                     , custom_charge_buy c
                                                                     , system_user d
                                                                         , CUSTOM cu
                                                                 WHERE a.svc_id = b.svc_id
                                                                   AND b.charge_id = c.charge_id
                                                                   AND c.custom_id = d.user_id
                                                                   AND a.charge_cl = 'MSG'
                                                                   AND b.bill_tp_cd = 'FR'
                                                                   AND c.use_yn = 'Y'
                                                                   AND cu.USER_ID = d.USER_ID


                        AND cu.blc_id = 10











                                                  )

                                                                ORDER BY custom_nm ASC

                                        ) A WHERE ROWNUM <= 10
                        ) WHERE RNUM > 0


