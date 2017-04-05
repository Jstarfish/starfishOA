package cls.pilottery.pos.system.service.impl;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
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

import cls.pilottery.common.EnumConfigEN;
import cls.pilottery.common.service.RedisService;
import cls.pilottery.common.utils.DBConnectUtil;
import cls.pilottery.packinfo.EunmPackUnit;
import cls.pilottery.packinfo.PackHandleFactory;
import cls.pilottery.packinfo.PackInfo;
import cls.pilottery.pos.common.annotation.PosMethod;
import cls.pilottery.pos.common.annotation.PosService;
import cls.pilottery.pos.common.model.BaseRequest;
import cls.pilottery.pos.common.model.BaseResponse;
import cls.pilottery.pos.common.model.UserToken;
import cls.pilottery.pos.system.dao.OrderManageDao;
import cls.pilottery.pos.system.model.AddDeliveryDetail;
import cls.pilottery.pos.system.model.AddDeliveryRequest;
import cls.pilottery.pos.system.model.AddDeliveryResponse;
import cls.pilottery.pos.system.model.DeliveryOrderRequest;
import cls.pilottery.pos.system.model.DeliveryOrderResponse;
import cls.pilottery.pos.system.model.DoDetailRequest;
import cls.pilottery.pos.system.model.DoDetailResponse;
import cls.pilottery.pos.system.model.MktFundFlowDetail;
import cls.pilottery.pos.system.model.MktFundFlowRequest;
import cls.pilottery.pos.system.model.MktFundFlowResponse;
import cls.pilottery.pos.system.model.MktInventoryDetail;
import cls.pilottery.pos.system.model.MktInventoryResponse;
import cls.pilottery.pos.system.model.PosDeliveryOrder;
import cls.pilottery.pos.system.model.PurchaseOrderRequest;
import cls.pilottery.pos.system.model.PurchaseOrderResponse;
import cls.pilottery.pos.system.model.mm.MMCapitalDaliy020508Req;
import cls.pilottery.pos.system.model.mm.MMCapitalDaliy020508Res;
import cls.pilottery.pos.system.model.mm.MMDealRecordSmry020502Req;
import cls.pilottery.pos.system.model.mm.MMDealRecordSmry020502Res;
import cls.pilottery.pos.system.model.mm.MMInventoryCheck020507Req;
import cls.pilottery.pos.system.model.mm.MMInventoryCheck020507Res;
import cls.pilottery.pos.system.model.mm.MMInventoryCheckTag020507Req;
import cls.pilottery.pos.system.model.mm.MMInventoryCheckTag020507Res;
import cls.pilottery.pos.system.model.mm.MMInventoryDaliy020501Req;
import cls.pilottery.pos.system.model.mm.MMInventoryDaliy020501Res;
import cls.pilottery.pos.system.model.mm.MMLogistics020506Res;
import cls.pilottery.pos.system.model.mm.MMPayoutDetail020504Res;
import cls.pilottery.pos.system.model.mm.MMReturnDetail020505Res;
import cls.pilottery.pos.system.model.mm.MMSalesDetail020503Res;
import cls.pilottery.pos.system.model.mm.PlanList020503Res;
import cls.pilottery.pos.system.model.mm.PlanList020505Res;
import cls.pilottery.pos.system.model.mm.PrizeLevelList020504Res;
import cls.pilottery.pos.system.model.mm.TagList020503Res;
import cls.pilottery.pos.system.model.mm.TagList020504Res;
import cls.pilottery.pos.system.model.mm.TagList020505Res;
import cls.pilottery.pos.system.service.OrderManageService;
import cls.pilottery.web.logistics.form.LogisticsForm;
import cls.pilottery.web.logistics.model.LogisticsList;
import cls.pilottery.web.logistics.model.LogisticsResult;
import cls.pilottery.web.logistics.model.PayoutModel;
import cls.pilottery.web.logistics.service.LogisticsService;
import cls.pilottery.web.marketManager.entity.ReturnDeliveryDetail;
import cls.pilottery.web.marketManager.entity.ReturnDeliveryOrder;
import cls.pilottery.web.marketManager.service.ReturnDeliveryService;
import cls.pilottery.web.sales.entity.DeliveryOrder;
import cls.pilottery.web.sales.entity.DeliveryOrderDetail;
import cls.pilottery.web.sales.entity.DeliveryOrderRelation;
import cls.pilottery.web.sales.model.PlanModel;
import cls.pilottery.web.sales.service.DeliveryService;
import cls.pilottery.web.sales.service.OrderService;

