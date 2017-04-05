package cls.pilottery.pos.system.model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import cls.pilottery.web.sales.entity.DeliveryOrderDetail;

public class DoDetailResponse implements Serializable {
	private static final long serialVersionUID = 5557217794642847735L;
	private String deliveryOrder;
	private String status;
	private List<DoDetail> detailList;

	public String getDeliveryOrder() {
		return deliveryOrder;
	}

	public void setDeliveryOrder(String deliveryOrder) {
		this.deliveryOrder = deliveryOrder;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
	
	public List<DoDetail> getDetailList() {
		return detailList;
	}

	public void setDetailList(List<DoDetail> detailList) {
		this.detailList = detailList;
	}

	public void setObjectValues(List<DeliveryOrderDetail> dolist){
		detailList = new ArrayList<DoDetail>();
		
		for(DeliveryOrderDetail detail : dolist){
			DoDetail dodetail = new DoDetail();
			dodetail.setPlanCode(detail.getPlanCode());
			dodetail.setPlanName(detail.getPlanName());
			dodetail.setTickets(detail.getTickets());
			dodetail.setAmount(detail.getAmount());
			this.detailList.add(dodetail);
		}
	}

	public class DoDetail implements Serializable{
		private static final long serialVersionUID = -5533123405151285030L;
		private String planCode;
		private String planName;
		private int tickets;
		private long amount;
		public String getPlanCode() {
			return planCode;
		}
		public void setPlanCode(String planCode) {
			this.planCode = planCode;
		}
		public String getPlanName() {
			return planName;
		}
		public void setPlanName(String planName) {
			this.planName = planName;
		}
		public int getTickets() {
			return tickets;
		}
		public void setTickets(int tickets) {
			this.tickets = tickets;
		}
		public long getAmount() {
			return amount;
		}
		public void setAmount(long amount) {
			this.amount = amount;
		}
	}
}
