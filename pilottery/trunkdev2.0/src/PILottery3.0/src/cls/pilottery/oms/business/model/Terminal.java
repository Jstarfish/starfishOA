package cls.pilottery.oms.business.model;

import org.apache.log4j.Logger;

import cls.pilottery.common.entity.AbstractEntity;

public class Terminal extends AbstractEntity{

	private static final long serialVersionUID = 147323576704534230L;
	
	static Logger logger = Logger.getLogger(Terminal.class);
	
	private String terminalCode;					//销售终端编码
	private String terminalCodeToChar;
	private String agencyCodeToChar;
	private String agencyName;
	private AreaParent agencyParent;			//所属销售站
	private String uniqueCode;					//销售终端标识码
	private Integer terminalType;				//销售终端型号
	private String  terminalTypeName;			
	private String macAddress;					//MAC地址
	private TerminalStatus terminalStatus;		//终端状态
	private TerminalYesNoType forPayment;
	private TerminalYesNoType enableTellerLogon;//是否训练模式
	private String softNo;
	private String agencyCode;
	
	//add by jhx
	private Integer status;  // 销售终端状态
	
	public Integer getStatus() {
		return status;
	}

	public void setStatus(Integer status) {
		this.status = status;
	}

	public AreaParent getAgencyParent() {
		return agencyParent;
	}
	
	public void setAgencyParent(AreaParent agencyParent) {
		this.agencyParent = agencyParent;
	}
	
	public TerminalStatus getTerminalStatus() {
		return terminalStatus;
	}
	
	public void setTerminalStatus(TerminalStatus terminalStatus) {
		this.terminalStatus = terminalStatus;
	}
	
	public String getTerminalCode() {
		return terminalCode;
	}
	
	public void setTerminalCode(String terminalCode) {
		this.terminalCode = terminalCode;
	}

	public String getUniqueCode() {
		return uniqueCode;
	}
	
	public void setUniqueCode(String uniqueCode) {
		this.uniqueCode = uniqueCode;
	}

	public String getMacAddress() {
		return macAddress;
	}
	
	public void setMacAddress(String macAddress) {
		this.macAddress = macAddress;
	}
	
	public TerminalYesNoType getForPayment() {
		return forPayment;
	}
	
	public void setForPayment(TerminalYesNoType forPayment) {
		this.forPayment = forPayment;
	}
	
	public TerminalYesNoType getEnableTellerLogon() {
		return enableTellerLogon;
	}
	
	public void setEnableTellerLogon(TerminalYesNoType enableTellerLogon) {
		this.enableTellerLogon = enableTellerLogon;
	}
	
	public Integer getTerminalType() {
		return terminalType;
	}
	
	public void setTerminalType(Integer terminalType) {
		this.terminalType = terminalType;
	}
	
	public String getTerminalTypeName() {
		return terminalTypeName;
	}
	
	public void setTerminalTypeName(String terminalTypeName) {
		this.terminalTypeName = terminalTypeName;
	}

	public String getTerminalCodeToChar() {
		return terminalCodeToChar;
	}

	public void setTerminalCodeToChar(String terminalCodeToChar) {
		this.terminalCodeToChar = terminalCodeToChar;
	}

	public String getAgencyCodeToChar() {
		return agencyCodeToChar;
	}

	public void setAgencyCodeToChar(String agencyCodeToChar) {
		this.agencyCodeToChar = agencyCodeToChar;
	}

	public String getAgencyName() {
		return agencyName;
	}

	public void setAgencyName(String agencyName) {
		this.agencyName = agencyName;
	}

	public String getSoftNo() {
		return softNo;
	}

	public void setSoftNo(String softNo) {
		this.softNo = softNo;
	}

	public String getAgencyCode() {
		return agencyCode;
	}

	public void setAgencyCode(String agencyCode) {
		this.agencyCode = agencyCode;
	}

	@Override
	public String toString() {
		return "Terminal [agencyCode=" + agencyCode + ", agencyCodeToChar=" + agencyCodeToChar + ", agencyName=" + agencyName + ", agencyParent=" + agencyParent + ", enableTellerLogon=" + enableTellerLogon + ", forPayment=" + forPayment + ", macAddress=" + macAddress + ", softNo=" + softNo + ", terminalCode=" + terminalCode + ", terminalCodeToChar=" + terminalCodeToChar + ", terminalStatus=" + terminalStatus + ", terminalType=" + terminalType + ", terminalTypeName=" + terminalTypeName + ", uniqueCode=" + uniqueCode + "]";
	}

}
