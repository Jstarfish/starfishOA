package cls.pilottery.web.system.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import cls.pilottery.common.constants.RedisConstants;
import cls.pilottery.common.constants.SysConstants;
import cls.pilottery.common.model.UserLoginInfo;
import cls.pilottery.common.service.RedisService;
import cls.pilottery.common.utils.LocaleUtil;
import cls.pilottery.common.utils.MD5Util;
import cls.pilottery.common.utils.PropertiesUtil;
import cls.pilottery.web.system.model.Privilege;
import cls.pilottery.web.system.model.User;
import cls.pilottery.web.system.model.UserLanguage;
import cls.pilottery.web.system.service.PrivilegeService;
import cls.pilottery.web.system.service.UserService;

@Controller
@RequestMapping("login")
public class LoginController {
	private static Logger log = Logger.getLogger(LoginController.class); 
	
	@Autowired
	private PrivilegeService privilegeService;
	
	@Autowired
	private UserService userService;
	
	@Autowired
	private RedisService redisService;

    @RequestMapping(method = RequestMethod.POST)
    public String doLogin(HttpServletRequest request,HttpServletResponse response, ModelMap model) {
    	
    	String regAcct = request.getParameter("regAcct");
        String regPwd = request.getParameter("regPwd");
        String validatorCode = request.getParameter("validatorCode");
        String userLang=request.getParameter("userLang");
        // 随机验证码
        if (!validatorCode.equals(request.getSession().getAttribute("validatorCode"))) {
        	if(userLang !=null && userLang.equals("ZH")){
        		model.addAttribute("errorValidatorCodeMsg","验证码错误!");
        	}else{
        		model.addAttribute("errorValidatorCodeMsg","Verification code error!");
        	}
            return "login";
        }
        
        UserLoginInfo ul = null;
        	
        try
        {
        	ul =(UserLoginInfo)redisService.getObject(RedisConstants.USER_LOGIN_ERROE_TIMES_KEY+regAcct);
        }catch (Exception e) {
        	log.info(e);
		}
        if(ul == null){
        	ul = new UserLoginInfo();
        	ul.setLoginName(regAcct);
        }
        
        User user = userService.getUserByLogin(regAcct);
        if (user == null) {
        	if(userLang !=null && userLang.equals("ZH")){
        		model.addAttribute("errorAccountMsg","用户不存在!");
        	}else{
        		model.addAttribute("errorAccountMsg", "User is not exist!");
        	}
            
            return "login";
        }
        if(user.getStatus() != 1){
        	 
        	if(userLang !=null && userLang.equals("ZH")){
         		model.addAttribute("errorAccountMsg", "账户被锁定!");
         	}else{
         		model.addAttribute("errorAccountMsg", "The account is locked!");
         	}
             return "login";
        }
        if (!MD5Util.MD5Encode(regPwd).equals(user.getPassword())) {
        	int times = ul.getPwdErrorTimes();
        	if(times == RedisConstants.USER_LOGIN_ERROR_TIMES - 1){
        		times++;
        		log.info("连续登录五次失败，账户锁定:"+regAcct);
        		user.setStatus(3);
        		userService.changeUserActive(user);
        		ul.setPwdErrorTimes(0);
        	}else{
        		times++;
        		ul.setPwdErrorTimes(times);
        	}
        	redisService.setObject(RedisConstants.USER_LOGIN_ERROE_TIMES_KEY+regAcct, ul);
            
            if(userLang !=null && userLang.equals("ZH")){
            	model.addAttribute("errorAccountMsg", "密码错误，你还有"+(RedisConstants.USER_LOGIN_ERROR_TIMES-times)+"次机会");
         	}else{
         		model.addAttribute("errorAccountMsg", "Password is wrong. You have "+(RedisConstants.USER_LOGIN_ERROR_TIMES-times)+" chances");
         	}
            return "login";
        } 
        
        List<Privilege> list = privilegeService.getPrivilegeByUserId(user.getId(),null);
        if(userLang.equals("EN")){
            user.setUserLang(UserLanguage.EN);
          }
          else{
            	user.setUserLang(UserLanguage.ZH);
          }
        request.getSession().setAttribute(SysConstants.CURR_LOGIN_USER_SESSION, user);
        request.setAttribute("user_privilege_list", list);
        request.setAttribute("omsUrl", PropertiesUtil.readValue("system.OMS"));
        request.setAttribute("pilotteryUrl", PropertiesUtil.readValue("system.pilottery"));
        //request.setAttribute("misUrl", PropertiesUtil.readValue("system.MIS"));
        //request.setAttribute("monitorUrl", PropertiesUtil.readValue("system.monitor"));
        
        //ul.setIsLogin(1);
        //ul.setLoginDevice("1");
        //ul.setLastLoginTime(System.currentTimeMillis());
        ul.setPwdErrorTimes(0);
        redisService.setObject(RedisConstants.USER_LOGIN_ERROE_TIMES_KEY+regAcct, ul);
        
        //密码是初始密码，需修改密码
        if(regPwd.equals(SysConstants.INIT_LOGIN_PASSWORD)){
        	 log.info("用户："+user.getLoginId()+"登陆成功，但密码是初始密码，跳转至修改密码页面");
        	 request.setAttribute("loginId", regAcct);
        	 return LocaleUtil.getUserLocalePath("system/changePwd", request);
        }
        
        log.info("用户："+user.getLoginId()+"登陆成功");
        return LocaleUtil.getUserLocalePath("_main/index", request);
    }
    
    /**
     * 安全退出
     */
    @RequestMapping(params = "method=exit")
    public String exit(HttpServletRequest request, HttpServletResponse response) {
        return "redirect:/";
    }
}