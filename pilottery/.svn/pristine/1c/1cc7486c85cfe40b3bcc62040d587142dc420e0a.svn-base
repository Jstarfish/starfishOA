package cls.pilottery.web.system.service.impl;

import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeSet;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import cls.pilottery.web.system.dao.RoleDao;
import cls.pilottery.web.system.form.RoleForm;
import cls.pilottery.web.system.model.PrivilegeTree;
import cls.pilottery.web.system.model.Role;
import cls.pilottery.web.system.model.RolePrivilegeLink;
import cls.pilottery.web.system.model.User;
import cls.pilottery.web.system.model.UserRoleLink;
import cls.pilottery.web.system.service.RoleService;



@Service
public class RoleServiceImpl implements RoleService{

	@Autowired
	private RoleDao roleDao;

	public Role getRoleById(Long id) {
		return roleDao.getRoleById(id);
	}
	 
	public Role getRoleByName(String name) {
		return roleDao.getRoleByName(name);
	}
	 
	public void deleteRole(Role role) {
		roleDao.deleteRole(role);
	}
	 
	@Transactional(rollbackFor={Exception.class}) 
	@Override
	public void saveRolePrivilege(Role role,List<RolePrivilegeLink> pr) {
		Long roleId = role.getId();
		roleDao.deleteRolePrivilege(roleId.toString());
		// 新建权限
	   this.saveRoleBatchPrivilege(pr);
	}
	
	
	@Override
	public Integer getCountAdminRole(Long roleId) {
		return roleDao.getCountAdminRole(roleId);
	}
	
	/*public void updateRole(RoleForm roleForm) {
		
		roleDao.updateRole(roleForm.getRole());
		// 修改权限
				List<RolePrivilegeLink> rpLinkList = new ArrayList<RolePrivilegeLink>();
				RolePrivilegeLink rpLink = null;
				if (roleForm.getPrivIds() != null) {
					for (Iterator<Long> it = roleForm.getPrivIds().iterator(); it.hasNext();) {
						rpLink = new RolePrivilegeLink();
						Long priv_id = (Long)it.next();
						Privilege vPriv = new Privilege();
						vPriv.setId(priv_id);
						rpLink.setPrivilege(vPriv);
						rpLink.setRole(roleForm.getRole());
						rpLinkList.add(rpLink);
					}
				}
				this.deleteRolePrivilege(roleForm.getRole());
				this.saveRolePrivilege(rpLinkList);
	}
*/
	
	public List<User> getRoleUser(Role role) {
		return roleDao.getRoleUser(role);
	}

	/*public void saveRolePrivilege(List<RolePrivilegeLink> rpLinkList) {
		roleDao.saveRolePrivilege(rpLinkList);
	}*/
	
	
	public void deleteRoleUser(UserRoleLink urLink) {
		roleDao.deleteRoleUser(urLink);
	}

	public Integer getRoleCount(Role role) {
		return roleDao.getRoleCount(role);
	}

	public List<Role> getRoleList(Role role) {
		return roleDao.getRoleList(role);
	}


	public List<Role> getAllRoleList() {
		return roleDao.getAllRoleList();
	}

	public Map<Long, String> getRoleMap() {
		List<Role> roleList = roleDao.getAllRoleList();
		Map<Long, String> roleMap = new LinkedHashMap<Long, String>();
		for(Iterator<Role> it = roleList.iterator(); it.hasNext();){
			Role p_role = (Role) it.next();
			roleMap.put(p_role.getId(), p_role.getName());
		}
		return roleMap;
	}

/*	@Override
	public void deleteRolePrivilege(String id) {
		
		
	}*/

	@Override
		//获得json结构的字符串
		public String getTree(List<PrivilegeTree> listpri) {
			String jsonStr="";
			StringBuilder build=new StringBuilder("[");
			  Set<PrivilegeTree> privilegeTreeset = new TreeSet<PrivilegeTree>(); 
			  privilegeTreeset.addAll(listpri);
			if(privilegeTreeset!=null && privilegeTreeset.size()>0){
				for(PrivilegeTree privilegeTree:privilegeTreeset){
					
					boolean flag=true;
					build.append("{" +"id"+":"+privilegeTree.getId()+","+" pId"+":"+privilegeTree.getPid()+","+"name"+":"+"\""+privilegeTree.getName()+"\""+","+"checked"+":"+privilegeTree.isChecked());
					if(privilegeTree.getId().equals(new Long(0)) && privilegeTree.isChecked()){
						build.append(","+"checked"+":"+false);
						build.append(","+"open"+":"+flag+"}"+",");
					}
					else if(privilegeTree.getId().equals(new Long(0))){
						build.append(","+"open"+":"+flag+"}"+",");
					}
					/*else if(privilegeTree.isChecked()){
						build.append(","+"checked"+":"+flag+"}"+",");
					}*/
					else{
						//build.append(","+"checked"+":"+"true");
						build.append("}"+",");
					}
					jsonStr=build.toString();
					jsonStr=jsonStr.substring(0,jsonStr.length()-1 );
				}
				jsonStr+="]";
		  }
		return jsonStr;
	}


	@Override
	public List<Role> getRoleInfo() {
		return this.roleDao.getRoleInfo();
	}

	@Override
	public List<PrivilegeTree> selectPrivilegeCode(String id) {
		
		return this.roleDao.selectPrivilegeCode(id);
	}

	@Override
	public void saveRoleUser(Role role) {
		 roleDao.saveRoleUser(role);		
	}

	/*@Override
	public void saveRolePrivilege(Role role, List<PrivateRole> pr) {
		// TODO Auto-generated method stub
		
	}*/

	@Override
	public void saveRole(RoleForm roleForm) {
		roleDao.saveRole(roleForm.getRole());
	}

	@Override
	public void updateRole(RoleForm roleForm) {
		roleDao.updateRole(roleForm.getRole());
		
	}

	@Override
	public void deleteRolePrivilege(Role role) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void saveRoleBatchPrivilege(List<RolePrivilegeLink> rpLinkList) {
		// TODO Auto-generated method stub
		
	}
	
	
	@Override
	public void saveRoleBatchPrivilege(Long roleid, String ids) {
		this.roleDao.saveRoleBatchPrivileges(roleid, ids);
		
	}


	
	
}
