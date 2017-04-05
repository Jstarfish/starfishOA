package cls.taishan.common.handler;

import cls.taishan.common.model.BaseMessage;
import cls.taishan.common.model.BaseResponse;
import io.vertx.ext.web.RoutingContext;

public interface InvokeHandler<E> extends StandardInvokeHandler<E>{

	BaseMessage<BaseResponse> invoke(RoutingContext event,String jsonBody) throws Exception;

}
