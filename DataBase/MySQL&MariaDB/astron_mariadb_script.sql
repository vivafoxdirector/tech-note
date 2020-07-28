CREATE DATABASE astron;
USE `astron`;

DROP TABLE IF EXISTS `INFO_AGENT`;			-- 에이전트 정보 테이블
CREATE TABLE `INFO_AGENT` (
  `agent_id` VARCHAR(80) NOT NULL,			-- 에이전트 고유 번호
  `host_sn` BIGINT(20) UNSIGNED NOT NULL, 				-- 연결 호스트 sn
  `group_cd` BIGINT(20) UNSIGNED NOT NULL,				-- 조직 코드 번호
  `version` VARCHAR(100) DEFAULT NULL,		-- 에이전트 버전
  `agent_ip` VARCHAR(20) DEFAULT NULL, 		-- 에이전트 아이피
  `cyper_suite_id` VARCHAR(100) DEFAULT NULL,	-- 암호화 아이디?
  `lic_id` VARCHAR(100) DEFAULT NULL,		-- 라이선스 아이디
  `lic_type` INT(11) NOT NULL, 				-- 라이선스 타입
  `lic_cnt` INT(11) NOT NULL, 				-- 라이선스 갯수
  `install_dt` DATETIME DEFAULT NULL,		-- 에이전트 설치 일시
  `agent_dt` DATETIME DEFAULT NULL,			-- 에이전트 시간

  -- 에이전트는 4개모듈(무결성,방화벽,모니터링, 로그)이 동작한다. 각 모듈의 동작(설정) 여부와 정상동작 여부를 알 수 있어야 한다. TODO: 설정여부는 향후 UI에 추가될 예정(스키마가 변경될수도있음)
  -- `agent_enable` INT(1) NOT NULL DEFAULT 1,	-- 에이전트 설정 여부 (동작여부라고 보면 된다. 1: enable, 2: disable)
  `status_agent_dt` DATETIME DEFAULT NULL,		-- 에이전트 상태 시간 (15분전이면 '오류', 이내이면 '정상', 비어있으면 '미설치')

  -- `intm_enable` INT(1) NOT NULL DEFAULT 1,	-- 무결성모듈 설정 여부 (동작여부라고 보면 된다. 1: enable, 2: disable)
  `status_integrity_dt` DATETIME DEFAULT NULL,	-- 무결성모듈 상태 시간 (15분전이면 '오류', 이내이면 '정상', 비어있으면 '미설치')

  -- `hfwm_enable` INT(1) NOT NULL DEFAULT 1,	-- 방화벽모듈 설정 여부 (동작여부라고 보면 된다. 1: enable, 2: disable)
  `status_hfw_dt` DATETIME DEFAULT NULL,	-- 방화벽모듈 상태 시간 (15분전이면 '오류', 이내이면 '정상', 비어있으면 '미설치')

  -- `monm_enable` INT(1) NOT NULL DEFAULT 1,	-- 모니터링모듈 설정 여부 (동작여부라고 보면 된다. 1: enable, 2: disable)
  `status_monit_dt` DATETIME DEFAULT NULL,	-- 모니터링모듈 상태 시간 (15분전이면 '오류', 이내이면 '정상', 비어있으면 '미설치')

  -- `logm_enable` INT(1) NOT NULL DEFAULT 1,	-- 로그모듈 설정 여부 (동작여부라고 보면 된다. 1: enable, 2: disable)
  `status_log_dt` DATETIME DEFAULT NULL,	-- 로그모듈 상태 시간 (15분전이면 '오류', 이내이면 '정상', 비어있으면 '미설치')
  `unmanaged_flag` INT(1) UNSIGNED NOT NULL DEFAULT 0, -- 0. 정상, 1.미관리 에이전트
  `work_dt` DATETIME DEFAULT NULL,			-- 데이터 생성 일시
  `del_flag` INT(1) NOT NULL,				-- 삭제 여부
  primary key(`agent_id`),
  INDEX PK_INDEX(`agent_id`),
  UNIQUE KEY `admin_unique` (`host_sn`),
  INDEX HOST_INDEX(`host_sn`)
)ENGINE=INNODB DEFAULT CHARSET=UTF8;

DROP TABLE IF EXISTS `INFO_AGENT_NOTICE`;			-- 에이전트 명령 전송 목록 테이블
CREATE TABLE `INFO_AGENT_NOTICE` (
  `agent_id` VARCHAR(80) NOT NULL,			-- 에이전트 아이디
  `host_sn` BIGINT(20) UNSIGNED NOT NULL, 				-- 연결 호스트 sn
  `group_cd` BIGINT(20) UNSIGNED NOT NULL,				-- 에이전트 그룹 번호
  `agent_ip` VARCHAR(20) DEFAULT NULL, 		-- 에이전트 아이피
  `host_id` VARCHAR(150) NOT NULL, 			-- 인스턴스 아이디
  `notice_type` INT(11) NOT NULL,			-- 전달 타입 : 1.에이전트 삭제, 2.미관리 자산 등록
  `try_cnt` INT(11) NOT NULL DEFAULT 0,		-- 전송 시도 횟수
  `work_dt` DATETIME DEFAULT NULL,			-- 데이터 생성 일시
  primary key(`agent_id`, `host_sn`, `notice_type`),
  INDEX PK_INDEX(`agent_id`),
  INDEX HOST_INDEX(`host_sn`)
)ENGINE=INNODB DEFAULT CHARSET=UTF8;

DROP TABLE IF EXISTS `INFO_UNSIGNED_AGENT`;	-- 미인증 에이전트 정보 테이블
CREATE TABLE `INFO_UNSIGNED_AGENT` (
  `ni_dtl_mac` VARCHAR(50) NOT NULL, 		-- MAC 주소
  `version` VARCHAR(100) DEFAULT NULL,		-- 에이전트 버전
  `cyper_suite_id` VARCHAR(100) DEFAULT NULL,	-- 암호화 아이디?
  `lic_id` VARCHAR(100) DEFAULT NULL,		-- 라이선스 아이디
  `host_nw_private_ip_addr` VARCHAR(20) DEFAULT NULL, -- 호스트 프라이빗 아이피
  `lic_type` INT(11) NOT NULL, 				-- 라이선스 타입
  `lic_cnt` INT(11) NOT NULL, 				-- 라이선스 갯수
  `agent_dt` DATETIME DEFAULT NULL,			-- 에이전트 시간
  `sub_dtl_cidr` VARCHAR(20) DEFAULT NULL, 	-- Subnet CIDR
  `sync_retry` INT DEFAULT 0, 				-- 싱크 리트라이 카운트
  `work_dt` DATETIME DEFAULT NULL,			-- 데이터 생성 일시
  primary key(`ni_dtl_mac`),
  INDEX PK_INDEX(`ni_dtl_mac`),
  UNIQUE KEY `admin_unique` (`ni_dtl_mac`, `host_nw_private_ip_addr`)
)ENGINE=INNODB DEFAULT CHARSET=UTF8;

DROP TABLE IF EXISTS `INFO_AGENT_LICENSE`;	-- 에이전트 정보 테이블
CREATE TABLE `INFO_AGENT_LICENSE` (
  `lic_id` VARCHAR(64) NOT NULL,					-- 라이선스 아이디
  `guid` VARCHAR(64) NOT NULL,						-- 에이전트 고유 번호
  `serial` VARCHAR(64) NOT NULL,					-- 제품 일련 번호
  `issuer` VARCHAR(64) NOT NULL,					-- 라이선스 발급자
  `issue_dt` DATETIME DEFAULT NULL,					-- 발급일
  `sign_code` VARCHAR(64) NOT NULL,					-- 라이선스 파일 인증 서명
  `lic_type` INT(1) NOT NULL,						-- 라이선스 타입
  `lic_cnt` INT(11) NOT NULL,						-- 라이선스 갯 수
  `borrow` VARCHAR(64) DEFAULT NULL,				-- 라이선스 대여시간(분)
  `lic_start_dt` DATETIME DEFAULT NULL,				-- license 시작일
  `lic_end_dt` DATETIME DEFAULT NULL,				-- license 종료일
  `fw` INT(1) NOT NULL DEFAULT 0,					-- 호스트방화벽 			사용 유무 | 0: 사용안함 1: 사용함
  `integrity` INT(1) NOT NULL DEFAULT 0,			-- 무결성 				사용 유무 | 0: 사용안함 1: 사용함
  `tracking` INT(1) NOT NULL DEFAULT 0,				-- 감사 프로세스 			사용 유무 | 0: 사용안함 1: 사용함
  `iam` INT(1) NOT NULL DEFAULT 0,					-- 계정 관리 				사용 유무 | 0: 사용안함 1: 사용함
  `av` INT(1) NOT NULL DEFAULT 0,					-- 안티바이러스 			사용 유무 | 0: 사용안함 1: 사용함
  `ids` INT(1) NOT NULL DEFAULT 0,					-- IDS 					사용 유무 | 0: 사용안함 1: 사용함
  `info` INT(1) NOT NULL DEFAULT 0,					-- 자원 					사용 유무 | 0: 사용안함 1: 사용함
  `mon` INT(1) NOT NULL DEFAULT 0,					-- 모니터링 				사용 유무 | 0: 사용안함 1: 사용함
  `work_dt` DATETIME DEFAULT NULL,					-- 데이터 생성 일시
  primary key(`lic_id`, `guid`)
)ENGINE=INNODB DEFAULT CHARSET=UTF8;

DROP TABLE IF EXISTS `MGR_LICENSE`;	-- 서버 라이선스 테이블
CREATE TABLE `MGR_LICENSE` (
  `spcode` VARCHAR(64) NOT NULL,			-- 서버 고유 번호
  `company` VARCHAR(64) NOT NULL,			-- 회사명
  `lic_type` INT(1) NOT NULL,				-- license type | 0: 데모  1:정식
  `server_cnt` INT(11) NOT NULL,			-- server수
  `client_cnt` INT(11) NOT NULL,			-- client수
  `rc_cnt` VARCHAR(20) NOT NULL,			-- 자산 제한 (ex: 2000대)
  `aws` INT(1) NOT NULL DEFAULT 0,			-- aws 사용 유무 | 0: 사용안함 1: 사용함
  `gcp` INT(1) NOT NULL DEFAULT 0,			-- gcp 사용 유무 | 0: 사용안함 1: 사용함
  `azure` INT(1) NOT NULL DEFAULT 0,		-- azure 사용 유무 | 0: 사용안함 1: 사용함
  `lic_start_dt` DATETIME DEFAULT NULL,		-- license 시작일
  `lic_end_dt` DATETIME DEFAULT NULL,		-- license 종료일
  `reg_dt` DATETIME DEFAULT NULL,			-- 생성일
  `hash_key` VARCHAR(255) DEFAULT NULL, 	-- hash-key | (hash 종류 : sha-256) 인증 및 라이선스 변조 방지
  `work_dt` DATETIME DEFAULT NULL,			-- 갱신일
  `activation_state` INT(1) DEFAULT 0, 		-- 라이선스 활성화 유무 (개발용)
  primary key(`spcode`)
)ENGINE=INNODB DEFAULT CHARSET=UTF8;

