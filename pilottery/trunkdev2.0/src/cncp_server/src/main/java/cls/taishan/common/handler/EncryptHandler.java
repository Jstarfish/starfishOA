package cls.taishan.common.handler;

import cls.taishan.common.constant.CommonConstant;
import cls.taishan.common.encrypt.RSASignature;
import cls.taishan.common.helper.FastJsonHelper;
import cls.taishan.common.utils.VertxConfiguration;
import io.vertx.core.Handler;
import io.vertx.core.http.HttpHeaders;
import io.vertx.core.http.HttpServerRequest;
import io.vertx.ext.web.RoutingContext;
import lombok.extern.log4j.Log4j;

/**
 * 对相应消息进行加密或签名
 * 
 * @author huangchy
 *
 * @2016年9月8日
 *
 */
@Log4j
public class EncryptHandler implements Handler<RoutingContext> {

	@Override
	public void handle(RoutingContext event) {
		log.debug("对数据进行签名加密……");
		
		event.response().headers().set(HttpHeaders.CONTENT_TYPE, CommonConstant.DEFAULT_CHARSET);
		event.response().setChunked(true);
		
		HttpServerRequest request = event.request();
		String token = request.getParam("token");
		String transType = request.getParam("transType"); 
		String transMessage = event.get("transMessage");
		
		String signstr=RSASignature.sign(transMessage,VertxConfiguration.configStr("cls_privateKey")); 
		
		String bodyString = FastJsonHelper.joinPostParam(token, transType, transMessage, signstr);
		log.info("返回消息,内容如下：");
		log.info(bodyString);
		event.response().write(bodyString,CommonConstant.DEFAULT_CHARSET ).end();
	}

}
