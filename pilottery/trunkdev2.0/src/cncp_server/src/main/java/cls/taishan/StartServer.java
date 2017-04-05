package cls.taishan;

import org.apache.log4j.PropertyConfigurator;

import cls.taishan.common.constant.CommonConstant;
import cls.taishan.common.utils.HttpClientUtils;
import cls.taishan.common.utils.VertxConfiguration;
import cls.taishan.common.verticle.RedisCacheVerticle;
import cls.taishan.common.verticle.StandardVerticle;
import io.vertx.core.DeploymentOptions;
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
public class StartServer {

	public static void main(String[] args){
		try {
			PropertyConfigurator.configure(StartServer.class.getClassLoader().getResource("log4j.properties"));
			log.info("Vertx log4j initialized");
			
			DeploymentOptions options1 = new DeploymentOptions().setInstances(5);
			DeploymentOptions options2 = new DeploymentOptions().setWorker(true);
			Vertx vertx = Vertx.vertx();
			
			vertx.deployVerticle("cls.taishan.common.verticle.StandardVerticle",options1, res -> {
				if (res.succeeded()) {
					String deploymentId = res.result();
					log.info("StandardVerticle deployed ok, deploymentId = " + deploymentId);
					
					vertx.deployVerticle(new RedisCacheVerticle(), options2, res2 -> {
						if (res2.succeeded()) {
							String deploymentId2 = res2.result();
							log.info("RedisCacheVerticle deployed ok, deploymentId = " + deploymentId2);
							
						} else {
							log.error("RedisCacheVerticle deployed failed", res2.cause());
						}
					});
				} else {
					log.error("StandardVerticle deployed failed", res.cause());
				}
			});
			
			String url = "http://127.0.0.1:"+VertxConfiguration.configInt("port")+"/issueNotify.do";
			Runnable r = () -> {
				try {
					while(true){
						Thread.sleep(CommonConstant.ISSUE_NOTIFY_SLEEP_SECEND);
						HttpClientUtils.postString(url, "");
					}
				} catch (Exception e) {
					log.error("期次同步错误",e);
				}
			};
			r.run();
			
		} catch (Exception e) {
			log.error("服务器异常："+e.getMessage());
			e.printStackTrace();
		}
	}
}