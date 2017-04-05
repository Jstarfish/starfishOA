package cls.pilottery.web.system.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import cls.pilottery.web.system.model.PrivilegeTree;
import cls.pilottery.web.system.model.Role;
import cls.pilottery.web.system.model.RolePrivilegeLink;
import cls.pilottery.web.system.model.User;
import cls.pilottery.web.system.model.UserRoleLink;

public interface RoleDao {

	void saveRole(Role role);

	Role getRoleById(Long id);

	Role getRoleByName(String name);

	void deleteRole(Role role);

	void updateRole(Role role);

	List<User> getRoleUser(Role role);

	List<Role> getRoleList(Role role);

	Integer getRoleCount(Role role);

	void saveRoleUser(Role role);

	// 获取所有角色信息
	public List<Role> getRoleInfo();

	// 获取权限列表

	public List<PrivilegeTree> selectPrivilegeCode(String id);

	// 批量插入权限
	void saveRolePrivilege(Role role, List<RolePrivilegeLink> rpLinkList);

	void deleteRolePrivilege(String id);

	void saveRoleBatchPrivilege(List<RolePrivilegeLink> rpLinkList);

	//
	void saveRoleBatchPrivileges(@Param(value = "roleid") Long roleId,
			@Param(value = "pids") String ids);

	// 查询当前角色下的用户数量
	Integer getCountAdminRole(Long roleId);

	
	/*
	 * will modify
	 */

	void deleteRoleUser(UserRoleLink urLink);

	void updateRolePrivilege(List<RolePrivilegeLink> rpLinkList);

	List<Role> getAllRoleList();

}
