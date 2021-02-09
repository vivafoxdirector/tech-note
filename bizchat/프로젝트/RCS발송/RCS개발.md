# RCS 기획 분석
## LMS/RCS 탭 작성 경우
작성(과금유형) > 발송
------------------------------------
일반(LMS)/RCS(LMS) > 일반(LMS)/RCS(RCS_LMS)
일반(MMS)/RCS(LMS) > 일반(MMS)/RCS(RCS_MMS)
일반(LMS)/RCS(MMS) > 일반(MMS)/RCS(RCS_MMS)
일반(MMS)/RCS(MMS) > 일반(MMS)/RCS(RCS_MMS)

## 단일 탭 작성 경우
작성(과금유형) > 발송
------------------------------------
일반(LMS)/RCS(작성안함) > 일반(LMS)
일반(MMS)/RCS(작성안함) > 일반(MMS)
일반(작성안함)/RCS(LMS) > RCS(RCS_LMS)
일반(작성안함)/RCS(MMS) > RCS(RCS_MMS)

## RCS_LMS/MMS 구분
구분 방법은 
1. 컨텐츠에 슬라이드 이미지 유무에 따라 LMS/MMS 가 된다.
2. 슬라이드 수에 따라 LMS/MMS가 된다. (슬라이드가 2~6개 있는 경우 과금유형이 MMS로 전환합니다.)

# RCS개발
## RCS분석
1. 메시지 발송이 가능한 스켈레톤 코드 지원
2. RCS는 질문/설문완료/설문종료 이번 프로젝트에는 없다. 단방향이기 때문에...
3. RCS도 쿠폰은 일반과 같이 사용한다. QA.md를 확인하면 해당 내용이 있다.

## RCS적용
1. 등록
    - 일반 등록 / RCS등록 별도로 처리하도록 한다.
1. Admin-Dashboard에 RCS LMS/MMS 집계 추가
DashboardController.java/dashboard.jsp::dashboard 에서 dataMap에 성공 + 실패 + 누적 건수를 표현한다.

## RCS구동환경설정파일
- maaperUrl설정파일은 mmate-common로 위치함.
    - mmate-common:dev/local/prod/maapapi.properties.xml
- rcs 스레드 MAX 개수 mmate-survey-agent
    - core.properties.xml/rcs.send.maxcount
