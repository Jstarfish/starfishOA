package cls.taishan.common.module;

import com.google.inject.Binder;
import com.google.inject.Module;

import io.vertx.core.Vertx;
import io.vertx.core.json.JsonObject;

public class GuiceModule implements Module {
  private Vertx vertx;
  private JsonObject config;

  public GuiceModule(Vertx vertx, JsonObject config) {
    this.vertx = vertx;
    this.config = config;
  }

  @Override
  public void configure(Binder binder) {
	  //binder.bind(DemoService.class);
  }
}
