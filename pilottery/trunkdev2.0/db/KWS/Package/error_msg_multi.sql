create or replace package error_msg is
  /****************************************************/
  /****** Error Messages - Multi-lingual Version ******/
  /****************************************************/

  /*----- Common ------*/
  err_comm_password_not_match     constant varchar2(4000) := '{"en":"Password error.","zh":"用户密码错误"}';
  err_comm_trade_type_error       constant varchar2(4000) := '{"en":"TRADE TYPE error.","zh":"交易类型错误"}';
  err_common_1                    constant varchar2(4000) := '{"en":"Database error.","zh":"数据库操作异常"}';
  err_common_2                    constant varchar2(4000) := '{"en":"Invalid status.","zh":"无效的状态值"}';
  err_common_3                    constant varchar2(4000) := '{"en":"Object does not exist.","zh":"对象不存在"}';
  err_common_4                    constant varchar2(4000) := '{"en":"Parameter name error.","zh":"参数名称错误"}';
  err_common_5                    constant varchar2(4000) := '{"en":"Invalid parameter.","zh":"无效的参数"}';
  err_common_6                    constant varchar2(4000) := '{"en":"Invalid code.","zh":"编码不符合规范"}';
  err_common_7                    constant varchar2(4000) := '{"en":"Code overflow.","zh":"编码溢出"}';
  err_common_8                    constant varchar2(4000) := '{"en":"The data is being processed by others.","zh":"数据正在被别人处理中"}';
  err_common_9                    constant varchar2(4000) := '{"en":"The deletion requrement cannot be satisfied.","zh":"不符合删除条件"}';
  err_common_100                  constant varchar2(4000) := '{"en":"The person does not exist.","zh":"无此人"}';
  err_common_101                  constant varchar2(4000) := '{"en":"The warehouse does not exist.","zh":"无此仓库"}';
  err_common_102                  constant varchar2(4000) := '{"en":"There is no batch in this plan.","zh":"无此方案批次"}';
  err_common_103                  constant varchar2(4000) := '{"en":"Self-reference exists in the input lottery object.","zh":"输入的彩票对象中，存在自包含的现象"}';
  err_common_104                  constant varchar2(4000) := '{"en":"Error occurred when updating the lottery status.","zh":"更新“即开票”状态时，出现错误"}';
  err_common_105                  constant varchar2(4000) := '{"en":"Wrong operation parameter, must be 1, 2 or 3.","zh":"操作类型参数错误，应该为1，2，3"}';
  err_common_106                  constant varchar2(4000) := '{"en":"Wrong operation parameter, must be 1, 2 or 3.","zh":"操作类型参数错误，应该为1，2，3"}';
  err_common_107                  constant varchar2(4000) := '{"en":"The batches of this plan are disabled.","zh":"此方案的批次处于非可用状态"}';
  err_common_108                  constant varchar2(4000) := '{"en":"The plan or batch data is empty.","zh":"方案或批次数据为空"}';
  err_common_109                  constant varchar2(4000) := '{"en":"No lottery object found in the input parameters.","zh":"输入参数中，没有发现彩票对象"}';

  err_p_import_batch_file_1       constant varchar2(4000) := '{"en":"The batch information already exists.","zh":"批次数据信息已经存在"}';
  err_p_import_batch_file_2       constant varchar2(4000) := '{"en":"The plan and batch information in the data file are inconsistent with the user input.","zh":"数据文件中所记录的方案与批次信息，与界面输入的方案和批次不符"}';
  err_p_import_batch_file_3       constant varchar2(4000) := '{"en":"The import file has error. PACKS_EVERY_TRUNK(line 7) divided by BOXES_EVERY_TRUNK(line 15) is not a integer","zh":"批次导入文件（包装参数）出现逻辑关系错误：{每箱本数/每箱盒数} 的结果不是一个整数"}';

  err_p_batch_inbound_1           constant varchar2(4000) := '{"en":"The trunk has already been received.","zh":"此箱已经入库"}';
  err_p_batch_inbound_2           constant varchar2(4000) := '{"en":"The warehouse does not exist.","zh":"无此仓库"}';
  err_p_batch_inbound_3           constant varchar2(4000) := '{"en":"The batch does not exist.","zh":"无此批次"}';
  err_p_batch_inbound_4           constant varchar2(4000) := '{"en":"Wrong operation parameter, must be 1, 2 or 3.","zh":"操作类型参数错误，应该为1，2，3"}';
  err_p_batch_inbound_5           constant varchar2(4000) := '{"en":"Batch receipt code error occurred when continuing or completing lottery receipt. Receipt code does not exist.","zh":"在进行继续入库和完结入库操作时，输入的批次入库单错误，未发现此批次入库单"}';
  err_p_batch_inbound_6           constant varchar2(4000) := '{"en":"Batch receipt code error occurred when continuing lottery receipt, or this batch receipt has already completed.","zh":"在进行继续入库时，输入的批次入库单错误，或者此批次入库单已经完结"}';
  err_p_batch_inbound_7           constant varchar2(4000) := '{"en":"The batch receipt has already completed, please do not repeat the process.","zh":"此批次的方案已经入库完毕，请不要重复进行"}';

  err_f_get_warehouse_code_1      constant varchar2(4000) := '{"en":"The input account type is not \"jg\", \"zd\" or \"mm\".","zh":"输入的账户类型不是“jg”,“zd”,“mm”"}';

  err_f_get_lottery_info_1        constant varchar2(4000) := '{"en":"The input \"Trunk\" code is out of the valid range.","zh":"输入的“箱”号超出合法的范围"}';
  err_f_get_lottery_info_2        constant varchar2(4000) := '{"en":"The input \"Box\" code is out of the valid range.","zh":"输入的“盒”号超出合法的范围"}';
  err_f_get_lottery_info_3        constant varchar2(4000) := '{"en":"The input \"Pack\" code is out of the valid range.","zh":"输入的“本”号超出合法的范围"}';

  err_p_tb_outbound_3             constant varchar2(4000) := '{"en":"Transfer code error occurred when continuing lottery issue, or the corresponding delivery order has completed.","zh":"在进行继续出库时，输入的调拨单号错误，或者此调拨单对应的出库单，出库已经完结"}';
  err_p_tb_outbound_4             constant varchar2(4000) := '{"en":"The transfer order status is incorrect when the transfer issue has completed.","zh":"调拨单出库完结时，调拨单状态不合法"}';
  err_p_tb_outbound_14            constant varchar2(4000) := '{"en":"The actual issued quantity for this transfer order is inconsistent with the applied quantity.","zh":"调拨单实际出库数量与申请数量不符"}';
  err_p_tb_outbound_5             constant varchar2(4000) := '{"en":"The transfer order status is incorrect when the transfer issue is being processed.","zh":"进行调拨单出库时，调拨单状态不合法"}';
  err_p_tb_outbound_6             constant varchar2(4000) := '{"en":"Cannot obtain the delivery code.","zh":"不能获得出库单编号"}';
  err_p_tb_outbound_7             constant varchar2(4000) := '{"en":"The actual number of tickets being delivered should not be larger than the number as specified in the transfer order.","zh":"实际出库票数不应该大于调拨单计划出库票数"}';

  err_p_tb_inbound_2              constant varchar2(4000) := '{"en":"The input parent institution of the warehouse is inconsistent with that as specified in the transfer order.","zh":"输入的仓库所属机构，与调拨单中标明的接收机构不符"}';
  err_p_tb_inbound_3              constant varchar2(4000) := '{"en":"Transfer code error occurred when continuing lottery receipt, or the corresponding receipt order has completed.","zh":"在进行继续入库时，输入的调拨单号错误，或者此调拨单对应的入库单，入库已经完结"}';
  err_p_tb_inbound_4              constant varchar2(4000) := '{"en":"The transfer order status is not as expected when the transfer receipt has completed.","zh":"调拨单入库完结时，调拨单状态与预期值不符"}';
  err_p_tb_inbound_5              constant varchar2(4000) := '{"en":"The transfer order status is incorrect when the transfer receipt is being processed.","zh":"进行调拨单入库时，调拨单状态不合法"}';
  err_p_tb_inbound_6              constant varchar2(4000) := '{"en":"Cannot find the corresponding receipt code with respect to the input transfer code when adding lottery tickets. It may be caused by having entered a wrong transfer code.","zh":"继续添加彩票时，未能按照输入的调拨单编号，查询到相应的入库单编号。可能传入了错误的调拨单编号"}';
  err_p_tb_inbound_25             constant varchar2(4000) := '{"en":"The transfer order does not exist.","zh":"未查询到此调拨单"}';
  err_p_tb_inbound_7              constant varchar2(4000) := '{"en":"The actual number of tickets being transferred should be smaller than or equal to the applied quantity.","zh":"实际调拨票数，应该小于或者等于申请调拨票数"}';

  err_p_batch_end_1               constant varchar2(4000) := '{"en":"The person does not exist.","zh":"无此人"}';
  err_p_batch_end_2               constant varchar2(4000) := '{"en":"The plan is disabled.","zh":"此方案已经不可用"}';
  err_p_batch_end_3               constant varchar2(4000) := '{"en":"Cannot terminate this batch because \"in transit\" or \"in outlet\" lottery ticket may exist.","zh":"存在“在途”和“在站点”的彩票，不能执行批次终结"}';
  err_p_batch_end_4               constant varchar2(4000) := '{"en":"Cannot terminate this batch because \"in transit\" or \"in outlet\" lottery ticket may exist.","zh":"存在“在途”和“在站点”的彩票，不能执行批次终结"}';
  err_p_batch_end_5               constant varchar2(4000) := '{"en":"Cannot terminate this batch because \"in transit\" or \"in outlet\" lottery ticket may exist.","zh":"存在“在途”和“在站点”的彩票，不能执行批次终结"}';


  err_p_gi_outbound_4             constant varchar2(4000) := '{"en":"The delivery order status is incorrect when the delivery issue has completed.","zh":"出货单出库完结时，出货单状态不合法"}';
  err_p_gi_outbound_5             constant varchar2(4000) := '{"en":"The delivery order status is incorrect when the delivery issue is being processed.","zh":"进行出货单出库时，出货单状态不合法"}';
  err_p_gi_outbound_6             constant varchar2(4000) := '{"en":"Cannot obtain the issue code.","zh":"不能获得出库单编号"}';
  err_p_gi_outbound_1             constant varchar2(4000) := '{"en":"The person does not exist.","zh":"无此人"}';
  err_p_gi_outbound_3             constant varchar2(4000) := '{"en":"Transfer code error occurred when continuing lottery issue, or the corresponding delivery order has completed.","zh":"在进行继续出库时，输入的调拨单号错误，或者此调拨单对应的出库单，出库已经完结"}';
  err_p_gi_outbound_10            constant varchar2(4000) := '{"en":"Exception occurred in \"Pack\" data when transferring a \"Trunk\".","zh":"调拨“箱”时，“本”数据出现异常"}';
  err_p_gi_outbound_12            constant varchar2(4000) := '{"en":"Cannot find relevant information in inventory when transferring a \"Box\". Or the trunk status may be incorrect.","zh":"调拨“盒”时，未在库存中找到相关信息。也可能是箱的状态不正确"}';
  err_p_gi_outbound_13            constant varchar2(4000) := '{"en":"Exception occurred in \"Pack\" data when transferring a \"Box\".","zh":"调拨“盒”时，对应的“本”数据异常"}';
  err_p_gi_outbound_16            constant varchar2(4000) := '{"en":"Cannot find relevant information in inventory when transferring a \"Pack\". Or the trunk status may be incorrect.","zh":"调拨“本”时，未在库存中找到相关信息。也可能是箱的状态不正确"}';
  err_p_gi_outbound_7             constant varchar2(4000) := '{"en":"Repeated items found for issue.","zh":"出现重复的出库物品"}';
  err_p_gi_outbound_8             constant varchar2(4000) := '{"en":"Cannot find relevant information in inventory when transferring a \"Trunk\". Or the trunk status may be incorrect.","zh":"调拨“箱”时，未在库存中找到相关信息。也可能是箱的状态不正确"}';
  err_p_gi_outbound_9             constant varchar2(4000) := '{"en":"Exception occurred in \"Box\" data when transferring a \"Trunk\".","zh":"调拨“箱”时，“盒”数据出现异常"}';
  err_p_gi_outbound_2             constant varchar2(4000) := '{"en":"The warehouse does not exist.","zh":"无此仓库"}';
  err_p_gi_outbound_11            constant varchar2(4000) := '{"en":"Validation failure: the corresponding trunk of the box is already inside the issue details.","zh":"盒对应的箱已经出现在出库明细中，逻辑校验失败"}';
  err_p_gi_outbound_14            constant varchar2(4000) := '{"en":"Validation failure: the corresponding trunk of the pack is already inside the issue details.","zh":"本对应的箱已经出现在出库明细中，逻辑校验失败"}';
  err_p_gi_outbound_15            constant varchar2(4000) := '{"en":"Validation failure: the corresponding trunk of the pack is already inside the issue details.","zh":"本对应的箱已经出现在出库明细中，逻辑校验失败"}';
  err_p_gi_outbound_17            constant varchar2(4000) := '{"en":"Exceeds the \"maximum allowable credit\" as held by this manager.","zh":"超过此管理员允许持有的“最高赊票金额”"}';

  err_p_rr_inbound_1              constant varchar2(4000) := '{"en":"The person does not exist.","zh":"无此人"}';
  err_p_rr_inbound_2              constant varchar2(4000) := '{"en":"The warehouse does not exist.","zh":"无此仓库"}';
  err_p_rr_inbound_3              constant varchar2(4000) := '{"en":"Wrong operation parameter, must be 1, 2 or 3.","zh":"操作类型参数错误，应该为1，2，3"}';
  err_p_rr_inbound_4              constant varchar2(4000) := '{"en":"The return delivery status is incorrect when the return delivery receipt has completed. Expected status: [Receiving].","zh":"还货单入库完结时，还货单状态不合法，期望的换货单状态应该为[收货中]"}';
  err_p_rr_inbound_24             constant varchar2(4000) := '{"en":"Cannot find the return delivery due to incorrect return code.","zh":"还货单编号不合法，未查询到此换货单"}';
  err_p_rr_inbound_5              constant varchar2(4000) := '{"en":"The return delivery status is incorrect when the return delivery receipt has completed. Expected status: [Approved].","zh":"还货单入库完结时，还货单状态不合法，期望的换货单状态应该为[已审批]"}';
  err_p_rr_inbound_15             constant varchar2(4000) := '{"en":"The return delivery status is incorrect when the return delivery receipt is being processed. Expected status: [Receiving].","zh":"还货单继续入库时，还货单状态不合法，期望的换货单状态应该为[接收中]"}';
  err_p_rr_inbound_6              constant varchar2(4000) := '{"en":"Cannot obtain the receipt code.","zh":"不能获得入库单编号"}';
  err_p_rr_inbound_7              constant varchar2(4000) := '{"en":"Repeated items found for receipt.","zh":"出现重复的入库物品"}';
  err_p_rr_inbound_8              constant varchar2(4000) := '{"en":"Exception occurred in \"Pack\" data when transferring a \"Box\".","zh":"调拨“盒”时，“本”数据出现异常"}';
  err_p_rr_inbound_18             constant varchar2(4000) := '{"en":"Exception occurred in \"Pack\" data when transferring a \"Trunk\".","zh":"调拨“箱”时，“本”数据出现异常"}';
  err_p_rr_inbound_28             constant varchar2(4000) := '{"en":"Exception occurred in \"Box\" data when transferring a \"Trunk\".","zh":"调拨“箱”时，“盒”数据出现异常"}';
  err_p_rr_inbound_38             constant varchar2(4000) := '{"en":"Cannot find relevant information in inventory when transferring a \"Trunk\". Or the trunk status may be incorrect.","zh":"调拨“箱”时，未在库存中找到相关信息。也可能是箱的状态不正确"}';
  err_p_rr_inbound_9              constant varchar2(4000) := '{"en":"Validation failure: the corresponding trunk of the box is already inside the receipt details.","zh":"盒对应的箱已经出现在入库明细中，逻辑校验失败"}';
  err_p_rr_inbound_10             constant varchar2(4000) := '{"en":"Cannot find relevant information in inventory when transferring a \"Box\". Or the trunk status may be incorrect.","zh":"调拨“盒”时，未在库存中找到相关信息。也可能是箱的状态不正确"}';
  err_p_rr_inbound_11             constant varchar2(4000) := '{"en":"Validation failure: the corresponding trunk of the pack is already inside the receipt details.","zh":"本对应的箱已经出现在入库明细中，逻辑校验失败"}';
  err_p_rr_inbound_12             constant varchar2(4000) := '{"en":"Validation failure: the corresponding trunk of the pack is already inside the receipt details.","zh":"本对应的箱已经出现在入库明细中，逻辑校验失败"}';
  err_p_rr_inbound_13             constant varchar2(4000) := '{"en":"Cannot find relevant information in inventory when transferring a \"Pack\". Or the trunk status may be incorrect.","zh":"调拨“本”时，未在库存中找到相关信息。也可能是箱的状态不正确"}';
  err_p_rr_inbound_14             constant varchar2(4000) := '{"en":"There is no information on this plan and batch in the warehouse manager inventory.","zh":"仓库管理员的库存中，没有此方案和批次的库存信息"}';

  err_p_ar_inbound_1              constant varchar2(4000) := '{"en":"The person does not exist.","zh":"无此人"}';
  err_p_ar_inbound_3              constant varchar2(4000) := '{"en":"Repeated items found for receipt.","zh":"出现重复的入库物品"}';
  err_p_ar_inbound_4              constant varchar2(4000) := '{"en":"Cannot find relevant information in inventory when processing a \"Trunk\". Or the trunk status may be incorrect.","zh":"处理“箱”时，未在库存中找到相关信息。也可能是箱的状态不正确"}';
  err_p_ar_inbound_5              constant varchar2(4000) := '{"en":"Exception occurred in \"Box\" data when processing a \"Trunk\".","zh":"处理“箱”时，“盒”数据出现异常"}';
  err_p_ar_inbound_6              constant varchar2(4000) := '{"en":"Exception occurred in \"Pack\" data when processing a \"Trunk\".","zh":"处理“箱”时，“本”数据出现异常"}';
  err_p_ar_inbound_7              constant varchar2(4000) := '{"en":"Validation failure: the corresponding trunk of the box is already inside the receipt details.","zh":"盒对应的箱已经出现在入库明细中，逻辑校验失败"}';
  err_p_ar_inbound_10             constant varchar2(4000) := '{"en":"Cannot find relevant information in inventory when processing a \"Box\". Or the trunk status may be incorrect.","zh":"处理“盒”时，未在库存中找到相关信息。也可能是箱的状态不正确"}';
  err_p_ar_inbound_38             constant varchar2(4000) := '{"en":"Exception occurred in \"Pack\" data when processing a \"Box\".","zh":"处理“盒”时，“本”数据出现异常"}';
  err_p_ar_inbound_11             constant varchar2(4000) := '{"en":"Validation failure: the corresponding trunk of the pack is already inside the receipt details.","zh":"本对应的箱已经出现在入库明细中，逻辑校验失败"}';
  err_p_ar_inbound_12             constant varchar2(4000) := '{"en":"Validation failure: the corresponding trunk of the pack is already inside the receipt details.","zh":"本对应的箱已经出现在入库明细中，逻辑校验失败"}';
  err_p_ar_inbound_13             constant varchar2(4000) := '{"en":"Cannot find relevant information in inventory when processing a \"Pack\". Or the trunk status may be incorrect.","zh":"处理“本”时，未在库存中找到相关信息。也可能是箱的状态不正确"}';
  err_p_ar_inbound_14             constant varchar2(4000) := '{"en":"There is no information on this plan and batch in the warehouse manager inventory.","zh":"仓库管理员的库存中，没有此方案和批次的库存信息"}';
  err_p_ar_inbound_15             constant varchar2(4000) := '{"en":"The outlet has not set up the sales commission rate of this lottery plan.","zh":"该销售站未设置此方案对应的销售佣金比例"}';
  err_p_ar_inbound_16             constant varchar2(4000) := '{"en":"The outlet does not have an account or the account status is incorrect.","zh":"销售站无账户或相应账户状态不正确"}';
  err_p_ar_inbound_17             constant varchar2(4000) := '{"en":"Insufficient outlet balance.","zh":"销售站余额不足"}';

  err_p_institutions_create_1     constant varchar2(4000) := '{"en":"Institution code cannot be empty.","zh":"部门编码不能为空！"}';
  err_p_institutions_create_2     constant varchar2(4000) := '{"en":"Institution name cannot be empty.","zh":"部门名称不能为空！"}';
  err_p_institutions_create_3     constant varchar2(4000) := '{"en":"Insittution director does not exist.","zh":"部门负责人不存在！"}';
  err_p_institutions_create_4     constant varchar2(4000) := '{"en":"Contact phone cannot be empty.","zh":"部门联系电话不能为空！"}';
  err_p_institutions_create_5     constant varchar2(4000) := '{"en":"This institution code already exists in the system.","zh":"部门编码在系统中已经存在！"}';
  err_p_institutions_create_6     constant varchar2(4000) := '{"en":"Area has been repeatedly governed by other insittution.","zh":"选择区域已经被其他部门管辖！"}';

  err_p_institutions_modify_1     constant varchar2(4000) := '{"en":"Original institution code cannot be empty.","zh":"部门原编码不能为空！"}';
  err_p_institutions_modify_2     constant varchar2(4000) := '{"en":"Other relevant staff in this institution cannot change the institution code.","zh":"部门关联其他人员不能修改编码！"}';

  err_p_outlet_create_1           constant varchar2(4000) := '{"en":"Institution code cannot be empty.","zh":"部门编码不能为空！"}';
  err_p_outlet_create_2           constant varchar2(4000) := '{"en":"The institution is disabled.","zh":"部门无效！"}';
  err_p_outlet_create_3           constant varchar2(4000) := '{"en":"Area code cannot be empty.","zh":"区域编码不能为空！"}';
  err_p_outlet_create_4           constant varchar2(4000) := '{"en":"The area is disabled.","zh":"区域无效！"}';

  err_p_outlet_modify_1           constant varchar2(4000) := '{"en":"The outlet code already exists.","zh":"站点编码已存在！"}';
  err_p_outlet_modify_2           constant varchar2(4000) := '{"en":"The outlet code is invalid.","zh":"站点编码不符合规范！"}';
  err_p_outlet_modify_3           constant varchar2(4000) := '{"en":"Cannot modify outlet code when there is a transaction.","zh":"站点有缴款业务不能变更编码！"}';
  err_p_outlet_modify_4           constant varchar2(4000) := '{"en":"Cannot modify outlet code when there is an order.","zh":"站点有订单业务不能变更编码！"}';

  err_p_outlet_plan_auth_1        constant varchar2(4000) := '{"en":"The delegated plan cannot be empty.","zh":"授权方案不能为空！"}';
  err_p_outlet_plan_auth_2        constant varchar2(4000) := '{"en":"The commission rate of the delegated plan cannot exceed the commission rate of the parent institution.","zh":"授权方案代销费率不能超出所属机构代销费率！"}';

  err_p_org_plan_auth_1           constant varchar2(4000) := '{"en":"The delegated plan cannot be empty.","zh":"授权方案不能为空！"}';
  err_p_org_plan_auth_2           constant varchar2(4000) := '{"en":"The commission rate of the delegated plan cannot exceed 1000.","zh":"授权方案代销费率不能超出1000！"}';

  err_p_warehouse_create_1        constant varchar2(4000) := '{"en":"Warehouse code cannot be empty.","zh":"编码不能为空！"}';
  err_p_warehouse_create_2        constant varchar2(4000) := '{"en":"Warehouse code cannot repeat.","zh":"编码不能重复！"}';
  err_p_warehouse_create_3        constant varchar2(4000) := '{"en":"Warehouse name cannot be empty.","zh":"名称不能为空！"}';
  err_p_warehouse_create_4        constant varchar2(4000) := '{"en":"Warehouse address cannot be empty.","zh":"地址不能为空！"}';
  err_p_warehouse_create_5        constant varchar2(4000) := '{"en":"Warehouse director does not exist.","zh":"负责人不存在！"}';
  err_p_warehouse_create_6        constant varchar2(4000) := '{"en":" has already had administering warehouse.","zh":"-已经有管辖仓库！"}';

  err_p_warehouse_modify_1        constant varchar2(4000) := '{"en":"Warehouse code does not exist.","zh":"编码不存在！"}';

  err_p_admin_create_1            constant varchar2(4000) := '{"en":"Real name cannot be empty.","zh":"真实姓名不能为空！"}';
  err_p_admin_create_2            constant varchar2(4000) := '{"en":"Login name cannot be empty.","zh":"登录名不能为空！"}';
  err_p_admin_create_3            constant varchar2(4000) := '{"en":"Login name already exists.","zh":"登录名已存在！"}';

  err_p_outlet_topup_1            constant varchar2(4000) := '{"en":"Outlet code cannot be empty.","zh":"站点编码不能为空！"}';
  err_p_outlet_topup_2            constant varchar2(4000) := '{"en":"User does not exist or is disabled.","zh":"用户不存在或者无效！"}';
  err_p_outlet_topup_3            constant varchar2(4000) := '{"en":"Password cannot be empty.","zh":"密码不能为空！"}';
  err_p_outlet_topup_4            constant varchar2(4000) := '{"en":"Password is invalid.","zh":"密码无效！"}';

  err_p_institutions_topup_1      constant varchar2(4000) := '{"en":"Institution code cannot be empty.","zh":"机构编码不能为空！"}';
  err_p_institutions_topup_2      constant varchar2(4000) := '{"en":"The current user is disabled.","zh":"当前用户无效！"}';
  err_p_institutions_topup_3      constant varchar2(4000) := '{"en":"The current institution is disabled.","zh":"当前机构无效！"}';

  err_p_outlet_withdraw_app_1     constant varchar2(4000) := '{"en":"Insufficient balance for cash withdraw.","zh":"提现金额不足！"}';
  err_p_outlet_withdraw_con_1     constant varchar2(4000) := '{"en":"Application form cannot be empty.","zh":"申请单不能为空！"}';
  err_p_outlet_withdraw_con_2     constant varchar2(4000) := '{"en":"Application form does not exist or is not approved.","zh":"申请单不存在或状态非审批通过！"}';
  err_p_outlet_withdraw_con_3     constant varchar2(4000) := '{"en":"The outlet does not exist or the password is incorrect.","zh":"站点不存在或密码无效！"}';

  err_p_warehouse_delete_1        constant varchar2(4000) := '{"en":"Cannot delete a warehouse with item inventory.","zh":"仓库中有库存物品，不可进行删除！"}';

  err_p_warehouse_check_step1_1   constant varchar2(4000) := '{"en":"The inventory check name cannot be empty.","zh":"盘点名称不能为空！"}';
  err_p_warehouse_check_step1_2   constant varchar2(4000) := '{"en":"The warehouse for check cannot be empty.","zh":"库房不能为空！"}';
  err_p_warehouse_check_step1_3   constant varchar2(4000) := '{"en":"The check operator is disabled.","zh":"盘点人无效！"}';
  err_p_warehouse_check_step1_4   constant varchar2(4000) := '{"en":"The warehouse is disabled or is in checking.","zh":"仓库无效或者正在盘点中！"}';
  err_p_warehouse_check_step1_5   constant varchar2(4000) := '{"en":"There are no lottery tickets or items for check in this warehouse.","zh":"仓库无彩票物品，没有必要盘点！"}';

  err_p_warehouse_check_step2_1   constant varchar2(4000) := '{"en":"The inventory check code cannot be empty.","zh":"盘点单不能为空！"}';
  err_p_warehouse_check_step2_2   constant varchar2(4000) := '{"en":"The inventory check does not exist or has completed.","zh":"盘点单不存在或已完结！"}';
  err_p_warehouse_check_step2_3   constant varchar2(4000) := '{"en":"The scanned information cannot be empty.","zh":"扫描信息不能为空！"}';

  err_p_mm_fund_repay_1           constant varchar2(4000) := '{"en":"Market manager cannot be empty.","zh":"市场管理员不能为空！"}';
  err_p_mm_fund_repay_2           constant varchar2(4000) := '{"en":"Market manager does not exist or is deleted.","zh":"市场管理员已经删除或不存在！"}';
  err_p_mm_fund_repay_3           constant varchar2(4000) := '{"en":"Current operator cannot be empty.","zh":"当前操作人不能为空！"}';
  err_p_mm_fund_repay_4           constant varchar2(4000) := '{"en":"Current operator does not exist or is deleted.","zh":"当前操作人已经删除或不存在！"}';
  err_p_mm_fund_repay_5           constant varchar2(4000) := '{"en":"The repayment amount is invalid.","zh":"还款金额无效！"}';

  err_p_fund_change_1             constant varchar2(4000) := '{"en":"Insufficient account balance.","zh":"账户余额不足"}';
  err_p_fund_change_2             constant varchar2(4000) := '{"en":"Incorrect fund type.","zh":"资金类型不合法"}';
  err_p_fund_change_3             constant varchar2(4000) := '{"en":"The outlet account does not exist, or the account status is incorrect.","zh":"未发现销售站的账户，或者账户状态不正确"}';

  err_p_lottery_reward_3          constant varchar2(4000) := '{"en":"This lottery ticket has not been on sale yet.","zh":"彩票未被销售"}';
  err_p_lottery_reward_4          constant varchar2(4000) := '{"en":"This lottery ticket has already been paid.","zh":"彩票已兑奖"}';
  err_p_lottery_reward_5          constant varchar2(4000) := '{"en":"Incorrect system parameter, please contact system administrator for recalibration.","zh":"系统参数值不正确，请联系管理员，重新设置"}';
  err_p_lottery_reward_6          constant varchar2(4000) := '{"en":"The outlet has not set up the payout commission rate of this lottery plan.","zh":"该销售站未设置此方案对应的兑奖佣金比例"}';
  err_p_lottery_reward_7          constant varchar2(4000) := '{"en":"The outlet has not set up the payout commission rate of this lottery plan.","zh":"该销售站未设置此方案对应的兑奖佣金比例"}';

  err_f_check_import_ticket       constant varchar2(4000) := '{"en":"Wrong input parameter, must be 1 or 2.","zh":"输入参数错误，应该为1或者2"}';

  err_f_check_ticket_include_1    constant varchar2(4000) := '{"en":"This lottery trunk has already been processed.","zh":"此箱彩票已经被处理"}';
  err_f_check_ticket_include_2    constant varchar2(4000) := '{"en":"This lottery box has already been processed.","zh":"此盒彩票已经被处理"}';
  err_f_check_ticket_include_3    constant varchar2(4000) := '{"en":"This lottery pack has already been processed.","zh":"此本彩票已经被处理"}';

  err_p_item_delete_1             constant varchar2(4000) := '{"en":"Item code cannot be empty.","zh":"物品编码不能为空"}';
  err_p_item_delete_2             constant varchar2(4000) := '{"en":"The item does not exist.","zh":"不存在此物品"}';
  err_p_item_delete_3             constant varchar2(4000) := '{"en":"This item currently exists in inventory.","zh":"该物品当前有库存"}';

  err_p_withdraw_approve_1        constant varchar2(4000) := '{"en":"Withdraw code cannot be empty.","zh":"提现编码不能为空"}';
  err_p_withdraw_approve_2        constant varchar2(4000) := '{"en":"The withdraw code does not exist or the withdraw record is disabled.","zh":"提现编码不存在或单据状态无效！"}';
  err_p_withdraw_approve_3        constant varchar2(4000) := '{"en":"Permission denied for cash withdraw approval.","zh":"审批结果超出定义范围！"}';
  err_p_withdraw_approve_4        constant varchar2(4000) := '{"en":"Insufficient balance.","zh":"余额不足！"}';
  err_p_withdraw_approve_5        constant varchar2(4000) := '{"en":"outlet cash withdraw failure.","zh":"销售站资金处理失败！"}';

  err_p_item_outbound_1           constant varchar2(4000) := '{"en":"This item currently does not exist in inventory.","zh":"该物品当前无库存"}';
  err_p_item_outbound_2           constant varchar2(4000) := '{"en":"This item is not enough in inventory.","zh":"该物品在库存不足"}';

  err_p_item_damage_1             constant varchar2(4000) := '{"en":"Item code cannot be empty.","zh":"物品编码不能为空"}';
  err_p_item_damage_2             constant varchar2(4000) := '{"en":"Warehouse code cannot be empty.","zh":"仓库编码不能为空"}';
  err_p_item_damage_3             constant varchar2(4000) := '{"en":"Damage quantity must be positive.","zh":"损毁物品数量必须为正数"}';
  err_p_item_damage_4             constant varchar2(4000) := '{"en":"The operator does not exist.","zh":"损毁登记人不存在"}';
  err_p_item_damage_5             constant varchar2(4000) := '{"en":"The item does not exist or is deleted.","zh":"该物品不存在或已删除"}';
  err_p_item_damage_6             constant varchar2(4000) := '{"en":"The warehouse does not exist or is deleted.","zh":"该仓库不存在或已删除"}';
  err_p_item_damage_7             constant varchar2(4000) := '{"en":"The item does not exist in this warehouse.","zh":"该仓库中不存在此物品"}';
  err_p_item_damage_8             constant varchar2(4000) := '{"en":"The item quantity in this warehouse is less than the input damage quantity.","zh":"该仓库中此物品的数量小于登记损毁的数量"}';

  err_p_ar_outbound_10            constant varchar2(4000) := '{"en":"Cannot refund this ticket because paid tickets may exist.","zh":"有彩票已经兑奖，不能退票"}';
  err_p_ar_outbound_20            constant varchar2(4000) := '{"en":"The corresponding trunk data is missing from the lottery receipt.","zh":"对应的箱数据，没有在入库单中找到"}';
  err_p_ar_outbound_30            constant varchar2(4000) := '{"en":"The corresponding box data is missing from the lottery receipt.","zh":"对应的盒数据，没有在入库单中找到"}';
  err_p_ar_outbound_40            constant varchar2(4000) := '{"en":"The corresponding pack data is missing from the lottery receipt.","zh":"对应的本数据，没有在入库单中找到"}';
  err_p_ar_outbound_50            constant varchar2(4000) := '{"en":"The corresponding trunk data has been found in the receipt, but its status or its outlet information is incorrect.","zh":"对应的箱数据已经在入库单中找到，但是状态或者所属站点信息不正确"}';
  err_p_ar_outbound_60            constant varchar2(4000) := '{"en":"Cannot find the sales record of the refunding ticket.","zh":"未查询到待退票的售票记录"}';
  err_p_ar_outbound_70            constant varchar2(4000) := '{"en":"Exceeds the \"maximum allowable credit\" as held by this manager.","zh":"超过此管理员允许持有的“最高赊票金额”"}';

  err_p_ticket_perferm_1          constant varchar2(4000) := '{"en":"This warehouse is stopped or is in checking. This operation is denied.","zh":"此仓库状态处于盘点或停用状态，不能进行出入库操作"}';
  err_p_ticket_perferm_3          constant varchar2(4000) := '{"en":"The plan of this batch does not exist in the system.","zh":"系统中不存在此批次的彩票方案"}';
  err_p_ticket_perferm_5          constant varchar2(4000) := '{"en":"The plan of this batch has already been disabled.","zh":"此批次的彩票方案已经停用"}';
  err_p_ticket_perferm_10         constant varchar2(4000) := '{"en":"This lottery trunk does not exist.","zh":"此箱彩票不存在"}';
  err_p_ticket_perferm_110        constant varchar2(4000) := '{"en":"This lottery box does not exist.","zh":"此盒彩票不存在"}';
  err_p_ticket_perferm_120        constant varchar2(4000) := '{"en":"The status of this lottery \"Box\" is not as expected, current status: ","zh":"此“盒”彩票的状态与预期不符，当前状态为"}';
  err_p_ticket_perferm_130        constant varchar2(4000) := '{"en":"The system status of this lottery \"Box\" is OPEN, therefore trunk-wise processing is not allowed.","zh":"此“盒”彩票在系统中处于开箱状态，因此不能进行整箱处理"}';
  err_p_ticket_perferm_140        constant varchar2(4000) := '{"en":"Error may exist in the inventory information of this lottery \"Box\", please double-check before proceed.","zh":"此“盒”彩票库存信息可能存在错误，请查询以后再进行操作"}';
  err_p_ticket_perferm_150        constant varchar2(4000) := '{"en":"Exception occurred during lottery processing, please contact the system maintenance for support.","zh":"处理彩票时，出现数据异常，请联系系统人员"}';
  err_p_ticket_perferm_160        constant varchar2(4000) := '{"en":"Exception occurred in the \"Pack\" data when processing a \"Box\". Possible errors include: 1-Some packs in this box have been removed, 2-The status of some packs in this box is not as expected.","zh":"处理“盒”时，“本”数据出现异常。可能的错误为：1-此盒对应的某些本已经被转移，2-此盒对应的某些本的状态与预期状态不符"}';
  err_p_ticket_perferm_20         constant varchar2(4000) := '{"en":"The status of this lottery \"Trunk\" is not as expected, current status: ","zh":"此“箱”彩票的状态与预期不符，当前状态为"}';
  err_p_ticket_perferm_210        constant varchar2(4000) := '{"en":"This lottery pack does not exist.","zh":"此本彩票不存在"}';
  err_p_ticket_perferm_220        constant varchar2(4000) := '{"en":"The status of this lottery \"Pack\" is not as expected, current status: ","zh":"此“本”彩票的状态与预期不符，当前状态为"}';
  err_p_ticket_perferm_230        constant varchar2(4000) := '{"en":"Error may exist in the inventory information of this lottery \"Pack\", please double-check before proceed.","zh":"此“本”彩票库存信息可能存在错误，请查询以后再进行操作"}';
  err_p_ticket_perferm_240        constant varchar2(4000) := '{"en":"Exception occurred during lottery processing, please contact the system maintenance for support.","zh":"处理彩票时，出现数据异常，请联系系统人员"}';
  err_p_ticket_perferm_30         constant varchar2(4000) := '{"en":"The system status of this lottery \"Trunk\" is OPEN, therefore trunk-wise processing is not allowed.","zh":"此“箱”彩票在系统中处于开箱状态，因此不能进行整箱处理"}';
  err_p_ticket_perferm_40         constant varchar2(4000) := '{"en":"Error may exist in the inventory information of this lottery \"Trunk\", please double-check before proceed.","zh":"此“箱”彩票库存信息可能存在错误，请查询以后再进行操作"}';
  err_p_ticket_perferm_50         constant varchar2(4000) := '{"en":"Exception occurred during lottery processing, please contact the system maintenance for support.","zh":"处理彩票时，出现数据异常，请联系系统人员"}';
  err_p_ticket_perferm_60         constant varchar2(4000) := '{"en":"Exception occurred in the \"Box\" data when processing a \"Trunk\". Possible errors include: 1-Some boxes in this trunk have been opened for use, 2-Some boxes in this trunk have been removed, 3-The status of some boxes in this trunk is not as expected.","zh":"处理“箱”时，“盒”数据出现异常。可能的错误为：1-此箱对应的某些盒已经被拆开使用，2-此箱对应的某些盒已经被转移，3-此箱对应的某些盒的状态与预期状态不符"}';
  err_p_ticket_perferm_70         constant varchar2(4000) := '{"en":"Exception occurred in the \"Box\" data when processing a \"Trunk\". Possible errors include: 1-Some packs in this trunk have been removed, 2-The status of some packs in this trunk is not as expected.","zh":"处理“箱”时，“盒”数据出现异常。可能的错误为：1-此箱对应的某些本已经被转移，2-此箱对应的某些本的状态与预期状态不符"}';

  err_f_get_sys_param_1           constant varchar2(4000) := '{"en":"The system parameter is not set. parameter: ","zh":"系统参数未被设置，参数编号为："}';

  err_p_teller_create_1           constant varchar2(4000) := '{"en":"Invalid Agency Code!","zh":"无效的销售站"}';
  err_p_teller_create_2           constant varchar2(4000) := '{"en":"The teller code is already used.","zh":"销售员编号重复"}';
  err_p_teller_create_3           constant varchar2(4000) := '{"en":"The teller code is out of the range.","zh":"输入的编码超出范围！"}';

  err_f_gen_teller_term_code_1    constant varchar2(4000) := '{"en":"The teller code is out of the range.","zh":"编码超出范围！"}';

  err_p_teller_status_change_1    constant varchar2(4000) := '{"en":"Invalid teller status!","zh":"无效的状态值"}';
  err_p_teller_status_change_2    constant varchar2(4000) := '{"en":"Invalid teller Code!","zh":"销售员不存在"}';
  err_p_set_sale_1                constant varchar2(4000) := '{"en":"Invalid TYPE(should BE 1) from the input parameter. Type is :","zh":"报文输入有错，非售票报文。类型为："}';
  err_p_set_cancel_1              constant varchar2(4000) := '{"en":"Invalid TYPE(should BE 2, 4) from the input parameter. Type is :","zh":"报文输入有错，非退票报文。类型为："}';
  err_p_set_cancel_2              constant varchar2(4000) := '{"en":"Can not find this ticket. ticket flow No. is ","zh":"未找到对应的售票信息。输入的流水号为："}';
  err_p_set_pay_1                 constant varchar2(4000) := '{"en":"Invalid TYPE(should BE 3, 5) from the input parameter. Type is :","zh":"报文输入有错，非兑奖报文。类型为："}';

  err_p_om_agency_auth_1          constant varchar2(4000) := '{"en":"The sales commission rate of the outlet that belong in some agents can not be large than the sales commission rate of its agent","zh":"代理商所属销售站销售代销费比例不能大于代理商的销售代销费比例"}';
  err_p_om_agency_auth_2          constant varchar2(4000) := '{"en":"The payout commission rate of the outlet that belong in some agents can not be large than the payout commission rate of its agent","zh":"代理商所属销售站销售代销费比例不能大于代理商的销售代销费比例"}';
  err_p_set_json_issue_draw_n_1   constant varchar2(4000) := '{"zh":"游戏期次不存在，或者未开奖"}';

  err_p_outlettopup_digital_suc   constant varchar2(4000) := '{"zh":"充值交易出现异常，可能是重复提交造成"}';

  msg0001                         constant varchar2(4000) := '{"en":"Rolling in from abandoned award","zh":"弃奖滚入"}';
	msg0002                         constant varchar2(4000) := '{"en":"Unknown pool adjustment type","zh":"未知的奖池调整类型"}';
	msg0003                         constant varchar2(4000) := '{"en":"Receiving object or title can not be empty","zh":"接收对象或标题不能为空"}';
	msg0004                         constant varchar2(4000) := '{"en":"Abnormal database operation","zh":"数据库操作异常"}';
	msg0005                         constant varchar2(4000) := '{"en":"The games being authorized can not be empty","zh":"授权游戏不能为空"}';
	msg0006                         constant varchar2(4000) := '{"en":"Invalid status","zh":"无效的状态值"}';
	msg0007                         constant varchar2(4000) := '{"en":"Already at the current state in the database","zh":"数据库中已经是当前状态"}';
	msg0008                         constant varchar2(4000) := '{"en":"This agency has been removed","zh":"站点已经清退"}';
	msg0009                         constant varchar2(4000) := '{"en":"Repeating code","zh":"编号重复"}';
	msg0010                         constant varchar2(4000) := '{"en":"Using 99 in area code is not allowed","zh":"区域编码中不允许使用[99]"}';
	msg0011                         constant varchar2(4000) := '{"en":"The code of the national center must be 0","zh":"全国区域编码必须为[0]"}';
	msg0012                         constant varchar2(4000) := '{"en":"The code of this type of region must be from [00-99]","zh":"此类型区域编码必须为[00-99]"}';
	msg0013                         constant varchar2(4000) := '{"en":"The code of this type of region must be from [0100-9999]","zh":"此类型区域编码必须为[0100-9999]"}';
	msg0014                         constant varchar2(4000) := '{"en":"Format error: the parent code is inconsistent with the parent region","zh":"编码格式错误:父区域编码部分和所属父区域不一致"}';
	msg0015                         constant varchar2(4000) := '{"en":"Number of agencies exceeds the limit of the parent region","zh":"销售站数量限制大于父区域数量限制"}';
	msg0016                         constant varchar2(4000) := '{"en":"Number of tellers exceeds the limit of the parent region","zh":"销售员数量限制大于父区域数量限制"}';
	msg0017                         constant varchar2(4000) := '{"en":"Number of terminals exceeds the limit of the parent region","zh":"终端机数量限制大于父区域数量限制"}';
	msg0018                         constant varchar2(4000) := '{"en":"Central agency","zh":"直属站"}';
	msg0019                         constant varchar2(4000) := '{"en":"The national center cannot be deleted","zh":"中心是系统内置不能删除"}';
	msg0020                         constant varchar2(4000) := '{"en":"The deleting region has affiliated sub-level regions","zh":"该区域有关联子区域不能删除"}';
	msg0021                         constant varchar2(4000) := '{"en":"The deleting region has affiliated agencies","zh":"该区域有关联站点不能删除"}';
	msg0022                         constant varchar2(4000) := '{"en":"The deleting region has affiliated tellers","zh":"该区域有关联用户不能删除"}';
	msg0023                         constant varchar2(4000) := '{"en":"Invalid agency","zh":"无效的销售站点"}';
	msg0024                         constant varchar2(4000) := '{"en":"Invalid operator","zh":"无效的操作人"}';
	msg0025                         constant varchar2(4000) := '{"en":"The adjustment amount cannot be empty","zh":"调整金额不能为空"}';
	msg0026                         constant varchar2(4000) := '{"en":"The adjustment amount is zero, it is not necessary to calculate","zh":"调整金额为0没有必要计算"}';
	msg0027                         constant varchar2(4000) := '{"en":"The issue cannot be empty","zh":"期次不能为空"}';
	msg0028                         constant varchar2(4000) := '{"en":"Invalid game code","zh":"无效的游戏编码"}';
	msg0029                         constant varchar2(4000) := '{"en":"The game is invalid","zh":"游戏无效"}';
	msg0030                         constant varchar2(4000) := '{"en":"The basic parameters are empty","zh":"游戏基础信息配置信息为空"}';
	msg0031                         constant varchar2(4000) := '{"en":"The policy parameters are empty","zh":"游戏政策参数配置信息为空"}';
	msg0032                         constant varchar2(4000) := '{"en":"The prize parameters are empty","zh":"游戏奖级参数配置信息为空"}';
	msg0033                         constant varchar2(4000) := '{"en":"The game subtype parameters are empty","zh":"游戏玩法参数配置信息为空"}';
	msg0034                         constant varchar2(4000) := '{"en":"The winning parameters are empty","zh":"游戏中奖参数配置信息为空"}';
	msg0035                         constant varchar2(4000) := '{"en":"Cannot arrange additional issues on the selected date","zh":"所选日期无法补充排期"}';
	msg0036                         constant varchar2(4000) := '{"en":"There is a time conflict in the issue arrangement","zh":"排期存在时间交叉"}';
	msg0037                         constant varchar2(4000) := '{"en":"Incorrect password","zh":"密码不正确"}';
	msg0038                         constant varchar2(4000) := '{"en":"Failed to update the teller''s password","zh":"更新销售员密码失败"}';
	msg0039                         constant varchar2(4000) := '{"en":"Failed to update the teller''s sign-out information","zh":"更新销售员签出信息失败"}';
	msg0040                         constant varchar2(4000) := '{"en":"Failed to update the teller''s sign-in information","zh":"更新销售员签入信息失败"}';
	msg0041                         constant varchar2(4000) := '{"en":"The teller code can not be repeated","zh":"销售员编号不能重复"}';
	msg0042                         constant varchar2(4000) := '{"en":"Cannot add tellers in a central agency","zh":"中心站不可以配置销售员"}';
	msg0043                         constant varchar2(4000) := '{"en":"The number of tellers is out of range","zh":"销售员数量超出范围"}';
	msg0044                         constant varchar2(4000) := '{"en":"The number of tellers has exceeded the limit of the current region","zh":"销售员数量已经超过当前区域限制值"}';
	msg0045                         constant varchar2(4000) := '{"en":"The number of tellers has exceeded the limit of the parent region","zh":"销售员数量已经超过父区域限制值"}';
	msg0046                         constant varchar2(4000) := '{"en":"Invalid teller","zh":"无效的销售员"}';
	msg0047                         constant varchar2(4000) := '{"en":"The teller has been deleted","zh":"销售员已删除"}';
	msg0048                         constant varchar2(4000) := '{"en":"Format of the MAC address is invalid","zh":"MAC地址格式不正确"}';
	msg0049                         constant varchar2(4000) := '{"en":"The terminal code does not meet the specification","zh":"终端编码不符合规范"}';
	msg0050                         constant varchar2(4000) := '{"en":"The MAC can not be repeated","zh":"MAC地址不能重复"}';
	msg0051                         constant varchar2(4000) := '{"en":"The number of terminals has exceeded the limit of the current region","zh":"终端数量已经超过当前区域限制值"}';
	msg0052                         constant varchar2(4000) := '{"en":"The number of terminals has exceeded the limit of the parent region","zh":"终端数量已经超过父区域限制值"}';
	msg0053                         constant varchar2(4000) := '{"en":"Invalid terminal","zh":"无效的终端机"}';
	msg0054                         constant varchar2(4000) := '{"en":"The terminal has been deleted","zh":"终端已退机"}';
	msg0055                         constant varchar2(4000) := '{"en":"Invalid parameter","zh":"无效的参数对象"}';
	msg0056                         constant varchar2(4000) := '{"en":"The name of the upgrade plan can not be repeated","zh":"升级计划名称不能重复"}';
	msg0057                         constant varchar2(4000) := '{"en":"Invalid upgrade object","zh":"无效的升级对象"}';
	msg0058                         constant varchar2(4000) := '{"en":"Terminal","zh":"终端机"}';
	msg0059                         constant varchar2(4000) := '{"en":"does not exist","zh":"不存在"}';
	msg0060                         constant varchar2(4000) := '{"en":"The machine type does not match the upgrading version","zh":"机型和升级版本要求不匹配"}';
	msg0061                         constant varchar2(4000) := '{"en":"The parameter name is wrong","zh":"参数名称错误"}';
	msg0062                         constant varchar2(4000) := '{"en":"Failed to update the error code and description of the drawing process","zh":"更新期次开奖过程错误编码和描述失败"}';
	msg0063                         constant varchar2(4000) := '{"en":"The pool is not found","zh":"没有找到游戏的奖池"}';
	msg0064                         constant varchar2(4000) := '{"en":"The amount rolling in from the pool cannot be empty","zh":"滚入的奖池金额不能为空"}';
	msg0065                         constant varchar2(4000) := '{"en":"Chump changes cannot be empty","zh":"期次奖金抹零不能为空"}';
	msg0066                         constant varchar2(4000) := '{"en":"Failed to get the policy parameters","zh":"无法获取政策参数"}';
	msg0067                         constant varchar2(4000) := '{"en":"The sales amount cannot be empty","zh":"期次销售金额不能为空值"}';
	msg0068                         constant varchar2(4000) := '{"en":"Logical error: the amount of sales is 0, but the input pool amount is greater than 0","zh":"逻辑错误：期次销售金额为0，但是输入的奖池金额大于0"}';
	msg0069                         constant varchar2(4000) := '{"en":"The pool amount is insufficient, supplemented from the adjustment fund","zh":"期次奖池不足，调节基金补充"}';
	msg0070                         constant varchar2(4000) := '{"en":"Rolling in from drawing","zh":"期次开奖滚入"}';
	msg0071                         constant varchar2(4000) := '{"en":"Failed to process the risk-control related statistics","zh":"期次风险控制相关统计数值失败"}';
	msg0072                         constant varchar2(4000) := '{"en":"The issue status is invalid","zh":"期次状态无效"}';
	msg0073                         constant varchar2(4000) := '{"en":"The issue does not exist or has completed","zh":"期次不存在或期次已完结"}';
	msg0074                         constant varchar2(4000) := '{"en":"The issue can not be repeated","zh":"期次不能重复"}';
	msg0075                         constant varchar2(4000) := '{"en":"Failed to get the payout period from the policy parameters","zh":"无法获取政策参数中的兑奖期"}';
	msg0076                         constant varchar2(4000) := '{"en":"Failed to update the ticket number statistics","zh":"更新期次票数统计失败"}';
	msg0077                         constant varchar2(4000) := '{"en":"Failed to update the winnings statistics","zh":"更新期次中奖统计信息失败"}';
	msg0078                         constant varchar2(4000) := '{"en":"The parameter code can not be empty","zh":"参数编号不能为空"}';
	msg0079                         constant varchar2(4000) := '{"en":"Invalid parameter","zh":"无效参数"}';
	msg0080                         constant varchar2(4000) := '{"en":"The agency code does not meet the specification","zh":"站点编码不符合规范"}';
	msg0081                         constant varchar2(4000) := '{"en":"Agency code overflow","zh":"编码溢出"}';
	msg0082                         constant varchar2(4000) := '{"en":"Error occurred when obtaining the system parameters","zh":"获取系统参数时出现错误"}';
	msg0083                         constant varchar2(4000) := '{"en":"Bank account cannot be repeated","zh":"银行账号不能重复"}';
	msg0084                         constant varchar2(4000) := '{"en":"The issuance fee is out of range","zh":"游戏发行费用超出范围"}';
	msg0085                         constant varchar2(4000) := '{"en":"The data are being processed by others","zh":"数据正在被别人处理中"}';
	msg0086                         constant varchar2(4000) := '{"en":"Deleting condition not satisfied","zh":"不符合删除条件"}';

end;