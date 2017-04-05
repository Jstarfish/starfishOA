package cls.pilottery.webncp.common.interceptor;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import cls.pilottery.common.utils.EncryptUtils;
import cls.pilottery.webncp.common.constants.WebncpConstant;
import cls.pilottery.webncp.common.model.BaseRequest;
import cls.pilottery.webncp.common.model.BaseResponse;
import cls.pilottery.webncp.system.model.Response30d4Model;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.serializer.SerializerFeature;

public class WebncpInterceptor implements HandlerInterceptor {
	private static Logger log = Logger.getLogger(WebncpInterceptor.class); 
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		String req = request.getParameter("req");
		log.debug("对请求数据进行解密");
		req = EncryptUtils.decrypt(req, WebncpConstant.ENCRYPT_KEY);
		log.info("解密后的请求数据，requestData："+req);
		
		//BaseRequest reqParam = JSON.parseObject(req,BaseRequest.class);
		request.setAttribute("req", req);
		
		return true;
	}
	
	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView model) throws Exception {
		BaseResponse res = (BaseResponse)request.getAttribute("res");
		String json = JSON.toJSONString(res,SerializerFeature.WriteMapNullValue);
		
		if(res!=null && res.getCMD()==0x2001){	//tds查询公告消息，单独处理
			Response30d4Model result = (Response30d4Model) res;
			json = result.getResultJson();
		}
		
		log.debug("将响应对象转换响应json字符串成功。");
		log.info("响应数据，responseData:"+json);
		log.debug("对响应数据进行加密");
		
		if(res.getCMD()!=0x4090 && res.getCMD() != 0x4091 ){
			json = EncryptUtils.encrypt(json, WebncpConstant.ENCRYPT_KEY);
		}
		ServletOutputStream out = response.getOutputStream();
		out.write(json.getBytes(WebncpConstant.CHAR_SET));
		out.flush();
		
	}
	
	@Override
	public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception exception) throws Exception {
		
	}

}
