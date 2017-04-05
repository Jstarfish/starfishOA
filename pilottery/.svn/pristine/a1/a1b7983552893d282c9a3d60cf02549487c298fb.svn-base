package cls.taishan.common.verticle;

import java.util.ArrayList;
import java.util.List;

import org.mybatis.guice.XMLMyBatisModule;

import com.google.inject.Guice;
import com.google.inject.Injector;
import com.google.inject.Module;

import cls.taishan.cncp.cmi.handler.IssueNotifyHandler;
import cls.taishan.common.handler.EncryptHandler;
import cls.taishan.common.handler.ExceptionHandler;
import cls.taishan.common.handler.HandlersFactory;
import cls.taishan.common.handler.ValidationHandler;
import cls.taishan.common.helper.RedisHelper;
import cls.taishan.common.module.GuiceModule;
import cls.taishan.common.utils.VertxConfiguration;
import io.vertx.core.AbstractVerticle;
import io.vertx.core.http.HttpClient;
import io.vertx.core.json.JsonObject;
import io.vertx.ext.web.Router;
import io.vertx.ext.web.handler.BodyHandler;
import io.vertx.ext.web.handler.ResponseTimeHandler;
import lombok.extern.log4j.Log4j;

/**
 * 入口Verticle
 * 
 * @author huangchy
 *
 * @2016年8月28日
 *
 */
@Log4j
public class StandardVerticle extends AbstractVerticle {

	private Integer port = VertxConfiguration.configInt("port");
	// private String uploadUrl =
	// VertxConfiguration.configStr("upload.files.url");
	private Injector injector;
	private JsonObject config;

	@Override
	public void start() throws Exception {
		init();
		
		Router router = Router.router(vertx);
		registerGlobalHandler(router);
		HandlersFactory.registerHandlers(router, injector);
		registerNotifyHandler(router);
		vertx.createHttpServer().requestHandler(router::accept).listen(port);
		log.info("Start server at port " + port + " .....");
	}

	private void init() {
		log.info("init...");
		List<Module> modules = new ArrayList<Module>();
		modules.add(new GuiceModule(vertx, config));
		modules.add(new XMLMyBatisModule() {
			@Override
			protected void initialize() {
				//setEnvironmentId("development");
				setClassPathResource("mybatis-config.xml");
			}
		});
		
		injector = Guice.createInjector(modules);
		RedisHelper.createShardedJedisPool();
	}

	private void registerGlobalHandler(Router router) {
		// router.route().handler(BodyHandler.create().setUploadsDirectory(FileUtils.generationFileDirectory(uploadUrl)));
		router.route().failureHandler(ExceptionHandler.create());
		//router.route().handler(StaticHandler.create());
		router.route().handler(ResponseTimeHandler.create());
		// router.route().handler(CookieHandler.create());
		router.route().handler(BodyHandler.create());
		
		router.route("/cncp.do").handler(new ValidationHandler());
		router.route("/encrypt.do").handler(new EncryptHandler());
		
	}

	private void registerNotifyHandler(Router router) {
		IssueNotifyHandler handler = new IssueNotifyHandler();
		router.route("/issueNotify.do").blockingHandler(handler);
		injector.injectMembers(handler);
		
		//针对内部触发的notify消息，使用get方式，不做签名加密
		//router.route("/issueNotify/:gameCode/:issueNumber").handler(new IssueNotifyHandler());
		
	}
}