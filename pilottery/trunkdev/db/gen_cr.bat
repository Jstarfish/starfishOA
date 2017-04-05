@echo off
set SRC_DIR=%~dp0
set KMS_DEST_FILE=%SRC_DIR%\run_scripts\10-kms.sql
rem set MIS_DEST_FILE=%SRC_DIR%\run_scripts\mis_all.sql
rem set DATA_DEST_FILE=%SRC_DIR%\init_data.sql

echo set feedback off > %KMS_DEST_FILE%

rem ###########################################################################
rem ##############################���� KMS �û�����##########################
rem ###########################################################################

echo ����KMS�û����� ... [TABLE]
echo prompt ���ڽ���[TABLE]...... >> %KMS_DEST_FILE%
type %SRC_DIR%\KMS\TABLES\create-table.sql >> %KMS_DEST_FILE%

echo ����KMS�û����� ... [TEMPORARY TABLE]
echo prompt ���ڽ���[TEMPORARY TABLE]...... >> %KMS_DEST_FILE%
type %SRC_DIR%\KMS\TABLES\create-temp-tables.sql >> %KMS_DEST_FILE%

echo ����KMS�û����� ... [SEQUENCE]
echo prompt ���ڽ���[SEQUENCE]...... >> %KMS_DEST_FILE%
type %SRC_DIR%\KMS\SEQUENCE\create-sequence.sql >> %KMS_DEST_FILE%

echo ����KMS�û����� ... [TYPE]
echo prompt ���ڽ���[TYPE]...... >> %KMS_DEST_FILE%
type %SRC_DIR%\KMS\TYPE\create_type.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%

echo ����KMS�û����� ... [PACKAGE]

echo prompt ���ڽ���[PACKAGE -^> dbtool]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PACKAGE\dbtool.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PACKAGE -^> eaccount_type]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PACKAGE\eaccount_type.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PACKAGE -^> eacc_status]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PACKAGE\eacc_status.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PACKAGE -^> eacc_type]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PACKAGE\eacc_type.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PACKAGE -^> eadmin_login_status]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PACKAGE\eadmin_login_status.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PACKAGE -^> eadmin_status]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PACKAGE\eadmin_status.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PACKAGE -^> eagency_status]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PACKAGE\eagency_status.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PACKAGE -^> eagency_type]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PACKAGE\eagency_type.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PACKAGE -^> eapply_status]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PACKAGE\eapply_status.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PACKAGE -^> earea_status]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PACKAGE\earea_status.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PACKAGE -^> earea_type]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PACKAGE\earea_type.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PACKAGE -^> ebatch_item_status]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PACKAGE\ebatch_item_status.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PACKAGE -^> eboolean]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PACKAGE\eboolean.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PACKAGE -^> ebroken_source]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PACKAGE\ebroken_source.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PACKAGE -^> ecp_result]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PACKAGE\ecp_result.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PACKAGE -^> ecp_status]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PACKAGE\ecp_status.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PACKAGE -^> eflow_type]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PACKAGE\eflow_type.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PACKAGE -^> eissue_type]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PACKAGE\eissue_type.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PACKAGE -^> eorder_status]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PACKAGE\eorder_status.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PACKAGE -^> eorg_status]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PACKAGE\eorg_status.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PACKAGE -^> eorg_type]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PACKAGE\eorg_type.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PACKAGE -^> eplan_flow]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PACKAGE\eplan_flow.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PACKAGE -^> ereceipt_type]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PACKAGE\ereceipt_type.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PACKAGE -^> error_msg_en]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PACKAGE\error_msg_en.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PACKAGE -^> esex]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PACKAGE\esex.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PACKAGE -^> eticket_status]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PACKAGE\eticket_status.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PACKAGE -^> etuning_type]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PACKAGE\etuning_type.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PACKAGE -^> evalid_number]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PACKAGE\evalid_number.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PACKAGE -^> ewarehouse_status]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PACKAGE\ewarehouse_status.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PACKAGE -^> ework_status]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PACKAGE\ework_status.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PACKAGE -^> eflow_sjz]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PACKAGE\epublisher_sjz.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PACKAGE -^> epaid_status]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PACKAGE\epaid_status.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PACKAGE -^> epublisher_code]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PACKAGE\epublisher_code.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo ����KMS�û����� ... [FUNCTION]

