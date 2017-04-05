package cls.taishan.common.handler;

import org.apache.commons.lang3.StringUtils;

import cls.taishan.common.constant.CommonConstant;
import cls.taishan.common.encrypt.RSASignature;
import cls.taishan.common.helper.FastJsonHelper;
import cls.taishan.common.helper.MethodHelper;
import cls.taishan.common.helper.RedisHelper;
import cls.taishan.common.model.BaseMessage;
import cls.taishan.common.model.BaseResponse;
import cls.taishan.common.utils.VertxConfiguration;
import io.vertx.core.Handler;
import io.vertx.core.http.HttpHeaders;
import io.vertx.core.http.HttpServerRequest;
import io.vertx.ext.web.RoutingContext;
import lombok.extern.log4j.Log4j;

/**
 * 请求参数验证Handler
 * 校验请求参数是否合法，数字签名是否正确等
 * 
 * @author huangchy
 *
 * @2016年9月8日
 *
 */
@Log4j
public class ValidationHandler implements Handler<RoutingContext> {

	@Override
	public void handle(RoutingContext event) {
		log.debug("ValidationHandler.handle()");
		event.response().headers().set(HttpHeaders.CONTENT_TYPE, CommonConstant.DEFAULT_CONTENT_TYPE);
		event.response().setChunked(true);
		
		BaseMessage<BaseResponse> result = new BaseMessage<BaseResponse>();
		String json = event.getBodyAsString(CommonConstant.DEFAULT_CHARSET);
		log.info("收到请求消息，内容如下:");
		log.info(json);
		
		HttpServerRequest request = event.request();
		String token = request.getParam("token");
		String transType = request.getParam("transType"); 
		String digest = request.getParam("digest");
		String transMessage = request.getParam("transMessage");
		
		if(StringUtils.isEmpty(json) || StringUtils.isEmpty(token) || StringUtils.isEmpty(transType) || StringUtils.isEmpty(digest) || StringUtils.isEmpty(transMessage)){
			log.error("请求消息内容非法，不做处理");
			return ;
		}
		
		String[] strs = json.split("&transMessage");
		for(String str:strs){
			if(str.startsWith("=")){
				transMessage = str.substring(1);
			}
		}
		
		event.put("token", token);
		event.put("transType", transType);
		event.put("transMessage", transMessage);
		
		try {
			log.debug("校验数字签名……");
			log.debug(transMessage);
			//String key = VertxConfiguration.configStr("agency_publicKey");
			String key = RedisHelper.get(CommonConstant.REDIS_AGENCY_PUBLIC_KEY+token);
					
			boolean flag = RSASignature.doCheck(transMessage, digest, key);
			log.debug("验签结果："+flag);
			
			if(flag){
				log.debug("transType:  "+transType);
				log.debug("rerout url:"+MethodHelper.getMethodUrl(transType));
				event.reroute(MethodHelper.getMethodUrl(transType));
			}else{
				log.error("数字签名校验失败");
				BaseResponse res = new BaseResponse(101);
				result.setBody(res);
				result.setToken(token);
				result.setTransType(Integer.parseInt(transType));
				//Buffer buffer = Buffer.buffer(FastJsonHelper.converter(result), Charset.defaultCharset().name());
				//event.setBody(buffer);
				event.put("transMessage", FastJsonHelper.converter(result));
				event.reroute("/encrypt.do");
			}
			
		} catch (Exception e) {
			log.error("程序处理中出现错误.", e);
			BaseResponse res = new BaseResponse(500);
			result.setBody(res);
			result.setToken(token);
			result.setTransType(Integer.parseInt(transType));
			event.put("transMessage", FastJsonHelper.converter(result));
			event.reroute("/encrypt.do");
		} 
		
	}
	
	public static String getRemoteAddr(final HttpServerRequest request) {
		try{
			String remoteAddr = request.getHeader("X-Forwarded-For");
			// 如果通过多级反向代理，X-Forwarded-For的值不止一个，而是一串用逗号分隔的IP值，此时取X-Forwarded-For中第一个非unknown的有效IP字符串
			if (isEffective(remoteAddr) && (remoteAddr.indexOf(",") > -1)) {
				String[] array = remoteAddr.split(",");
				for (String element : array) {
					if (isEffective(element)) {
						remoteAddr = element;
						break;
					}
				}
			}
			if (!isEffective(remoteAddr)) {
				remoteAddr = request.getHeader("X-Real-IP");
			}
			if (!isEffective(remoteAddr)) {
				remoteAddr = request.remoteAddress().toString();
			}
			return remoteAddr;
		}catch(Exception e){
			log.error("get romote ip error,error message:"+e.getMessage());
			return "";
		}
	}
	
	/**
	 * 获取客户端源端口
	 * @param request
	 * @return
	 */
	public static Long getRemotePort(final HttpServerRequest request){
		try{
			String port = request.getHeader("remote-port");
			if(port != null || port.trim() != "") {
				try{
					return Long.parseLong(port);
				}catch(NumberFormatException ex){
					log.error("convert port to long error , port:	"+port);
					return 0l;
				}
			}else{
				return 0l;
			}		
		}catch(Exception e){
			log.error("get romote port error,error message:"+e.getMessage());
			return 0l;
		}
	}
	
	/**
	 * 远程地址是否有效.
	 * 
	 * @param remoteAddr
	 *            远程地址
	 * @return true代表远程地址有效，false代表远程地址无效
	 */
	private static boolean isEffective(final String remoteAddr) {
		boolean isEffective = false;
		if ((null != remoteAddr) && (!"".equals(remoteAddr.trim()))
				&& (!"unknown".equalsIgnoreCase(remoteAddr.trim()))) {
			isEffective = true;
		}
		return isEffective;
	}

}