import com.alibaba.fastjson.JSONObject;

@PosService
public class OrderManageServiceImpl implements OrderManageService {
	public static Logger log = Logger.getLogger(OrderManageServiceImpl.class);
	@Autowired
	private OrderManageDao orderManageDao;
	@Autowired
	DeliveryService deliveryService;
	@Autowired
	private RedisService redisService;
	@Autowired
	private OrderService orderService;
	@Autowired
	private ReturnDeliveryService returnDeliveryService;
	@Autowired
	private LogisticsService logisticsService;
	
	/*
	 * 出货单列表查询（020101）
	 */
	@Override
	@PosMethod(code="020101")
	public BaseResponse getDeliveryOrderList(Object obj) throws Exception {
		BaseRequest bq = (BaseRequest)obj;
		DeliveryOrderRequest dor = null;
		
		if(bq != null && bq.getParam() != null){
			dor = JSONObject.parseObject(bq.getParam().toString(), DeliveryOrderRequest.class);
		}
		
		BaseResponse response = new BaseResponse();
		UserToken ut = (UserToken)redisService.getObject(bq.getToken());
		
		DeliveryOrderResponse dores = new DeliveryOrderResponse();
		
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("userId", ut.getId());
		map.put("lastId", dor.getFollow());
		map.put("pageCount", dor.getCount());
		
		List<PosDeliveryOrder> list = orderManageDao.getPosDeliveryList(map);
		if(list!=null && list.size()>0){
			dores.setDeliveryList(list);
			dores.setFollow(list.get(list.size()-1).getDeliveryOrder());
		}
		response.setResult(dores);
		return response;
	}

	/*
	 * 出货单详情查询（020102）
	 */
	@Override
	@PosMethod(code="020102")
	public BaseResponse getDeliveryOrderDetail(Object obj) throws Exception {
		BaseRequest request = (BaseRequest)obj;
		BaseResponse response = new BaseResponse();
		DoDetailResponse dores = new DoDetailResponse();
		
		//BeanUtils.copyProperties(doreq, request.getParam());
		DoDetailRequest doreq = JSONObject.parseObject(request.getParam().toString(), DoDetailRequest.class);
		String doNo = doreq.getDeliveryOrder();
		DeliveryOrder order = orderManageDao.getPosDeliveryDetail(doNo);
		
		if(order!=null){
			dores.setDeliveryOrder(order.getDoNo());
			dores.setStatus(order.getStatusValue());
			List<DeliveryOrderDetail> ddlist = order.getDeliveryDetail();
			dores.setObjectValues(ddlist);
		}
		response.setResult(dores);
		return response;
	}

