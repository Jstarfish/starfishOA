package cls.pilottery.pos.system.service.impl;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import oracle.jdbc.OracleTypes;
import oracle.sql.ARRAY;
import oracle.sql.ArrayDescriptor;
import oracle.sql.STRUCT;
import oracle.sql.StructDescriptor;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;

import cls.pilottery.common.service.RedisService;
import cls.pilottery.common.utils.DBConnectUtil;
import cls.pilottery.common.utils.DateUtil;
import cls.pilottery.common.utils.LocaleUtil;
import cls.pilottery.common.utils.MD5Util;
import cls.pilottery.packinfo.PackHandleFactory;
import cls.pilottery.packinfo.PackInfo;
import cls.pilottery.pos.common.annotation.PosMethod;
import cls.pilottery.pos.common.annotation.PosService;
import cls.pilottery.pos.common.model.BaseRequest;
import cls.pilottery.pos.common.model.BaseResponse;
import cls.pilottery.pos.common.model.UserToken;
import cls.pilottery.pos.system.dao.OutletsManageDao;
import cls.pilottery.pos.system.model.AddOrderDetail;
import cls.pilottery.pos.system.model.AddOrderRequest;
import cls.pilottery.pos.system.model.BalanceInfo;
import cls.pilottery.pos.system.model.OutletDaliyReportRequest;
import cls.pilottery.pos.system.model.OutletDaliyReportResponse;
import cls.pilottery.pos.system.model.OutletFlowListResponse;
import cls.pilottery.pos.system.model.OutletFlowRequest;
import cls.pilottery.pos.system.model.OutletFundFlow;
import cls.pilottery.pos.system.model.OutletGoodInfo;
import cls.pilottery.pos.system.model.OutletGoodsRecpRequest;
import cls.pilottery.pos.system.model.OutletInfo;
import cls.pilottery.pos.system.model.OutletPopupRequest;
import cls.pilottery.pos.system.model.OutletPopupResponse;
import cls.pilottery.pos.system.model.OutletSalesReocrd;
import cls.pilottery.pos.system.model.OutletWithdrawConRequest;
import cls.pilottery.pos.system.model.OutletWithdrawRequest;
import cls.pilottery.pos.system.model.PayTicketRequest;
import cls.pilottery.pos.system.model.PayTicketResponse;
import cls.pilottery.pos.system.model.SecurityCode;
import cls.pilottery.pos.system.model.WinTicketInfo;
import cls.pilottery.pos.system.model.WithDrawRecordResponse;
import cls.pilottery.pos.system.service.OutletsManageService;
import cls.pilottery.web.outlet.form.DetailsForm;
import cls.pilottery.web.outlet.model.FlowAgency;
import cls.pilottery.web.outlet.service.OutletService;
import cls.pilottery.web.payout.model.PayoutRecord;
import cls.pilottery.web.payout.model.WinInfo;
import cls.pilottery.web.payout.service.PayoutService;
import cls.pilottery.web.sales.dao.OrderDao;
import cls.pilottery.web.sales.entity.PurchaseOrder;
import cls.pilottery.web.sales.entity.PurchaseOrderDetail;
import cls.pilottery.web.sales.model.PlanModel;
import cls.pilottery.web.sales.service.OrderService;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;

@PosService
public class OutletsManageServiceImpl implements OutletsManageService {
	public static Logger log = Logger.getLogger(OutletsManageServiceImpl.class);
	@Autowired
	private RedisService redisService;

	@Autowired
	private OutletService outletService;

	@Autowired
	private PayoutService service;

	@Autowired
	private OrderDao orderDao;
	@Autowired
	private OrderService orderService;
	@Autowired
	private OutletsManageDao outletsManageDao;

