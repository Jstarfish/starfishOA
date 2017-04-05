package cls.pilottery.web.capital.model;

import java.util.List;

/*
 * 组织结构账户扩展类
 * 
 * 
 */
public class OutletAccountExt extends OutletAccount {

	/**
	 * 序列化
	 */
	private static final long serialVersionUID = 170193637953252295L;
	
	/*
	 * 方案授权信息列表
	 */
	private List<OutletCommRate> outletCommRate;
	

	

	public List<OutletCommRate> getOutletCommRate() {
		return outletCommRate;
	}

	public void setOutletCommRate(List<OutletCommRate> outletCommRate) {
		this.outletCommRate = outletCommRate;
	}


	
	
}
