package cls.taishan;

import org.apache.log4j.PropertyConfigurator;

import cls.taishan.common.verticle.RedisCacheVerticle;
import cls.taishan.common.verticle.StandardVerticle;
import io.vertx.core.Vertx;
import lombok.extern.log4j.Log4j;

/**
 * vertx web服务启动类
 * 
 * @author huangchy
 *
 * @2016年8月31日
 *
 */
@Log4j
public class StartVertxWebServer {

	public static void main(String[] args){
		//PropertyConfigurator.configure(new FileInputStream(new File("log4j.properties")));
		try {
			PropertyConfigurator.configure(StartVertxWebServer.class.getClassLoader().getResource("log4j.properties"));
			log.info("Vertx log4j initialized");
			Vertx.vertx().deployVerticle(new StandardVerticle(), res -> {
				if (res.succeeded()) {
					String deploymentId = res.result();
					log.info("StandardVerticle deployed ok, deploymentId = " + deploymentId);
				} else {
					log.error("StandardVerticle deployed failed", res.cause());
				}
			});
			
			Vertx.vertx().deployVerticle(new RedisCacheVerticle(), res -> {
				if (res.succeeded()) {
					String deploymentId = res.result();
					log.info("RedisCacheVerticle deployed ok, deploymentId = " + deploymentId);
				} else {
					log.error("RedisCacheVerticle deployed failed", res.cause());
				}
			});
		} catch (Exception e) {
			log.error("服务器异常："+e.getMessage());
			e.printStackTrace();
		}
	}
}
