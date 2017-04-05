package cls.pilottery.pos.system.model;

import java.io.Serializable;
import java.util.List;

import com.alibaba.fastjson.JSON;

/*
 * 站点入库请求
 */
public class OutletGoodsRecpRequest implements Serializable {
	private static final long serialVersionUID = 5793673894427319219L;
	private String outletCode;
	private String password;
	private List<OutletGoodInfo> goodsTagList;
	
	@Override
	public String toString() {
		return "[outletCode=" + outletCode + ", password=" + password + ", goodsTagList=" + JSON.toJSONString(goodsTagList)+ "]";
	}

	public String getOutletCode() {
		return outletCode;
	}

	public void setOutletCode(String outletCode) {
		this.outletCode = outletCode;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public List<OutletGoodInfo> getGoodsTagList() {
		return goodsTagList;
	}

	public void setGoodsTagList(List<OutletGoodInfo> goodsTagList) {
		this.goodsTagList = goodsTagList;
	}
}