echo prompt ���ڽ���[FUNCTION -^>   f_get_acc_no]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_get_acc_no.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>   f_get_adm_id_seq]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_get_adm_id_seq.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>   f_get_adm_name]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_get_adm_name.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>   f_get_agency_code_by_area]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_get_agency_code_by_area.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>   f_get_batch_import_seq]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_get_batch_import_seq.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>   f_get_detail_sequence_no_seq]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_get_detail_sequence_no_seq.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>   f_get_flow_agency_seq]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_get_flow_agency_seq.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>   f_get_flow_cancel_seq]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_get_flow_cancel_seq.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>   f_get_flow_gui_pay_seq]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_get_flow_gui_pay_seq.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>   f_get_flow_market_manager_seq]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_get_flow_market_manager_seq.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>   f_get_flow_org_seq]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_get_flow_org_seq.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>   f_get_flow_pay_seq]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_get_flow_pay_seq.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>   f_get_flow_sale_seq]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_get_flow_sale_seq.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>   f_get_fund_charge_cash_seq]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_get_fund_charge_cash_seq.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>   f_get_fund_charge_center_seq]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_get_fund_charge_center_seq.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>   f_get_fund_mm_cash_repay_seq]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_get_fund_mm_cash_repay_seq.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>   f_get_fund_tuning_seq]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_get_fund_tuning_seq.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>   f_get_fund_withdraw_seq]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_get_fund_withdraw_seq.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>   f_get_inf_agency_delete_seq]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_get_inf_agency_delete_seq.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>   f_get_item_code_seq]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_get_item_code_seq.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>   f_get_item_detail_seq]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_get_item_detail_seq.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>   f_get_item_ii_no_seq]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_get_item_ii_no_seq.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>   f_get_item_ir_no_seq]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_get_item_ir_no_seq.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>   f_get_item_ic_no_seq]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_get_item_ic_no_seq.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>   f_get_item_id_no_seq]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_get_item_id_no_seq.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>   f_get_lottery_info]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_get_lottery_info.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>   f_get_org_type]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_get_org_type.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>   f_get_sale_ai_seq]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_get_sale_ai_seq.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>   f_get_sale_ar_seq]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_get_sale_ar_seq.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>   f_get_sale_delivery_order_seq]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_get_sale_delivery_order_seq.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>   f_get_sale_order_seq]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_get_sale_order_seq.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>   f_get_sale_return_recoder_seq]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_get_sale_return_recoder_seq.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>   f_get_sale_transfer_bill_seq]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_get_sale_transfer_bill_seq.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>   f_get_sys_param]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_get_sys_param.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>   f_get_warehouse_code]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_get_warehouse_code.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>   f_get_whgoodsreceipt_detai_seq]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_get_whgoodsreceipt_detai_seq.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>   f_get_wh_batch_end_seq]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_get_wh_batch_end_seq.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>   f_get_wh_batch_inbound_seq]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_get_wh_batch_inbound_seq.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>   f_get_wh_broken_recoder_seq]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_get_wh_broken_recoder_seq.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>   f_get_wh_check_point_seq]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_get_wh_check_point_seq.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>   f_get_wh_goodsissue_detail_seq]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_get_wh_goodsissue_detail_seq.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>   f_get_wh_goods_issue_detai_seq]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_get_wh_goods_issue_detai_seq.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>   f_get_wh_goods_issue_seq]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_get_wh_goods_issue_seq.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>   f_get_wh_goods_receipt_detai_seq]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_get_wh_goods_receipt_detai_seq.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>   f_get_wh_goods_receipt_seq]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_get_wh_goods_receipt_seq.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>   f_lottery_print]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_lottery_print.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>   f_print_lottery_info]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_print_lottery_info.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>   f_check_org]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_check_org.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>  f_get_agency_org]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_get_agency_org.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>  f_get_admin_org]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_get_admin_org.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>  f_get_plan_name]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_get_plan_name.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>  f_check_trunk]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_check_trunk.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>  f_check_box]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_check_box.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>  f_check_pack]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_check_pack.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>  f_get_area_org]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_get_area_org.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>  f_get_flow_pay_org]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_get_flow_pay_org.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>  f_get_flow_pay_detail_no_seq]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_get_flow_pay_detail_no_seq.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>  f_get_flow_pay_detail_seq]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_get_flow_pay_detail_seq.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>  f_get_reward_ticket_ver]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_get_reward_ticket_ver.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>  f_get_switch_no_seq]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_get_switch_no_seq.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>  f_get_switch_seq]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_get_switch_seq.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>  f_get_old_plan_name]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_get_old_plan_name.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>  f_get_agency_comm_rate]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_get_agency_comm_rate.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>  f_get_comm_flow_org_seq]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_get_comm_flow_org_seq.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>  f_get_org_comm_rate]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_get_org_comm_rate.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>  f_get_org_comm_rate_by_name]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_get_org_comm_rate_by_name.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>  f_get_plan_code_by_name]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_get_plan_code_by_name.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>   f_check_admin]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_check_admin.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>   f_check_import_ticket]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_check_import_ticket.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>   f_check_plan_batch]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_check_plan_batch.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>   f_check_plan_batch_status]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_check_plan_batch_status.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>   f_check_ticket_include]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_check_ticket_include.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>   f_check_ticket_perfect]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_check_ticket_perfect.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>   f_check_warehouse]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_check_warehouse.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[FUNCTION -^>   f_get_plan_publisher]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\FUNCTION\f_get_plan_publisher.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo ����KMS�û����� ... [PROCEDURE]

