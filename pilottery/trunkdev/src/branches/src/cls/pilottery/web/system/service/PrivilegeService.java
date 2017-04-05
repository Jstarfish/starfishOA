package cls.pilottery.web.system.service;

import java.util.List;

import cls.pilottery.web.system.model.Privilege;
import cls.pilottery.web.system.model.Role;
import cls.pilottery.web.system.model.User;

public interface PrivilegeService {
	

	List<Privilege> getPrivilegeByUserId(Long id);
	
/*
 * will modify
 */
	//查询全部一级权限	 
	public List<Privilege> getAllPrivilegeList(int areacode);
	
	//取得 用户权限列表	 
	public List<Privilege> getPrivilegeListByUserId(Long userId);

	//得到权限对象
	public Privilege getPrivilegeById(Long privilegeId);
	
	//根据权限标识得到权限	 
	public List<Privilege> getPrivilegeByCode(String code);
	
	//根据角色表中的id或name查询角色信息和对应权限信息
	public List<Privilege> getRolePrivelege(List<Role> roles,int areacode);
}
