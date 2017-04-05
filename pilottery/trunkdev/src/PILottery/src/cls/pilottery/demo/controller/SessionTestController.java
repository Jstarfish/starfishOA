package cls.pilottery.demo.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import cls.pilottery.web.system.form.UserForm;
import cls.pilottery.web.system.model.User;
import cls.pilottery.common.utils.*;
import cls.pilottery.common.constants.*;

/*******************************************
 * 测试session共享程序
 * 
 * add by dzg
 * 
 * 2015/09/07
 * 
 * 
 ******************************************/
@Controller
@RequestMapping("sessiontest")
public class SessionTestController {

	@RequestMapping(params = "method=test1")
	public String testFunction1(HttpServletRequest request, ModelMap model,
			UserForm userForm) {

		try {
			if (request == null || request.getSession() == null)
				throw new Exception("System Null Pointer");

			User user = (User) request.getSession().getAttribute(
					SysConstants.CURR_LOGIN_USER_SESSION);

			if (user == null)
				throw new Exception("Login Session is Null!");

			request.setAttribute("user", user);

			String ip = IPAdressUtil.getRemoteIP(request);
			request.setAttribute("ip", ip);
			ip = IPAdressUtil.getHttpRealIP(request);
			request.setAttribute("ipr", ip);

		} catch (Exception e) {
			e.printStackTrace();
			request.setAttribute("error", e.getMessage());
		}
		return "demo/sessionTest";
	}
}
