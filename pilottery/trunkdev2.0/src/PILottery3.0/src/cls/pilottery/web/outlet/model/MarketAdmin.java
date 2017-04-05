package cls.pilottery.web.outlet.model;

import java.io.Serializable;

/**
 * 
 * @describe 市场管理员列表
 * 
 */
public class MarketAdmin implements Serializable {

	private static final long serialVersionUID = 1L;

	private Long market;

	private String realName;

	public String getRealName() {

		return realName;
	}

	public void setRealName(String realName) {

		this.realName = realName;
	}

	public Long getMarket() {

		return market;
	}

	public void setMarket(Long market) {

		this.market = market;
	}

	public MarketAdmin() {

	}
}
