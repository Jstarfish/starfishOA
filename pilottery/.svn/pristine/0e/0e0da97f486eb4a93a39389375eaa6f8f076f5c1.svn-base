package cls.pilottery.web.system.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import cls.pilottery.common.EnumConfigEN;
import cls.pilottery.common.constants.SysConstants;
import cls.pilottery.common.utils.LocaleUtil;
import cls.pilottery.common.utils.MD5Util;
import cls.pilottery.common.utils.PageUtil;
import cls.pilottery.common.utils.SpringContextUtil;
import cls.pilottery.web.capital.model.MarketManager;
import cls.pilottery.web.capital.model.ResulstMessage;
import cls.pilottery.web.institutions.model.InfOrgs;
import cls.pilottery.web.institutions.service.InstitutionsService;
import cls.pilottery.web.system.form.UserForm;
import cls.pilottery.web.system.model.User;
import cls.pilottery.web.system.service.MarketPwdService;
import cls.pilottery.web.system.service.UserService;

/**
 * 用户管理Controller
 * 
 * @author jhx
 */
@Controller
@RequestMapping("/user")
public class UserController {

	static Logger logger = Logger.getLogger(UserController.class);

	@Autowired
	private UserService userService;

	@Autowired
	private InstitutionsService institutionsService;

	private Map<Integer, String> userStatus = EnumConfigEN.userStatus;

	/*
	 * 准备数据-枚举定义
	 */
	@ModelAttribute("userStatusMap")
	public Map<Integer, String> getUserStatus(HttpServletRequest request) {
		if (request != null)
			this.userStatus = LocaleUtil.getUserLocaleEnum("userStatus", request);
		return userStatus;
	}

	/**
	 * 列表查询,显示当前存在的用户 数据分页处理
	 */
	@RequestMapping(params = "method=listUsers")
	public String toUserList(HttpServletRequest request , ModelMap model , UserForm userForm) {

		List<InfOrgs> orgsList = this.institutionsService.getAllInstitutionsInfo();
		List<User> list = new ArrayList<User>();
		int pageIndex = PageUtil.getPageIndex(request);
		Integer count = userService.getUserCount(userForm);
		if (count != null && count.intValue() != 0) {
			userForm.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
			userForm.setEndNum((pageIndex - 1) * PageUtil.pageSize + PageUtil.pageSize);
			list = userService.getUserList(userForm);
		}
		model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
		model.addAttribute("pageDataList", list);
		model.addAttribute("orgsList", orgsList);
		return LocaleUtil.getUserLocalePath("system/userList", request);
	}

	/**
	 * 新增用户和修改用户
	 */
	@RequestMapping(params = "method=editUser", method = RequestMethod.GET)
	public String editUser(HttpServletRequest request, ModelMap model,
			Long userId) {
		UserForm userForm = new UserForm();

		/* 获取部门信息 */
		List<InfOrgs> orgsList = this.institutionsService
				.getAllInstitutionsInfo();
		userForm.setOper((short) 1);
		if (userId != null) {
			User user = userService.getUserById(userId);
			boolean iscol = false;
			if (user != null && (user.getIsCollector() == 1)) {
				iscol = true;
			}
			user.setIsCollectorB(iscol);
			userForm.setUser(user);
			// 绑定角色到form
			userForm.setOper((short) 2);
		}
		model.addAttribute("editForm", userForm);
		model.addAttribute("orgsList", orgsList);
		return "system/editUser";
	}

	/**
	 * 保存用户信息
	 */
	@RequestMapping(params = "method=saveUser" , method = RequestMethod.POST)
	public String saveUser(HttpServletRequest request , ModelMap model , UserForm userForm) {
		try {
			if (userForm.getOper() == 1) {
				if (userService.ifRegAcctUsed(userForm.getUser().getLoginId())) {
					model.addAttribute("system_message", "‘"+ userForm.getUser().getLoginId()+ "’ has been registered! ");
					return "common/errorTip";
				}
				// 默认设置
				User user = userForm.getUser();
				if (user != null)
					user.setIsCollector(user.getIsCollectorB() ? 1 : 0);
				user.setPassword(MD5Util.MD5Encode(SysConstants.INIT_LOGIN_PASSWORD)); // 默认密码
				// 保存用户
				userService.saveUser(user);
				if (user.getC_errcode() > 0)
					throw new Exception(user.getC_errmsg());
			} else if (userForm.getOper() == 2) {
				User user = userForm.getUser();
				if (user != null){
					user.setPassword(MD5Util.MD5Encode(SysConstants.INIT_LOGIN_PASSWORD));
				}
				userService.updateUser(userForm);
				if (user.getC_errcode() > 0)
					throw new Exception(user.getC_errmsg());
			}
		} catch (Exception e) {
			model.addAttribute("system_message", e.getMessage());
			return "common/errorTip";
		}
		// 设置保留参数
		return "common/successTip";
	}

	/**
	 * 删除用户，需要判断：当该用户下有正在进行的订单，或有欠款时，不可进行删除
	 */
	@ResponseBody
	@RequestMapping(params = "method=deleteUser")
	public ResulstMessage deleteUser(HttpServletRequest request , ModelMap model , Long userId) {

		ResulstMessage message = new ResulstMessage();
		User user = userService.getUserById(userId);
		Integer count = 0;
		try {
			count = userService.judgeIfCanDelete(userId);
			if (count > 0) {
				message.setMessage("Cannot delete a user with outstanding debt or order");
			} else {
				userService.deleteUser(user);
			}
		} catch (Exception e) {
			logger.error("删除用户出现异常,异常信息:" + e.getMessage(), e);
		}
		return message;
	}

