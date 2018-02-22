conn c##_nbl_cc_txns_dm/"Welcome2018!";

CREATE TABLE MONTH_DIM
    AS
        ( SELECT
            TO_CHAR(LAST_DAY(ADD_MONTHS(SYSDATE,-ROWNUM + 1) ),'YYYYMM') MONTH_WID,
            LAST_DAY(ADD_MONTHS(SYSDATE,-ROWNUM + 1) ) MONTH
          FROM
            DUAL
        CONNECT BY
            LEVEL <= 36
        )
        ORDER BY
            1 ASC;