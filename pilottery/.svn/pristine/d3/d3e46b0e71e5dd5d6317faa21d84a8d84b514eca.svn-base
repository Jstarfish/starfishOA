create or replace package error_msg is
   /**********************************************/
   /****** Error Messages - English Version ******/
   /**********************************************/

   /*----- Common ------*/
   err_comm_password_not_match constant  varchar2(4000)   := 'Password error.';

   /*----- Procedure ------*/
   -- err_p_cxxxxx_1
   -- err_p_cxxxxx_2
   -- err_f_cxxxxx_1
   -- err_f_cxxxxx_2

   err_p_import_batch_file_1  constant varchar2(4000) := 'The batch information already exists.';
   err_p_import_batch_file_2  constant varchar2(4000) := 'The plan and batch information in the data file are inconsistent with the user input.';

   err_p_batch_inbound_1 constant varchar2(4000) := 'The trunk has already been received.';
   err_p_batch_inbound_2 constant varchar2(4000) := 'The warehouse does not exist.';
   err_p_batch_inbound_3 constant varchar2(4000) := 'The batch does not exist.';
   err_p_batch_inbound_4 constant varchar2(4000) := 'Wrong operation parameter, must be 1, 2 or 3.';
   err_p_batch_inbound_5 constant varchar2(4000) := 'Batch receipt code error occurred when continuing or completing lottery receipt. Receipt code does not exist.';
   err_p_batch_inbound_6 constant varchar2(4000) := 'Batch receipt code error occurred when continuing lottery receipt, or this batch receipt has already completed.';
   err_p_batch_inbound_7 constant varchar2(4000) := 'The batch receipt has already completed, please do not repeat the process.';

   err_f_get_warehouse_code_1 constant varchar2(4000) := 'The input account type is not "jg", "zd" or "mm".';

   err_f_get_lottery_info_1 constant varchar2(4000) := 'The input "Trunk" code is out of the valid range.';
   err_f_get_lottery_info_2 constant varchar2(4000) := 'The input "Box" code is out of the valid range.';
   err_f_get_lottery_info_3 constant varchar2(4000) := 'The input "Pack" code is out of the valid range.';

   err_p_tb_outbound_3  constant varchar2(4000) := 'Transfer code error occurred when continuing lottery issue, or the corresponding delivery order has completed.';
   err_p_tb_outbound_4  constant varchar2(4000) := 'The transfer order status is incorrect when the transfer issue has completed.';
   err_p_tb_outbound_14 constant varchar2(4000) := 'The actual issued quantity for this transfer order is inconsistent with the applied quantity.';
   err_p_tb_outbound_5  constant varchar2(4000) := 'The transfer order status is incorrect when the transfer issue is being processed.';
   err_p_tb_outbound_6  constant varchar2(4000) := 'Cannot obtain the delivery code.';
   err_p_tb_outbound_7  constant varchar2(4000) := 'The actual number of tickets being delivered should not be larger than the number as specified in the transfer order.';

   err_p_tb_inbound_2  constant varchar2(4000) := 'The input parent institution of the warehouse is inconsistent with that as specified in the transfer order.';
   err_p_tb_inbound_3  constant varchar2(4000) := 'Transfer code error occurred when continuing lottery receipt, or the corresponding receipt order has completed.';
   err_p_tb_inbound_4  constant varchar2(4000) := 'The transfer order status is not as expected when the transfer receipt has completed.';
   err_p_tb_inbound_5  constant varchar2(4000) := 'The transfer order status is incorrect when the transfer receipt is being processed.';
   err_p_tb_inbound_6  constant varchar2(4000) := 'Cannot find the corresponding receipt code with respect to the input transfer code when adding lottery tickets. It may be caused by having entered a wrong transfer code.';
   err_p_tb_inbound_25 constant varchar2(4000) := 'The transfer order does not exist.';
   err_p_tb_inbound_7 constant varchar2(4000)  := 'The actual number of tickets being transferred should be smaller than or equal to the applied quantity.';

   err_p_batch_end_1 constant varchar2(4000) := 'The person does not exist.';
   err_p_batch_end_2 constant varchar2(4000) := 'The plan is disabled.';
   err_p_batch_end_3 constant varchar2(4000) := 'Cannot terminate this batch because "in transit" or "in outlet" lottery ticket may exist.';
   err_p_batch_end_4 constant varchar2(4000) := 'Cannot terminate this batch because "in transit" or "in outlet" lottery ticket may exist.';
   err_p_batch_end_5 constant varchar2(4000) := 'Cannot terminate this batch because "in transit" or "in outlet" lottery ticket may exist.';


   err_p_gi_outbound_4  constant varchar2(4000) := 'The delivery order status is incorrect when the delivery issue has completed.';
   err_p_gi_outbound_5  constant varchar2(4000) := 'The delivery order status is incorrect when the delivery issue is being processed.';
   err_p_gi_outbound_6  constant varchar2(4000) := 'Cannot obtain the issue code.';
   err_p_gi_outbound_1  constant varchar2(4000) := 'The person does not exist.';
   err_p_gi_outbound_3  constant varchar2(4000) := 'Transfer code error occurred when continuing lottery issue, or the corresponding delivery order has completed.';
   err_p_gi_outbound_10 constant varchar2(4000) := 'Exception occurred in "Pack" data when transferring a "Trunk".';
   err_p_gi_outbound_12 constant varchar2(4000) := 'Cannot find relevant information in inventory when transferring a "Box". Or the trunk status may be incorrect.';
   err_p_gi_outbound_13 constant varchar2(4000) := 'Exception occurred in "Pack" data when transferring a "Box".';
   err_p_gi_outbound_16 constant varchar2(4000) := 'Cannot find relevant information in inventory when transferring a "Pack". Or the trunk status may be incorrect.';
   err_p_gi_outbound_7  constant varchar2(4000) := 'Repeated items found for issue.';
   err_p_gi_outbound_8  constant varchar2(4000) := 'Cannot find relevant information in inventory when transferring a "Trunk". Or the trunk status may be incorrect.';
   err_p_gi_outbound_9  constant varchar2(4000) := 'Exception occurred in "Box" data when transferring a "Trunk".';
   err_p_gi_outbound_2  constant varchar2(4000) := 'The warehouse does not exist.';
   err_p_gi_outbound_11 constant varchar2(4000) := 'Validation failure: the corresponding trunk of the box is already inside the issue details.';
   err_p_gi_outbound_14 constant varchar2(4000) := 'Validation failure: the corresponding trunk of the pack is already inside the issue details.';
   err_p_gi_outbound_15 constant varchar2(4000) := 'Validation failure: the corresponding trunk of the pack is already inside the issue details.';
   err_p_gi_outbound_17 constant varchar2(4000) := 'Exceeds the "maximum allowable credit" as held by this manager.';

   err_p_rr_inbound_1 constant varchar2(4000) := 'The person does not exist.';
   err_p_rr_inbound_2 constant varchar2(4000) := 'The warehouse does not exist.';
   err_p_rr_inbound_3 constant varchar2(4000) := 'Wrong operation parameter, must be 1, 2 or 3.';
   err_p_rr_inbound_4 constant varchar2(4000) := 'The return delivery status is incorrect when the return delivery receipt has completed. Expected status: [Receiving].';
   err_p_rr_inbound_24 constant varchar2(4000) := 'Cannot find the return delivery due to incorrect return code.';
   err_p_rr_inbound_5 constant varchar2(4000) := 'The return delivery status is incorrect when the return delivery receipt has completed. Expected status: [Approved].';
   err_p_rr_inbound_15 constant varchar2(4000) := 'The return delivery status is incorrect when the return delivery receipt is being processed. Expected status: [Receiving].';
   err_p_rr_inbound_6 constant varchar2(4000) := 'Cannot obtain the receipt code.';
   err_p_rr_inbound_7 constant varchar2(4000) := 'Repeated items found for receipt.';
   err_p_rr_inbound_8 constant varchar2(4000) := 'Exception occurred in "Pack" data when transferring a "Box".';
   err_p_rr_inbound_18 constant varchar2(4000) := 'Exception occurred in "Pack" data when transferring a "Trunk".';
   err_p_rr_inbound_28 constant varchar2(4000) := 'Exception occurred in "Box" data when transferring a "Trunk".';
   err_p_rr_inbound_38 constant varchar2(4000) := 'Cannot find relevant information in inventory when transferring a "Trunk". Or the trunk status may be incorrect.';
   err_p_rr_inbound_9 constant varchar2(4000) := 'Validation failure: the corresponding trunk of the box is already inside the receipt details.';
   err_p_rr_inbound_10 constant varchar2(4000) := 'Cannot find relevant information in inventory when transferring a "Box". Or the trunk status may be incorrect.';
   err_p_rr_inbound_11 constant varchar2(4000) := 'Validation failure: the corresponding trunk of the pack is already inside the receipt details.';
   err_p_rr_inbound_12 constant varchar2(4000) := 'Validation failure: the corresponding trunk of the pack is already inside the receipt details.';
   err_p_rr_inbound_13 constant varchar2(4000) := 'Cannot find relevant information in inventory when transferring a "Pack". Or the trunk status may be incorrect.';
   err_p_rr_inbound_14 constant varchar2(4000) := 'There is no information on this plan and batch in the warehouse manager inventory.';

   err_p_ar_inbound_1 constant varchar2(4000) := 'The person does not exist.';
   err_p_ar_inbound_3 constant varchar2(4000) := 'Repeated items found for receipt.';
   err_p_ar_inbound_4 constant varchar2(4000) := 'Cannot find relevant information in inventory when processing a "Trunk". Or the trunk status may be incorrect.';
   err_p_ar_inbound_5 constant varchar2(4000) := 'Exception occurred in "Box" data when processing a "Trunk".';
   err_p_ar_inbound_6 constant varchar2(4000) := 'Exception occurred in "Pack" data when processing a "Trunk".';
   err_p_ar_inbound_7 constant varchar2(4000) := 'Validation failure: the corresponding trunk of the box is already inside the receipt details.';
   err_p_ar_inbound_10 constant varchar2(4000) := 'Cannot find relevant information in inventory when processing a "Box". Or the trunk status may be incorrect.';
   err_p_ar_inbound_38 constant varchar2(4000) := 'Exception occurred in "Pack" data when processing a "Box".';
   err_p_ar_inbound_11 constant varchar2(4000) := 'Validation failure: the corresponding trunk of the pack is already inside the receipt details.';
   err_p_ar_inbound_12 constant varchar2(4000) := 'Validation failure: the corresponding trunk of the pack is already inside the receipt details.';
   err_p_ar_inbound_13 constant varchar2(4000) := 'Cannot find relevant information in inventory when processing a "Pack". Or the trunk status may be incorrect.';
   err_p_ar_inbound_14 constant varchar2(4000) := 'There is no information on this plan and batch in the warehouse manager inventory.';
   err_p_ar_inbound_15 constant varchar2(4000) := 'The outlet has not set up the sales commission rate of this lottery plan.';
   err_p_ar_inbound_16 constant varchar2(4000) := 'The outlet does not have an account or the account status is incorrect.';
   err_p_ar_inbound_17 constant varchar2(4000) := 'Insufficient outlet balance.';


   err_p_institutions_create_1 constant varchar2(4000) := 'Institution code cannot be empty.';
   err_p_institutions_create_2 constant varchar2(4000) := 'Institution name cannot be empty.';
   err_p_institutions_create_3 constant varchar2(4000) := 'Insittution director does not exist.';
   err_p_institutions_create_4 constant varchar2(4000) := 'Contact phone cannot be empty.';
   err_p_institutions_create_5 constant varchar2(4000) := 'This institution code already exists in the system.';
   err_p_institutions_create_6 constant varchar2(4000) := 'Area has been repeatedly governed by other insittution.';

   err_p_institutions_modify_1 constant varchar2(4000) := 'Original institution code cannot be empty.';
   err_p_institutions_modify_2 constant varchar2(4000) := 'Other relevant staff in this institution cannot change the institution code.';

   err_p_outlet_create_1 constant varchar2(4000) := 'Institution code cannot be empty.';
   err_p_outlet_create_2 constant varchar2(4000) := 'The institution is disabled.';
   err_p_outlet_create_3 constant varchar2(4000) := 'Area code cannot be empty.';
   err_p_outlet_create_4 constant varchar2(4000) := 'The area is disabled.';

   err_p_outlet_modify_1 constant varchar2(4000) := 'The outlet code already exists.';
   err_p_outlet_modify_2 constant varchar2(4000) := 'The outlet code is invalid.';
   err_p_outlet_modify_3 constant varchar2(4000) := 'Cannot modify outlet code when there is a transaction.';
   err_p_outlet_modify_4 constant varchar2(4000) := 'Cannot modify outlet code when there is an order.';

   err_p_outlet_plan_auth_1 constant varchar2(4000) := 'The delegated plan cannot be empty.';
   err_p_outlet_plan_auth_2 constant varchar2(4000) := 'The commission rate of the delegated plan cannot exceed the commission rate of the parent institution.';

   err_p_org_plan_auth_1 constant varchar2(4000) := 'The delegated plan cannot be empty.';
   err_p_org_plan_auth_2 constant varchar2(4000) := 'The commission rate of the delegated plan cannot exceed 1000.';

   err_p_warehouse_create_1 constant varchar2(4000) := 'Warehouse code cannot be empty.';
   err_p_warehouse_create_2 constant varchar2(4000) := 'Warehouse code cannot repeat.';
   err_p_warehouse_create_3 constant varchar2(4000) := 'Warehouse name cannot be empty.';
   err_p_warehouse_create_4 constant varchar2(4000) := 'Warehouse address cannot be empty.';
   err_p_warehouse_create_5 constant varchar2(4000) := 'Warehouse director does not exist.';
   err_p_warehouse_create_6 constant varchar2(4000) := ' has already had administering warehouse.';

   err_p_warehouse_modify_1 constant varchar2(4000) := 'Warehouse code does not exist.';

   err_p_admin_create_1 constant varchar2(4000) := 'Real name cannot be empty.';
   err_p_admin_create_2 constant varchar2(4000) := 'Login name cannot be empty.';
   err_p_admin_create_3 constant varchar2(4000) := 'Login name already exists.';

   err_p_outlet_topup_1 constant varchar2(100) := 'Outlet code cannot be empty.';
   err_p_outlet_topup_2 constant varchar2(100) := 'User does not exist or is disabled.';
   err_p_outlet_topup_3 constant varchar2(100) := 'Password cannot be empty.';
   err_p_outlet_topup_4 constant varchar2(100) := 'Password is invalid.';

   err_p_institutions_topup_1 constant varchar2(100) := 'Institution code cannot be empty.';
   err_p_institutions_topup_2 constant varchar2(100) := 'The current user is disabled.';
   err_p_institutions_topup_3 constant varchar2(100) := 'The current institution is disabled.';

   err_p_outlet_withdraw_app_1 constant varchar2(100) := 'Insufficient balance for cash withdraw.';
   err_p_outlet_withdraw_con_1 constant varchar2(100) := 'Application form cannot be empty.';
   err_p_outlet_withdraw_con_2 constant varchar2(100) := 'Application form does not exist or is not approved.';
   err_p_outlet_withdraw_con_3 constant varchar2(100) := 'The outlet does not exist or the password is incorrect.';

   err_p_warehouse_delete_1 constant varchar2(100) := 'Cannot delete a warehouse with item inventory.';

   err_p_warehouse_check_step1_1 constant varchar2(100) := 'The inventory check name cannot be empty.';
   err_p_warehouse_check_step1_2 constant varchar2(100) := 'The warehouse for check cannot be empty.';
   err_p_warehouse_check_step1_3 constant varchar2(100) := 'The check operator is disabled.';
   err_p_warehouse_check_step1_4 constant varchar2(100) := 'The warehouse is disabled or is in checking.';
   err_p_warehouse_check_step1_5 constant varchar2(100) := 'There are no lottery tickets or items for check in this warehouse.';

   err_p_warehouse_check_step2_1 constant varchar2(100) := 'The inventory check code cannot be empty.';
   err_p_warehouse_check_step2_2 constant varchar2(100) := 'The inventory check does not exist or has completed.';
   err_p_warehouse_check_step2_3 constant varchar2(100) := 'The scanned information cannot be empty.';

   err_p_mm_fund_repay_1 constant varchar2(100) := 'Market manager cannot be empty.';
   err_p_mm_fund_repay_2 constant varchar2(100) := 'Market manager does not exist or is deleted.';
   err_p_mm_fund_repay_3 constant varchar2(100) := 'Current operator cannot be empty.';
   err_p_mm_fund_repay_4 constant varchar2(100) := 'Current operator does not exist or is deleted.';
   err_p_mm_fund_repay_5 constant varchar2(100) := 'The repayment amount is invalid.';

   err_common_1 constant varchar2(4000) := 'Database error.';
   err_common_2 constant varchar2(4000) := 'Invalid status.';
   err_common_3 constant varchar2(4000) := 'Object does not exist.';
   err_common_4 constant varchar2(4000) := 'Parameter name error.';
   err_common_5 constant varchar2(4000) := 'Invalid parameter.';
   err_common_6 constant varchar2(4000) := 'Invalid code.';
   err_common_7 constant varchar2(4000) := 'Code overflow.';
   err_common_8 constant varchar2(4000) := 'The data is being processed by others.';
   err_common_9 constant varchar2(4000) := 'The deletion requrement cannot be satisfied.';

   err_p_fund_change_1 constant varchar2(4000) := 'Insufficient account balance.';
   err_p_fund_change_2 constant varchar2(4000) := 'Incorrect fund type.';
   err_p_fund_change_3 constant varchar2(4000) := 'The outlet account does not exist, or the account status is incorrect.';

   err_p_lottery_reward_3 constant varchar2(4000) := 'This lottery ticket has not been on sale yet.';
   err_p_lottery_reward_4 constant varchar2(4000) := 'This lottery ticket has already been paid.';
   err_p_lottery_reward_5 constant varchar2(4000) := 'Incorrect system parameter, please contact system administrator for recalibration.';
   err_p_lottery_reward_6 constant varchar2(4000) := 'The outlet has not set up the payout commission rate of this lottery plan.';
   err_p_lottery_reward_7 constant varchar2(4000) := 'The outlet has not set up the payout commission rate of this lottery plan.';

   err_f_check_import_ticket constant varchar2(4000) := 'Wrong input parameter, must be 1 or 2.';

   err_common_100 constant varchar2(4000) := 'The person does not exist.';
   err_common_101 constant varchar2(4000) := 'The warehouse does not exist.';
   err_common_102 constant varchar2(4000) := 'There is no batch in this plan.';
   err_common_103 constant varchar2(4000) := 'Self-reference exists in the input lottery object.';
   err_common_104 constant varchar2(4000) := 'Error occurred when updating the lottery status.';
   err_common_105 constant varchar2(4000) := 'Wrong operation parameter, must be 1, 2 or 3.';
   err_common_106 constant varchar2(4000) := 'Wrong operation parameter, must be 1, 2 or 3.';
   err_common_107 constant varchar2(4000) := 'The batches of this plan are disabled.';
   err_common_108 constant varchar2(4000) := 'The plan or batch data is empty.';
   err_common_109 constant varchar2(4000) := 'No lottery object found in the input parameters.';

   err_f_check_ticket_include_1 constant varchar2(4000) := 'This lottery trunk has already been processed.';
   err_f_check_ticket_include_2 constant varchar2(4000) := 'This lottery box has already been processed.';
   err_f_check_ticket_include_3 constant varchar2(4000) := 'This lottery pack has already been processed.';

   err_p_item_delete_1 constant varchar2(4000) := 'Item code cannot be empty.';
   err_p_item_delete_2 constant varchar2(4000) := 'The item does not exist.';
   err_p_item_delete_3 constant varchar2(4000) := 'This item currently exists in inventory.';

   err_p_withdraw_approve_1 constant varchar2(4000) := 'Withdraw code cannot be empty.';
   err_p_withdraw_approve_2 constant varchar2(4000) := 'The withdraw code does not exist or the withdraw record is disabled.';
   err_p_withdraw_approve_3 constant varchar2(4000) := 'Permission denied for cash withdraw approval.';
   err_p_withdraw_approve_4 constant varchar2(4000) := 'Insufficient balance.';
   err_p_withdraw_approve_5 constant varchar2(4000) := 'outlet cash withdraw failure.';

   err_p_item_outbound_1 constant varchar2(4000) := 'This item currently does not exist in inventory.';
   err_p_item_outbound_2 constant varchar2(4000) := 'This item is not enough in inventory.';

   err_p_item_damage_1 constant varchar2(4000) := 'Item code cannot be empty.';
   err_p_item_damage_2 constant varchar2(4000) := 'Warehouse code cannot be empty.';
   err_p_item_damage_3 constant varchar2(4000) := 'Damage quantity must be positive.';
   err_p_item_damage_4 constant varchar2(4000) := 'The operator does not exist.';
   err_p_item_damage_5 constant varchar2(4000) := 'The item does not exist or is deleted.';
   err_p_item_damage_6 constant varchar2(4000) := 'The warehouse does not exist or is deleted.';
   err_p_item_damage_7 constant varchar2(4000) := 'The item does not exist in this warehouse.';
   err_p_item_damage_8 constant varchar2(4000) := 'The item quantity in this warehouse is less than the input damage quantity.';

   err_p_ar_outbound_10 constant varchar2(4000) := 'Cannot refund this ticket because paid tickets may exist.';
   err_p_ar_outbound_20 constant varchar2(4000) := 'The corresponding trunk data is missing from the lottery receipt.';
   err_p_ar_outbound_30 constant varchar2(4000) := 'The corresponding box data is missing from the lottery receipt.';
   err_p_ar_outbound_40 constant varchar2(4000) := 'The corresponding pack data is missing from the lottery receipt.';
   err_p_ar_outbound_50 constant varchar2(4000) := 'The corresponding trunk data has been found in the receipt, but its status or its outlet information is incorrect.';
   err_p_ar_outbound_60 constant varchar2(4000) := 'Cannot find the sales record of the refunding ticket.';
   err_p_ar_outbound_70 constant varchar2(4000) := 'Exceeds the "maximum allowable credit" as held by this manager.';

   err_p_ticket_perferm_1   constant varchar2(4000) := 'This warehouse is stopped or is in checking. This operation is denied.';
   err_p_ticket_perferm_3   constant varchar2(4000) := 'The plan of this batch does not exist in the system.';
   err_p_ticket_perferm_5   constant varchar2(4000) := 'The plan of this batch has already been disabled.';
   err_p_ticket_perferm_10  constant varchar2(4000) := 'This lottery trunk does not exist.';
   err_p_ticket_perferm_110 constant varchar2(4000) := 'This lottery box does not exist.';
   err_p_ticket_perferm_120 constant varchar2(4000) := 'The status of this lottery "Box" is not as expected, current status: ';
   err_p_ticket_perferm_130 constant varchar2(4000) := 'The system status of this lottery "Box" is OPEN, therefore trunk-wise processing is not allowed.';
   err_p_ticket_perferm_140 constant varchar2(4000) := 'Error may exist in the inventory information of this lottery "Box", please double-check before proceed.';
   err_p_ticket_perferm_150 constant varchar2(4000) := 'Exception occurred during lottery processing, please contact the system maintenance for support.';
   err_p_ticket_perferm_160 constant varchar2(4000) := 'Exception occurred in the "Pack" data when processing a "Box". Possible errors include: 1-Some packs in this box have been removed; 2-The status of some packs in this box is not as expected.';
   err_p_ticket_perferm_20  constant varchar2(4000) := 'The status of this lottery "Trunk" is not as expected, current status: ';
   err_p_ticket_perferm_210 constant varchar2(4000) := 'This lottery pack does not exist.';
   err_p_ticket_perferm_220 constant varchar2(4000) := 'The status of this lottery "Pack" is not as expected, current status: ';
   err_p_ticket_perferm_230 constant varchar2(4000) := 'Error may exist in the inventory information of this lottery "Pack", please double-check before proceed.';
   err_p_ticket_perferm_240 constant varchar2(4000) := 'Exception occurred during lottery processing, please contact the system maintenance for support.';
   err_p_ticket_perferm_30  constant varchar2(4000) := 'The system status of this lottery "Trunk" is OPEN, therefore trunk-wise processing is not allowed.';
   err_p_ticket_perferm_40  constant varchar2(4000) := 'Error may exist in the inventory information of this lottery "Trunk", please double-check before proceed.';
   err_p_ticket_perferm_50  constant varchar2(4000) := 'Exception occurred during lottery processing, please contact the system maintenance for support.';
   err_p_ticket_perferm_60  constant varchar2(4000) := 'Exception occurred in the "Box" data when processing a "Trunk". Possible errors include: 1-Some boxes in this trunk have been opened for use; 2-Some boxes in this trunk have been removed; 3-The status of some boxes in this trunk is not as expected.';
   err_p_ticket_perferm_70  constant varchar2(4000) := 'Exception occurred in the "Box" data when processing a "Trunk". Possible errors include: 1-Some packs in this trunk have been removed; 2-The status of some packs in this trunk is not as expected.';

   err_f_get_sys_param_1    constant varchar2(4000) := 'The system parameter is not set. parameter: ';
end;
