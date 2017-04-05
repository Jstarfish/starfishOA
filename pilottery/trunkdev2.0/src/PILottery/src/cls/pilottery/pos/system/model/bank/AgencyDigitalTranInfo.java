package cls.pilottery.pos.system.model.bank;

import java.io.Serializable;


public class AgencyDigitalTranInfo implements Serializable {

	private static final long serialVersionUID = -5756345505507908323L;
	private String tranFlow;
	private String referFlow;
	private String bankFlow;
	private int tranType;
	private int accType;
	private String agencyCode;
	private String agencyAccNo;
	private String digitalAccSeq;
	private String digitalAccNo;
	private String exchangeRate;
	private long amount;
	private long fee;
	//充值后账户余额
	private long afterAmout;
	private int status;
	private int currency;
	private int adminId;
	private String reqJsonData;
	private String failureReason;
	private String repJsonData;
	
	
	//专门为提现准备的字段
	private String password;
	private int isOutLimit;
	
	private int errCode;
	private String errMessage;
	
	public String getTranFlow() {
		return tranFlow;
	}
	public void setTranFlow(String tranFlow) {
		this.tranFlow = tranFlow;
	}
	public String getReferFlow() {
		return referFlow;
	}
	public void setReferFlow(String referFlow) {
		this.referFlow = referFlow;
	}
	public int getTranType() {
		return tranType;
	}
	public void setTranType(int tranType) {
		this.tranType = tranType;
	}
	public int getAccType() {
		return accType;
	}
	public void setAccType(int accType) {
		this.accType = accType;
	}
	public String getAgencyCode() {
		return agencyCode;
	}
	public void setAgencyCode(String agencyCode) {
		this.agencyCode = agencyCode;
	}
	public String getAgencyAccNo() {
		return agencyAccNo;
	}
	public void setAgencyAccNo(String agencyAccNo) {
		this.agencyAccNo = agencyAccNo;
	}
	public String getDigitalAccSeq() {
		return digitalAccSeq;
	}
	public void setDigitalAccSeq(String digitalAccSeq) {
		this.digitalAccSeq = digitalAccSeq;
	}
	public String getDigitalAccNo() {
		return digitalAccNo;
	}
	public void setDigitalAccNo(String digitalAccNo) {
		this.digitalAccNo = digitalAccNo;
	}
	public long getAmount() {
		return amount;
	}
	public void setAmount(long amount) {
		this.amount = amount;
	}
	public int getStatus() {
		return status;
	}
	public void setStatus(int status) {
		this.status = status;
	}
	public String getReqJsonData() {
		return reqJsonData;
	}
	public void setReqJsonData(String reqJsonData) {
		this.reqJsonData = reqJsonData;
	}
	public int getCurrency() {
		return currency;
	}
	public void setCurrency(int currency) {
		this.currency = currency;
	}
	public long getAfterAmout() {
		return afterAmout;
	}
	public void setAfterAmout(long afterAmout) {
		this.afterAmout = afterAmout;
	}
	public String getErrMessage() {
		return errMessage;
	}
	public void setErrMessage(String errMessage) {
		this.errMessage = errMessage;
	}
	public int getErrCode() {
		return errCode;
	}
	public void setErrCode(int errCode) {
		this.errCode = errCode;
	}
	public String getFailureReason() {
		return failureReason;
	}
	public void setFailureReason(String failureReason) {
		this.failureReason = failureReason;
	}
	public String getRepJsonData() {
		return repJsonData;
	}
	public void setRepJsonData(String repJsonData) {
		this.repJsonData = repJsonData;
	}
	public String getBankFlow() {
		return bankFlow;
	}
	public void setBankFlow(String bankFlow) {
		this.bankFlow = bankFlow;
	}
	public long getFee() {
		return fee;
	}
	public void setFee(long fee) {
		this.fee = fee;
	}
	public int getAdminId() {
		return adminId;
	}
	public void setAdminId(int adminId) {
		this.adminId = adminId;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public int getIsOutLimit() {
		return isOutLimit;
	}
	public void setIsOutLimit(int isOutLimit) {
		this.isOutLimit = isOutLimit;
	}
	public String getExchangeRate() {
		return exchangeRate;
	}
	public void setExchangeRate(String exchangeRate) {
		this.exchangeRate = exchangeRate;
	}
	
		
}