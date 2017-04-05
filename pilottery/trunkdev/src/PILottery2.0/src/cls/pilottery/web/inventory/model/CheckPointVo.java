package cls.pilottery.web.inventory.model;

import java.util.Date;

public class CheckPointVo {
	private String cpNo;// 盘点编号
	private String houseCode;// 仓库名称
	private String cpName;// 盘点名称
	private Date cpDate;// 盘点日期
	private Integer status;// 盘点状态
	private Integer result;// 盘点结果
	private String chName;// 盘点人

	public String getCpNo() {
		return cpNo;
	}

	public void setCpNo(String cpNo) {
		this.cpNo = cpNo;
	}

	public String getHouseCode() {
		return houseCode;
	}

	public void setHouseCode(String houseCode) {
		this.houseCode = houseCode;
	}

	public String getCpName() {
		return cpName;
	}

	public void setCpName(String cpName) {
		this.cpName = cpName;
	}

	public Date getCpDate() {
		return cpDate;
	}

	public void setCpDate(Date cpDate) {
		this.cpDate = cpDate;
	}

	public Integer getStatus() {
		return status;
	}

	public void setStatus(Integer status) {
		this.status = status;
	}

	public Integer getResult() {
		return result;
	}

	public void setResult(Integer result) {
		this.result = result;
	}

	public String getChName() {
		return chName;
	}

	public void setChName(String chName) {
		this.chName = chName;
	}

}
