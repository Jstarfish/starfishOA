package cls.taishan.cncp.cmi.handler;

import java.text.SimpleDateFormat;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Singleton;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;

import cls.taishan.cncp.cmi.entity.IssueReward;
import cls.taishan.cncp.cmi.service.IssueNotifyService;
import cls.taishan.common.constant.CommonConstant;
import cls.taishan.common.helper.RedisHelper;
import cls.taishan.common.model.GameInfo;
import cls.taishan.common.model.HostMessageBaseReq;
import cls.taishan.common.model.HostMessageBaseRes;
import cls.taishan.common.model.IssueInfo;
import cls.taishan.common.utils.HttpClientUtils;
import cls.taishan.common.utils.VertxConfiguration;
import io.vertx.core.Handler;
import io.vertx.core.http.HttpHeaders;
import io.vertx.ext.web.RoutingContext;

/**
 * 奖期推送Handler
 * 
 * @author huangchy
 *
 * @2016年9月22日
 *
 * 向主机请求期次数据，然后比较是否有更新，如果有更新，则更新期次数据到数据库
 * 
 */
@Singleton
public class IssueNotifyHandler implements Handler<RoutingContext> {
	Logger log = Logger.getLogger("notifyLog");
	@Inject
	private IssueNotifyService issueNotifyService;
	
	private String hostUrl = null;
	private String agencyCode = null;
	private Map<Integer,IssueInfo> maxSaleMap = null;
	private Map<Integer,IssueInfo> maxPreSaleMap = null;
	
	private boolean saleUpdateFlag = false;
	private boolean preSaleUpdateFlag = false;
	private long msn = 0L;
	
	@SuppressWarnings("unchecked")
	@Override
	public void handle(RoutingContext event) {
		log.debug("开始同步期次信息------------------------");
		try {
			saleUpdateFlag = false;
			preSaleUpdateFlag = false;
			String lockStatus = RedisHelper.get(CommonConstant.REDIS_HOST_55007_LOCK_KEY);
			if(StringUtils.isEmpty(lockStatus) || lockStatus.equals("0")){
				RedisHelper.set(CommonConstant.REDIS_HOST_55007_LOCK_KEY,"1",CommonConstant.HOST_55007_LOCK_SECEND);
			}else{
				log.info("有其他程序正在处理……");
				return;
			}
			
			List<GameInfo> gameList = (List<GameInfo>)RedisHelper.getObject(CommonConstant.REDIS_GAMELIST_KEY);
			if(gameList == null || gameList.size() < 1 ){
				log.error("未加载到游戏信息！");
			}else{
				msn = Long.parseLong(RedisHelper.get(CommonConstant.REDIS_HOST_MSN_KEY));
				for(GameInfo game : gameList){
					log.info("开始同步"+game.getGameName()+"游戏的在售或销售结束的期次信息……");
					maxSaleMap = (Map<Integer,IssueInfo>)RedisHelper.getObject(CommonConstant.REDIS_MAX_SALE_ISSUE_KEY);
					IssueInfo issue = maxSaleMap.get(game.getGameCode());
					if(issue != null){
						Date endTime = new SimpleDateFormat("yyyyMMddHHmmss").parse(issue.getEndTime());
						long time = endTime.getTime() - System.currentTimeMillis();
						if(time > 10*1000){
							log.debug("未到期次结束时间，不需要同步……");
							continue;
						}
					}
					
					if("KPW".equalsIgnoreCase(game.getCompany())){
			    		hostUrl = VertxConfiguration.configStr("kpw_host_url");
			    		agencyCode = VertxConfiguration.configStr("kpw_oms_agency");
			    	}else{
			    		hostUrl = VertxConfiguration.configStr("nsl_host_url");
			    		agencyCode = VertxConfiguration.configStr("nsl_oms_agency");
			    	}
					
					this.processSaleIssue(game);
					log.info("开始同步"+game.getGameName()+"游戏的预售期次信息……"); 
					maxPreSaleMap = (Map<Integer,IssueInfo>)RedisHelper.getObject(CommonConstant.REDIS_MAX_PRESALE_ISSUE_KEY);
					this.processPresaleIssue(game);
				}
				
				if (saleUpdateFlag) {
					log.info("重新缓存最新在售或已售期次……");
					List<IssueInfo> issueList = issueNotifyService.getMaxSaleIssueList();
					maxSaleMap = new HashMap<Integer, IssueInfo>();
					for (IssueInfo issue : issueList) {
						maxSaleMap.put(issue.getGameCode(), issue);
					}
					RedisHelper.setObject(CommonConstant.REDIS_MAX_SALE_ISSUE_KEY,maxSaleMap);
				}
				if (preSaleUpdateFlag) {
					log.info("重新缓存最新预售期次……");
					List<IssueInfo> issueList = issueNotifyService.getMaxPreSaleIssueList();
					maxPreSaleMap = new HashMap<Integer, IssueInfo>();
					for (IssueInfo issue : issueList) {
						maxPreSaleMap.put(issue.getGameCode(), issue);
					}
					RedisHelper.setObject(CommonConstant.REDIS_MAX_PRESALE_ISSUE_KEY,maxPreSaleMap);
				}
			}
			RedisHelper.set(CommonConstant.REDIS_HOST_MSN_KEY,msn+"");
			RedisHelper.set(CommonConstant.REDIS_HOST_55007_LOCK_KEY,"0");
			
		} catch (Exception e1) {
			e1.printStackTrace();
			log.error("同步期次出现错误",e1);
		} finally {
			log.debug("期次同步结束------------------------");
			event.response().headers().set(HttpHeaders.CONTENT_TYPE, CommonConstant.DEFAULT_CHARSET);
			event.response().setChunked(true);
			event.response().write("").end();
		}
		
	}

