-- # AGENT
-- 1. 인증
SELECT
            a.host_sn, a.host_id, e.vpc_sn, c.sub_sn, a.cld_type, b.host_nw_public_ip_addr, f.ami_sn
        FROM
            CLD_HOST a
        JOIN
        	CLD_HOST_NETWORK b ON a.host_sn = b.host_sn
        JOIN
        	CLD_SUBNET c ON a.sub_sn = c.sub_sn
        JOIN
        	CLD_SUBNET_DTL d ON c.sub_sn = d.sub_sn
        JOIN
        	CLD_VPC e ON a.vpc_sn = e.vpc_sn
        JOIN
        	CLD_AMI f ON a.host_sn = f.host_sn
        WHERE
        	b.host_nw_public_ip_addr = '52.78.46.217' AND e.vpc_id = 'vpc-5af90631';

-- DELETE AGENT
DELETE FROM INFO_AGENT WHERE agent_id = '000000040000000100000007000000100000000400010011';

-- REF QUERY
SELECT * FROM INFO_AGENT;

-- CPU
DELETE FROM INFO_AGENT_CPU_DTL;
ALTER TABLE INFO_AGENT_CPU_DTL AUTO_INCREMENT = 1;

SELECT * FROM INFO_AGENT;
SELECT * FROM CLD_HOST_CPU;
SELECT * FROM CLD_HOST_CPU_DTL;
SELECT * FROM INFO_AGENT_CPU_DTL;

-- MEMORY
SELECT * FROM INFO_AGENT_MEMORY;

-- AGENT MEMORY
SELECT * FROM INFO_AGENT_MEMORY;
SELECT * FROM INFO_AGENT_MOUNT;
SELECT * FROM INFO_AGENT_MOUNT_DTL;
select * from info_agent_nic_dtl;

select * from CLD_SG_INGRESS_DTL;
SELECT * FROM info_agent_rc_mgr_sw_DTL;

-- MGR SW
SELECT * FROM INFO_AGENT_RC_MGR_SW_DTL;

-- NIC
SELECT * FROM INFO_AGENT_NIC;
SELECT * FROM INFO_AGENT_NIC_DTL;

-- DISK
SELECT * FROM INFO_AGENT_DISK;
SELECT * FROM INFO_AGENT_DISK_DTL;

-- OS
SELECT * FROM INFO_AGENT_OS;

-- MOUNT
SELECT * FROM INFO_AGENT_MOUNT;
SELECT * FROM INFO_AGENT_MOUNT_DTL;

-- AGENT
select * from info_agent;

-- 호스트 시스템 로그
SELECT
    a.host_sn, UPPER(syslog_yn) as syslog_yn, UPPER(alert_yn), UPPER(critical_yn), UPPER(error_yn), UPPER(warn_yn), UPPER(notice_yn), UPPER(info_yn), UPPER(debug_yn), UPPER(etc_yn), reg_mgr_id, reg_dt, mod_mgr_id, mod_dt
FROM
    MGR_HOST_SYSLOG_CONF a
JOIN
    INFO_AGENT b ON a.host_sn = b.host_sn
WHERE
    b.agent_id = '00000008000000060000000d0000000200000023000165B1'

insert into mgr_host_syslog_conf
(host_sn, syslog_yn, alert_yn, critical_yn, error_yn, warn_yn, notice_yn, info_yn, debug_yn, etc_yn, reg_mgr_id, reg_dt, mod_mgr_id, mod_dt)
values(8, 'y', 'y', 'y', 'y', 'y', 'y', 'y', 'y', 'y', 'admin', now(), 'admin', now());

-- 호스트 방화벽 로그
SELECT
    a.host_sn, UPPER(fwlog_yn), UPPER(block_yn), UPPER(permit_yn), reg_mgr_id, reg_dt, mod_mgr_id, mod_dt
FROM
    MGR_HOST_FWLOG_CONF a
JOIN
    INFO_AGENT b ON a.host_sn = b.host_sn
WHERE
    b.agent_id = '00000008000000060000000d0000000200000023000165B1';

insert into MGR_HOST_FWLOG_CONF
(host_sn, fwlog_yn, block_yn, permit_yn, reg_mgr_id, reg_dt, mod_mgr_id, mod_dt)
values(8, 'y', 'y', 'y', 'admin', now(), 'admin', now())

-- 프로세스 정책
select * from MGR_HOST_PROCESS_CONF;
insert into MGR_HOST_PROCESS_CONF
(host_sn, process_nm, pid, parameters, use_yn, process_cnt_warn, process_cnt_cri, alias, reg_mgr_id, reg_dt, mod_mgr_id, mod_dt)
values(8, 'hogehoge', 123, 'param0 param2 param3 param4', 'y', 10, 20, '', 'admin', now(), 'admin', now());
insert into MGR_HOST_PROCESS_CONF
(host_sn, process_nm, pid, parameters, use_yn, process_cnt_warn, process_cnt_cri, alias, reg_mgr_id, reg_dt, mod_mgr_id, mod_dt)
values(8, 'hogehoge2', 124, 'param0 param2 param3 param4', 'y', 10, 20, '', 'admin', now(), 'admin', now());
insert into MGR_HOST_PROCESS_CONF
(host_sn, process_nm, pid, parameters, use_yn, process_cnt_warn, process_cnt_cri, alias, reg_mgr_id, reg_dt, mod_mgr_id, mod_dt)
values(8, 'hogehoge3', 125, 'param0 param2 param3 param4', 'y', 10, 20, '', 'admin', now(), 'admin', now());

SELECT
    a.host_process_no, a.host_sn, a.process_nm, a.pid, a.parameters, UPPER(a.use_yn), a.process_cnt_warn, a.process_cnt_cri, a.alias, a.reg_mgr_id, a.reg_dt, a.mod_mgr_id, a.mod_dt
FROM
    MGR_HOST_PROCESS_CONF a
JOIN
    INFO_AGENT b ON a.host_sn = b.host_sn
WHERE
    b.agent_id = '00000008000000060000000d0000000200000023000165B1';

SELECT
    *
FROM INFO_AGENT
WHERE
      1=1
      and work_dt > (NOW() - INTERVAL 15 MINUTE )
AND host_sn = 13;

ALTER TABLE INFO_AGENT ADD `status_logm_dt` DATETIME DEFAULT NULL AFTER status_monm_dt;
select * from info_agent;
-- 0: 미설치, 1: 정상, 2: 오류
SELECT
    (case
        when work_dt > (NOW() - INTERVAL 15 MINUTE) THEN 1
        when work_dt
        ELSE 2 END) as c1
FROM INFO_AGENT
WHERE host_sn = 4;

-- 0: 미설치, 1: 정상, 2: 오류
SELECT
    (CASE
        WHEN a.status_dt IS NULL THEN 0
        WHEN a.status_dt > (NOW() - INTERVAL 15 MINUTE) THEN 1
        ELSE 2 END
    ) AS status
FROM (
         SELECT status_dt
         FROM INFO_AGENT
         WHERE host_sn = 4
     ) AS a;

-- AGENT 존재유무
select
    *
from
    info_agent
where
    host_sn = 4;

-- AGENT 상태 갱신
update info_agent
set `status_dt` = now()
where  host_sn = 422233330928348;

SELECT IFNULL(
(SELECT
(
    CASE
    WHEN a.status_dt IS NULL THEN 0
    WHEN a.status_dt > (NOW() - INTERVAL 15 MINUTE) THEN 1
    ELSE 2 END
) AS status
FROM (
         SELECT status_dt
         FROM INFO_AGENT
         WHERE host_sn = 33
     )as a),0
) AS status

-- MAC IP
SELECT
    a.host_nw_private_ip_addr, b.ni_dtl_mac
FROM
    CLD_HOST_NETWORK a
JOIN
    CLD_NI_DTL b ON a.host_nw_private_ip_addr = b.ni_dtl_priv_ip
JOIN
    CLD_NI c ON b.ni_sn = c.ni_sn
WHERE
    b.ni_dtl_mac = '02:1c:c3:96:e3:18';


SELECT
    a.host_sn, a.host_id, e.vpc_sn, c.sub_sn, a.cld_type, b.host_nw_private_ip_addr, f.ami_sn, h.group_cd, g.work_dt, j.ni_dtl_mac
FROM
    CLD_HOST a
JOIN
    CLD_HOST_NETWORK b ON a.host_sn = b.host_sn
JOIN
    CLD_SUBNET c ON a.sub_sn = c.sub_sn
JOIN
    CLD_SUBNET_DTL d ON c.sub_sn = d.sub_sn
JOIN
    CLD_VPC e ON a.vpc_sn = e.vpc_sn
JOIN
    CLD_AMI f ON a.host_sn = f.host_sn
JOIN
    CLD_NI_DTL j ON b.host_nw_private_ip_addr = j.ni_dtl_priv_ip
JOIN
    CLD_NI k ON k.ni_sn = j.ni_sn
JOIN
    MGR_ADMIN_IAM_RC g ON g.iam_rc_type = 6 AND g.iam_rc_sn = a.host_sn
JOIN
    MGR_ADMIN_IAM_REGION i ON g.region_sn = i.region_sn
JOIN
    MGR_ADMIN_IAM h ON h.iam_main = 1 AND h.iam_sn = i.iam_sn;
WHERE
    b.host_nw_private_ip_addr = '' AND  j.ni_dtl_mac = #{ni_dtl_mac}
order by work_dt limit 1

select * from info_agent;
ALTER TABLE info_agent ADD `status_monit_dt` DATETIME DEFAULT NULL AFTER status_hfw_dt;


-- # 대화채널 구조 변경
-- 대화채널 정보 조회(0: 송신대상)
SELECT * FROM MGR_CANARY_INFO;
SELECT
    canary_mgr_sn
    , host_sn
    , host_nw_private_ip_addr
    , command
    , command_type
    , command_action
    , result_flg
    , work_dt
FROM
    MGR_CANARY_INFO
WHERE result_flg = 0