	/*
	 * 站点信息查询（020401）
	 */
	@Override
	@PosMethod(code = "020401")
	public BaseResponse getOutletInfo(Object obj) throws Exception {

		BaseRequest bq = (BaseRequest) obj;
		BaseResponse response = new BaseResponse();

		if (bq == null) {
			response.setErrcode(10012);
			log.info("请求参数不合法或为空!");
			return response;
		}
		
		//获取回话信息
		UserToken ut = (UserToken) redisService.getObject(bq.getToken());
		if(ut == null)
		{
			response.setErrcode(10010);
			log.info("Session 信息获取失败!");
			return response;
		}
				
		String code = bq.getParam().toString();
		JSONObject x = JSON.parseObject(code);
		code = x.getString("outletCode");

		// 构造返回信息
		DetailsForm en = outletService.getByCodeAndMM(code,ut.getId());
		if(en == null)
		{
			response.setErrcode(10016);
			log.info("站点已删除或站点未授权!");
			return response;
		}
		
		OutletInfo info = new OutletInfo();
		info.setContact(en.getContactPerson());
		info.setOutletCode(code);
		info.setOutletName(en.getAgencyName());
		info.setPhone(en.getTelephone());
		info.setBalance(en.getBalance());

		response.setResult(info);

		return response;
	}

	/*
	 * 站点资金流水查询（020402）
	 */
	@Override
	@PosMethod(code = "020402")
	public BaseResponse getOutletFundFlow(Object obj) throws Exception {
		BaseRequest bq = (BaseRequest) obj;
		BaseResponse response = new BaseResponse();

		if (bq == null || bq.getParam() == null) {
			response.setErrcode(10012);
			log.info("请求参数不合法或为空!");
			return response;
		}

		OutletFlowRequest rqparam = new OutletFlowRequest();
		rqparam = JSONObject.parseObject(bq.getParam().toString(),
				OutletFlowRequest.class);

		FlowAgency flow = new FlowAgency();
		flow.setAgencyCode(rqparam.getOutletCode());
		flow.setAgencyType((short) 0);
		flow.setAgencyFundFlow(rqparam.getFollow());
		flow.setBeginNum(rqparam.getCount());
		// 构造返回信息
		OutletFlowListResponse respara = new OutletFlowListResponse();
		List<FlowAgency> list = outletService.selectAgencyFlowForPOS(flow);
		if (list != null && list.size() > 0) {
			Map<Integer, String> map = LocaleUtil.getUserLocaleEnum(
					"transFlowType", 1);
			List<OutletFundFlow> rlist = new ArrayList<OutletFundFlow>();
			for (FlowAgency f : list) {
				OutletFundFlow fr = new OutletFundFlow();
				fr.setAmount(f.getChangeAmount());
				fr.setType(map.get((int)f.getFlowType()));
				fr.setTime(DateUtil.getDate(f.getTransTime()));
				respara.setBalance(f.getBalance());
				respara.setCredit(f.getCredit());
				respara.setFollow(f.getMaxFlow());
				respara.setOutletCode(f.getAgencyCode());
				rlist.add(fr);
			}
			respara.setRecordList(rlist);
		} else {
			FlowAgency en = outletService.selectAgencyAccForPOS(rqparam.getOutletCode());
			if (en == null) {
				log.info("Having no matched records.");
				//response.setErrcode(10015);
				//return response;
			} else {
				respara.setBalance(en.getBalance());
				respara.setCredit(en.getCredit());
				respara.setFollow("");
				respara.setOutletCode(en.getAgencyCode());
			}
		}
		response.setResult(respara);

		return response;
	}

	/*
	 * 站点资金日结记录查询（020403）
	 */
	@Override
	@PosMethod(code = "020403")
	public BaseResponse getOutletDailyList(Object obj) throws Exception {
		BaseRequest bq = (BaseRequest)obj;
		BaseResponse response = new BaseResponse();
		OutletDaliyReportRequest req = null;
		OutletDaliyReportResponse res = new OutletDaliyReportResponse();
		
		if(bq != null && bq.getParam() != null){
			req = JSONObject.parseObject(bq.getParam().toString(), OutletDaliyReportRequest.class);
			if(StringUtils.isEmpty(req.getFollow())){
				Calendar cld = Calendar.getInstance(); 
				//cld.add(Calendar.DATE, 1);
				String defaultDate = (new SimpleDateFormat("yyyy-MM-dd")).format(cld.getTime());
				req.setFollow(defaultDate);
			}
			List<OutletSalesReocrd> recordList = outletsManageDao.getOutletDailyList(req);
			res.setSalesList(recordList);
			res.setOutletCode(req.getOutletCode());
			BalanceInfo balance = outletsManageDao.getOutletsBalance(req.getOutletCode());
			if(balance != null){
				res.setBalance(balance.getBalance());
				res.setCredit(balance.getCredit());
			}
			if(recordList != null && recordList.size()>0 ){
				res.setFollow(recordList.get(recordList.size()-1).getDate());
			}
		}
		response.setResult(res);
		return response;
	}