DROP TABLE IF EXISTS `MGR_ADMIN`;		-- 관리자 리스트 테이블
CREATE TABLE `MGR_ADMIN` (
  `mgr_id` VARCHAR(50) NOT NULL,				-- 관리 콘솔 관리자 아이디 (사용자 아이디와 다름, 에이전트 설치 후 사용자 인증해야 관리 콘솔 접근 가능)
  `mgr_password` VARCHAR(65) NOT NULL,			-- 관리 콘솔 관리자 비밀번호
  `tmp_password` VARCHAR(65) NULL,			-- 관리 콘솔 관리자 임시 비밀번호 (갱신됨 -
  `authority_name` VARCHAR(20) NOT NULL,				-- 관리자 권한 0.MSA, 1.CSA, 2.A, 3.U
  `group_cd` BIGINT(20) UNSIGNED NOT NULL,			-- 관리 콘솔 관리자 관리 그룹 코드 (소속그룹임.)
  `temp_pass_dt` DATETIME DEFAULT NULL,				-- 임시비밀번호 발급 일시
  `work_dt` DATETIME DEFAULT NULL,				-- 데이터 생성 일시
  PRIMARY KEY (`mgr_id`),
  UNIQUE KEY `admin_unique` (`mgr_password`, `group_cd`),
  INDEX PK_INDEX(`mgr_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
INSERT INTO `MGR_ADMIN` (`mgr_id`, `mgr_password`, `authority_name`, `group_cd`, `work_dt`) VALUES('admin', '$2a$10$2nhbEcUhTZwDpuHz1FeFqOHMKpDiTX//teJk6LooxyDhCFlLjL76a', 'MSA', 1, now());

DROP TABLE IF EXISTS `MGR_ADMIN_DTL`;		-- 관리자 상세 정보 테이블
CREATE TABLE `MGR_ADMIN_DTL` (
  `mgr_id` VARCHAR(50) NOT NULL,					-- 관리 콘솔 관리자 아이디
  `mgr_name` VARCHAR(50) NOT NULL,					-- 관리 콘솔 관리자 이름
  `mgr_phone_num` VARCHAR(20) DEFAULT NULL,				-- 관리 콘솔 관리자 핸드폰 전화번호
  `mgr_state` INT(1) NOT NULL DEFAULT 0,			-- 관리 콘솔 관리자 상태 0 : Disable(잠금), 1 : Enable
  `mgr_login_op` INT(1) NOT NULL DEFAULT 0,			-- 관리 콘솔 관리자 중복 로그인 0:금지, 1: 허용
  `mgr_email_addr` VARCHAR(50) NOT NULL DEFAULT '',		-- 관리 콘솔 관리자 이메일
  `mgr_desc` VARCHAR(80) DEFAULT NULL,					-- 설명
  `login_fail_cnt` INT DEFAULT 0,			-- 관리 콘솔 로그인 실패 건수
  `login_lock_time` DATETIME NULL,				-- 관리 콘솔 로그인 Lock 시간
  `login_time` DATETIME NULL,				-- 관리 콘솔 최종 로그인 시간
  `last_pw_change_date`  DATETIME DEFAULT NULL,				-- 관리 콘솔 비밀번호 최종 변경 일자
  `work_dt` DATETIME DEFAULT NULL,					-- 데이터 생성 일시
  PRIMARY KEY (`mgr_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
INSERT INTO `MGR_ADMIN_DTL` (`mgr_id`, `mgr_name`, `mgr_phone_num`, `mgr_state`, `mgr_login_op`, `mgr_email_addr`, `mgr_desc`, `login_fail_cnt`, `work_dt`)
VALUES('admin', 'admin', 'admin', 1, 1, 'admin', 'admin', 0, now());

DROP TABLE IF EXISTS `MGR_ADMIN_ALARM`;			-- 관리자 알람 설정 테이블
CREATE TABLE `MGR_ADMIN_ALARM` (
  `mgr_id` VARCHAR(50) NOT NULL,				-- 관리자 아이디
  `email_use` INT(1) DEFAULT 0,					-- 알람 0:사용 안함, 1: E-mail
  `email_week` VARCHAR(14) DEFAULT NULL, 		-- 이메일 수신 요일 0. 일요일, 1.월요일, 2.화요일, 3.수요일, 4.목요일, 5.금요일, 6. 토요일 (구분값 ',' ex: 월,수만 적용 1,3)
  `email_to_hour` INT(11) DEFAULT 0,			-- 이메일 수신 시간 to ~ 시
  `email_to_min` INT(11) DEFAULT 0,				-- 이메일 수신 시간 to ~ 분
  `email_from_hour` INT(11) DEFAULT 0,			-- 이메일 수신 시간 from ~ 시
  `email_from_min` INT(11) DEFAULT 0,			-- 이메일 수신 시간 from ~ 분
  `mon_use` INT(1) DEFAULT 0,					-- 알람 0:사용 안함, 1: 화면
  `mon_caution_sound` INT(1) DEFAULT 0,			-- 주의 알람 소리
  `mon_danger_sound` INT(1) DEFAULT 0,			-- 위험 알람 소리
  `mon_default_sound` INT(1) DEFAULT 0,			-- 기능 알람 소리
  `mon_resource` INT(1) DEFAULT 0, 				-- 모니터링 실시간 알람 0:사용 안함, 1:Resource
  `mon_network` INT(1) DEFAULT 0, 				-- 모니터링 실시간 알람 0:사용 안함, 1:Network
  `mon_process` INT(1) DEFAULT 0, 				-- 모니터링 실시간 알람 0:사용 안함, 1:Process
  `mon_port` INT(1) DEFAULT 0, 					-- 모니터링 실시간 알람 0:사용 안함, 1:Port
  `mon_url` INT(1) DEFAULT 0, 					-- 모니터링 실시간 알람 0:사용 안함, 1:Url
  `mon_ping` INT(1) DEFAULT 0, 					-- 모니터링 실시간 알람 0:사용 안함, 1:Ping
  `alarm_same_use` INT(1) DEFAULT 0,			-- 동일 알람 0:미수신, 1: 수신
  `alarm_same_interval` INT(11) DEFAULT 0,		-- 동일 알람 간격 분단위(5,10,20,30,60,90,120,180,360,720,1440)
  `alarm_interval` INT(11) DEFAULT 10,			-- 기능 묶음 알림 간격 5분단위(5~60)
  `asset_add` INT(1) DEFAULT 0, 				-- 자산 변동 0.사용안함, 1:생성
  `asset_del` INT(1) DEFAULT 0, 				-- 자산 변동 0.사용안함, 1:삭제
  `asset_upd` INT(1) DEFAULT 0, 				-- 자산 변동 0.사용안함, 1:변경
  `asset_auto` INT(1) DEFAULT 0, 				-- 자산 변동 0.사용안함, 1:오토스케일링
  `hfw_deny` INT(1) DEFAULT 0, 					-- 호스트 방화벽 0.없음, 1.차단
  `hfw_allow` INT(1) DEFAULT 0, 				-- 호스트 방화벽 0.없음, 1.허용
  `integrity_add` INT(1) DEFAULT 0, 			-- 무결성 점검 0.없음, 1.생성
  `integrity_del` INT(1) DEFAULT 0, 			-- 무결성 점검 0.없음, 1.삭제
  `integrity_upd` INT(1) DEFAULT 0, 			-- 무결성 점검 0.없음, 1.변경
  PRIMARY KEY (`mgr_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8;
INSERT INTO `MGR_ADMIN_ALARM` (`mgr_id`) VALUES ('admin');

DROP TABLE IF EXISTS `MGR_ADMIN_ALARM_EXCEPT`;		-- 관리자 알람 수신 예외 테이블
CREATE TABLE `MGR_ADMIN_ALARM_EXCEPT` (
  `mgr_id` VARCHAR(50) NOT NULL,					-- 관리자 아이디
  `host_sn` BIGINT(20) UNSIGNED NOT NULL, 				-- 알람 제외 호스트 sn
  `work_dt` DATETIME DEFAULT NULL,					-- 데이터 생성 일시
  PRIMARY KEY (`mgr_id`, `host_sn`),
  INDEX PK_INDEX(`mgr_id`,`host_sn`)
) ENGINE=INNODB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `MGR_ADMIN_GROUP`;		-- 관리자 그룹 테이블
CREATE TABLE `MGR_ADMIN_GROUP` (
  `group_cd` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,			-- 관리 콘솔 조직 코드 번호
  `group_nm` VARCHAR(50) NOT NULL,				-- 그룹명
  `group_map` INT(1) DEFAULT 0,		-- 그룹 맵핑 넘버
  `group_depth` INT(1) DEFAULT 1,			-- 그룹 깊이
  `parent_group_cd` INT(11) DEFAULT 0,				-- 상위 조직 코드 번호
  `group_desc` VARCHAR(150) DEFAULT NULL, 			-- 설명
  `disp_seq` INT(3) UNSIGNED DEFAULT 0,					-- 화면 정렬 순서
  `unmanaged_flag` INT(1) UNSIGNED DEFAULT 0,		-- 미관리 자산 그룹 여부 (0. 일반 그룹 , 1. 미관리 자산 그룹)
  `work_dt` DATETIME DEFAULT NULL,					-- 데이터 생성 일시
  PRIMARY KEY (`group_cd`),
  INDEX PK_INDEX(`group_cd`)
) ENGINE=INNODB DEFAULT CHARSET=utf8;
INSERT INTO MGR_ADMIN_GROUP (group_cd, group_nm, group_depth, group_desc) VALUES (1, 'All Groups', 1, 'Top-level group');

DROP TABLE IF EXISTS `MGR_ADMIN_GROUP_PERMISSION`;		-- 관리자와 그룹 연결 테이블
CREATE TABLE `MGR_ADMIN_GROUP_PERMISSION` (
  `group_cd` BIGINT(20) UNSIGNED NOT NULL,							-- 관리 콘솔 조직 코드 번호
  `mgr_id` VARCHAR(50) NOT NULL,						-- 관리자명
  PRIMARY KEY (`group_cd`, `mgr_id`),
  INDEX GROUP_INDEX(`group_cd`),
  INDEX MGR_INDEX(`mgr_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `MGR_ADMIN_IAM`;		-- 최고 관리자만 접근할 수 있는 Cloud 계정 정보 테이블
CREATE TABLE `MGR_ADMIN_IAM` (
  `iam_sn` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `group_cd` BIGINT(20) UNSIGNED NOT NULL,						-- 회사 코드
  `iam_cld_type` INT(11) NOT NULL,					-- 계정의 클라우드 타입 1: AWS, 2: GCP, 3: AZURE / 51: KT, 52: NBP, 53: 가비아 / 100:Legacy
  `profile_id` VARCHAR(64) NOT NULL,				-- 프로필 아이디
  `access_key` VARCHAR(256) NOT NULL,				-- 엑세스 키
  `secret_access_key` VARCHAR(256) NOT NULL,			-- 보안 액세스 키
  `iam_passwd` VARCHAR(64) DEFAULT NULL,			-- 클라우드(AWS) 콘솔 유저일 경우 접속 비밀번호 *선택사항
  `login_url` VARCHAR(150) DEFAULT NULL,			-- 클라우드(AWS) 콘솔 유저일 경우 접속 URL *선택사항
  `use_flag` INT(1) NOT NULL DEFAULT 0, 			-- 계정 사용 가능 여부 0. 사용 불가 / 1. 사용 가능
  `iam_main` INT(1) NOT NULL,						-- 1: 메인(실제 aws에 의해 로드되어 등록된 계정), 2: 권한(로드된 자산을 하위그룹에게 분배한 계정)
  `availability_flag` INT(1) DEFAULT 1,				-- 1: 유효함, 2: 유효성 검증 실패
  `work_dt` DATETIME DEFAULT NULL,					-- 데이터 생성 일시
  PRIMARY KEY (`iam_sn`, `group_cd`,`profile_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `MGR_ADMIN_IAM_RC`;			-- Cloud 계정이 갖는 모든 자산 정보 + 그룹에 할당 된 자산 테이블
CREATE TABLE `MGR_ADMIN_IAM_RC` (
  `region_sn` INT(11) NOT NULL,
  `iam_rc_type` INT(11) NOT NULL,					-- 자산 타입 1. VPC, 2.route, 3. N ACL, 4.SUBNET, 5. SG, 6. HOST, 7.VOLUME, 8. Network Interface, 9. region
  `iam_rc_sn` INT(11) NOT NULL,						-- 자산 SN번호(host_sn, vpc_sn, 등등)
  `work_dt` DATETIME DEFAULT NULL,					-- 데이터 생성 일시
  PRIMARY KEY (`region_sn`, `iam_rc_sn`, `iam_rc_type`),
  INDEX PK_INDEX(`region_sn`),
  INDEX RC_INDEX(`iam_rc_sn`),
  INDEX TYPE_INDEX(`iam_rc_type`)
) ENGINE=INNODB DEFAULT CHARSET=utf8;
-- 예) host의 region가져오려면 iam_rc_type = 6이고, iam_rc_sn 을 가져오면 됨.

DROP TABLE IF EXISTS `MGR_ADMIN_IAM_REGION`;
CREATE TABLE `MGR_ADMIN_IAM_REGION` (
  `region_sn` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `iam_sn` BIGINT(20) UNSIGNED NOT NULL,
  `regions` VARCHAR(50) NOT NULL,					-- 계정이 생성된 리전 *필수 (us-east, us-west등등)
  `work_dt` DATETIME DEFAULT NULL,					-- 데이터 생성 일시
  PRIMARY KEY (`region_sn`),
  UNIQUE KEY (`iam_sn`, `regions`),
  INDEX PK_INDEX(`iam_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `MGR_ADMIN_IAM_TAG`;		-- Cloud 사용자(iam) 태그
CREATE TABLE `MGR_ADMIN_IAM_TAG` (
  `iam_tag_sn` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `iam_sn` BIGINT(20) UNSIGNED NOT NULL,							-- iam Main Table SN
  `iam_tag_key` VARCHAR(256) NOT NULL, 					-- 태그 키
  `iam_tag_value` VARCHAR(256) NOT NULL, 				-- 태그 값
  PRIMARY KEY (`iam_tag_sn`),
  INDEX PK_INDEX(`iam_tag_sn`),
  INDEX IAM_INDEX(`iam_sn`)
) ENGINE=INNODB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `MGR_SCHEDULED`;		-- 쿼츠 스케쥴 테이블
CREATE TABLE `MGR_SCHEDULED` (
  `scheduled_name` VARCHAR(40) NOT NULL DEFAULT '', 		-- 스케쥴 명
  `scheduled_job_name` VARCHAR(80) NOT NULL DEFAULT '',		-- 스케쥴 잡 명
  `scheduled_group` VARCHAR(40) DEFAULT NULL,				-- 스케쥴 그룹 명
  `scheduled_class` VARCHAR(255) NOT NULL DEFAULT '',		-- 실행될 클래스
  `scheduled_cron` VARCHAR(255) DEFAULT NULL,				-- 스케쥴 cron 시간
  `scheduled_trigger` VARCHAR(40) DEFAULT NULL,				-- 트리커명
  `scheduled_priority` INT(2) DEFAULT 0,					-- 우선 순위
  `scheduled_service` VARCHAR(40) NOT NULL DEFAULT '',		-- 서비스 명
  `use_flag` INT(1) DEFAULT 1,								-- 사용 여부 (0. 사용안함 / 1.사용)
  `work_dt` DATETIME DEFAULT NULL,							-- 작업 시간
  PRIMARY KEY (`scheduled_name`,`scheduled_job_name`),
  INDEX PK_INDEX(`scheduled_name`, `scheduled_job_name`)
) ENGINE=INNODB DEFAULT CHARSET=utf8;
INSERT INTO `MGR_SCHEDULED` (`scheduled_name`, `scheduled_job_name`, `scheduled_group`, `scheduled_class`, `scheduled_cron`, `scheduled_trigger`, `scheduled_priority`, `scheduled_service`, `use_flag`)
VALUES('awsSyncSchedule', 'awsSyncSchedule', 'awsSyncGroup','com.utron.astron.core.schedule.job.AwsSyncScheduled','0 0 0 * * ?','awsSyncTrigger','1','iAMService','1');
INSERT INTO `MGR_SCHEDULED` (`scheduled_name`, `scheduled_job_name`, `scheduled_group`, `scheduled_class`, `scheduled_cron`, `scheduled_trigger`, `scheduled_priority`, `scheduled_service`, `use_flag`)
VALUES('awsAutoScalingSchedule', 'awsAutoScalingSchedule', 'awsAutoScalingGroup','com.utron.astron.core.schedule.job.AwsAutoScalingScheduled','0 0 0/1 * * ?','awsAutoScalingTrigger','1','iAMService','1');
INSERT INTO `MGR_SCHEDULED` (`scheduled_name`, `scheduled_job_name`, `scheduled_group`, `scheduled_class`, `scheduled_cron`, `scheduled_trigger`, `scheduled_priority`, `scheduled_service`, `use_flag`)
VALUES('mgrServerCollectSchedule', 'mgrServerCollectSchedule', 'mgrServerCollectGroup','com.utron.astron.core.schedule.job.MgrServerScheduled','0 0/1 * * * ?','mgrServerCollectTrigger','1','mgrServerCollectService','1');  -- 매분
INSERT INTO `MGR_SCHEDULED` (`scheduled_name`, `scheduled_job_name`, `scheduled_group`, `scheduled_class`, `scheduled_cron`, `scheduled_trigger`, `scheduled_priority`, `scheduled_service`, `use_flag`)
VALUES('mgrServerHourStsSchedule', 'mgrServerHourStsSchedule', 'mgrServerHourStsGroup','com.utron.astron.core.schedule.job.MgrServerHourStsScheduled','0 0 0/1 * * ?','mgrServerHourStsTrigger','1','mgrServerCollectService','1');   -- 매시간
INSERT INTO `MGR_SCHEDULED` (`scheduled_name`, `scheduled_job_name`, `scheduled_group`, `scheduled_class`, `scheduled_cron`, `scheduled_trigger`, `scheduled_priority`, `scheduled_service`, `use_flag`)
VALUES('mgrServerDayStsSchedule', 'mgrServerDayStsSchedule', 'mgrServerDayStsGroup','com.utron.astron.core.schedule.job.MgrServerDayStsScheduled','0 0 0 * * ?','mgrServerDayStsTrigger','1','mgrServerCollectService','1');    -- 매일
INSERT INTO `MGR_SCHEDULED` (`scheduled_name`, `scheduled_job_name`, `scheduled_group`, `scheduled_class`, `scheduled_cron`, `scheduled_trigger`, `scheduled_priority`, `scheduled_service`, `use_flag`)
VALUES('mongDbdeleteScheduled', 'mongDbdeleteScheduled', 'deleteGroup','com.utron.astron.core.schedule.job.DeleteScheduled','0 10 0 * * ?','MongoDbDeleteTrigger','1','mongoDBService','1');
INSERT INTO `MGR_SCHEDULED` (`scheduled_name`, `scheduled_job_name`, `scheduled_group`, `scheduled_class`, `scheduled_cron`, `scheduled_trigger`, `scheduled_priority`, `scheduled_service`, `use_flag`)
VALUES('unmanagedDeleteScheduled', 'unmanagedDeleteScheduled', 'deleteGroup','com.utron.astron.core.schedule.job.DeleteScheduled','0 0 0 * * ?','UnmanagedDeleteTrigger','1','agentService','1');

DROP TABLE IF EXISTS `INFO_CODE_MASTER`;		-- 코드 리스트 테이블
CREATE TABLE `INFO_CODE_MASTER` (
	`code_type` VARCHAR(50) NOT NULL, 			-- 코드 타입
	`code_number` INT(11) NOT NULL, 			-- 코드 번호
	`code_name` VARCHAR(1024) NOT NULL, 		-- 코드 이름
	`code` VARCHAR(150) DEFAULT '', 			-- 코드 약어
	`code_remark` VARCHAR(150) DEFAULT '', 		-- 설명
	`use_flag` INT(1) DEFAULT 1, 				-- 사용 여부
	primary key(`code_type`, `code_number`)
)ENGINE=INNODB DEFAULT CHARSET=UTF8;

DROP TABLE IF EXISTS `CLD_CONF_OPTION`;		-- 호스트에서 사용중인 옵션 정보 테이블
CREATE TABLE `CLD_CONF_OPTION` (
  `cld_conf_sn` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `flag_sn` INT(11) NOT NULL,		-- 연결될 테이블 sn
  `type_sn` INT(11) NOT NULL,		-- 1.host 2.vpc
  `auto_scaling_flag` INT(1) DEFAULT 0, -- 오토스케일링 사용 여부
  `peering_flag` INT(1) DEFAULT 0, -- 피어링 사용 여부
  PRIMARY KEY (`cld_conf_sn`),
  INDEX PK_INDEX(`cld_conf_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `CLD_AMI`;		-- 이미지(AMI) 테이블
CREATE TABLE `CLD_AMI` (
  `ami_sn` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `host_sn` BIGINT(20) UNSIGNED NOT NULL,		-- Host Main Table SN
  `ami_id` VARCHAR(80) NOT NULL, -- 이미지 아이디
  PRIMARY KEY (`ami_sn`),
  UNIQUE KEY `ami_id_unique` (`host_sn`, `ami_id`),
  INDEX PK_INDEX(`ami_sn`),
  INDEX HOST_INDEX(`host_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `CLD_HOST`;	-- 호스트 정보 메인 테이블
CREATE TABLE `CLD_HOST` (
  `host_sn` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `host_id` VARCHAR(50) NOT NULL, -- 인스턴스 아이디
  `vpc_sn` BIGINT(20) UNSIGNED NOT NULL,		-- VPC Main Table SN
  `sub_sn` BIGINT(20) UNSIGNED NOT NULL,		-- SUBNET Main Table SN
  `cld_type` INT(1) NOT NULL DEFAULT 1, -- 클라우드 타입 1: AWS, 2: GCP, 3: AZURE / 51: KT, 52: NBP, 53: 가비아 / 100:Legacy
  `del_flag` INT(1) DEFAULT 0, -- 삭제 여부 0.존재 / 1.삭제됨
  `work_dt` DATETIME DEFAULT NULL,	-- 서버 데이터 생성 일시
  PRIMARY KEY (`host_sn`),
  UNIQUE KEY `host_id_unique` (`host_id`),
  INDEX WORK_DT_INDEX(`work_dt`),
  INDEX PK_INDEX(`host_sn`),
  INDEX VPC_INDEX(`vpc_sn`),
  INDEX SUBNET_INDEX(`sub_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `CLD_HOST_DTL`;		-- 호스트 상세 정보 테이블									--
CREATE TABLE `CLD_HOST_DTL` (
  `host_sn` BIGINT(20) UNSIGNED NOT NULL,		-- Host Main Table SN
  `host_dtl_type` VARCHAR(20) NOT NULL, -- 스토리지 유형
  `host_dtl_actt` VARCHAR(20) NOT NULL, -- 아키텍처
  `host_dtl_hyperv` VARCHAR(10) NOT NULL, -- 하이퍼바이저
  `host_dtl_root_dev_nm` VARCHAR(20) NOT NULL, -- 루트 디바이스명
  `host_dtl_root_dev_type` VARCHAR(10) NOT NULL, -- 루트 디바이스 타입
  `host_dtl_vir_type` VARCHAR(10) NOT NULL, -- 가상 머신 유형
  `host_dtl_ramdisk_id` VARCHAR(50) DEFAULT NULL, -- 램디스크 아이디 (데이터 모름)
  `host_dtl_licenses` VARCHAR(50) DEFAULT NULL, -- 라이선스 정보 (데이터 모름)
  `host_dtl_platform` VARCHAR(50) DEFAULT NULL, -- 플랫폼 (Windows 같은 운영 체제 플랫폼입니다. 이 값은 일부 플랫폼 유형에는 반환되지 않습니다.)
  `host_dtl_key_pair` VARCHAR(30) DEFAULT NULL, -- 키 페어 네임
  `host_dtl_life_cycle` VARCHAR(30) DEFAULT NULL, -- 인스턴스 생명 주기 (데이터 모름)
  `host_dtl_kernel_id`  VARCHAR(30) DEFAULT NULL, -- AMI(amazon 머신 이미지)와 연결된 운영 체제 커널 아이디
  `host_dtl_cap_reserv_id` VARCHAR(30) DEFAULT NULL, -- 용광 예약로 아이디 (데이터 모름)
  `host_dtl_ami_launch_index` INT(11) NOT NULL, -- AMI 시작 인덱스
  `host_dtl_ebs_optimiz` INT(1) NOT NULL, -- 엘라스틱 블록 스토리지 최적화 여부
  `host_dtl_ena_support` INT(1) NOT NULL, -- 엘라스틱 네트워크 어뎁터 정보
  `host_dtl_hiber_op` INT(1) NOT NULL, -- 하이버네이션 옵션 정보 여부
  `host_dtl_iam_profile_arn` VARCHAR(50) DEFAULT NULL, -- IAM 프로필 정보
  `host_dtl_iam_profile_id` VARCHAR(50) DEFAULT NULL, -- IAM 프로필 id 정보
  `host_dtl_spot_id` VARCHAR(50) DEFAULT NULL, -- 스팟 인스턴스 요청 아이디 (필요한지..?)
  `host_dtl_sriov_ns` VARCHAR(50) DEFAULT NULL, -- sriovNetSupport 속성 :  intel 82599 VF 인터페이스를 사용하는 향상된 네트워킹이 활성화됨.
  `host_dtl_owner_id` VARCHAR(30) NOT NULL, 				-- 소유자
  PRIMARY KEY (`host_sn`),
  INDEX PK_INDEX(`host_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `CLD_HOST_SG`;		-- 호스트와 연결된 보안 그룹 정보
CREATE TABLE `CLD_HOST_SG` (
  `host_sn` BIGINT(20) UNSIGNED NOT NULL,		-- Host Main Table SN
  `sg_sn` BIGINT(20) UNSIGNED NOT NULL,		-- sg Main Table SN
  INDEX HOST_INDEX(`host_sn`),
  INDEX SG_INDEX(`sg_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `CLD_HOST_PRODUCT`;		-- 제품 정보 그룹 테이블
CREATE TABLE `CLD_HOST_PRODUCT` (
  `host_sn` BIGINT(20) UNSIGNED NOT NULL,		-- Host Main Table SN
  `host_pd_code_type` VARCHAR(20) DEFAULT NULL, -- 호스트 제품 코드 타입 정보 (ex: marketplace)
  `host_pd_code_id` VARCHAR(50) DEFAULT NULL, -- 호스트 제품 코드 아이디 정보
  PRIMARY KEY (`host_sn`),
  INDEX PK_INDEX(`host_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `CLD_HOST_CPU`;		-- CPU 옵션 정보 그룹 테이블
CREATE TABLE `CLD_HOST_CPU` (
  `host_cpu_sn` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `host_sn` BIGINT(20) UNSIGNED NOT NULL,		-- Host Main Table SN
  PRIMARY KEY (`host_cpu_sn`),
  INDEX PK_INDEX(`host_cpu_sn`),
  INDEX HOST_INDEX(`host_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `CLD_HOST_CPU_DTL`;   -- CLOUD CPU 상세 정보 그룹 테이블 (Agent)
CREATE TABLE `CLD_HOST_CPU_DTL` (
  `cpu_dtl_sn` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `host_cpu_sn` BIGINT(20) UNSIGNED NOT NULL,   -- Host Main Table SN
  `cpu_dtl_core_cnt` INT(11) NOT NULL, -- cpu 코어 수
  `cpu_dtl_thread_per_cnt` INT(11) NOT NULL, -- 스레드 수
  `work_dt` DATETIME DEFAULT NULL,	-- 서버 데이터
  PRIMARY KEY (`cpu_dtl_sn`),
  INDEX PK_INDEX(`cpu_dtl_sn`),
  INDEX HOST_CPU_INDEX(`host_cpu_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `INFO_AGENT_CPU_DTL`;   -- CPU 상세 정보 그룹 테이블 (Agent)
CREATE TABLE `INFO_AGENT_CPU_DTL` (
  `cpu_dtl_sn` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `host_sn` BIGINT(20) UNSIGNED NOT NULL,   -- Host SN
  `cpu_dtl_bank_idx` INT(11) DEFAULT NULL, -- cpu 뱅크 번호
  `cpu_dtl_core_cnt` INT(11) NOT NULL, -- cpu 코어 수
  `cpu_dtl_thread_per_cnt` INT(11) NOT NULL, -- 스레드 수
  `cpu_dtl_processor_cnt` INT(11) DEFAULT NULL, -- processor 수
  `cpu_dtl_vendor` VARCHAR(40) DEFAULT "", -- 벤더 아이디
  `cpu_dtl_speed` VARCHAR(20) DEFAULT NULL, -- 속도
  `cpu_dtl_family` VARCHAR(40) DEFAULT "", -- 종류
  `cpu_dtl_ver` VARCHAR(40) DEFAULT "", -- 버전
  `ins_work_dt` DATETIME DEFAULT NULL,	-- 서버 데이터 생성 일시
  `del_work_dt` DATETIME DEFAULT NULL,	-- 서버 데이터 삭제 일시
  `work_dt` DATETIME DEFAULT NULL,	-- 서버 데이터
  PRIMARY KEY (`cpu_dtl_sn`),
  INDEX PK_INDEX(`cpu_dtl_sn`),
  INDEX HOST_CPU_INDEX(`host_sn`),
  UNIQUE KEY `host_cpu_sn_index` (`host_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `INFO_AGENT_MEMORY`;		-- 메모리 정보 그룹 테이블
CREATE TABLE `INFO_AGENT_MEMORY` (
  `memory_sn` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `host_sn` BIGINT(20) UNSIGNED NOT NULL,		-- Host Main Table SN
  `memory_total` VARCHAR(50) NOT NULL, -- 메모리 총량
  `memory_vendor` VARCHAR(50) NOT NULL, -- 벤더 정보
  `memory_bank_cnt` INT(11) NOT NULL, -- 뱅크 갯수
  `memory_use_bank` INT(11) NOT NULL, -- processor 수
  `memory_type` VARCHAR(50) DEFAULT "", -- memory 타입 (DDR, DDR3, ..)
  `memory_speed` VARCHAR(50) DEFAULT "", -- memory 속도 (200Ghz,...)
  `work_dt` DATETIME DEFAULT NULL,	-- 서버 데이터
  PRIMARY KEY (`memory_sn`),
  INDEX PK_INDEX(`memory_sn`),
  INDEX HOST_INDEX(`host_sn`),
  UNIQUE KEY `host_memory_sn_index` (`host_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `INFO_AGENT_DISK`;		-- 에이전트에서 수집된 호스트 디스크정보
CREATE TABLE `INFO_AGENT_DISK` (
  `disk_sn` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `host_sn` BIGINT(20) UNSIGNED NOT NULL,		-- Host Main Table SN
  `work_dt` DATETIME DEFAULT NULL,	-- 서버 데이터
  PRIMARY KEY (`disk_sn`),
  INDEX PK_INDEX(`disk_sn`),
  INDEX HOST_INDEX(`host_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `INFO_AGENT_DISK_DTL`;		-- 에이전트에서 수집된 호스트 디스크정보
CREATE TABLE `INFO_AGENT_DISK_DTL` (
  `disk_dtl_sn` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `disk_sn` BIGINT(20) UNSIGNED NOT NULL,		-- Host Main Table SN
  `disk_dtl_name` VARCHAR(50) NOT NULL,		-- 디스크 명
  `disk_dtl_vendor` VARCHAR(50) NOT NULL,	-- 벤더 명
  `disk_dtl_model` VARCHAR(100) NOT NULL,	-- 모델 명
  `disk_dtl_interface` VARCHAR(50) NOT NULL,		-- 인터페이스 상태 정보
  `disk_dtl_size` BIGINT NOT NULL,			-- 디스크 사이즈
  `disk_dtl_index` INT(11) NOT NULL,		-- 디스크 인덱스
  `disk_dtl_partition_cnt` INT(11) NOT NULL,		-- 디스크 파티션 개수
  PRIMARY KEY (`disk_dtl_sn`),
  INDEX PK_INDEX(`disk_dtl_sn`),
  INDEX DISK_INDEX(`disk_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 20191230 마운트 정보는 모니터링에 통계성으로 보여준다. 통계는 수집서버에서 하고, 정보도 준다.
-- 20200103 마운트 통계성 정보를 제외하고 나머지는 만들도록 한다.
DROP TABLE IF EXISTS `INFO_AGENT_MOUNT`;		-- 에이전트에서 수집된 호스트 마운트정보
CREATE TABLE `INFO_AGENT_MOUNT` (
  `mount_sn` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `host_sn` BIGINT(20) UNSIGNED NOT NULL,					-- Host Main Table SN
  `work_dt` DATETIME DEFAULT NULL,				-- 서버 데이터
  PRIMARY KEY (`mount_sn`),
  INDEX PK_INDEX(`mount_sn`),
  INDEX HOST_INDEX(`host_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `INFO_AGENT_MOUNT_DTL`;	-- 에이전트에서 수집된 호스트 디스크정보
CREATE TABLE `INFO_AGENT_MOUNT_DTL` (
  `mount_dtl_sn` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `mount_sn` BIGINT(20) UNSIGNED NOT NULL,					-- Host Main Table SN
  `mount_dtl_index` INT(11) NOT NULL,			-- 마운트 인덱스
  `mount_dtl_name` VARCHAR(50) NOT NULL,		-- 마운트 명
  `mount_dtl_partition` VARCHAR(50) DEFAULT '',	-- 파티션
  `mount_dtl_filesystem` VARCHAR(100) DEFAULT '',	-- 파일 시스템
  `mount_dtl_drive_type` INT(11) NOT NULL,		-- drivetype (3:local, 2:Removable, 0:Unknown, 1:No Root Dir, 4:Network, 5:Compact, 6:Ram Disk, 10:Overlay)
  PRIMARY KEY (`mount_dtl_sn`),
  INDEX PK_INDEX(`mount_dtl_sn`),
  INDEX DISK_INDEX(`mount_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `INFO_AGENT_NIC`;		-- 에이전트에서 수집된 호스트 nic정보
CREATE TABLE `INFO_AGENT_NIC` (
  `nic_sn` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `host_sn` BIGINT(20) UNSIGNED NOT NULL,		-- Host Main Table SN
  `work_dt` DATETIME DEFAULT NULL,	-- 서버 데이터
  PRIMARY KEY (`nic_sn`),
  INDEX PK_INDEX(`nic_sn`),
  INDEX HOST_INDEX(`host_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `INFO_AGENT_NIC_DTL`;		-- 에이전트에서 수집된 호스트 nic정보
CREATE TABLE `INFO_AGENT_NIC_DTL` (
  `nic_dtl_sn` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `nic_sn` BIGINT(20) UNSIGNED NOT NULL,			-- Host Main Table SN
  `nic_dtl_index` INT(11) NOT NULL,			-- NIC 인덱스
  `nic_dtl_interface` VARCHAR(50) NOT NULL,	-- nic 명
  `nic_dtl_vendor` VARCHAR(50) NOT NULL,	-- 벤더 명
  `nic_dtl_product` VARCHAR(100) NOT NULL,	-- 제품군
  `nic_dtl_speed` VARCHAR(50) NOT NULL,		-- 속도
  `nic_dtl_mac` VARCHAR(150) NOT NULL,			-- mac 주소
  `nic_dtl_ip` VARCHAR(50) NOT NULL,			-- ip 주소
  PRIMARY KEY (`nic_dtl_sn`),
  INDEX PK_INDEX(`nic_dtl_sn`),
  INDEX NIC_INDEX(`nic_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `INFO_AGENT_OS`;		-- OS 정보 그룹 테이블
CREATE TABLE `INFO_AGENT_OS` (
  `agent_os_sn` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `host_sn` BIGINT(20) UNSIGNED NOT NULL,		-- Host Main Table SN
  `agent_os_kernel_version` VARCHAR(150) DEFAULT NULL, -- 커널 버전 정보
  `agent_os_type` INT NOT NULL, -- OS 타입 (1: 윈도우(Desk), 2: 윈도우(Server), 5: 리눅스(Desk), 6:리눅스(Server), 10: AIX, 15: HP, 20: Solaris)
  `agent_os_type2` INT NOT NULL, -- OS 타입2 (1: RedHat, 2: CentOS, 3: Ubuntu, 4: Debian 5: Amazon, 1007: Win7, 1008: Win8, 1010: Win10, 2008: Win Server 2008)
  `agent_os_version` VARCHAR(150) DEFAULT NULL, -- 버전 정보
  `agent_os_name` VARCHAR(150) DEFAULT NULL, -- os 사용자명
  `boot_time` DATETIME DEFAULT NULL,	-- 호스트 실행 시간
  `work_dt` DATETIME DEFAULT NULL,	-- 서버 데이터 생성 일시
  PRIMARY KEY (`agent_os_sn`),
  UNIQUE KEY `host_sn_index` (`host_sn`),
  INDEX PK_INDEX(`agent_os_sn`),
  INDEX AGENT_INDEX(`host_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `CLD_HOST_NETWORK`;		-- 호스트 네트워크 정보 테이블 (네트워크 인터페이스랑 비교해보고 같으면 버리세요.)
CREATE TABLE `CLD_HOST_NETWORK` (
  `host_nw_sn` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `host_sn` BIGINT(20) UNSIGNED NOT NULL,		-- Host Main Table SN
  `host_nw_public_ip_addr` VARCHAR(20) DEFAULT NULL, -- 호스트 퍼블릭 아이피
  `host_nw_public_dns_nm` VARCHAR(150) DEFAULT NULL, -- 호스트 퍼블릭 dns 이름
  `host_nw_private_ip_addr` VARCHAR(20) DEFAULT NULL, -- 호스트 프라이빗 아이피
  `host_nw_private_dns_nm` VARCHAR(50) DEFAULT NULL, -- 호스트 프라이빗 dns 이름
  PRIMARY KEY (`host_nw_sn`),
  INDEX PK_INDEX(`host_nw_sn`),
  INDEX HOST_INDEX(`host_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `CLD_HOST_STATUS`; -- 호스트 상태 정보 테이블										--
CREATE TABLE `CLD_HOST_STATUS` (
  `host_sn` BIGINT(20) UNSIGNED NOT NULL,		-- Host Main Table SN
  `host_status_code` INT(1) NOT NULL, -- 인스턴스 상태 코드
  `host_status_mon` VARCHAR(50) DEFAULT NULL, -- 모니터링 상태 정보
  `host_status_trans_reason` VARCHAR(50) NOT NULL, -- 호스트 상태 전환 이유
  `host_status_launch_time` DATETIME DEFAULT NULL, -- 호스트 시작 시간
  `host_status_reason` VARCHAR(250) DEFAULT NULL, -- 상태 변경 메세지
  PRIMARY KEY (`host_sn`),
  INDEX PK_INDEX(`host_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `CLD_HOST_TAG`;		-- 호스트 태그 테이블
CREATE TABLE `CLD_HOST_TAG` (
  `host_tag_sn` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `host_sn` BIGINT(20) UNSIGNED NOT NULL,		-- Host Main Table SN
  `host_tag_key` VARCHAR(256) NOT NULL, -- 태그 키
  `host_tag_value` VARCHAR(256) NOT NULL, -- 태그 값
  PRIMARY KEY (`host_tag_sn`),
  INDEX PK_INDEX(`host_tag_sn`),
  INDEX HOST_INDEX(`host_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `CLD_HOST_PLACEMENT`;		-- 호스트 배치 그룹 테이블
CREATE TABLE `CLD_HOST_PLACEMENT` (
  `host_sn` BIGINT(20) UNSIGNED NOT NULL,		-- Host Main Table SN
  `host_pm_az` VARCHAR(20) NOT NULL, -- 배치 그룹의 가용 영역
  `host_pm_group_nm` VARCHAR(20) NOT NULL, -- 배치 그룹 명
  `host_pm_tenancy` VARCHAR(20) NOT NULL, -- 태넌시: 실행하고자 하는 전용 호스트
  `host_pm_affinity` VARCHAR(20) DEFAULT NULL, -- 확인 필요.
  `host_pm_partition_num` VARCHAR(20) DEFAULT NULL, -- 확인 필요.
  `host_pm_spread_domain` VARCHAR(20) DEFAULT NULL, -- 확인 필요.
  PRIMARY KEY (`host_sn`),
  INDEX PK_INDEX(`host_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `CLD_HOST_CRS`;		-- 용량 예약 설정 그룹 테이블
CREATE TABLE `CLD_HOST_CRS` (
  `host_sn` BIGINT(20) UNSIGNED NOT NULL,		-- Host Main Table SN
  `host_crs_crp` VARCHAR(20) NOT NULL, -- 용량 예약 설정 정보
  `host_crs_target` VARCHAR(20) DEFAULT NULL, -- 용량 예약 타겟
  PRIMARY KEY (`host_sn`),
  INDEX PK_INDEX(`host_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `CLD_HOST_BDM`;		-- blockDeviceMappings 블록 디바이스 그룹
CREATE TABLE `CLD_HOST_BDM` (
  `host_bdm_sn` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `host_sn` BIGINT(20) UNSIGNED NOT NULL,		-- Host Main Table SN
  `host_bdm_device_nm` VARCHAR(20) NOT NULL, -- 볼륨을 포함하는 시스템 디바이스명
  PRIMARY KEY (`host_bdm_sn`),
  INDEX PK_INDEX(`host_bdm_sn`),
  INDEX HOST_INDEX(`host_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `CLD_HOST_EBDM`;		-- blockDeviceMappings 블록 디바이스 그룹에 포함된 엘라스틱 블록 스토리지 정보 그룹 테이블
CREATE TABLE `CLD_HOST_EBDM` (		-- cloud 의 볼륨 연결 정보
  `host_bdm_sn` BIGINT(20) UNSIGNED NOT NULL,		-- Host Main Table SN
  `vol_sn` BIGINT(20) UNSIGNED NOT NULL,		-- VOLUME Main Table SN
  `host_ebdm_attach_time` DATETIME DEFAULT NULL, -- ebs 생성 일시
  `host_ebdm_del_on_tmnt` INT(1) DEFAULT NULL, -- 인스턴트 연결 종료 시 삭제 설정
  `host_ebdm_status` VARCHAR(10) NOT NULL, -- ebs 연결 상태
  PRIMARY KEY (`host_bdm_sn`),
  INDEX PK_INDEX(`host_bdm_sn`),
  INDEX VOLUME_INDEX(`vol_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `CLD_HOST_DEL_LIST`;		-- 몽고DB 호스트 정보 삭제 리스트
CREATE TABLE `CLD_HOST_DEL_LIST` (
  `host_sn` BIGINT(20) UNSIGNED NOT NULL,
  PRIMARY KEY (`host_sn`),
  INDEX PK_INDEX(`host_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `INFO_AGENT_RC_MGR_SW_DTL`;	-- 호스트 관리대상 소프트 웨어 자산 상세 테이블([설정]에서 설정되는 소프트웨어 관리 목록)
CREATE TABLE `INFO_AGENT_RC_MGR_SW_DTL` (
  `msw_dtl_sn` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `host_sn` BIGINT(20) UNSIGNED NOT NULL,					-- HOST SW Main Table SN
  `msw_dtl_mg` INT(1) NOT NULL DEFAULT 0, 		-- 주요 소프트웨어 관리 대상(0: 관리대상 제외, 1: 관리대상)
  `msw_dtl_nm` VARCHAR(200) DEFAULT NULL, 		-- 소프트웨어 이름
  `msw_dtl_vendor` VARCHAR(50) DEFAULT NULL, 	-- 소프트웨어 회사명
  `msw_dtl_type` INT(1) NOT NULL DEFAULT 0, 	-- 소프트웨어 유형(0:etc, 1:WEB, 2:WAS, 3:DBMS, 4:Application, 5:Library)
  `msw_dtl_port` VARCHAR(50) DEFAULT NULL, 		-- 소프트웨어 서비스 포트 ('8080,9090' 같이 문자열입력)
  `msw_dtl_cver` VARCHAR(50) DEFAULT NULL, 		-- 소프트웨어 현재 버전
  `msw_dtl_rver` VARCHAR(50) DEFAULT NULL, 		-- 소프트웨어 권장 버전
  `msw_dtl_pver` VARCHAR(50) DEFAULT NULL, 		-- 소프트웨어 이전 버전
  `msw_dtl_size` INT(11) DEFAULT NULL, 			-- 소프트웨어 크기
  `msw_dtl_release` VARCHAR(50) DEFAULT NULL, 	-- 소프트웨어 릴리즈 정보
  `msw_dtl_ins_dt` DATETIME DEFAULT NULL,		-- 소프트웨어 설치 일시
  `msw_dtl_build_dt` DATETIME DEFAULT NULL,		-- 소프트웨어 빌드 일시
  `msw_dtl_owner` VARCHAR(20) DEFAULT NULL,		-- 등록자
  `work_dt` DATETIME DEFAULT NULL,				-- 서버 데이터 생성 일시(수정일)
  PRIMARY KEY (`msw_dtl_sn`, `host_sn`, `msw_dtl_nm`),
  UNIQUE KEY `fw_host_sn_dtl_nm_unique` (`host_sn`, `msw_dtl_nm`),
  INDEX PK_INDEX(`msw_dtl_sn`),
  INDEX SW_INDEX(`host_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `INFO_AGENT_FW_DTL`;	-- 호스트 방화벽 상세 테이블
CREATE TABLE `INFO_AGENT_FW_DTL` (
  `fw_dtl_sn` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
--  `fw_sn` INT(11) NOT NULL,		-- FW Main Table SN
  `host_sn` BIGINT(20) UNSIGNED NOT NULL,		-- HOST SN
  `fw_dtl_nm` VARCHAR(50) NOT NULL, -- 방화벽 정책 이름
  `fw_dtl_rule_num` INT(11) DEFAULT NULL, -- 룰 넘버
--  `fw_dtl_type` INT(11) NOT NULL DEFAULT 0, -- 정책 타입  1.HOST, 2. 예제 (뺀다. 템플릿으로 대체)
  `fw_dtl_direct` INT(1) NOT NULL DEFAULT 0, -- 방향 0. in, 1. out
  `fw_dtl_enable` INT(1) NOT NULL DEFAULT 1, -- 룰 사용여부 0:사용안함, 1:사용함 => TODO 무조건 1만 셋팅하도록 한다.
  `fw_dtl_action` INT(1) NOT NULL DEFAULT 0, -- 행위 0: Deny, 1: Allow
  `fw_dtl_log_lv` INT(1) NOT NULL DEFAULT 1, -- 0: No, 1: Info, 2: Warn, 3: Error, 4: Critical, 5: Fault, 7: Debug => TODO 무조건 1만 셋팅하도록 한다.
--  `fw_dtl_protocol` INT(11) NOT NULL DEFAULT 0, -- 프로토콜 0:All, 1 : TCP&UDP, 2:ICMP 6:TCP, 17:UDP
  `fw_dtl_protocol` INT(1) NOT NULL DEFAULT 0, -- 프로토콜 0:All, 1:TCP&UDP, 2:ICMP 6:TCP, 17:UDP
  `fw_dtl_port` VARCHAR(20) NOT NULL DEFAULT '0-65535', -- 포트 null 이면 0-65535이어야 한다.(공백 없도록)
  `fw_dtl_ip_src` VARCHAR(40), -- 출발지 주소
  `fw_dtl_ip_dst` VARCHAR(40), -- 목적지 주소
  `fw_dtl_schedule_flag` INT(1) NOT NULL DEFAULT 0, -- 스케쥴 사용 여부 (사용할 경우 스케쥴 테이블에 정보 생성) (0: 사용안함, 1:사용함) 스케쥴 없이 디폴트 설정 적용한다면 사용안함
  `fw_dtl_desc` VARCHAR(255), -- 설명
  `work_dt` DATETIME DEFAULT NULL,	-- 서버 데이터 생성 일시
  PRIMARY KEY (`fw_dtl_sn`),
  UNIQUE KEY `fw_host_sn_dtl_direct_rule_num_unique` (`host_sn`, `fw_dtl_direct`, `fw_dtl_rule_num`),
  INDEX PK_INDEX(`fw_dtl_sn`),
  INDEX FW_INDEX(`host_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `INFO_AGENT_FW_SCHEDULE`;	-- 호스트 방화벽 스케쥴 테이블
CREATE TABLE `INFO_AGENT_FW_SCHEDULE` (
  `schedule_sn` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `fw_dtl_sn` BIGINT(20) UNSIGNED NOT NULL,					-- FW DTL Main Table SN
  `schedule_type` INT(1) NOT NULL, 				-- 1.날짜별,2.요일별,3.날짜 + 요일별
  `schedule_from` VARCHAR(10) DEFAULT NULL,		-- 서버 데이터 생성 일시(날짜만 시분초 제외)
  `schedule_to` VARCHAR(10) DEFAULT NULL,			-- 서버 데이터 생성 일시(날짜만 시분초 제외)
  `schedule_week` VARCHAR(150) DEFAULT NULL, 	-- 0. 일요일, 1.월요일, 2.화요일, 3.수요일, 4.목요일, 5.금요일, 6. 토요일 (구분값 ',' ex: 월,수만 적용 [1]0900-1700,[3]1200-2300)
  `work_dt` DATETIME DEFAULT NULL,	-- 서버 데이터 생성 일시
  PRIMARY KEY (`schedule_sn`),
  UNIQUE KEY `fw_dtl_sn_info_agent_fw_schedule_unique` (`fw_dtl_sn`),
  INDEX PK_INDEX(`schedule_sn`),
  INDEX FW_DTL_INDEX(`fw_dtl_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `INFO_AGENT_FW_TEMPLATE`;
CREATE TABLE `INFO_AGENT_FW_TEMPLATE` (
	`fw_temp_sn` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
    `fw_temp_id` VARCHAR(50) DEFAULT NULL, 	-- 템플릿 ID
    `fw_temp_desc` VARCHAR(255) DEFAULT NULL, -- 설명
    `work_dt` DATETIME DEFAULT NULL,			-- 서버 데이터 생성 일시
    PRIMARY KEY (`fw_temp_sn`),
    INDEX PK_INDEX(`fw_temp_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `INFO_AGENT_FW_TEMPLATE_GROUP`;
CREATE TABLE `INFO_AGENT_FW_TEMPLATE_GROUP` (
	`fw_temp_group_sn` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
	`fw_temp_sn` BIGINT(20) UNSIGNED NOT NULL,
	`group_cd` BIGINT(20) UNSIGNED NOT NULL,				-- 회사 코드
    PRIMARY KEY (`fw_temp_group_sn`),
    UNIQUE KEY `fw_group_cd_temp_id_unique` (`group_cd`, `fw_temp_sn`),
    INDEX PK_INDEX(`fw_temp_group_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `INFO_AGENT_FW_TEMPLATE_DTL`;
CREATE TABLE `INFO_AGENT_FW_TEMPLATE_DTL` (
  `fw_temp_dtl_sn` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `fw_temp_sn` BIGINT(20) UNSIGNED NOT NULL,		-- Host FW Tempalte SN
  `fw_temp_nm` VARCHAR(50) NOT NULL, -- 방화벽 정책 이름
  `fw_temp_rule_num` INT(11) DEFAULT NULL, -- 룰 넘버
  `fw_temp_direct` INT(1) NOT NULL DEFAULT 0, -- 방향 0. in, 1. out
  `fw_temp_enable` INT(1) NOT NULL DEFAULT 1, -- 룰 사용여부 0:사용안함, 1:사용함 => TODO 무조건 1만 셋팅하도록 한다.
  `fw_temp_action` INT(1) NOT NULL DEFAULT 0, -- 행위 0: Deny, 1: Allow
  `fw_temp_log_lv` INT(1) NOT NULL DEFAULT 1, -- 0: No, 1: Info, 2: Warn, 3: Error, 4: Critical, 5: Fault, 7: Debug => TODO 무조건 1만 셋팅하도록 한다.
  `fw_temp_protocol` INT(1) NOT NULL DEFAULT 0, -- 프로토콜 0:All, 1 : TCP&UDP, 2:ICMP 6:TCP, 17:UDP
  `fw_temp_port` VARCHAR(20) NOT NULL DEFAULT '0-65535', -- 포트
  `fw_temp_ip_src` VARCHAR(40), -- 출발지 주소
  `fw_temp_ip_dst` VARCHAR(40), -- 목적지 주소
  `fw_temp_schedule_flag` INT(1) NOT NULL DEFAULT 0, -- 스케쥴 사용 여부 (사용할 경우 스케쥴 테이블에 정보 생성) (0: 사용안함, 1:사용함) 스케쥴 없이 디폴트 설정 적용한다면 사용안함
  `fw_temp_desc` VARCHAR(255), -- 설명
  `work_dt` DATETIME DEFAULT NULL,	-- 데이터 활동 시간 (20200115 삭제)
  PRIMARY KEY (`fw_temp_dtl_sn`),
  UNIQUE KEY `fw_temp_sn_temp_direct_rule_num_unique` (`fw_temp_sn`, `fw_temp_direct`, `fw_temp_rule_num`),
  INDEX PK_INDEX(`fw_temp_dtl_sn`),
  INDEX NACL_TEMP_INDEX(`fw_temp_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `INFO_AGENT_FW_TEMPLATE_SCHEDULE`;	-- 호스트 방화벽 템플릿 스케쥴 테이블
CREATE TABLE `INFO_AGENT_FW_TEMPLATE_SCHEDULE` (
  `temp_schedule_sn` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `fw_temp_dtl_sn` BIGINT(20) UNSIGNED NOT NULL,					-- FW DTL Main Table SN
  `schedule_type` INT(1) NOT NULL, 				-- 1.날짜별,2.요일별,3.날짜 + 요일별
  `schedule_from` VARCHAR(10) DEFAULT NULL,		-- 서버 데이터 생성 일시(날짜만 시분초 제외)
  `schedule_to` VARCHAR(10) DEFAULT NULL,			-- 서버 데이터 생성 일시(날짜만 시분초 제외)
  `schedule_week` VARCHAR(150) DEFAULT NULL, 	-- 0. 일요일, 1.월요일, 2.화요일, 3.수요일, 4.목요일, 5.금요일, 6. 토요일 (구분값 ',' ex: 월,수만 적용 [1]0900-1700,[3]1200-2300)
  PRIMARY KEY (`temp_schedule_sn`),
  UNIQUE KEY `fw_temp_dtl_sn_info_agent_fw_schedule_unique` (`fw_temp_dtl_sn`),
  INDEX PK_INDEX(`temp_schedule_sn`),
  INDEX FW_DTL_INDEX(`fw_temp_dtl_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `INFO_AGENT_PROCESS`;	-- 호스트 프로세스 모니터 정책
CREATE TABLE `INFO_AGENT_PROCESS` (
  `pm_sn` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `host_sn` BIGINT(20) UNSIGNED NOT NULL,		-- HOST Main Table SN
  `work_dt` DATETIME DEFAULT NULL,	-- 서버 데이터 생성 일시
  PRIMARY KEY (`pm_sn`),
  INDEX WORK_DT_INDEX(`work_dt`),
  INDEX PK_INDEX(`pm_sn`),
  INDEX HOST_INDEX(`host_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `INFO_AGENT_PROCESS_DTL`;	-- 호스트 프로세스 모니터 상세 테이블
CREATE TABLE `INFO_AGENT_PROCESS_DTL` (
  `pm_dtl_sn` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `pm_sn` BIGINT(20) UNSIGNED NOT NULL,		-- Process Monitor Main Table SN
  `pm_dtl_nm` VARCHAR(50) NOT NULL, -- 정책 이름
  `pm_dtl_alias` VARCHAR(128) DEFAULT NULL,
  `pm_dtl_use_flag` INT(1) NOT NULL DEFAULT 0,
  `pm_dtl_path` VARCHAR(128) NOT NULL DEFAULT 0,
  `pm_dtl_param` VARCHAR(1024) NOT NULL DEFAULT 0,
  `pm_dtl_warning` INT(1) NOT NULL DEFAULT 0,
  `pm_dtl_critical` INT(1) NOT NULL DEFAULT 0,
  `work_dt` DATETIME DEFAULT NULL,	-- 서버 데이터 생성 일시
  PRIMARY KEY (`pm_dtl_sn`),
  INDEX PK_INDEX(`pm_dtl_sn`),
  INDEX FW_INDEX(`pm_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `INFO_AGENT_PROCESS_CONFIG`;	-- 호스트 프로세스 모니터 환경설정
CREATE TABLE `INFO_AGENT_PROCESS_CONFIG` (
  `pm_conf_sn` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `pm_sn` BIGINT(20) UNSIGNED NOT NULL,		-- Process Monitor Main Table SN
  `pm_conf_type` INT(1) NOT NULL,		-- 검사 방식(1:수동, 2:주기적, 3:자동)
  `pm_conf_schedule_flag` INT(1) NOT NULL, -- 스케줄 Enable (0: disable, 1:Enable)
  `pm_conf_schedule_type` INT(1) NOT NULL,	-- 스케줄 방식 (1:분단위, 3:특정시간)
  `pm_conf_schedule_second` VARCHAR(50) DEFAULT NULL,	-- 초단위 검사
  `pm_conf_time` DATETIME DEFAULT NULL, -- 특정 시간 지정 hhmm
  `work_dt` DATETIME DEFAULT NULL,	-- 서버 데이터 생성 일시
  PRIMARY KEY (`pm_conf_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `CLD_NI`;	-- 네트워크 인터페이스 정보 메인 테이블
CREATE TABLE `CLD_NI` (
  `ni_sn` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `vpc_sn` BIGINT(20) UNSIGNED NOT NULL,		-- VPC Main Table SN
  `sub_sn` BIGINT(20) UNSIGNED NOT NULL,		-- SUBNET Main Table SN
  `ni_id` VARCHAR(50) NOT NULL, -- 네트워크 인터페이스 아이디
  `cld_type` INT(1) NOT NULL DEFAULT 1, -- 클라우드 타입 1: AWS, 2: GCP, 3: AZURE / 51: KT, 52: NBP, 53: 가비아 / 100:Legacy
  `del_flag` INT(1) DEFAULT 0, -- 삭제 여부 0.존재 / 1.삭제됨
  `work_dt` DATETIME DEFAULT NULL,	-- 데이터 활동 시간
  PRIMARY KEY (`ni_sn`),
  UNIQUE KEY `ni_id_unique` (`ni_id`),
  INDEX WORK_DT_INDEX(`work_dt`),
  INDEX PK_INDEX(`ni_sn`),
  INDEX VPC_INDEX(`vpc_sn`),
  INDEX SUBNET_INDEX(`sub_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `CLD_NI_DTL`;				-- 네트워크 인터페이스 상세 정보 테이블
CREATE TABLE `CLD_NI_DTL` (
  `ni_sn` BIGINT(20) UNSIGNED NOT NULL,								-- Network Interface Main Table SN
  `ni_dtl_type` VARCHAR(150) NOT NULL, 					-- 인터페이스 타입
  `ni_dtl_desc` VARCHAR(150) NOT NULL, 					-- 네트워크 인터페이스 설명
  `ni_dtl_sour_dest_chk` INT(1) DEFAULT 0, 				-- 소스/대상 확인 여부
  `ni_dtl_owner_id` VARCHAR(30) NOT NULL, 				-- 소유자
  `ni_dtl_priv_dns_nm` VARCHAR(150) DEFAULT "", 			-- 프라이빗 DNS명
  `ni_dtl_priv_ip` VARCHAR(50) NOT NULL, 				-- 프라이빗 아이피 주소
  `ni_dtl_mac` VARCHAR(50) NOT NULL, 					-- MAC 주소
  `ni_dtl_status` VARCHAR(20) NOT NULL, 				-- 인터페이스 상태
  `ni_dtl_az` VARCHAR(50) NOT NULL, 					-- 가용 영역
  `ni_dtl_requester_id` VARCHAR(100) DEFAULT "", 		-- 사용자를 대신하여 인스턴스를 시작한 요청자의 ID (예 : AWS Management Console 또는 Auto Scaling).
  `ni_dtl_requester_managed` INT(1) DEFAULT 0, 			-- 다른 AWS 서비스가 네트워크 인터페이스를 관리하는 경우 true
  PRIMARY KEY (`ni_sn`),
  INDEX PK_INDEX(`ni_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `CLD_NI_PUB_IPS`;	-- 네트워크 인터페이스에 할당된 프라이빗 아이피에 대한  IPv4 퍼블릭 ip 그룹 테이블
CREATE TABLE `CLD_NI_PUB_IPS` (
  `ni_sn` BIGINT(20) UNSIGNED NOT NULL,		-- Network Interface Main Table SN
  `ni_pub_dns_nm` VARCHAR(100) NOT NULL, -- public dns name
  `ni_pub_ip` VARCHAR(50) NOT NULL, -- public ip
  `ni_pub_ip_owner_id` VARCHAR(50) DEFAULT NULL, -- ip 소유자
  `ni_pub_ip_alloc_id` VARCHAR(100) DEFAULT NULL, -- 확인필요
  `ni_pub_ip_assoc_id` VARCHAR(100) DEFAULT NULL, -- ip 연결 아이디
  PRIMARY KEY (`ni_sn`),
  INDEX PK_INDEX(`ni_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `CLD_NI_PRIVIPS`;	-- 네트워크 인터페이스에 할당된 프라이빗 IP 그룹 테이블 (보조 IP를 설정할 경우 IP가 많아진다.)
CREATE TABLE `CLD_NI_PRIVIPS` (
  `ni_priv_sn` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `ni_sn` BIGINT(20) UNSIGNED NOT NULL,		-- Network Interface Main Table SN
  `ni_priv_dns_nm` VARCHAR(100) DEFAULT "", -- private dns nm
  `ni_priv_ip` VARCHAR(50) NOT NULL, -- private ip
  `ni_priv_primary` INT(1) DEFAULT NULL, -- 기본 Private IP 주소 여부
  PRIMARY KEY (`ni_priv_sn`),
  INDEX PK_INDEX(`ni_priv_sn`),
  INDEX NI_INDEX(`ni_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `CLD_NI_PRIVIPS_ASSOCIATIONS`;				-- 보조 프라이빗 아이피들에 대한 IPv4 퍼블릭 ip 그룹 테이블
CREATE TABLE `CLD_NI_PRIVIPS_ASSOCIATIONS` (
  `ni_priv_sn` BIGINT(20) UNSIGNED NOT NULL,								-- Network Interface Main Table SN
  `ni_priv_asso_pub_dns_nm` VARCHAR(150) NOT NULL, 				-- public dns name
  `ni_priv_asso_pub_ip` VARCHAR(50) NOT NULL, 					-- public ip
  `ni_priv_asso_ip_owner_id` VARCHAR(50) NOT NULL, 				-- ip 소유자
  `ni_priv_asso_alloc_id` VARCHAR(100) DEFAULT NULL, 				-- 확인필요
  `ni_priv_asso_assoc_id` VARCHAR(100) DEFAULT NULL, 				-- ip 연결 아이디
  PRIMARY KEY (`ni_priv_sn`),
  INDEX PK_INDEX(`ni_priv_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `CLD_NI_ATTACHMENT`;	-- 네트워크 인터페이스와 호스트 연결 정보 테이블
CREATE TABLE `CLD_NI_ATTACHMENT` (
  `ni_sn` BIGINT(20) UNSIGNED NOT NULL,		-- Network Interface Main Table SN
  `host_sn` BIGINT(20) UNSIGNED NOT NULL,		-- HOST Main Table SN
  `ni_attac_id` VARCHAR(50) NOT NULL, -- 인스턴스에 연결되는 네트워크 인터페이스를 식별하는 ID
  `ni_attac_del_on_tmnt` INT(1) DEFAULT NULL, -- 호스트 연결 종료 시 삭제 설정
  `ni_attac_time` DATETIME DEFAULT NULL, -- 생성 일 시
  `ni_attac_device_index` INT(11) DEFAULT NULL, -- 디바이스 인덱스
  `ni_attac_status` VARCHAR(20) NOT NULL, -- 연결 상태
  `work_dt` DATETIME DEFAULT NULL,	-- 데이터 활동 시간
  PRIMARY KEY (`ni_sn`),
  INDEX PK_INDEX(`ni_sn`),
  INDEX HOST_INDEX(`host_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `CLD_NI_IPV_SIX`;	-- 네트워크 인터페이스에 할당된 Ipv6 정보 그룹 테이블
CREATE TABLE `CLD_NI_IPV_SIX` (
  `ni_sn` BIGINT(20) UNSIGNED NOT NULL,		-- Network Interface Main Table SN
  `ni_ipv_six_addr` VARCHAR(50) NOT NULL, -- Ipv6 address
  PRIMARY KEY (`ni_sn`),
  INDEX PK_INDEX(`ni_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `CLD_NI_SG`;	-- 네트워크 인터페이스에 연결된 SG 그룹 정보
CREATE TABLE `CLD_NI_SG` (
  `ni_sn` BIGINT(20) UNSIGNED NOT NULL,		-- Network Interface Main Table SN
  `sg_sn` BIGINT(20) UNSIGNED NOT NULL,		-- SG Main Table SN
  INDEX NI_INDEX(`ni_sn`),
  INDEX SG_INDEX(`sg_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `CLD_NI_TAG`;		-- 네트워크 인터페이스 태그 테이블
CREATE TABLE `CLD_NI_TAG` (
  `ni_tag_sn` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `ni_sn` BIGINT(20) UNSIGNED NOT NULL,		-- Network Interface Main Table SN
  `ni_tag_key` VARCHAR(256) NOT NULL, -- 태그 키
  `ni_tag_value` VARCHAR(256) NOT NULL, -- 태그 값
  PRIMARY KEY (`ni_tag_sn`),
  INDEX PK_INDEX(`ni_tag_sn`),
  INDEX NI_INDEX(`ni_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `CLD_NACL`;	-- Network ACL 정보 메인 테이블
CREATE TABLE `CLD_NACL` (
  `nacl_sn` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `vpc_sn` BIGINT(20) UNSIGNED NOT NULL,		-- VPC Main Table SN
  `nacl_id` VARCHAR(50) NOT NULL, -- Network ACL 아이디
  `cld_type` INT(1) NOT NULL DEFAULT 1, -- 클라우드 타입 1: AWS, 2: GCP, 3: AZURE / 51: KT, 52: NBP, 53: 가비아 / 100:Legacy
  `del_flag` INT(1) DEFAULT 0, -- 삭제 여부 0.존재 / 1.삭제됨
  `work_dt` DATETIME DEFAULT NULL,	-- 데이터 활동 시간
  PRIMARY KEY (`nacl_sn`),
  UNIQUE KEY `nacl_id_unique` (`nacl_id`),
  INDEX WORK_DT_INDEX(`work_dt`),
  INDEX PK_INDEX(`nacl_sn`),
  INDEX VPC_INDEX(`vpc_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `CLD_NACL_DTL`;		-- Network ACL 상세 정보 테이블
CREATE TABLE `CLD_NACL_DTL` (
  `nacl_sn` BIGINT(20) UNSIGNED NOT NULL,		-- Network ACL Main Table SN
  `nacl_dtl_owner_id` VARCHAR(20) NOT NULL, -- 소유자
  `nacl_dtl_default` INT(1) NOT NULL, -- default 여부
  PRIMARY KEY (`nacl_sn`),
  INDEX PK_INDEX(`nacl_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `CLD_NACL_ASSOCIATIONS`;		-- Network ACL과 서브넷 연결 정보 테이블
CREATE TABLE `CLD_NACL_ASSOCIATIONS` (
  `nacl_sn` BIGINT(20) UNSIGNED NOT NULL,		-- Network ACL Main Table SN
  `sub_sn` BIGINT(20) UNSIGNED NOT NULL,		-- SUBNET Main Table SN
  `nacl_asso_id` VARCHAR(50) NOT NULL, -- 서브넷의 VPC와 연결되는 네트워크 ACL의 ID
  INDEX NACL_INDEX(`nacl_sn`),
  INDEX SUBNET_INDEX(`sub_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `CLD_NACL_TAG`;		-- Network ACL 태그 테이블
CREATE TABLE `CLD_NACL_TAG` (
  `nacl_tag_sn` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `nacl_sn` BIGINT(20) UNSIGNED NOT NULL,		-- Network ACL Main Table SN
  `nacl_tag_key` VARCHAR(256) NOT NULL, -- 태그 키
  `nacl_tag_value` VARCHAR(256) NOT NULL, -- 태그 값
  PRIMARY KEY (`nacl_tag_sn`),
  INDEX PK_INDEX(`nacl_tag_sn`),
  INDEX NACL_INDEX(`nacl_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `CLD_NACL_ENTRIES`;		-- Network ACL 상세 정보 테이블
CREATE TABLE `CLD_NACL_ENTRIES` (
  `nacl_ent_sn` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `nacl_sn` BIGINT(20) UNSIGNED NOT NULL,		-- Network ACL Main Table SN
  `nacl_ent_egress` INT(1) NOT NULL, -- 인/아웃 바운드 유형 1. 아웃바운드 / 2. 인바운드
  `nacl_ent_cidrblock` VARCHAR(20) DEFAULT NULL, -- IPv4 CIDR 범위
  `nacl_ent_ipvsix_cidrblock` VARCHAR(100) DEFAULT '', -- IPv6 CIDR 범위
  `nacl_ent_rule_no` INT(11) NOT NULL, -- 규칙 번호
  `nacl_ent_rule_ac` VARCHAR(10) NOT NULL, -- 트래픽 허용 여부 (allow or deny)
  `nacl_ent_protocol` INT(11) NOT NULL, -- 규칙이 적용되는 IP 프로토콜
  `nacl_ent_to_port` INT(11) DEFAULT NULL, -- UDP/TCP 프로토콜의 출발 포트 번호 범위
  `nacl_ent_from_port` INT(11) DEFAULT NULL, -- UDP/TCP 프로토콜의 도착 포트 번호 범위
  `nacl_ent_icmp_type` INT(11) DEFAULT NULL, -- ICMP Type
  `nacl_ent_icmp_code` INT(11) DEFAULT NULL, -- ICMP Code
  `work_dt` DATETIME DEFAULT NULL,	-- 데이터 활동 시간
  PRIMARY KEY (`nacl_ent_sn`),
  UNIQUE KEY `nacl_sn_nacl_ent_egress_nacl_ent_rule_no` (`nacl_sn`, `nacl_ent_egress`, `nacl_ent_rule_no`),
  INDEX PK_INDEX(`nacl_ent_sn`),
  INDEX NACL_INDEX(`nacl_sn`),
  INDEX NACL_RULE_NO_INDEX(`nacl_ent_rule_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `CLD_NACL_RULE_NAME`;		-- NACL 룰 이름 테이블
CREATE TABLE `CLD_NACL_RULE_NAME` (
  `nacl_sn` BIGINT(20) UNSIGNED NOT NULL,					-- Network ACL Main Table SN
  `nacl_ent_rule_no` INT(11) NOT NULL,			-- 룰 넘버 SN
  `nacl_ent_rule_nm` VARCHAR(50) NOT NULL,		-- 룰 네임
  `nacl_ent_rule_desc` TEXT NOT NULL,			-- 룰 설명
  PRIMARY KEY (`nacl_sn`, `nacl_ent_rule_no`),
  INDEX PK_INDEX(`nacl_sn`, `nacl_ent_rule_no`),
  INDEX NAME_INDEX(`nacl_ent_rule_nm`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `CLD_VPC`;
CREATE TABLE `CLD_VPC` (
  `vpc_sn` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `vpc_id` VARCHAR(50) NOT NULL, -- VPC 아이디
  `cld_type` INT(1) NOT NULL DEFAULT 1, -- 클라우드 타입 1: AWS, 2: GCP, 3: AZURE / 51: KT, 52: NBP, 53: 가비아 / 100:Legacy
  `del_flag` INT(1) DEFAULT 0, -- 삭제 여부 0.존재 / 1.삭제됨
  `work_dt` DATETIME DEFAULT NULL,	-- 데이터 활동 시간
  PRIMARY KEY (`vpc_sn`),
  UNIQUE KEY `vpc_id_unique` (`vpc_id`),
  INDEX WORK_DT_INDEX(`work_dt`),
  INDEX PK_INDEX(`vpc_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `CLD_VPC_DTL`;		-- VPC 상세 정보 테이블
CREATE TABLE `CLD_VPC_DTL` (
  `vpc_sn` BIGINT(20) UNSIGNED NOT NULL,		-- VPC Main Table SN
  `vpc_dtl_default` INT(1) NOT NULL, -- default 여부
  `vpc_dtl_host_tenancy` VARCHAR(20) NOT NULL, -- 태넌시: 실행하고자 하는 전용 호스트
  `vpc_dtl_owner_id` VARCHAR(20) NOT NULL, -- vpc 소유자
  `vpc_dtl_state` VARCHAR(10) NOT NULL, -- vpc 상태
  `vpc_dtl_dhcp_op_id` VARCHAR(20) NOT NULL, -- DHCP 옵션 세트 아이디
  PRIMARY KEY (`vpc_sn`),
  INDEX PK_INDEX(`vpc_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `CLD_VPC_TAG`;		-- VPC 태그 테이블
CREATE TABLE `CLD_VPC_TAG` (
  `vpc_tag_sn` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `vpc_sn` BIGINT(20) UNSIGNED NOT NULL,		-- VPC Main Table SN
  `vpc_tag_key` VARCHAR(256) NOT NULL, -- 태그 키
  `vpc_tag_value` VARCHAR(256) NOT NULL, -- 태그 값
  PRIMARY KEY (`vpc_tag_sn`),
  INDEX PK_INDEX(`vpc_tag_sn`),
  INDEX VPC_INDEX(`vpc_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `CLD_VPC_CIDR`;		-- CIDR 블록 정보 그룹 상세 정보 테이블
CREATE TABLE `CLD_VPC_CIDR` (
  `vpc_sn` BIGINT(20) UNSIGNED NOT NULL,		-- VPC Main Table SN
  `vpc_cidr_type` INT(1) NOT NULL, -- 사이더 블록 타입 1. IPv4 / 2. IPv6
  `vpc_cidr_asso_id` VARCHAR(100) NOT NULL, -- CIDR id
  `vpc_cidr_block` VARCHAR(100) NOT NULL, -- 사이더 블록 상태
  `vpc_cidr_state` VARCHAR(20) NOT NULL, -- 사이더 블록 상태
  `vpc_cidr_state_msg` VARCHAR(100) Default '', -- 사이더 블록 상태 사유
  INDEX PK_INDEX(`vpc_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `CLD_SG`;
CREATE TABLE `CLD_SG` (
  `sg_sn` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `sg_id` VARCHAR(50) NOT NULL, -- Security Group 아이디
  `vpc_sn` BIGINT(20) UNSIGNED NOT NULL,		-- VPC Main Table SN
  `cld_type` INT(1) NOT NULL DEFAULT 1, -- 클라우드 타입 1: AWS, 2: GCP, 3: AZURE / 51: KT, 52: NBP, 53: 가비아 / 100:Legacy
  `del_flag` INT(1) DEFAULT 0, -- 삭제 여부 0.존재 / 1.삭제됨
  `work_dt` DATETIME DEFAULT NULL,	-- 데이터 활동 시간
  PRIMARY KEY (`sg_sn`),
  UNIQUE KEY `sg_id_unique` (`sg_id`),
  INDEX WORK_DT_INDEX(`work_dt`),
  INDEX PK_INDEX(`sg_sn`),
  INDEX VPC_INDEX(`vpc_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `CLD_SG_DTL`;		-- Security Group 상세 정보 테이블
CREATE TABLE `CLD_SG_DTL` (
  `sg_sn` BIGINT(20) UNSIGNED NOT NULL,		-- SG Main Table SN
  `sg_dtl_nm`  VARCHAR(150) NOT NULL, -- 보안 그룹 명
  `sg_dtl_desc` VARCHAR(255) NOT NULL, -- 보안 그룹 설명
  `sg_dtl_owner_id` VARCHAR(20) NOT NULL, -- 보안 그룹 소유자
  PRIMARY KEY (`sg_sn`),
  INDEX PK_INDEX(`sg_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `CLD_SG_EGRESS`;		-- Security Group 정책 정보 테이블
CREATE TABLE `CLD_SG_EGRESS` (
  `sg_er_sn` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `sg_sn` BIGINT(20) UNSIGNED NOT NULL,		-- SG Main Table SN
  `sg_er_ip_protocol` VARCHAR(50) NOT NULL, -- 유형 (ex: tcp, udp)
  `sg_er_from_port` INT(11) DEFAULT NULL, -- 도착 포트 범위
  `sg_er_to_port` INT(11) DEFAULT NULL, -- 시작 포트 범위
  `work_dt` DATETIME DEFAULT NULL,	-- 데이터 활동 시간
  PRIMARY KEY (`sg_er_sn`),
  INDEX PK_INDEX(`sg_er_sn`),
  INDEX SG_INDEX(`sg_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `CLD_SG_INGRESS`;		-- Security Group 정책 정보 테이블
CREATE TABLE `CLD_SG_INGRESS` (
  `sg_in_sn` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `sg_sn` BIGINT(20) UNSIGNED NOT NULL,		-- SG Main Table SN
  `sg_in_ip_protocol` VARCHAR(50) NOT NULL, -- 유형 (ex: tcp, udp)
  `sg_in_from_port` INT(11) DEFAULT NULL, -- 도착 포트 범위
  `sg_in_to_port` INT(11) DEFAULT NULL, -- 시작 포트 범위
  `work_dt` DATETIME DEFAULT NULL,	-- 데이터 활동 시간
  PRIMARY KEY (`sg_in_sn`),
  INDEX PK_INDEX(`sg_in_sn`),
  INDEX SG_INDEX(`sg_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `CLD_SG_EGRESS_DTL`;		-- Security Group 아웃바운드 정책 정보 테이블
CREATE TABLE `CLD_SG_EGRESS_DTL` (
  `sg_er_sn` BIGINT(20) UNSIGNED NOT NULL,		-- SG EGRESS Main Table SN
  `sg_erd_type` INT(1) NOT NULL, -- 아웃 바운드 타입 1. 아웃바운드 IPv4 / 2. 아웃바운드 IPv6 / 3. 아웃바운드 접두사
  `sg_erd_source` VARCHAR(150) NOT NULL, -- IPv4,6,prefix
  `sg_erd_desc` VARCHAR(255) DEFAULT NULL, -- 정책 설명
  `work_dt` DATETIME DEFAULT NULL,	-- 데이터 활동 시간
  INDEX PK_INDEX(`sg_er_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `CLD_SG_INGRESS_DTL`;		-- Security Group 인바운드 정책 정보 테이블
CREATE TABLE `CLD_SG_INGRESS_DTL` (
  `sg_in_sn` BIGINT(20) UNSIGNED NOT NULL,		-- SG INGRESS Main Table SN
  `sg_ind_type` INT(1) NOT NULL, -- 인바운드 타입 1. 인바운드 IPv4 / 2. 인바운드 IPv6 / 3. 인바운드 접두사
  `sg_ind_source` VARCHAR(150) NOT NULL, -- IPv4,6,prefix
  `sg_ind_desc` VARCHAR(255) DEFAULT NULL, -- 정책 설명
  `work_dt` DATETIME DEFAULT NULL,	-- 데이터 활동 시간
  INDEX PK_INDEX(`sg_in_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `CLD_SG_EGRESS_PAIRS`;		-- 사용자 ID그룹에 참조하는 보안 그룹 정보 그룹 정보 테이블 (user Id Group Pairs)
CREATE TABLE `CLD_SG_EGRESS_PAIRS` (
  `sg_er_sn` BIGINT(20) UNSIGNED NOT NULL,		-- SG Main Table SN
  `vpc_sn` BIGINT(20) UNSIGNED NOT NULL,		-- VPC Main Table SN
  `sg_er_pairs_group_id` VARCHAR(50) DEFAULT NULL, -- 연결 그룹 아이디
  `sg_er_pairs_group_nm` VARCHAR(50) DEFAULT NULL, -- 연결 그룹 명
  `sg_er_pairs_peering_status` VARCHAR(50) DEFAULT NULL, -- vpc 피어링 연결 상태
  `sg_er_pairs_user_id` VARCHAR(50) DEFAULT NULL, -- 보안 그룹이 참조하고있는 계정 아이디
  `sg_er_pairs_vpc_peer_conn_id` VARCHAR(50) DEFAULT NULL, -- vpc 피어링 연결 아이디
  `sg_er_pairs_desc` VARCHAR(150) DEFAULT NULL, -- 설명
  `work_dt` DATETIME DEFAULT NULL,	-- 데이터 활동 시간
  INDEX PK_INDEX(`sg_er_sn`),
  INDEX VPC_INDEX(`vpc_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `CLD_SG_INGRESS_PAIRS`;		-- 사용자 ID그룹에 참조하는 보안 그룹 정보 그룹 정보 테이블 (user Id Group Pairs)
CREATE TABLE `CLD_SG_INGRESS_PAIRS` (
  `sg_in_sn` BIGINT(20) UNSIGNED NOT NULL,		-- SG Main Table SN
  `vpc_sn` BIGINT(20) UNSIGNED NOT NULL,		-- VPC Main Table SN
  `sg_in_pairs_group_id` VARCHAR(50) DEFAULT NULL, -- 연결 그룹 아이디
  `sg_in_pairs_group_nm` VARCHAR(50) DEFAULT NULL, -- 연결 그룹 명
  `sg_in_pairs_peering_status` VARCHAR(50) DEFAULT NULL, -- vpc 피어링 연결 상태
  `sg_in_pairs_user_id` VARCHAR(50) DEFAULT NULL, -- 보안 그룹이 참조하고있는 계정 아이디
  `sg_in_pairs_vpc_peer_conn_id` VARCHAR(50) DEFAULT NULL, -- vpc 피어링 연결 아이디
  `sg_in_pairs_desc` VARCHAR(150) DEFAULT NULL, -- 설명
  `work_dt` DATETIME DEFAULT NULL,	-- 데이터 활동 시간
  INDEX PK_INDEX(`sg_in_sn`),
  INDEX VPC_INDEX(`vpc_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `CLD_SG_TAG`;		-- Security Group 태그 테이블
CREATE TABLE `CLD_SG_TAG` (
  `sg_tag_sn` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `sg_sn` BIGINT(20) UNSIGNED NOT NULL,		-- SG Main Table SN
  `sg_tag_key` VARCHAR(256) NOT NULL, -- 태그 키
  `sg_tag_value` VARCHAR(256) NOT NULL, -- 태그 값
  PRIMARY KEY (`sg_tag_sn`),
  INDEX PK_INDEX(`sg_tag_sn`),
  INDEX SG_INDEX(`sg_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `CLD_SUBNET`;
CREATE TABLE `CLD_SUBNET` (
  `sub_sn` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `vpc_sn` BIGINT(20) UNSIGNED NOT NULL,		-- VPC Main Table SN
  `sub_id` VARCHAR(50) NOT NULL, 	-- SUBNET 아이디
  `cld_type` INT(1) NOT NULL DEFAULT 1, -- 클라우드 타입 1: AWS, 2: GCP, 3: AZURE / 51: KT, 52: NBP, 53: 가비아 / 100:Legacy
  `del_flag` INT(1) DEFAULT 0, -- 삭제 여부 0.존재 / 1.삭제됨
  `work_dt` DATETIME DEFAULT NULL,	-- 데이터 활동 시간
  PRIMARY KEY (`sub_sn`),
  UNIQUE KEY `sub_id_unique` (`sub_id`),
  INDEX WORK_DT_INDEX(`work_dt`),
  INDEX PK_INDEX(`sub_sn`),
  INDEX VPC_INDEX(`vpc_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `CLD_SUBNET_DTL`;		-- SUBNET 상세 정보 테이블
CREATE TABLE `CLD_SUBNET_DTL` (
  `sub_sn` BIGINT(20) UNSIGNED NOT NULL,		-- SUBNET Main Table SN
  `sub_dtl_az`  VARCHAR(50) NOT NULL, -- 가용 영역 명
  `sub_dtl_az_id` VARCHAR(50) NOT NULL, -- 가용 영역 아이디 설명
  `sub_dtl_cidr` VARCHAR(50) NOT NULL, -- IPv4 사이더
  `sub_dtl_owner_id` VARCHAR(20) NOT NULL, -- 서브넷 소유자
  `sub_dtl_state` VARCHAR(10) NOT NULL, -- 서브넷 상태
  `sub_dtl_arn` VARCHAR(100) NOT NULL, -- 서브넷의 Amazon Resource Name
  `sub_dtl_map_pub_ip_launch` INT(1) NOT NULL, -- 퍼블릭 IPv4 주소 자동 할당
  `sub_dtl_avaliaddr_count` INT(11) NOT NULL, -- 사용 가능한 IPv4 주소
  `sub_dtl_ipvsix_addr_creat` INT(1) NOT NULL, -- 자동 할당 IPv6 주소
  `sub_dtl_default` INT(1) NOT NULL, -- Default 여부
  PRIMARY KEY (`sub_sn`),
  INDEX PK_INDEX(`sub_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `CLD_SUBNET_IPVSIX`;		-- SUBNET  IPv6 CIDR 블록 정보 테이블
CREATE TABLE `CLD_SUBNET_IPVSIX` (
  `sub_sn` BIGINT(20) UNSIGNED NOT NULL,		-- SUBNET Main Table SN
  `sub_six_asso_id`  VARCHAR(100) NOT NULL, -- IPv6 CIDR 블록 - CIDR
  `sub_six_block` VARCHAR(50) NOT NULL, -- IPv6 CIDR 블록 - 상태
  `sub_six_state` VARCHAR(50) NOT NULL, -- IPv6 CIDR 블록 - 상태 사유
  PRIMARY KEY (`sub_sn`),
  INDEX PK_INDEX(`sub_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `CLD_SUBNET_TAG`;		-- SUBNET 태그 테이블
CREATE TABLE `CLD_SUBNET_TAG` (
  `sub_tag_sn` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `sub_sn` BIGINT(20) UNSIGNED NOT NULL,		-- SUBNET Main Table SN
  `sub_tag_key` VARCHAR(256) NOT NULL, -- 태그 키
  `sub_tag_value` VARCHAR(256) NOT NULL, -- 태그 값
  PRIMARY KEY (`sub_tag_sn`),
  INDEX PK_INDEX(`sub_tag_sn`),
  INDEX SUBNET_INDEX(`sub_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `CLD_ROUTE`;
CREATE TABLE `CLD_ROUTE` (
  `route_sn` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `vpc_sn` BIGINT(20) UNSIGNED NOT NULL,		-- VPC Main Table SN
  `route_id` VARCHAR(50) NOT NULL,  -- ROUTE 아이디
  `cld_type` INT(1) NOT NULL DEFAULT 1, -- 클라우드 타입 1: AWS, 2: GCP, 3: AZURE / 51: KT, 52: NBP, 53: 가비아 / 100:Legacy
  `route_owner_id` VARCHAR(20) NOT NULL, -- 라우트 소유자
  `del_flag` INT(1) DEFAULT 0, -- 삭제 여부 0.존재 / 1.삭제됨
  `work_dt` DATETIME DEFAULT NULL,	-- 데이터 활동 시간
  PRIMARY KEY (`route_sn`),
  UNIQUE KEY `route_id_unique` (`route_id`),
  INDEX WORK_DT_INDEX(`work_dt`),
  INDEX PK_INDEX(`route_sn`),
  INDEX VPC_INDEX(`vpc_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `CLD_ROUTE_INFO`;		--  라우트별 정보 그룹 테이블
CREATE TABLE `CLD_ROUTE_INFO` (
  `route_sn` BIGINT(20) UNSIGNED NOT NULL,		-- ROUTE Main Table SN
  `host_sn` VARCHAR(50) NOT NULL, -- VPC에 있는 NAT 인스턴스의 아이디
  `ni_sn` VARCHAR(50) NOT NULL, -- 라우팅을 허용하는 네트워크 인터페이스 아이디
  `route_info_dest_cidrblock` VARCHAR(50) DEFAULT NULL, -- 대상 일치에 사용되는 IPv4 CIDR 주소 블록
  `route_info_dest_six_cidrblock` VARCHAR(100) DEFAULT NULL, -- 대상 일치에 사용되는 IPv6 CIDR 주소 블록
  `route_info_dest_prefix` VARCHAR(50) DEFAULT NULL, -- 대상 일치에 사용되는 접두사 목록 아이디
  `route_info_egress_gw_id` VARCHAR(50) DEFAULT NULL, -- VPC에 연결되는 외부 전용 인터넷 게이트웨이 아이디
  `route_info_gw_id` VARCHAR(50) DEFAULT NULL, -- VPC에 연결된 인터넷 게이트웨이 또는 가상 프라이빗 게이트웨이의 아이디
  `route_host_owner_id` VARCHAR(20) DEFAULT NULL, -- 호스트 소유자
  `route_info_nat_gw_id` VARCHAR(50) DEFAULT NULL, -- NAT 게이트웨이의 아이디
  `route_info_origin` VARCHAR(50) NOT NULL, -- 라우팅 경로가 작성된 방법을 설명
  `route_info_state` VARCHAR(50) NOT NULL, -- 라우팅 상태
  `route_info_trans_gw_id` VARCHAR(50) DEFAULT NULL, -- AWS Transit Gateway 아이디
  `route_info_vpc_peer_conn_id` VARCHAR(50) DEFAULT NULL, -- VPC 피어링 연결 아이디
  INDEX PK_INDEX(`route_sn`),
  INDEX HOST_INDEX(`host_sn`),
  INDEX NI_INDEX(`ni_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `CLD_ROUTE_ASSOCIATIONS`;		--  라우팅 테이블과 서브넷 간의 연결 정보 테이블
CREATE TABLE `CLD_ROUTE_ASSOCIATIONS` (
  `route_sn` BIGINT(20) UNSIGNED NOT NULL,		-- ROUTE Main Table SN
  `sub_sn` BIGINT(20) UNSIGNED NOT NULL, -- 연결된 서브넷 sn
  `route_asso_id` VARCHAR(50) NOT NULL, -- 라우팅 테이블과 서브넷 간의 연결 아이디
  `route_asso_default` INT(1) NOT NULL, -- Default 여부
  INDEX ROUTE_INDEX(`route_sn`),
  INDEX SUBNET_INDEX(`sub_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `CLD_ROUTE_VGW`;		--  라우팅 전파 정보 그룹 테이블 (Virtual Gate Way)
CREATE TABLE `CLD_ROUTE_VGW` (
  `route_sn` BIGINT(20) UNSIGNED NOT NULL,		-- ROUTE Main Table SN
  `route_vgw_id` VARCHAR(50) NOT NULL, -- 가상 프라이빗 게이트웨이 아이디
  INDEX ROUTE_INDEX(`route_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `CLD_ROUTE_TAG`;		-- ROUTE 태그 테이블
CREATE TABLE `CLD_ROUTE_TAG` (
  `route_tag_sn` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `route_sn` BIGINT(20) UNSIGNED NOT NULL,		-- ROUTE Main Table SN
  `route_tag_key` VARCHAR(256) NOT NULL, -- 태그 키
  `route_tag_value` VARCHAR(256) NOT NULL, -- 태그 값
  PRIMARY KEY (`route_tag_sn`),
  INDEX PK_INDEX(`route_tag_sn`),
  INDEX ROUTE_INDEX(`route_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `CLD_VOLUME`;
CREATE TABLE `CLD_VOLUME` (
  `vol_sn` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `vol_id` VARCHAR(50) NOT NULL, -- VOLUME 아이디
  `cld_type` INT(1) NOT NULL DEFAULT 1, -- 클라우드 타입 1: AWS, 2: GCP, 3: AZURE / 51: KT, 52: NBP, 53: 가비아 / 100:Legacy
  `del_flag` INT(1) DEFAULT 0, -- 삭제 여부 0.존재 / 1.삭제됨
  `work_dt` DATETIME DEFAULT NULL,	-- 데이터 활동 시간
  PRIMARY KEY (`vol_sn`),
  UNIQUE KEY `vol_id_unique` (`vol_id`),
  INDEX WORK_DT_INDEX(`work_dt`),
  INDEX PK_INDEX(`vol_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `CLD_VOLUME_DTL`;		--  VOLUME 상세 정보 테이블
CREATE TABLE `CLD_VOLUME_DTL` (
  `vol_sn` BIGINT(20) UNSIGNED NOT NULL,		-- ROUTE Main Table SN
  `vol_dtl_az` VARCHAR(50) NOT NULL, -- 가용 영역
  `vol_dtl_create_time` DATETIME DEFAULT NULL, -- 생성 완료 시간
  `vol_dtl_encrypted` INT(1) NOT NULL, -- 암호화 여부
  `vol_dtl_kms_id` VARCHAR(50) DEFAULT NULL, -- KMS 키 아이디: 데이터 암호화 아이디
  `vol_dtl_size` INT(11) NOT NULL, -- 볼륨 크기
  `vol_dtl_snapshot_id` VARCHAR(50) NOT NULL, -- 볼륨 스냅샷 아이디
  `vol_dtl_state` VARCHAR(20) NOT NULL, -- 볼륨 상태
  `vol_dtl_iops` INT(11) NOT NULL, -- I/O 작업 수: 볼륨이 지원할 수 있는 요청된 초당 I/O 작업 수
  `vol_dtl_type` VARCHAR(20) NOT NULL, -- 볼륨 유형 : 볼륨이 표준(마그네틱), gp2(범용(SSD)) 또는 io1(프로비저닝된 IOPS(SSD)) 볼륨인지를 나타냅니다
  INDEX PK_INDEX(`vol_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `CLD_VOLUME_ATTACHMENT`;		-- VOLUME과 호스트 연결 정보 테이블
CREATE TABLE `CLD_VOLUME_ATTACHMENT` (
  `vol_sn` BIGINT(20) UNSIGNED NOT NULL,		-- ROUTE Main Table SN
  `host_sn` BIGINT(20) UNSIGNED NOT NULL, -- 연결 호스트 sn
  `vol_attac_device` VARCHAR(50) NOT NULL, -- 디바이스 경로
  `vol_attac_state` VARCHAR(50) NOT NULL, -- 볼륨 상태
  `vol_attac_time` DATETIME DEFAULT NULL, -- 호스트 연결 시간
  `vol_attac_del_on_tmnt` INT(1) NOT NULL, -- 볼륨 종료 시 삭제 설정
  PRIMARY KEY (`vol_sn`, `host_sn`),
  INDEX VOLUME_INDEX(`vol_sn`),
  INDEX HOST_INDEX(`host_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `CLD_VOLUME_TAG`;		-- VOLUME 태그 테이블
CREATE TABLE `CLD_VOLUME_TAG` (
  `vol_tag_sn` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `vol_sn` BIGINT(20) UNSIGNED NOT NULL,		-- ROUTE Main Table SN
  `vol_tag_key` VARCHAR(256) NOT NULL, -- 태그 키
  `vol_tag_value` VARCHAR(256) NOT NULL, -- 태그 값
  PRIMARY KEY (`vol_tag_sn`),
  INDEX PK_INDEX(`vol_tag_sn`),
  INDEX VOLUME_INDEX(`vol_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- FW TEMPLATE START
DROP TABLE IF EXISTS `CLD_NACL_TEMPLATE`;
CREATE TABLE `CLD_NACL_TEMPLATE` (
	`nacl_temp_sn` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
    `nacl_temp_id` VARCHAR(50) DEFAULT NULL, 	-- 템플릿 ID
    `nacl_temp_desc` VARCHAR(255) DEFAULT NULL, -- 설명
    `work_dt` DATETIME DEFAULT NULL,			-- 서버 데이터 생성 일시
    PRIMARY KEY (`nacl_temp_sn`),
    INDEX PK_INDEX(`nacl_temp_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `CLD_NACL_TEMPLATE_GROUP`;
CREATE TABLE `CLD_NACL_TEMPLATE_GROUP` (
	`nacl_temp_group_sn` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
	`nacl_temp_sn` BIGINT(20) UNSIGNED NOT NULL,
	`group_cd` BIGINT(20) UNSIGNED NOT NULL,				-- 회사 코드
    PRIMARY KEY (`nacl_temp_group_sn`),
    UNIQUE KEY `nacl_group_cd_temp_id_unique` (`group_cd`, `nacl_temp_sn`),
    INDEX PK_INDEX(`nacl_temp_group_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `CLD_NACL_TEMPLATE_ENTRIES`;
CREATE TABLE `CLD_NACL_TEMPLATE_ENTRIES` (
  `nacl_temp_ent_sn` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `nacl_temp_sn` BIGINT(20) UNSIGNED NOT NULL,		-- Network ACL Main Table SN
  `nacl_temp_ent_egress` INT(1) NOT NULL, -- 인/아웃 바운드 유형 1. 아웃바운드 / 2. 인바운드
  `nacl_temp_ent_cidrblock` VARCHAR(20) DEFAULT NULL, -- IPv4 CIDR 범위
  `nacl_temp_ent_ipvsix_cidrblock` VARCHAR(100) DEFAULT '', -- IPv6 CIDR 범위
  `nacl_temp_ent_rule_no` INT(11) NOT NULL, -- 규칙 번호
  `nacl_temp_ent_rule_ac` VARCHAR(10) NOT NULL, -- 트래픽 허용 여부 (allow or deny)
  `nacl_temp_ent_protocol` INT(11) NOT NULL, -- 규칙이 적용되는 IP 프로토콜
  `nacl_temp_ent_to_port` INT(11) DEFAULT NULL, -- UDP/TCP 프로토콜의 출발 포트 번호 범위
  `nacl_temp_ent_from_port` INT(11) DEFAULT NULL, -- UDP/TCP 프로토콜의 도착 포트 번호 범위
  `nacl_temp_ent_icmp_code` INT(11) DEFAULT NULL, -- ICMP Type Code
  -- `work_dt` DATETIME DEFAULT NULL,	-- 데이터 활동 시간 (20200115 삭제)
  PRIMARY KEY (`nacl_temp_ent_sn`),
  INDEX PK_INDEX(`nacl_temp_ent_sn`),
  INDEX NACL_TEMP_INDEX(`nacl_temp_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `CLD_SG_TEMPLATE`;
CREATE TABLE `CLD_SG_TEMPLATE` (
	`sg_temp_sn` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
    `sg_temp_id` VARCHAR(50) DEFAULT NULL, -- 템플릿 ID
    `sg_temp_desc` VARCHAR(255) DEFAULT NULL, -- 설명
    `work_dt` DATETIME DEFAULT NULL,	-- 서버 데이터 생성 일시
    PRIMARY KEY (`sg_temp_sn`),
    UNIQUE KEY `host_temp_id_unique` (`sg_temp_id`),
    INDEX PK_INDEX(`sg_temp_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `CLD_SG_TEMPLATE_GROUP`;
CREATE TABLE `CLD_SG_TEMPLATE_GROUP` (
	`sg_temp_group_sn` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
	`sg_temp_sn` BIGINT(20) UNSIGNED NOT NULL,
	`group_cd` BIGINT(20) UNSIGNED NOT NULL,				-- 회사 코드
    PRIMARY KEY (`sg_temp_group_sn`),
    UNIQUE KEY `sg_group_cd_temp_id_unique` (`group_cd`, `sg_temp_sn`),
    INDEX PK_INDEX(`sg_temp_group_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `CLD_SG_TEMPLATE_ENTRIES`;
CREATE TABLE `CLD_SG_TEMPLATE_ENTRIES` (
  `sg_temp_ent_sn` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `sg_temp_sn` BIGINT(20) UNSIGNED NOT NULL,		-- SG Main Table SN
  `sg_temp_ent_egress` INT(1) NOT NULL, -- 인/아웃 바운드 유형 1. 인바운드 / 2. 아웃바운드
  `sg_temp_ent_ip_protocol` VARCHAR(50) NOT NULL, -- 유형 (ex: tcp, udp)
  `sg_temp_ent_from_port` INT(11) DEFAULT NULL, -- 도착 포트 범위
  `sg_temp_ent_to_port` INT(11) DEFAULT NULL, -- 시작 포트 범위
  -- `sg_temp_erd_type` INT(1) NOT NULL, -- 아웃 바운드 타입 1. 아웃바운드 IPv4 / 2. 아웃바운드 IPv6 / 3. 아웃바운드 접두사 (20200115 삭제)
  `sg_temp_ent_source` VARCHAR(150) NOT NULL, -- IPv4,6,prefix
  `sg_temp_ent_desc` VARCHAR(255) DEFAULT NULL, -- 정책 설명
  -- `work_dt` DATETIME DEFAULT NULL,	-- 데이터 활동 시간 (20200115 삭제)
  PRIMARY KEY (`sg_temp_ent_sn`),
  INDEX PK_INDEX(`sg_temp_ent_sn`),
  INDEX SG_INDEX(`sg_temp_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `CLD_HOST_TEMPLATE`;
CREATE TABLE `CLD_HOST_TEMPLATE`(
	`host_temp_sn` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
    `host_temp_id` VARCHAR(50) DEFAULT NULL, -- 템플릿 ID
    `temp_desc` VARCHAR(255) DEFAULT NULL, -- 설명
    `work_dt` DATETIME DEFAULT NULL,	-- 서버 데이터 생성 일시
    PRIMARY KEY (`host_temp_sn`),
    UNIQUE KEY `host_temp_id_unique` (`host_temp_id`),
    INDEX PK_INDEX(`host_temp_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `CLD_HOST_TEMPLATE_ENTRIES`;
CREATE TABLE `CLD_HOST_TEMPLATE_ENTRIES`(
  `host_temp_dtl_sn` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `host_temp_sn` BIGINT(20) UNSIGNED NOT NULL,		-- FW Main Table SN
  `host_temp_dtl_nm` VARCHAR(50) NOT NULL, -- 방화벽 정책 이름
  `host_temp_dtl_rule_num` INT(11) DEFAULT NULL, -- 룰 넘버
  `host_temp_dtl_type` INT(11) NOT NULL DEFAULT 0, -- 정책 타입  1.HOST, 2. 예제
  `host_temp_dtl_direct` INT(1) NOT NULL DEFAULT 0, -- 방향 0. in, 1. out
  `host_temp_dtl_use_flag` INT(1) NOT NULL DEFAULT 0, -- 사용여부
  `host_temp_dtl_action` INT(1) NOT NULL DEFAULT 0, -- 행위 0: Deny, 1: Allow
  `host_temp_dtl_log_lv` INT(1) NOT NULL DEFAULT 0, -- 0: No, 1: Info, 2: Warn, 3: Error, 4: Critical, 5: Fault, 7: Debug
  `host_temp_dtl_protocol` INT(11) NOT NULL DEFAULT 0, -- 프로토콜 0:All, 1 : TCP&UDP, 2:ICMP 6:TCP, 17:UDP
  `host_temp_dtl_port_src` VARCHAR(20) NOT NULL, -- 출발지 포트
  `host_temp_dtl_port_dst` VARCHAR(20) NOT NULL, -- 목적지 포트
  `host_temp_dtl_ip_src` VARCHAR(40) NOT NULL, -- 출발지 주소
  `host_temp_dtl_ip_dst` VARCHAR(40) NOT NULL, -- 목적지 주소
  `host_temp_dtl_schedule_flag` INT(1) NOT NULL, -- 스케쥴 사용 여부 (사용할 경우 스케쥴 테이블에 정보 생성)
  `work_dt` DATETIME DEFAULT NULL,	-- 서버 데이터 생성 일시
  PRIMARY KEY (`host_temp_dtl_sn`),
  INDEX PK_INDEX(`host_temp_dtl_sn`),
  INDEX FW_INDEX(`host_temp_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
-- FW TEMPLATE END

-- 20191218 추가함

-- 20191218 추가함
DROP TABLE IF EXISTS `mgr_mon_compare`;
CREATE TABLE `mgr_mon_compare` (
	`mon_compare_sn` BIGINT(20) UNSIGNED AUTO_INCREMENT COMMENT '모니터링비교번호',
	`mon_compare_nm` VARCHAR(1024) NOT NULL COMMENT '모니티링비교이름',
  `mon_compare_item` INT UNSIGNED NOT NULL COMMENT '모니티링비교측정항목(1:cpu사용률,2:mem사용률,3:DISK사용률,4:SWAP사용률,5:TrafficIn,6:TrafficOut)',
  `compare_host_sns` VARCHAR(1024) NOT NULL COMMENT '모니티링비교대상호스트목록(,로분리한호스트번호목록,최대4개:hostSn1,hostSn2,hostSn3,hostSn4)',
	`work_dt` DATETIME NOT NULL COMMENT '등록일자',
	`mgr_id` VARCHAR(50) NOT NULL COMMENT '등록관리자',
	`mod_dt` DATETIME  COMMENT '변경일자',
	`mod_mgr_id` VARCHAR(50)  COMMENT '변경관리자',
	PRIMARY KEY (`mon_compare_sn`),
	INDEX idx_mon_compare_dt(`work_dt`),
  INDEX idx_mon_compare_id(`mgr_id`)
) ENGINE = InnoDB CHARACTER SET UTF8 COMMENT = '모니터링비교';


-- 20200102 추가함
drop table if exists astron.mgr_rc_memo;
create table astron.mgr_rc_memo (
memo_no BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '메모번호'
,rc_type INT UNSIGNED NOT NULL COMMENT '자산구분(HOST=6, NFW=3, SG=5)'
,rc_sn INT UNSIGNED NOT NULL COMMENT '자산번호(HOST, NFW, SG 번호)'
,memo VARCHAR(4000) NOT NULL COMMENT '메모'
,reg_mgr_id VARCHAR(50) NOT NULL COMMENT '등록관리자'
,reg_dt DATETIME NOT NULL COMMENT '등록일시'
)
ENGINE = INNODB CHARACTER SET UTF8 COMMENT = '자산메모';

CREATE  INDEX idx_rc_memo_at ON astron.mgr_rc_memo(reg_dt);
CREATE  INDEX idx_rc_memo_rc ON astron.mgr_rc_memo(rc_type, rc_sn);


DROP TABLE IF EXISTS `CLD_HOST_ALARM`;
CREATE TABLE `CLD_HOST_ALARM` (
    host_alarm_sn   BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'HOST 알람번호',
    host_sn         BIGINT(20) UNSIGNED NOT NULL COMMENT 'HOST번호',
    alarm_maj       TINYINT UNSIGNED NOT NULL COMMENT '알람주ID(11:시스템)',
    alarm_min       TINYINT UNSIGNED NOT NULL COMMENT '알람부ID(1:CPU,2:MEMORY,3:SWAP,4:DISK,5:DISK MOUNT,6:NETWORK, 7:PROCESS 8: PORT BIND, 91: URL, 92: PING)',
    alarm_level     TINYINT UNSIGNED NOT NULL COMMENT '알람등급(2:위험CRITICAL,4:주의WARNING)',
    alarm_at        DATETIME NOT NULL COMMENT '알람발생시각(ALARM_SYSM.DATETIME)',
    first_alarm_at  DATETIME NOT NULL COMMENT '최초알람일시',
    critical_cnt    INT UNSIGNED NOT NULL COMMENT '위험알람 수',
    warn_cnt        INT UNSIGNED NOT NULL COMMENT '주의알람 수',
    clear_dt        DATETIME NOT NULL COMMENT '복구일시',
    PRIMARY KEY (`host_alarm_sn`),
    INDEX PK_INDEX(`host_sn`,`alarm_at`),
    INDEX ALARM_AT_INDEX(`alarm_at`),
    INDEX CLEAR_DT(`clear_dt`),
    INDEX FIRST_ALARM_AT(`first_alarm_at`),
    UNIQUE KEY `cld_host_alarm_unique` (`host_sn`, `alarm_maj`, `alarm_min`, `first_alarm_at`)
) ENGINE = INNODB CHARACTER SET UTF8 COMMENT = '호스트알람';

DROP TABLE IF EXISTS `LOG_IAM_LOAD_FAIL`;
CREATE TABLE `LOG_IAM_LOAD_FAIL` (
  `log_sn` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `iam_sn` BIGINT(20) UNSIGNED NOT NULL,
  `group_cd` BIGINT(20) UNSIGNED NOT NULL,						-- 회사 코드
  `iam_cld_type` INT(11) NOT NULL,					-- 계정의 클라우드 타입 1: AWS, 2: GCP, 3: AZURE / 51: KT, 52: NBP, 53: 가비아 / 100:Legacy
  `profile_id` VARCHAR(64) NOT NULL,				-- 프로필 아이디
  `regions` VARCHAR(50) NOT NULL,					-- 계정이 생성된 리전 *필수 (us-east, us-west등등)
  `work_dt` DATETIME DEFAULT NULL,
  PRIMARY KEY (`log_sn`),
  INDEX PK_INDEX(`log_sn`),
  INDEX WORK_DT_INDEX(`work_dt`)
) ENGINE=INNODB DEFAULT CHARSET=UTF8;

-- (자산이 삭제되면 생성/삭제 빼고 변경 이력은 전부 삭제한다. 연계방법: rc_id + chg_type + rc_type 으로 한다. HOST인 경우삭제대상이 HFW, SW이다.)
-- (NACL/SG 자산이 삭제된 경우 이력테이블의 생성/삭제 기록빼고 다 삭제한다)
-- TODO: 몽고DB의 자산정보도 삭제가 되어야한다.
DROP TABLE IF EXISTS `MGR_CHG_RC_LOG_DESC`;		-- 클라우드 자산 규칙 변동(생성) 로그 (desc: 인바운드 규칙변화 1로우, 아웃바운드 규칙변화 1로우 되도록 한다)
CREATE TABLE `MGR_CHG_RC_LOG_DESC` (
  `log_mgr_sn` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `cld_type` INT(1) NOT NULL DEFAULT 1, 		-- 클라우드 타입 1: AWS, 2: GCP, 3: AZURE / 51: KT, 52: NBP, 53: 가비아 / 100:Legacy
  `rc_id` VARCHAR(50) NOT NULL,					-- 자산 ID (오토스케일링 그룹명도 같이 포함한다)
  `rc_tag_value` VARCHAR(256) DEFAULT '',			-- 자산 태그 (NACL 태그값, SG 태그값)
  `vpc_id` VARCHAR(50) DEFAULT NULL,				-- VPC ID
  `vpc_tag_value` VARCHAR(256) DEFAULT '',			-- VPC 태그 값
  `group_cd` BIGINT(20) UNSIGNED NOT NULL,				    -- GROUP CD
  `group_nm` VARCHAR(50) NOT NULL,				-- 그룹명
  `host_dtl_type` VARCHAR(20) DEFAULT NULL,		-- 스토리지 유형
  `host_nw_private_ip_addr` VARCHAR(20) DEFAULT NULL, -- 호스트 프라이빗 아이피
  `host_nw_public_ip_addr` VARCHAR(20) DEFAULT NULL, -- 호스트 퍼블릭 아이피
  `action_type` VARCHAR(20) NOT NULL,			-- 1: astron, 2: console
  `rc_type` INT(11) NOT NULL,					-- 자산 타입 3: NACL, 5: SG, 6: HOST, 10. AutoScaling, 11: HFW, 12: SW(최초 이후의 변경항목만 추가한다)
  `regions` VARCHAR(50) NOT NULL,				-- 클라우드 계정 번호
  `chg_type` INT(1) NOT NULL,				    -- 1: 생성, 2: 삭제, 3: 변경
  `chg_desc` TEXT NOT NULL,				        -- 상세내용 (변경이력정리.xls 참고)
  `sub_dtl_az` VARCHAR(50) DEFAULT NULL, 			-- 가용 영역
  `sub_id` VARCHAR(50) DEFAULT NULL, 	        -- SUBNET 아이디
  `sub_tag_value` VARCHAR(256) DEFAULT '',     -- SUBNET 태그 값
  `rc_chg_cnt` INT(11) DEFAULT 0, 	    		-- 자산변동 카운트 (이전카운트 비교하여 카운트한다. 정책 변경 CNT (NACL, SG, HFW), 오토스케일링)
  `last_dt` BIGINT(13) UNSIGNED DEFAULT 0,		-- 오토스케일링 = 마지막으로 읽은 활동 기록 시간
  `work_dt` DATETIME DEFAULT NULL,				-- 데이터 생성 일시
  primary key(`log_mgr_sn`),
  INDEX PK_INDEX(`log_mgr_sn`),
  INDEX TIME_INDEX(`work_dt`)
)ENGINE=INNODB DEFAULT CHARSET=UTF8;

DROP TABLE IF EXISTS `CLD_AUTOSCALING`;		-- 오토스케일링 메인 테이블
CREATE TABLE `CLD_AUTOSCALING` (
  `auto_sn` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `iam_sn` BIGINT(20) UNSIGNED NOT NULL,
  `auto_group_nm` VARCHAR(200) NOT NULL, -- 오토스케일링 그룹명
  `del_flag` INT(1) DEFAULT 0, -- 삭제 여부 0.존재 / 1.삭제됨
  `work_dt` DATETIME DEFAULT NULL,	-- 서버 데이터 생성 일시
  PRIMARY KEY (`auto_sn`),
  UNIQUE KEY `auto_nm_unique` (`auto_group_nm`),
  INDEX WORK_DT_INDEX(`work_dt`),
  INDEX PK_INDEX(`auto_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `CLD_AUTOSCALING_DTL`;		-- 오토스케일링 메인 테이블
CREATE TABLE `CLD_AUTOSCALING_DTL` (
  `auto_sn` BIGINT(20) UNSIGNED NOT NULL,
  `auto_dtl_group_arn` VARCHAR(200) DEFAULT '', -- Auto Scaling 그룹의 Amazon 리소스 이름
  `auto_dtl_health_type` VARCHAR(20) DEFAULT '', --  오토스케일링 그룹 구성 시 상태를 확인할 타입, 유효한 값 EC2, ELB
  `auto_dtl_launch_conf_nm` VARCHAR(200) DEFAULT '', -- 연관된 시작 구성 명 (템플릿 명)
  `auto_dtl_placement` VARCHAR(200) DEFAULT '', -- 인스턴스를 시작할 배치 그룹 명 (있는 경우).
  `auto_dtl_role_arn` VARCHAR(200) DEFAULT '', -- Auto Scaling 그룹이 사용자를 대신하여 다른 AWS 서비스를 호출하는 데 사용하는 서비스 연결 역할의 Amazon 리소스 이름
  `auto_dtl_del_status` VARCHAR(200) DEFAULT '', -- DeleteAutoScalingGroup 이 진행 중일 때 그룹의 현재 상태입니다.
  `auto_dtl_create_dt` VARCHAR(100) DEFAULT '', -- 오토스케일링 그룹 생성 시간
  `auto_dtl_default_cooldown` int(20) DEFAULT 0, -- 스케일링 활동이 완료된 후 다른 스케일링 활동을 시작할 수있는 시간 (초)
  `auto_dtl_desired_capacity` int(11) DEFAULT 0, -- 목표 용량
  `auto_dtl_grace_period` int(200) DEFAULT 0, -- 상태 검사 유예 기간 health Check Grace Period
  `auto_dtl_launch_temp` VARCHAR(200) DEFAULT '', -- 그룹의 시작 템플릿
  `auto_dtl_max_size` int(11) DEFAULT 0, -- 최대 인스턴스 사이즈
  `auto_dtl_min_size` int(11) DEFAULT 0, -- 최소 인스턴스 사이즈
  `auto_dtl_protected` int(1) DEFAULT 0, -- 1.보호안함, 2.보호 / 확장시 새로 시작된 인스턴스가 Amazon EC2 Auto Scaling에 의해 종료되지 않도록 보호되는지 여부
  PRIMARY KEY (`auto_sn`),
  INDEX PK_INDEX(`auto_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `CLD_AUTOSCALING_LOADBALANCE`;		-- 오토스케일링 로드 벨런스
CREATE TABLE `CLD_AUTOSCALING_LOADBALANCE` (
  `lb_sn` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `auto_sn` BIGINT(20) UNSIGNED NOT NULL,
  `lb_nm` VARCHAR(200) NOT NULL, -- 클래식 로드 밸런스명
  `work_dt` DATETIME DEFAULT NULL,	-- 서버 데이터 생성 일시
  PRIMARY KEY (`lb_sn`),
  UNIQUE KEY `lb_unique` (`auto_sn`, `lb_nm`),
  INDEX PK_INDEX(`lb_sn`),
  INDEX WORK_DT_INDEX(`work_dt`),
  INDEX MAIN_INDEX(`auto_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `CLD_AUTOSCALING_HOST`;		-- 오토스케일링에서 실행중인 인스턴스
CREATE TABLE `CLD_AUTOSCALING_HOST` (
  `auto_sn` BIGINT(20) UNSIGNED NOT NULL,
  `host_sn` BIGINT(20) UNSIGNED NOT NULL,
  `ah_health_status` VARCHAR(100) DEFAULT '', -- 인스턴스의 마지막으로보고 된 상태
  `ah_az` VARCHAR(50) DEFAULT '', -- 인스턴스의 가용 영역
  `ah_lifecycle_status` VARCHAR(100) DEFAULT '', -- 현재 수명주기 상태에 대한 설명
  `ah_launch_conf_nm` VARCHAR(200) DEFAULT '', -- 연관된 시작 구성 명 (템플릿 명)
  `ah_protected` int(1) DEFAULT 0, -- 1.보호안함, 2.보호 / 확장시 인스턴스가 Amazon EC2 Auto Scaling에 의해 종료되지 않도록 보호 여부
  PRIMARY KEY (`auto_sn`, `host_sn`),
  INDEX MAIN_INDEX(`auto_sn`, `host_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `CLD_AUTOSCALING_SUBNET`;		-- 오토스케일링에 구성된 서브넷
CREATE TABLE `CLD_AUTOSCALING_SUBNET` (
  `auto_sn` BIGINT(20) UNSIGNED NOT NULL,
  `sub_sn` BIGINT(20) UNSIGNED NOT NULL,
  PRIMARY KEY (`auto_sn`, `sub_sn`),
  INDEX MAIN_INDEX(`auto_sn`, `sub_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `CLD_AUTOSCALING_METRIC`;		-- 오토스케일링 모니터링
CREATE TABLE `CLD_AUTOSCALING_METRIC` (
  `auto_sn` BIGINT(20) UNSIGNED NOT NULL,
  `metric_nm` VARCHAR(150) DEFAULT '', -- 클래식 로드 밸런스명
  `metric_granularity` VARCHAR(50) DEFAULT '', -- 클래식 로드 밸런스명
  `work_dt` DATETIME DEFAULT NULL,	-- 서버 데이터 생성 일시
  PRIMARY KEY (`auto_sn`, `metric_nm`),
  INDEX PK_INDEX(`auto_sn`),
  INDEX WORK_DT_INDEX(`work_dt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `CLD_AUTOSCALING_TARGET_ARN`;		-- 오토스케일링 로드 밸런서 대상 그룹의 Amazon 리소스 정보 테이블
CREATE TABLE `CLD_AUTOSCALING_TARGET_ARN` (
  `auto_sn` BIGINT(20) UNSIGNED NOT NULL,
  `arn_nm` VARCHAR(250) DEFAULT '', --  Amazon 리소스 이름
  `work_dt` DATETIME DEFAULT NULL,	-- 서버 데이터 생성 일시
  PRIMARY KEY (`auto_sn`, `arn_nm`),
  INDEX PK_INDEX(`auto_sn`),
  INDEX WORK_DT_INDEX(`work_dt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `CLD_AUTOSCALING_TERMINAT_POL`;		-- 오토스케일링 종료 정책 정보 테이블
CREATE TABLE `CLD_AUTOSCALING_TERMINAT_POL` (
  `auto_sn` BIGINT(20) UNSIGNED NOT NULL,
  `tp_nm` VARCHAR(250) DEFAULT '', --  종료 정책 명
  `work_dt` DATETIME DEFAULT NULL,	-- 서버 데이터 생성 일시
  PRIMARY KEY (`auto_sn`, `tp_nm`),
  INDEX PK_INDEX(`auto_sn`),
  INDEX WORK_DT_INDEX(`work_dt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `CLD_AUTOSCALING_TAG`;		-- 오토스케일링 태그
CREATE TABLE `CLD_AUTOSCALING_TAG` (
  `auto_tag_sn` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `auto_sn` BIGINT(20) UNSIGNED NOT NULL,		-- Network Interface Main Table SN
  `auto_tag_key` VARCHAR(256) NOT NULL, -- 태그 키
  `auto_tag_value` VARCHAR(256) NOT NULL, -- 태그 값
  PRIMARY KEY (`auto_tag_sn`),
  INDEX PK_INDEX(`auto_tag_sn`),
  INDEX MAIN_INDEX(`auto_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `CLD_UNMANAGED_HOST`;		-- 미관리 자산 정보 테이블
CREATE TABLE `CLD_UNMANAGED_HOST` (
  `unmanaged_sn` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `iam_sn` BIGINT(20) UNSIGNED NOT NULL,
  `host_sn` BIGINT(20) UNSIGNED NOT NULL,
  `ami_sn` BIGINT(20) UNSIGNED NOT NULL,
  `group_cd` BIGINT(20) UNSIGNED NOT NULL,
  `rc_id` VARCHAR(150) NOT NULL,				-- 자산 ID
  `vpc_id` VARCHAR(150) DEFAULT '',				-- VPC ID
  `sub_id` VARCHAR(150) DEFAULT '',				-- Subnet ID
  `host_id` VARCHAR(150) NOT NULL, 				-- 인스턴스 아이디
  `host_status_code` INT(1) NOT NULL, 			-- 인스턴스 상태 코드
  `host_dtl_type` VARCHAR(20) NOT NULL,			-- 인스턴스 이미지 타입
  `host_dtl_owner_id` VARCHAR(30) NOT NULL, 				-- 소유자
  `host_nw_private_ip_addr` VARCHAR(20) DEFAULT NULL, -- 호스트 프라이빗 아이피
  `host_nw_public_ip_addr` VARCHAR(20) DEFAULT NULL, -- 호스트 퍼블릭 아이피
  `agent_status` INT(1) NOT NULL, 				-- 에이전트 상태
  `cld_type` INT(1) NOT NULL DEFAULT 1, 	-- 클라우드 타입 1: AWS, 2: GCP, 3: AZURE / 51: KT, 52: NBP, 53: 가비아 / 100:Legacy
  -- `regions` VARCHAR(50) NOT NULL,				-- 클라우드 계정 번호
  `work_dt` DATETIME DEFAULT NULL,			-- 데이터 생성 일시
  primary key(`unmanaged_sn`),
  UNIQUE KEY `unmanaged_unique` (`host_id`),
  INDEX PK_INDEX(`unmanaged_sn`),
  INDEX OWNER_INDEX(`host_dtl_owner_id`),
  INDEX TIME_INDEX(`work_dt`)
)ENGINE=INNODB DEFAULT CHARSET=UTF8;

-- 대화채널 구조 변경으로 사용하는 테이블
DROP TABLE IF EXISTS `MGR_CANARY_INFO`;		-- 대화채널 정보 테이블
CREATE TABLE `MGR_CANARY_INFO` (
  `canary_mgr_sn` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `host_sn` BIGINT(20) NOT NULL, 				-- 연결 호스트 sn
  `agent_id` VARCHAR(80) NOT NULL,			-- 에이전트 고유 번호
  `host_nw_private_ip_addr` VARCHAR(20) DEFAULT NULL, -- 호스트 프라이빗 아이피
  `command` VARCHAR(20)	NOT NULL,			-- Command Mgr 명령부 MGR (문서: 프로토콜_제어에이전트_대화채널.doc)
  `command_type` INT(1) NOT NULL DEFAULT 0, -- Command 형태 (0: 단순 통지, 1: 데이터 전달 - 기본적으로 0:단순 통지)
  `command_action` INT(1) NOT NULL DEFAULT 0, -- Command Type (0: 기본, command_type=1(1: 추가, 2: 갱신, 3: 삭제))
  `result_flg` INT(1) DEFAULT 0,			-- Command 결과 (0. 송신대상 / 1.송신완료 / 2. 오류(트라이 3회?))
  `work_dt` DATETIME DEFAULT NULL,			-- 생성 일시
  primary key(`canary_mgr_sn`),
  INDEX PK_INDEX(`canary_mgr_sn`),
  INDEX WORK_DT_INDEX(`work_dt`)
)ENGINE=INNODB DEFAULT CHARSET=UTF8;

-- 20200326 [설정]에 필요한 테이블 추가
-- ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
-- ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓

-- mgr_rc_change_alarm_conf  자산_변경_알람_설정
drop table if exists astron.mgr_rc_change_alarm_conf;
create table astron.mgr_rc_change_alarm_conf (
group_cd BIGINT(20) UNSIGNED NOT NULL COMMENT '그룹코드'
,use_yn CHAR(1) NOT NULL DEFAULT  'Y' COMMENT '자산변경알람여부(Y:알람적용,N:알람미적용)'
,add_alarm_yn CHAR(1) NOT NULL DEFAULT  'Y' COMMENT '생성알람'
,mod_alarm_yn CHAR(1) NOT NULL DEFAULT  'Y' COMMENT '변경알람'
,del_alarm_yn CHAR(1) NOT NULL DEFAULT  'Y' COMMENT '삭제알람'
,as_alarm_yn CHAR(1) NOT NULL DEFAULT  'Y' COMMENT '오토스케일림알람'
,reg_mgr_id VARCHAR(50) NOT NULL COMMENT '등록자'
,reg_dt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시'
,mod_mgr_id VARCHAR(50)  COMMENT '수정자'
,mod_dt DATETIME  COMMENT '수정일시'
)
ENGINE = INNODB CHARACTER SET UTF8 COMMENT = '자산_변경_알람_설정';

CREATE  INDEX idx_group_rc_change_alarm_conf_at ON astron.mgr_rc_change_alarm_conf(reg_dt);
CREATE  INDEX idx_group_rc_change_alarm_conf_mgr ON astron.mgr_rc_change_alarm_conf(reg_mgr_id);

ALTER TABLE astron.mgr_rc_change_alarm_conf ADD PRIMARY KEY (group_cd);


-- mgr_group_rc_conf 그룹_자산_설정
drop table if exists astron.mgr_group_rc_conf;
create table astron.mgr_group_rc_conf (
group_cd BIGINT(20) UNSIGNED NOT NULL COMMENT '그룹코드'
,cpu_yn CHAR(1) NOT NULL DEFAULT  'Y' COMMENT 'CPU알람여부(Y:알람적용,N:알람미적용)'
,cpu_warn TINYINT UNSIGNED NOT NULL DEFAULT 80 COMMENT 'CPU_주의임계치 (0~100)'
,cpu_cri TINYINT UNSIGNED NOT NULL DEFAULT 95 COMMENT 'CPU_위험임계치 (0~100)'
,mem_yn CHAR(1) NOT NULL DEFAULT  'Y' COMMENT 'MEM알람여부(Y:알람적용,N:알람미적용)'
,mem_warn TINYINT UNSIGNED NOT NULL DEFAULT 80 COMMENT 'MEM_주의임계치 (0~100)'
,mem_cri TINYINT UNSIGNED NOT NULL DEFAULT 95 COMMENT 'MEM_위험임계치 (0~100)'
,swap_yn CHAR(1) NOT NULL DEFAULT  'Y' COMMENT 'SWAP알람여부(Y:알람적용,N:알람미적용)'
,swap_warn TINYINT UNSIGNED NOT NULL DEFAULT 80 COMMENT 'SWAP_주의임계치 (0~100)'
,swap_cri TINYINT UNSIGNED NOT NULL DEFAULT 95 COMMENT 'SWAP_위험임계치 (0~100)'
,disk_yn CHAR(1) NOT NULL DEFAULT  'Y' COMMENT 'DISK알람여부(Y:알람적용,N:알람미적용)'
,disk_warn TINYINT UNSIGNED NOT NULL DEFAULT 80 COMMENT 'DISK_주의임계치 (0~100)'
,disk_cri TINYINT UNSIGNED NOT NULL DEFAULT 95 COMMENT 'DISK_위험임계치 (0~100)'
,use_yn CHAR(1) NOT NULL DEFAULT  'Y' COMMENT 'Resource측정여부(Y:알람적용,N:알람미적용)'
,reg_mgr_id VARCHAR(50) NOT NULL COMMENT '등록자'
,reg_dt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시'
,mod_mgr_id VARCHAR(50)  COMMENT '수정자'
,mod_dt DATETIME  COMMENT '수정일시'
)
ENGINE = INNODB CHARACTER SET UTF8 COMMENT = '그룹_자산_설정';

CREATE  INDEX idx_group_rc_conf_at ON astron.mgr_group_rc_conf(reg_dt);
CREATE  INDEX idx_group_rc_conf_mgr ON astron.mgr_group_rc_conf(reg_mgr_id);

ALTER TABLE astron.mgr_group_rc_conf ADD PRIMARY KEY (group_cd);


-- mgr_host_rc_conf  호스트_자산_설정
drop table if exists astron.mgr_host_rc_conf;
create table astron.mgr_host_rc_conf (
host_sn BIGINT(20) UNSIGNED NOT NULL COMMENT '호스트번호'
,cpu_yn CHAR(1) NOT NULL DEFAULT  'Y' COMMENT 'CPU알람여부(Y:알람적용,N:알람미적용)'
,cpu_warn TINYINT UNSIGNED NOT NULL DEFAULT 80 COMMENT 'CPU_주의임계치 (0~100)'
,cpu_cri TINYINT UNSIGNED NOT NULL DEFAULT 95 COMMENT 'CPU_위험임계치 (0~100)'
,mem_yn CHAR(1) NOT NULL DEFAULT  'Y' COMMENT 'MEM알람여부(Y:알람적용,N:알람미적용)'
,mem_warn TINYINT UNSIGNED NOT NULL DEFAULT 80 COMMENT 'MEM_주의임계치 (0~100)'
,mem_cri TINYINT UNSIGNED NOT NULL DEFAULT 95 COMMENT 'MEM_위험임계치 (0~100)'
,swap_yn CHAR(1) NOT NULL DEFAULT  'Y' COMMENT 'SWAP알람여부(Y:알람적용,N:알람미적용)'
,swap_warn TINYINT UNSIGNED NOT NULL DEFAULT 80 COMMENT 'SWAP_주의임계치 (0~100)'
,swap_cri TINYINT UNSIGNED NOT NULL DEFAULT 95 COMMENT 'SWAP_위험임계치 (0~100)'
,disk_yn CHAR(1) NOT NULL DEFAULT  'Y' COMMENT 'DISK알람여부(Y:알람적용,N:알람미적용)'
,disk_warn TINYINT UNSIGNED NOT NULL DEFAULT 80 COMMENT 'DISK_주의임계치 (0~100)'
,disk_cri TINYINT UNSIGNED NOT NULL DEFAULT 95 COMMENT 'DISK_위험임계치 (0~100)'
,use_yn CHAR(1) NOT NULL DEFAULT  'Y' COMMENT 'Resource측정여부(Y:알람적용,N:알람미적용)'
,by_host CHAR(1) NOT NULL DEFAULT  'Y' COMMENT '호스트변경여부(Y:호스트에서변경, N:그룹에서변경)'
,reg_mgr_id VARCHAR(50) NOT NULL COMMENT '등록자'
,reg_dt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시'
,mod_mgr_id VARCHAR(50)  COMMENT '수정자'
,mod_dt DATETIME  COMMENT '수정일시'
)
ENGINE = INNODB CHARACTER SET UTF8 COMMENT = '호스트_자산_설정';
show full columns from astron.mgr_host_rc_conf;

CREATE  INDEX idx_host_rc_conf_at ON astron.mgr_host_rc_conf(reg_dt);
CREATE  INDEX idx_host_rc_conf_mgr ON astron.mgr_host_rc_conf(reg_mgr_id);

ALTER TABLE astron.mgr_host_rc_conf ADD PRIMARY KEY (host_sn);


-- mgr_group_nw_conf 그룹_네트웍_설정
drop table if exists astron.mgr_group_nw_conf;
create table astron.mgr_group_nw_conf (
group_cd BIGINT(20) UNSIGNED NOT NULL COMMENT '그룹코드'
,in_yn CHAR(1) NOT NULL DEFAULT  'Y' COMMENT 'INBOUND알람여부(Y:알람적용,N:알람미적용)'
,in_tr_warn INT UNSIGNED NOT NULL DEFAULT 10000 COMMENT 'INBOUND_TRAFFIC_주의임계치 (단위:kbps)'
,in_tr_cri INT UNSIGNED NOT NULL DEFAULT 10000 COMMENT 'INBOUND_TRAFFIC_위험임계치 (단위:kbps)'
,in_acc_warn INT UNSIGNED NOT NULL DEFAULT 500 COMMENT 'INBOUND_누적전송량_주의임계치 (단위:MB)'
,in_acc_cri INT UNSIGNED NOT NULL DEFAULT 500 COMMENT 'INBOUND_누적전송량_위험임계치 (단위:MB)'
,out_yn CHAR(1) NOT NULL DEFAULT  'Y' COMMENT 'OUTBOUND알람여부(Y:알람적용,N:알람미적용)'
,out_tr_warn INT UNSIGNED NOT NULL DEFAULT 80 COMMENT 'OUTBOUND_TRAFFIC_주의임계치 (단위:kbps)'
,out_tr_cri INT UNSIGNED NOT NULL DEFAULT 95 COMMENT 'OUTBOUND_TRAFFIC_위험임계치 (단위:kbps)'
,out_acc_warn INT UNSIGNED NOT NULL DEFAULT 80 COMMENT 'OUTBOUND_누적전송량_주의임계치 (단위:MB)'
,out_acc_cri INT UNSIGNED NOT NULL DEFAULT 95 COMMENT 'OUTBOUND_누적전송량_위험임계치 (단위:MB)'
,use_yn CHAR(1) NOT NULL DEFAULT  'Y' COMMENT 'Nw측정여부(Y:알람적용,N:알람미적용)'
,reg_mgr_id VARCHAR(50) NOT NULL COMMENT '등록자'
,reg_dt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시'
,mod_mgr_id VARCHAR(50)  COMMENT '수정자'
,mod_dt DATETIME  COMMENT '수정일시'
)
ENGINE = INNODB CHARACTER SET UTF8 COMMENT = '그룹_네트웍_설정';

CREATE  INDEX idx_group_nw_conf_at ON astron.mgr_group_nw_conf(reg_dt);
CREATE  INDEX idx_group_nw_conf_mgr ON astron.mgr_group_nw_conf(reg_mgr_id);

ALTER TABLE astron.mgr_group_nw_conf ADD PRIMARY KEY (group_cd);


-- mgr_host_nw_conf  호스트_네트웍_설정
drop table if exists astron.mgr_host_nw_conf;
create table astron.mgr_host_nw_conf (
host_sn BIGINT(20) UNSIGNED NOT NULL COMMENT '호스트번호'
,in_yn CHAR(1) NOT NULL DEFAULT  'Y' COMMENT 'INBOUND알람여부(Y:알람적용,N:알람미적용)'
,in_tr_warn INT UNSIGNED NOT NULL DEFAULT 10000 COMMENT 'INBOUND_TRAFFIC_주의임계치 (단위:kbps)'
,in_tr_cri INT UNSIGNED NOT NULL DEFAULT 10000 COMMENT 'INBOUND_TRAFFIC_위험임계치 (단위:kbps)'
,in_acc_warn INT UNSIGNED NOT NULL DEFAULT 500 COMMENT 'INBOUND_누적전송량_주의임계치 (단위:MB)'
,in_acc_cri INT UNSIGNED NOT NULL DEFAULT 500 COMMENT 'INBOUND_누적전송량_위험임계치 (단위:MB)'
,out_yn CHAR(1) NOT NULL DEFAULT  'Y' COMMENT 'OUTBOUND알람여부(Y:알람적용,N:알람미적용)'
,out_tr_warn INT UNSIGNED NOT NULL DEFAULT 80 COMMENT 'OUTBOUND_TRAFFIC_주의임계치 (단위:kbps)'
,out_tr_cri INT UNSIGNED NOT NULL DEFAULT 95 COMMENT 'OUTBOUND_TRAFFIC_위험임계치 (단위:kbps)'
,out_acc_warn INT UNSIGNED NOT NULL DEFAULT 80 COMMENT 'OUTBOUND_60누적전송량_주의임계치 (단위:MB)'
,out_acc_cri INT UNSIGNED NOT NULL DEFAULT 95 COMMENT 'OUTBOUND_61누적전송량_위험임계치 (단위:MB)'
,use_yn CHAR(1) NOT NULL DEFAULT  'Y' COMMENT 'Nw측정여부(Y:알람적용,N:알람미적용)'
,by_host CHAR(1) NOT NULL DEFAULT  'Y' COMMENT '호스트변경여부(Y:호스트에서변경, N:그룹에서변경)'
,reg_mgr_id VARCHAR(50) NOT NULL COMMENT '등록자'
,reg_dt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시'
,mod_mgr_id VARCHAR(50)  COMMENT '수정자'
,mod_dt DATETIME  COMMENT '수정일시'
)
ENGINE = INNODB CHARACTER SET UTF8 COMMENT = '호스트_네트웍_설정';
show full columns from astron.mgr_host_nw_conf;

CREATE  INDEX idx_host_nw_conf_at ON astron.mgr_host_nw_conf(reg_dt);
CREATE  INDEX idx_host_nw_conf_mgr ON astron.mgr_host_nw_conf(reg_mgr_id);

ALTER TABLE astron.mgr_host_nw_conf ADD PRIMARY KEY (host_sn);


-- mgr_host_process_conf 호스트_프로세스_설정
drop table if exists astron.mgr_host_process_conf;
create table astron.mgr_host_process_conf (
host_process_no INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '호스트_프로세스_번호'
,host_sn INT UNSIGNED NOT NULL COMMENT '호스트번호'
,process_nm VARCHAR(500) NOT NULL COMMENT '프로세스명'
,pid INT UNSIGNED  COMMENT 'PID'
,parameters LONGTEXT  COMMENT '인자값'
,use_yn CHAR(1) NOT NULL DEFAULT  'Y' COMMENT '프로세스_COUNT알람여부(Y:알람적용,N:알람미적용)'
,process_cnt_min INT UNSIGNED NOT NULL DEFAULT 5 COMMENT '프로세스_최소갯수'
,process_cnt_max INT UNSIGNED NOT NULL DEFAULT 10 COMMENT '프로세스_최대갯수'
,alias VARCHAR(1024)  COMMENT 'alias'
,reg_mgr_id VARCHAR(50) NOT NULL COMMENT '등록자'
,reg_dt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시'
,mod_mgr_id VARCHAR(50)  COMMENT '수정자'
,mod_dt DATETIME  COMMENT '수정일시'
)
ENGINE = INNODB CHARACTER SET UTF8 COMMENT = '호스트_프로세스_설정';
show full columns from astron.mgr_host_process_conf;

CREATE  INDEX idx_host_process_nm ON astron.mgr_host_process_conf(process_nm);
CREATE  INDEX idx_host_process_conf_at ON astron.mgr_host_process_conf(reg_dt);
CREATE  INDEX idx_host_process_conf_mgr ON astron.mgr_host_process_conf(reg_mgr_id);


-- mgr_host_port_conf  호스트_포트_설정
drop table if exists astron.mgr_host_port_conf;
create table astron.mgr_host_port_conf (
host_port_no BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '호스트_포트_번호'
,host_sn BIGINT(20) UNSIGNED NOT NULL COMMENT '호스트번호'
,service_nm VARCHAR(32) NOT NULL COMMENT '서비스명(대문자:TCP,UDP,FTP,SSH…)'
,port_no INT UNSIGNED NOT NULL COMMENT 'port번호'
,port_nm VARCHAR(255)  COMMENT 'port명'
,protocol VARCHAR(32) NOT NULL COMMENT '프로토콜(대문자:TCP,UDP)'
,use_yn CHAR(1) NOT NULL DEFAULT  'Y' COMMENT '포트알람여부(Y:알람적용,N:알람미적용)'
,port_alarm_type TINYINT UNSIGNED NOT NULL DEFAULT 4 COMMENT 'port알람(4:주의, 1:위험)'
,reg_mgr_id VARCHAR(50) NOT NULL COMMENT '등록자'
,reg_dt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시'
,mod_mgr_id VARCHAR(50)  COMMENT '수정자'
,mod_dt DATETIME  COMMENT '수정일시'
)
ENGINE = INNODB CHARACTER SET UTF8 COMMENT = '호스트_포트_설정';

CREATE unique INDEX uidx_host_port ON astron.mgr_host_port_conf(host_sn, port_no);
CREATE  INDEX idx_host_port_protocol ON astron.mgr_host_port_conf(protocol);
CREATE  INDEX idx_host_port_service ON astron.mgr_host_port_conf(service_nm);
CREATE  INDEX idx_host_port_conf_at ON astron.mgr_host_port_conf(reg_dt);
CREATE  INDEX idx_host_port_conf_mgr ON astron.mgr_host_port_conf(reg_mgr_id);


-- mgr_host_url_conf 호스트_url_설정
drop table if exists astron.mgr_host_url_conf;
create table astron.mgr_host_url_conf (
host_url_no BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '호스트_url_번호'
,host_sn BIGINT(20) UNSIGNED NOT NULL COMMENT '호스트번호'
,url VARCHAR(2500) NOT NULL COMMENT '대상URL'
,response_limit INT UNSIGNED NOT NULL DEFAULT 5000 COMMENT '응답시간임계치(단위:ms)'
,use_yn CHAR(1) NOT NULL DEFAULT  'Y' COMMENT 'url알람여부(Y:알람적용,N:알람미적용)'
,url_alarm_type TINYINT UNSIGNED NOT NULL DEFAULT 4 COMMENT 'url알람(4:주의, 1:위험)'
,check_period INT UNSIGNED NOT NULL DEFAULT 5 COMMENT '측정주기(단위:분)'
,reg_mgr_id VARCHAR(50) NOT NULL COMMENT '등록자'
,reg_dt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시'
,mod_mgr_id VARCHAR(50)  COMMENT '수정자'
,mod_dt DATETIME  COMMENT '수정일시'
)
ENGINE = INNODB CHARACTER SET UTF8 COMMENT = '호스트_url_설정';

CREATE  INDEX idx_host_url ON astron.mgr_host_url_conf(url(1024));
CREATE  INDEX idx_host_url_conf_at ON astron.mgr_host_url_conf(reg_dt);
CREATE  INDEX idx_host_url_conf_mgr ON astron.mgr_host_url_conf(reg_mgr_id);


-- mgr_host_ping_conf  호스트_ping_설정
drop table if exists astron.mgr_host_ping_conf;
create table astron.mgr_host_ping_conf (
host_sn BIGINT(20) UNSIGNED NOT NULL COMMENT '호스트번호'
,ip VARCHAR(48) NOT NULL COMMENT '대상 ip address'
,use_yn CHAR(1) NOT NULL DEFAULT  'Y' COMMENT 'ping알람여부(Y:알람적용,N:알람미적용)'
,ping_limit_warn TINYINT UNSIGNED NOT NULL DEFAULT 1 COMMENT 'ping지속_주의(단위:회)'
,ping_limit_cri TINYINT UNSIGNED NOT NULL DEFAULT 5 COMMENT 'ping지속_위험(단위:회)'
,check_period INT UNSIGNED NOT NULL DEFAULT 5 COMMENT '측정주기(단위:분,1,5,10)'
,reg_mgr_id VARCHAR(50) NOT NULL COMMENT '등록자'
,reg_dt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시'
,mod_mgr_id VARCHAR(50)  COMMENT '수정자'
,mod_dt DATETIME  COMMENT '수정일시'
)
ENGINE = INNODB CHARACTER SET UTF8 COMMENT = '호스트_ping_설정';

CREATE  INDEX idx_host_ping_conf_at ON astron.mgr_host_ping_conf(reg_dt);
CREATE  INDEX idx_host_ping_conf_mgr ON astron.mgr_host_ping_conf(reg_mgr_id);

ALTER TABLE astron.mgr_host_ping_conf ADD PRIMARY KEY (host_sn);


-- mgr_group_syslog_conf 그룹_시스템로그_설정
drop table if exists astron.mgr_group_syslog_conf;
create table astron.mgr_group_syslog_conf (
group_cd BIGINT(20) UNSIGNED NOT NULL COMMENT '그룹코드'
,syslog_yn CHAR(1) NOT NULL DEFAULT  'Y' COMMENT 'syslog(Y:동작,N:중지)'
,alert_yn CHAR(1) NOT NULL DEFAULT  'Y' COMMENT 'alert수집여부(Y:수집, N:미수집)'
,critical_yn CHAR(1) NOT NULL DEFAULT  'Y' COMMENT 'critical수집여부(Y:수집, N:미수집)'
,error_yn CHAR(1) NOT NULL DEFAULT  'Y' COMMENT 'error수집여부(Y:수집, N:미수집)'
,warn_yn CHAR(1) NOT NULL DEFAULT  'Y' COMMENT 'warn수집여부(Y:수집, N:미수집)'
,notice_yn CHAR(1) NOT NULL DEFAULT  'Y' COMMENT 'notice수집여부(Y:수집, N:미수집)'
,info_yn CHAR(1) NOT NULL DEFAULT  'Y' COMMENT 'info수집여부(Y:수집, N:미수집)'
,debug_yn CHAR(1) NOT NULL DEFAULT  'Y' COMMENT 'debug수집여부(Y:수집, N:미수집)'
,etc_yn CHAR(1) NOT NULL DEFAULT  'Y' COMMENT 'etc수집여부(Y:수집, N:미수집)'
,reg_mgr_id VARCHAR(50) NOT NULL COMMENT '등록자'
,reg_dt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시'
,mod_mgr_id VARCHAR(50)  COMMENT '수정자'
,mod_dt DATETIME  COMMENT '수정일시'
)
ENGINE = INNODB CHARACTER SET UTF8 COMMENT = '그룹_시스템로그_설정';

CREATE  INDEX idx_group_syslog_conf_at ON astron.mgr_group_syslog_conf(reg_dt);
CREATE  INDEX idx_group_syslog_conf_mgr ON astron.mgr_group_syslog_conf(reg_mgr_id);

ALTER TABLE astron.mgr_group_syslog_conf ADD PRIMARY KEY (group_cd);


-- mgr_host_syslog_conf  호스트_시스템로그_설정
drop table if exists astron.mgr_host_syslog_conf;
create table astron.mgr_host_syslog_conf (
host_sn BIGINT(20) UNSIGNED NOT NULL COMMENT '호스트번호'
,syslog_yn CHAR(1) NOT NULL DEFAULT  'Y' COMMENT 'syslog(Y:동작,N:중지)'
,alert_yn CHAR(1) NOT NULL DEFAULT  'Y' COMMENT 'alert수집여부(Y:수집, N:미수집)'
,critical_yn CHAR(1) NOT NULL DEFAULT  'Y' COMMENT 'critical수집여부(Y:수집, N:미수집)'
,error_yn CHAR(1) NOT NULL DEFAULT  'Y' COMMENT 'error수집여부(Y:수집, N:미수집)'
,warn_yn CHAR(1) NOT NULL DEFAULT  'Y' COMMENT 'warn수집여부(Y:수집, N:미수집)'
,notice_yn CHAR(1) NOT NULL DEFAULT  'Y' COMMENT 'notice수집여부(Y:수집, N:미수집)'
,info_yn CHAR(1) NOT NULL DEFAULT  'Y' COMMENT 'info수집여부(Y:수집, N:미수집)'
,debug_yn CHAR(1) NOT NULL DEFAULT  'Y' COMMENT 'debug수집여부(Y:수집, N:미수집)'
,etc_yn CHAR(1) NOT NULL DEFAULT  'Y' COMMENT 'etc수집여부(Y:수집, N:미수집)'
,by_host CHAR(1) NOT NULL DEFAULT  'Y' COMMENT '호스트변경여부(Y:호스트에서변경, N:그룹에서변경)'
,reg_mgr_id VARCHAR(50) NOT NULL COMMENT '등록자'
,reg_dt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시'
,mod_mgr_id VARCHAR(50)  COMMENT '수정자'
,mod_dt DATETIME  COMMENT '수정일시'
)
ENGINE = INNODB CHARACTER SET UTF8 COMMENT = '호스트_시스템로그_설정';
show full columns from astron.mgr_host_syslog_conf;

CREATE  INDEX idx_host_syslog_conf_at ON astron.mgr_host_syslog_conf(reg_dt);
CREATE  INDEX idx_host_syslog_conf_mgr ON astron.mgr_host_syslog_conf(reg_mgr_id);

ALTER TABLE astron.mgr_host_syslog_conf ADD PRIMARY KEY (host_sn);


-- mgr_group_fwlog_conf  그룹_방화벽로그_설정
drop table if exists astron.mgr_group_fwlog_conf;
create table astron.mgr_group_fwlog_conf (
group_cd BIGINT(20) UNSIGNED NOT NULL COMMENT '그룹코드'
,fwlog_yn CHAR(1) NOT NULL DEFAULT  'Y' COMMENT 'fwlog(Y:동작,N:중지)'
,block_yn CHAR(1) NOT NULL DEFAULT  'Y' COMMENT '차단여부(Y:수집, N:미수집)'
,permit_yn CHAR(1) NOT NULL DEFAULT  'Y' COMMENT '허용여부(Y:수집, N:미수집)'
,reg_mgr_id VARCHAR(50) NOT NULL COMMENT '등록자'
,reg_dt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시'
,mod_mgr_id VARCHAR(50)  COMMENT '수정자'
,mod_dt DATETIME  COMMENT '수정일시'
)
ENGINE = INNODB CHARACTER SET UTF8 COMMENT = '그룹_방화벽로그_설정';

CREATE  INDEX idx_group_fwlog_conf_at ON astron.mgr_group_fwlog_conf(reg_dt);
CREATE  INDEX idx_group_fwlog_conf_mgr ON astron.mgr_group_fwlog_conf(reg_mgr_id);

ALTER TABLE astron.mgr_group_fwlog_conf ADD PRIMARY KEY (group_cd);


-- mgr_host_fwlog_conf 호스트_방화벽로그_설정
drop table if exists astron.mgr_host_fwlog_conf;
create table astron.mgr_host_fwlog_conf (
host_sn BIGINT(20) UNSIGNED NOT NULL COMMENT '호스트번호'
,fwlog_yn CHAR(1) NOT NULL DEFAULT  'Y' COMMENT 'fwlog(Y:동작,N:중지)'
,block_yn CHAR(1) NOT NULL DEFAULT  'Y' COMMENT '차단여부(Y:수집, N:미수집)'
,permit_yn CHAR(1) NOT NULL DEFAULT  'Y' COMMENT '허용여부(Y:수집, N:미수집)'
,by_host CHAR(1) NOT NULL DEFAULT  'Y' COMMENT '호스트변경여부(Y:호스트에서변경, N:그룹에서변경)'
,reg_mgr_id VARCHAR(50) NOT NULL COMMENT '등록자'
,reg_dt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시'
,mod_mgr_id VARCHAR(50)  COMMENT '수정자'
,mod_dt DATETIME  COMMENT '수정일시'
)
ENGINE = INNODB CHARACTER SET UTF8 COMMENT = '호스트_방화벽로그_설정';
show full columns from astron.mgr_host_fwlog_conf;

CREATE  INDEX idx_host_fwlog_conf_at ON astron.mgr_host_fwlog_conf(reg_dt);
CREATE  INDEX idx_host_fwlog_conf_mgr ON astron.mgr_host_fwlog_conf(reg_mgr_id);

ALTER TABLE astron.mgr_host_fwlog_conf ADD PRIMARY KEY (host_sn);


-- mgr_integrity_template_base 무결성점검_템플릿
drop table if exists astron.mgr_integrity_template_base;
create table astron.mgr_integrity_template_base (
integrity_template_no BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '무결성점검_템플릿_번호'
,integrity_template_nm VARCHAR(255) NOT NULL COMMENT '무결성점검_템플릿_이름'
,integrity_template_desc VARCHAR(1024)  COMMENT '무결성점검_템플릿_설명'
,reg_mgr_id VARCHAR(50) NOT NULL COMMENT '등록자'
,reg_dt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시'
,mod_mgr_id VARCHAR(50)  COMMENT '수정자'
,mod_dt DATETIME  COMMENT '수정일시'
)
ENGINE = INNODB CHARACTER SET UTF8 COMMENT = '무결성점검_템플릿';

CREATE unique INDEX uidx_integrity_template ON astron.mgr_integrity_template_base(integrity_template_nm);
CREATE  INDEX idx_integrity_template_at ON astron.mgr_integrity_template_base(reg_dt);
CREATE  INDEX idx_integrity_template_mgr ON astron.mgr_integrity_template_base(reg_mgr_id);


-- mgr_integrity_template_policy 무결성점검_템플릿_정책
drop table if exists astron.mgr_integrity_template_policy;
create table astron.mgr_integrity_template_policy (
integrity_template_policy_no BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '무결성점검_템플릿_정책_번호'
,integrity_template_no INT UNSIGNED NOT NULL COMMENT '무결성점검_템플릿_번호'
,policy_type CHAR(1) NOT NULL DEFAULT  '1' COMMENT '정책구분(1:파일, 2:디렉토리)'
,target_nm VARCHAR(128) NOT NULL COMMENT '점검대상_이름'
,target_path VARCHAR(1024) NOT NULL COMMENT '점검대상_전체경로'
,code_acts VARCHAR(64) NOT NULL COMMENT '탐지유형목록(16:생성,32:삭제, 64:변경)'
,changes VARCHAR(64)  COMMENT '변경유형목록(1:변경-크기,2:변경-날짜, 3: 권한(모드), 4:변경-사용자, 8:변경-그룹)'
,include_sub CHAR(1) NOT NULL DEFAULT  'N' COMMENT '하위폴더포함(Y:포함, N:미포함)'
,reg_mgr_id VARCHAR(50) NOT NULL COMMENT '등록자'
,reg_dt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시'
,mod_mgr_id VARCHAR(50)  COMMENT '수정자'
,mod_dt DATETIME  COMMENT '수정일시'
)
ENGINE = INNODB CHARACTER SET UTF8 COMMENT = '무결성점검_템플릿_정책';

CREATE  INDEX idx_integrity_template_policy_no ON astron.mgr_integrity_template_policy(integrity_template_no);
CREATE  INDEX idx_integrity_template_policy_nm ON astron.mgr_integrity_template_policy(target_nm);
CREATE  INDEX idx_integrity_template_policy_target ON astron.mgr_integrity_template_policy(target_path);


-- mgr_integrity_template_group  무결성점검_템플릿_그룹
drop table if exists astron.mgr_integrity_template_group;
create table astron.mgr_integrity_template_group (
integrity_template_no INT UNSIGNED NOT NULL COMMENT '무결성점검_템플릿_번호'
,group_cd INT UNSIGNED NOT NULL COMMENT '그룹코드'
)
ENGINE = INNODB CHARACTER SET UTF8 COMMENT = '무결성점검_템플릿_그룹';

CREATE  INDEX idx_integrity_template_group_no ON astron.mgr_integrity_template_group(integrity_template_no);

ALTER TABLE astron.mgr_integrity_template_group ADD PRIMARY KEY (integrity_template_no, group_cd);


-- mgr_host_integrity_policy 호스트_무결성점검_정책
drop table if exists astron.mgr_host_integrity_policy;
create table astron.mgr_host_integrity_policy (
host_integrity_policy_no BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '호스트_무결성점검_정책_번호'
,host_sn BIGINT(20) UNSIGNED NOT NULL COMMENT '호스트번호'
,policy_type CHAR(1) NOT NULL DEFAULT  '1' COMMENT '정책구분(1:파일, 2:디렉토리)'
,target_nm VARCHAR(128) NOT NULL COMMENT '점검대상_이름'
,target_path VARCHAR(1024) NOT NULL COMMENT '점검대상'
,code_acts VARCHAR(64) NOT NULL COMMENT '탐지유형목록(16:생성,32:삭제, 64-1:변경-크기,64-2:변경-날짜, 64-3: 변경-권한(모드), 64-4:변경-사용자, 64-8:변경-그룹)'
,changes VARCHAR(64)  COMMENT '탐지유형목록(16:생성,32:삭제, 64-1:변경-크기,64-2:변경-날짜, 64-3: 변경-권한(모드), 64-4:변경-사용자, 64-8:변경-그룹)'
,include_sub CHAR(1) NOT NULL DEFAULT  'Y' COMMENT '하위폴더포함(Y:포함, N:미포함)'
,reg_mgr_id VARCHAR(50) NOT NULL COMMENT '등록자'
,reg_dt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시(YYYY-MM-DD hh:mm:ss)'
,mod_mgr_id VARCHAR(50)  COMMENT '수정자'
,mod_dt DATETIME  COMMENT '수정일시 (※갱신, 삭제시 등록)(YYYY-MM-DD hh:mm:ss)'
)
ENGINE = INNODB CHARACTER SET UTF8 COMMENT = '호스트_무결성점검_정책';

CREATE  INDEX idx_host_integrity_policy_host ON astron.mgr_host_integrity_policy(host_sn);
CREATE  INDEX idx_host_integrity_policy_nm ON astron.mgr_host_integrity_policy(host_sn, policy_type, target_nm);
CREATE  INDEX idx_host_integrity_ploicy_target ON astron.mgr_host_integrity_policy(target_path);

-- trNewHostIntegrityPolicy  호스트무결성점검정책추가
DELIMITER $$

CREATE
    /*[DEFINER = { user | CURRENT_USER }]*/
    TRIGGER `astron`.`trNewHostIntegrityPolicy` AFTER INSERT
    ON `astron`.`mgr_host_integrity_policy`
    FOR EACH ROW BEGIN

  INSERT INTO mgr_host_integrity_policy_hist (
    host_integrity_policy_no, host_sn, policy_type, target_nm, target_path, code_acts
    , changes, include_sub, reg_mgr_id, reg_dt, hist_type, agent_noti
  )
  VALUES (
    new.host_integrity_policy_no, new.host_sn, new.policy_type, new.target_nm, new.target_path, new.code_acts
    , new.changes, new.include_sub, new.reg_mgr_id, NOW(), '1', 'N'
  );

    END$$

DELIMITER ;

-- trModHostIntegrityPolicy  호스트무결성점검정책수정
DELIMITER $$

CREATE
    /*[DEFINER = { user | CURRENT_USER }]*/
    TRIGGER `astron`.`trModHostIntegrityPolicy` AFTER UPDATE
    ON `astron`.`mgr_host_integrity_policy`
    FOR EACH ROW BEGIN

  INSERT INTO mgr_host_integrity_policy_hist (
    host_integrity_policy_no, host_sn, policy_type, target_nm, target_path, code_acts
    , changes, include_sub, reg_mgr_id, reg_dt, hist_type, agent_noti
  )
  VALUES (
    new.host_integrity_policy_no, new.host_sn, new.policy_type, new.target_nm, new.target_path, new.code_acts
    , new.changes, new.include_sub, new.mod_mgr_id, NOW(), '2', 'N'
  );

    END$$

DELIMITER ;

-- trDelHostIntegrityPolicy  호스트무결성점검정책삭제
DELIMITER $$

CREATE
    /*[DEFINER = { user | CURRENT_USER }]*/
    TRIGGER `astron`.`trDelHostIntegrityPolicy` AFTER DELETE
    ON `astron`.`mgr_host_integrity_policy`
    FOR EACH ROW BEGIN

  INSERT INTO mgr_host_integrity_policy_hist (
    host_integrity_policy_no, host_sn, policy_type, target_nm, target_path, code_acts
    , changes, include_sub, reg_mgr_id, reg_dt, hist_type, agent_noti
  )
  VALUES (
    old.host_integrity_policy_no, old.host_sn, old.policy_type, old.target_nm, old.target_path, old.code_acts
    , old.changes, old.include_sub, old.mod_mgr_id, NOW(), '3', 'N'
  );

    END$$

DELIMITER ;

-- 2020-04-03 추가 매니저 서버 관리 관련 테이블 START
DROP TABLE IF EXISTS `MGR_SERVER_ALARM_CONF`;
CREATE TABLE `MGR_SERVER_ALARM_CONF` (
    `conf_sn` BIGINT(20) UNSIGNED NOT NULL  AUTO_INCREMENT NOT NULL COMMENT '알람 설정 순번' ,
    `cpu_yn` CHAR(1) NOT NULL DEFAULT 'Y' COMMENT 'CPU 측정여부' , -- Y, N
    `cpu_alarm_yn` CHAR(1) NOT NULL DEFAULT 'Y' COMMENT 'CPU 알람여부' , -- Y, N
    `cpu_warn_val` TINYINT UNSIGNED NOT NULL DEFAULT 80 COMMENT 'CPU 위험 임계치 (0~100)' ,
    `cpu_critical_val` TINYINT UNSIGNED NOT NULL DEFAULT 95 COMMENT 'CPU 주의 임계치 (0~100)' ,
    `mem_yn` CHAR(1) NOT NULL DEFAULT 'Y' COMMENT '메모리 측정여부' , -- Y, N
    `mem_alarm_yn` CHAR(1) NOT NULL DEFAULT 'Y' COMMENT '메모리 알람여부' , -- Y, N
    `mem_warn_val` TINYINT UNSIGNED NOT NULL DEFAULT 80 COMMENT '메모리 위험 임계치 (0~100)' ,
    `mem_critical_val` TINYINT UNSIGNED NOT NULL DEFAULT 95 COMMENT '메모리 주의 임계치 (0~100)' ,
    `disk_yn` CHAR(1) NOT NULL DEFAULT 'Y' COMMENT 'disk 측정여부' , -- Y, N
    `disk_alarm_yn` CHAR(1) NOT NULL DEFAULT 'Y' COMMENT 'disk 알람여부' , -- Y, N
    `disk_warn_val` TINYINT UNSIGNED NOT NULL DEFAULT 80 COMMENT 'disk 위험 임계치 (0~100)' ,
    `disk_critical_val` TINYINT UNSIGNED NOT NULL DEFAULT 95 COMMENT 'disk 주의 임계치 (0~100)' ,
    `usage_yn` CHAR(1) NOT NULL DEFAULT 'Y' COMMENT '가동률 측정여부' , -- Y, N
    `usage_alarm_yn` CHAR(1) NOT NULL DEFAULT 'Y' COMMENT '가동률 알람여부' , -- Y, N
    `usage_warn_val` TINYINT UNSIGNED NOT NULL DEFAULT 80 COMMENT '가동률 위험 임계치 (0~100)' ,
    `usage_critical_val` TINYINT UNSIGNED NOT NULL DEFAULT 95 COMMENT '가동률 주의 임계치 (0~100)' ,
    `nw_yn` CHAR(1) NOT NULL DEFAULT 'Y' COMMENT '네트워크 측정여부' , -- Y, N
    `nw_alarm_yn` CHAR(1) NOT NULL DEFAULT 'Y' COMMENT '네트워크 알람여부' , -- Y, N
    `in_traffic_warn_val` INT UNSIGNED NOT NULL DEFAULT 10000  COMMENT 'IN Traffic 주의 임계치 (단위:kbps)' ,
    `out_traffic_warn_val` INT UNSIGNED NOT NULL DEFAULT 10000 COMMENT 'OUT Traffic 주의 임계치 (단위:kbps)' ,
    `in_traffic_critical_val` INT UNSIGNED NOT NULL DEFAULT 10000  COMMENT 'IN Traffic 위험 임계치 (단위:kbps)' ,
    `out_traffic_critical_val` INT UNSIGNED NOT NULL DEFAULT 10000 COMMENT 'OUT Traffic 위험 임계치 (단위:kbps)' ,
    `in_trans_warn_val` INT UNSIGNED NOT NULL DEFAULT 500 COMMENT 'IN 누적 주의 전송량 (단위:MB) ' ,
    `out_trans_warn_val` INT UNSIGNED NOT NULL DEFAULT 500 COMMENT 'OUT 누적 주의 전송량 (단위:MB)' ,
    `in_trans_critical_val` INT UNSIGNED NOT NULL DEFAULT 500 COMMENT 'IN 누적 위험 전송량 (단위:MB) ' ,
    `out_trans_critical_val` INT UNSIGNED NOT NULL DEFAULT 500 COMMENT 'OUT 누적 위험 전송량 (단위:MB)' ,
    `reg_mgr_id` VARCHAR(50)  COMMENT '등록자ID' ,
    `reg_dt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시' ,
    `mod_mgr_id` VARCHAR(50) COMMENT '수정자ID' ,
    `mod_dt` TIMESTAMP   DEFAULT CURRENT_TIMESTAMP  COMMENT '수정일시' ,
    PRIMARY KEY (`conf_sn`),
    INDEX PK_INDEX(`conf_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8 COMMENT = '매니저 서버관리 알람 설정';
INSERT  INTO MGR_SERVER_ALARM_CONF (conf_sn) VALUES (1) ;


DROP TABLE IF EXISTS `MGR_SERVER_ALARM_RES`;
CREATE TABLE `MGR_SERVER_ALARM_RES` (
    `res_sn` BIGINT(20) UNSIGNED NOT NULL  AUTO_INCREMENT COMMENT '수신자 순번' ,
    `conf_sn` INT NOT NULL COMMENT '알람 설정 순번' ,
    `mgr_id` VARCHAR(50) NOT NULL  COMMENT '관리 콘솔 관리자 아이디' ,
    `reg_mgr_id` VARCHAR(50) COMMENT '등록자ID' ,
    `reg_dt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시' ,
    `mod_mgr_id` VARCHAR(50) COMMENT '수정자ID' ,
    `mod_dt` TIMESTAMP  DEFAULT CURRENT_TIMESTAMP   COMMENT '수정일시' ,
    PRIMARY KEY (`res_sn`, `mgr_id`),
    INDEX PK_INDEX(`res_sn`, `mgr_id`)
 ) ENGINE=InnoDB DEFAULT CHARSET=UTF8 COMMENT = '매니저 서버 알람 수신자';

INSERT  INTO MGR_SERVER_ALARM_RES (conf_sn, mgr_id) VALUES (1, 'admin') ;

DROP TABLE IF EXISTS `MGR_SERVER_ALARM_HST`;
CREATE TABLE `MGR_SERVER_ALARM_HST` (
    `alarm_hst_sn` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '알람이력 순번' ,
    `alarm_min` CHAR(1) NOT NULL  COMMENT '알람부ID' , -- 1:CPU,2:MEMORY,3:SWAP,4:DISK,5:DISK MOUNT,6:NETWORK, 7:PROCESS
    `alarm_level` CHAR(1) NOT NULL  COMMENT '알람 레벨' , -- 알람등급(2:위험CRITICAL,4:주의WARNING)
    `alarm_val` DOUBLE NOT NULL  COMMENT '시스템 값' ,
    `message` VARCHAR(4000)  COMMENT '알림 메시지' ,
    `first_dt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '발생일시' ,
    `clear_dt` DATETIME   COMMENT '복구일시' ,
    `reg_mgr_id` VARCHAR(50)  COMMENT '등록자ID' ,
    `reg_dt` DATETIME NOT NULL  DEFAULT CURRENT_TIMESTAMP  COMMENT '등록일시' ,
    `mod_mgr_id` VARCHAR(50)  COMMENT '수정자ID' ,
    `mod_dt` TIMESTAMP   DEFAULT CURRENT_TIMESTAMP COMMENT '수정일시' ,
    PRIMARY KEY (`alarm_hst_sn`),
    INDEX PK_INDEX(`alarm_hst_sn`),
    INDEX FIRST_DT_INDEX(`first_dt`),
    INDEX CLEAR_DT_INDEX(`clear_dt`),
    UNIQUE KEY `mgr_server_alarm_hst_unique` (`alarm_min`, `first_dt`)
 ) ENGINE=InnoDB DEFAULT CHARSET=UTF8 COMMENT = '매니저 서버 알람 이력';


DROP TABLE IF EXISTS `STS_CPU_BASE_USAGE`;
CREATE TABLE `STS_CPU_BASE_USAGE` (
    `sts_base_sn` BIGINT(20) UNSIGNED NOT NULL  AUTO_INCREMENT  COMMENT '1분 통계 순번' ,
    `sts_dt`   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '일자',
    `cpu_system` DOUBLE  DEFAULT 0 COMMENT '시스템 사용률' ,
    `cpu_user` DOUBLE  DEFAULT 0 COMMENT '사용자 사용률' ,
    `cpu_idle` DOUBLE  DEFAULT 0 COMMENT '프리 사용률' ,
    `reg_mgr_id` VARCHAR(50) COMMENT '등록자ID' ,
    `reg_dt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시' ,
    PRIMARY KEY (`sts_base_sn`),
    INDEX PK_INDEX(`sts_base_sn`),
    INDEX STS_DT_INDEX(`sts_dt`)
 ) ENGINE=InnoDB DEFAULT CHARSET=UTF8 COMMENT = '1분 CPU 사용률';


DROP TABLE IF EXISTS `STS_CPU_USAGE`;
CREATE TABLE `STS_CPU_USAGE` (
    `sts_sn` BIGINT(20) UNSIGNED NOT NULL  AUTO_INCREMENT  COMMENT '1시간 통계 순번' ,
    `sts_dt`   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '일자',
    `sts_type` CHAR(1) NOT NULL DEFAULT 'H' COMMENT '집계 구분' , -- 0: 시간, 1: 일
    `cpu_usage` DOUBLE  DEFAULT 0 COMMENT '평균 시스템 사용률' ,
    `cpu_min` DOUBLE  DEFAULT 0 COMMENT '최소 사용률' ,
    `cpu_max` DOUBLE  DEFAULT 0 COMMENT '최대 사용률' ,
    `cpu_idle` DOUBLE  DEFAULT 0 COMMENT '평균 프리 사용율' ,
    `reg_mgr_id` VARCHAR(50) COMMENT '등록자ID' ,
    `reg_dt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시' ,
    PRIMARY KEY (`sts_sn`),
    INDEX PK_INDEX(`sts_sn`),
    INDEX STS_INDEX(`sts_type`, `sts_dt`)
 ) ENGINE=InnoDB DEFAULT CHARSET=UTF8 COMMENT = 'CPU 사용률 집계';

DROP TABLE IF EXISTS `STS_SWAP_BASE_USAGE`;
CREATE TABLE `STS_SWAP_BASE_USAGE` (
    `sts_base_sn` BIGINT(20) UNSIGNED NOT NULL  AUTO_INCREMENT  COMMENT '1분 통계 순번' ,
    `sts_dt`   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '일자',
    `swap_usage` DOUBLE  DEFAULT 0 COMMENT '스왑 사용률' ,
    `swap_size` BIGINT  DEFAULT 0 COMMENT '스왑 크기' ,
    `swap_use` BIGINT  DEFAULT 0 COMMENT '스왑 사용크기' ,
    `swap_free` BIGINT   COMMENT '스왑 빈 공간 크기' ,
    `reg_mgr_id` VARCHAR(50) COMMENT '등록자ID' ,
    `reg_dt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시' ,
    PRIMARY KEY (`sts_base_sn`),
    INDEX PK_INDEX(`sts_base_sn`),
    INDEX STS_DT_INDEX(`sts_dt`)
 ) ENGINE=InnoDB DEFAULT CHARSET=UTF8 COMMENT = '1분 SWAP 사용률';

DROP TABLE IF EXISTS `STS_SWAP_USAGE`;
CREATE TABLE `STS_SWAP_USAGE` (
    `sts_sn` BIGINT(20) UNSIGNED NOT NULL  AUTO_INCREMENT  COMMENT '1시간 통계 순번' ,
    `sts_type` CHAR(1) NOT NULL DEFAULT 'H' COMMENT '집계 구분' , -- 0: 시간, 1: 일
    `sts_dt`   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '일자' ,
    `swap_usage` DOUBLE  DEFAULT 0 COMMENT '스왑 사용률' ,
    `swap_size` BIGINT  DEFAULT 0 COMMENT '스왑 크기' ,
    `swap_use` BIGINT  DEFAULT 0 COMMENT '스왑 사용크기' ,
    `swap_free` BIGINT  DEFAULT 0 COMMENT '스왑 빈 공간 크기' ,
    `swap_min` DOUBLE  DEFAULT 0 COMMENT '스왑 최소 사용률' ,
    `swp_max` DOUBLE  DEFAULT 0 COMMENT '스왑 최대 사용률' ,
    `reg_mgr_id` VARCHAR(50)  COMMENT '등록자ID' ,
    `reg_dt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시' ,
    PRIMARY KEY (`sts_sn`),
    INDEX PK_INDEX(`sts_sn`),
    INDEX STS_INDEX(`sts_type`, `sts_dt`)
 ) ENGINE=InnoDB DEFAULT CHARSET=UTF8 COMMENT = 'SWAP 사용률 집계';

DROP TABLE IF EXISTS `STS_MEM_BASE_USAGE`;
CREATE TABLE `STS_MEM_BASE_USAGE` (
    `sts_base_sn` BIGINT(20) UNSIGNED NOT NULL  AUTO_INCREMENT  COMMENT '1분 통계 순번' ,
    `sts_dt`   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '일자' ,
    `mem_usage` DOUBLE  DEFAULT 0 COMMENT '메모리 사용률' ,
    `mem_size` BIGINT  DEFAULT 0 COMMENT '메모리 크기' ,
    `mem_use` BIGINT  DEFAULT 0 COMMENT '메모리 사용크기' ,
    `mem_free` BIGINT   COMMENT '메모리 빈 공간 크기' ,
    `reg_mgr_id` VARCHAR(50) COMMENT '등록자ID' ,
    `reg_dt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시' ,
    PRIMARY KEY (`sts_base_sn`),
    INDEX PK_INDEX(`sts_base_sn`),
    INDEX STS_DT_INDEX(`sts_dt`)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8 COMMENT = '1분 Memory 사용률';

DROP TABLE IF EXISTS `STS_MEM_USAGE`;
CREATE TABLE `STS_MEM_USAGE` (
    `sts_sn` BIGINT(20) UNSIGNED NOT NULL  AUTO_INCREMENT  COMMENT '1시간 통계 순번' ,
    `sts_dt`   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '일자' ,
    `sts_type` CHAR(1) NOT NULL DEFAULT 'H' COMMENT '집계 구분' , -- 0: 시간, 1: 일
    `mem_usage` DOUBLE  DEFAULT 0 COMMENT '메모리 사용률' ,
    `mem_size` BIGINT  DEFAULT 0 COMMENT '메모리 크기' ,
    `mem_use` BIGINT  DEFAULT 0 COMMENT '메모리 사용크기' ,
    `mem_free` BIGINT  DEFAULT 0 COMMENT '메모리 빈 공간 크기' ,
    `mem_min` DOUBLE   COMMENT '메모리 최소 사용률' ,
    `mem_max` DOUBLE   COMMENT '메모리 최대 사용률' ,
    `reg_mgr_id` VARCHAR(50)  COMMENT '등록자ID' ,
    `reg_dt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시' ,
    PRIMARY KEY (`sts_sn`),
    INDEX PK_INDEX(`sts_sn`),
    INDEX STS_INDEX(`sts_type`, `sts_dt`)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8 COMMENT = 'Memory 사용률 집계';

DROP TABLE IF EXISTS `STS_DISK_BASE_USAGE`;
CREATE TABLE `STS_DISK_BASE_USAGE` (
    `sts_base_sn` BIGINT(20) UNSIGNED NOT NULL  AUTO_INCREMENT  COMMENT '1분 통계 순번' ,
    `sts_dt`   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '일자' ,
    `disk_drive` CHAR(2) NOT NULL COMMENT '디스크 드라이브',
    `disk_usage` DOUBLE  DEFAULT 0 COMMENT '디스크, 사용률' ,
    `disk_size` BIGINT  DEFAULT 0 COMMENT '디스크 크기' ,
    `disk_use` BIGINT  DEFAULT 0 COMMENT '디스크 사용크기' ,
    `disk_free` BIGINT   COMMENT '디스크 빈 공간 크기' ,
    `reg_mgr_id` VARCHAR(50)  COMMENT '등록자ID' ,
    `reg_dt` DATETIME NOT NULL  COMMENT '등록자ID' ,
    PRIMARY KEY (`sts_base_sn`),
    INDEX PK_INDEX(`sts_base_sn`),
    INDEX STS_DT_INDEX(`sts_dt`)
  ) ENGINE=InnoDB DEFAULT CHARSET=UTF8 COMMENT = '1분 DISK 사용률';

DROP TABLE IF EXISTS `STS_DISK_USAGE`;
CREATE TABLE `STS_DISK_USAGE` (
    `sts_sn` BIGINT(20) UNSIGNED NOT NULL  AUTO_INCREMENT  COMMENT '1시간 통계 순번' ,
    `sts_dt`   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '일자' ,
    `disk_drive` CHAR(2) NOT NULL COMMENT '디스크 드라이브',
    `sts_type` CHAR(1) NOT NULL DEFAULT 'H' COMMENT '집계 구분' , -- 0: 시간, 1: 일
    `disk_usage` DOUBLE  DEFAULT 0 COMMENT 'DISK 사용률' ,
    `disk_size` BIGINT  DEFAULT 0 COMMENT 'DISK 크기' ,
    `disk_use` BIGINT  DEFAULT 0 COMMENT 'DISK 사용크기' ,
    `disk_free` BIGINT  DEFAULT 0 COMMENT 'DISK 빈 공간 크기' ,
    `disk_min` DOUBLE   COMMENT 'DISK 최소 사용률' ,
    `disk_max` DOUBLE   COMMENT 'DISK 최대 사용률' ,
    `reg_mgr_id` VARCHAR(50)  COMMENT '등록자ID' ,
    `reg_dt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시' ,
    PRIMARY KEY (`sts_sn`),
    INDEX PK_INDEX(`sts_sn`),
    INDEX STS_INDEX(`sts_type`, `sts_dt`)
 ) ENGINE=InnoDB DEFAULT CHARSET=UTF8 COMMENT = 'DISK 사용률 집계';

DROP TABLE IF EXISTS `STS_USAGE_BASE`;
CREATE TABLE `STS_USAGE_BASE` (
    `sts_base_sn` BIGINT(20) UNSIGNED NOT NULL  AUTO_INCREMENT  COMMENT '1분 통계 순번' ,
    `sts_dt`   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '일자' ,
    `usage_val` INT   COMMENT '사용값' ,
    -- `usage_type` VARCHAR(10)   COMMENT '사용값 구분' ,
    `reg_mgr_id` VARCHAR(50)  COMMENT '등록자ID' ,
    `reg_dt` DATETIME NOT NULL  COMMENT '등록자ID' ,
    PRIMARY KEY (`sts_base_sn`),
    INDEX PK_INDEX(`sts_base_sn`),
    INDEX STS_DT_INDEX(`sts_dt`)
  ) ENGINE=InnoDB DEFAULT CHARSET=UTF8 COMMENT = '1분 가동률';

DROP TABLE IF EXISTS `STS_USAGE`;
CREATE TABLE `STS_USAGE` (
    `sts_sn` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT  COMMENT '1시간 통계 순번' ,
    `sts_dt`   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '일자' ,
    `sts_type` CHAR(1) NOT NULL DEFAULT 'H' COMMENT '집계 구분' , -- 0: 시간, 1: 일
    `usage_val` DOUBLE  DEFAULT 0 COMMENT '사용값' ,
    -- `usage_type` VARCHAR(10)  DEFAULT 0 COMMENT '사용값 구분' ,
    `reg_mgr_id` VARCHAR(50)  COMMENT '등록자ID' ,
    `reg_dt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시' ,
    PRIMARY KEY (`sts_sn`),
    INDEX PK_INDEX(`sts_sn`),
    INDEX STS_INDEX(`sts_type`, `sts_dt`)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8 COMMENT = '가동률 집계';

DROP TABLE IF EXISTS `STS_NETWORK_BASE`;
CREATE TABLE `STS_NETWORK_BASE` (
    `sts_base_sn` BIGINT(20) UNSIGNED NOT NULL  AUTO_INCREMENT  COMMENT '1분 통계 순번' ,
    `sts_dt`   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '일자' ,
    `nw_id`    VARCHAR(100) NOT NULL COMMENT 'Network IF id',
    `nw_nm`    VARCHAR(1000)  COMMENT 'Network IF nm',
    `rx_byte` BIGINT UNSIGNED   COMMENT 'in traffic (단위:kbps)' ,
    `tx_byte` BIGINT UNSIGNED   COMMENT 'out traffic (단위:kbps)' ,
    `inbound` BIGINT UNSIGNED   COMMENT 'in 누적 전송량 (단위:kbps)' ,
    `outbound` BIGINT UNSIGNED   COMMENT 'out 누적 전송량 (단위:kbps)' ,
     `net_rx_bytes` BIGINT UNSIGNED COMMENT '누적 io traffic',
     `net_tx_bytes` BIGINT UNSIGNED COMMENT '누적 our traffic',
    `reg_mgr_id` VARCHAR(50)  COMMENT '등록자ID' ,
    `reg_dt` DATETIME NOT NULL  COMMENT '등록자ID' ,
    PRIMARY KEY (`sts_base_sn`, `sts_dt`, `nw_id`),
    INDEX PK_INDEX(`sts_base_sn`, `sts_dt`, `nw_id`),
    INDEX STS_DT_INDEX(`sts_dt`)
 ) ENGINE=InnoDB DEFAULT CHARSET=UTF8 COMMENT = '1분 네트워크';

DROP TABLE IF EXISTS `STS_NETWORK`;
CREATE TABLE `STS_NETWORK` (
    `sts_sn` BIGINT(20) UNSIGNED NOT NULL  AUTO_INCREMENT  COMMENT '1시간 통계 순번' ,
    `sts_dt`   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '일자' ,
    `nw_id`    VARCHAR(100) NOT NULL COMMENT 'Network IF id',
    `nw_nm`    VARCHAR(1000)  COMMENT 'Network IF nm',
    `sts_type` CHAR(1) NOT NULL DEFAULT 'H' COMMENT '집계 구분' , -- 0: 시간, 1: 일
    `rx_byte` BIGINT UNSIGNED   COMMENT 'in traffic (단위:kbps)' ,
    `tx_byte` BIGINT UNSIGNED   COMMENT 'out traffic (단위:kbps)' ,
    `inbound` BIGINT UNSIGNED   COMMENT 'in 누적 전송량 (단위:MB)' ,
    `outbound` BIGINT UNSIGNED   COMMENT 'out 누적 전송량 (단위:MB)' ,
    `rx_byte_min` BIGINT UNSIGNED   COMMENT 'in traffic 최소 (단위:kbps)' ,
    `rx_byte_max` BIGINT UNSIGNED   COMMENT 'in traffic 최대 (단위:kbps)' ,
    `tx_byte_min` BIGINT UNSIGNED   COMMENT 'out traffic 최소 (단위:kbps)' ,
    `tx_byte_max` BIGINT UNSIGNED   COMMENT 'out traffic 최대 (단위:kbps)' ,
    `inbound_min` BIGINT UNSIGNED   COMMENT 'in 누적 전송량 최소 (단위:MB)' ,
    `inbound_max` BIGINT UNSIGNED   COMMENT 'in 누적 전송량 최대 (단위:MB)' ,
    `outbound_min` BIGINT UNSIGNED   COMMENT 'out 누적 전송량 최소 (단위:MB)' ,
    `outbound_max` BIGINT UNSIGNED   COMMENT 'out 누적 전송량 최대 (단위:MB)' ,
    `reg_mgr_id` VARCHAR(50)  COMMENT '등록자ID' ,
    `reg_dt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시' ,
    PRIMARY KEY (`sts_sn`, `sts_dt`, `nw_id`),
    INDEX PK_INDEX(`sts_sn`, `sts_dt`, `nw_id`),
    INDEX STS_INDEX(`sts_type`, `sts_dt`)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8 COMMENT = '네트워크 집계';

DROP TABLE IF EXISTS `STS_NETWORK_LIST` ;
CREATE TABLE `STS_NETWORK_LIST` (
  `nw_id`    VARCHAR(100) NOT NULL COMMENT 'Network IF id',
  `nw_nm`    VARCHAR(1000)  COMMENT 'Network IF nm',
  `reg_dt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시' ,
  PRIMARY KEY (`nw_id`),
  INDEX PK_INDEX(`nw_id`)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8 COMMENT = '네트워크 리스트';
-- 2020-04-03 추가 매니저 서버 관리 관련 테이블 END


-- 20200618 성능 개선을 위한 테이블 생성 ↓↓↓↓↓↓↓↓↓↓↓↓↓↓
-- 몽고DB에 있는 일부 항목들을 RDB로 옮겨와서 처리하기 위함.
-- TODO:
--   1. 계정삭제/자산이 삭제 될경우 함께 삭제가 되어야 한다.
--   2. 원래 conf테이블에서 CRUD로 인한 아래의 테이블이 관리가 안되는 경우를 생각해 보아야함.(싱크처리:정기적으로 conf테이블과 비교하여 남아있는 데이터를 삭제처리)
--   3. 20200629 URL/PING 집계도 필요하므로 추가한다. MongoDB 알람이력에 추가시 갱신하도록 한다.
-- 관련 테이블 mgr_host_process_conf
DROP TABLE IF EXISTS `INFO_HOST_CHG_HOUR_STAT` ;
CREATE TABLE `INFO_HOST_CHG_HOUR_STAT` (
`host_sn` BIGINT(20) UNSIGNED NOT NULL  COMMENT 'HOST번호' ,
`stat_dtm` VARCHAR(10) NOT NULL  COMMENT '집계일시(YYYYMMDDHH)' ,
`hfw_deny_cnt` INT UNSIGNED   COMMENT '방화벽 차단 건수' ,
`hfw_allow_cnt` INT UNSIGNED   COMMENT '방화벽 허용 건수' ,
`integrity_add_cnt` INT UNSIGNED   COMMENT '무결성 생성 건수' ,
`integrity_del_cnt` INT UNSIGNED   COMMENT '무결성 삭제 건수' ,
`integrity_upd_cnt` INT UNSIGNED   COMMENT '무결성 수정 건수' ,
`mon_critical_cnt` INT UNSIGNED   COMMENT '모니터링 위험 건수' ,
`mon_warn_cnt` INT UNSIGNED   COMMENT '모니터링 주의 건수' ,
`etc_critical_cnt` INT UNSIGNED   COMMENT 'URL/PING 위험 건수' ,
`etc_warn_cnt` INT UNSIGNED   COMMENT 'URL/PING 주의 건수' ,
`work_dt` TIMESTAMP  DEFAULT CURRENT_TIMESTAMP COMMENT '생성 일시' ,
`mod_dt` TIMESTAMP  DEFAULT CURRENT_TIMESTAMP ON UPDATE  CURRENT_TIMESTAMP  COMMENT '변경 일시' , -- update 시 자동으로 입력됨
PRIMARY KEY (`host_sn`, `stat_dtm` ),
INDEX PK_INDEX(`host_sn`, `stat_dtm`)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8 COMMENT= '호스트 시간별 변동 현황 집계' ;

DROP TABLE IF EXISTS `INFO_HOST_RESOURCES_STAT` ;
CREATE TABLE `INFO_HOST_RESOURCES_STAT` (
`host_sn` BIGINT(20) UNSIGNED NOT NULL  COMMENT 'HOST번호' ,
`cpu_usage` TINYINT(3) UNSIGNED   COMMENT 'CPU 사용률' , -- 0~100
`mem_usage` TINYINT(3) UNSIGNED   COMMENT 'Memory 사용률' , -- 0~100
`swap_usage` TINYINT(3) UNSIGNED   COMMENT 'Swap 사용률' , -- 0~100
`disk_usage` TINYINT(3) UNSIGNED   COMMENT 'DISK 사용률' , -- 호스트중 최대 사용률
`dmount_usage` TINYINT(3) UNSIGNED   COMMENT 'DISK 마운트 사용률' , -- 호스트중 최대 사용률
`traffic_in_sum` BIGINT   COMMENT 'Traffic in total byte' , -- 호스트의 총 합계
`traffic_out_sum` BIGINT   COMMENT 'Traffic out total byte' , -- 호스트의 총 합계
`trans_in_sum` BIGINT   COMMENT '누적전송량(60분) in total byte' , -- 호스트의 총 합계 (1시간에 1번만 update한다)
`trans_out_sum` BIGINT   COMMENT '누적전송량(60분) out total byte' , -- 호스트의 총 합계 (1시간에 1번만 update한다)
`work_dt` TIMESTAMP  DEFAULT CURRENT_TIMESTAMP COMMENT '생성 일시' ,
`mod_dt` TIMESTAMP  DEFAULT CURRENT_TIMESTAMP ON UPDATE  CURRENT_TIMESTAMP  COMMENT '변경 일시' , -- update 시 자동으로 입력됨
PRIMARY KEY (`host_sn` ),
INDEX PK_INDEX(`host_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8 COMMENT= '에이전트 호스트 리소스 상태' ;


DROP TABLE IF EXISTS `INFO_HOST_RESOURCES_DTL_STAT` ;
CREATE TABLE `INFO_HOST_RESOURCES_DTL_STAT` (
`host_sn` BIGINT(20) UNSIGNED NOT NULL  COMMENT 'HOST번호' ,
`index` INT UNSIGNED NOT NULL  COMMENT '자산 index' ,
`disk_usage` TINYINT(3) UNSIGNED   COMMENT 'DISK 사용률' ,
`dmount_uasge` TINYINT(3) UNSIGNED   COMMENT 'DISK 마운트 사용률' ,
`traffic_in` BIGINT   COMMENT 'Traffic in byte' ,
`traffic_out` BIGINT   COMMENT 'Traffic out byte' ,
`trans_in` BIGINT   COMMENT '누적전송량(60분) in byte' , -- 1시간에 1번 update
`trans_out` BIGINT   COMMENT '누적전송량(60분) out byte' , -- 1시간에 1번 update
`work_dt` TIMESTAMP  DEFAULT CURRENT_TIMESTAMP COMMENT '생성 일시' ,
`mod_dt` TIMESTAMP  DEFAULT CURRENT_TIMESTAMP ON UPDATE  CURRENT_TIMESTAMP  COMMENT '변경 일시' , -- update 시 자동으로 입력됨
PRIMARY KEY (`host_sn`, `index` ),
INDEX PK_INDEX(`host_sn`, `index`),
INDEX HOST_INDEX(`host_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8 COMMENT= '호스트 리소스 상세 상태' ;

-- 관련 테이블 mgr_host_process_conf
DROP TABLE IF EXISTS `INFO_HOST_PROCESS_STAT` ;
CREATE TABLE `INFO_HOST_PROCESS_STAT` (
`host_process_no` BIGINT UNSIGNED NOT NULL COMMENT '호스트 프로세스 설정 번호' ,
`host_sn` BIGINT(20) UNSIGNED NOT NULL COMMENT 'HOST번호' ,
`process_pid` INT UNSIGNED   COMMENT 'PID' ,
`process_cpu_usage` TINYINT(3) UNSIGNED   COMMENT 'CPU 사용률' ,
`process_mem_usage` TINYINT(3) UNSIGNED   COMMENT 'MEM 사용률' ,
`process_cnt` INT UNSIGNED   COMMENT '프로세스 개수' ,
`work_dt` TIMESTAMP  DEFAULT CURRENT_TIMESTAMP COMMENT '생성 일시' ,
`mod_dt` TIMESTAMP  DEFAULT CURRENT_TIMESTAMP ON UPDATE  CURRENT_TIMESTAMP  COMMENT '변경 일시' , -- update 시 자동으로 입력됨
PRIMARY KEY (`host_process_no`, `host_sn`),
INDEX PK_INDEX(`host_process_no`, `host_sn`),
INDEX HOST_INDEX(`host_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8 COMMENT= '호스트 관심 프로세스 현황' ;

-- 관련 테이블 mgr_host_port_conf
DROP TABLE IF EXISTS `INFO_HOST_PORT_STAT` ;
CREATE TABLE `INFO_HOST_PORT_STAT` (
  host_port_no BIGINT UNSIGNED NOT NULL COMMENT '호스트_포트_설정_번호',
  host_sn BIGINT(20) UNSIGNED NOT NULL COMMENT '호스트번호',
  port_alarm_type TINYINT UNSIGNED COMMENT 'port알람(4:주의, 1:위험, 0:정상)',
`work_dt` TIMESTAMP  DEFAULT CURRENT_TIMESTAMP COMMENT '생성 일시' ,
`mod_dt` TIMESTAMP  DEFAULT CURRENT_TIMESTAMP ON UPDATE  CURRENT_TIMESTAMP  COMMENT '변경 일시' , -- update 시 자동으로 입력됨
PRIMARY KEY (`host_port_no` , `host_sn`),
INDEX PK_INDEX(`host_port_no`, `host_sn`),
INDEX HOST_INDEX(`host_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8 COMMENT= '호스트 포트 현황' ;
-- 20200618 성능 개선을 위한 테이블 생성 ↑↑↑↑↑↑↑↑↑↑↑↑↑


-- 20200630 테이블 생성 ↓↓↓↓↓↓↓↓↓↓↓↓↓↓
drop table if exists astron.mgr_url_result;
create table astron.mgr_url_result (
mon_result_no INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'URL결과번호'
,host_url_no INT UNSIGNED NOT NULL COMMENT '호스트URL번호'
,result_at DATETIME NOT NULL COMMENT '결과일시'
,mon_result TINYINT UNSIGNED NOT NULL COMMENT '측정결과(0:정상, 1:TIMEOUT, 2:상태오류)'
,mon_result_msg VARCHAR(48)  COMMENT '측정결과(0:정상, 1:TIMEOUT, 2:상태오류)'
,http_status INT UNSIGNED  COMMENT 'HTTP상태코드'
,response_time INT UNSIGNED  COMMENT '응답시간(ms)'
,host_sn INT UNSIGNED NOT NULL COMMENT '호스트번호'
,alarm_level TINYINT UNSIGNED NOT NULL COMMENT '알람등급(0:정상, 2:위험, 4:주의)'
,response_limit INT UNSIGNED  COMMENT '응답시간임계치(ms)'
,base_min DATETIME  COMMENT '기준_분(yyyy-mm-dd hh:mi:00)'
,base_10min DATETIME  COMMENT '기준_10분(yyyy-mm-dd hh:m0:00)'
,base_hr DATETIME  COMMENT '기준_시각(yyyy-mm-dd hh:00:00)'
)
ENGINE = INNODB CHARACTER SET UTF8 COMMENT = 'url측정결과';
show full columns from astron.mgr_url_result;

CREATE  INDEX idx_url_result_at ON astron.mgr_url_result(result_at);
CREATE  INDEX idx_url_result_host ON astron.mgr_url_result(host_sn);
CREATE  INDEX idx_url_result_host_url_no ON astron.mgr_url_result(host_url_no);
CREATE  INDEX idx_url_result_min ON astron.mgr_url_result(host_sn, base_min);
CREATE  INDEX idx_url_result_10min ON astron.mgr_url_result(host_sn, base_10min);
CREATE  INDEX idx_url_result_hr ON astron.mgr_url_result(host_sn, base_hr);


drop table if exists astron.mgr_ping_result;
create table astron.mgr_ping_result (
mon_result_no INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'PING결과번호'
,ip VARCHAR(48) NOT NULL COMMENT 'PING IP'
,result_at DATETIME NOT NULL COMMENT '결과일시'
,mon_result TINYINT UNSIGNED NOT NULL COMMENT '측정결과(0:정상, 1:TIMEOUT, 2:Unknown Host, 3:Unreachable Host, 9:Unknown Error)'
,mon_result_msg VARCHAR(48)  COMMENT '결과메시지'
,rtt_min FLOAT  COMMENT '최소시간(ms)'
,rtt_avg FLOAT  COMMENT '평균시간(ms)'
,rtt_max FLOAT  COMMENT '최대시간(ms)'
,error_cnt INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '오류발생횟수'
,host_sn INT UNSIGNED NOT NULL COMMENT '호스트번호'
,alarm_level TINYINT UNSIGNED NOT NULL COMMENT '알람등급(0:정상, 2:위험, 4:주의)'
,ping_limit_warn TINYINT UNSIGNED NOT NULL COMMENT 'ping지속_주의(단위:회)'
,ping_limit_cri TINYINT UNSIGNED NOT NULL COMMENT 'ping지속_위험(단위:회)'
,base_min DATETIME  COMMENT '기준_분(yyyy-mm-dd hh:mi:00)'
,base_10min DATETIME  COMMENT '기준_10분(yyyy-mm-dd hh:m0:00)'
,base_hr DATETIME  COMMENT '기준_시각(yyyy-mm-dd hh:00:00)'
)
ENGINE = INNODB CHARACTER SET UTF8 COMMENT = 'ping측정결과';
show full columns from astron.mgr_ping_result;

CREATE  INDEX idx_ping_result_at ON astron.mgr_ping_result(result_at);
CREATE  INDEX idx_ping_result_host ON astron.mgr_ping_result(host_sn);
CREATE  INDEX idx_ping_result_ip ON astron.mgr_ping_result(ip);
CREATE  INDEX idx_ping_result_min ON astron.mgr_ping_result(host_sn, base_min);
CREATE  INDEX idx_ping_result_10min ON astron.mgr_ping_result(host_sn, base_10min);
CREATE  INDEX idx_ping_result_hr ON astron.mgr_ping_result(host_sn, base_hr);

-- 20200630 테이블 생성 ↑↑↑↑↑↑↑↑↑↑↑↑↑

drop table  if exists astron.tbl_no;
create table astron.tbl_no (
no INT UNSIGNED NOT NULL COMMENT '일련번호(0,1,2…)'
)  
ENGINE = INNODB CHARACTER SET UTF8 COMMENT = '일련번호';
show full columns from astron.tbl_no;

ALTER TABLE astron.tbl_no ADD PRIMARY KEY (no);

INSERT INTO tbl_no(NO) 
SELECT @row := @row + 1 AS row FROM 
(select 0 union all select 1 union all select 2 union all select 3 union all select 4 union all select 5 union all select 6 union all select 7 union all select 8 union all select 9) t,
(select 0 union all select 1 union all select 2 union all select 3 union all select 4 union all select 5 union all select 6 union all select 7 union all select 8 union all select 9) t2, 
(select 0 union all select 1 union all select 2 union all select 3 union all select 4 union all select 5 union all select 6 union all select 7 union all select 8 union all select 9) t3, 
(select 0 union all select 1 union all select 2 union all select 3 union all select 4 union all select 5 union all select 6 union all select 7 union all select 8 union all select 9) t4, 
(SELECT @row:=0) numbers; 