	// 重置密码
	@RequestMapping(params = "method=resetPwd")
	public String resetPwd(HttpServletRequest request , ModelMap model , Long userId) {

		User user = userService.getUserById(userId);
		try {
			user.setPassword(MD5Util.MD5Encode(SysConstants.INIT_LOGIN_PASSWORD));
			userService.updatePwd(user);
		} catch (Exception e) {
			model.addAttribute("system_message", e.getMessage());
			return "common/errorTip";
		}
		// 设置保留参数
		return "common/successTip";
	}

	@Autowired
	private MarketPwdService marketManagerPwdService;

	// 重置市场管理员的交易密码
	@RequestMapping(params = "method=resetTransPwd")
	public String resetTransPwd(HttpServletRequest request , ModelMap model , Long userId) {
		/* User user = userService.getUserById(userId); */
		MarketManager marketManager = marketManagerPwdService.getMarketById(userId);
		try {
			marketManager.setTransPass(MD5Util.MD5Encode(SysConstants.INIT_LOGIN_PASSWORD));
			marketManagerPwdService.updatePwd(marketManager);
		} catch (Exception e) {
			model.addAttribute("system_message", e.getMessage());
			return "common/errorTip";
		}
		// 设置保留参数
		return "common/successTip";
	}

	/**
	 * 锁定/解锁用户
	 * 
	 * @throws Exception
	 */
	@RequestMapping(params = "method=changeUserActive")
	public String changeUserActive(HttpServletRequest request , ModelMap model , String fl , Long userId ,
			Integer status) throws Exception {

		String actTip = "";
		if (status.equals("0"))
			actTip = "锁定";
		if (status.equals("1"))
			actTip = "激活";
		User user = userService.getUserById(userId);
		try {
			if (fl != null && fl.equals("confirm")) {
				model.addAttribute("title", "确定要" + actTip + "该用户吗？");
				model.addAttribute("submitUrl", "sysUser.do?method=changeUserActive&userId=" + userId + "&active="
						+ status);
				return "system/confirm";
			}
			user.setStatus(status);
			userService.changeUserActive(user);
			String sI = "";
			if (status.equals("0"))
				sI = SpringContextUtil.getMessage("userInfo.userLockSuc", request);
			if (status.equals("1"))
				sI = SpringContextUtil.getMessage("userInfo.userActiveSuc", request);
		} catch (Exception e) {
			model.addAttribute("system_message", e.getMessage());
			String fI = "";
			if (status.equals("0"))
				fI = SpringContextUtil.getMessage("userInfo.userLockFail", request);
			if (status.equals("1"))
				fI = SpringContextUtil.getMessage("userInfo.userActiveFail", request);
			return "common/errorTip";
		}
		// 设置保留参数
		model.addAttribute("reservedHrefURL", "sysUser.do?method=list");
		return "common/successTip";
	}

	/**
	 * 修改密码
	 */
	@RequestMapping(params = "method=initChangePwd")
	public String initchangePwd(HttpServletRequest request , ModelMap model) {

		User user = (User) request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		model.addAttribute("loginId", user.getLoginId());
		return "system/changePwd";
	}

	@RequestMapping(params = "method=ChangePwd")
	public String changePwd(HttpServletRequest request , ModelMap model) {

		User user = (User) request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		String pass = request.getParameter("password2");
		if (pass == "" || pass == null) {
			model.addAttribute("system_message", "password not valided");
			return "common/errorTip";
		} else if (pass.length() != 6 || !pass.matches("[0-9]{6}")) {
			model.addAttribute("system_message", "password not valided");
			return "common/errorTip";
		}
		try {
			user.setPassword(MD5Util.MD5Encode(pass));
			userService.updatePwd(user);
		} catch (Exception e) {
			model.addAttribute("system_message", e.getMessage());
			return "common/errorTip";
		}
		return "system/successChangePassTip";
	}

	@ResponseBody
	@RequestMapping(params = "method=confirmPass")
	public String confirmPass(HttpServletRequest request) {

		long userid = ((User) request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION)).getId();
		String oldPass = request.getParameter("pass");
		if (oldPass == "" || oldPass == null) {
			return "error";
		}
		String md5Pass = MD5Util.MD5Encode(oldPass);
		User user = userService.getUserById(userid);
		String nowPass = user.getPassword();
		if (nowPass.equals(md5Pass)) {
			return "success";
		} else
			return "error";
	}

	// 保存密码
	@RequestMapping(params = "method=updatePwd")
	public String updatePwd(HttpServletRequest request , ModelMap model , UserForm userForm) {

		if (!userService.ajaxIfExPwdSame(userForm.getEx_password(), userForm.getUser().getId())) {
			String wrongInfo = SpringContextUtil.getMessage("userInfo.originalPassWrong", request);
			model.addAttribute("system_message", wrongInfo);
			return "common/errorTip";
		}
		User user = userForm.getUser();
		try {
			user.setPassword(MD5Util.MD5Encode(user.getPassword()));
			userService.updatePwd(user);
		} catch (Exception e) {
			model.addAttribute("system_message", e.getMessage());
			return "common/errorTip";
		}
		// 设置保留参数
		model.addAttribute("reservedHrefURL", "sysUser.do?method=list");
		return "common/successTip";
	}

	/* 用户详情 */
	@RequestMapping(params = "method=userDetail")
	public String userDetail(HttpServletRequest request , ModelMap model) {

		String userId = request.getParameter("userId");
		User user = userService.getUserDetail(userId);
		model.addAttribute("user", user);
		return "system/userDetail";
	}
}
