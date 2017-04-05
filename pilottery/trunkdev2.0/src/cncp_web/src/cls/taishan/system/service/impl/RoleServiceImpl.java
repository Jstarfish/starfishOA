package cls.taishan.system.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import cls.taishan.system.dao.RoleDao;
import cls.taishan.system.form.RolePermisionForm;
import cls.taishan.system.model.PrivilegeTree;
import cls.taishan.system.model.Role;
import cls.taishan.system.service.RoleService;

@Service
public class RoleServiceImpl implements RoleService {
	@Autowired
	private RoleDao roleDao;
	
	@Override
	public List<Role> getAllRoles() {
		return roleDao.getAllRoles();
	}

	@Override
	public Role getRoleById(long roleId) {
		return roleDao.getRoleById(roleId);
	}

	@Override
	public void updateRole(Role role) {
		roleDao.updateRole(role);
	}

	@Override
	public void saveRole(Role role) {
		roleDao.saveRole(role);
	}

	@Override
	public int getUserCountByRole(long roleId) {
		return roleDao.getUserCountByRole(roleId);
	}

	@Override
	@Transactional(rollbackFor={Exception.class})
	public void deleteRole(long roleId) {
		roleDao.deletePrivilegeByRole(roleId);
		roleDao.deleteRole(roleId);
	}

	@Override
	public List<PrivilegeTree> getMenuTree(long roleId) {
		return roleDao.getMenuTree(roleId);
	}

	@Override
	@Transactional(rollbackFor={Exception.class})
	public void saveRolePermission(RolePermisionForm form) {
		roleDao.deleteRolePermission(form.getRoleId());
		String[] menuIds = form.getMenuIds().split(",");
		for( String menuId : menuIds){
			form.setMenuId(menuId);
			roleDao.saveRolePermission(form);
		}
	}

}
