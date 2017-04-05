package cls.pilottery.demo.model;

import java.util.Date;
import java.util.List;

import cls.pilottery.common.model.BaseEntity;

public class User extends BaseEntity {
	private static final long serialVersionUID = 4886146712942662664L;
	private Long id;
	private String realname; //真实姓名
	private String account;  //账户
	private String password; //密码
	private String active;	 //是否激活(1-是，2-否)
	private String email;	 //email
	private Date birthday;	 //生日
	private Integer gender;	 //性别
	private String tel;	 	 //电话
	private String fax;	 	 //传真
	private String address;	 //地址
	private Date createtime;
	private Long createAdminId; //创建人ID
	private Short areaCode;
	private Date loginTime;	//上次登录时间
	private int loginStatus;
	
	private List<Role> roles;	
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getRealname() {
		return realname;
	}
	public void setRealname(String realname) {
		this.realname = realname;
	}
	public String getAccount() {
		return account;
	}
	public void setAccount(String account) {
		this.account = account;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getActive() {
		return active;
	}
	public void setActive(String active) {
		this.active = active;
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
	public Integer getGender() {
		return gender;
	}
	public void setGender(Integer gender) {
		this.gender = gender;
	}
	public String getTel() {
		return tel;
	}
	public void setTel(String tel) {
		this.tel = tel;
	}
	public String getFax() {
		return fax;
	}
	public void setFax(String fax) {
		this.fax = fax;
	}
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	public Date getCreatetime() {
		return createtime;
	}
	public void setCreatetime(Date createtime) {
		this.createtime = createtime;
	}
	public Long getCreateAdminId() {
		return createAdminId;
	}
	public void setCreateAdminId(Long createAdminId) {
		this.createAdminId = createAdminId;
	}
	public Short getAreaCode() {
		return areaCode;
	}
	public void setAreaCode(Short areaCode) {
		this.areaCode = areaCode;
	}
	public Date getLoginTime() {
		return loginTime;
	}
	public void setLoginTime(Date loginTime) {
		this.loginTime = loginTime;
	}
	public int getLoginStatus() {
		return loginStatus;
	}
	public void setLoginStatus(int loginStatus) {
		this.loginStatus = loginStatus;
	}
	public List<Role> getRoles() {
		return roles;
	}
	public void setRoles(List<Role> roles) {
		this.roles = roles;
	}
	@Override
	public String toString() {
		return "User [account=" + account + ", active=" + active + ", address="
				+ address + ", areaCode=" + areaCode + ", birthday=" + birthday
				+ ", createAdminId=" + createAdminId + ", createtime="
				+ createtime + ", email=" + email + ", fax=" + fax
				+ ", gender=" + gender + ", id=" + id + ", loginStatus="
				+ loginStatus + ", loginTime=" + loginTime + ", password="
				+ password + ", realname=" + realname + ", tel=" + tel + "]";
	}
}
