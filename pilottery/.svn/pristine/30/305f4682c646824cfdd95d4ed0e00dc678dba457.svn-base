package cls.pilottery.pos.system.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;

import cls.pilottery.common.service.RedisService;
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
import cls.pilottery.pos.system.service.OrderManageService;
import cls.pilottery.web.marketManager.dao.ReturnDeliveryDao;
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
	
}
