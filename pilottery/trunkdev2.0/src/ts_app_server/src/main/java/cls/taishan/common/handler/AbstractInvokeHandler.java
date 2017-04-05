package cls.taishan.common.handler;

import cls.taishan.common.helper.FastJsonHelper;
import cls.taishan.common.model.BaseMessage;
import cls.taishan.common.model.BaseResponse;
import io.vertx.core.http.HttpHeaders;
import io.vertx.core.http.HttpServerRequest;
import io.vertx.ext.web.RoutingContext;
import lombok.extern.log4j.Log4j;

/**
 * 所有handler需要继承该Handler
 * 
 * @author huangchy
 *
 * @2016年8月28日
 *
 */
@Log4j
public abstract class AbstractInvokeHandler implements InvokeHandler<RoutingContext> {

	@Override
	public void handle(RoutingContext event) {
		event.response().headers().set(HttpHeaders.CONTENT_TYPE, DEFAULT_CONTENT_TYPE);
		event.response().setChunked(true);
		
		BaseMessage<BaseResponse> result = new BaseMessage<BaseResponse>();
		
		HttpServerRequest request = event.request();
		String token = request.getParam("token");
		String transType = request.getParam("transType"); 
		String transMessage = event.get("transMessage"); 
		log.debug(transMessage);
		try {
			result = invoke(event, transMessage);
		} catch (Exception e) {
			log.error("处理异常", e);
			BaseResponse res = new BaseResponse(500);
			result.setBody(res);
			result.setToken(token);
			result.setTransType(Integer.parseInt(transType));
		} finally {
			event.put("transMessage", FastJsonHelper.converter(result));
			event.reroute("/encrypt.do");
			
			log.debug("AbstractInvokeHandler处理完成");
			//event.response().write(resultJson,CommonConstant.DEFAULT_CHARSET ).end();
		}
	}	

}