	/*
	 * 生成出货单（020103）
	 */
	@Override
	@PosMethod(code="020103")
	public BaseResponse addDeliveryOrder(Object obj) throws Exception {
		BaseRequest request = (BaseRequest)obj;
		BaseResponse response = new BaseResponse();
		
		//BeanUtils.copyProperties(doreq, request.getParam());
		AddDeliveryRequest adreq = JSONObject.parseObject(request.getParam().toString(), AddDeliveryRequest.class);
		if(adreq != null && adreq.getPlansList()!=null){
			String doNo = deliveryService.getDeliveryOrderSeq();
			//当前可用的方案
			List<PlanModel> planList = orderService.getPlanList();
			int totalTickets = 0;
			long totalAmount = 0;
			List<DeliveryOrderDetail> detailList = new ArrayList<DeliveryOrderDetail>();
			for(AddDeliveryDetail addetail : adreq.getPlansList()){
				if(addetail!=null && addetail.getTickets()>0){
					DeliveryOrderDetail detail = new DeliveryOrderDetail();
					detail.setDoNo(doNo);
					detail.setTickets(addetail.getTickets());
					detail.setPlanCode(addetail.getPlanCode());
					for(PlanModel plan : planList){
						if(plan.getPlanCode().equals(addetail.getPlanCode())){
							if(addetail.getTickets()%plan.getPackTickets() != 0){
								log.info("申请的出货单数量不符合规范：["+addetail.getPlanCode()+" : "+addetail.getTickets()+"]");
								response.setErrcode(10021);
								return response;
							}
							detail.setAmount((long)addetail.getTickets()*plan.getTicketAmount());
							detail.setPackages(addetail.getTickets()/plan.getPackTickets());
						}
					}
					totalTickets += detail.getTickets();
					totalAmount += detail.getAmount();
					detailList.add(detail);
				}
			}
			
			if(totalTickets == 0){
				response.setErrcode(10013);
			}else{
			
			 List<DeliveryOrderRelation> relationList = new ArrayList<DeliveryOrderRelation>();
			 for(String orderNo : adreq.getOrderList()){
				 if(StringUtils.isNotEmpty(orderNo)){
					 DeliveryOrderRelation relation = new DeliveryOrderRelation();
					 relation.setDoNo(doNo);
					 relation.setOrderNo(orderNo);
					 relationList.add(relation);
				 }
			 }
			
			 UserToken ut = (UserToken)redisService.getObject(request.getToken());
			 DeliveryOrder order = new DeliveryOrder();
			 order.setDoNo(doNo);
			 order.setApplyAdmin(ut.getId().shortValue());
			 order.setTotalAmount(totalAmount);
			 order.setTotalTickets((long)totalTickets);
			 order.setRemark("Submit by Pos Terminal");
			 order.setDeliveryDetail(detailList);
			 order.setDoRelation(relationList);
			 
			 int flag = deliveryService.saveDeliveryOrder(order);
			 if(flag == -1){
				 response.setErrcode(10017);
				 log.info("生成出货单失败：用户："+ut.getLoginId()+" 赊票金额不足");
				 return response;
			 }
			 
			 AddDeliveryResponse res = new AddDeliveryResponse();
			 res.setDeliveryOrder(doNo);
			 res.setAmount(totalAmount);
			 res.setTickets(totalTickets);
			 res.setStatus("Submitted");
			 res.setTime("");
			 response.setResult(res);
			}
		}else{
			response.setErrcode(10012);
		}
		
		return response;
	}
	
	/*
	 * 订单列表查询
	 */
	@Override
	@PosMethod(code="020104")
	public BaseResponse getPurchaseOrderList(Object obj) throws Exception {
		BaseRequest bq = (BaseRequest)obj;
		PurchaseOrderRequest poreq = null;
		
		if(bq != null && bq.getParam() != null){
			poreq = JSONObject.parseObject(bq.getParam().toString(), PurchaseOrderRequest.class);
		}
		
		BaseResponse response = new BaseResponse();
		UserToken ut = null;
		Map<String,Object> map = new HashMap<String,Object>();
		if(StringUtils.isEmpty(poreq.getOutletCode())){
			ut = (UserToken)redisService.getObject(bq.getToken());
			map.put("userId", ut.getId());
		}else{
			map.put("outletCode", poreq.getOutletCode());
		}
		
		map.put("status", poreq.getStatus());
		map.put("lastId", poreq.getFollow());
		map.put("pageCount", poreq.getCount());
		
		List<PurchaseOrderResponse> list = orderManageDao.getPosPurchaseOrderList(map);
		Map<String,Object> resultMap = new HashMap<String,Object>();
		resultMap.put("orderList", list);
		if(list!=null && list.size()>0){
			resultMap.put("follow", list.get(list.size()-1).getOrderNo());
		}else{
			resultMap.put("follow","");
		}
		response.setResult(resultMap);
		
		return response;
	}
	
