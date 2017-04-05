package cls.taishan.system.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import cls.taishan.common.utils.LocaleUtil;
import cls.taishan.system.form.RolePermisionForm;
import cls.taishan.system.model.PrivilegeTree;
import cls.taishan.system.model.Role;
import cls.taishan.system.service.RoleService;

@Controller
@RequestMapping("role")
public class RoleController {
	@Autowired
	private RoleService roleService;
	
	@RequestMapping(params = "method=initRoleList")
	public String initRoleList(HttpServletRequest request) {
		return LocaleUtil.getUserLocalePath("system/role/roleList", request);
	}
	
	@ResponseBody
	@RequestMapping(params = "method=listRoles")
	public Object listRoles() {
		List<Role> role = roleService.getAllRoles();
		return role;
	}
	
	@RequestMapping(params = "method=editRole")
	public String editRole(HttpServletRequest request, ModelMap model, long roleId) {
		Role role = roleService.getRoleById(roleId);
		model.addAttribute("role",role);
		return LocaleUtil.getUserLocalePath("system/role/editRole", request);
	}
	
	@ResponseBody
	@RequestMapping(params = "method=updateRole")
	public String updateRole(HttpServletRequest request, ModelMap model, Role role) {
		try {
			roleService.updateRole(role);
		} catch (Exception e) {
			e.printStackTrace();
			return "error";
		}
		
		return "success";
	}
	
	@RequestMapping(params = "method=addRole")
	public String addRole(HttpServletRequest request, ModelMap model ) {
		return LocaleUtil.getUserLocalePath("system/role/addRole", request);
	}
	
	@ResponseBody
	@RequestMapping(params = "method=saveRole")
	public String saveRole(HttpServletRequest request,HttpSession session, ModelMap model, Role role) {
		try {
			roleService.saveRole(role);
		} catch (Exception e) {
			e.printStackTrace();
			return "error";
		} 
		return "success";
	}
	
	@ResponseBody
	@RequestMapping(params = "method=deleteRole")
	public String deleteRole(HttpServletRequest request, ModelMap model, long roleId) {
		try {
			int roleUserCount = roleService.getUserCountByRole(roleId);
			if(roleUserCount > 0){	//该角色下有用户存在
				return "-1";	
			}
			roleService.deleteRole(roleId);
		} catch (Exception e) {
			e.printStackTrace();
			return "error";
		}
		return "success";
	}
	
	@RequestMapping(params = "method=rolePermission")
	public String rolePermission(HttpServletRequest request, ModelMap model, long roleId) {
		Role role = roleService.getRoleById(roleId);
		model.addAttribute("role",role);
		return LocaleUtil.getUserLocalePath("system/role/rolePermission", request);
	}
	
	@ResponseBody
	@RequestMapping(params = "method=getMenuTree")
	public Object getMenuTree(HttpServletRequest request, ModelMap model, long roleId) {
		List<PrivilegeTree> menuList = roleService.getMenuTree(roleId);
		return menuList;
	}
	
	@ResponseBody
	@RequestMapping(params = "method=saveRolePermission")
	public String saveRolePermission(HttpServletRequest request,HttpSession session, ModelMap model, RolePermisionForm form) {
		try {
			roleService.saveRolePermission(form);
		} catch (Exception e) {
			e.printStackTrace();
			return "error";
		} 
		return "success";
	}
	
}
