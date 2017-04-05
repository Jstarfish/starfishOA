package cls.taishan.common.handler.impl;

import java.util.HashMap;
import java.util.Map;

import javax.inject.Singleton;

import com.alibaba.fastjson.JSONObject;

import cls.taishan.common.handler.ExceptionHandler;
import io.vertx.ext.web.RoutingContext;
import lombok.extern.log4j.Log4j;

/**
 * 
 * @author huangchy
 *
 * @2016年8月31日
 *
 */
@Singleton
@Log4j
public class ExceptionHandlerImpl implements ExceptionHandler {

	@Override
	public void handle(RoutingContext context) {
		int code = 1;
		String msg = "";
		Map<String, Object> map = new HashMap<String, Object>();

		if (context.failed()) {
			Throwable failure = context.failure();
			if (failure != null) {
				msg = failure.getMessage();
			}
			int statusCode = context.statusCode();
			if (statusCode < 400) {
				context.response().setStatusCode(400);
			} else {
				context.response().setStatusCode(statusCode);
			}
			map.put("errorCode", code);
			map.put("errorMessage", msg);
			log.error("Exception[errorCode:" + code + ",errorMessage:" + msg + "]");
			context.response().end(JSONObject.toJSONString(map));
		}
	}

}