	/*
	 * 资金流水查询（020204）
	 */
	@Override
	@PosMethod(code="020204")
	public BaseResponse getFundFlow(Object obj) throws Exception {
		BaseRequest bq = (BaseRequest)obj;
		
		MktFundFlowRequest request = JSONObject.parseObject(bq.getParam().toString(), MktFundFlowRequest.class);
		
		BaseResponse response = new BaseResponse();
		UserToken ut = (UserToken)redisService.getObject(bq.getToken());
		
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("userId", ut.getId());
		map.put("lastId", request.getFollow());
		map.put("pageCount", request.getCount());
		
		MktFundFlowResponse mffres = orderManageDao.getMktFundBalance(ut.getId().intValue());
		if(mffres != null){
			List<MktFundFlowDetail> rlist = orderManageDao.getMktFundFlow(map);
			if(rlist != null && rlist.size()>0){
				mffres.setRecordList(rlist);
				mffres.setFollow(rlist.get(rlist.size()-1).getAccNo());
			}
		}
		response.setResult(mffres);
		return response;
	}

	/*
	 * 在手库存查询（020305）
	 */
	@Override
	@PosMethod(code="020305")
	public BaseResponse getInventoryList(Object obj) throws Exception {
		BaseRequest bq = (BaseRequest)obj;
		
		BaseResponse response = new BaseResponse();
		UserToken ut = (UserToken)redisService.getObject(bq.getToken());
		
		List<MktInventoryDetail> list = orderManageDao.getInventoryList(ut.getId());
		MktInventoryResponse mires = new MktInventoryResponse();
		mires.setDetailList(list);
		response.setResult(mires);
		
		return response;
	}
	
	/*
	 * 申请还货单（020306）
	 */
	@Override
	@PosMethod(code="020306")
	public BaseResponse applyReturnDelivery(Object obj) throws Exception {
		BaseRequest bq = (BaseRequest)obj;
		BaseResponse response = new BaseResponse();
		
		UserToken ut = (UserToken)redisService.getObject(bq.getToken());
		List<MktInventoryDetail> list = orderManageDao.getInventoryList(ut.getId());
		String returnNo = null;
		if(list != null && list.size() > 0){
			List<PlanModel> planList = orderService.getPlanList();
			ReturnDeliveryOrder rdorder = new ReturnDeliveryOrder();
			List<ReturnDeliveryDetail> detailList = new ArrayList<ReturnDeliveryDetail>();
			//String returnNo = returnDeliveryDao.getReturnDeliverySeq();
			//rdorder.setReturnNo(returnNo);
			int totalTickets = 0;
			long totalAmount = 0;
			for(MktInventoryDetail detail : list){
				ReturnDeliveryDetail rdDetail = new ReturnDeliveryDetail();
				rdDetail.setPlanCode(detail.getPlanCode());
				rdDetail.setAmount(detail.getAmount());
				rdDetail.setTickets(detail.getTickets());
				//rdDetail.setReturnNo(returnNo);
				for(PlanModel plan : planList){
					if(detail.getPlanCode().equals(plan.getPlanCode())){
						rdDetail.setPackages(detail.getTickets()/plan.getPackTickets());
					}
				}
				detailList.add(rdDetail);
				totalTickets += detail.getTickets();
				totalAmount += detail.getAmount();
				//returnDeliveryDao.saveReturnDeliveryDetail(rdDetail);
			}
			rdorder.setRdDetail(detailList);
			rdorder.setMarketManagerAdmin(ut.getId().intValue());
			rdorder.setApplyAmount(totalAmount);
			rdorder.setApplyTickets(totalTickets);
			
			/*int directAmount = returnDeliveryDao.getDirectAmount();
			rdorder.setDirectAmount(directAmount);
			if(rdorder.getApplyAmount() <= directAmount){
				returnDeliveryDao.saveReturnDeliveryDirect(rdorder);
			}else{
				returnDeliveryDao.saveReturnDelivery(rdorder);
			}*/
			if(totalTickets > 0){
				returnNo = returnDeliveryService.saveReturnDelivery(rdorder);
			}
		}
		
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("returnNo", returnNo);
		response.setResult(map);
		
		return response;
	}

