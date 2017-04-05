package cls.taishan.common.verticle;

import javax.sql.DataSource;

import cls.taishan.common.constant.CommonConstant;
import cls.taishan.common.helper.RedisHelper;
import cls.taishan.common.utils.VertxConfiguration;
import io.vertx.core.AbstractVerticle;
import io.vertx.core.json.JsonArray;
import io.vertx.core.json.JsonObject;
import io.vertx.ext.jdbc.JDBCClient;
import io.vertx.ext.sql.SQLConnection;
import lombok.extern.log4j.Log4j;

@Log4j
public class RedisCacheVerticle extends AbstractVerticle {

	@Override
	public void start() throws Exception {
		log.debug("缓存渠道商密钥到REDIS……");
		/*final JDBCClient client = JDBCClient.createShared(vertx,
				new JsonObject().put("url", "jdbc:oracle:thin:@192.168.26.110:1521/taishan")
						.put("driver_class", "oracle.jdbc.driver.OracleDriver")
						.put("user", "kws_all")
						.put("password", "oracle"));*/
		final JDBCClient client = JDBCClient.createShared(vertx,
				new JsonObject().put("url", VertxConfiguration.jdbcStr("jdbc.db.url"))
						.put("driver_class", VertxConfiguration.jdbcStr("jdbc.db.driver"))
						.put("user", VertxConfiguration.jdbcStr("jdbc.db.username"))
						.put("password", VertxConfiguration.jdbcStr("jdbc.db.password")));

		client.getConnection(conn -> {
			if (conn.failed()) {
				log.error("获取数据库连接出错:" + conn.cause().getMessage());
				return;
			}

			final SQLConnection connection = conn.result();
			connection.query("select dealer_code,public_key from cncp_security_dealer", rs -> {
				for (JsonArray line : rs.result().getResults()) {
					RedisHelper.set(CommonConstant.REDIS_AGENCY_PUBLIC_KEY+line.getString(0), line.getString(1));
				}
				log.debug("渠道商密钥缓存到REDIS完毕……");

				// and close the connection
				connection.close(done -> {
					log.debug("关闭数据库连接……");
					if (done.failed()) {
						log.error("关闭数据库连接时出错："+done.cause());
						throw new RuntimeException(done.cause());
					}
				});
			});
		});
	}

}
