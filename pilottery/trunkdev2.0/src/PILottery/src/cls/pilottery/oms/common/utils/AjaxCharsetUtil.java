package cls.pilottery.oms.common.utils;


import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;

import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.codehaus.jackson.map.ObjectMapper;

/*
 * add by dzg
 * 用于处理中文编码及其相关函数
 */
public final class AjaxCharsetUtil {

	static Logger logger2 = Logger.getLogger(AjaxCharsetUtil.class);
	
	private static String OrigCharEncoding = "UTF-8";
	private static String NewCharEncoding = "ISO-8859-1";
	private static String ContentType = "text/html";

	/*
	 * 解码中文，用于处理中文的乱码问题 。
	 * 如果为空，或者异常则返回null
	 */
	public static String getDecodeString(HttpServletRequest request,
			String paraname, boolean isneedtrim) {
		String strRet = null;

		String objs = request.getParameter(paraname);
		if (StringUtils.isNotBlank(objs)) {

			try {
				objs = URLDecoder.decode(objs, OrigCharEncoding);
				objs = new String(objs.getBytes(NewCharEncoding),
						OrigCharEncoding);
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}
			
			if(isneedtrim)
				strRet = objs.trim();
		}
		return strRet;
	}

	/*
	 * 输出指定对象的组成的指定编码的字符串
	 */
	public static void outJsonChineseStr(HttpServletResponse response,Object obj)
	{
		ObjectMapper mapper = new ObjectMapper();
        String json = "";

        try
        {
            json = mapper.writeValueAsString(obj);
            //System.out.println(json);
            response.setCharacterEncoding(OrigCharEncoding); //设置编码格式
            response.setContentType(ContentType);   //设置数据格式
            PrintWriter out = response.getWriter(); //获取写入对象
            out.print(json); //将json数据写入流中
            out.flush();
        }
        catch(Exception e)
        {
            e.getMessage();
        }
	}
	
	/*
	 * add by dzg 2014-10-24 解决登陆问题
	 * 
	 * response servlet输出信息
	 * tipinfo 提示信息
	 * url 输出提示
	 * isclean 是否清理缓存
	 */
	public static void outputReponseHtml(ServletResponse response,String tipinfo,String url) {
		
		if(response == null)
			return;
		StringBuilder sb = new StringBuilder();
		sb.append("<script type=\"text/javascript\">");
		sb.append("if (confirm(\"").append(tipinfo).append("\")){");
		sb.append("top.location.href = \"").append(url).append("\";");
		sb.append("}");
		sb.append("</script>");
		
		try {
			
			logger2.info("time out:"+sb.toString());
			response.getWriter().println(sb.toString());			
			
		} catch (IOException e) {						
			logger2.error(e);
		}
		
	}
	
}