echo. >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PROCEDURE -^>  p_admin_create]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PROCEDURES\p_admin_create.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PROCEDURE -^>  p_agency_fund_change]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PROCEDURES\p_agency_fund_change.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PROCEDURE -^>  p_ar_inbound]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PROCEDURES\p_ar_inbound.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PROCEDURE -^>  p_ar_outbound]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PROCEDURES\p_ar_outbound.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PROCEDURE -^>  p_batch_close]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PROCEDURES\p_batch_close.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PROCEDURE -^>  p_batch_inbound]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PROCEDURES\p_batch_inbound.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PROCEDURE -^>  p_get_lottery_history]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PROCEDURES\p_get_lottery_history.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PROCEDURE -^>  p_get_lottery_reward]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PROCEDURES\p_get_lottery_reward.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PROCEDURE -^>  p_gi_outbound]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PROCEDURES\p_gi_outbound.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PROCEDURE -^>  p_import_batch_file]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PROCEDURES\p_import_batch_file.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PROCEDURE -^>  p_institutions_create]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PROCEDURES\p_institutions_create.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PROCEDURE -^>  p_institutions_modify]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PROCEDURES\p_institutions_modify.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PROCEDURE -^>  p_institutions_topup]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PROCEDURES\p_institutions_topup.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PROCEDURE -^>  p_lottery_reward]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PROCEDURES\p_lottery_reward.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PROCEDURE -^>  p_lotter_detail_stat]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PROCEDURES\p_lotter_detail_stat.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PROCEDURE -^>  p_mm_fund_change]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PROCEDURES\p_mm_fund_change.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PROCEDURE -^>  p_mm_fund_repay]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PROCEDURES\p_mm_fund_repay.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PROCEDURE -^>  p_org_fund_change]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PROCEDURES\p_org_fund_change.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PROCEDURE -^>  p_org_plan_auth ]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PROCEDURES\p_org_plan_auth.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PROCEDURE -^>  p_outlet_create]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PROCEDURES\p_outlet_create.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PROCEDURE -^>  p_outlet_modify]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PROCEDURES\p_outlet_modify.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PROCEDURE -^>  p_outlet_plan_auth]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PROCEDURES\p_outlet_plan_auth.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PROCEDURE -^>  p_outlet_topup]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PROCEDURES\p_outlet_topup.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PROCEDURE -^>  p_outlet_withdraw_app]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PROCEDURES\p_outlet_withdraw_app.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PROCEDURE -^>  p_outlet_withdraw_con]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PROCEDURES\p_outlet_withdraw_con.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PROCEDURE -^>  p_roleprivilege_create]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PROCEDURES\p_roleprivilege_create.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PROCEDURE -^>  p_roleuser_create]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PROCEDURES\p_roleuser_create.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PROCEDURE -^>  p_rr_inbound]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PROCEDURES\p_rr_inbound.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PROCEDURE -^>  p_tb_inbound]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PROCEDURES\p_tb_inbound.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PROCEDURE -^>  p_tb_outbound]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PROCEDURES\p_tb_outbound.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PROCEDURE -^>  p_ticket_perferm]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PROCEDURES\p_ticket_perferm.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PROCEDURE -^>  p_warehouse_check_step1]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PROCEDURES\p_warehouse_check_step1.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PROCEDURE -^>  p_warehouse_check_step2]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PROCEDURES\p_warehouse_check_step2.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PROCEDURE -^>  p_warehouse_check_step3]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PROCEDURES\p_warehouse_check_step3.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PROCEDURE -^>  p_warehouse_create]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PROCEDURES\p_warehouse_create.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PROCEDURE -^>  p_warehouse_delete]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PROCEDURES\p_warehouse_delete.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PROCEDURE -^>  p_warehouse_get_sum_info]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PROCEDURES\p_warehouse_get_sum_info.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PROCEDURE -^>  p_warehouse_modify]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PROCEDURES\p_warehouse_modify.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PROCEDURE -^>  p_withdraw_approve]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PROCEDURES\p_withdraw_approve.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PROCEDURE -^>  p_item_delete]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PROCEDURES\p_item_delete.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PROCEDURE -^>  p_item_delete]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PROCEDURES\p_item_delete.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PROCEDURE -^>  p_item_inbound]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PROCEDURES\p_item_inbound.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PROCEDURE -^>  p_item_outbound]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PROCEDURES\p_item_outbound.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PROCEDURE -^>  p_item_check_step1]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PROCEDURES\p_item_check_step1.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PROCEDURE -^>  p_item_check_step2]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PROCEDURES\p_item_check_step2.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PROCEDURE -^>  p_his_gen_by_day]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PROCEDURES\p_his_gen_by_day.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PROCEDURE -^>  p_his_gen_by_hour]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PROCEDURES\p_his_gen_by_hour.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PROCEDURE -^>  p_warehouse_damage_register]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PROCEDURES\p_warehouse_damage_register.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PROCEDURE -^>  p_wh_ticket_damage]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PROCEDURES\p_wh_ticket_damage.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PROCEDURE -^>  p_item_damage_register]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PROCEDURES\p_item_damage_register.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PROCEDURE -^>  p_admin_modify]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PROCEDURES\p_admin_modify.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PROCEDURE -^>  p_batch_inbound_all]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PROCEDURES\p_batch_inbound_all.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PROCEDURE -^>  p_withdraw_approve_mm]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PROCEDURES\p_withdraw_approve_mm.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PROCEDURE -^>  p_lottery_reward_all]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PROCEDURES\p_lottery_reward_all.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PROCEDURE -^>  p_mm_inv_check]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PROCEDURES\p_mm_inv_check.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PROCEDURE -^>  p_lottery_reward2]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PROCEDURES\p_lottery_reward2.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo prompt ���ڽ���[PROCEDURE -^>  p_plan_batch_auth]...... >> %KMS_DEST_FILE%
type %SRC_DIR%KMS\PROCEDURES\p_plan_batch_auth.sql >> %KMS_DEST_FILE%
echo. >> %KMS_DEST_FILE%
echo / >> %KMS_DEST_FILE%