	/*
	 * 市场管理员库存日结查询
	 */
	@Override
	@PosMethod(code="020501")
	public BaseResponse getMMInventoryDaliyList(Object reqParam) throws Exception {
		BaseRequest bq = (BaseRequest)reqParam;
		BaseResponse response = new BaseResponse();
		MMInventoryDaliy020501Req req = null;
		if(bq != null && bq.getParam() != null){
			req = JSONObject.parseObject(bq.getParam().toString(), MMInventoryDaliy020501Req.class);
		}
		UserToken ut = (UserToken)redisService.getObject(bq.getToken());
		Map<String, Object> paraMap = new HashMap<String,Object>();
		paraMap.put("count", req.getCount());
		paraMap.put("follow", req.getFollow());
		paraMap.put("userId", ut.getId());
		
		Map<String,Object> resultMap = new HashMap<String,Object>();
		List<MMInventoryDaliy020501Res> list = orderManageDao.getMMInventoryDaliyList(paraMap);
		String follow = null;
		if(list != null && list.size() > 0){
			follow = list.get(list.size()-1).getCalcDate();
		}
		resultMap.put("follow", follow);
		resultMap.put("inventoryList", list);
		
		response.setResult(resultMap);
		return response;
	}
	
	/*
	 * 市场管理员交易记录汇总查询
	 */
	@Override
	@PosMethod(code="020502")
	public BaseResponse getMMTransRecordSummary(Object reqParam) throws Exception {
		BaseRequest bq = (BaseRequest)reqParam;
		BaseResponse response = new BaseResponse();
		MMDealRecordSmry020502Req req = null;
		if(bq != null && bq.getParam() != null){
			req = JSONObject.parseObject(bq.getParam().toString(), MMDealRecordSmry020502Req.class);
		}
		UserToken ut = (UserToken)redisService.getObject(bq.getToken());
		Map<String, Object> paraMap = new HashMap<String,Object>();
		paraMap.put("count", req.getCount());
		paraMap.put("follow", req.getFollow());
		paraMap.put("userId", ut.getId());
		
		Map<String,Object> resultMap = new HashMap<String,Object>();
		List<MMDealRecordSmry020502Res> list = orderManageDao.getMMTransRecordSummary(paraMap);
		String follow = null;
		if(list != null && list.size() > 0){
			follow = list.get(list.size()-1).getTime();
		}
		resultMap.put("follow", follow);
		resultMap.put("dealList", list);
		
		response.setResult(resultMap);
		return response;
	}

	/*
	 * 销售记录详情查询
	 */
	@Override
	@PosMethod(code="020503")
	public BaseResponse getMMSalesRecordDetail(Object reqParam)	throws Exception {
		BaseRequest bq = (BaseRequest)reqParam;
		BaseResponse response = new BaseResponse();
		String dealNo = null;
		if(bq != null && bq.getParam() != null){
			Map map = JSONObject.parseObject(bq.getParam().toString(), Map.class);
			if(map == null & map.get("dealNo") == null){
				response.setErrcode(10012);
				log.info("市场管理员销售记录详情查询失败，请求参数不合法！");
				return response;
			}
			dealNo = (String)map.get("dealNo");
		}
		
		MMSalesDetail020503Res res = orderManageDao.getMMSaleDetailFund(dealNo);
		List<PlanList020503Res> planList = orderManageDao.getMMSaleDetailPlanList(dealNo);
		List<TagList020503Res> recordList = orderManageDao.getMMSaleDetailRecordList(dealNo);
		
		res.setPlanList(planList);
		res.setRecordList(recordList);
		response.setResult(res);
		return response;
	}
	
