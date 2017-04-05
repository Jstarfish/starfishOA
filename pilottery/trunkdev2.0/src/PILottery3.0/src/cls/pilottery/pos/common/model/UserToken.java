package cls.pilottery.pos.common.model;

public class UserToken implements java.io.Serializable{
	private static final long serialVersionUID = 4310333014297178120L;
	private long msn = 1;		//消息序号
	private Long id;			//用户ID
	private String realName; 	//真实姓名
	private String loginId;  	//账户
	private String institutionCode;	//所属部门编码
	private String  institutionName;	//所属部门名称
	private String warehouseCode;		//管辖仓库编码
	private String warehouseName;		//管辖仓库名称
	private String language;			//语言
	private String userType;			//用户类型：1 市场专员 2 站点
	private String deviceType;			//默认填2,1传统终端	2 移动终端	3 手机
	private String deviceSign;			//设备标志码IMEI
	private String marketManageId;		//站点所对应 的市场管理员
	public long getMsn() {
		return msn;
	}
	public void setMsn(long msn) {
		this.msn = msn;
	}
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getRealName() {
		return realName;
	}
	public void setRealName(String realName) {
		this.realName = realName;
	}
	public String getLoginId() {
		return loginId;
	}
	public void setLoginId(String loginId) {
		this.loginId = loginId;
	}
	public String getMarketManageId() {
		return marketManageId;
	}
	public void setMarketManageId(String marketManageId) {
		this.marketManageId = marketManageId;
	}
	public String getInstitutionCode() {
		return institutionCode;
	}
	public void setInstitutionCode(String institutionCode) {
		this.institutionCode = institutionCode;
	}
	public String getInstitutionName() {
		return institutionName;
	}
	public void setInstitutionName(String institutionName) {
		this.institutionName = institutionName;
	}
	public String getWarehouseCode() {
		return warehouseCode;
	}
	public void setWarehouseCode(String warehouseCode) {
		this.warehouseCode = warehouseCode;
	}
	public String getWarehouseName() {
		return warehouseName;
	}
	public void setWarehouseName(String warehouseName) {
		this.warehouseName = warehouseName;
	}
	public String getLanguage() {
		return language;
	}
	public void setLanguage(String language) {
		this.language = language;
	}
	public String getDeviceType() {
		return deviceType;
	}
	public void setDeviceType(String deviceType) {
		this.deviceType = deviceType;
	}
	public String getDeviceSign() {
		return deviceSign;
	}
	public void setDeviceSign(String deviceSign) {
		this.deviceSign = deviceSign;
	}
	public String getUserType() {
		return userType;
	}
	public void setUserType(String userType) {
		this.userType = userType;
	}
}
