conn c##_nbl_cc_txns_dm/"Welcome2018!";

CREATE TABLE credit_card_txns
    AS
        ( SELECT
            last_day(txn.posted_date) posted_period,
            txn.posted_date,
            txn.billed_amount,
            txn.billed_currency_code,
            txn.merchant_name1,
            txn.merchant_city,
            txn.expense_status,
            txn.trx_id,
            snap.first_name,
            snap.last_name,
            snap.email_address,
            snap.name,
            snap.reports_to_path,
            snap.exec_manager
          FROM
            rt_hier_snap snap,
            emp_txns txn
          WHERE
            snap.row_wid = txn.rt_wid
            AND   txn.transaction_date >= add_months(last_day(SYSDATE),-36)
        );