package cls.taishan.common.interceptor;

import java.util.Iterator;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import cls.taishan.common.constants.SysConstants;
import cls.taishan.system.model.User;

public class OperateLogInterceptor implements HandlerInterceptor {

	private static Logger log = Logger.getLogger("operateLog");

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object obj) throws Exception {
		StringBuilder sb = new StringBuilder();
		//SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
		//sb.append("OprTime:" + sdf.format(System.currentTimeMillis()));

		String path = request.getRequestURI(); 
		if(path.indexOf("/pos.do") > -1 || path.indexOf("/ncp.do") > -1){
			return true;
		}
		if (request != null) {
			User user = (User) request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			if (user != null) {
				sb.append("User:" + user.getId() + "[" + user.getLoginId() + "]");
			} else {
				sb.append("User:" + "null");
			}

			String ipAddr = getIpAddr(request);
			sb.append(";IP:" + ipAddr);
		}

		// 请求参数
		sb.append(";Request URL:" + path);

		// 其他参数
		Map<?, ?> parameters = request.getParameterMap();
		if (parameters != null && parameters.size() > 0) {
			sb.append(";Paramters:{ ");
			for (Iterator<?> iter = parameters.keySet().iterator(); iter.hasNext();) {
				String key = (String) iter.next();
				String[] values = (String[]) parameters.get(key);
				for (int i = 0; i < values.length; i++) {
					sb.append(key).append("=").append(values[i]).append(";");
				}
			}
			sb.append(" }");
		}

		log.info(sb.toString());

		return true;
	}

	@Override
	public void afterCompletion(HttpServletRequest arg0, HttpServletResponse arg1, Object arg2, Exception arg3) throws Exception {

	}

	@Override
	public void postHandle(HttpServletRequest arg0, HttpServletResponse arg1, Object arg2, ModelAndView arg3) throws Exception {

	}

	public static String getIpAddr(HttpServletRequest request) {
		String ip = request.getHeader("x-forwarded-for");
		if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
			ip = request.getHeader("Proxy-Client-IP");
		}
		if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
			ip = request.getHeader("WL-Proxy-Client-IP");
		}
		if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
			ip = request.getRemoteAddr();
		}
		return ip;
	}

}