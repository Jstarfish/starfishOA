package cls.pilottery.web.system.service;

import java.util.List;
import java.util.Map;

import cls.pilottery.web.system.form.RoleForm;
import cls.pilottery.web.system.model.PrivilegeTree;
import cls.pilottery.web.system.model.Role;
import cls.pilottery.web.system.model.RolePrivilegeLink;
import cls.pilottery.web.system.model.UserLanguage;
import cls.pilottery.web.system.model.UserRoleLink;


/**
 * 角色Service接口
 */
public interface RoleService{

	//得到角色总数
	Integer getRoleCount(Role role);
	
	//分页查询
	List<Role> getRoleList(Role role);
	
	List<Role> getAllRoleList();

	//插入信息
	void saveRole(RoleForm roleForm);
	
	void saveRoleUser(Role role);

	void updateRole(RoleForm roleForm);
	
	//根据id查询角色信息
	Role getRoleById(Long id);
	
	//根据name查询角色信息
	Role getRoleByName(String name);
	
	//根据id或者name删除角色信息
	void deleteRole(Role role);
	
	//查询当前角色下的用户数量 
	Integer getCountAdminRole(Long roleId);
	
	/******************role——user关系操作*****************/
	//删除角色与用户之间的对应关系
	void deleteRoleUser(UserRoleLink urLink);
	/****************************************************/
	
	/***************role——privilege关系操作**************/
	void deleteRolePrivilege(Role role);

	Map<Long, String> getRoleMap();
	

	
	//获得json结构的字符串
	public String getTree(List<PrivilegeTree> listpri, UserLanguage lang);
	
	public List<Role> getRoleInfo();
	
	public List<PrivilegeTree> selectPrivilegeCode(String id);
	
	void saveRolePrivilege(Role role,List<RolePrivilegeLink> rpLinkList);
	void saveRoleBatchPrivilege(List<RolePrivilegeLink> rpLinkList);
	
	void saveRoleBatchPrivilege(Long roleid,String ids);
}