	/*
	 * 站点充值（020404）
	 */
	@Override
	@PosMethod(code = "020404")
	public BaseResponse getOutletTopup(Object obj) throws Exception {
		BaseRequest bq = (BaseRequest) obj;
		BaseResponse response = new BaseResponse();

		if (bq == null) {
			response.setErrcode(10012);
			log.info("请求参数不合法或为空!");
			return response;
		}

		OutletPopupRequest rqparam = new OutletPopupRequest();
		rqparam = JSONObject.parseObject(bq.getParam().toString(),
				OutletPopupRequest.class);
		
		//验证状态
		DetailsForm dd=	outletService.getByCode(rqparam.getOutletCode());
	    if(dd == null || dd.getStatus() != 1)
	    {
	    	response.setErrcode(10020);
			log.info("提现失败：站点状态不正确或站点不存在！");
			return response;
	    }
			    
		UserToken ut = (UserToken) redisService.getObject(bq.getToken());

		FlowAgency flow = new FlowAgency();
		flow.setAgencyCode(rqparam.getOutletCode());
		flow.setPassword(MD5Util.MD5Encode(rqparam.getTransPassword()));
		flow.setAdminId(Integer.parseInt(ut.getId().toString()));
		flow.setAmount(rqparam.getAmount());

		// 构造返回信息
		outletService.forOutletPopup(flow);
		log.debug("p_outlet_topup执行完毕");
		log.debug("Error Code:" + flow.getC_errcode());
		log.debug("Error Message:" + flow.getC_errmsg());
		if (flow.getC_errcode() != 0) {
			response.setErrcode(1);
			response.setErrmesg(flow.getC_errmsg());
			return response;
		}

		OutletPopupResponse info = new OutletPopupResponse();
		info.setBalance(flow.getAfterAmount());
		info.setOutletCode(flow.getAgencyCode());
		//info.setOutletFlow(flow.getAgencyFundFlow());
		info.setOutletName("Outlet Name");
		info.setTopupAmount(flow.getAmount());
		response.setResult(info);

		return response;
	}

	/*
	 * 站点提现记录查询（020405）
	 */
	@Override
	@PosMethod(code = "020405")
	public BaseResponse getCashWithdrawnList(Object obj) throws Exception {
		BaseRequest bq = (BaseRequest) obj;
		BaseResponse response = new BaseResponse();

		Map reqMap = JSONObject
				.parseObject(bq.getParam().toString(), Map.class);
		if (reqMap == null
				|| StringUtils.isEmpty((String) reqMap.get("outletCode"))) {
			response.setErrcode(10012);
			log.info("请求参数不合法或为空!");
			return response;
		}

		String outletCode = (String) reqMap.get("outletCode");
		UserToken ut = (UserToken) redisService.getObject(bq.getToken());

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", ut.getId());
		map.put("outletCode", outletCode);

		BalanceInfo balance = outletsManageDao.getOutletsBalance(outletCode);
		List<WithDrawRecordResponse> wrresList = outletsManageDao.getCashWithdrawnList(map);
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("balance", balance.getBalance());
		resultMap.put("outletCode", outletCode);
		resultMap.put("withdrawnList", wrresList);
		response.setResult(resultMap);
		return response;
	}

