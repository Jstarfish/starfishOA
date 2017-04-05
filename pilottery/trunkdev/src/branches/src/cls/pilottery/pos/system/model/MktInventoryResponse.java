package cls.pilottery.pos.system.model;

import java.util.List;

public class MktInventoryResponse {
	private List<MktInventoryDetail> detailList ;

	public List<MktInventoryDetail> getDetailList() {
		return detailList;
	}

	public void setDetailList(List<MktInventoryDetail> detailList) {
		this.detailList = detailList;
	}
	
}