	/*
	 * 兑奖记录详情查询
	 */
	@Override
	@PosMethod(code="020504")
	public BaseResponse getMMPayoutRecordDetail(Object reqParam) throws Exception {
		BaseRequest bq = (BaseRequest)reqParam;
		BaseResponse response = new BaseResponse();
		String dealNo = null;
		if(bq != null && bq.getParam() != null){
			Map map = JSONObject.parseObject(bq.getParam().toString(), Map.class);
			if(map == null & map.get("dealNo") == null){
				response.setErrcode(10012);
				log.info("市场管理员兑奖记录详情查询失败，请求参数不合法！");
				return response;
			}
			dealNo = (String)map.get("dealNo");
		}
		
		MMPayoutDetail020504Res res = orderManageDao.getMMPayoutDetailFund(dealNo);
		List<PrizeLevelList020504Res> planList = orderManageDao.getMMPayoutDetailPlanList(dealNo);
		List<TagList020504Res> recordList = orderManageDao.getMMPayoutDetailRecordList(dealNo);
		
		if(res != null){
			res.setPlanList(planList);
			res.setRecordList(recordList);
		}
		response.setResult(res);
		return response;
	}

	/*
	 * 退票记录详情查询
	 */
	@Override
	@PosMethod(code="020505")
	public BaseResponse getMMReturnRecordDetail(Object reqParam) throws Exception {
		BaseRequest bq = (BaseRequest)reqParam;
		BaseResponse response = new BaseResponse();
		String dealNo = null;
		if(bq != null && bq.getParam() != null){
			Map map = JSONObject.parseObject(bq.getParam().toString(), Map.class);
			if(map == null & map.get("dealNo") == null){
				response.setErrcode(10012);
				log.info("市场管理员兑奖记录详情查询失败，请求参数不合法！");
				return response;
			}
			dealNo = (String)map.get("dealNo");
		}
		
		MMReturnDetail020505Res res = orderManageDao.getMMReturnDetailFund(dealNo);
		List<PlanList020505Res> planList = orderManageDao.getMMReturnDetailPlanList(dealNo);
		List<TagList020505Res> recordList = orderManageDao.getMMReturnDetailRecordList(dealNo);
		if(res == null){
			response.setErrcode(1);
			response.setErrmesg("Result is Null");
			log.info("Result is Null!");
		}
		res.setPlanList(planList);
		res.setRecordList(recordList);
		response.setResult(res);
		return response;
	}

