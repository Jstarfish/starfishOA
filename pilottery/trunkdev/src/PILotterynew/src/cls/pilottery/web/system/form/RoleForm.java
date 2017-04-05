package cls.pilottery.web.system.form;

import java.util.List;

import cls.pilottery.web.system.model.Role;

public class RoleForm {

	private Role role;

	// 权限列表
	private List<Long> privIds;
	
	public Role getRole() {
		if (role == null)
			role = new Role();
		return role;
	}

	public void setRole(Role role) {
		this.role = role;
	}

	public List<Long> getPrivIds() {
		return privIds;
	}

	public void setPrivIds(List<Long> privIds) {
		this.privIds = privIds;
	}

}