-- 대화채널 정보 입력
INSERT INTO MGR_CANARY_INFO (host_sn, host_nw_private_ip_addr, command, command_type, command_action, result_flg, work_dt)
VALUES (#{host_sn}, #{host_nw_private_ip_addr}, #{command}, 0, 0, 0,now())

-- 대화채널 정보 결과 갱신
UPDATE
    MGR_CANARY_INFO
SET
    result_flg = #{result_flg}
WHERE
    canary_mgr_sn = #{canary_mgr_sn}

-- 대화채널 정보 삭제(1: 송신완료)
DELETE FROM MGR_CANARY_INFO
WHERE result_flg = 1
;

select * from mgr_host_integrity_policy;
select * from mgr_host_integrity_policy_hist;
SELECT * FROM MGR_HOST_INTEGRITY_POLICY_HIST
WHERE agent_noti = 'N'

select * from mgr_host_integrity_policy;
select * from info_agent_fw_dtl;
select * from info_agent_fw_schedule;

select * from mgr_host_port_conf;
SELECT
    a.host_port_no, a.host_sn, a.service_nm, a.port_no, a.port_nm, a.protocol, a.use_yn, a.port_alarm_type, a.reg_mgr_id, a.reg_dt, a.mod_mgr_id, a.mod_dt
FROM
    MGR_HOST_PORT_CONF a
JOIN
    INFO_AGENT b ON a.host_sn = b.host_sn
WHERE
    b.agent_id = 'a';

select * from info_agent; where agent_id = '000000080000000a00000018000000020000002b000165B1';

select * from CLD_UNMANAGED_HOST;



SELECT
    a.host_sn, a.host_id, e.vpc_sn, c.sub_sn, a.cld_type, b.host_nw_private_ip_addr, f.ami_sn, h.group_cd, g.work_dt,j.ni_dtl_mac
FROM
    CLD_HOST a
JOIN
    CLD_HOST_NETWORK b ON a.host_sn = b.host_sn
JOIN
    CLD_SUBNET c ON a.sub_sn = c.sub_sn
JOIN
    CLD_SUBNET_DTL d ON c.sub_sn = d.sub_sn
JOIN
    CLD_VPC e ON a.vpc_sn = e.vpc_sn
JOIN
    CLD_AMI f ON a.host_sn = f.host_sn
JOIN
    CLD_NI_DTL j ON b.host_nw_private_ip_addr = j.ni_dtl_priv_ip
JOIN
    CLD_NI k ON k.ni_sn = j.ni_sn
JOIN
    MGR_ADMIN_IAM_RC g ON g.iam_rc_type = 6 AND g.iam_rc_sn = a.host_sn
JOIN
    MGR_ADMIN_IAM_REGION i ON g.region_sn = i.region_sn
JOIN
    MGR_ADMIN_IAM h ON h.iam_main = 1 AND h.iam_sn = i.iam_sn;
WHERE
    b.host_nw_private_ip_addr = '10.12.1.43' AND j.ni_dtl_mac = '02:1c:c3:96:e3:18'
order by work_dt limit 1


select * from cld_host;

select DATE_FORMAT(reg_dt, '%Y-%m-%d %H:%i:%s') from mgr_host_integrity_policy;

select UNIX_TIMESTAMP(reg_dt) from mgr_host_integrity_policy;


select * from info_agent_disk;
select * from info_agent_os;
select * from info_agent_cpu_dtl;

select * from cld_host;

select * from CLD_UNMANAGED_HOST;

-- 에이전트 설치 유무 판단
select
    *
from cld_host a
join info_agent b ON a.host_sn = b.host_sn



        SELECT
            a.iam_sn, a.group_cd, b.region_sn, b.regions, a.iam_cld_type, a.profile_id, a.access_key, a.secret_access_key as secret_key, a.iam_main, c.group_nm, a.availability_flag
        FROM
            MGR_ADMIN_IAM a
        JOIN
        	MGR_ADMIN_IAM_REGION b ON a.iam_sn = b.iam_sn
        JOIN
        	MGR_ADMIN_GROUP c ON a.group_cd = c.group_cd
        WHERE
            a.iam_main = 1




SELECT
     distinct ch.host_sn, ch.host_id, cv.vpc_sn, ch.sub_sn, ch.cld_type, chn.host_nw_private_ip_addr, cnd.ni_dtl_mac, b.regions, cv.vpc_id
FROM
    MGR_ADMIN_IAM a
JOIN
    MGR_ADMIN_IAM_REGION b ON a.iam_sn = b.iam_sn
JOIN
    MGR_ADMIN_IAM_RC c ON c.iam_rc_type = 6 AND c.region_sn = b.region_sn
JOIN
    MGR_ADMIN_GROUP e ON e.group_cd = a.group_cd
JOIN
    CLD_HOST ch ON ch.host_sn = c.iam_rc_sn
LEFT JOIN
    CLD_VPC cv ON ch.vpc_sn = cv.vpc_sn
LEFT JOIN
    CLD_HOST_NETWORK chn ON ch.host_sn = chn.host_sn
LEFT JOIN
    CLD_NI_DTL cnd ON chn.host_nw_private_ip_addr = cnd.ni_dtl_priv_ip
order by ch.host_sn

select * from info_agent_os where host_sn = 5;
select * from info_agent_cpu_dtl;
select * from info_agent_memory;
select * from info_agent_nic;
select * from info_agent_nic_dtl;
select * from info_agent_mount;
select * from info_agent_mount_dtl;
select * from info_agent_disk;
select * from info_agent_disk_dtl;
select * from info_agent_rc_mgr_sw_dtl;
select * from info_agent;
select * from info_agent_fw_dtl;


select * from info_agent_os where host_sn = 5;
select * from info_agent_cpu_dtl;
select * from info_agent_cpu_dtl b JOIN cld_host_cpu a on a.host_sn = b.host_cpu_sn where a.host_sn = 5;

select * from info_agent_memory where host_sn = 5;
select * from info_agent_nic where host_sn = 5;
select * from info_agent_nic_dtl where host_sn = 5;
select * from info_agent_mount where host_sn = 5;
select * from info_agent_mount_dtl where host_sn = 5;
select * from info_agent_disk where host_sn = 5;
select * from info_agent_disk_dtl where host_sn = 5;
select * from info_agent_rc_mgr_sw_dtl where host_sn = 5;
select * from info_agent where host_sn = 24;

		SELECT
		    a.mgr_id, a.authority_name, a.mgr_password, a.group_cd, b.mgr_name, b.mgr_phone_num, b.mgr_state, b.mgr_login_op, b.mgr_email_addr, b.mgr_desc, b.login_fail_cnt, e.group_cd as initCheckedCode, e.group_nm as initCheckedName, a.work_dt, a.temp_pass_dt, a.tmp_password
		FROM
		    MGR_ADMIN a
		JOIN
		    MGR_ADMIN_DTL b ON a.mgr_id = b.mgr_id
		JOIN
		    (
		    SELECT
		    	c.group_cd, c.group_nm, d.mgr_id
		    FROM
		        MGR_ADMIN_GROUP c
		    JOIN
		        MGR_ADMIN_GROUP_PERMISSION d ON c.group_cd = d.group_cd
		    WHERE c.group_depth = 1 ORDER BY c.group_depth, c.group_map ASC
		    ) AS e ON e.mgr_id = a.mgr_id
		WHERE
		    a.mgr_id = 'astron'


		    SELECT
		    	c.group_cd, c.group_nm, d.mgr_id
		    FROM
		        MGR_ADMIN_GROUP c
		    JOIN
		        MGR_ADMIN_GROUP_PERMISSION d ON c.group_cd = d.group_cd
		    WHERE mgr_id = 'admin' ORDER BY c.group_depth, c.group_map ASC


		SELECT
		    a.mgr_id, a.authority_name, a.mgr_password, a.group_cd, b.mgr_name, b.mgr_phone_num, b.mgr_state, b.mgr_login_op, b.mgr_email_addr, b.mgr_desc, b.login_fail_cnt, e.group_cd as initCheckedCode, e.group_nm as initCheckedName, a.work_dt, a.temp_pass_dt, a.tmp_password
		FROM
		    MGR_ADMIN a
		JOIN
		    MGR_ADMIN_DTL b ON a.mgr_id = b.mgr_id
		JOIN
		    (
		    SELECT
		    	c.group_cd, c.group_nm, d.mgr_id
		    FROM
		        MGR_ADMIN_GROUP c
		    JOIN
		        MGR_ADMIN_GROUP_PERMISSION d ON c.group_cd = d.group_cd
		    WHERE c.group_depth != 1 ORDER BY c.group_depth, c.group_map ASC
		    ) AS e ON e.mgr_id = a.mgr_id
		WHERE
		    a.mgr_id = 'admin' LIMIT 1




alter table INFO_AGENT_MOUNT_DTL change mount_dtl_name VARCHAR(50) DEFAULT '';


ALTER TABLE INFO_AGENT_MOUNT_DTL MODIFY `mount_dtl_name` VARCHAR(50) NOT NULL;

        DELETE
			a, b, c, f, g, h, i, j, k, l, m, n, o, p, r,
		FROM
			INFO_AGENT a
		LEFT JOIN INFO_AGENT_DISK b ON a.host_sn = b.host_sn
		LEFT JOIN INFO_AGENT_DISK_DTL c ON b.disk_sn = c.disk_sn
		LEFT JOIN INFO_AGENT_FW_DTL f ON a.host_sn = f.host_sn
		LEFT JOIN INFO_AGENT_FW_SCHEDULE g ON f.fw_dtl_sn = g.fw_dtl_sn
		LEFT JOIN INFO_AGENT_MEMORY h ON a.host_sn = h.host_sn
		LEFT JOIN INFO_AGENT_MOUNT i ON a.host_sn = i.host_sn
		LEFT JOIN INFO_AGENT_MOUNT_DTL j ON  i.mount_sn = j.mount_sn
		LEFT JOIN INFO_AGENT_NIC k ON a.host_sn = k.host_sn
		LEFT JOIN INFO_AGENT_NIC_DTL l ON k.nic_sn = l.nic_sn
		LEFT JOIN INFO_AGENT_OS m ON a.host_sn = m.host_sn
		LEFT JOIN INFO_AGENT_PROCESS n ON a.host_sn = n.host_sn
		LEFT JOIN INFO_AGENT_PROCESS_CONFIG o ON n.pm_sn = o.pm_sn
		LEFT JOIN INFO_AGENT_PROCESS_DTL p ON n.pm_sn = p.pm_sn
		LEFT JOIN INFO_AGENT_RC_MGR_SW_DTL r ON a.host_sn = r.host_sn

--		LEFT JOIN INFO_AGENT_CPU_DTL s ON host_cpu.host_cpu_sn = s.host_cpu_sn
		WHERE
			a.host_sn =5;


show processlist
kill 7

select * from information_schema.INNODB_LOCK_WAITS;
select * from mgr_host_url_conf;
UPDATE mgr_host_url_conf
        SET use_yn='N',
                mod_mgr_id='astron', mod_dt=now()
        WHERE host_url_no=3

ddelete from info_agent where agent_id = '000000060000000100000007000000020000024b000124D4'

select * from cld_host;

insert into cld_host values(20, 'i-testtest', 11, 22, 3, 0, now());
delete from cld_host where host_sn = 20;

select * from info_agent;
select * from info_agent_os;
select * from info_agent_mount;
select * from cld_host_cpu;
select * from info_agent_cpu_dtl;
select * from info_agent_memory;
select * from cld_host_cpu a JOIN info_agent_cpu_dtl b on a.host_cpu_sn = b.host_cpu_sn

SELECT
    a.host_cpu_sn
FROM
    CLD_HOST_CPU a
JOIN
    INFO_AGENT b ON a.host_sn = b.host_sn
WHERE
    b.agent_id = '000000050000000100000007000000020000026100012A2C';

select * from info_agent where agent_id = '0000000600000001000000070000000200000262000124D4';
select * from info_agent_cpu_dtl where host_cpu_sn = 609;
select * from info_agent where host_sn = 6;
select * from cld_host_cpu;
select count(1) from info_agent_rc_mgr_sw_dtl where host_sn = 6;
select * from cld_host_alarm;



select * from MGR_HOST_PORT_CONF;
update MGR_HOST_PORT_CONF
set host_sn = 6
where host_port_no = 3;

select * from cld_host_alarm;



SELECT date_format( (base - INTERVAL b*10+c DAY),'%Y%m%d')  AS base_day
FROM
   (SELECT date_format(NOW(), '%Y%m%d') AS base) a
 , (SELECT 0 b
    UNION ALL SELECT 1
    UNION ALL SELECT 2
    UNION ALL SELECT 3
    UNION ALL SELECT 4
    UNION ALL SELECT 5
    UNION ALL SELECT 6
    UNION ALL SELECT 7
    UNION ALL SELECT 8
    UNION ALL SELECT 9
    ) b
 , (SELECT 0 c
    UNION ALL SELECT 1
    UNION ALL SELECT 2
    UNION ALL SELECT 3
    UNION ALL SELECT 4
    UNION ALL SELECT 5
    UNION ALL SELECT 6
    UNION ALL SELECT 7
    UNION ALL SELECT 8
    UNION ALL SELECT 9
    ) c
 WHERE b*10+c < 30



SELECT
    UNIX_TIMESTAMP(T20.base_day)*1000 as base_day,
    IFNULL(T15.y, 0) as y
FROM
(
    SELECT date_format( (base - INTERVAL b*10+c DAY),'%Y%m%d')  AS base_day
FROM
   (SELECT date_format(NOW(), '%Y%m%d') AS base) a
 , (SELECT 0 b
    UNION ALL SELECT 1
    UNION ALL SELECT 2
    UNION ALL SELECT 3
    UNION ALL SELECT 4
    UNION ALL SELECT 5
    UNION ALL SELECT 6
    UNION ALL SELECT 7
    UNION ALL SELECT 8
    UNION ALL SELECT 9
    ) b
 , (SELECT 0 c
    UNION ALL SELECT 1
    UNION ALL SELECT 2
    UNION ALL SELECT 3
    UNION ALL SELECT 4
    UNION ALL SELECT 5
    UNION ALL SELECT 6
    UNION ALL SELECT 7
    UNION ALL SELECT 8
    UNION ALL SELECT 9
    ) c
 WHERE b*10+c < 30
) as T20
LEFT JOIN (
SELECT
      work_dt as x
    , IFNULL(SUM(case when rc_type = 3 then cnt else 0 end),0) as y
FROM (
    SELECT
           DATE_FORMAT(work_dt, '%Y%m%d') as work_dt
         , rc_type
         , COUNT(1) AS cnt
    FROM MGR_CHG_RC_LOG_DESC
    WHERE group_cd IN (2)
    AND rc_type IN (3)
    AND chg_type  = 3
    AND work_dt  > (NOW() - INTERVAL 1 MONTH )
    GROUP BY work_dt
) as T10) as T15 ON T15.x = T20.base_day



		SELECT
		      work_dt as x
		    , IFNULL(SUM(case when rc_type = 3 then cnt else 0 end),0) as y
		FROM (
			SELECT
			       UNIX_TIMESTAMP(work_dt)*1000 as work_dt
			     , rc_type
			     , COUNT(1) AS cnt
			FROM MGR_CHG_RC_LOG_DESC
			WHERE group_cd IN (2)
			AND rc_type IN (3)
			AND chg_type  = 3
			AND work_dt  > (NOW() - INTERVAL 1 MONTH )
			GROUP BY DATE_FORMAT(work_dt, '%Y%m%d')
		) as T10;


-- 조회
-- 테스트 HOST_SN: 3
delete from mgr_host_integrity_policy
where host_integrity_policy_no = 2
and host_sn = 3;

SELECT * FROM mgr_host_integrity_policy;
where reg_mgr_id = 'admin';
DELETE FROM mgr_host_integrity_policy;
DELETE FROM mgr_host_integrity_policy
		WHERE host_integrity_policy_no IN
    			 (2,3,4,5,6,7,8,9,10);

DELETE FROM mgr_host_integrity_policy
		WHERE host_integrity_policy_no = 9 and reg_mgr_id = 'admin';


update mgr_host_integrity_policy set changes ='1,2,4'
where host_integrity_policy_no = 1;



-- # 공통
-- TAG 조회
-- (자산별 태그는 [자산]_TAG 에 있다. 태그는 하나의 자산에 여러개가 존재한다. 화면에 태그를 가져와야 하는 경우 태그목록 중에서 1번째 로우를 사용하기로 한다)
-- 예) NACL에서 태그를 가져오는 방법
SELECT
    nacl_tag_value
FROM
    CLD_NACL a
JOIN
    CLD_NACL_TAG b ON a.nacl_sn = b.nacl_sn
ORDER BY nacl_tag_sn ASC LIMIT 1;

# HOST자산 가져오기
select
    b.vpc_sn, b.sub_sn
from
    MGR_ADMIN_IAM_RC a
JOIN CLD_HOST b ON a.iam_rc_sn = b.host_sn
where iam_rc_type = 6;

# VPC자산 가져오기
select
    b.vpc_sn, b.vpc_id
from
    MGR_ADMIN_IAM_RC a
JOIN CLD_VPC b ON a.iam_rc_sn = b.vpc_sn
where iam_rc_type = 1;

# 가용영역 Subnet
select
    b.sub_sn, c.sub_dtl_az
from
    MGR_ADMIN_IAM_RC a
JOIN CLD_SUBNET b ON a.iam_rc_sn = b.sub_sn
JOIN CLD_SUBNET_DTL c ON b.sub_sn = c.sub_sn
where iam_rc_type = 4;

# HOST가 속한 AZ
select
    b.host_sn, b.host_id,
    (select c.sub_dtl_az from cld_subnet_dtl c where c.sub_sn = b.sub_sn) as sub_dtl_az
from
    MGR_ADMIN_IAM_RC a
JOIN CLD_HOST b ON a.iam_rc_sn = b.host_sn
WHERE a.iam_rc_type = 6;

# HOST가 속한 AZ
SELECT
    b.host_sn, b.host_id, c.sub_dtl_az
FROM
    MGR_ADMIN_IAM_RC a
JOIN
    CLD_HOST b ON a.iam_rc_sn = b.host_sn
JOIN
    CLD_SUBNET_DTL c ON c.sub_sn = b.sub_sn
WHERE a.iam_rc_type = 6;

## 그룹에 포함된 자산(예제는 SG) 가져오기
SELECT
    a.iam_sn, a.group_cd, b.region_sn, b.regions, d.vpc_sn
FROM
    MGR_ADMIN_IAM a
JOIN
    MGR_ADMIN_IAM_REGION b ON a.iam_sn = b.iam_sn
JOIN
    MGR_ADMIN_IAM_RC c ON c.iam_rc_type = 5 AND c.region_sn = b.region_sn