	/*
	 * 市场管理员物流查询
	 */
	@Override
	@PosMethod(code="020506")
	public BaseResponse getLogisticsInfo(Object reqParam) throws Exception {
		BaseRequest bq = (BaseRequest)reqParam;
		BaseResponse response = new BaseResponse();
		
		String tagNo = null;
		if(bq != null && bq.getParam() != null){
			Map rq = JSONObject.parseObject(bq.getParam().toString(), Map.class);
			tagNo = (String)rq.get("tagNo");
		}
		
		PackInfo pi = PackHandleFactory.getPackInfo(tagNo);
		LogisticsForm form = new LogisticsForm();
		switch(pi.getPackUnit()){
		case Trunck :
			form.setSpecification("1");
			break;
		case Box :
			form.setSpecification("2");
			break;
		case pkg:
			form.setSpecification("3");
			break;
		default : 
			form.setSpecification("4");
		}
		form.setPlanCode(pi.getPlanCode());
		form.setBatchCode(pi.getBatchCode());
		form.setTagCode(pi.getPackUnitCode());
		form.setTicketNo(pi.getTicketNum()+"");
		
		LogisticsList logistics = logisticsService.getLogistics(form);
		List<LogisticsResult> result = logistics.getResult();
		List<MMLogistics020506Res> list = new ArrayList<MMLogistics020506Res>();
		if (logistics != null && result != null) {
			PayoutModel payout = null;
			Date rewardTime = logistics.getRewardTime();
			SimpleDateFormat sdf =  new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			if (rewardTime != null) {
				payout = logisticsService.getPayout(form);
				MMLogistics020506Res pores = new MMLogistics020506Res();
				pores.setTime(sdf.format(payout.getPayoutDate()));
				pores.setWarehouse("Payout At Outlet--"+payout.getOutlet());
				list.add(pores);
			}
			
			for (LogisticsResult lr : result) {
				MMLogistics020506Res res = new MMLogistics020506Res();
				res.setOperation(EnumConfigEN.outOrInputStatus.get(lr.getObjType()));
				res.setWarehouse(lr.getWarehouseNo());
				res.setOperator(lr.getOperator());
				res.setTime(sdf.format(lr.getTime()));
				list.add(res);
			}
		}
		
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("recordList", list);
		response.setResult(map);
		
		return response;
	}
	
