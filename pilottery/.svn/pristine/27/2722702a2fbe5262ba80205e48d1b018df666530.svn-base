package cls.taishan.system.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import cls.taishan.common.constants.SysConstants;
import cls.taishan.common.utils.LocaleUtil;
import cls.taishan.system.model.Privilege;
import cls.taishan.system.model.User;
import cls.taishan.system.service.PrivilegeService;

@Controller
@RequestMapping("index")
public class IndexController {
	@Autowired
	private PrivilegeService privilegeService;
	
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
    	//String system = request.getParameter("sys");
    	User user = (User)request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
    	
    	if( user!= null ){
    		List<Privilege> list = privilegeService.getPrivilegeByUserId(user.getId(),SysConstants.SYSTEM_BANK_GATE);
        	request.setAttribute("menuList", list);
        	
        	/*request.setAttribute("omsUrl", PropertiesUtil.readValue("system.OMS"));
            request.setAttribute("pilotteryUrl", PropertiesUtil.readValue("system.pilottery"));*/
    		return LocaleUtil.getUserLocalePath("index", request);
    	}else{
    		return "login";
    	}
    }

}