JOIN
    CLD_SG d ON d.vpc_sn  = c.iam_rc_sn
JOIN
    MGR_ADMIN_GROUP e ON e.group_cd = a.group_cd
WHERE
    a.group_cd IN (1, 2, 3, 4, 5)
GROUP BY d.vpc_sn;

## HOST 의 IP가져오기
SELECT
    a.host_sn, a.host_id, b.host_nw_private_ip_addr, b.host_nw_public_ip_addr
FROM
    CLD_HOST a
JOIN
    CLD_HOST_NETWORK b ON a.host_sn = b.host_sn
WHERE
    a.host_sn = 2;


SELECT
    a.mgr_id, a.authority_name, a.mgr_password, a.group_cd, b.mgr_name, b.mgr_phone_num, b.mgr_state, b.mgr_login_op, b.mgr_email_addr, b.mgr_desc, b.login_fail_cnt, a.work_dt
FROM
    MGR_ADMIN a
JOIN
    MGR_ADMIN_DTL b ON a.mgr_id = b.mgr_id
WHERE
    a.mgr_id = 'admin';

## User 의 그룹코드 가져오기
select * from mgr_admin_group_permission;

## 프로필 아이디 취득
select *
from
    mgr_admin_group_permission
JOIN
    mgr_admin_iam

## 트리
SELECT * FROM MGR_ADMIN_DTL;

# User의 group_cd (복수) 가져오기
SELECT
    b.group_cd
FROM
    MGR_ADMIN a
JOIN
    MGR_ADMIN_GROUP_PERMISSION b ON a.mgr_id = b.mgr_id
WHERE
    a.mgr_id = 'admin';

SELECT * FROM MGR_ADMIN_IAM;

SELECT
    *
FROM
    MGR_ADMIN_IAM a
JOIN
    MGR_ADMIN_GROUP_



# 사용자 정보 가져오기
SELECT
    a.mgr_id, a.authority_name, a.mgr_password, a.group_cd, b.mgr_name, b.mgr_phone_num, b.mgr_state, b.mgr_login_op, b.mgr_email_addr, b.mgr_desc, b.login_fail_cnt, a.work_dt
FROM
    MGR_ADMIN a
JOIN
    MGR_ADMIN_DTL b ON a.mgr_id = b.mgr_id
WHERE
    a.mgr_id = 'admin';


# 사용자가 속한 group_cd(복수) 가져오기
SELECT
    b.group_cd
FROM
    MGR_ADMIN a
JOIN
    MGR_ADMIN_GROUP_PERMISSION b ON a.mgr_id = b.mgr_id
WHERE
    a.mgr_id = 'api_test1';

# 자산이 속한 그룹 가져오기(HOST)
SELECT
     distinct ch.host_sn, ch.host_id, cv.vpc_sn, ch.sub_sn, ch.cld_type, chn.host_nw_private_ip_addr, cnd.ni_dtl_mac, b.regions, cv.vpc_id
FROM
    MGR_ADMIN_IAM a
JOIN
    MGR_ADMIN_IAM_REGION b ON a.iam_sn = b.iam_sn
JOIN
    MGR_ADMIN_IAM_RC c ON c.iam_rc_type = 6 AND c.region_sn = b.region_sn
JOIN
    MGR_ADMIN_GROUP e ON e.group_cd = a.group_cd
JOIN
    CLD_HOST ch ON ch.host_sn = c.iam_rc_sn
LEFT JOIN
    CLD_VPC cv ON ch.vpc_sn = cv.vpc_sn
LEFT JOIN
    CLD_HOST_NETWORK chn ON ch.host_sn = chn.host_sn
LEFT JOIN
    CLD_NI_DTL cnd ON chn.host_nw_private_ip_addr = cnd.ni_dtl_priv_ip
WHERE
    ch.host_sn in (3,4,7,9,10,11,47,48,49,50,51,52)
order by ch.host_sn



select b.ni_dtl_mac from CLD_HOST_NETWORK a
JOIN CLD_NI_DTL b ON a.host_nw_private_ip_addr = b.ni_dtl_priv_ip
where host_nw_private_ip_addr = '10.12.1.43'

4,7, 47, 49

select * from cld_host;

# 자산이 속한 그룹 가져오기(SUBNET)
SELECT
    a.group_cd, e.group_nm, b.regions, cs.sub_sn, cs.sub_id
FROM
    MGR_ADMIN_IAM a
JOIN
    MGR_ADMIN_IAM_REGION b ON a.iam_sn = b.iam_sn
JOIN
    MGR_ADMIN_IAM_RC c ON c.iam_rc_type = 4 AND c.region_sn = b.region_sn
JOIN
    MGR_ADMIN_GROUP e ON e.group_cd = a.group_cd
JOIN
    CLD_SUBNET cs ON cs.sub_sn = c.iam_rc_sn
WHERE
    cs.sub_sn= 11;

# 자산이 속한 그룹 가져오기(HOST)
SELECT
    a.group_cd, e.group_nm, b.regions, cs.sub_sn, cs.sub_id
FROM
    MGR_ADMIN_IAM a
JOIN
    MGR_ADMIN_IAM_REGION b ON a.iam_sn = b.iam_sn
JOIN
    MGR_ADMIN_IAM_RC c ON c.iam_rc_type = 4 AND c.region_sn = b.region_sn
JOIN
    MGR_ADMIN_GROUP e ON e.group_cd = a.group_cd
JOIN
    CLD_SUBNET cs ON cs.sub_sn = c.iam_rc_sn
WHERE
    cs.sub_sn= 11;



select * from cld_subnet;
select * from cld_host where host_id = 'i-03a82214957696755'



# 사용자가 속한 그룹의 VPC목록 가져오기
SELECT
    a.iam_cld_type, cv.vpc_sn, cv.vpc_id
FROM
    MGR_ADMIN_IAM a
JOIN
    MGR_ADMIN_IAM_REGION b ON a.iam_sn = b.iam_sn
JOIN
    MGR_ADMIN_IAM_RC c ON c.iam_rc_type = 1 AND c.region_sn = b.region_sn
JOIN
    CLD_VPC cv ON cv.vpc_sn = c.iam_rc_sn
WHERE
    a.group_cd IN (1,2,3,4) AND a.iam_cld_type = 1
GROUP BY cv.vpc_sn;

# 로그인후에 최초 표시되는 그룹(코드, 명)
# -- initCheckedCode: group_cd
# -- initCheckedName: group_nm
SELECT
    a.group_cd, a.group_nm
FROM
    MGR_ADMIN_GROUP a
JOIN
    MGR_ADMIN_GROUP_PERMISSION b ON a.group_cd = b.group_cd
WHERE b.mgr_id = 'admin' AND a.group_depth != 1 ORDER BY a.group_depth, a.group_map ASC LIMIT 1;


# 로그인 사용자 정보 가져오기
# -- initCheckedCode: group_cd
# -- initCheckedName: group_nm
SELECT
    a.mgr_id, a.authority_name, a.mgr_password, a.group_cd, b.mgr_name, b.mgr_phone_num, b.mgr_state, b.mgr_login_op, b.mgr_email_addr, b.mgr_desc, b.login_fail_cnt, e.group_cd as initCheckedCode, e.group_nm as initCheckedName, a.work_dt
FROM
    MGR_ADMIN a
JOIN
    MGR_ADMIN_DTL b ON a.mgr_id = b.mgr_id
JOIN
    (
    SELECT c.group_cd, c.group_nm, d.mgr_id
    FROM
        MGR_ADMIN_GROUP c
    JOIN
        MGR_ADMIN_GROUP_PERMISSION d ON c.group_cd = d.group_cd
    WHERE c.group_depth != 1 ORDER BY c.group_depth, c.group_map ASC LIMIT 1
    ) AS e ON e.mgr_id = a.mgr_id
WHERE
    a.mgr_id = 'admin';


select * from MGR_ADMIN;
update mgr_admin
set authority_name = 'MSA'
where mgr_id = 'admin';

update mgr_admin
set authority_name = 'CSA'
where mgr_id = 'admin';

select * from mgr_admin_access;

select * from MGR_CHG_RC_LOG_DESC;

select * from mgr_admin_dtl;

SELECT
    a.iam_sn, b.region_sn, b.regions, d.host_id, d.host_sn, a.group_cd, d.vpc_sn, f.sub_sn
FROM
    MGR_ADMIN_IAM a
JOIN
    MGR_ADMIN_IAM_REGION b ON a.iam_sn = b.iam_sn
JOIN
    MGR_ADMIN_IAM_RC c ON c.iam_rc_type = 6 AND c.region_sn = b.region_sn
JOIN
    CLD_HOST d ON d.host_sn  = c.iam_rc_sn
JOIN
    MGR_ADMIN_GROUP e ON e.group_cd = a.group_cd
JOIN
    CLD_SUBNET f ON f.vpc_sn = d.vpc_sn
WHERE
    a.group_cd IN (2,3,3,4,1) and d.host_sn =3


SELECT
     *
FROM (
    SELECT
             ch.host_sn  as host_sn
           , tag.host_tag_value AS host_nm
           , ch.host_id
           , stat.host_status_code
           , IFNULL(icm.code_name, '없음') AS host_stat
           , COUNT(sg.sg_sn) AS sg_cnt
           , (CASE WHEN COUNT(agent.agent_id) > 0 THEN '설치' ELSE '미설치' END) AS agent_stat
    FROM cld_host ch
    INNER JOIN mgr_admin_iam_rc mair
        ON mair.iam_rc_sn = ch.host_sn
        AND mair.iam_rc_type = 6
    INNER JOIN mgr_admin_iam_region regeion
        ON regeion.region_sn  = mair.region_sn
    INNER JOIN mgr_admin_iam mai
        ON mai.iam_sn  = regeion .iam_sn
    INNER JOIN cld_host_status stat   /* host 상태 */
        ON stat.host_sn = ch.host_sn
    INNER JOIN cld_host_sg hsg /* host에 연결된 SG */
        ON hsg.host_sn = ch.host_sn
    INNER JOIN cld_sg sg
        ON sg.sg_sn  = hsg.sg_sn
        AND sg.del_flag = 0
    LEFT OUTER JOIN info_agent agent
        ON agent.host_sn = ch.host_sn
    LEFT OUTER JOIN cld_host_tag tag
        ON tag.host_sn = ch.host_sn
        AND tag.host_tag_key  = 'Name'
    INNER JOIN mgr_admin_group gr
        ON gr.group_cd = mai.group_cd
    LEFT OUTER JOIN info_code_master icm
        ON icm.code_type = 'host_status_code'
        AND icm.code_number = stat.host_status_code
    WHERE mai.group_cd IN (1,2,3,4,5)
) T20 ORDER BY group_nm ASC

select b.ni_dtl_mac from CLD_HOST_NETWORK a
JOIN CLD_NI_DTL b ON a.host_nw_private_ip_addr = b.ni_dtl_priv_ip
where host_nw_private_ip_addr = '10.12.1.43'

SELECT
		    (CASE WHEN tot.iam_cld_type = 1 THEN 'AWS'
		          WHEN tot.iam_cld_type = 2 THEN 'GCP'
		          WHEN tot.iam_cld_type = 3 THEN 'AZURE'
		          WHEN tot.iam_cld_type = 0 THEN '전체' END) as 'name'
		    , (CASE WHEN tot.iam_cld_type != 0 THEN sgTcnt
		        WHEN tot.iam_cld_type = 0 THEN sum(sgTcnt) over() END) as 'sgTcnt'
		    , (CASE WHEN tot.iam_cld_type != 0 THEN naclTcnt
		        WHEN tot.iam_cld_type = 0 THEN sum(naclTcnt) over() END) as 'naclTcnt'
		    , (CASE WHEN tot.iam_cld_type != 0 THEN hfwTcnt
		        WHEN tot.iam_cld_type = 0 THEN sum(hfwTcnt) over() END) as 'hfwTcnt'
		    , (CASE WHEN tot.iam_cld_type != 0 THEN sgTcnt + naclTcnt
		        WHEN tot.iam_cld_type = 0 THEN sum(sgTcnt + naclTcnt) over() END) as 'totTcnt'
		    , (CASE WHEN tot.iam_cld_type != 0 THEN chgAddCnt
		        WHEN tot.iam_cld_type = 0 THEN sum(chgAddCnt) over() END) as 'chgAddCnt'
		    , (CASE WHEN tot.iam_cld_type != 0 THEN chgDelCnt
		        WHEN tot.iam_cld_type = 0 THEN sum(chgDelCnt) over() END) as 'chgDelCnt'
		    , (CASE WHEN tot.iam_cld_type != 0 THEN chgModCnt
		        WHEN tot.iam_cld_type = 0 THEN sum(chgModCnt) over() END) as 'chgModCnt'
		FROM (
		    SELECT
		        rcCld.cld_type as iam_cld_type
		        , ifnull(statCld.sgTcnt, 0) sgTcnt
		        , ifnull(statCld.naclTcnt, 0) naclTcnt
		        , ifnull(statCld.hfwTcnt, 0) hfwTcnt
		        , ifnull(statCld.chgAddCnt, 0) chgAddCnt
		        , ifnull(statCld.chgDelCnt, 0) chgDelCnt
		        , ifnull(statCld.chgModCnt, 0) chgModCnt
		    FROM
		    (select
		    1 as cld_type
		    from dual
		    UNION ALL
		    select
		    2 as cld_type
		    from dual
		    UNION ALL
		    select
		    3 as cld_type
		    from dual
		    UNION ALL
		    select
		    0 as cld_type
		    from dual) as rcCld
		    LEFT JOIN (
		    SELECT
		         iamCld.iam_cld_type
		        , sum(IF (sg.del_flag = 0 , 1 , 0) ) AS sgTcnt
		        , sum(IF (nacl.del_flag = 0, 1, 0) ) AS naclTcnt
				,(
	    SELECT
			sum(if(host_sn is null, 0 ,1)) AS fwTcnt
		FROM (
		SELECT
		    b.host_sn
		FROM mgr_admin_iam_rc a
		JOIN (
		    SELECT
		          mair.region_sn
		        , mai.iam_cld_type
		    FROM mgr_admin_iam mai
		    INNER JOIN mgr_admin_iam_region mair
		    ON mair.iam_sn  = mai.iam_sn
		    WHERE mai.group_cd = 5
		) region
		ON region.region_sn = a.region_sn
		AND a.iam_rc_type = 6
		LEFT JOIN info_agent_fw_dtl b ON a.iam_rc_sn = b.host_sn AND a.iam_rc_type = 6
		group by b.host_sn
		) AS FWCNT
     ) AS hfwTcnt
		        , SUM(CASE WHEN mcrd.chg_type = 1 THEN 1 ELSE 0 END) AS chgAddCnt
		        , SUM(CASE WHEN mcrd.chg_type = 2 THEN 1 ELSE 0 END) AS chgDelCnt
		        , SUM(CASE WHEN mcrd.chg_type = 3 THEN 1 ELSE 0 END) AS chgModCnt
		        FROM
		        MGR_ADMIN_IAM_RC iamRc
		        JOIN (
		            SELECT mair.region_sn
		            , mai.iam_cld_type
		            , mag.group_cd
		            , mag.group_nm
		            FROM mgr_admin_iam mai
		            JOIN mgr_admin_iam_region mair
		            ON mair.iam_sn = mai.iam_sn
		            JOIN mgr_admin_group mag
		            ON mag.group_cd = mai.group_cd
		            WHERE mai.group_cd = 5
		        ) as iamCld ON iamCld.iam_cld_type IN (1,2,3)
		        AND iamCld.region_sn = iamRc.region_sn
		        LEFT JOIN
		        CLD_SG sg ON sg.sg_sn = iamRc.iam_rc_sn
		        AND iamRc.iam_rc_type = 5
		        LEFT JOIN
		        CLD_NACL nacl ON nacl.nacl_sn = iamRc.iam_rc_sn
		        AND iamRc.iam_rc_type = 3
		        LEFT JOIN
		        mgr_chg_rc_log_desc mcrd ON iamCld.group_nm = mcrd.group_nm
		        AND iamCld.group_cd = mcrd.group_cd
		        AND mcrd.rc_type IN (3, 5, 11)
		        AND mcrd.work_dt  > (NOW() - INTERVAL  24 HOUR )
		        UNION ALL
		        SELECT
		        0 AS iam_cld_type
		        , 0 AS naclTcnt
		        , 0 AS sgTcnt
		        , 0 AS hfwTcnt
		        , 0 AS chgAddCnt
		        , 0 AS chgDelCnt
		        , 0 AS chgModCnt
		        FROM DUAL
		) as statCld ON statCld.iam_cld_type = rcCld.cld_type) as tot

