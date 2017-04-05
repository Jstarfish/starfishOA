package cls.pilottery.packinfo;

import java.io.Serializable;

/*
 * 包装实体信息
 */
public class PackInfo implements Serializable {

	private static final long serialVersionUID = 1L;

	private String planCode;// 方案编号

	private String planName;// 方案名称

	private String batchCode;// 批次编号

	private EunmPackUnit packUnit;// 箱=1盒=2本=3保安码=4

	private String packUnitCode;// 箱盒本编号

	private Integer ticketNum;// 总票数

	private Long amount;// 总金额

	private String safetyCode;// 保安码，用用户兑奖

	private String paySign;// 快速兑奖标志

	private String firstPkgCode;// 首本号

	private String safeCode;// 安全码

	private String splitChar = "-";// 分割符号，用于返回完整票号
	
	private int payLevel;//兑奖级别，用于控制范围

	public String getSafeCode() {

		return safeCode;
	}

	public void setSafeCode(String safeCode) {

		this.safeCode = safeCode;
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

	private String groupCode;// 奖组编码

	public String getPaySign() {

		return paySign;
	}

	@Override
	public String toString() {

		return "PackInfo [planCode=" + planCode + ", planName=" + planName + ", batchCode=" + batchCode + ", packUnit="
				+ packUnit + ", packUnitCode=" + packUnitCode + ", ticketNum=" + ticketNum + ", amount=" + amount
				+ ", safetyCode=" + safetyCode + ", paySign=" + paySign + ", firstPkgCode=" + firstPkgCode
				+ ", safeCode=" + safeCode + ", groupCode=" + groupCode + "]";
	}

	/*
	 * 返回完整票号 方案-批次-本号-票号
	 */
	public String getFullTicketCode() {

		try {
			return this.planCode.trim() + this.splitChar + this.batchCode.trim() + this.splitChar
					+ this.firstPkgCode.trim() + this.splitChar + this.getPackUnitCode();
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
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

	public int getPayLevel() {
		return payLevel;
	}

	public void setPayLevel(int payLevel) {
		this.payLevel = payLevel;
	}
}
