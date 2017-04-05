package cls.pilottery.web.goodsreceipts.model;

import java.util.ArrayList;
import java.util.List;

public class ReturnResult {
	private String  marketManager;
	private String orgName;
	private String applyDate;
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
	public String getApplyDate() {
		return applyDate;
	}
	public void setApplyDate(String applyDate) {
		this.applyDate = applyDate;
	}
	public String getOrgName() {
		return orgName;
	}
	public void setOrgName(String orgName) {
		this.orgName = orgName;
	}
}