SELECT
    b.vpc_sn,
    b.work_dt,
    c.vpc_dtl_default,
    c.vpc_dtl_owner_id,
    vpc_tag_value AS tag,
    b.vpc_id
FROM MGR_ADMIN_IAM_RC a
JOIN CLD_VPC b ON a.iam_rc_sn = b.vpc_sn
JOIN CLD_VPC_DTL c ON b.vpc_sn = c.vpc_sn
JOIN MGR_ADMIN_IAM_REGION d ON a.region_sn = d.region_sn
JOIN MGR_ADMIN_IAM e ON d.iam_sn = e.iam_sn
LEFT OUTER JOIN (
     SELECT vpc_tag_value, vpc_sn, rank() OVER (PARTITION BY vpc_sn ORDER BY vpc_tag_sn asc) rk
     FROM CLD_VPC_TAG
) f ON f.vpc_sn = b.vpc_sn AND f.rk = 1
WHERE  f.vpc_tag_value like '%default%';

SELECT
    b.vpc_sn,
    b.work_dt,
    c.vpc_dtl_default,
    c.vpc_dtl_owner_id,
    b.vpc_id
FROM
    MGR_ADMIN_IAM_RC a
JOIN CLD_VPC b ON a.iam_rc_sn = b.vpc_sn
JOIN CLD_VPC_DTL c ON b.vpc_sn = c.vpc_sn
JOIN MGR_ADMIN_IAM_REGION d ON a.region_sn = d.region_sn
JOIN MGR_ADMIN_IAM e ON d.iam_sn = e.iam_sn
WHERE exists (SELECT 1 FROM CLD_VPC_TAG WHERE vpc_sn = b.vpc_sn AND vpc_tag_value like '%def%' ORDER BY vpc_tag_sn ASC LIMIT 1);

SELECT
    host_sn
FROM
    CLD_HOST b
WHERE
    exists (SELECT 1 FROM CLD_HOST_TAG WHERE host_sn = b.host_sn AND host_tag_value like '%tg%' ORDER BY host_tag_sn ASC LIMIT 1);

select * from cld_host_tag
where host_sn = 4
order by host_tag_sn ASC LIMIT 1



select * from cld_host order by work_dt desc limit 1
select * from info_agent_rc_mgr_sw_dtl;





SELECT

    	msw_dtl_sn as mswDtlSn, host_sn as hostSn, msw_dtl_mg as mswDtlMg, msw_dtl_nm as mswDtlNm,
    	msw_dtl_type as mswDtlType, msw_dtl_port as mswDtlPort, msw_dtl_cver as mswDtlCver, msw_dtl_rver as mswDtlRver,
    	msw_dtl_pver as mswDtlPver, msw_dtl_size as mswDtlSize, msw_dtl_release mswDtlRelease, msw_dtl_ins_dt as mswDtlInsDt,
    	msw_dtl_owner as msgDtlOwner, DATE_FORMAT(work_dt, '%Y-%m-%d %H:%i:%s') as workDt

    	FROM info_agent_rc_mgr_sw_dtl
    	WHERE host_sn = 8
    	ORDER BY workDt DESC LIMIT 1


SELECT
    code_type, code_number, code_name, code, code_remark, use_flag
FROM
    INFO_CODE_MASTER
WHERE
    code_type = 'cld_type' AND use_flag = 1;

INSERT INTO `INFO_CODE_MASTER` (`code_type`, `code_number`, `code_name`, `code`, `code_remark`, `use_flag`) VALUES('cld_type', 1, 'AWS', '', '', 1)
INSERT INTO `INFO_CODE_MASTER` (`code_type`, `code_number`, `code_name`, `code`, `code_remark`, `use_flag`) VALUES('cld_type', 2, 'GCP', '', '', 1)
INSERT INTO `INFO_CODE_MASTER` (`code_type`, `code_number`, `code_name`, `code`, `code_remark`, `use_flag`) VALUES('cld_type', 3, 'AZURE', '', '', 1)
INSERT INTO `INFO_CODE_MASTER` (`code_type`, `code_number`, `code_name`, `code`, `code_remark`, `use_flag`) VALUES('cld_type', 51, 'KT', '', '', 0)
INSERT INTO `INFO_CODE_MASTER` (`code_type`, `code_number`, `code_name`, `code`, `code_remark`, `use_flag`) VALUES('cld_type', 52, 'NBP', '', '', 0)
INSERT INTO `INFO_CODE_MASTER` (`code_type`, `code_number`, `code_name`, `code`, `code_remark`, `use_flag`) VALUES('cld_type', 53, '가비아', '', '', 0)
INSERT INTO `INFO_CODE_MASTER` (`code_type`, `code_number`, `code_name`, `code`, `code_remark`, `use_flag`) VALUES('cld_type', 100, 'Legacy', '', '', 1)





		SELECT
		    a.mgr_id, a.authority_name, a.mgr_password, a.group_cd, b.mgr_name, b.mgr_phone_num, b.mgr_state, b.mgr_login_op, b.mgr_email_addr, b.mgr_desc, b.login_fail_cnt, e.group_cd as initCheckedCode, e.group_nm as initCheckedName, a.work_dt, a.temp_pass_dt, a.tmp_password
		FROM
		    MGR_ADMIN a
		JOIN
		    MGR_ADMIN_DTL b ON a.mgr_id = b.mgr_id
		JOIN
		    (
		    SELECT
		    	c.group_cd, c.group_nm, d.mgr_id
		    FROM
		        MGR_ADMIN_GROUP c
		    JOIN
		        MGR_ADMIN_GROUP_PERMISSION d ON c.group_cd = d.group_cd
		    WHERE c.group_depth != 1 ORDER BY c.group_depth, c.group_map ASC
		    ) AS e ON e.mgr_id = a.mgr_id
		WHERE
		    a.mgr_id = 'api_test1' LIMIT 1

		    SELECT
		    	c.group_cd, c.group_nm, d.mgr_id
		    FROM
		        MGR_ADMIN_GROUP c
		    JOIN
		        MGR_ADMIN_GROUP_PERMISSION d ON c.group_cd = d.group_cd
		    WHERE c.group_depth != 1 ORDER BY c.group_depth, c.group_map ASC



		SELECT
		    a.mgr_id, a.authority_name, a.mgr_password, a.group_cd, b.mgr_name, b.mgr_phone_num, b.mgr_state, b.mgr_login_op, b.mgr_email_addr, b.mgr_desc, b.login_fail_cnt, a.work_dt, a.temp_pass_dt, a.tmp_password
		FROM
		    MGR_ADMIN a
		JOIN
		    MGR_ADMIN_DTL b ON a.mgr_id = b.mgr_id
		JOIN
		    (

                )
        WHERE a.mgr_id = 'viva';

select * from mgr_admin_group_permission;
select * from cld_host;
select * from MGR_ADMIN_ALARM;




SELECT
    a.mgr_id, a.authority_name, a.mgr_password, a.group_cd, b.mgr_name, b.mgr_phone_num, b.mgr_state, b.mgr_login_op, b.mgr_email_addr, b.mgr_desc, b.login_fail_cnt, a.group_cd as initCheckedCode, c.group_nm as initCheckedName, a.work_dt, a.temp_pass_dt, a.tmp_password
FROM
    MGR_ADMIN a
JOIN
    MGR_ADMIN_DTL b ON a.mgr_id = b.mgr_id
JOIN
    MGR_ADMIN_GROUP c ON c.group_cd = a.group_cd
WHERE
    a.mgr_id = 'admin' LIMIT 1

select
    *
from mgr_admin a
join mgr_admin_dtl b on a.mgr_id = b.mgr_id
where a.mgr_id = 'admin'

select * from mgr_admin;
select * from mgr_admin_group;

MSA 일때는 group_depth를 사용하지 않음.
;




SELECT
    a.mgr_id, a.authority_name, a.mgr_password, a.tmp_password,  a.group_cd, b.mgr_name, b.mgr_phone_num, b.mgr_state, b.mgr_login_op, b.mgr_email_addr, b.mgr_desc, b.login_fail_cnt, a.work_dt, a.temp_pass_dt, a.tmp_password
FROM
    MGR_ADMIN a
JOIN
    MGR_ADMIN_DTL b ON a.mgr_id = b.mgr_id
WHERE
    a.mgr_id = 'astron';




