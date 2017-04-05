package cls.taishan.system.model;

public class RolePrivilegeLink {
	
	private Long roleId;
	private Long priId;
	public Long getRoleId() {
		return roleId;
	}
	public void setRoleId(Long roleId) {
		this.roleId = roleId;
	}
	public Long getPriId() {
		return priId;
	}
	public void setPriId(Long priId) {
		this.priId = priId;
	}
}