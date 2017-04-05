package cls.pilottery.common.filter;


import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;

import cls.pilottery.common.constants.SysConstants;
import cls.pilottery.common.utils.PropertiesUtil;
import cls.pilottery.web.system.model.User;

/**
 * 项目名：泰山无纸化平台 
 * 文件名：LoginFilter.java
 * 类描述：用户登录过滤器，校验用户是否已经登录或是否超时
 * 创建人：huangchengyuan@chinalotsynergy.com
 * 日期：2015-8-21-上午09:57:06
 * 版本信息：v1.0.0
 * Copyright (c) 2015华彩控股有限公司-版权所有
 */
public class LoginFilter implements Filter {

	private static Logger log = Logger.getLogger(LoginFilter.class); 
	
	@Override
	public void destroy() {
		
	}

	@Override
	public void doFilter(ServletRequest arg0, ServletResponse arg1,
			FilterChain chain) throws IOException, ServletException {
		
		HttpServletRequest request = (HttpServletRequest) arg0;
        HttpServletResponse response = (HttpServletResponse) arg1;
        HttpSession session = request.getSession();

        String path = request.getRequestURI(); 
        String queryString = request.getQueryString();  
        
        User user = (User)session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
        
        if(path.indexOf("/pos.do") > -1 || path.indexOf("/ncp.do") > -1 || path.indexOf("/fti.do") > -1  || path.indexOf("/login.jsp") > -1 || path.indexOf("/validator.do") > -1 || 
        		path.indexOf("/login.do") > -1 || path.indexOf("/loginForbiddenTip.jsp") > -1 ) {
            chain.doFilter(request, response);
            return;
        }
        
        int httpPort = Integer.parseInt(PropertiesUtil.readValue("httpServerPort"));
        int isTestSystem = Integer.parseInt(PropertiesUtil.readValue("isTestSystem"));
        if((path.indexOf("/pos.do") == -1 || path.indexOf("/ncp.do") == -1) && request.getServerPort() == httpPort && isTestSystem == 0){
        	response.sendRedirect("views/loginForbiddenTip.jsp");
        	return;
        }
        
        if (user==null ||user.getLoginId() == null || StringUtils.isEmpty(user.getLoginId())) {
            response.sendRedirect(request.getContextPath());
        } else {
        	log.info("用户"+user.getLoginId()+"访问页面"+path+"?"+queryString);
            chain.doFilter(request, response);
        }
	}

	@Override
	public void init(FilterConfig arg0) throws ServletException {
		
	}

}