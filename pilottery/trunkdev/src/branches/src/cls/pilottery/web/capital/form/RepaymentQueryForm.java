package cls.pilottery.web.capital.form;

import cls.pilottery.common.model.BaseEntity;

public class RepaymentQueryForm extends BaseEntity {

	private static final long serialVersionUID = -9068672450478777907L;
	
	private String marketManagerCode;
	private String marketManagerName;
	private String repaymentDate;
	private String sessionOrgCode;         //当前登录用户所属的机构
	
	public String getMarketManagerCode() {
		return marketManagerCode;
	}
	
	public void setMarketManagerCode(String marketManagerCode) {
		this.marketManagerCode = marketManagerCode == null ? null : marketManagerCode.trim();
	}
	
	public String getMarketManagerName() {
		return marketManagerName;
	}
	
	public void setMarketManagerName(String marketManagerName) {
		this.marketManagerName = marketManagerName == null ? null : marketManagerName.trim();
	}

	public String getRepaymentDate() {
		return repaymentDate;
	}

	public void setRepaymentDate(String repaymentDate) {
		this.repaymentDate = repaymentDate == null ? null : repaymentDate.trim();
	}

	public String getSessionOrgCode() {
		return sessionOrgCode;
	}

	public void setSessionOrgCode(String sessionOrgCode) {
		this.sessionOrgCode = sessionOrgCode == null ? null : sessionOrgCode.trim();
	}
}
