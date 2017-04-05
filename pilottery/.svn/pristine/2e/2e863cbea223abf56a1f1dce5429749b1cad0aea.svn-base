package cls.pilottery.web.system.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import cls.pilottery.common.constants.SysConstants;
import cls.pilottery.common.utils.LocaleUtil;
import cls.pilottery.common.utils.PropertiesUtil;
import cls.pilottery.web.system.model.Privilege;
import cls.pilottery.web.system.model.User;
import cls.pilottery.web.system.service.PrivilegeService;

@Controller
@RequestMapping("index")
public class IndexController {
	@Autowired
	private PrivilegeService privilegeService;
	
    @RequestMapping(params = "method=mainRequest")
    public String mainRequest(HttpServletRequest request,HttpServletResponse response) {
    	return LocaleUtil.getUserLocalePath("_main/main", request);
    }

    @RequestMapping(params="method=logout")
    public String logout(HttpServletRequest request,HttpServletResponse response) {
        
        try {
            request.getSession().invalidate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "login";
    }
    
    @RequestMapping
    public String index(HttpServletRequest request,HttpServletResponse response) {
    	String system = request.getParameter("sys");
    	List<Privilege> list = null;
    	User user = (User)request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
    	if( user== null || StringUtils.isNotEmpty(system)){
    		list = privilegeService.getPrivilegeByUserId(user.getId(),system);
    		request.setAttribute("user_privilege_list", list);
    		request.setAttribute("omsUrl", PropertiesUtil.readValue("system.OMS"));
            request.setAttribute("pilotteryUrl", PropertiesUtil.readValue("system.pilottery"));
    		return LocaleUtil.getUserLocalePath("_main/index", request);
    	}else{
    		return "login";
    	}
    }

}