	/*
	 * 站点提现申请（020406）
	 */
	@Override
	@PosMethod(code = "020406")
	public BaseResponse addCashWithdrawn(Object obj) throws Exception {
		BaseRequest bq = (BaseRequest) obj;
		BaseResponse response = new BaseResponse();

		if (bq == null) {
			response.setErrcode(10012);
			log.info("请求参数不合法或为空!");
			return response;
		}

		OutletWithdrawRequest rqparam = new OutletWithdrawRequest();
		rqparam = JSONObject.parseObject(bq.getParam().toString(),
				OutletWithdrawRequest.class);
		
		//验证状态
		DetailsForm dd=	outletService.getByCode(rqparam.getOutletCode());
	    if(dd == null || dd.getStatus() != 1)
	    {
	    	response.setErrcode(10020);
			log.info("提现失败：站点状态不正确或站点不存在！");
			return response;
	    }

		UserToken ut = (UserToken) redisService.getObject(bq.getToken());

		FlowAgency flow = new FlowAgency();
		flow.setAgencyCode(rqparam.getOutletCode());
		flow.setAdminId(Integer.parseInt(ut.getId().toString()));
		flow.setAmount(rqparam.getAmount());
		flow.setPassword(MD5Util.MD5Encode(rqparam.getPassword()));

		// 构造返回信息
		outletService.forOutletWithdrawApp(flow);
		log.debug("执行提现申请存储过程：p_outlet_withdraw_app");
		log.debug("return code: " + flow.getC_errcode());
		log.debug("return mesg: " + flow.getC_errmsg());
		if (flow.getC_errcode() != 0){
			log.info("执行提现申请procedure失败");
			response.setErrcode(1);
			response.setErrmesg(flow.getC_errmsg());
			return response;
		}
			
		response.setResult("withdrawnCode:" + flow.getAgencyFundFlow());

		return response;
	}

	/*
	 * 站点提现确认（020407）
	 */
	@Override
	@PosMethod(code = "020407")
	public BaseResponse confirmCashWithdrawn(Object obj) throws Exception {

		BaseRequest bq = (BaseRequest) obj;
		BaseResponse response = new BaseResponse();

		if (bq == null) {
			response.setErrcode(10012);
			log.info("请求参数不合法或为空!");
			return response;
		}

		OutletWithdrawConRequest rqparam = new OutletWithdrawConRequest();
		rqparam = JSONObject.parseObject(bq.getParam().toString(),
				OutletWithdrawConRequest.class);
		
		//验证状态
		DetailsForm dd=	outletService.getByCode(rqparam.getOutletCode());
	    if(dd == null || dd.getStatus() != 1)
	    {
	    	response.setErrcode(10020);
			log.info("提现失败：站点状态不正确或站点不存在！");
			return response;
	    }
			    
		UserToken ut = (UserToken) redisService.getObject(bq.getToken());

		FlowAgency flow = new FlowAgency();
		flow.setAgencyCode(rqparam.getOutletCode());
		flow.setAdminId(Integer.parseInt(ut.getId().toString()));
		flow.setPassword(MD5Util.MD5Encode(rqparam.getPassword()));
		flow.setAgencyFundFlow(rqparam.getWithdrawnCode());

		// 构造返回信息
		outletService.forOutletWithdrawCon(flow);
		if (flow.getC_errcode() != 0) {
			response.setErrcode(1);
			response.setErrmesg(flow.getC_errmsg());
			log.error("020407执行失败,失败原因：" + flow.getC_errmsg());
		}
		return response;
	}