echo ����KMS�û����� ... [VIEW]
echo prompt ���ڽ�����ͼview ...... >> %KMS_DEST_FILE%
type %SRC_DIR%\KMS\view\create_view.sql >> %KMS_DEST_FILE%

rem echo ����KMS�û����� ... [GRANT]

rem echo prompt ��������GRANT�ű�...... >> %KMS_DEST_FILE%
rem type %SRC_DIR%\KMS\GRANT\create_grant.sql >> %KMS_DEST_FILE%

echo �����ʼ�����ݽű� ... [Init Data]
echo prompt �������г�ʼ���ű����˵���...... >> %KMS_DEST_FILE%
type %SRC_DIR%\KMS\INITData\10-init_menu.sql >> %KMS_DEST_FILE%

echo prompt �������г�ʼ���ű�������...... >> %KMS_DEST_FILE%
type %SRC_DIR%\KMS\INITData\11-init_areas.sql >> %KMS_DEST_FILE%

echo prompt �������г�ʼ���ű���Ȩ�ޣ�...... >> %KMS_DEST_FILE%
type %SRC_DIR%\KMS\INITData\12-init_privlege.sql >> %KMS_DEST_FILE%

echo prompt �������г�ʼ���ű���������...... >> %KMS_DEST_FILE%
type %SRC_DIR%\KMS\INITData\13-init_other.sql >> %KMS_DEST_FILE%

echo ��ӽ�������
echo. >> %KMS_DEST_FILE%
echo exit; >> %KMS_DEST_FILE%

pause
