package cls.pilottery.web.goodsreceipts.model;

import java.util.ArrayList;
import java.util.List;

public class ReturnResult {
	private String  marketManager;
	private Long actickets;
	private List<RetrurnVo> rows=new ArrayList<RetrurnVo> ();
	public String getMarketManager() {
		return marketManager;
	}
	public void setMarketManager(String marketManager) {
		this.marketManager = marketManager;
	}
	public List<RetrurnVo> getRows() {
		return rows;
	}
	public void setRows(List<RetrurnVo> rows) {
		this.rows = rows;
	}
	public Long getActickets() {
		return actickets;
	}
	public void setActickets(Long actickets) {
		this.actickets = actickets;
	}

}