	/*
	 * 站点入库（020408）
	 */
	@Override
	@PosMethod(code = "020408")
	public BaseResponse addOutletGoodsReceipts(Object obj) throws Exception {

		BaseResponse response = new BaseResponse();
		BaseRequest bq = (BaseRequest) obj;
		UserToken ut = (UserToken) redisService.getObject(bq.getToken());

		// 获取参数
		OutletGoodsRecpRequest en = new OutletGoodsRecpRequest();
		en = JSONObject.parseObject(bq.getParam().toString(),
				OutletGoodsRecpRequest.class);

		if (en == null || en.getGoodsTagList() == null
				|| en.getGoodsTagList().size() <= 0) {
			response.setErrcode(10012);
			log.info("站点入库失败，请求参数不合法！");
			return response;
		}
		
		
		String pass = MD5Util.MD5Encode(en.getPassword());
	    DetailsForm dd=	outletService.getByCode(en.getOutletCode());
	    if(dd == null || dd.getPass() == null ||(dd.getPass().equals(pass)==false))
	    {
	    	response.setErrcode(10018);
			log.info("站点入库失败，密码不正确！");
			return response;
	    }
	   
	    //验证状态
	    if(dd == null || dd.getStatus() != 1)
	    {
	    	response.setErrcode(10020);
			log.info("提现失败：站点状态不正确或站点不存在！");
			return response;
	    }

		int len = en.getGoodsTagList().size();

		// 先解析完后入库，是为了减少连接占用时间代码；好判断长度
		Connection conn = null;
		CallableStatement stmt = null;
		int resultCode = 0;
		String resultMesg = "";
		try {
			conn = DBConnectUtil.getConnection();
			conn.setAutoCommit(false);
			StructDescriptor sd = new StructDescriptor("TYPE_LOTTERY_INFO",
					conn);
			STRUCT[] result = new STRUCT[len];
			for (int index = 0; index < len; index++) {
				OutletGoodInfo pi = en.getGoodsTagList().get(index);
				PackInfo gpr = PackHandleFactory.getPackInfo(pi.getGoodsTag());
				if(gpr == null || gpr.getPackUnit().ordinal()>2)
				{
					response.setErrcode(10019);
					log.info("站点退货失败，标签不符合规范："+pi.getGoodsTag());
					return response;
				}
				Object[] o = new Object[9];
				o[0] = gpr.getPlanCode(); // 方案
				o[1] = gpr.getBatchCode(); // 批次
				o[2] = gpr.getPackUnit().ordinal() + 1; // 型号1-箱号、2-盒号、3-本号
				switch (gpr.getPackUnit()) {
				case Trunck:
					o[3] = gpr.getPackUnitCode();
					o[4] = "";
					o[5] = "";
					o[6] = gpr.getFirstPkgCode();
					o[7] = "";
					break;
				case Box:
					o[3] = "";
					o[4] = gpr.getPackUnitCode();
					o[5] = "";
					o[6] = gpr.getFirstPkgCode();
					o[7] = "";
					break;
				case pkg:
					o[3] = "";
					o[4] = "";
					o[5] = "";
					o[6] = gpr.getPackUnitCode();
					o[7] = "";
					break;
				default:
					break;
				}
				o[8] = 0;

				result[index] = new STRUCT(sd, conn, o);
			}
			ArrayDescriptor orc_table = ArrayDescriptor.createDescriptor(
					"TYPE_LOTTERY_LIST", conn);
			ARRAY oracle_array = new ARRAY(orc_table, conn, result);

			stmt = conn.prepareCall("{ call p_ar_inbound(?,?,?,?,?) }");
			stmt.setObject(1, en.getOutletCode());// 收货销售站
			stmt.setObject(2, ut.getId());
			stmt.setObject(3, oracle_array);
			stmt.registerOutParameter(4, OracleTypes.NUMBER);
			stmt.registerOutParameter(5, OracleTypes.VARCHAR);
			stmt.execute();

			resultCode = stmt.getInt(4);
			resultMesg = stmt.getString(5);

			log.debug("方法020408的p_ar_inbound执行完成。");
			log.debug("return code: " + resultCode);
			log.debug("return mesg: " + resultMesg);

			if (resultCode != 0) {
				response.setErrcode(1);
				response.setErrmesg(resultMesg);
				log.info("p_ar_inbound执行失败，错误信息：" + resultMesg);
			}
			Map<String,Object> map = new HashMap<String,Object>();
			long balance = 0;
			//入库成功返回余额
			DetailsForm ol = outletService.getByCodeAndMM(en.getOutletCode(),ut.getId());
			if(ol != null)
			{
				balance = ol.getBalance();
			}
			map.put("balance", balance);
			response.setResult(map);

		} catch (Exception e) {
			response.setErrcode(10500);
			log.error("020408执行出现异常！", e);
		} finally {
			DBConnectUtil.close(stmt);
			DBConnectUtil.close(conn);
		}

		return response;
	}

