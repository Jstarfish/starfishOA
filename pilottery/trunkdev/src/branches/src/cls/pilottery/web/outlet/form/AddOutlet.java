package cls.pilottery.web.outlet.form;

import java.io.Serializable;
import java.util.Date;

public class AddOutlet implements Serializable {
	private static final long serialVersionUID = 1L;

	private String agencyName; // 站点名称

	private Short storetypeId; // 店面类型ID

	private Short agencyType; // 销售站类型（1=传统终端(预付费)；2=受信终端(后付费)；3=无纸化；4=中心销售站）

	private Short bankId;// 银行ID

	private String bankAccount;// 银行账号

	private String telephone;// 销售站电话

	private String contactPerson;// 销售站联系人

	private String address;// 销售站地址

	private String orgCode;// 所属部门编码

	private String areaCode;// 所属区域编码

	private String pass;// 站点密码

	private int marketManagerId;// 市场管理员编码

	private String personalId;// 证件号码

	private String contractNo;// 合同编号

	private String glatlng_n;// 经度

	private String glatlng_e;// 纬度

	private int status;// 状态

	private Date agencyAddTime;// 添加时间

	public Date getAgencyQuitTime() {
		return agencyQuitTime;
	}

	public void setAgencyQuitTime(Date agencyQuitTime) {
		this.agencyQuitTime = agencyQuitTime;
	}

	private Date agencyQuitTime;// 清退时间

	public Date getAgencyAddTime() {
		return agencyAddTime;
	}

	public void setAgencyAddTime(Date agencyAddTime) {
		this.agencyAddTime = agencyAddTime;
	}

	public int getStatus() {
		return status;
	}

	public void setStatus(int status) {
		this.status = status;
	}

	// -----------返回信息
	private String c_outlet_code;// 站点编码

	private int c_errorcode;// 错误编码

	private String c_errormesg;// 错误原因

	public String getC_outlet_code() {
		return c_outlet_code;
	}

	public void setC_outlet_code(String c_outlet_code) {
		this.c_outlet_code = c_outlet_code;
	}

	public int getC_errorcode() {
		return c_errorcode;
	}

	public void setC_errorcode(int c_errorcode) {
		this.c_errorcode = c_errorcode;
	}

	public String getC_errormesg() {
		return c_errormesg;
	}

	public void setC_errormesg(String c_errormesg) {
		this.c_errormesg = c_errormesg;
	}

	public String getAgencyName() {
		return agencyName;
	}

	public void setAgencyName(String agencyName) {
		this.agencyName = agencyName;
	}

	public Short getStoretypeId() {
		return storetypeId;
	}

	public void setStoretypeId(Short storetypeId) {
		this.storetypeId = storetypeId;
	}

	public Short getAgencyType() {
		return agencyType;
	}

	public void setAgencyType(Short agencyType) {
		this.agencyType = agencyType;
	}

	public Short getBankId() {
		return bankId;
	}

	public void setBankId(Short bankId) {
		this.bankId = bankId;
	}

	public String getBankAccount() {
		return bankAccount;
	}

	public void setBankAccount(String bankAccount) {
		this.bankAccount = bankAccount;
	}

	public String getTelephone() {
		return telephone;
	}

	public void setTelephone(String telephone) {
		this.telephone = telephone;
	}

	public String getContactPerson() {
		return contactPerson;
	}

	public void setContactPerson(String contactPerson) {
		this.contactPerson = contactPerson;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getOrgCode() {
		return orgCode;
	}

	public void setOrgCode(String orgCode) {
		this.orgCode = orgCode;
	}

	public String getAreaCode() {
		return areaCode;
	}

	public void setAreaCode(String areaCode) {
		this.areaCode = areaCode;
	}

	public String getPass() {
		return pass;
	}

	public void setPass(String pass) {
		this.pass = pass;
	}

	public int getMarketManagerId() {
		return marketManagerId;
	}

	public void setMarketManagerId(int marketManagerId) {
		this.marketManagerId = marketManagerId;
	}

	public String getPersonalId() {
		return personalId;
	}

	public void setPersonalId(String personalId) {
		this.personalId = personalId;
	}

	public String getContractNo() {
		return contractNo;
	}

	public void setContractNo(String contractNo) {
		this.contractNo = contractNo;
	}

	public String getGlatlng_n() {
		return glatlng_n;
	}

	public void setGlatlng_n(String glatlng_n) {
		this.glatlng_n = glatlng_n;
	}

	public String getGlatlng_e() {
		return glatlng_e;
	}

	public void setGlatlng_e(String glatlng_e) {
		this.glatlng_e = glatlng_e;
	}

	public AddOutlet() {
	}

	@Override
	public String toString() {
		return "AddOutlet [agencyName=" + agencyName + ", storetypeId=" + storetypeId + ", agencyType=" + agencyType
				+ ", bankId=" + bankId + ", bankAccount=" + bankAccount + ", telephone=" + telephone
				+ ", contactPerson=" + contactPerson + ", address=" + address + ", orgCode=" + orgCode + ", areaCode="
				+ areaCode + ", pass=" + pass + ", marketManagerId=" + marketManagerId + ", personalId=" + personalId
				+ ", contractNo=" + contractNo + ", glatlng_n=" + glatlng_n + ", glatlng_e=" + glatlng_e + "]";
	}
}
