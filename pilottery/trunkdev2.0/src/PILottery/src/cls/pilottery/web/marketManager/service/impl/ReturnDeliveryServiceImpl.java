package cls.pilottery.web.marketManager.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import cls.pilottery.web.marketManager.dao.ReturnDeliveryDao;
import cls.pilottery.web.marketManager.entity.ReturnDeliveryDetail;
import cls.pilottery.web.marketManager.entity.ReturnDeliveryOrder;
import cls.pilottery.web.marketManager.form.ReturnDeliveryForm;
import cls.pilottery.web.marketManager.service.ReturnDeliveryService;
import cls.pilottery.web.sales.entity.StockTransferDetail;

@Service
public class ReturnDeliveryServiceImpl implements ReturnDeliveryService {
	@Autowired
	private ReturnDeliveryDao returnDeliveryDao;

	@Override
	public int getReturnDeliveryCount(ReturnDeliveryForm form) {
		return returnDeliveryDao.getReturnDeliveryCount(form);
	}

	@Override
	public ReturnDeliveryOrder getReturnDeliveryDetail(String returnNo) {
		return returnDeliveryDao.getReturnDeliveryDetail(returnNo);
	}

	@Override
	public List<ReturnDeliveryOrder> getReturnDeliveryList(ReturnDeliveryForm form) {
		return returnDeliveryDao.getReturnDeliveryList(form);
	}

	@Override
	public int modifyReturnDeliveryStatus(String returnNo, int status) {
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("returnNo", returnNo);
		map.put("status", status);
		return returnDeliveryDao.modifyReturnDeliveryStatus(map);
	}

	@Transactional(rollbackFor={Exception.class}) 
	@Override
	public String saveReturnDelivery(ReturnDeliveryOrder order) {
		List<ReturnDeliveryDetail> rdDetail = order.getRdDetail();
		String returnNo = returnDeliveryDao.getReturnDeliverySeq();
		order.setReturnNo(returnNo);
		for(int i=0;i<rdDetail.size();i++){
			ReturnDeliveryDetail detail = rdDetail.get(i);
			if(detail != null && detail.getAmount() > 0){
				detail.setReturnNo(returnNo);
				for(int k=i+1;k<rdDetail.size();k++){
					ReturnDeliveryDetail detail2 = rdDetail.get(k);
					if(detail2 != null && detail2.getAmount()>0 && detail.getPlanCode().equals(detail2.getPlanCode())){
						detail.setAmount(detail.getAmount()+detail2.getAmount());
						detail.setPackages(detail.getPackages()+detail2.getPackages());
						detail.setTickets(detail.getTickets()+detail2.getTickets());
						rdDetail.set(k, null);
					}
				}
				returnDeliveryDao.saveReturnDeliveryDetail(detail);
			}
		}
		long directAmount = returnDeliveryDao.getDirectAmount();
		order.setDirectAmount(directAmount);
		if(order.getApplyAmount() <= directAmount){
			returnDeliveryDao.saveReturnDeliveryDirect(order);
		}else{
			returnDeliveryDao.saveReturnDelivery(order);
		}
		return returnNo;
	}

	@Transactional(rollbackFor={Exception.class}) 
	@Override
	public void updateReturnDelivery(ReturnDeliveryOrder order) {
		List<ReturnDeliveryDetail> rdDetail = order.getRdDetail();
		String returnNo = order.getReturnNo();
		returnDeliveryDao.deleteReturnDeliveryDetails(returnNo);
		for(int i=0;i<rdDetail.size();i++){
			ReturnDeliveryDetail detail = rdDetail.get(i);
			if(detail != null && detail.getAmount() > 0){
				detail.setReturnNo(returnNo);
				for(int k=i+1;k<rdDetail.size();k++){
					ReturnDeliveryDetail detail2 = rdDetail.get(k);
					if(detail2 != null && detail2.getAmount()>0 && detail.getPlanCode().equals(detail2.getPlanCode())){
						detail.setAmount(detail.getAmount()+detail2.getAmount());
						detail.setPackages(detail.getPackages()+detail2.getPackages());
						detail.setTickets(detail.getTickets()+detail2.getTickets());
						rdDetail.set(k, null);
					}
				}
				returnDeliveryDao.saveReturnDeliveryDetail(detail);
			}
		}
		long directAmount = returnDeliveryDao.getDirectAmount();
		order.setDirectAmount(directAmount);
		if(order.getApplyAmount() <= directAmount){
			returnDeliveryDao.updateReturnDeliveryDirect(order);
		}else{
			returnDeliveryDao.updateReturnDelivery(order);
		}
	}

	@Override
	public void updateReturnDeliveryAproval(ReturnDeliveryOrder order) {
		returnDeliveryDao.updateReturnDeliveryAproval(order);
	}

}