	/*
	 * 站点增加新订单（020409）
	 */
	@Override
	@PosMethod(code = "020409")
	public BaseResponse addPurchaseOrder(Object obj) throws Exception {
		BaseRequest bq = (BaseRequest) obj;
		BaseResponse response = new BaseResponse();

		AddOrderRequest adreq = JSONObject.parseObject(
				bq.getParam().toString(), AddOrderRequest.class);
		
		//验证状态
		DetailsForm dd=	outletService.getByCode(adreq.getOutletCode());
	    if(dd == null || dd.getStatus() != 1)
	    {
	    	response.setErrcode(10020);
			log.info("提现失败：站点状态不正确或站点不存在！");
			return response;
	    }
			    
		UserToken ut = (UserToken) redisService.getObject(bq.getToken());
		String orderSeq = orderDao.getOrderSeq();

		List<PurchaseOrderDetail> detailList = new ArrayList<PurchaseOrderDetail>();
		List<PlanModel> planList = orderDao.getPlanList();
		int totalTickets = 0;
		long totalAmount = 0;
		for (AddOrderDetail aoDetail : adreq.getGoodsTagList()) {
			if (aoDetail != null && aoDetail.getTickets() > 0) {
				PurchaseOrderDetail detail = new PurchaseOrderDetail();
				detail.setTickets(aoDetail.getTickets());
				detail.setPlanCode(aoDetail.getGoodsTag());
				for (PlanModel plan : planList) {
					if (plan.getPlanCode().equals(aoDetail.getGoodsTag())) {
						detail.setAmount((long)aoDetail.getTickets()
								* plan.getTicketAmount());
						detail.setPackages(aoDetail.getTickets()
								/ plan.getPackTickets());
					}
				}
				totalTickets += detail.getTickets();
				totalAmount += detail.getAmount();
				detailList.add(detail);
			}
		}

		PurchaseOrder order = new PurchaseOrder();
		order.setOrderNo(orderSeq);
		order.setApplyAdmin(ut.getId().shortValue());
		order.setApplyAgency(adreq.getOutletCode());
		order.setApplyAmount(totalAmount);
		order.setApplyTickets(totalTickets);
		order.setApplyContact("");
		order.setRemark("Submit by Pos Terminal");
		order.setOrderDetail(detailList);

		orderService.savePurchaseOrder(order);

		Map map = new HashMap();
		map.put("orderCode", orderSeq);
		response.setResult(map);
		return response;
	}