	private void processPresaleIssue(GameInfo game) {
		IssueInfo issue = maxPreSaleMap.get(game.getGameCode());
		if(issue == null){
			issue = new IssueInfo();
			issue.setGameCode(game.getGameCode());
			issue.setIssueNumber(0L);
			issue.setIssueSeq(0L);
		}		
		log.debug("CNCP数据库中最大预售期次为："+issue.getIssueNumber());
		
		HostMessageBaseReq hReq = new HostMessageBaseReq();
		hReq.setFunc(55009);
		hReq.setType(5);
		hReq.setVersion("1.0.0");
		hReq.setWhen(System.currentTimeMillis() / 1000);
		hReq.setToken(1);
		hReq.setMsn(msn++);
		Map<String,Object> param = new HashMap<String,Object>();
		param.put("issueNumber", issue.getIssueNumber());
		param.put("issueSeq", issue.getIssueSeq());
		param.put("gameCode", issue.getGameCode());
		param.put("agencyCode", Long.parseLong(agencyCode));
		hReq.setParams(param);
		 
		String json = JSONObject.toJSONString(hReq);
		log.debug("向主机"+hostUrl+"发送请求，请求内容：" + json);
		String resJson = HttpClientUtils.postString(hostUrl, json);
		log.debug("接收到主机的响应，消息内容：" + resJson);
		
		HostMessageBaseRes res = JSON.parseObject(resJson,HostMessageBaseRes.class);
		if(res != null && res.getRc() == 0){
			Object obj = res.getResult();
			JSONObject result = (JSONObject)obj;
			
			if(obj == null || result.isEmpty()){
				log.debug("游戏"+game.getGameName()+"没有查询到预售期变化……");
			}else{
				JSONArray issues = result.getJSONArray("issueList");
				List<IssueInfo> issueList = JSONObject.parseArray(issues.toJSONString(), IssueInfo.class);  
				for(IssueInfo is : issueList){
					if(is.getIssueNumber() != issue.getIssueNumber()){
						log.debug("新增游戏"+game.getGameName()+","+is.getIssueNumber()+"期");
						is.setGameCode(game.getGameCode());
						is.setIssueStatus(0);
						issueNotifyService.saveIssueInfo(is);
					}
				}
				
				preSaleUpdateFlag = true;
				log.debug("游戏"+game.getGameName()+"的预售期次同步完成……");
			}
		}else{
			log.error("同步失败，主机返回错误!");
			log.info("向主机"+hostUrl+"请求内容：" + json);
			log.info("主机的响应内容：" + resJson);
		}
	}

