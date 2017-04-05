package cls.pilottery.common.export.encodingfilter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;

public class EncodingFilter implements Filter{

	private static String encoding="UTF-8";

	@Override
	public void doFilter(ServletRequest request, ServletResponse response,
			FilterChain chain) throws IOException, ServletException {
		
		request.setCharacterEncoding(EncodingFilter.encoding);
		response.setCharacterEncoding(EncodingFilter.encoding);
		
		chain.doFilter(request,response);
		
	}

	@Override
	public void init(FilterConfig config) throws ServletException {
		String charset=config.getInitParameter("encoding");
		if(null!=charset && !"".equals(charset.trim())){
			EncodingFilter.encoding=charset;
		}
	}
	
	@Override
	public void destroy() {
		
	}

}