	/*
	 * 站点退货（020410）
	 */
	@Override
	@PosMethod(code = "020410")
	public BaseResponse returnGoods(Object obj) throws Exception {

		BaseResponse response = new BaseResponse();
		BaseRequest bq = (BaseRequest) obj;
		UserToken ut = (UserToken) redisService.getObject(bq.getToken());

		// 获取参数
		OutletGoodsRecpRequest en = new OutletGoodsRecpRequest();
		en = JSONObject.parseObject(bq.getParam().toString(),
				OutletGoodsRecpRequest.class);
		//验证状态
		DetailsForm dd=	outletService.getByCode(en.getOutletCode());
	    if(dd == null || dd.getStatus() != 1)
	    {
	    	response.setErrcode(10020);
			log.info("提现失败：站点状态不正确或站点不存在！");
			return response;
	    }
			    
		if (en == null || en.getGoodsTagList() == null
				|| en.getGoodsTagList().size() <= 0) {
			response.setErrcode(10012);
			log.info("站点退货失败，请求参数不合法！");
			return response;
		}

		int len = en.getGoodsTagList().size();

		// 先解析完后入库，是为了减少连接占用时间代码；好判断长度
		Connection conn = null;
		CallableStatement stmt = null;
		int resultCode = 0;
		String resultMesg = "";
		try {
			conn = DBConnectUtil.getConnection();
			conn.setAutoCommit(false);
			StructDescriptor sd = new StructDescriptor("TYPE_LOTTERY_INFO",
					conn);
			STRUCT[] result = new STRUCT[len];
			for (int index = 0; index < len; index++) {
				OutletGoodInfo pi = en.getGoodsTagList().get(index);
				PackInfo gpr = PackHandleFactory.getPackInfo(pi.getGoodsTag());
				if(gpr == null || gpr.getPackUnit().ordinal()>2)
				{
					response.setErrcode(10019);
					log.info("站点退货失败，标签不符合规范："+pi.getGoodsTag());
					return response;
				}

				Object[] o = new Object[9];
				o[0] = gpr.getPlanCode(); // 方案
				o[1] = gpr.getBatchCode(); // 批次
				o[2] = gpr.getPackUnit().ordinal() + 1; // 型号1-箱号、2-盒号、3-本号
				switch (gpr.getPackUnit()) {
				case Trunck:
					o[3] = gpr.getPackUnitCode();
					o[4] = "";
					o[5] = "";
					o[6] = gpr.getFirstPkgCode();
					o[7] = "";
					break;
				case Box:
					o[3] = "";
					o[4] = gpr.getPackUnitCode();
					o[5] = "";
					o[6] = gpr.getFirstPkgCode();
					o[7] = "";
					break;
				case pkg:
					o[3] = "";
					o[4] = "";
					o[5] = "";
					o[6] = gpr.getPackUnitCode();
					o[7] = "";
					break;
				default:
					break;
				}
				o[8] = 0;

				result[index] = new STRUCT(sd, conn, o);
			}
			ArrayDescriptor orc_table = ArrayDescriptor.createDescriptor(
					"TYPE_LOTTERY_LIST", conn);
			ARRAY oracle_array = new ARRAY(orc_table, conn, result);

			stmt = conn.prepareCall("{ call p_ar_outbound(?,?,?,?,?) }");
			stmt.setObject(1, en.getOutletCode());// 收货销售站
			stmt.setObject(2, ut.getId());
			stmt.setObject(3, oracle_array);
			stmt.registerOutParameter(4, OracleTypes.NUMBER);
			stmt.registerOutParameter(5, OracleTypes.VARCHAR);
			stmt.execute();

			resultCode = stmt.getInt(4);
			resultMesg = stmt.getString(5);

			log.debug("方法020410的p_ar_outbound执行完成。");
			log.debug("return code: " + resultCode);
			log.debug("return mesg: " + resultMesg);

			if (resultCode != 0) {
				response.setErrcode(1);
				response.setErrmesg(resultMesg);
				log.info("p_ar_outbound执行失败，错误信息：" + resultMesg);
			}
			
			Map<String,Object> map = new HashMap<String,Object>();
			long balance = 0;
			//入库成功返回余额
			DetailsForm ol = outletService.getByCodeAndMM(en.getOutletCode(),ut.getId());
			if(ol != null)
			{
				balance = ol.getBalance();
			}
			map.put("balance", balance);
			response.setResult(map);
			

		} catch (Exception e) {
			response.setErrcode(10500);
			log.error("020410执行出现异常！", e);
		} finally {
			DBConnectUtil.close(stmt);
			DBConnectUtil.close(conn);
		}

		return response;
	}

