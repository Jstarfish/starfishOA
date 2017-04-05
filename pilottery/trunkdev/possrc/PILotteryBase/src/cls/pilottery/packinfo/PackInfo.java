package cls.pilottery.packinfo;

import java.io.Serializable;

/*
 * 包装实体信息
 */
public class PackInfo implements  Serializable  {

	public String EWMStr;//二维码字符串
	private String planCode;//方案编号
	private String planName;//方案名称
	private String batchCode;//批次编号
	private EunmPackUnit packUnit;//箱=1盒=2本=3
	private String packUnitCode;//箱盒本编号
	private Integer ticketNum;//总票数
	private Long	amount;//总金额
	private String safetyCode;//保安码，用用户兑奖
	private String paySign;//快速兑奖标志
	private String firstPkgCode;//首本号

	private Long PrizeAmount;//中奖的金额
	
	// 判断是否重复，
	// getBatchCode 批次号
	// getPlanCode 方案编号
	// getPackUnitCode 箱盒本编号
	public boolean isSame(PackInfo pi) {
		if (pi.getPackUnit() == getPackUnit()
				&& pi.getBatchCode().equals(getBatchCode())
				&& pi.getPlanCode().equals(getPlanCode())
				&& pi.getPackUnitCode().equals(getPackUnitCode())) {
			if (pi.getPackUnit() == EunmPackUnit.ticket) {
				if (pi.getFirstPkgCode().equals(getFirstPkgCode())) {
					return true;
				}
			} else {
				return true;
			}
		}
		return false;
	}

	public Long getPrizeAmount() {
		return PrizeAmount;
	}
	public void setPrizeAmount(Long prize) {
		PrizeAmount=prize;
	}
	public String getPlanCode() {
		return planCode;
	}
	public void setPlanCode(String planCode) {
		this.planCode = planCode;
	}
	public String getBatchCode() {
		return batchCode;
	}
	public void setBatchCode(String batchCode) {
		this.batchCode = batchCode;
	}
	public EunmPackUnit getPackUnit() {
		return packUnit;
	}
	public void setPackUnit(EunmPackUnit packUnit) {
		this.packUnit = packUnit;
	}
	public String getPackUnitCode() {
		return packUnitCode;
	}
	public void setPackUnitCode(String packUnitCode) {
		this.packUnitCode = packUnitCode;
	}
	public Integer getTicketNum() {
		return ticketNum;
	}
	public void setTicketNum(Integer ticketNum) {
		this.ticketNum = ticketNum;
	}
	public Long getAmount() {
		return amount;
	}
	public void setAmount(Long amount) {
		this.amount = amount;
	}
	public String getGroupCode() {
		return groupCode;
	}
	public void setGroupCode(String groupCode) {
		this.groupCode = groupCode;
	}
	private String groupCode;//奖组编码
	
	
    @Override
    public String toString() {
    	StringBuffer sb = new StringBuffer();
    	sb.append("planCode="+this.planCode+";");
    	sb.append("planName="+this.planName+";");
    	sb.append("batchCode="+this.batchCode+";");
    	sb.append("packUnit="+this.packUnit+";");
    	sb.append("packUnitCode="+this.packUnitCode+";");
    	sb.append("ticketNum="+this.ticketNum+";");
    	sb.append("amount="+this.amount+";");
    	sb.append("groupCode="+this.groupCode+";");
    	sb.append("firstPkgCode="+this.firstPkgCode+";");
    	return sb.toString();
    }
	public String getPaySign() {
		return paySign;
	}
	public void setPaySign(String paySign) {
		this.paySign = paySign;
	}
	public String getSafetyCode() {
		return safetyCode;
	}
	public void setSafetyCode(String safetyCode) {
		this.safetyCode = safetyCode;
	}
	public String getFirstPkgCode() {
		return firstPkgCode;
	}
	public void setFirstPkgCode(String firstPkgCode) {
		this.firstPkgCode = firstPkgCode;
	}
	public String getPlanName() {
		return planName;
	}
	public void setPlanName(String planName) {
		this.planName = planName;
	}
	
}
