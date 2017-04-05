package cls.pilottery.web.system.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import cls.pilottery.common.constants.SysConstants;
import cls.pilottery.common.utils.MD5Util;
import cls.pilottery.common.utils.SpringContextUtil;
import cls.pilottery.web.capital.model.MarketManager;
import cls.pilottery.web.system.form.UserForm;
import cls.pilottery.web.system.model.User;
import cls.pilottery.web.system.service.MarketPwdService;
import cls.pilottery.web.system.service.UserService;

/**
 * 修改市场管理员的交易密码
 * @author jhx
 */
@Controller
@RequestMapping("/marketManagerPwd")
public class MarketPwdController {
	static Logger logger = Logger.getLogger(MarketPwdController.class);
	
	@Autowired
	private MarketPwdService marketManagerPwdService;
	
	/**
	 * 修改密码
	 */
	@RequestMapping(params = "method=changeMarketManagerPwd")
	public String initchangePwd(HttpServletRequest request , ModelMap model,HttpSession session) {
		User currentUser = (User) request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		model.addAttribute("loginId", currentUser.getLoginId());
		return "system/changMarketManagerPwd";
	}
	
	@RequestMapping(params = "method=ChangePwd")
	public String changePwd(HttpServletRequest request , ModelMap model) {
		MarketManager marketManager = new MarketManager();
		User currentUser = (User) request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		String pass = request.getParameter("password");
		if(pass == "" || pass == null){
			model.addAttribute("system_message", "password length not valid");
			return "common/errorTip";
		}else if (pass.length() != 6|| (!pass.matches("[0-9]{6}"))) {
			model.addAttribute("system_message", "password not valid");
			return "common/errorTip";
		}
		try {
			marketManager.setMarketAdmin(currentUser.getId());
			marketManager.setTransPass(MD5Util.MD5Encode(pass));
			//user.setPassword(MD5Util.MD5Encode(pass));
			//userService.updatePwd(user);
			marketManagerPwdService.updatePwd(marketManager);
		} catch (Exception e) {
			model.addAttribute("system_message", e.getMessage());
			return "common/errorTip";
		}
		return "system/changeTransPwdSuccessTip";
	}

	@ResponseBody
	@RequestMapping(params = "method=confirmPass")
	public String confirmPass(HttpServletRequest request) {
		long userid = ((User) request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION)).getId();
		String oldPass = request.getParameter("pass");
		String md5Pass=MD5Util.MD5Encode(oldPass);
		MarketManager marketManager = marketManagerPwdService.getMarketById(userid);
		String nowPass = marketManager.getTransPass();
		if (nowPass.equals(md5Pass)) {
			return "success";
		} else
			return "error";
	}
}
