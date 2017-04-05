package cls.pilottery.web.outlet.form;

public class ReturnedGoodsForm {
	private String arAgency;// 站点编号
	// 分页参数
	private Integer beginNum;
	private Integer endNum;
    private String orgCode;
	public String getArAgency() {
		return arAgency;
	}

	public void setArAgency(String arAgency) {
		this.arAgency = arAgency;
	}

	public Integer getBeginNum() {
		return beginNum;
	}

	public void setBeginNum(Integer beginNum) {
		this.beginNum = beginNum;
	}

	public Integer getEndNum() {
		return endNum;
	}

	public void setEndNum(Integer endNum) {
		this.endNum = endNum;
	}

	public String getOrgCode() {
		return orgCode;
	}

	public void setOrgCode(String orgCode) {
		this.orgCode = orgCode;
	}

}