SELECT COUNT(*) AS cnt

		FROM (

		SELECT iam_rc_type AS assetType, '서버' AS assetTypeNm, iam_rc_sn AS rcSn , region_sn AS regionSn, vpc_sn AS vpcSn, cld_type AS cldType
		FROM mgr_admin_iam_rc
		JOIN cld_host ON iam_rc_sn=host_sn
		WHERE iam_rc_type = 6

		UNION ALL

		SELECT iam_rc_type AS assetType, 'NFW' AS assetTypeNm, iam_rc_sn AS rcSn , region_sn AS regionSn, vpc_sn AS vpcSn, cld_type AS cldType
		FROM mgr_admin_iam_rc
		JOIN cld_nacl ON iam_rc_sn=nacl_sn
		WHERE iam_rc_type = 3

		UNION ALL

		SELECT iam_rc_type AS assetType, 'SG' AS assetTypeNm, iam_rc_sn AS rcSn , region_sn AS regionSn, vpc_sn AS vpcSn, cld_type AS cldType
		FROM mgr_admin_iam_rc
		JOIN cld_sg ON iam_rc_sn=sg_sn
		WHERE iam_rc_type = 5

		) r
		LEFT JOIN (

		SELECT c.sg_sn AS sgSn, c.sg_id AS sgId, c.cld_type AS cldType, c.vpc_sn AS vpcSn
			, IFNULL(t.sg_tag_value, '') AS sgNm
		FROM cld_sg c
		LEFT JOIN (select t.sg_sn, t.sg_tag_value from cld_sg_tag t WHERE t.sg_tag_key='Name') t ON c.sg_sn=t.sg_sn

		) sg ON r.rcSn = sg.sgSn
		LEFT JOIN (

		SELECT c.nacl_sn AS naclSn, c.nacl_id AS naclId, c.cld_type AS cldType, c.vpc_sn AS vpcSn
			, IFNULL(t.nacl_tag_value,'') AS naclNm
		FROM cld_nacl c
		LEFT JOIN (SELECT nacl_sn, nacl_tag_value from cld_nacl_tag t WHERE t.nacl_tag_key='Name' ) t ON c.nacl_sn=t.nacl_sn

		) nacl ON r.rcSn = nacl.naclSn
		LEFT JOIN (

		SELECT
    	c.host_sn AS hostSn, c.host_id AS hostId, c.cld_type AS cldType, c.vpc_sn AS vpcSn, c.sub_sn AS subSn
		, d.host_dtl_type AS hostType
		, (SELECT host_tag_value FROM cld_host_tag t WHERE t.host_sn=c.host_sn AND t.host_tag_key='Name' ) AS hostNm
		, a.install_dt AS installDt
		, CASE WHEN !ISNULL(agent_id) THEN 1 ELSE 0 END AS agentStatus
		, CASE s.host_status_code WHEN 16 THEN 'r' ELSE 's' END AS assetStatus
		, o.agent_os_type AS osType, o.agent_os_version AS osNm
		, n.host_nw_public_ip_addr AS publicIp, n.host_nw_private_ip_addr AS privateIp

			, s.subId, s.subNm, s.az

		FROM cld_host c
		JOIN cld_host_dtl d ON c.host_sn=d.host_sn
		JOIN cld_host_network n ON n.host_sn=c.host_sn
		LEFT JOIN info_agent a ON a.host_sn=c.host_sn
		JOIN cld_host_status s ON s.host_sn=c.host_sn
		LEFT JOIN info_agent_os o ON o.host_sn=c.host_sn

		JOIN (

		SELECT c.sub_sn AS subSn, c.sub_id AS subId, c.cld_type AS cldType, c.vpc_sn as vpcSn
			, t.sub_tag_value AS subNm, d.sub_dtl_az AS az
		FROM cld_subnet c
		JOIN cld_subnet_dtl d ON c.sub_sn=d.sub_sn
		JOIN cld_subnet_tag t ON c.sub_sn=t.sub_sn
		WHERE t.sub_tag_key='Name'

		) s  ON s.subSn = c.sub_sn

		) h ON r.rcSn = h.hostSn
		JOIN (

		SELECT c.vpc_sn AS vpcSn, c.vpc_id AS vpcId, c.cld_type AS cldType
			, t.vpc_tag_value AS vpcNm
		FROM cld_vpc c
		JOIN cld_vpc_tag t ON c.vpc_sn=t.vpc_sn
		WHERE t.vpc_tag_key='Name'

		) v ON v.vpcSn = r.vpcSn
		JOIN (

		SELECT a.group_cd as groupCd, b.region_sn as regionSn, b.regions, g.group_nm as groupNm
		FROM mgr_admin_iam a
		JOIN mgr_admin_iam_region b ON a.iam_sn = b.iam_sn
		JOIN mgr_admin_group g ON g.group_cd=a.group_cd

		) g ON g.regionSn = r.regionSn

    	WHERE 1=1

				AND groupCd IN
	    			 (
	    						2
	    			 )


		SELECT
		    r.group_cd, r.group_nm, a.cld_type, r.vpc_sn, r.vpc_id,
		    a.host_sn, a.host_id, c.host_nw_private_ip_addr, c.host_nw_public_ip_addr,
		    (SELECT COUNT(1) FROM INFO_AGENT_FW_DTL afd WHERE afd.host_sn = a.host_sn AND afd.fw_dtl_direct = 0) as inbound_cnt,
		    (SELECT COUNT(1) FROM INFO_AGENT_FW_DTL afd WHERE afd.host_sn = a.host_sn AND afd.fw_dtl_direct = 1) as outbound_cnt,
		    (SELECT COUNT(1) FROM INFO_AGENT_FW_SCHEDULE afs JOIN INFO_AGENT_FW_DTL afd ON afs.fw_dtl_sn = afd.fw_dtl_sn WHERE afd.host_sn = a.host_sn) as schedule_cnt
		FROM
		    CLD_HOST a
		LEFT JOIN
		    INFO_AGENT_FW_DTL b ON a.host_sn = b.host_sn
		LEFT JOIN
		    CLD_HOST_NETWORK c ON a.host_sn = c.host_sn
		LEFT JOIN
		    (
                SELECT
                	a.iam_sn, a.group_cd, e.group_nm, b.region_sn, b.regions, cv.vpc_sn, cv.vpc_id
                FROM
                	MGR_ADMIN_IAM a
                JOIN
                	MGR_ADMIN_IAM_REGION b ON a.iam_sn = b.iam_sn
                JOIN
                    MGR_ADMIN_IAM_RC c ON c.iam_rc_type = 1 AND c.region_sn = b.region_sn
				JOIN
				    CLD_VPC cv ON cv.vpc_sn = c.iam_rc_sn
				JOIN
                    MGR_ADMIN_GROUP e ON e.group_cd = a.group_cd
		        WHERE
		            a.group_cd IN (2)
                   GROUP BY cv.vpc_sn
            ) as r ON r.vpc_sn = a.vpc_sn
    	GROUP BY r.group_cd, r.group_nm, a.cld_type, r.vpc_sn, r.vpc_id, a.host_sn, a.host_id, c.host_nw_private_ip_addr, c.host_nw_public_ip_addr
		ORDER BY a.cld_type, r.vpc_id



		SELECT
		    b.group_cd
		FROM
		    MGR_ADMIN a
		JOIN
		    MGR_ADMIN_GROUP_PERMISSION b ON a.mgr_id = b.mgr_id
		WHERE
		    a.mgr_id = 'astron'


    	SELECT group_cd as groupCd
		FROM ( SELECT * FROM mgr_admin_group ORDER BY parent_group_cd, group_cd) group_sorted,
		     (SELECT @pv := (SELECT group_cd FROM mgr_admin WHERE mgr_id='astron') ) a
		WHERE find_in_set(parent_group_cd, @pv)
			AND length(@pv := concat(@pv,',',group_cd))
		UNION ALL
		SELECT group_cd as groupCd
		FROM mgr_admin_group
		WHERE group_cd = (SELECT group_cd FROM mgr_admin WHERE mgr_id='astron');




WITH RECURSIVE parent AS (
    SELECT T1.group_cd, T1.group_nm, T1.parent_group_cd, 1 AS lvl, T1.group_map, T2.mgr_id
    FROM mgr_admin_group T1
    INNER JOIN MGR_ADMIN_GROUP_PERMISSION T2
    ON T2.group_cd = T1.group_cd
    UNION ALL
    SELECT T1.group_cd, T1.group_nm, T1.parent_group_cd, T2.lvl+1 AS lvl, T1.group_map, T2.mgr_id   FROM mgr_admin_group T1
    INNER JOIN parent T2 ON T2.group_cd = T1.parent_group_cd
)
SELECT * FROM parent
WHERE mgr_id = 'astron'
AND group_cd IN (2)
ORDER BY group_map, lvl

select * from info_agent_fw_dtl;


SELECT
    a.host_sn, UPPER(fwlog_yn) as fwlog_yn, UPPER(block_yn) as block_yn, UPPER(permit_yn) as permit_yn, reg_mgr_id, UNIX_TIMESTAMP(reg_dt) as reg_dt, mod_mgr_id, UNIX_TIMESTAMP(mod_dt) as mod_dt
FROM
    MGR_HOST_FWLOG_CONF a
WHERE
    a.host_sn = 5


SELECT
    a.host_sn, UPPER(syslog_yn) as syslog_yn, UPPER(alert_yn) as alert_yn, UPPER(critical_yn) as critical_yn, UPPER(error_yn) as error_yn, UPPER(warn_yn) as warn_yn, UPPER(notice_yn) as notice_yn, UPPER(info_yn) as info_yn, UPPER(debug_yn) as debug_yn, UPPER(etc_yn) as etc_yn, reg_mgr_id, UNIX_TIMESTAMP(reg_dt) as reg_dt, mod_mgr_id, UNIX_TIMESTAMP(mod_dt) as mod_dt
FROM
    MGR_HOST_SYSLOG_CONF a
JOIN
    INFO_AGENT b ON a.host_sn = b.host_sn
WHERE
    b.agent_id = '000000050000000100000007000000020000026100012A2C'



select
    *
from info_agent_cpu_dtl a
JOIN cld_host_cpu b on a.host_cpu_sn = b.host_cpu_sn;
where a.host_cpu_sn = 811;

select * from info_agent_cpu_dtl;

SELECT
    a.host_cpu_sn
FROM
    CLD_HOST_CPU a
JOIN
    INFO_AGENT b ON a.host_sn = b.host_sn
WHERE
    b.agent_id = "000000190000000b0000003400000005000000750001A0FE"

select * from cld_host;
select * from cld_host_cpu;
select * from cld_host_cpu_dtl;
select * from cld_host_network;


select * from info_agent_cpu_dtl;
select * from info_agent where agent_id = "000000190000000b0000003400000005000000750001A0FE"
select * from info_agent_cpu_dtl;
select * from cld_host_cpu;

select * from info_agent_mount_dtl;

select * from info_agent_nic_dtl;

select * from info_agent;
select * from cld_host;
show processlist;
INFO_AGENT_NIC_DTL



SELECT
		    a.fw_dtl_sn, b.host_sn, a.fw_dtl_nm, a.fw_dtl_rule_num, a.fw_dtl_direct, a.fw_dtl_enable, a.fw_dtl_action, a.fw_dtl_log_lv, a.fw_dtl_protocol, a.fw_dtl_port, a.fw_dtl_ip_src, a.fw_dtl_ip_dst, a.fw_dtl_schedule_flag, a.fw_dtl_desc, UNIX_TIMESTAMP(a.work_dt) as work_dt
		FROM
		    INFO_AGENT_FW_DTL a
		JOIN
		    INFO_AGENT b ON a.host_sn = b.host_sn


select * from info_agent;


INSERT INTO
            INFO_AGENT_RC_MGR_SW_DTL (host_sn, msw_dtl_nm, msw_dtl_vendor, msw_dtl_cver, msw_dtl_release, msw_dtl_size, msw_dtl_build_dt, msw_dtl_ins_dt, work_dt)
        VALUES
           	(16, ' Tools for .Net 3.5', 'Microsoft Corporation', '3.11.50727', '51103271', '13584',

           			null,

           			1589122800,

           	now())

select * from mgr_url_result;

SELECT
		    a.mgr_id, a.authority_name, a.mgr_password, a.group_cd, b.mgr_name, b.mgr_phone_num, b.mgr_state, b.mgr_login_op, b.mgr_email_addr, b.mgr_desc, b.login_fail_cnt, a.group_cd as initCheckedCode, c.group_nm as initCheckedName, a.work_dt, a.temp_pass_dt, a.tmp_password
		FROM
		    MGR_ADMIN a
		JOIN
		    MGR_ADMIN_DTL b ON a.mgr_id = b.mgr_id
		JOIN
		    MGR_ADMIN_GROUP c ON c.group_cd = a.group_cd;



SELECT COUNT(*)

    	FROM (
    		SELECT c.*, h.host_id, h.host_nm, h.vpc_id, h.vpc_nm, h.public_ip, h.private_ip, h.group_nm, h.cld_type, h.os_type, h.os_nm
    		FROM mgr_host_process_conf c
    		JOIN (

		SELECT h.host_sn, h.host_id, (SELECT ht.host_tag_value FROM cld_host_tag ht WHERE ht.host_sn=h.host_sn AND ht.host_tag_key='Name') as host_nm,
			   h.cld_type,
			   fn_get_code_nm('cld_type', h.cld_type) AS cld_nm,
			   h.vpc_sn, v.vpc_id , (SELECT vt.vpc_tag_value FROM cld_vpc_tag vt WHERE vt.vpc_sn=h.vpc_sn AND vt.vpc_tag_key='Name' ) as vpc_nm,
			   n.host_nw_public_ip_addr as public_ip, n.host_nw_private_ip_addr as private_ip,
			   s.sub_id, (SELECT vt.sub_tag_value FROM cld_subnet_tag vt WHERE vt.sub_sn=h.sub_sn AND vt.sub_tag_key='Name' ) as sub_nm,
			   sdtl.sub_dtl_az as az,
				(
					SELECT DISTINCT IFNULL(ir.regions, '')
					FROM mgr_admin_iam_region ir
					JOIN mgr_admin_iam_rc r ON ir.region_sn=r.region_sn
					WHERE r.iam_rc_type=6 AND r.iam_rc_sn=h.host_sn
				) as regions,
				o.agent_os_type as os_type, o.agent_os_version AS os_nm

			   , g.group_nm, g.group_cd

		FROM cld_host h
		JOIN cld_vpc v ON h.vpc_sn=v.vpc_sn
		JOIN cld_host_network n ON n.host_sn=h.host_sn
		JOIN cld_subnet s ON s.sub_sn=h.sub_sn
		JOIN cld_subnet_dtl sdtl ON sdtl.sub_sn = h.sub_sn
		LEFT JOIN info_agent_os o ON o.host_sn=h.host_sn

		JOIN (
			SELECT h.host_sn, i.group_cd, g.group_nm
			FROM (
				SELECT r.region_sn, r.iam_sn, r.regions, h.iam_rc_type, h.iam_rc_sn AS host_sn
				FROM mgr_admin_iam_region r
				JOIN mgr_admin_iam_rc h ON r.region_sn=h.region_sn
				WHERE h.iam_rc_type=6
			) h
			JOIN mgr_admin_iam i ON i.iam_sn=h.iam_sn
			JOIN mgr_admin_group g ON g.group_cd = i.group_cd

		WHERE 1=1

				AND h.host_sn IN
	    			 (
	    						1
	    			 ,
	    						2
	    			 ,
	    						3
	    			 ,
	    						4
	    			 ,
	    						5
	    			 ,
	    						7
	    			 ,
	    						8
	    			 ,
	    						9
	    			 ,
	    						10
	    			 ,
	    						11
	    			 ,
	    						12
	    			 ,
	    						13
	    			 ,
	    						14
	    			 ,
	    						15
	    			 ,
	    						16
	    			 ,
	    						17
	    			 ,
	    						35
	    			 ,
	    						36
	    			 ,
	    						37
	    			 ,
	    						38
	    			 ,
	    						39
	    			 ,
	    						40
	    			 ,
	    						41
	    			 ,
	    						61
	    			 )

				AND g.group_cd IN
	    			 (
	    						2
	    			 )

		) g ON g.host_sn=h.host_sn

		WHERE 1=1

				AND h.host_sn IN
	    			 (
	    						1
	    			 ,
	    						2
	    			 ,
	    						3
	    			 ,
	    						4
	    			 ,
	    						5
	    			 ,
	    						7
	    			 ,
	    						8
	    			 ,
	    						9
	    			 ,
	    						10
	    			 ,
	    						11
	    			 ,
	    						12
	    			 ,
	    						13
	    			 ,
	    						14
	    			 ,
	    						15
	    			 ,
	    						16
	    			 ,
	    						17
	    			 ,
	    						35
	    			 ,
	    						36
	    			 ,
	    						37
	    			 ,
	    						38
	    			 ,
	    						39
	    			 ,
	    						40
	    			 ,
	    						41
	    			 ,
	    						61
	    			 )

    		) h
    		ON c.host_sn=h.host_sn
    	) a
		WHERE 1=1






select
    *
from info_agent a
join cld_host b ON a.host_sn = b.host_sn
where 1=1
-- and b.host_sn = 2
and a.status_agent_dt > (NOW() - INTERVAL 15 MINUTE)




-- MySQL & MariaDB function summary

-- * INTERVAL
-- ref: https://qiita.com/azusanakano/items/f33bce0664d851a88666
SELECT NOW();
SELECT NOW() - INTERVAL  1 MICROSECOND ;
SELECT NOW() - INTERVAL  1 SECOND ;
SELECT NOW() - INTERVAL  1 MINUTE ;
SELECT NOW() - INTERVAL  1 HOUR;
SELECT NOW() - INTERVAL  1 DAY;
SELECT NOW() - INTERVAL  1 WEEK;
SELECT NOW() - INTERVAL  1 MONTH;

-- * LAST_DAY
SELECT LAST_DAY(NOW() - INTERVAL  1 MONTH )

--
show variables like '%time_zone%';

--
SELECT
   @date:=date(date_format(CURRENT_DATE(),'%Y-%m-01')) as Date
