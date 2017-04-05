package cls.pilottery.pos.common.interceptior;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import cls.pilottery.common.constants.RedisConstants;
import cls.pilottery.common.service.RedisService;
import cls.pilottery.common.utils.MD5Util;
import cls.pilottery.pos.common.constants.PosConstant;
import cls.pilottery.pos.common.model.BaseRequest;
import cls.pilottery.pos.common.model.BaseResponse;
import cls.pilottery.pos.common.model.UserToken;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.serializer.SerializerFeature;

/**
 * 登陆校验
 * @author Administrator
 */
public class LoginInterceptor implements HandlerInterceptor{
	private static Logger log = Logger.getLogger(LoginInterceptor.class); 
	@Autowired
	private RedisService redisService;
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		String req = (String)request.getAttribute("req");
		String md5 = req.substring(0, 32);
		String reqParamJson = req.substring(32,req.length());
		log.info("请求数据，requestData："+reqParamJson);
		try {
			if(md5!=null && md5.equals(MD5Util.MD5Encode(reqParamJson))){
				log.debug("MD5校验通过");
				BaseRequest reqParam = JSON.parseObject(reqParamJson,BaseRequest.class);
				request.setAttribute("req", reqParam);
				
				if(reqParam != null && !"010001".equals(reqParam.getMethod()) && !"010009".equals(reqParam.getMethod()) && !"888888".equals(reqParam.getMethod())){
					UserToken ut = redisService.getObject(UserToken.class,reqParam.getToken());
					if(ut == null){
						log.info("登陆超时或未登陆或在其他设备登陆");
						BaseResponse res = new BaseResponse(10010);
						request.setAttribute("res", res);
						return true;
					}else if(ut.getMsn() == reqParam.getMsn()){
						log.info("请求消息重复");
						BaseResponse res = new BaseResponse(10011);
						request.setAttribute("res", res);
						return true;
					}else{
						ut.setMsn(reqParam.getMsn());
						redisService.setObject(reqParam.getToken(), ut);
						redisService.expire(reqParam.getToken(), PosConstant.SESSION_TIMEOUT);
						//log.debug("设置token超时时间,token:"+reqParam.getToken()+"  超时时间："+PosConstant.SESSION_TIMEOUT);
						redisService.expire(RedisConstants.USER_LOGIN_ERROE_TIMES_KEY+ut.getLoginId(), PosConstant.SESSION_TIMEOUT);
						//log.debug("设置user超时时间,token:"+RedisConstants.USER_LOGIN_ERROE_TIMES_KEY+ut.getLoginId()+"  超时时间："+PosConstant.SESSION_TIMEOUT);
					}
				}
			}else{
				log.info("MD5校验不通过");
				BaseResponse res = new BaseResponse(10001);
				request.setAttribute("res", res);
				return true;
			}
		} catch (Exception e) {
			e.printStackTrace();
			log.error("认证请求时出现异常", e);
			BaseResponse res = new BaseResponse(10001);
			request.setAttribute("res", res);
			return true;
		}
		
		return true;
	}
	
	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView model) throws Exception {
		BaseResponse res = (BaseResponse)request.getAttribute("res");
		String json = JSON.toJSONString(res,SerializerFeature.WriteMapNullValue);
		request.setAttribute("res", json);
		log.debug("将响应对象转换响应json字符串成功。");
		log.info("响应数据，responseData:"+json);
	}
	
	@Override
	public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception exception) throws Exception {
		
	}


}
