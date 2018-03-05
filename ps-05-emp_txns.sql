conn c##_nbl_cc_txns_dm/"Welcome2018!";

CREATE TABLE EMP_TXNS AS (
SELECT
crds.employee_id || '~' || to_char(last_day(cctxn.transaction_date),'YYYYMM') AS RT_WID,
crds.employee_id,
cctxn.transaction_date,
cctxn.billed_date,
cctxn.posted_date,
cctxn.trx_available_date,
cctxn.last_update_date,
cctxn.transaction_amount,
cctxn.expensed_amount,
cctxn.billed_amount,
cctxn.billed_currency_code,
cctxn.card_program_id,
cctxn.sic_code,
cctxn.merchant_name1,
cctxn.merchant_city,
cctxn.merchant_province_state,
cctxn.merchant_postal_code,
cctxn.merchant_country,
cctxn.category,
cctxn.report_header_id,
cctxn.expense_status,
cctxn.card_id,
cctxn.reference_number,
cctxn.trx_id
FROM ap_credit_card_trxns_all@ebs cctxn, ap_cards_all@ebs crds
where
cctxn.card_id = crds.card_id)
;
