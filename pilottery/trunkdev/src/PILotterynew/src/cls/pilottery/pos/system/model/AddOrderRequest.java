package cls.pilottery.pos.system.model;

import java.io.Serializable;
import java.util.List;

public class AddOrderRequest implements Serializable {
	private static final long serialVersionUID = -8469723118437480920L;
	private String outletCode;
	private List<AddOrderDetail> goodsTagList;
	public String getOutletCode() {
		return outletCode;
	}
	public void setOutletCode(String outletCode) {
		this.outletCode = outletCode;
	}
	public List<AddOrderDetail> getGoodsTagList() {
		return goodsTagList;
	}
	public void setGoodsTagList(List<AddOrderDetail> goodsTagList) {
		this.goodsTagList = goodsTagList;
	}
}