	/*
	 *市场管理员库存盘点 
	 */
	@Override
	@PosMethod(code="020507")
	public BaseResponse getMMInventoryCheck(Object reqParam) throws Exception {
		BaseResponse response = new BaseResponse();
		BaseRequest bq = (BaseRequest) reqParam;
		UserToken ut = (UserToken) redisService.getObject(bq.getToken());

		MMInventoryCheck020507Req req = JSONObject.parseObject(bq.getParam().toString(),MMInventoryCheck020507Req.class);
		List<MMInventoryCheckTag020507Req> tagList = req.getTagList();
		
		if (req == null || tagList == null || tagList.size() <= 0 ) {
			response.setErrcode(10012);
			log.info("市场管理员库存盘点失败，请求参数不合法！");
			return response;
		}

		int len = tagList.size();

		// 先解析完后入库，是为了减少连接占用时间代码；好判断长度
		Connection conn = null;
		CallableStatement stmt = null;
		int resultCode = 0;
		String resultMesg = "";
		try {
			conn = DBConnectUtil.getConnection();
			conn.setAutoCommit(false);
			StructDescriptor sd = new StructDescriptor("TYPE_MM_CHECK_LOTTERY_INFO",conn);
			STRUCT[] result = new STRUCT[len];
			StringBuilder sb = new StringBuilder();
			for (int i = 0; i < len; i++) {
				MMInventoryCheckTag020507Req tag = tagList.get(i);
				PackInfo pi = PackHandleFactory.getPackInfo(tag.getTagNo());
				if(pi == null || pi.getPackUnit().ordinal() > 2 || pi.getPackUnit() != EunmPackUnit.pkg){
					response.setErrcode(10019);
					log.info("市场管理员库存盘点失败，标签不符合规范："+tag.getTagNo());
					return response;
				}
				
				Object[] obj = new Object[8];
				obj[0] = pi.getPlanCode(); // 方案
				obj[1] = pi.getBatchCode(); // 批次
				obj[2] = 3;
				obj[3] = "";
				obj[4] = "";
				obj[5] = pi.getPackUnitCode();
				obj[6] = 0;
				obj[7] = 0;
				result[i] = new STRUCT(sd, conn, obj);
				sb.append(Arrays.toString(obj));
			}
			
			ArrayDescriptor orc_table = ArrayDescriptor.createDescriptor("TYPE_MM_CHECK_LOTTERY_LIST", conn);
			ARRAY oracle_array = new ARRAY(orc_table, conn, result);

			stmt = conn.prepareCall("{ call p_mm_inv_check(?,?,?,?,?,?,?,?) }");
			stmt.setObject(1, ut.getId());
			stmt.setObject(2, oracle_array);
			stmt.registerOutParameter(3, OracleTypes.ARRAY, "TYPE_MM_CHECK_LOTTERY_LIST");
			stmt.registerOutParameter(4, OracleTypes.NUMBER);
			stmt.registerOutParameter(5, OracleTypes.NUMBER);
			stmt.registerOutParameter(6, OracleTypes.NUMBER);
			stmt.registerOutParameter(7, OracleTypes.NUMBER);
			stmt.registerOutParameter(8, OracleTypes.VARCHAR);
			log.debug("执行方法020507的p_mm_inv_check。");
			log.debug("[ userId :" +ut.getId() + ",oracle_array :"+sb.toString());
			
			stmt.execute();
			
			resultCode = stmt.getInt(7);
			resultMesg = stmt.getString(8);
			log.debug("方法020507的p_mm_inv_check执行完成。");
			log.debug("return code: " + resultCode);
			log.debug("return mesg: " + resultMesg);
			if (resultCode != 0) {
				response.setErrcode(1);
				response.setErrmesg(resultMesg);
				log.info("p_mm_inv_check执行失败，错误信息：" + resultMesg);
				return response;
			}
			
			MMInventoryCheck020507Res res = new MMInventoryCheck020507Res();
			res.setInventoryTickets(stmt.getInt(4));
			res.setCheckTickets(stmt.getInt(5));
			res.setDiffTickets(stmt.getInt(6));
			
			ARRAY array = (oracle.sql.ARRAY) stmt.getArray(3);
			ResultSet rs = array.getResultSet();
			List<MMInventoryCheckTag020507Res> recordList = new ArrayList<MMInventoryCheckTag020507Res>();
			while (rs != null && rs.next()) {
				STRUCT struct = (STRUCT) rs.getObject(2);
				Object[] attribs = struct.getAttributes();
				MMInventoryCheckTag020507Res tr = new MMInventoryCheckTag020507Res();
				tr.setTagCode(attribs[0]+"-"+attribs[1]+"-"+attribs[5]);
				tr.setStatus(attribs[7]+"");
				recordList.add(tr);
			}
			res.setRecordList(recordList);
			response.setResult(res);

		} catch (Exception e) {
			response.setErrcode(10500);
			response.setErrmesg(e.getMessage());
			log.error("020507执行出现异常！", e);
		} finally {
			DBConnectUtil.close(stmt);
			DBConnectUtil.close(conn);
		}
		return response;
	}
	
	/*
	 * 市场管理员资金日结查询
	 */
	@Override
	@PosMethod(code="020508")
	public BaseResponse getMMCapitalDaliyList(Object reqParam) throws Exception {
		BaseRequest bq = (BaseRequest)reqParam;
		BaseResponse response = new BaseResponse();
		MMCapitalDaliy020508Req req = null;
		if(bq != null && bq.getParam() != null){
			req = JSONObject.parseObject(bq.getParam().toString(), MMCapitalDaliy020508Req.class);
		}
		UserToken ut = (UserToken)redisService.getObject(bq.getToken());
		Map<String, Object> paraMap = new HashMap<String,Object>();
		paraMap.put("count", req.getCount());
		paraMap.put("follow", req.getFollow());
		paraMap.put("userId", ut.getId());
		
		Map<String,Object> resultMap = new HashMap<String,Object>();
		List<MMCapitalDaliy020508Res> list = orderManageDao.getMMCapitalDaliyList(paraMap);
		String follow = null;
		if(list != null && list.size() > 0){
			follow = list.get(list.size()-1).getCalcDate();
		}
		resultMap.put("follow", follow);
		resultMap.put("dealList", list);
		
		response.setResult(resultMap);
		return response;
	}
	
}
