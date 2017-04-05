package cls.pilottery.web.system.controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import cls.pilottery.common.utils.PageUtil;
import cls.pilottery.web.capital.model.ResulstMessage;
import cls.pilottery.web.system.form.RoleForm;
import cls.pilottery.web.system.model.BatchRolePrivilege;
import cls.pilottery.web.system.model.Privilege;
import cls.pilottery.web.system.model.PrivilegeTree;
import cls.pilottery.web.system.model.Role;
import cls.pilottery.web.system.model.User;
import cls.pilottery.web.system.service.PrivilegeService;
import cls.pilottery.web.system.service.RoleService;
import cls.pilottery.web.system.service.UserService;

import com.alibaba.fastjson.JSON;
import com.sun.xml.bind.v2.TODO;

/**
 * 角色管理Controller
 * 
 */

@Controller
@RequestMapping("/role")
public class RoleController {

	Logger log = Logger.getLogger(RoleController.class);

	@Autowired
	private UserService userService;

	@Autowired
	private RoleService roleService;

	@Autowired
	private PrivilegeService privilegeService;

	/**
	 * 数据准备: 所有权限List
	 */
	@ModelAttribute("allPrivList")
	public List<Privilege> refAllFuncList() {
		return privilegeService.getAllPrivilegeList(0);
	}

	/**
	 * 角色列表查询 数据分页处理
	 */
	@RequestMapping(params = "method=listRoles")
	public String toRoleList(HttpServletRequest request, ModelMap model,
			RoleForm roleForm) {
		Role role = roleForm.getRole();
		Integer count = roleService.getRoleCount(role);
		List<Role> list = new ArrayList<Role>();

		int pageIndex = PageUtil.getPageIndex(request);

		if (count != null && count.intValue() != 0) {
			role.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
			role.setEndNum((pageIndex - 1) * PageUtil.pageSize
					+ PageUtil.pageSize);
			list = roleService.getRoleList(role);
		}
		model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
		model.addAttribute("pageDataList", list);
		return "system/roleList";
	}

	/** 
	 * 转向角色新增/编辑页面
	 */
	@RequestMapping(params = "method=editRole", method = RequestMethod.GET)
	public String editRole(HttpServletRequest request, ModelMap model,
			Long roleId) {
		RoleForm roleForm = new RoleForm();

		String operFlag = "create"; // 操作标记
		if (roleId != null) {
			// 角色对象
			Role role = roleService.getRoleById(roleId);
			// 绑定功能到角色信息
			roleForm.setRole(role);
			operFlag = "edit";
		}
		model.addAttribute("roleForm", roleForm);
		model.addAttribute("operFlag", operFlag);
		return "system/editRole";
	}

	/**
	 * 保存角色
	 */
	@RequestMapping(params = "method=saveRole", method = RequestMethod.POST)
	public String saveRole(HttpServletRequest request, RoleForm roleForm,
			ModelMap model, String operFlag) {
		try {
			// 保存
			if (operFlag.equals("create")) {
				if (roleService.getRoleByName(roleForm.getRole().getName()) != null) {
					model.addAttribute("system_message", "‘"
							+ roleForm.getRole().getName()
							+ "’ has been registered! ");
					return "common/errorTip";
				}
				roleService.saveRole(roleForm);
			} else {
				/*if (roleService.getRoleByName(roleForm.getRole().getName()) != null) {
					model.addAttribute("system_message", "‘"
							+ roleForm.getRole().getName()
							+ "’ has been registered! ");
					return "common/errorTip";
				}*/
				roleService.updateRole(roleForm);
			}
		} catch (Exception e) {
			model.addAttribute("system_message", e.getMessage());
			return "common/errorTip";
		}
		// 设置保留参数
		// model.addAttribute("reservedHrefURL","role.do?method=listRoles");
		return "common/successTip";
		// return "system/roleList";
	}

