package cls.taishan.common.filter;

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

import cls.taishan.common.constants.SysConstants;
import cls.taishan.system.model.User;

public class LoginFilter implements Filter {

	private static Logger log = Logger.getLogger(LoginFilter.class);

	@Override
	public void destroy() {

	}

	@Override
	public void doFilter(ServletRequest arg0, ServletResponse arg1, FilterChain chain)
			throws IOException, ServletException {

		HttpServletRequest request = (HttpServletRequest) arg0;
		HttpServletResponse response = (HttpServletResponse) arg1;
		HttpSession session = request.getSession();

		String path = request.getRequestURI();
		String queryString = request.getQueryString();

		User user = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);

		if (path.indexOf("/login.jsp") > -1 || path.indexOf("/validator.do") > -1 || path.indexOf("/login.do") > -1 || path.indexOf("/API/") > -1) {
			chain.doFilter(request, response);
			return;
		}

		if (user == null || user.getLoginId() == null || StringUtils.isEmpty(user.getLoginId())) {
			response.sendRedirect(request.getContextPath());
		} else {
			log.info("用户" + user.getLoginId() + "访问页面" + path + "?" + queryString);
			chain.doFilter(request, response);
		}
	}

	@Override
	public void init(FilterConfig arg0) throws ServletException {

	}

}