package cls.pilottery.web.sales.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import cls.pilottery.web.sales.dao.OrderDao;
import cls.pilottery.web.sales.entity.PurchaseOrder;
import cls.pilottery.web.sales.entity.PurchaseOrderDetail;
import cls.pilottery.web.sales.form.OrderForm;
import cls.pilottery.web.sales.model.PlanModel;
import cls.pilottery.web.sales.service.OrderService;

@Service
public class OrderServiceImpl implements OrderService {

	@Autowired
	private OrderDao orderDao;

	@Override
	public int getOrderCount(OrderForm form) {
		return orderDao.getOrderCount(form);
	}

	@Override
	public List<PurchaseOrder> getOrderList(OrderForm form) {
		return orderDao.getOrderList(form);
	}

	@Override
	public int modifyOrderStatus(String purchaseOrderNo, int status) {
		Map<String,Object> paraMap = new HashMap<String,Object>();
		paraMap.put("purchaseOrderNo", purchaseOrderNo);
		paraMap.put("status", status);
		return orderDao.modifyOrderStatus(paraMap);
	}

	@Override
	public List<PlanModel> getPlanList() {
		return orderDao.getPlanList();
	}

	@Transactional(rollbackFor={Exception.class}) 
	@Override
	public void savePurchaseOrder(PurchaseOrder order) {
		String orderSeq = null;
		if(StringUtils.isEmpty(order.getOrderNo())){
			orderSeq = orderDao.getOrderSeq();
		}else{
			orderSeq = order.getOrderNo();
		}
		order.setOrderNo(orderSeq);
		for(int i=0;i<order.getOrderDetail().size();i++){
			PurchaseOrderDetail detail = order.getOrderDetail().get(i);
			if(detail != null && detail.getAmount() > 0){
				for(int k=i+1;k<order.getOrderDetail().size();k++){
					PurchaseOrderDetail detail2 = order.getOrderDetail().get(k);
					if(detail2!=null && detail2.getAmount()>0 && detail.getPlanCode().equals(detail2.getPlanCode())){
						detail.setAmount(detail.getAmount()+detail2.getAmount());
						detail.setPackages(detail.getPackages()+detail2.getPackages());
						detail.setTickets(detail.getTickets()+detail2.getTickets());
						order.getOrderDetail().set(k, null);
					}
				}
				
				detail.setOrderNo(orderSeq);
				orderDao.saveOrderDetail(detail);
			}
		}
		orderDao.savePurchaseOrder(order);
	}

	@Override
	public PurchaseOrder getPurchaseDetail(String purchaseOrderNo) {
		return orderDao.getPurchaseDetail(purchaseOrderNo);
	}

	@Transactional(rollbackFor={Exception.class}) 
	@Override
	public void updatePurchaseOrder(PurchaseOrder order) {
		String orderSeq = order.getOrderNo();
		orderDao.deleteOrderDetails(orderSeq);
		for(int i=0;i<order.getOrderDetail().size();i++){
			PurchaseOrderDetail detail = order.getOrderDetail().get(i);
			if(detail != null && detail.getAmount() > 0){
				for(int k=i+1;k<order.getOrderDetail().size();k++){
					PurchaseOrderDetail detail2 = order.getOrderDetail().get(k);
					if(detail2!=null && detail2.getAmount()>0 &&detail.getPlanCode().equals(detail2.getPlanCode())){
						detail.setAmount(detail.getAmount()+detail2.getAmount());
						detail.setPackages(detail.getPackages()+detail2.getPackages());
						detail.setTickets(detail.getTickets()+detail2.getTickets());
						order.getOrderDetail().set(k, null);
					}
				}
				detail.setOrderNo(orderSeq);
				orderDao.saveOrderDetail(detail);
			}
		}
		orderDao.updatePurchaseOrder(order);	
	}

	@Override
	public List<PurchaseOrder> getOrderListByUser(Map<String,Object> map) {
		return orderDao.getOrderListByUser(map);
	}

	@Override
	public List<PlanModel> getOrderPlanList(Map<String,Object> map) {
		return orderDao.getOrderPlanList(map);
	}

	@Override
	public int getOrderCountForInquery(OrderForm form) {
		return orderDao.getOrderCountForInquery(form);
	}

	@Override
	public List<PurchaseOrder> getOrderListForInquery(OrderForm form) {
		return orderDao.getOrderListForInquery(form);
	}

	@Override
	public int getOutletCountByUser(Map<String, Object> map) {
		return orderDao.getOutletCountByUser(map);
	}

	@Override
	public List<PlanModel> getPlanListByOrg(String insCode) {

		return orderDao.getPlanListByOrg(insCode);
	}

}