UNION ALL
SELECT
   @date:=DATE_ADD(@date, INTERVAL 1 DAY)
FROM
   mgr_chg_rc_log_desc
WHERE
   @date < last_day(CURRENT_DATE());

-- 일자별 출력 예제
-- ref: https://symfoware.blog.fc2.com/blog-entry-1713.html
select
date_format(date_add('2015-03-31', interval td.generate_series day), '%Y-%m-%d') as d
from
(
SELECT 0 generate_series FROM DUAL WHERE (@num:=1-1)*0 UNION ALL
SELECT @num:=@num+1 FROM `information_schema`.COLUMNS LIMIT 30
) as td;

select
date_format(date_add((CURRENT_DATE() - INTERVAL  1 MONTH), interval td.generate_series day), '%Y-%m-%d') as d
from
(
SELECT 0 generate_series FROM DUAL WHERE (@num:=1-1)*0 UNION ALL
SELECT @num:=@num+1 FROM `information_schema`.COLUMNS LIMIT 30
) as td;

select 0 as add_day from dual where (@num := 1 - 1) * 0
union all
select @num := @num + 1 as add_day from `information_schema`.columns limit 31

select (CURRENT_DATE() - INTERVAL  1 MONTH);

set @a = 'test';
select @a, (@a:=20) from dual;







