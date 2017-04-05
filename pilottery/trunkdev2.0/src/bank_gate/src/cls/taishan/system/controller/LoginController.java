package cls.taishan.system.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import cls.taishan.common.constants.RedisConstants;
import cls.taishan.common.constants.SysConstants;
import cls.taishan.common.service.RedisService;
import cls.taishan.common.utils.LocaleUtil;
import cls.taishan.common.utils.MD5Util;
import cls.taishan.system.form.ChangePwdForm;
import cls.taishan.system.model.User;
import cls.taishan.system.model.UserLanguage;
import cls.taishan.system.model.UserLoginInfo;
import cls.taishan.system.service.UserService;


@Controller
@RequestMapping("login")
public class LoginController {
	private static Logger log = Logger.getLogger(LoginController.class); 
	
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
        /*if (!validatorCode.equals(request.getSession().getAttribute("validatorCode"))) {
        	if(userLang !=null && userLang.equals("ZH")){
        		model.addAttribute("errorMsg","验证码错误!");
        	}else{
        		model.addAttribute("errorMsg","Verification code error!");
        	}
            return "login";
        }*/
        
		UserLoginInfo ul = null;
		try {
			ul = (UserLoginInfo) redisService.getObject(RedisConstants.USER_LOGIN_ERROE_TIMES_KEY + regAcct);
		} catch (Exception e) {
			log.info(e);
		}
		if (ul == null) {
			ul = new UserLoginInfo();
			ul.setLoginName(regAcct);
		}
        
        User user = userService.getUserByLogin(regAcct);
        if (user == null || user.getStatus() ==2) {
        	if(userLang !=null && userLang.equals("ZH")){
        		model.addAttribute("errorMsg","用户不存在!");
        	}else{
        		model.addAttribute("errorMsg", "User is not exist!");
        	}
            
            return "login";
        }
        if(user.getStatus() != 1){
        	if(userLang !=null && userLang.equals("ZH")){
         		model.addAttribute("errorMsg", "账户被锁定!");
         	}else{
         		model.addAttribute("errorMsg", "The account is locked!");
         	}
             return "login";
        }
        if (!MD5Util.MD5Encode(regPwd).equals(user.getPassword())) {
        	int times = ul.getPwdErrorTimes();
        	if(times == RedisConstants.USER_LOGIN_ERROR_TIMES - 1){
        		times++;
        		log.info("连续登录五次失败，账户锁定:"+regAcct);
        		user.setStatus(3);
        		userService.updateUserStatus(user);
        		ul.setPwdErrorTimes(0);
        	}else{
        		times++;
        		ul.setPwdErrorTimes(times);
        	}
        	redisService.setObject(RedisConstants.USER_LOGIN_ERROE_TIMES_KEY+regAcct, ul);
            
            if(userLang !=null && userLang.equals("ZH")){
            	model.addAttribute("errorMsg", "密码错误，你还有"+(RedisConstants.USER_LOGIN_ERROR_TIMES-times)+"次机会");
         	}else{
         		model.addAttribute("errorMsg", "Password is wrong. You have "+(RedisConstants.USER_LOGIN_ERROR_TIMES-times)+" chances");
         	}
            return "login";
        } 
        
		if (userLang.equals("EN")) {
			user.setUserLang(UserLanguage.EN);
		} else {
			user.setUserLang(UserLanguage.ZH);
		}
		
        ul.setIsLogin(1);
        ul.setLoginDevice("1");
        ul.setLastLoginTime(System.currentTimeMillis());
        ul.setPwdErrorTimes(0);
        redisService.setObject(RedisConstants.USER_LOGIN_ERROE_TIMES_KEY+regAcct, ul);
        
        //密码是初始密码，需修改密码
        if(regPwd.equals(SysConstants.INIT_LOGIN_PASSWORD)){
        	 log.info("用户："+user.getLoginId()+"登陆成功，但密码是初始密码，跳转至修改密码页面");
        	 request.setAttribute("loginId", regAcct);
        	 if (userLang.equals("EN")) {
     			return "system/changePwd";
     		} else {
     			return "system/changePwd_zh";
     		}
        }
        request.getSession().setAttribute(SysConstants.CURR_LOGIN_USER_SESSION, user);
        log.info("用户："+user.getLoginId()+"登陆成功");
        return "redirect:/index.do";
    }
    
    /**
     * 安全退出
     */
    @RequestMapping(params = "method=exit")
    public String exit(HttpServletRequest request, HttpServletResponse response) {
        return "redirect:/";
    }
    
    @RequestMapping(params = "method=changePwd")
    @ResponseBody
    public String changePwd(HttpServletRequest request, HttpServletResponse response,ChangePwdForm form) {
    	try {
			User user = userService.getUserByLogin(form.getLoginId());
			if(!MD5Util.MD5Encode(form.getOldPwd()).equals(user.getPassword())){ //密码不正确
				return "-1";
			}
			user.setPassword(MD5Util.MD5Encode(form.getNewPwd()));
			userService.updatePwd(user);
			
		} catch (Exception e) {
			e.printStackTrace();
			log.error(e);
			return "-2";
		}
        return "1";
    }
}
