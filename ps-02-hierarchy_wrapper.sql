conn c##_nbl_cc_txns_dm/"Welcome2018!";

CREATE OR REPLACE TYPE RT_HIER_TYPE AS OBJECT (
EMPLOYEE_NUMBER NUMBER(22,10),
FIRST_NAME VARCHAR2(450),
LAST_NAME VARCHAR2(450),
EMAIL_ADDRESS VARCHAR2(720),
NAME VARCHAR2(2100),
SUPERVISOR_ID NUMBER(22,10),
REPORTS_TO_PATH VARCHAR2(4000),
EXEC_MANAGER VARCHAR2(4000));
/

CREATE OR REPLACE TYPE RT_HIER_TABLE_TYPE AS TABLE OF RT_HIER_TYPE;
/

CREATE OR REPLACE FUNCTION FUNC_RT_HIER_TABLE_TYPE (INP_DATE IN DATE DEFAULT SYSDATE)
RETURN RT_HIER_TABLE_TYPE
PIPELINED
AS
BEGIN

   FOR V_REC IN (SELECT
    EMPLOYEE_NUMBER,
    FIRST_NAME,
    LAST_NAME,
    EMAIL_ADDRESS,
    NAME,
    SUPERVISOR_ID,
    SYS_CONNECT_BY_PATH(LAST_NAME,'/') REPORTS_TO_PATH,
    CASE
            WHEN LEVEL < 3
                 AND LEVEL > 1 THEN REPLACE(REPLACE(SYS_CONNECT_BY_PATH(LAST_NAME,'/'),'/'
            || LAST_NAME,''),'/','')
            WHEN LEVEL >= 3  THEN SUBSTR(SYS_CONNECT_BY_PATH(LAST_NAME,'/'),INSTR(SYS_CONNECT_BY_PATH(LAST_NAME,'/'),'/',1,2) + 1,INSTR(SYS_CONNECT_BY_PATH
(LAST_NAME,'/'),'/',2,2) - INSTR(SYS_CONNECT_BY_PATH(LAST_NAME,'/'),'/',1,2) - 1)
            ELSE REPLACE(SYS_CONNECT_BY_PATH(LAST_NAME,'/'),'/')
        END
    AS EXEC_MANAGER
FROM
    (
        SELECT
            PAPF.EMPLOYEE_NUMBER,
            PAPF.PERSON_ID,
            PAPF.FIRST_NAME,
            PAPF.LAST_NAME,
            PAPF.EMAIL_ADDRESS,
            PJ.NAME,
            PAAF.SUPERVISOR_ID
        FROM
            HR.PER_ALL_PEOPLE_F@EBS PAPF,
            HR.PER_ALL_ASSIGNMENTS_F@EBS PAAF,
            HR.PER_JOBS@EBS PJ
        WHERE
            PAPF.PERSON_ID = PAAF.PERSON_ID
            AND   PAAF.JOB_ID = PJ.JOB_ID (+)
            AND   PAAF.PRIMARY_FLAG = 'Y'
            AND   PAAF.ASSIGNMENT_TYPE = 'E'
            AND   PAPF.CURRENT_EMPLOYEE_FLAG = 'Y'
            AND   PAAF.EMPLOYMENT_CATEGORY != 'RESTORE'
            AND   INP_DATE BETWEEN PAAF.EFFECTIVE_START_DATE AND PAAF.EFFECTIVE_END_DATE
            AND   INP_DATE BETWEEN PAPF.EFFECTIVE_START_DATE AND PAPF.EFFECTIVE_END_DATE
    )
START WITH
    SUPERVISOR_ID IS NULL
CONNECT BY
    PRIOR PERSON_ID = SUPERVISOR_ID
ORDER BY
    LEVEL ASC) LOOP

      PIPE ROW (RT_HIER_TYPE(V_REC.EMPLOYEE_NUMBER, V_REC.FIRST_NAME ,V_REC.LAST_NAME,V_REC.EMAIL_ADDRESS, V_REC.NAME, V_REC.SUPERVISOR_ID, V_REC.REPORTS_TO_PATH, V_REC.EXEC_MANAGER));

   END LOOP;

RETURN;
END;
/