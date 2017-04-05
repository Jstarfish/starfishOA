package cls.pilottery.web.system.model;

import java.util.Date;
import java.util.List;

import org.springframework.format.annotation.DateTimeFormat;

import cls.pilottery.common.model.BaseEntity;

/*
 * 用户实体类
 * modify by dzg 2015-9-8 定义全局session缓存用户信息，另外按照开发规范规范化定义
 */
public class User extends BaseEntity {

	private static final long serialVersionUID = 4886146712942662664L;
	private Long id;
	private String realName; // 真实姓名
	private String loginId; // 账户
	private String password; // 密码
	private Integer gender; // 性别
	private String email; // email

	@DateTimeFormat(pattern = "yyyy-MM-dd")
	private Date birthday; // 生日
	private String mobilePhone;// 移动电话
	private String officePhone; // 办公电话
	private String homePhone;// 住宅电话
	private String homeAddress; // 地址
	private String institutionCode;// 所属部门编码
	private String institutionName;// 所属部门名称
	private Integer status; // (1-可用，2-删除，3-由于密码原因停用)
	private Integer loginStatus;// 登陆状态(1-在线，2-离线)
	private Integer isCollector;// 是否缴款员
	
	private Boolean isCollectorB;//是否缴款员，仅供前台显示
	private Integer isWarehouseManger;// 是否库房管理员
	private Date createTime;
	private Long createAdminId; // 创建人ID
	private Date loginTime; // 上次登录时间
	private Integer loginCount;// 登陆次数
	private String remark; // 备注信息
	private UserLanguage userLang = UserLanguage.EN;// 用户登陆选择语言默认英文
	private String warehouseCode;// 管辖仓库编码
	private String warehouseName;// 管辖仓库名称
	private Long institutionLeader=-1l;//机构领导
	private Boolean isInstitutionLeader =false;//是否机构领导

	private List<Role> roles;

	public Long getInstitutionLeader() {
		return institutionLeader;
	}

	public void setInstitutionLeader(Long institutionLeader) {
		this.institutionLeader = institutionLeader;
	}

	/*
	 * add by dzg 判断是否当前用户是否机构领导
	 */
	public Boolean getIsInstitutionLeader() {
		if(this.getInstitutionLeader() == -1)
		return false;
		else
			return (this.id == this.institutionLeader);
	}

	public void setIsInstitutionLeader(Boolean isInstitutionLeader) {
		this.isInstitutionLeader = isInstitutionLeader;
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

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
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

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public Integer getGender() {
		return gender;
	}

	public void setGender(Integer gender) {
		this.gender = gender;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public Date getBirthday() {
		return birthday;
	}

	public void setBirthday(Date birthday) {
		this.birthday = birthday;
	}

	public String getMobilePhone() {
		return mobilePhone;
	}

	public void setMobilePhone(String mobilePhone) {
		this.mobilePhone = mobilePhone;
	}

	public String getOfficePhone() {
		return officePhone;
	}

	public void setOfficePhone(String officePhone) {
		this.officePhone = officePhone;
	}

	public String getHomePhone() {
		return homePhone;
	}

	public void setHomePhone(String homePhone) {
		this.homePhone = homePhone;
	}

	public String getHomeAddress() {
		return homeAddress;
	}

	public void setHomeAddress(String homeAddress) {
		this.homeAddress = homeAddress;
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

	public Integer getStatus() {
		return status;
	}

	public void setStatus(Integer status) {
		this.status = status;
	}

	public Integer getLoginStatus() {
		return loginStatus;
	}

	public void setLoginStatus(Integer loginStatus) {
		this.loginStatus = loginStatus;
	}

	public Integer getIsCollector() {
		return isCollector;
	}

	public void setIsCollector(Integer isCollector) {
		this.isCollector = isCollector;
	}

	public Integer getIsWarehouseManger() {
		return isWarehouseManger;
	}

	public void setIsWarehouseManger(Integer isWarehouseManger) {
		this.isWarehouseManger = isWarehouseManger;
	}

	public Long getCreateAdminId() {
		return createAdminId;
	}

	public void setCreateAdminId(Long createAdminId) {
		this.createAdminId = createAdminId;
	}

	public Date getLoginTime() {
		return loginTime;
	}

	public void setLoginTime(Date loginTime) {
		this.loginTime = loginTime;
	}

	public List<Role> getRoles() {
		return roles;
	}

	public void setRoles(List<Role> roles) {
		this.roles = roles;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	public Date getCreateTime() {
		return createTime;
	}

	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}

	public Integer getLoginCount() {
		return loginCount;
	}

	public void setLoginCount(Integer loginCount) {
		this.loginCount = loginCount;
	}

	public UserLanguage getUserLang() {
		return userLang;
	}

	public void setUserLang(UserLanguage userLang) {
		this.userLang = userLang;
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

	public Boolean getIsCollectorB() {
		return (this.isCollector != null && this.isCollector ==1);
	}

	public void setIsCollectorB(Boolean isCollectorB) {
		this.isCollectorB = isCollectorB;
		if(this.isCollectorB)
			this.isCollector =1;
		else
			this.isCollector =0;
	}

}
