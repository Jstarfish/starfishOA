package cls.taishan.system.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import cls.taishan.common.constants.SysConstants;
import cls.taishan.common.utils.LocaleUtil;
import cls.taishan.common.utils.MD5Util;
import cls.taishan.system.form.UserForm;
import cls.taishan.system.model.OrgInfo;
import cls.taishan.system.model.Role;
import cls.taishan.system.model.User;
import cls.taishan.system.service.RoleService;
import cls.taishan.system.service.UserService;
import lombok.extern.log4j.Log4j;
@Log4j
@Controller
@RequestMapping("user")
public class UserController {
	@Autowired
	private UserService userService;
	@Autowired
	private RoleService roleService;
	
	@RequestMapping(params = "method=initUserList")
	public String initUserList(HttpServletRequest request , ModelMap model , UserForm userForm) {
		List<OrgInfo> orgList = userService.getAllOrgs();
		model.addAttribute("orgList",orgList);
		return LocaleUtil.getUserLocalePath("system/user/userList", request);
	}
	
	@ResponseBody
	@RequestMapping(params = "method=listUsers")
	public Object listUsers(UserForm form) {
		List<User> user = userService.getAllUsers(form);
		return user;
	}
	
	@RequestMapping(params = "method=editUser")
	public String editUser(HttpServletRequest request, ModelMap model, long userId) {
		UserForm form = new UserForm();
		form.setUserId(userId);
		User user = userService.getUserByCondition(form);
		
		//获取编辑用户的角色
		String userRoleList = userService.getUserRoles(userId);
		List<OrgInfo> orgList = userService.getAllOrgs();
		
		List<Role> roleList = roleService.getAllRoles();
		model.addAttribute("roleList",roleList);
		
		model.addAttribute("orgList",orgList);
		model.addAttribute("user",user);
		model.addAttribute("userRoleList",userRoleList);
		return LocaleUtil.getUserLocalePath("system/user/editUser", request);
	}
	
	@ResponseBody
	@RequestMapping(params = "method=updateUser")
	public String updateUser(HttpServletRequest request, ModelMap model, User user) {
		try {
			Long userId = user.getId();
			int count = userService.getRoleByUser(userId);
			if(count != 0){
				userService.deleteRoleByUser(userId);
			}
			userService.updateUser(user);
		} catch (Exception e) {
			log.error("更新用户信息出错",e);
			return "error";
		}
		return "success";
	}
	
	@RequestMapping(params = "method=addUser")
	public String addUser(HttpServletRequest request, ModelMap model ) {
		List<OrgInfo> orgList = userService.getAllOrgs();
		model.addAttribute("orgList",orgList);
		
		List<Role> roleList = roleService.getAllRoles();
		model.addAttribute("roleList",roleList);
		return LocaleUtil.getUserLocalePath("system/user/addUser", request);
	}
	
	@ResponseBody
	@RequestMapping(params = "method=saveUser")
	public String saveUser(HttpServletRequest request,HttpSession session, ModelMap model, User user) {
		try {
			Long userId = userService.getUserIdByName(user.getLoginId());
			if (userId != null) {
				return "exist";
			}
			User currentUser = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			user.setCreateAdminId(currentUser.getId());
			user.setPassword(MD5Util.MD5Encode(SysConstants.INIT_LOGIN_PASSWORD));
			userService.saveUser(user);

		} catch (Exception e) {
			log.error("新增用户出错", e);
			return "error";
		}
		return "success";
	}
	
	@ResponseBody
	@RequestMapping(params = "method=enableUser")
	public String enableUser(HttpServletRequest request, ModelMap model, long userId) {
		try {
			User user = new User();
			user.setId(userId);
			user.setStatus(1);
			userService.updateUserStatus(user);
		} catch (Exception e) {
			e.printStackTrace();
			return e.getMessage();
		}
		return "success";
	}
	
	@ResponseBody
	@RequestMapping(params = "method=disableUser")
	public String disableUser(HttpServletRequest request, ModelMap model, long userId) {
		try {
			User user = new User();
			user.setId(userId);
			user.setStatus(3);
			userService.updateUserStatus(user);
		} catch (Exception e) {
			e.printStackTrace();
			return e.getMessage();
		}
		return "success";
	}
	
	@ResponseBody
	@RequestMapping(params = "method=resetPwd")
	public String resetPwd(HttpServletRequest request, ModelMap model, long userId) {
		try {
			User user = new User();
			user.setId(userId);
			user.setPassword(MD5Util.MD5Encode(SysConstants.INIT_LOGIN_PASSWORD));
			userService.updatePwd(user);
		} catch (Exception e) {
			e.printStackTrace();
			return e.getMessage();
		}
		return "success";
	}
	
	@ResponseBody
	@RequestMapping(params = "method=deleteUser")
	public String deleteUser(HttpServletRequest request, ModelMap model, long userId) {
		try {
			User user = new User();
			user.setId(userId);
			user.setStatus(2);
			userService.updateUserStatus(user);
		} catch (Exception e) {
			e.printStackTrace();
			return e.getMessage();
		}
		return "success";
	}
	
}
