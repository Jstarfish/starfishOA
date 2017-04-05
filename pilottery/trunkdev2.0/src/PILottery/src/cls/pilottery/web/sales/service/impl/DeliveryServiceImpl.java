package cls.pilottery.web.sales.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import cls.pilottery.web.sales.dao.DeliveryDao;
import cls.pilottery.web.sales.dao.OrderDao;
import cls.pilottery.web.sales.entity.DeliveryOrder;
import cls.pilottery.web.sales.entity.DeliveryOrderDetail;
import cls.pilottery.web.sales.entity.DeliveryOrderRelation;
import cls.pilottery.web.sales.form.DeliveryForm;
import cls.pilottery.web.sales.service.DeliveryService;

@Service
public class DeliveryServiceImpl implements DeliveryService {

	@Autowired
	private DeliveryDao deliveryDao;
	
	@Autowired
	private OrderDao orderDao;
	
	@Override
	public List<DeliveryOrder> getDeliveryList(DeliveryForm form) {
		return deliveryDao.getDeliveryList(form);
	}

	@Override
	public int getDeliveryCount(DeliveryForm form) {
		return deliveryDao.getDeliveryCount(form);
	}

	@Override
	public DeliveryOrder getDeliveryDetail(String deliveryOrderNo) {
		return deliveryDao.getDeliveryDetail(deliveryOrderNo);
	}

	@Override
	public String getDeliveryOrderSeq() {
		return deliveryDao.getDeliveryOrderSeq();
	}

	@Transactional(rollbackFor={Exception.class})
	@Override
	public int saveDeliveryOrder(DeliveryOrder order) {
		Long balance = deliveryDao.getMktManagerBalance(order.getApplyAdmin());
		if(balance == null || balance < order.getTotalAmount()){	//市场管理员账户余额不足
			return -1;
		}
		
		List<DeliveryOrderDetail> deliveryDetail = order.getDeliveryDetail();
	    List<DeliveryOrderRelation> doRelation = order.getDoRelation();
		for(int i=0;i<deliveryDetail.size();i++){
			DeliveryOrderDetail detail = deliveryDetail.get(i);
			if(detail!=null && detail.getAmount() > 0){
				for(int j=i+1;j<deliveryDetail.size();j++){	//将同一个方案的明细进行合并
					DeliveryOrderDetail detail2 = deliveryDetail.get(j);
					if(detail2 !=null && detail2.getAmount()>0 && detail.getPlanCode().equals(detail2.getPlanCode())){
						detail.setAmount(detail.getAmount()+detail2.getAmount());
						detail.setPackages(detail.getPackages()+detail2.getPackages());
						detail.setTickets(detail.getTickets()+detail2.getTickets());
						deliveryDetail.set(j, null);
					}
				}
				detail.setDoNo(order.getDoNo());
				deliveryDao.saveDeliveryOrderDetail(detail);
			}
		}
		if(doRelation != null && doRelation.size() > 0){
			for(int k=0;k<doRelation.size();k++){
				DeliveryOrderRelation relation = doRelation.get(k);
				if(relation !=null && StringUtils.isNotEmpty(relation.getOrderNo())){
					relation.setDoNo(order.getDoNo());
					deliveryDao.saveDeliverOrderRelation(relation);
					//更新订单状态为3已受理
					Map<String,Object> map = new HashMap<String,Object>();
					map.put("status", 3);
					map.put("purchaseOrderNo", relation.getOrderNo());
					orderDao.modifyOrderStatus(map);
				}
			}
		}
		deliveryDao.saveDeliveryOrder(order);
		return 1 ;
	}

	@Override
	public int modifyDeliveryOrderStatus(String deliveryOrderNo, int status) {
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("doNo", deliveryOrderNo);
		map.put("status", status);
		return deliveryDao.modifyDeliveryOrderStatus(map);
	}

	@Transactional(rollbackFor={Exception.class})
	@Override
	public int modifyDeliveryOrder(DeliveryOrder order) {
		Long balance = deliveryDao.getMktManagerBalance(order.getApplyAdmin());
		if(balance == null || balance < order.getTotalAmount()){	//市场管理员账户余额不足
			return -1;
		}
		
		List<DeliveryOrderDetail> deliveryDetail = order.getDeliveryDetail();
		List<DeliveryOrderRelation> doRelation = order.getDoRelation();
		deliveryDao.deleteDeliveryDetails(order.getDoNo());		//删除该出货单的明细
		for(int i=0;i<deliveryDetail.size();i++){
			DeliveryOrderDetail detail = deliveryDetail.get(i);
			if(detail!=null && detail.getAmount() > 0){
				for(int j=i+1;j<deliveryDetail.size();j++){	//将同一个方案的明细进行合并
					DeliveryOrderDetail detail2 = deliveryDetail.get(j);
					if(detail2 !=null && detail2.getAmount()>0 && detail.getPlanCode().equals(detail2.getPlanCode())){
						detail.setAmount(detail.getAmount()+detail2.getAmount());
						detail.setPackages(detail.getPackages()+detail2.getPackages());
						detail.setTickets(detail.getTickets()+detail2.getTickets());
						deliveryDetail.set(j, null);
					}
				}
				detail.setDoNo(order.getDoNo());
				deliveryDao.saveDeliveryOrderDetail(detail);
			}
		}
		
		deliveryDao.modifyOrderStatus(order.getDoNo());		//更新该出货单对应订单的状态为1
		deliveryDao.deleteDeliveryOrders(order.getDoNo());		//删除该出货单所包含的订单明细
		if(doRelation != null && doRelation.size() > 0){
			for(int k=0;k<doRelation.size();k++){
				DeliveryOrderRelation relation = doRelation.get(k);
				if(relation !=null && StringUtils.isNotEmpty(relation.getOrderNo())){
					relation.setDoNo(order.getDoNo());
					deliveryDao.saveDeliverOrderRelation(relation);
					//更新订单状态为3已受理
					Map<String,Object> map = new HashMap<String,Object>();
					map.put("status", 3);
					map.put("purchaseOrderNo", relation.getOrderNo());
					orderDao.modifyOrderStatus(map);
				}
			}
		}
		
		deliveryDao.updateDeliveryOrder(order);
		return 1;
	}

	@Override
	public int getDeliveryCountForInquery(DeliveryForm form) {
		return deliveryDao.getDeliveryCountForInquery(form);
	}

	@Override
	public List<DeliveryOrder> getDeliveryListForInquery(DeliveryForm form) {
		return deliveryDao.getDeliveryListForInquery(form);
	}

	@Transactional(rollbackFor={Exception.class})
	@Override
	public int cancelDeliveryOrder(String deliveryOrderNo) {
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("doNo", deliveryOrderNo);
		map.put("status", 2);
		deliveryDao.modifyOrderStatus(deliveryOrderNo);		//更新该出货单对应订单的状态为1
		deliveryDao.deleteDeliveryOrders(deliveryOrderNo);		//删除该出货单所包含的订单明细
		int count = deliveryDao.modifyDeliveryOrderStatus(map);
		return count;
	}

}