	/*
	 * 站点兑奖（020411）
	 */
	@Override
	@PosMethod(code = "020411")
	public BaseResponse payout(Object obj) throws Exception {

		BaseResponse result = new BaseResponse();
		PayTicketResponse ps = new PayTicketResponse();

		try {
			BaseRequest bq = (BaseRequest) obj;
			UserToken ut = (UserToken) redisService.getObject(bq.getToken());

			// 获取参数
			PayTicketRequest en = new PayTicketRequest();
			en = JSONObject.parseObject(bq.getParam().toString(),
					PayTicketRequest.class);
			
			//验证状态
			DetailsForm dd=	outletService.getByCode(en.getOutletCode());
		    if(dd == null || dd.getStatus() != 1)
		    {
		    	result.setErrcode(10020);
				log.info("提现失败：站点状态不正确或站点不存在！");
				return result;
		    }
		    
			if (en == null || en.getSecurityCodeList() == null
					|| en.getSecurityCodeList().size() <= 0) {
				result.setErrcode(10012);
				log.info("站点兑奖失败，请求参数不合法！");
				return result;
			}

			// 标签校验
			List<SecurityCode> sclist = en.getSecurityCodeList();
			for(SecurityCode sc : sclist){
				String str= sc.getSecurityCode();
				PackInfo pix = PackHandleFactory.getPackInfo(str);
				if (pix == null) {
					result.setErrcode(10014);
					result.setErrmesg("标签不合法:" + str);
					log.info("标签不合法，标签为：" + str);
					return result;
				}
			}

			long userId = ut.getId();
			ps.setOutletCode(en.getOutletCode());

			List<WinTicketInfo> glist = new ArrayList<WinTicketInfo>();

			// 用于构造兑奖返回错误列表,部分成功
			StringBuilder sb = new StringBuilder();
			
			//枚举
			Map<Integer, String> mpStatus=LocaleUtil.getUserLocaleEnum("ticketPayoutStatus", 1);
			
			for(SecurityCode sc : sclist){
				String str= sc.getSecurityCode();
				PackInfo pi = PackHandleFactory.getPackInfo(str);
				if (pi == null) {
					continue;
				}
				
				//先查询--paylevel =1 站点
				WinInfo w = new WinInfo(pi.getPlanCode(),pi.getBatchCode(),pi.getFirstPkgCode(),pi.getSafetyCode()
						+ pi.getPaySign(),1);
				service.payoutQuery(w);
				
				if(w.getC_errcode() != 0)
				{
					log.error("兑奖查询执行失败！错误信息："+w.getC_errmsg());
					if (sb.length() <= 0)
						sb.append("ticket:" + pi.getPackUnitCode() + ","
								+ w.getC_errmsg());
					else
						sb.append(";ticket:" + pi.getPackUnitCode() + ","
								+ w.getC_errmsg());
					continue;
				}
				
				//分类型处理，0中奖 1大奖 2 未中奖 3 已兑奖
				
				long paymoney = 0;
				WinTicketInfo wt = null;
				String ticketStatus = mpStatus.get(w.getWinResult());
				switch (w.getWinResult()) {
				case 1://中大奖
					wt = new WinTicketInfo(pi.getFullTicketCode(), ticketStatus, "*");
					break;
				case 2://未中奖
					wt = new WinTicketInfo(pi.getFullTicketCode(), ticketStatus, "0");
					break;
				case 3://已兑奖
					wt = new WinTicketInfo(pi.getFullTicketCode(), ticketStatus, "-");
					break;
				case 0://已中奖
					
					try {
						PayoutRecord record = new PayoutRecord(pi.getSafetyCode()
								+ pi.getPaySign(), 3, pi.getPlanCode(),
								pi.getBatchCode(), pi.getFirstPkgCode(),
								pi.getPackUnitCode(), userId, en.getOutletCode());
						service.payout(record);
						log.debug("方法020411的p_lottery_reward执行完成。");
						log.debug("return code: " + record.getC_errcode());
						log.debug("return mesg: " + record.getC_errmsg());
						if (record.getC_errcode() == 0)
							paymoney = record.getAmount();
						else{
							log.error("兑奖存储过程执行失败！错误信息："+record.getC_errmsg());
							throw new Exception(record.getC_errmsg());
						}

					} catch (Exception e) {
						log.info("payout obj:" + pi.toString());
						log.error("payout:" + e.getMessage(),e);
						if (sb.length() <= 0)
							sb.append("ticket:" + pi.getPackUnitCode() + ","
									+ e.getMessage());
						else
							sb.append(";ticket:" + pi.getPackUnitCode() + ","
									+ e.getMessage());
					}

					wt = new WinTicketInfo(pi.getFullTicketCode(), ticketStatus, String.valueOf(paymoney));
					
					break;
					
				default://通常是无效票					
					wt = new WinTicketInfo(pi.getFullTicketCode(), ticketStatus, "-");
					break;
				}
								
				glist.add(wt);
				ps.setWinAmount(paymoney + ps.getWinAmount());
			}
			ps.setWinningList(glist);
			if (sb.length() > 0)
				result.setErrmesg(sb.toString());

		} catch (Exception e) {
			log.error("020411执行失败！",e);
			result.setErrcode(10500);
			result.setErrmesg(e.getMessage());
		}

		result.setResult(ps);
		return result;

	}

}