-- @@@@@@@@@@@@
-- # 날짜별 집계
DROP TABLE `tests`;
CREATE TABLE `tests` (
  `work_dt` datetime NOT NULL,
  `cnt` bigint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
INSERT INTO `tests`
(`work_dt`, `cnt`)
VALUES ('2000-01-01',1), ('2000-01-01',2), ('2000-01-03',3), ('2000-01-03',4), ('2000-01-03',1), ('2000-01-03',1), ('2000-01-04',1), ('2000-01-04',1), ('2000-01-05',1), ('2000-01-06',1);
SELECT
   DATE_FORMAT(work_dt, '%Y-%m-%d') AS work_dt
 , COUNT(1)
FROM tests
GROUP BY DATE_FORMAT(work_dt, '%Y%m%d');

-- @@@@@@@@@@@@
-- # 연령대별 집계
-- ref: https://qiita.com/sai-san/items/8901468713cfe28adfe2
DROP TABLE `agetest`;
CREATE TABLE `agetest` (
  `type` int(1) NOT NULL,
  `cnt` bigint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
INSERT INTO `agetest`
(`type`, `cnt`)
VALUES (1,1), (2,2), (2,2), (1,1), (1,1), (3,2), (3,3), (3,1), (1,1), (1,4), (2,1), (3,1), (3,1), (2,1)

select
    a.cld_type, ifnull(b.tot,0)
from
(select
1 as cld_type
, 'AWS' as cld_nm
from dual
UNION ALL
select
2 as cld_type
, 'GCP' as cld_nm
from dual
UNION ALL
select
3 as cld_type
, 'AZURE' as cld_nm
from dual) a

LEFT JOIN
(select
1 as cld_type
, 0 as tot
from dual
UNION ALL
select
2 as cld_type
, 0 as tot
from dual) b ON b.cld_type = a.cld_type

select
    a.type,
     a.cnt
from (
select
    type,
    sum(cnt) as cnt
from agetest
group by type
) as a;
group by
a.cnt div 2

select
    case
        when cnt between 0 AND 5 THEN '0 - 5'
        when cnt between 6 AND 10 THEN '6 - 10'
        when cnt between 11 AND 15 THEN '11 - 15'
        when cnt between 16 AND 20 THEN '16 - 20'
    END
from (
select
    a.type,
     a.cnt
from (
select
    type,
    sum(cnt) as cnt
from agetest
group by type
) as a) as b;

SELECT
    CASE
        WHEN age <18 THEN 'Under 18'
        WHEN age between 18 AND 24 THEN '18-24'
        WHEN age between 25 AND 34 THEN '25-34'
        WHEN age between 35 AND 44 THEN '35-44'
    END AS 年代,
    Count(*) AS 人数
FROM
    table_name
GROUP BY 年代;


SELECT
    b.vpc_sn,
    b.work_dt,
    c.vpc_dtl_default,
    c.vpc_dtl_owner_id,
    vpc_tag_value AS tag,
    b.vpc_id
FROM MGR_ADMIN_IAM_RC a
JOIN CLD_VPC b ON a.iam_rc_sn = b.vpc_sn
JOIN CLD_VPC_DTL c ON b.vpc_sn = c.vpc_sn
JOIN MGR_ADMIN_IAM_REGION d ON a.region_sn = d.region_sn
JOIN MGR_ADMIN_IAM e ON d.iam_sn = e.iam_sn
LEFT OUTER JOIN (
     SELECT vpc_tag_value, vpc_sn, rank() OVER (PARTITION BY vpc_sn ORDER BY vpc_tag_sn asc) rk
     FROM CLD_VPC_TAG
) f ON f.vpc_sn = b.vpc_sn AND f.rk = 1
WHERE  f.vpc_tag_value like '%default%';

SELECT
    b.vpc_sn,
    b.work_dt,
    c.vpc_dtl_default,
    c.vpc_dtl_owner_id,
    b.vpc_id
FROM
    MGR_ADMIN_IAM_RC a
JOIN CLD_VPC b ON a.iam_rc_sn = b.vpc_sn
JOIN CLD_VPC_DTL c ON b.vpc_sn = c.vpc_sn
JOIN MGR_ADMIN_IAM_REGION d ON a.region_sn = d.region_sn
JOIN MGR_ADMIN_IAM e ON d.iam_sn = e.iam_sn
WHERE exists (SELECT 1 FROM CLD_VPC_TAG WHERE vpc_sn = b.vpc_sn AND vpc_tag_value like '%def%' ORDER BY vpc_tag_sn ASC LIMIT 1);


SELECT
    host_sn
FROM
    CLD_HOST b
WHERE
    exists (SELECT 1 FROM CLD_HOST_TAG WHERE host_sn = b.host_sn AND host_tag_value like '%tg%' ORDER BY host_tag_sn ASC LIMIT 1);




select * from info_agent;
select * from cld_host where host_sn = 63;
select * from info_agent_memory;


ALTER TABLE INFO_AGENT_RC_MGR_SW_DTL MODIFY msw_dtl_nm varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci     not null ;


ALTER TABLE INFO_AGENT_RC_MGR_SW_DTL MODIFY msw_dtl_nm varchar(200)     not null;
ALTER TABLE t1 MODIFY
subject VARCHAR(255)
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

info_agent_rc_mgr_sw_dtl


select *
from info_agent a
JOIN cld_host b ON a.host_sn = b.host_sn


select * from cld_host where host_id = 'i-03be2fb6be83566cd';

select *
from cld_host_network where host_nw_private_ip_addr = '192.168.218.180'
select * from mgr_scheduled;
select * from info_agent;

select * from cld_host_sg a join cld_sg b on a.sg_sn = b.sg_sn where vpc_sn = 66










		SELECT
		    cs.cld_type, cs.sg_sn, cs.sg_id, cv.vpc_sn, cv.vpc_id, r.regions, r.group_cd, r.group_nm,
		    IFNULL((SELECT sg_tag_value FROM CLD_SG_TAG WHERE sg_sn = cs.sg_sn ORDER BY sg_tag_sn ASC LIMIT 1), '') as sg_tag_value,
		    IFNULL((SELECT vpc_tag_value FROM CLD_VPC_TAG WHERE vpc_sn = cv.vpc_sn ORDER BY vpc_tag_sn ASC LIMIT 1), '') as vpc_tag_value,
		    (SELECT COUNT(1) FROM cld_sg_ingress WHERE sg_sn = cs.sg_sn) AS ingress,
		    (SELECT COUNT(1) FROM cld_sg_egress WHERE sg_sn = cs.sg_sn) AS egress,
		    csd.sg_dtl_desc, csd.sg_dtl_owner_id, cv.work_dt
		FROM
		    CLD_SG cs
		LEFT JOIN
		    CLD_SG_DTL csd ON cs.sg_sn = csd.sg_sn
		LEFT JOIN
		    CLD_VPC cv ON cs.vpc_sn = cv.vpc_sn AND cs.cld_type = cv.cld_type
		JOIN
		    (
		        SELECT
		            a.iam_sn, a.group_cd, b.region_sn, b.regions, d.vpc_sn, e.group_nm
		        FROM
		            MGR_ADMIN_IAM a
		        JOIN
		            MGR_ADMIN_IAM_REGION b ON a.iam_sn = b.iam_sn
		        JOIN
		            MGR_ADMIN_IAM_RC c ON c.iam_rc_type = 5 AND c.region_sn = b.region_sn
		        JOIN
		            CLD_SG d ON d.vpc_sn  = c.iam_rc_sn
		        JOIN
		            MGR_ADMIN_GROUP e ON e.group_cd = a.group_cd
		        WHERE
		            a.group_cd IN (2)
		        GROUP BY d.vpc_sn
		    ) as r ON r.vpc_sn = cv.vpc_sn
    	where
			cv.cld_type IN (1)
    			AND cv.vpc_id IN ('vpc-074d1703ac164dbfd')

		ORDER BY cv.vpc_id, cs.cld_type


select * from info_agent_os;
update info_agent_os set agent_os_type = 5 where agent_os_type = 3;

select * from info_agent_memory where host_sn = 77
select * from info_agent_os; where host_sn = 85
select * from info_agent where host_sn = 77;
select * from cld_host_network;


		SELECT
		    UNIX_TIMESTAMP(T20.base_day)*1000 as x,
		    IFNULL(T15.y, 0) as y
		FROM
		(
    SELECT date_format( (base - INTERVAL b*10+c DAY),'%Y%m%d')  AS base_day
	FROM
	   (SELECT date_format(NOW(), '%Y%m%d') AS base) a
	 , (SELECT 0 b
	    UNION ALL SELECT 1
	    UNION ALL SELECT 2
	    UNION ALL SELECT 3
	    UNION ALL SELECT 4
	    UNION ALL SELECT 5
	    UNION ALL SELECT 6
	    UNION ALL SELECT 7
	    UNION ALL SELECT 8
	    UNION ALL SELECT 9
	    ) b
	 , (SELECT 0 c
	    UNION ALL SELECT 1
	    UNION ALL SELECT 2
	    UNION ALL SELECT 3
	    UNION ALL SELECT 4
	    UNION ALL SELECT 5
	    UNION ALL SELECT 6
	    UNION ALL SELECT 7
	    UNION ALL SELECT 8
	    UNION ALL SELECT 9
	    ) c
	 WHERE b*10+c <  30
		) as T20
		LEFT JOIN (
		SELECT
		      work_dt as x
		    , IFNULL(SUM(case when rc_type = 3 then cnt else 0 end),0) as y
		FROM (
			SELECT
			       UNIX_TIMESTAMP(work_dt)*1000 as work_dt
			     , rc_type
			     , COUNT(1) AS cnt
			FROM MGR_CHG_RC_LOG_DESC
			WHERE group_cd IN (2,6)
			AND rc_type = 3
			AND chg_type  = 3
			AND work_dt  > (NOW() - INTERVAL 1 MONTH )
			GROUP BY work_dt
		) as T10) as T15 ON T15.x = T20.base_day









    SELECT date_format( (base - INTERVAL b*10+c DAY),'%Y%m%d')  AS base_day
	FROM
	   (SELECT date_format(NOW(), '%Y%m%d') AS base) a
	 , (SELECT 0 b
	    UNION ALL SELECT 1
	    UNION ALL SELECT 2
	    UNION ALL SELECT 3
	    UNION ALL SELECT 4
	    UNION ALL SELECT 5
	    UNION ALL SELECT 6
	    UNION ALL SELECT 7
	    UNION ALL SELECT 8
	    UNION ALL SELECT 9
	    ) b
	 , (SELECT 0 c
	    UNION ALL SELECT 1
	    UNION ALL SELECT 2
	    UNION ALL SELECT 3
	    UNION ALL SELECT 4
	    UNION ALL SELECT 5
	    UNION ALL SELECT 6
	    UNION ALL SELECT 7
	    UNION ALL SELECT 8
	    UNION ALL SELECT 9
	    ) c
	 WHERE b*10+c <![CDATA[ < ]]> 30



SELECT a.base_at, UNIX_TIMESTAMP(a.base_at)*1000 AS x, IFNULL(cnt,0) AS y
FROM (
    SELECT base_at , COUNT(*) AS cnt
    FROM (
        SELECT *, DATE_FORMAT(work_dt, '%Y-%m-%d') AS base_at
        FROM mgr_chg_rc_log_desc
        WHERE 1=1

            AND	group_cd in (2)
        AND rc_type IN (3,5,6)
        AND chg_type = 2
        AND work_dt >= ADDDATE(NOW(), INTERVAL -1 MONTH)
    ) a
    GROUP BY base_at
) a
ORDER BY a.base_at ASC



SELECT
    T20.base_day as base_at,
    UNIX_TIMESTAMP(T20.base_day)*1000 as x,
    IFNULL(T15.y, 0) as y
FROM
(
    SELECT date_format( (base - INTERVAL b*10+c DAY),'%Y%m%d')  AS base_day
    FROM
       (SELECT date_format(NOW(), '%Y%m%d') AS base) a
     , (SELECT 0 b
        UNION ALL SELECT 1
        UNION ALL SELECT 2
        UNION ALL SELECT 3
        UNION ALL SELECT 4
        UNION ALL SELECT 5
        UNION ALL SELECT 6
        UNION ALL SELECT 7
        UNION ALL SELECT 8
        UNION ALL SELECT 9
        ) b
     , (SELECT 0 c
        UNION ALL SELECT 1
        UNION ALL SELECT 2
        UNION ALL SELECT 3
        UNION ALL SELECT 4
        UNION ALL SELECT 5
        UNION ALL SELECT 6
        UNION ALL SELECT 7
        UNION ALL SELECT 8
        UNION ALL SELECT 9
        ) c
     WHERE b*10+c < 30
) as T20
LEFT JOIN (
    SELECT a.base_at AS x, IFNULL(cnt,0) AS y
    FROM (
        SELECT base_at , COUNT(*) AS cnt
        FROM (
            SELECT *, DATE_FORMAT(work_dt, '%Y%m%d') AS base_at
            FROM mgr_chg_rc_log_desc
            WHERE 1=1

                AND	group_cd in (2)
            AND rc_type IN (3,5,6)
            AND chg_type = 2
            AND work_dt >= ADDDATE(NOW(), INTERVAL -1 MONTH)
        ) a
        GROUP BY base_at
    ) a
    ORDER BY a.base_at ASC
) as T15 ON T15.x = T20.base_day order by base_at








SELECT
    T20.base_day as base_at,
    UNIX_TIMESTAMP(T20.base_day)*1000 as x,
    IFNULL(T15.y, 0) as y
FROM
(
    SELECT date_format( (base - INTERVAL b*10+c DAY),'%Y%m%d')  AS base_day
    FROM
       (SELECT date_format(NOW(), '%Y%m%d') AS base) a
     , (SELECT 0 b
        UNION ALL SELECT 1
        UNION ALL SELECT 2
        UNION ALL SELECT 3
        UNION ALL SELECT 4
        UNION ALL SELECT 5
        UNION ALL SELECT 6
        UNION ALL SELECT 7
        UNION ALL SELECT 8
        UNION ALL SELECT 9
        ) b
     , (SELECT 0 c
        UNION ALL SELECT 1
        UNION ALL SELECT 2
        UNION ALL SELECT 3
        UNION ALL SELECT 4
        UNION ALL SELECT 5
        UNION ALL SELECT 6
        UNION ALL SELECT 7
        UNION ALL SELECT 8
        UNION ALL SELECT 9
        ) c
     WHERE b*10+c < 30
) as T20
LEFT JOIN (
		SELECT a.base_at AS x, IFNULL(cnt,0) AS y
		FROM (
			SELECT base_at , COUNT(*) AS cnt
			FROM (
				SELECT *, DATE_FORMAT(work_dt, '%Y-%m-%d %H:00:00') AS base_at
				FROM mgr_chg_rc_log_desc
				WHERE 1=1
                AND	group_cd in (2)
				AND rc_type = 10
				AND chg_type = 3
				AND work_dt >= ADDDATE(NOW(), INTERVAL -1 MONTH)
			) a
			GROUP BY base_at
		) a
		ORDER BY a.base_at ASC
) as T15 ON T15.x = T20.base_day order by base_at





SELECT
    T20.base_day as base_at,
    UNIX_TIMESTAMP(T20.base_day)*1000 as x,
    IFNULL(T15.y, 0) as y
FROM
(
    SELECT date_format( (base - INTERVAL b*10+c DAY),'%Y%m%d')  AS base_day
    FROM
       (SELECT date_format(NOW(), '%Y%m%d') AS base) a
     , (SELECT 0 b
        UNION ALL SELECT 1
        UNION ALL SELECT 2
        UNION ALL SELECT 3
        UNION ALL SELECT 4
        UNION ALL SELECT 5
        UNION ALL SELECT 6
        UNION ALL SELECT 7
        UNION ALL SELECT 8
        UNION ALL SELECT 9
        ) b
     , (SELECT 0 c
        UNION ALL SELECT 1
        UNION ALL SELECT 2
        UNION ALL SELECT 3
        UNION ALL SELECT 4
        UNION ALL SELECT 5
        UNION ALL SELECT 6
        UNION ALL SELECT 7
        UNION ALL SELECT 8
        UNION ALL SELECT 9
        ) c
     WHERE b*10+c < 30
) as T20
LEFT JOIN (
    SELECT cld_type AS cldType,
        fn_get_code_nm('cld_type', cld_type) as cldNm,
        DATE_FORMAT(work_dt, '%Y%m%d') AS x,
        SUM( CASE chg_type WHEN 1 THEN 1 ELSE 0 END ) - SUM( CASE chg_type WHEN 2 THEN 1 ELSE 0 END ) AS y
    FROM mgr_chg_rc_log_desc c
    WHERE rc_type IN (3,5,6) AND work_dt >= ADDDATE(NOW(), INTERVAL -1 MONTH)
        AND chg_type IN (1,2)
        AND group_cd in (2)
    GROUP BY cld_type, DATE_FORMAT(work_dt, '%Y%m%d')
    ORDER BY cld_type, x ASC
) as T15 ON T15.x = T20.base_day order by base_at







		SELECT rc_type AS rcType,
			CASE rc_type WHEN 3 THEN 'NACL' WHEN 5 THEN 'SG' WHEN 6 THEN '호스트' ELSE '' END as rcNm,
			UNIX_TIMESTAMP(DATE_FORMAT(work_dt, '%Y-%m-%d'))*1000 AS AT,
			SUM( CASE chg_type WHEN 1 THEN 1 ELSE 0 END ) - SUM( CASE chg_type WHEN 2 THEN 1 ELSE 0 END ) AS cnt
		FROM mgr_chg_rc_log_desc c
		WHERE rc_type IN (3,5,6) AND work_dt >= DATE_FORMAT(ADDDATE(NOW(), INTERVAL -1 MONTH), '%Y-%m-%d 00:00:00')
			AND chg_type IN (1,2)

			AND	group_cd in (2)
		GROUP BY rc_type, DATE_FORMAT(work_dt, '%Y-%m-%d')
		ORDER BY rc_type, at ASC


SELECT
    T10.base_day,
    UNIX_TIMESTAMP(T10.base_day)*1000 AS AT,
    T10.rc_type,
    CASE rc_type WHEN 3 THEN 'NACL' WHEN 5 THEN 'SG' WHEN 6 THEN '호스트' ELSE '' END as rcNm,
    IFNULL(T20.cnt,0) as cnt
FROM (
         SELECT date_format((base - INTERVAL b * 10 + c DAY), '%Y%m%d') AS base_day, 3 as rc_type
         FROM (SELECT date_format(NOW(), '%Y%m%d') AS base) a
            , (SELECT 0 b
               UNION ALL
               SELECT 1
               UNION ALL
               SELECT 2
               UNION ALL
               SELECT 3
               UNION ALL
               SELECT 4
               UNION ALL
               SELECT 5
               UNION ALL
               SELECT 6
               UNION ALL
               SELECT 7
               UNION ALL
               SELECT 8
               UNION ALL
               SELECT 9
         ) b
            , (SELECT 0 c
               UNION ALL
               SELECT 1
               UNION ALL
               SELECT 2
               UNION ALL
               SELECT 3
               UNION ALL
               SELECT 4
               UNION ALL
               SELECT 5
               UNION ALL
               SELECT 6
               UNION ALL
               SELECT 7
               UNION ALL
               SELECT 8
               UNION ALL
               SELECT 9
         ) c
         WHERE b * 10 + c < 30
         UNION ALL
         SELECT date_format((base - INTERVAL b * 10 + c DAY), '%Y%m%d') AS base_day, 5 as rc_type
         FROM (SELECT date_format(NOW(), '%Y%m%d') AS base) a
            , (SELECT 0 b
               UNION ALL
               SELECT 1
               UNION ALL
               SELECT 2
               UNION ALL
               SELECT 3
               UNION ALL
               SELECT 4
               UNION ALL
               SELECT 5
               UNION ALL
               SELECT 6
               UNION ALL
               SELECT 7
               UNION ALL
               SELECT 8
               UNION ALL
               SELECT 9
         ) b
            , (SELECT 0 c
               UNION ALL
               SELECT 1
               UNION ALL
               SELECT 2
               UNION ALL
               SELECT 3
               UNION ALL
               SELECT 4
               UNION ALL
               SELECT 5
               UNION ALL
               SELECT 6
               UNION ALL
               SELECT 7
               UNION ALL
               SELECT 8
               UNION ALL
               SELECT 9
         ) c
         WHERE b * 10 + c < 30
         UNION ALL
         SELECT date_format((base - INTERVAL b * 10 + c DAY), '%Y%m%d') AS base_day, 6 as rc_type
         FROM (SELECT date_format(NOW(), '%Y%m%d') AS base) a
            , (SELECT 0 b
               UNION ALL
               SELECT 1
               UNION ALL
               SELECT 2
               UNION ALL
               SELECT 3
               UNION ALL
               SELECT 4
               UNION ALL
               SELECT 5
               UNION ALL
               SELECT 6
               UNION ALL
               SELECT 7
               UNION ALL
               SELECT 8
               UNION ALL
               SELECT 9
         ) b
            , (SELECT 0 c
               UNION ALL
               SELECT 1
               UNION ALL
               SELECT 2
               UNION ALL
               SELECT 3
               UNION ALL
               SELECT 4
               UNION ALL
               SELECT 5
               UNION ALL
               SELECT 6
               UNION ALL
               SELECT 7
               UNION ALL
               SELECT 8
               UNION ALL
               SELECT 9
         ) c
         WHERE b * 10 + c < 30
     ) as T10
LEFT JOIN (
    		SELECT rc_type AS rcType,
			CASE rc_type WHEN 3 THEN 'NACL' WHEN 5 THEN 'SG' WHEN 6 THEN '호스트' ELSE '' END as rcNm,
			DATE_FORMAT(work_dt, '%Y%m%d') AS base_day,
			SUM( CASE chg_type WHEN 1 THEN 1 ELSE 0 END ) - SUM( CASE chg_type WHEN 2 THEN 1 ELSE 0 END ) AS cnt
		FROM mgr_chg_rc_log_desc c
		WHERE rc_type IN (3,5,6) AND work_dt >= DATE_FORMAT(ADDDATE(NOW(), INTERVAL -1 MONTH), '%Y-%m-%d 00:00:00')
			AND chg_type IN (1,2)
			AND	group_cd in (2)
		GROUP BY rc_type, DATE_FORMAT(work_dt, '%Y-%m-%d')
		ORDER BY rc_type, base_day ASC
    ) as T20 ON T10.rc_type = T20.rcType AND T10.base_day = T20.base_day order by rc_type, base_day







SELECT
    T10.cldType,
    fn_get_code_nm('cld_type', T10.cldType) as cldNm,
    UNIX_TIMESTAMP(T10.base_day)*1000 AS AT,
    IFNULL(T20.cnt,0) as cnt
FROM (
         SELECT date_format((base - INTERVAL b * 10 + c DAY), '%Y%m%d') AS base_day, 1 as cldType
         FROM (SELECT date_format(NOW(), '%Y%m%d') AS base) a
            , (SELECT 0 b
               UNION ALL
               SELECT 1
               UNION ALL
               SELECT 2
               UNION ALL
               SELECT 3
               UNION ALL
               SELECT 4
               UNION ALL
               SELECT 5
               UNION ALL
               SELECT 6
               UNION ALL
               SELECT 7
               UNION ALL
               SELECT 8
               UNION ALL
               SELECT 9
         ) b
            , (SELECT 0 c
               UNION ALL
               SELECT 1
               UNION ALL
               SELECT 2
               UNION ALL
               SELECT 3
               UNION ALL
               SELECT 4
               UNION ALL
               SELECT 5
               UNION ALL
               SELECT 6
               UNION ALL
               SELECT 7
               UNION ALL
               SELECT 8
               UNION ALL
               SELECT 9
         ) c
         WHERE b * 10 + c < 30
         UNION ALL
         SELECT date_format((base - INTERVAL b * 10 + c DAY), '%Y%m%d') AS base_day, 2 as cldType
         FROM (SELECT date_format(NOW(), '%Y%m%d') AS base) a
            , (SELECT 0 b
               UNION ALL
               SELECT 1
               UNION ALL
               SELECT 2
               UNION ALL
               SELECT 3
               UNION ALL
               SELECT 4
               UNION ALL
               SELECT 5
               UNION ALL
               SELECT 6
               UNION ALL
               SELECT 7
               UNION ALL
               SELECT 8
               UNION ALL
               SELECT 9
         ) b
            , (SELECT 0 c
               UNION ALL
               SELECT 1
               UNION ALL
               SELECT 2
               UNION ALL
               SELECT 3
               UNION ALL
               SELECT 4
               UNION ALL
               SELECT 5
               UNION ALL
               SELECT 6
               UNION ALL
               SELECT 7
               UNION ALL
               SELECT 8
               UNION ALL
               SELECT 9
         ) c
         WHERE b * 10 + c < 30
         UNION ALL
         SELECT date_format((base - INTERVAL b * 10 + c DAY), '%Y%m%d') AS base_day, 3 as cldType
         FROM (SELECT date_format(NOW(), '%Y%m%d') AS base) a
            , (SELECT 0 b
               UNION ALL
               SELECT 1
               UNION ALL
               SELECT 2
               UNION ALL
               SELECT 3
               UNION ALL
               SELECT 4
               UNION ALL
               SELECT 5
               UNION ALL
               SELECT 6
               UNION ALL
               SELECT 7
               UNION ALL
               SELECT 8
               UNION ALL
               SELECT 9
         ) b
            , (SELECT 0 c
               UNION ALL
               SELECT 1
               UNION ALL
               SELECT 2
               UNION ALL
               SELECT 3
               UNION ALL
               SELECT 4
               UNION ALL
               SELECT 5
               UNION ALL
               SELECT 6
               UNION ALL
               SELECT 7
               UNION ALL
               SELECT 8
               UNION ALL
               SELECT 9
         ) c
         WHERE b * 10 + c < 30
     ) as T10
LEFT JOIN (
SELECT cld_type AS cldType,
    DATE_FORMAT(work_dt, '%Y%m%d') AS base_day,
    SUM( CASE chg_type WHEN 1 THEN 1 ELSE 0 END ) - SUM( CASE chg_type WHEN 2 THEN 1 ELSE 0 END ) AS cnt
FROM mgr_chg_rc_log_desc c
WHERE rc_type IN (3,5,6) AND work_dt >= DATE_FORMAT(ADDDATE(NOW(), INTERVAL -1 MONTH), '%Y-%m-%d 00:00:00')
    AND chg_type IN (1,2)
	AND	group_cd in (2)
GROUP BY cld_type, DATE_FORMAT(work_dt, '%Y%m%d')
ORDER BY cld_type, base_day ASC
) as T20 ON T10.cldType = T20.cldType AND T10.base_day = T20.base_day order by cldType, AT




SELECT
		    UNIX_TIMESTAMP(T10.base_day)*1000 AS AT,
		    T10.rc_type as rcType,
		    CASE rc_type WHEN 3 THEN 'NACL' WHEN 5 THEN 'SG' WHEN 6 THEN '호스트' ELSE '' END as rcNm,
		    IFNULL(T20.cnt,0) as cnt
		FROM (
		         SELECT date_format((base - INTERVAL b * 10 + c DAY), '%Y%m%d') AS base_day, 3 as rc_type
		         FROM (SELECT date_format(NOW(), '%Y%m%d') AS base) a
		            , (SELECT 0 b
		               UNION ALL
		               SELECT 1
		               UNION ALL
		               SELECT 2
		               UNION ALL
		               SELECT 3
		               UNION ALL
		               SELECT 4
		               UNION ALL
		               SELECT 5
		               UNION ALL
		               SELECT 6
		               UNION ALL
		               SELECT 7
		               UNION ALL
		               SELECT 8
		               UNION ALL
		               SELECT 9
		         ) b
		            , (SELECT 0 c
		               UNION ALL
		               SELECT 1
		               UNION ALL
		               SELECT 2
		               UNION ALL
		               SELECT 3
		               UNION ALL
		               SELECT 4
		               UNION ALL
		               SELECT 5
		               UNION ALL
		               SELECT 6
		               UNION ALL
		               SELECT 7
		               UNION ALL
		               SELECT 8
		               UNION ALL
		               SELECT 9
		         ) c
		         WHERE b * 10 + c < 30
		         UNION ALL
		         SELECT date_format((base - INTERVAL b * 10 + c DAY), '%Y%m%d') AS base_day, 5 as rc_type
		         FROM (SELECT date_format(NOW(), '%Y%m%d') AS base) a
		            , (SELECT 0 b
		               UNION ALL
		               SELECT 1
		               UNION ALL
		               SELECT 2
		               UNION ALL
		               SELECT 3
		               UNION ALL
		               SELECT 4
		               UNION ALL
		               SELECT 5
		               UNION ALL
		               SELECT 6
		               UNION ALL
		               SELECT 7
		               UNION ALL
		               SELECT 8
		               UNION ALL
		               SELECT 9
		         ) b
		            , (SELECT 0 c
		               UNION ALL
		               SELECT 1
		               UNION ALL
		               SELECT 2
		               UNION ALL
		               SELECT 3
		               UNION ALL
		               SELECT 4
		               UNION ALL
		               SELECT 5
		               UNION ALL
		               SELECT 6
		               UNION ALL
		               SELECT 7
		               UNION ALL
		               SELECT 8
		               UNION ALL
		               SELECT 9
		         ) c
		         WHERE b * 10 + c < 30
		         UNION ALL
		         SELECT date_format((base - INTERVAL b * 10 + c DAY), '%Y%m%d') AS base_day, 6 as rc_type
		         FROM (SELECT date_format(NOW(), '%Y%m%d') AS base) a
		            , (SELECT 0 b
		               UNION ALL
		               SELECT 1
		               UNION ALL
		               SELECT 2
		               UNION ALL
		               SELECT 3
		               UNION ALL
		               SELECT 4
		               UNION ALL
		               SELECT 5
		               UNION ALL
		               SELECT 6
		               UNION ALL
		               SELECT 7
		               UNION ALL
		               SELECT 8
		               UNION ALL
		               SELECT 9
		         ) b
		            , (SELECT 0 c
		               UNION ALL
		               SELECT 1
		               UNION ALL
		               SELECT 2
		               UNION ALL
		               SELECT 3
		               UNION ALL
		               SELECT 4
		               UNION ALL
		               SELECT 5
		               UNION ALL
		               SELECT 6
		               UNION ALL
		               SELECT 7
		               UNION ALL
		               SELECT 8
		               UNION ALL
		               SELECT 9
		         ) c
		         WHERE b * 10 + c < 30
		     ) as T10
		LEFT JOIN (
    		SELECT rc_type AS rcType,
				CASE rc_type WHEN 3 THEN 'NACL' WHEN 5 THEN 'SG' WHEN 6 THEN '호스트' ELSE '' END as rcNm,
				DATE_FORMAT(work_dt, '%Y%m%d') AS base_day,
				SUM( CASE chg_type WHEN 1 THEN 1 ELSE 0 END ) - SUM( CASE chg_type WHEN 2 THEN 1 ELSE 0 END ) AS cnt
			FROM mgr_chg_rc_log_desc c
			WHERE rc_type IN (3,5,6) AND work_dt >= DATE_FORMAT(ADDDATE(NOW(), INTERVAL -1 MONTH), '%Y-%m-%d 00:00:00')
				AND chg_type IN (1,2)
	AND	group_cd in (2)
			GROUP BY rc_type, DATE_FORMAT(work_dt, '%Y-%m-%d')
			ORDER BY rc_type, base_day ASC
	    ) as T20 ON T10.rc_type = T20.rcType AND T10.base_day = T20.base_day order by rcType, AT

select * from info_agent;
select * from info_host_chg_hour_stat where work_dt > '2020-07-09';





	    SELECT hostSn
	    FROM (
	    	SELECT c.host_sn AS hostSn, IFNULL(h.by_host, 'N') AS by_host
	    	FROM (
	    		SELECT distinct host_sn
	    		FROM (
                    SELECT iam_rc_sn AS host_sn, r.group_cd
                    FROM mgr_admin_iam_rc rc
                    JOIN (
                        SELECT r.region_sn, i.group_cd
                        FROM mgr_admin_iam_region r
                        JOIN mgr_admin_iam i
                        ON r.iam_sn = i.iam_sn
                    ) r
                    ON rc.region_sn = r.region_sn
                    WHERE iam_rc_type=6
					AND r.group_cd IN(2)
	    		) a
	    	) c
	    	LEFT JOIN mgr_host_rc_conf h ON c.host_sn = h.host_sn
	    ) a
	    WHERE a.by_host != 'Y';



select * from mgr_host_rc_conf;
select * from info_agent;


select * from info_agent_os;

select now() from dual;

select UTC_TIMESTAMP from dual;


select * from info_agent;




select * from mgr_host_integrity_policy;

*71 : 192.168.218.184
*85 : 192.168.218.180
77 : 192.168.218.181
81 : 192.168.218.183
67 : 192.168.218.182
86 : 192.168.218.185


show variables like '%time_zone%';



		SELECT
		    cld_type, rc_id, rc_tag_value, vpc_id, vpc_tag_value, group_cd, group_nm,
		    CASE action_type WHEN 1 THEN 'astron' WHEN 2 THEN 'console' ELSE '' END as action_type,
		    rc_type, regions, rc_chg_cnt,
		    CASE chg_type WHEN 1 THEN '생성'  WHEN 2 THEN '삭제' WHEN 3 THEN '변경' ELSE '' END as chg_type,
		    chg_desc, DATE_FORMAT(work_dt, '%Y-%m-%d %H:%i:%s') AS work_dt
		FROM
			mgr_chg_rc_log_desc
		WHERE
			group_cd IN (2)
		AND rc_type IN (3, 5, 11)
		AND chg_type  IN (1,2,3)
		AND work_dt  > (NOW() - INTERVAL 24 HOUR )


select * from info_agent;




         SELECT
		       ch.host_sn
		     , chd.host_tag_value AS host_nm
		     , ch.host_id
		     , rg.group_nm
		 FROM cld_host ch
		 INNER JOIN mgr_admin_iam_rc rc
		  ON rc.iam_rc_sn = ch.host_sn
		 INNER JOIN (
		     SELECT
		           mair.region_sn
		         , mai.iam_cld_type
		         , mai.group_cd
		         , mag.group_nm
		     FROM mgr_admin_iam mai
		     INNER JOIN mgr_admin_group mag
		        ON mag.group_cd = mai.group_cd
		     INNER JOIN mgr_admin_iam_region mair
		         ON mair.iam_sn  = mai.iam_sn
		     WHERE 1 = 1

		        AND mai.group_cd IN (2,6)
		 ) rg
		 ON rc.region_sn = rg.region_sn
		 AND rc.iam_rc_type = 6  /* 6: host */
		 LEFT OUTER JOIN (
                SELECT host_sn,  GROUP_CONCAT(host_tag_value ORDER BY host_tag_sn ASC LIMIT 1) AS host_tag_value
                FROM CLD_HOST_TAG
                WHERE host_tag_key = 'Name'   /* NAME : host명 tag key */
                GROUP BY host_sn  ) chd
         ON chd.host_sn = ch.host_sn


select * from info_agent;
select * from info_host_chg_hour_stat where host_sn IN (75,67,85,83,81,107,86,77,71) and hfw_deny_cnt > 0 order by stat_dtm desc



SELECT
    a.mgr_id, a.authority_name, a.mgr_password, a.group_cd, b.mgr_name, b.mgr_phone_num, b.mgr_state, b.mgr_login_op, b.mgr_email_addr, b.mgr_desc, b.login_fail_cnt, e.group_cd as initCheckedCode, e.group_nm as initCheckedName, a.work_dt, a.temp_pass_dt, a.tmp_password
FROM
    MGR_ADMIN a
JOIN
    MGR_ADMIN_DTL b ON a.mgr_id = b.mgr_id
JOIN
    (
    SELECT
        c.group_cd, c.group_nm, d.mgr_id
    FROM
        MGR_ADMIN_GROUP c
    JOIN
        MGR_ADMIN_GROUP_PERMISSION d ON c.group_cd = d.group_cd
    WHERE c.group_depth != 1 ORDER BY c.group_depth, c.group_map ASC
    ) AS e ON e.mgr_id = a.mgr_id
WHERE
    a.mgr_id = 'security'



select * from mgr_chg_rc_log_desc order by work_dt desc



		SELECT
		    a.group_cd, e.group_nm, b.regions, cn.nacl_sn
		FROM
		    MGR_ADMIN_IAM a
		JOIN
		    MGR_ADMIN_IAM_REGION b ON a.iam_sn = b.iam_sn
		JOIN
		    MGR_ADMIN_IAM_RC c ON c.iam_rc_type = 3 AND c.region_sn = b.region_sn
		JOIN
		    MGR_ADMIN_GROUP e ON e.group_cd = a.group_cd
		JOIN
		    CLD_NACL cn ON cn.nacl_sn = c.iam_rc_sn
		WHERE
		    cn.nacl_sn = 87


        SELECT
            a.host_id, b.vpc_id, c.host_dtl_type, d.sub_id, e.host_nw_public_ip_addr, e.host_nw_private_ip_addr, a.cld_type,
            IFNULL((SELECT host_tag_value FROM CLD_HOST_TAG WHERE host_sn = a.host_sn ORDER BY host_tag_sn ASC LIMIT 1), '') as host_tag_value,
            IFNULL((SELECT sub_tag_value FROM CLD_SUBNET_TAG WHERE sub_sn = a.sub_sn ORDER BY sub_tag_sn ASC LIMIT 1), '') as sub_tag_value,
            IFNULL((SELECT vpc_tag_value FROM CLD_VPC_TAG WHERE vpc_sn = a.vpc_sn ORDER BY vpc_tag_sn ASC LIMIT 1), '') as vpc_tag_value
        FROM
            CLD_HOST a
        LEFT JOIN
        	CLD_VPC b ON a.vpc_sn = b.vpc_sn
        JOIN
        	CLD_HOST_DTL c ON a.host_sn = c.host_sn
        LEFT JOIN
        	CLD_SUBNET d ON a.sub_sn = d.sub_sn
        JOIN
        	CLD_HOST_NETWORK e ON a.host_sn = e.host_sn
        WHERE
			a.host_sn = #{host_sn}



		SELECT
		    cv.vpc_id, cn.vpc_sn,cn.nacl_id, cn.nacl_sn,
		    IFNULL((SELECT vpc_tag_value FROM CLD_VPC_TAG WHERE vpc_sn = cv.vpc_sn ORDER BY vpc_tag_sn ASC LIMIT 1), '') as vpc_tag_value,
		    IFNULL((SELECT nacl_tag_value FROM CLD_NACL_TAG WHERE nacl_sn = cn.nacl_sn ORDER BY nacl_tag_sn ASC LIMIT 1), '') as nacl_tag_value,
		    cn.work_dt
		FROM
		    CLD_NACL cn
		JOIN
		    CLD_NACL_DTL cnd ON cn.nacl_sn = cnd.nacl_sn
		JOIN
		    CLD_VPC cv ON cn.vpc_sn = cv.vpc_sn
		WHERE 1=1
		        AND cn.nacl_sn = 87

select * from info_agent_rc_mgr_sw_dtl;

select * from cld_nacl_entries where nacl_sn = 15402

select * from cld_nacl where nacl_id = 'acl-091e455b76dcd0c96'

select * from cld_nacl_entries;

select * from info_agent;




SELECT
    distinct ch.host_sn,
	IFNULL((SELECT host_tag_value FROM CLD_HOST_TAG WHERE host_sn = ch.host_sn ORDER BY host_tag_sn ASC LIMIT 1), '') as host_tag_value,
    ch.host_id, cv.vpc_sn, ch.sub_sn, ch.cld_type, chn.host_nw_private_ip_addr, cnd.ni_dtl_mac, b.regions, cv.vpc_id
FROM
    MGR_ADMIN_IAM a
JOIN
    MGR_ADMIN_IAM_REGION b ON a.iam_sn = b.iam_sn
JOIN
    MGR_ADMIN_IAM_RC c ON c.iam_rc_type = 6 AND c.region_sn = b.region_sn
JOIN
    MGR_ADMIN_GROUP e ON e.group_cd = a.group_cd
JOIN
    CLD_HOST ch ON ch.host_sn = c.iam_rc_sn
LEFT JOIN
    CLD_VPC cv ON ch.vpc_sn = cv.vpc_sn
LEFT JOIN
    CLD_HOST_NETWORK chn ON ch.host_sn = chn.host_sn
LEFT JOIN
    CLD_NI_DTL cnd ON chn.host_nw_private_ip_addr = cnd.ni_dtl_priv_ip
WHERE
    ch.host_sn in (67,71,75,77,81,83,85,86,114,115)
order by ch.host_sn



select * from cld_host;





show variables like '%time_zone%';

DROP TABLE IF EXISTS `testtable`;
CREATE TABLE `testtable`
(
    `date_timestamp` TIMESTAMP NOT NULL,
    `date_datetime`  DATETIME  NOT NULL
)ENGINE = InnoDB;


SELECT @@GLOBAL.time_zone, @@SESSION.time_zone;

show variables like '%time_zone%';
SET time_zone = 'SYSTEM';
SET time_zone = 'Asia/Tokyo';
select * from testtable;
insert into testtable values(now(), now());
insert into testtable values(now(), UTC_TIMESTAMP());
insert into testtable values(UTC_TIMESTAMP(), now());
insert into testtable values(from_unixtime(1234567), UTC_TIMESTAMP());

