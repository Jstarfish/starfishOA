package cls.taishan.system.dao;

import java.util.List;

import cls.taishan.system.form.RolePermisionForm;
import cls.taishan.system.model.PrivilegeTree;
import cls.taishan.system.model.Role;

public interface RoleDao {

	List<Role> getAllRoles();

	Role getRoleById(long roleId);

	void updateRole(Role role);

	void saveRole(Role role);

	int getUserCountByRole(long roleId);

	void deleteRole(long roleId);

	void deletePrivilegeByRole(long roleId);

	List<PrivilegeTree> getMenuTree(long roleId);

	void deleteRolePermission(long roleId);

	void saveRolePermission(RolePermisionForm form);

}