	/**
	 * 角色授权用户的界面
	 */
	@RequestMapping(params = "method=addRoleUser", method = RequestMethod.GET)
	public String addRoleUser(HttpServletRequest request, ModelMap model,
			Long roleId) {
		Role role = null;
		List<User> allUsers = null;
		List<User> currUsers = null;
		try {
			if (roleId != null) {
				// 角色对象
				role = roleService.getRoleById(roleId);
				allUsers = userService.getAllNotUserByRoleId(roleId);
				currUsers = userService.getAllUserByRoleId(roleId);
			}
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			log.error("角色授权发生异常！", e);
			return "_common/errorTip";
		}
		model.addAttribute("role", role);
		model.addAttribute("allUsers", allUsers);
		model.addAttribute("currUsers", currUsers);
		return "system/addRoleUsers";
	}

	/**
	 * 保存用户角色
	 */
	@RequestMapping(params = "method=saveRoleUser", method = RequestMethod.POST)
	public String saveRoleUser(HttpServletRequest request, ModelMap model) {
		try {
			long roleid = Long.parseLong(request.getParameter("roleid"));
			if (roleid>0) {
				Role r =new Role();
				r.setId(roleid);
				String[] roles =request.getParameterValues("undo_redo_to");
				if(roles != null)
				{
					r.setUsers(StringUtils.join(roles,","));
				}
				roleService.saveRoleUser(r);
				if(r.getC_errcode() != 0)
				{
					throw new Exception(r.getC_errmsg());
				}
			}else
			{
				throw new Exception("Invalid Role Parameters.");
			}
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			log.error("保存用户角色发生异常！", e);
			return "common/errorTip";
		}
		return "common/successTip";
	}

	/**
	 * 删除角色   note: 当角色下又用户时不能进行删除
	 */
	@ResponseBody
	@RequestMapping(params = "method=deleteRole")
	public ResulstMessage deleteRole(HttpServletRequest request, ModelMap model,Long roleId) {
		ResulstMessage message = new ResulstMessage();
		Role role = roleService.getRoleById(roleId);
		Integer count = 0;
				try {
					count = roleService.getCountAdminRole(roleId);
					if (count > 0) {
						message.setMessage("Cannot delete a role having user");
					} else {
				roleService.deleteRole(role);
			}
		} catch (Exception e) {
			message.setMessage(e.getMessage());
			log.error("删除用户出现异常,异常信息:" + e.getMessage(), e);
		}
		 return message;
	}
	
	/**
	 * 初始化角色授权
	 */
	@RequestMapping(params = "method=rolePermissions")
	public String rolePrivilege(HttpServletRequest request, ModelMap model) {
		 String id=request.getParameter("roleId");
		 Role role= roleService.getRoleById(Long.parseLong(id));
		 model.addAttribute("role", role);
		List<PrivilegeTree> list = roleService.selectPrivilegeCode(id);
		String jsonStr = roleService.getTree(list);
		model.addAttribute("jsonStr", jsonStr);
		return "system/rolePermissions";
	}
	/**
	 *  修改角色授权信息
	 */
	@RequestMapping(params = "method=modyRolePermissions")
	public String modyInstitutions(HttpServletRequest request, ModelMap model,Role role)throws Exception{
		Long roleid=role.getId();
		try{
			 String privas=request.getParameter("privilegeId");
			 /*String [] att=priva.split(",");
			
			 List<RolePrivilegeLink> plist = new ArrayList<RolePrivilegeLink>();
			 if(att.length>0){
				 for(int i=0;i<att.length;i++){
					 RolePrivilegeLink ro = new RolePrivilegeLink(); 
					 ro.setRoleId(id);
					 ro.setPriId(new Long(att[i]));
					 plist.add(ro);
				 }
			 }*/
			//roleService.saveRolePrivilege(role, plist);
			 BatchRolePrivilege brp=new BatchRolePrivilege();
			 brp.setRoleid(roleid.toString());
			 brp.setPids(privas);
			 roleService.saveRoleBatchPrivilege(roleid, privas);
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			log.error("修改角色授权功能发生异常！", e);
			return "common/errorTip";
		}
		return "common/successTip";
	}
	
}
