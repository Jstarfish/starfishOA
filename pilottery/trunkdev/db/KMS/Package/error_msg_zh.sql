create or replace package error_msg is
   /******************************/
   /****** 错误消息中文版本 ******/
   /******************************/

   /*----- 通用错误类型定义 ------*/
   err_comm_password_not_match constant  varchar2(4000)   := '用户密码错误';

   /*----- 各个存储过程中的定义 ------*/
   -- err_p_cxxxxx_1
   -- err_p_cxxxxx_2
   -- err_f_cxxxxx_1
   -- err_f_cxxxxx_2

   err_p_import_batch_file_1  constant varchar2(4000) := '批次数据信息已经存在';
   err_p_import_batch_file_2  constant varchar2(4000) := '数据文件中所记录的方案与批次信息，与界面输入的方案和批次不符';

   err_p_batch_inbound_1 constant varchar2(4000) := '此箱已经入库';
   err_p_batch_inbound_2 constant varchar2(4000) := '无此仓库';
   err_p_batch_inbound_3 constant varchar2(4000) := '无此批次';
   err_p_batch_inbound_4 constant varchar2(4000) := '操作类型参数错误，应该为1，2，3';
   err_p_batch_inbound_5 constant varchar2(4000) := '在进行继续入库和完结入库操作时，输入的批次入库单错误，未发现此批次入库单';
   err_p_batch_inbound_6 constant varchar2(4000) := '在进行继续入库时，输入的批次入库单错误，或者此批次入库单已经完结';
   err_p_batch_inbound_7 constant varchar2(4000) := '此批次的方案已经入库完毕，请不要重复进行';

   err_f_get_warehouse_code_1 constant varchar2(4000) := '输入的账户类型不是“jg”,“zd”,“mm”';

   err_f_get_lottery_info_1 constant varchar2(4000) := '输入的“箱”号超出合法的范围';
   err_f_get_lottery_info_2 constant varchar2(4000) := '输入的“盒”号超出合法的范围';
   err_f_get_lottery_info_3 constant varchar2(4000) := '输入的“本”号超出合法的范围';

   err_p_tb_outbound_3  constant varchar2(4000) := '在进行继续出库时，输入的调拨单号错误，或者此调拨单对应的出库单，出库已经完结';
   err_p_tb_outbound_4  constant varchar2(4000) := '调拨单出库完结时，调拨单状态不合法';
   err_p_tb_outbound_14 constant varchar2(4000) := '调拨单实际出库数量与申请数量不符';
   err_p_tb_outbound_5  constant varchar2(4000) := '进行调拨单出库时，调拨单状态不合法';
   err_p_tb_outbound_6  constant varchar2(4000) := '不能获得出库单编号';
   err_p_tb_outbound_7  constant varchar2(4000) := '实际出库票数不应该大于调拨单计划出库票数';

   err_p_tb_inbound_2  constant varchar2(4000) := '输入的仓库所属机构，与调拨单中标明的接收机构不符';
   err_p_tb_inbound_3  constant varchar2(4000) := '在进行继续入库时，输入的调拨单号错误，或者此调拨单对应的入库单，入库已经完结';
   err_p_tb_inbound_4  constant varchar2(4000) := '调拨单入库完结时，调拨单状态与预期值不符';
   err_p_tb_inbound_5  constant varchar2(4000) := '进行调拨单入库时，调拨单状态不合法';
   err_p_tb_inbound_6  constant varchar2(4000) := '继续添加彩票时，未能按照输入的调拨单编号，查询到相应的入库单编号。可能传入了错误的调拨单编号';
   err_p_tb_inbound_25 constant varchar2(4000) := '未查询到此调拨单';
   err_p_tb_inbound_7 constant varchar2(4000)  := '实际调拨票数，应该小于或者等于申请调拨票数';

   err_p_batch_end_1 constant varchar2(4000) := '无此人';
   err_p_batch_end_2 constant varchar2(4000) := '此方案已经不可用';
   err_p_batch_end_3 constant varchar2(4000) := '存在“在途”和“在站点”的彩票，不能执行批次终结';
   err_p_batch_end_4 constant varchar2(4000) := '存在“在途”和“在站点”的彩票，不能执行批次终结';
   err_p_batch_end_5 constant varchar2(4000) := '存在“在途”和“在站点”的彩票，不能执行批次终结';


   err_p_gi_outbound_4  constant varchar2(4000) := '出货单出库完结时，出货单状态不合法';
   err_p_gi_outbound_5  constant varchar2(4000) := '进行出货单出库时，出货单状态不合法';
   err_p_gi_outbound_6  constant varchar2(4000) := '不能获得出库单编号';
   err_p_gi_outbound_1  constant varchar2(4000) := '无此人';
   err_p_gi_outbound_3  constant varchar2(4000) := '在进行继续出库时，输入的调拨单号错误，或者此调拨单对应的出库单，出库已经完结';
   err_p_gi_outbound_10 constant varchar2(4000) := '调拨“箱”时，“本”数据出现异常';
   err_p_gi_outbound_12 constant varchar2(4000) := '调拨“盒”时，未在库存中找到相关信息。也可能是箱的状态不正确';
   err_p_gi_outbound_13 constant varchar2(4000) := '调拨“盒”时，对应的“本”数据异常';
   err_p_gi_outbound_16 constant varchar2(4000) := '调拨“本”时，未在库存中找到相关信息。也可能是箱的状态不正确';
   err_p_gi_outbound_7  constant varchar2(4000) := '出现重复的出库物品';
   err_p_gi_outbound_8  constant varchar2(4000) := '调拨“箱”时，未在库存中找到相关信息。也可能是箱的状态不正确';
   err_p_gi_outbound_9  constant varchar2(4000) := '调拨“箱”时，“盒”数据出现异常';
   err_p_gi_outbound_2  constant varchar2(4000) := '无此仓库';
   err_p_gi_outbound_11 constant varchar2(4000) := '盒对应的箱已经出现在出库明细中，逻辑校验失败';
   err_p_gi_outbound_14 constant varchar2(4000) := '本对应的箱已经出现在出库明细中，逻辑校验失败';
   err_p_gi_outbound_15 constant varchar2(4000) := '本对应的箱已经出现在出库明细中，逻辑校验失败';
   err_p_gi_outbound_17 constant varchar2(4000) := '超过此管理员允许持有的“最高赊票金额”';

   err_p_rr_inbound_1 constant varchar2(4000) := '无此人';
   err_p_rr_inbound_2 constant varchar2(4000) := '无此仓库';
   err_p_rr_inbound_3 constant varchar2(4000) := '操作类型参数错误，应该为1，2，3';
   err_p_rr_inbound_4 constant varchar2(4000) := '还货单入库完结时，还货单状态不合法，期望的换货单状态应该为[收货中]';
   err_p_rr_inbound_24 constant varchar2(4000) := '还货单编号不合法，未查询到此换货单';
   err_p_rr_inbound_5 constant varchar2(4000) := '还货单入库完结时，还货单状态不合法，期望的换货单状态应该为[已审批]';
   err_p_rr_inbound_15 constant varchar2(4000) := '还货单继续入库时，还货单状态不合法，期望的换货单状态应该为[接收中]';
   err_p_rr_inbound_6 constant varchar2(4000) := '不能获得入库单编号';
   err_p_rr_inbound_7 constant varchar2(4000) := '出现重复的入库物品';
   err_p_rr_inbound_8 constant varchar2(4000) := '调拨“盒”时，“本”数据出现异常';
   err_p_rr_inbound_18 constant varchar2(4000) := '调拨“箱”时，“本”数据出现异常';
   err_p_rr_inbound_28 constant varchar2(4000) := '调拨“箱”时，“盒”数据出现异常';
   err_p_rr_inbound_38 constant varchar2(4000) := '调拨“箱”时，未在库存中找到相关信息。也可能是箱的状态不正确';
   err_p_rr_inbound_9 constant varchar2(4000) := '盒对应的箱已经出现在入库明细中，逻辑校验失败';
   err_p_rr_inbound_10 constant varchar2(4000) := '调拨“盒”时，未在库存中找到相关信息。也可能是箱的状态不正确';
   err_p_rr_inbound_11 constant varchar2(4000) := '本对应的箱已经出现在入库明细中，逻辑校验失败';
   err_p_rr_inbound_12 constant varchar2(4000) := '本对应的箱已经出现在入库明细中，逻辑校验失败';
   err_p_rr_inbound_13 constant varchar2(4000) := '调拨“本”时，未在库存中找到相关信息。也可能是箱的状态不正确';
   err_p_rr_inbound_14 constant varchar2(4000) := '仓库管理员的库存中，没有此方案和批次的库存信息';

   err_p_ar_inbound_1 constant varchar2(4000) := '无此人';
   err_p_ar_inbound_3 constant varchar2(4000) := '出现重复的入库物品';
   err_p_ar_inbound_4 constant varchar2(4000) := '处理“箱”时，未在库存中找到相关信息。也可能是箱的状态不正确';
   err_p_ar_inbound_5 constant varchar2(4000) := '处理“箱”时，“盒”数据出现异常';
   err_p_ar_inbound_6 constant varchar2(4000) := '处理“箱”时，“本”数据出现异常';
   err_p_ar_inbound_7 constant varchar2(4000) := '盒对应的箱已经出现在入库明细中，逻辑校验失败';
   err_p_ar_inbound_10 constant varchar2(4000) := '处理“盒”时，未在库存中找到相关信息。也可能是箱的状态不正确';
   err_p_ar_inbound_38 constant varchar2(4000) := '处理“盒”时，“本”数据出现异常';
   err_p_ar_inbound_11 constant varchar2(4000) := '本对应的箱已经出现在入库明细中，逻辑校验失败';
   err_p_ar_inbound_12 constant varchar2(4000) := '本对应的箱已经出现在入库明细中，逻辑校验失败';
   err_p_ar_inbound_13 constant varchar2(4000) := '处理“本”时，未在库存中找到相关信息。也可能是箱的状态不正确';
   err_p_ar_inbound_14 constant varchar2(4000) := '仓库管理员的库存中，没有此方案和批次的库存信息';
   err_p_ar_inbound_15 constant varchar2(4000) := '该销售站未设置此方案对应的销售佣金比例';
   err_p_ar_inbound_16 constant varchar2(4000) := '销售站无账户或相应账户状态不正确';
   err_p_ar_inbound_17 constant varchar2(4000) := '销售站余额不足';


   err_p_institutions_create_1 constant varchar2(4000) := '部门编码不能为空！';
   err_p_institutions_create_2 constant varchar2(4000) := '部门名称不能为空！';
   err_p_institutions_create_3 constant varchar2(4000) := '部门负责人不存在！';
   err_p_institutions_create_4 constant varchar2(4000) := '部门联系电话不能为空！';
   err_p_institutions_create_5 constant varchar2(4000) := '部门编码在系统中已经存在！';
   err_p_institutions_create_6 constant varchar2(4000) := '选择区域已经被其他部门管辖！';

   err_p_institutions_modify_1 constant varchar2(4000) := '部门原编码不能为空！';
   err_p_institutions_modify_2 constant varchar2(4000) := '部门关联其他人员不能修改编码！';

   err_p_outlet_create_1 constant varchar2(4000) := '部门编码不能为空！';
   err_p_outlet_create_2 constant varchar2(4000) := '部门无效！';
   err_p_outlet_create_3 constant varchar2(4000) := '区域编码不能为空！';
   err_p_outlet_create_4 constant varchar2(4000) := '区域无效！';

   err_p_outlet_modify_1 constant varchar2(4000) := '站点编码已存在！';
   err_p_outlet_modify_2 constant varchar2(4000) := '站点编码不符合规范！';
   err_p_outlet_modify_3 constant varchar2(4000) := '站点有缴款业务不能变更编码！';
   err_p_outlet_modify_4 constant varchar2(4000) := '站点有订单业务不能变更编码！';

   err_p_outlet_plan_auth_1 constant varchar2(4000) := '授权方案不能为空！';
   err_p_outlet_plan_auth_2 constant varchar2(4000) := '授权方案代销费率不能超出所属机构代销费率！';

   err_p_org_plan_auth_1 constant varchar2(4000) := '授权方案不能为空！';
   err_p_org_plan_auth_2 constant varchar2(4000) := '授权方案代销费率不能超出1000！';

   err_p_warehouse_create_1 constant varchar2(4000) := '编码不能为空！';
   err_p_warehouse_create_2 constant varchar2(4000) := '编码不能重复！';
   err_p_warehouse_create_3 constant varchar2(4000) := '名称不能为空！';
   err_p_warehouse_create_4 constant varchar2(4000) := '地址不能为空！';
   err_p_warehouse_create_5 constant varchar2(4000) := '负责人不存在！';
   err_p_warehouse_create_6 constant varchar2(4000) := '-已经有管辖仓库！';

   err_p_warehouse_modify_1 constant varchar2(4000) := '编码不存在！';

   err_p_admin_create_1 constant varchar2(4000) := '真实姓名不能为空！';
   err_p_admin_create_2 constant varchar2(4000) := '登录名不能为空！';
   err_p_admin_create_3 constant varchar2(4000) := '登录名已存在！';

   err_p_outlet_topup_1 constant varchar2(100) := '站点编码不能为空！';
   err_p_outlet_topup_2 constant varchar2(100) := '用户不存在或者无效！';
   err_p_outlet_topup_3 constant varchar2(100) := '密码不能为空！';
   err_p_outlet_topup_4 constant varchar2(100) := '密码无效！';

   err_p_institutions_topup_1 constant varchar2(100) := '机构编码不能为空！';
   err_p_institutions_topup_2 constant varchar2(100) := '当前用户无效！';
   err_p_institutions_topup_3 constant varchar2(100) := '当前机构无效！';

   err_p_outlet_withdraw_app_1 constant varchar2(100) := '提现金额不足！';
   err_p_outlet_withdraw_con_1 constant varchar2(100) := '申请单不能为空！';
   err_p_outlet_withdraw_con_2 constant varchar2(100) := '申请单不存在或状态非审批通过！';
   err_p_outlet_withdraw_con_3 constant varchar2(100) := '站点不存在或密码无效！';

   err_p_warehouse_delete_1 constant varchar2(100) := '仓库中有库存物品，不可进行删除！';

   err_p_warehouse_check_step1_1 constant varchar2(100) := '盘点名称不能为空！';
   err_p_warehouse_check_step1_2 constant varchar2(100) := '库房不能为空！';
   err_p_warehouse_check_step1_3 constant varchar2(100) := '盘点人无效！';
   err_p_warehouse_check_step1_4 constant varchar2(100) := '仓库无效或者正在盘点中！';
   err_p_warehouse_check_step1_5 constant varchar2(100) := '仓库无彩票物品，没有必要盘点！';

   err_p_warehouse_check_step2_1 constant varchar2(100) := '盘点单不能为空！';
   err_p_warehouse_check_step2_2 constant varchar2(100) := '盘点单不存在或已完结！';
   err_p_warehouse_check_step2_3 constant varchar2(100) := '扫描信息不能为空！';

   err_p_mm_fund_repay_1 constant varchar2(100) := '市场管理员不能为空！';
   err_p_mm_fund_repay_2 constant varchar2(100) := '市场管理员已经删除或不存在！';
   err_p_mm_fund_repay_3 constant varchar2(100) := '当前操作人不能为空！';
   err_p_mm_fund_repay_4 constant varchar2(100) := '当前操作人已经删除或不存在！';
   err_p_mm_fund_repay_5 constant varchar2(100) := '还款金额无效！';

   err_common_1 constant varchar2(4000) := '数据库操作异常';
   err_common_2 constant varchar2(4000) := '无效的状态值';
   err_common_3 constant varchar2(4000) := '对象不存在';
   err_common_4 constant varchar2(4000) := '参数名称错误';
   err_common_5 constant varchar2(4000) := '无效的参数';
   err_common_6 constant varchar2(4000) := '编码不符合规范';
   err_common_7 constant varchar2(4000) := '编码溢出';
   err_common_8 constant varchar2(4000) := '数据正在被别人处理中';
   err_common_9 constant varchar2(4000) := '不符合删除条件';

   err_p_fund_change_1 constant varchar2(4000) := '账户余额不足';
   err_p_fund_change_2 constant varchar2(4000) := '资金类型不合法';
   err_p_fund_change_3 constant varchar2(4000) := '未发现销售站的账户，或者账户状态不正确';

   err_p_lottery_reward_3 constant varchar2(4000) := '彩票未被销售';
   err_p_lottery_reward_4 constant varchar2(4000) := '彩票已兑奖';
   err_p_lottery_reward_5 constant varchar2(4000) := '系统参数值不正确，请联系管理员，重新设置';
   err_p_lottery_reward_6 constant varchar2(4000) := '该销售站未设置此方案对应的兑奖佣金比例';
   err_p_lottery_reward_7 constant varchar2(4000) := '该销售站未设置此方案对应的兑奖佣金比例';

   err_f_check_import_ticket constant varchar2(4000) := '输入参数错误，应该为1或者2';

   err_common_100 constant varchar2(4000) := '无此人';
   err_common_101 constant varchar2(4000) := '无此仓库';
   err_common_102 constant varchar2(4000) := '无此方案批次';
   err_common_103 constant varchar2(4000) := '输入的彩票对象中，存在自包含的现象';
   err_common_104 constant varchar2(4000) := '更新“即开票”状态时，出现错误';
   err_common_105 constant varchar2(4000) := '操作类型参数错误，应该为1，2，3';
   err_common_106 constant varchar2(4000) := '操作类型参数错误，应该为1，2，3';
   err_common_107 constant varchar2(4000) := '此方案的批次处于非可用状态';
   err_common_108 constant varchar2(4000) := '方案或批次数据为空';
   err_common_109 constant varchar2(4000) := '输入参数中，没有发现彩票对象';

   err_f_check_ticket_include_1 constant varchar2(4000) := '此箱彩票已经被处理';
   err_f_check_ticket_include_2 constant varchar2(4000) := '此盒彩票已经被处理';
   err_f_check_ticket_include_3 constant varchar2(4000) := '此本彩票已经被处理';

   err_p_item_delete_1 constant varchar2(4000) := '物品编码不能为空';
   err_p_item_delete_2 constant varchar2(4000) := '不存在此物品';
   err_p_item_delete_3 constant varchar2(4000) := '该物品当前有库存';

   err_p_withdraw_approve_1 constant varchar2(4000) := '提现编码不能为空';
   err_p_withdraw_approve_2 constant varchar2(4000) := '提现编码不存在或单据状态无效！';
   err_p_withdraw_approve_3 constant varchar2(4000) := '审批结果超出定义范围！';
   err_p_withdraw_approve_4 constant varchar2(4000) := '余额不足！';
   err_p_withdraw_approve_5 constant varchar2(4000) := '销售站资金处理失败！';

   err_p_item_outbound_1 constant varchar2(4000) := '该物品当前无库存';
   err_p_item_outbound_2 constant varchar2(4000) := '该物品在库存不足';

   err_p_item_damage_1 constant varchar2(4000) := '物品编码不能为空';
   err_p_item_damage_2 constant varchar2(4000) := '仓库编码不能为空';
   err_p_item_damage_3 constant varchar2(4000) := '损毁物品数量必须为正数';
   err_p_item_damage_4 constant varchar2(4000) := '损毁登记人不存在';
   err_p_item_damage_5 constant varchar2(4000) := '该物品不存在或已删除';
   err_p_item_damage_6 constant varchar2(4000) := '该仓库不存在或已删除';
   err_p_item_damage_7 constant varchar2(4000) := '该仓库中不存在此物品';
   err_p_item_damage_8 constant varchar2(4000) := '该仓库中此物品的数量小于登记损毁的数量';

   err_p_ar_outbound_10 constant varchar2(4000) := '有彩票已经兑奖，不能退票';
   err_p_ar_outbound_20 constant varchar2(4000) := '对应的箱数据，没有在入库单中找到';
   err_p_ar_outbound_30 constant varchar2(4000) := '对应的盒数据，没有在入库单中找到';
   err_p_ar_outbound_40 constant varchar2(4000) := '对应的本数据，没有在入库单中找到';
   err_p_ar_outbound_50 constant varchar2(4000) := '对应的箱数据已经在入库单中找到，但是状态或者所属站点信息不正确';
   err_p_ar_outbound_60 constant varchar2(4000) := '未查询到待退票的售票记录';
   err_p_ar_outbound_70 constant varchar2(4000) := '超过此管理员允许持有的“最高赊票金额”';

   err_p_ticket_perferm_1   constant varchar2(4000) := '此仓库状态处于盘点或停用状态，不能进行出入库操作';
   err_p_ticket_perferm_3   constant varchar2(4000) := '系统中不存在此批次的彩票方案';
   err_p_ticket_perferm_5   constant varchar2(4000) := '此批次的彩票方案已经停用';
   err_p_ticket_perferm_10  constant varchar2(4000) := '此箱彩票不存在';
   err_p_ticket_perferm_110 constant varchar2(4000) := '此盒彩票不存在';
   err_p_ticket_perferm_120 constant varchar2(4000) := '此“盒”彩票的状态与预期不符，当前状态为';
   err_p_ticket_perferm_130 constant varchar2(4000) := '此“盒”彩票在系统中处于开箱状态，因此不能进行整箱处理';
   err_p_ticket_perferm_140 constant varchar2(4000) := '此“盒”彩票库存信息可能存在错误，请查询以后再进行操作';
   err_p_ticket_perferm_150 constant varchar2(4000) := '处理彩票时，出现数据异常，请联系系统人员';
   err_p_ticket_perferm_160 constant varchar2(4000) := '处理“盒”时，“本”数据出现异常。可能的错误为：1-此盒对应的某些本已经被转移，2-此盒对应的某些本的状态与预期状态不符';
   err_p_ticket_perferm_20  constant varchar2(4000) := '此“箱”彩票的状态与预期不符，当前状态为';
   err_p_ticket_perferm_210 constant varchar2(4000) := '此本彩票不存在';
   err_p_ticket_perferm_220 constant varchar2(4000) := '此“本”彩票的状态与预期不符，当前状态为';
   err_p_ticket_perferm_230 constant varchar2(4000) := '此“本”彩票库存信息可能存在错误，请查询以后再进行操作';
   err_p_ticket_perferm_240 constant varchar2(4000) := '处理彩票时，出现数据异常，请联系系统人员';
   err_p_ticket_perferm_30  constant varchar2(4000) := '此“箱”彩票在系统中处于开箱状态，因此不能进行整箱处理';
   err_p_ticket_perferm_40  constant varchar2(4000) := '此“箱”彩票库存信息可能存在错误，请查询以后再进行操作';
   err_p_ticket_perferm_50  constant varchar2(4000) := '处理彩票时，出现数据异常，请联系系统人员';
   err_p_ticket_perferm_60  constant varchar2(4000) := '处理“箱”时，“盒”数据出现异常。可能的错误为：1-此箱对应的某些盒已经被拆开使用，2-此箱对应的某些盒已经被转移，3-此箱对应的某些盒的状态与预期状态不符';
   err_p_ticket_perferm_70  constant varchar2(4000) := '处理“箱”时，“盒”数据出现异常。可能的错误为：1-此箱对应的某些本已经被转移，2-此箱对应的某些本的状态与预期状态不符';

   err_f_get_sys_param_1    constant varchar2(4000) := '系统参数未被设置，参数编号为：';
end;
