package cls.taishan.common.handler;

import cls.taishan.common.handler.impl.ExceptionHandlerImpl;
import io.vertx.core.Handler;
import io.vertx.ext.web.RoutingContext;

public interface ExceptionHandler extends Handler<RoutingContext> {
  static ExceptionHandler create() {
    return new ExceptionHandlerImpl();
  }
}
