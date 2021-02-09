# RCS_TEST
## 설문 듀프 해제
=> 설문 듀프인경우 테스트 발송이 안되는 경우가 있다. 이경우 2개의 테이블에 있는 내용을 삭제하도록 한다.(삭제시 중간 쿼리 조회해서 나온거에 한해서 삭제하도록 한다)
```
UPDATE/*[survey/survey.sqlmap.xml].[updateSurveyDupTrgter] */
        SURVEY_TRGTER SET DUP_RCVER_YN = 'Y'
        WHERE SURVEY_SEQ = 4507
        AND RCVER_PHONE_NUM IN (
            SELECT
            ST.RCVER_PHONE_NUM
            FROM SURVEY_TRGTER ST
            INNER JOIN
                (
                SELECT
                    STR.SURVEY_SEQ
                    ,STR.RCVER_PHONE_NUM
                FROM SURVEY_TRGTER STR
                INNER JOIN SURVEY S
                ON S.SURVEY_SEQ = STR.SURVEY_SEQ
                AND STR.RCV_RJT_YN = 'N'
                AND STR.DUP_RCVER_YN = 'N'
                AND S.TEST_SURVEY_YN = 'N'
                AND S.SURVEY_STATE_CD in ('RUNNING','AUTO_END','MANUAL_END')
                AND TO_CHAR(S.SURVEY_END_DTTM+12/24, 'YYYY-MM-DD hh24:mi') >= TO_CHAR(SYSDATE , 'YYYY-MM-DD hh24:mi')
                UNION ALL
                SELECT
                    STR.SURVEY_SEQ
                    ,STR.RCVER_PHONE_NUM
                FROM SURVEY_TRGTER STR
                INNER JOIN SURVEY S
                ON S.SURVEY_SEQ = STR.SURVEY_SEQ
                AND STR.RCV_RJT_YN = 'N'
                AND STR.DUP_RCVER_YN = 'N'
                AND S.TEST_SURVEY_YN = 'Y'
                AND S.SURVEY_STATE_CD in ('RUNNING','AUTO_END','MANUAL_END')
                AND TO_CHAR(S.SURVEY_END_DTTM+10/(24*60), 'YYYY-MM-DD hh24:mi') >= TO_CHAR(SYSDATE , 'YYYY-MM-DD hh24:mi')
                INNER JOIN SURVEY_PARTCPTN SP
                ON STR.SURVEY_SEQ = SP.SURVEY_SEQ
                AND SP.PARTCPTN_STATE_CD NOT IN ('COMPL', 'SCR')
                AND SP.RCVER_PHONE_NUM = STR.RCVER_PHONE_NUM
                )A
            ON ST.RCVER_PHONE_NUM = A.RCVER_PHONE_NUM
            WHERE ST.SURVEY_SEQ = 4609
            AND ST.RCV_RJT_YN = 'N'
            AND ST.SURVEY_SEQ != A.SURVEY_SEQ
        )
select * from survey where survey_seq = 4609;
select * from SURVEY_TRGTER where RCVER_PHONE_NUM = '01020950147' and survey_seq = 4507;
select * from SURVEY_TRGTER where survey_seq = 4609;
delete from SURVEY_TRGTER where survey_seq = 4587;
commit
select * from SURVEY_PARTCPTN where survey_seq = 4507;
delete from SURVEY_PARTCPTN where survey_seq = 4586;
```


## 발송부터 집계까지 확인
-- ## 설문부터 정상 발송까지 확인방법
select * from survey where survey_seq= 4858;
select * from survey_rcs where survey_seq = 4858;
select * from SURVEY_TRGTER where survey_seq = 4858;
select * from snd_msg where survey_seq = 4858;
select * from mt_msg_queue where CUSTOM_REQ_ID = '7632051'; -- 7632049 7632051

select *  from mt_msg_queue where CUSTOM_REQ_ID in ('7632047','7632049','7632051','7632042','7632043','7632045','7632046','7632050','7632044','7632048')
select * from mt_snd_hist where MT_QUEUE_ID = 57102910;

