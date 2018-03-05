conn c##_nbl_cc_txns_dm/"Welcome2018!";

CREATE OR REPLACE PROCEDURE BUILD_RT_HIER_SNAP IS
BEGIN FOR DT IN (
    SELECT
        MONTH_WID,
        MONTH
    FROM
        MONTH_DIM
)
LOOP
    INSERT INTO RT_HIER_SNAP (
        ROW_WID,
        MONTH_WID,
        EMPLOYEE_NUMBER,
        EMPLOYEE_ID,
        FIRST_NAME,
        LAST_NAME,
        EMAIL_ADDRESS,
        NAME,
        SUPERVISOR_ID,
        REPORTS_TO_PATH,
        EXEC_MANAGER
    )
        SELECT
            TO_CHAR(EMPLOYEE_ID) || '~' || DT.MONTH_WID,
            DT.MONTH_WID,
            EMPLOYEE_NUMBER,
            EMPLOYEE_ID,
            FIRST_NAME,
            LAST_NAME,
            EMAIL_ADDRESS,
            NAME,
            SUPERVISOR_ID,
            REPORTS_TO_PATH,
            EXEC_MANAGER
        FROM
            FUNC_RT_HIER_TABLE_TYPE(DT.MONTH); 
END LOOP; 
END BUILD_RT_HIER_SNAP;
/

EXEC BUILD_RT_HIER_SNAP;