	private void processSaleIssue(GameInfo game) {
		IssueInfo issue = maxSaleMap.get(game.getGameCode());
		if(issue == null){
			issue = new IssueInfo();
			issue.setGameCode(game.getGameCode());
			issue.setIssueNumber(0L);
			issue.setIssueSeq(0L);
		}
		log.debug("CNCP数据库中最大在售或销售结束的期次为："+issue.getIssueNumber());
		
		HostMessageBaseReq hReq = new HostMessageBaseReq();
		hReq.setFunc(55007);
		hReq.setType(5);
		hReq.setVersion("1.0.0");
		hReq.setWhen(System.currentTimeMillis() / 1000);
		hReq.setToken(1);
		hReq.setMsn(msn++);
		Map<String,Object> param = new HashMap<String,Object>();
		param.put("issueNumber", issue.getIssueNumber());
		param.put("issueSeq", issue.getIssueSeq());
		param.put("gameCode", issue.getGameCode());
		param.put("agencyCode", Long.parseLong(agencyCode));
		hReq.setParams(param);
		
		String json = JSONObject.toJSONString(hReq);
		log.debug("向主机"+hostUrl+"发送请求，请求内容：\n" + json);
		String resJson = HttpClientUtils.postString(hostUrl, json);
		log.debug("接收到主机的响应，消息内容：" + resJson);
		
		HostMessageBaseRes res = JSON.parseObject(resJson,HostMessageBaseRes.class);
		if(res != null && res.getRc() == 0){
			Object obj = res.getResult();
			JSONObject result = (JSONObject)obj;
			if(obj == null || result.isEmpty()){
				log.debug("游戏"+game.getGameName()+"没有查询到变化期次……");
			}else{
				JSONArray issues = result.getJSONArray("issueList");
				List<IssueInfo> issueList = JSONObject.parseArray(issues.toJSONString(), IssueInfo.class);  
				for(IssueInfo is : issueList){
					is.setGameCode(game.getGameCode());
					if(is.getIssueNumber() == issue.getIssueNumber()){
						if(is.getIssueStatus() == issue.getIssueStatus()){
							log.debug("游戏"+game.getGameName()+","+is.getIssueNumber()+"期次无变化……");
						}else{
							if(is.getIssueStatus() == 5){
								log.info("游戏"+game.getGameName()+","+is.getIssueNumber()+"期开奖完成，进行派奖……");
								IssueReward ir = new IssueReward();
								ir.setGameCode(is.getGameCode());
								ir.setIssueNumber(is.getIssueNumber());
								ir.setAgencyCode(agencyCode);
								issueNotifyService.processIssueReward(ir);
								if(ir.getErrorCode() == 0){
									log.debug("更新游戏"+game.getGameName()+","+is.getIssueNumber()+"期次状态为"+is.getIssueStatus());
									issueNotifyService.updateIssueInfo(is);
									saleUpdateFlag = true;
								}else{
									log.error("派奖失败,失败期次信息"+ir.toString());
								}
								log.info("派奖存储过程执行结果："+ir.toString());
							}
							//saleUpdateFlag = true;
						}
					}else{
						log.debug("更新游戏"+game.getGameName()+","+is.getIssueNumber()+"期");
						
						if(is.getIssueStatus() == 5){
							log.info("游戏"+game.getGameName()+","+is.getIssueNumber()+"期开奖完成，进行派奖……");
							IssueReward ir = new IssueReward();
							ir.setGameCode(is.getGameCode());
							ir.setIssueNumber(is.getIssueNumber());
							ir.setAgencyCode(agencyCode);
							issueNotifyService.processIssueReward(ir);
							if(ir.getErrorCode() == 0){
								issueNotifyService.saveOrUpdateIssueInfo(is);
								saleUpdateFlag = true;
							}else{
								log.error("派奖失败,失败期次信息"+ir.toString());
							}
						}else{
							issueNotifyService.saveOrUpdateIssueInfo(is);
							saleUpdateFlag = true;
						}
					}
				}
				
				log.debug("游戏"+game.getGameName()+"的在售或销售结束的期次同步完成……");
			}
		}else{
			log.error("同步失败，主机返回错误!");
			log.info("向主机"+hostUrl+"请求内容：" + json);
			log.info("主机的响应内容：" + resJson);
		}
	}

	
	/*@Override
		public void handle(RoutingContext event) {
			HttpServerRequest request = event.request();
			String gameCode = request.getParam("gameCode");
			String issueNumber = request.getParam("issueNumber");
			
			Req1101Notify body = null;
			log.debug("获取奖级通知消息，游戏："+gameCode + "，期次：" + issueNumber);
			
			Map<String,Object> map = new HashMap<String,Object>();
			map.put("gameCode", gameCode);
			map.put("issueNumber", issueNumber);
			//获取渠道商服务器url及渠道商编码列表
			map.put("dealerCode", "");
			
			//body = service.get1101IssueNotify(map) 
			BaseMessage<Req1101Notify> result = new BaseMessage<Req1101Notify>();
			result.setBody(body);
			result.setTransType(1101);
			result.setTimestamp(DateUtils.getStringDateByLongDate(System.currentTimeMillis(),"yyyyMMddHHmmss"));
			result.setToken("");
			result.setMessengerId(DateUtils.getStringDateByLongDate(System.currentTimeMillis(),"yyMMddHHmmssSSS"));
			String transMessage = FastJsonHelper.converter(result);
			
			String signstr=RSASignature.sign(transMessage,VertxConfiguration.configStr("cls_privateKey")); 
			String bodyString = FastJsonHelper.joinPostParam("", "1101", transMessage, signstr);
			
			log.debug("发送期次消息推送，推送消息如下");
			log.debug(bodyString);
			String resResult = HttpClientUtils.postString(VertxConfiguration.configStr("agency_host_url"), bodyString);
			log.debug("收到返回消息："+resResult);
		}*/

}