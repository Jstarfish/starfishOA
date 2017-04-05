package cls.pilottery.web.warehouses.model;

import java.util.Date;

import cls.pilottery.common.model.BaseEntity;

public class DamageInfo extends BaseEntity {

	private static final long serialVersionUID = 1L;

	private String recordCode;// 登记编号

	private long damageNum;// 损毁数量

	private Date regDate;// 登记时间

	private String planCode;// 方案代码

	private String planName;// 方案名称

	private String batchNo;// 批次
	
	private int pecification;

	private String pecificationValue;// 规格名称

	private String barEncoding;// 条形编码

	private String backup;// 备注

	private String outPerson;// 登记人名称

	private long amount;// 损毁金额
	
	private long unitNum;//规格数量

	
	public long getUnitNum() {
	
		return unitNum;
	}

	
	public void setUnitNum(long unitNum) {
	
		this.unitNum = unitNum;
	}

	public long getAmount() {

		return amount;
	}

	public String getBackup() {

		return backup;
	}

	public String getBarEncoding() {

		return barEncoding;
	}

	public String getBatchNo() {

		return batchNo;
	}

	public long getDamageNum() {

		return damageNum;
	}

	public String getOutPerson() {

		return outPerson;
	}

	public int getPecification() {

		return pecification;
	}

	public String getPlanCode() {

		return planCode;
	}

	public String getPlanName() {

		return planName;
	}

	public String getRecordCode() {

		return recordCode;
	}

	public Date getRegDate() {

		return regDate;
	}

	

	public void setAmount(long amount) {

		this.amount = amount;
	}

	public void setBackup(String backup) {

		this.backup = backup;
	}

	public void setBarEncoding(String barEncoding) {

		this.barEncoding = barEncoding;
	}

	public void setBatchNo(String batchNo) {

		this.batchNo = batchNo;
	}

	public void setDamageNum(long damageNum) {

		this.damageNum = damageNum;
	}

	public void setOutPerson(String outPerson) {

		this.outPerson = outPerson;
	}

	public void setPecification(int pecification) {

		this.pecification = pecification;
	}

	
	public String getPecificationValue() {
	
		return pecificationValue;
	}

	
	public void setPecificationValue(String pecificationValue) {
	
		this.pecificationValue = pecificationValue;
	}

	public void setPlanCode(String planCode) {

		this.planCode = planCode;
	}

	public void setPlanName(String planName) {

		this.planName = planName;
	}

	public void setRecordCode(String recordCode) {

		this.recordCode = recordCode;
	}

	public void setRegDate(Date regDate) {

		this.regDate = regDate;
	}

	
}
