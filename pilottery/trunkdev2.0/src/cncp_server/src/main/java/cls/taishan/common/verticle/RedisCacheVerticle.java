package cls.taishan.common.verticle;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import cls.taishan.common.constant.CommonConstant;
import cls.taishan.common.helper.RedisHelper;
import cls.taishan.common.model.GameInfo;
import cls.taishan.common.model.IssueInfo;
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
			});
			
			List<GameInfo> gameList = new ArrayList<GameInfo>();
			connection.query("select game_code,short_name,bet_amount,ISSUING_ORGANIZATION,sys_ab from INF_GAMES", rs -> {
				for (JsonArray line : rs.result().getResults()) {
					GameInfo game = new GameInfo();
					game.setGameCode(line.getInteger(0));
					game.setGameName(line.getString(1));
					game.setBetAmount(line.getLong(2));
					game.setCompany(line.getString(3));
					game.setSysab(line.getString(4));
					gameList.add(game);
				}
				RedisHelper.setObject(CommonConstant.REDIS_GAMELIST_KEY, gameList);
				
				log.debug("缓存游戏数据到REDIS完毕……");
			});
			
			log.debug("初始化主机消息的MSN");
			RedisHelper.set(CommonConstant.REDIS_HOST_MSN_KEY, "0");
			
			log.debug("缓存无纸化中最大的在售或已售期次信息……");
			Map<Integer,IssueInfo> maxSaleMap = new HashMap<Integer,IssueInfo>();
			connection.query("with base as (select game_code, min(issue_seq) issue_seq from cncp_game_issues where issue_status in (1,2,3,4) group by game_code) select game_code gameCode, issue_number issueNumber, issue_seq issueSeq,issue_status issueStatus,to_char(START_SALE_TIME,'yyyymmddhh24miss') startTime,to_char(END_SALE_TIME,'yyyymmddhh24miss') endTime from cncp_game_issues join base using (game_code, issue_seq)", rs -> {
				for (JsonArray line : rs.result().getResults()) {
					IssueInfo issue = new IssueInfo();
					issue.setGameCode(line.getInteger(0));
					issue.setIssueNumber(line.getLong(1));
					issue.setIssueSeq(line.getLong(2));
					issue.setIssueStatus(line.getInteger(3));
					issue.setStartTime(line.getString(4));
					issue.setEndTime(line.getString(5));
					maxSaleMap.put(line.getInteger(0), issue);
				}
				RedisHelper.setObject(CommonConstant.REDIS_MAX_SALE_ISSUE_KEY, maxSaleMap);
				log.debug("缓存完毕……");
			});
			
			log.debug("缓存无纸化中最大期次信息……");
			Map<Integer,IssueInfo> maxPreSaleMap = new HashMap<Integer,IssueInfo>();
			connection.query("with base as (select game_code, max(issue_seq) issue_seq from cncp_game_issues group by game_code) select game_code gameCode, issue_number issueNumber, issue_seq issueSeq,issue_status issueStatus from cncp_game_issues join base using (game_code, issue_seq)", rs -> {
				for (JsonArray line : rs.result().getResults()) {
					IssueInfo issue = new IssueInfo();
					issue.setGameCode(line.getInteger(0));
					issue.setIssueNumber(line.getLong(1));
					issue.setIssueSeq(line.getLong(2));
					issue.setIssueStatus(line.getInteger(3));
					maxPreSaleMap.put(line.getInteger(0), issue);
				}
				RedisHelper.setObject(CommonConstant.REDIS_MAX_PRESALE_ISSUE_KEY, maxPreSaleMap);
				log.debug("缓存完毕……");
			});
			
			connection.close(done -> {
				log.debug("关闭数据库连接……");
				if (done.failed()) {
					log.error("关闭数据库连接时出错："+done.cause());
					throw new RuntimeException(done.cause());
				}
			});
			
		});
		
	}

}