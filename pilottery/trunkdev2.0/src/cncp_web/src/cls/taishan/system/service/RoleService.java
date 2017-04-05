package cls.taishan.system.service;

import java.util.List;

import cls.taishan.system.form.RolePermisionForm;
import cls.taishan.system.model.PrivilegeTree;
import cls.taishan.system.model.Role;

public interface RoleService {

	List<Role> getAllRoles();

	Role getRoleById(long roleId);

	void updateRole(Role role);

	void saveRole(Role role);

	int getUserCountByRole(long roleId);

	void deleteRole(long roleId);

	List<PrivilegeTree> getMenuTree(long roleId);

	void saveRolePermission(RolePermisionForm form);

}
