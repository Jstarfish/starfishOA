package cls.taishan.cncp.cmi.handler;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.inject.Inject;
import javax.inject.Singleton;

import org.apache.commons.lang3.StringUtils;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.alibaba.fastjson.TypeReference;

import cls.taishan.cncp.cmi.model.Req1001Msg;
import cls.taishan.cncp.cmi.model.Res5001Msg;
import cls.taishan.cncp.cmi.model.Res5005Msg;
import cls.taishan.cncp.cmi.model.Res5006Msg;
import cls.taishan.cncp.cmi.model.Res5007Msg;
import cls.taishan.cncp.cmi.service.DataQueryService;
import cls.taishan.common.annotations.RouteHandler;
import cls.taishan.common.annotations.RouteMapping;
import cls.taishan.common.constant.CommonConstant;
import cls.taishan.common.exception.VertxInvokeException;
import cls.taishan.common.handler.AbstractInvokeHandler;
import cls.taishan.common.model.BaseMessage;
import cls.taishan.common.model.BaseResponse;
import cls.taishan.common.utils.DateUtils;
import io.vertx.core.http.HttpMethod;
import io.vertx.ext.web.RoutingContext;
import lombok.extern.log4j.Log4j;

/**
 * 基础查询相关消息处理Handler
 * 
 * @author huangchy
 *
 * @2016年9月8日
 * 
 * 包含的消息如下：
 * 1.系统时间查询消息<请求1006 / 响应5006>
 * 2.奖期查询消息<请求1001 / 响应5001>
 * 3.账户查询消息<请求1005 / 响应5005>
 * 4.日结对账查询消息 <请求1007 / 响应5007>
 *
 */
@Log4j
@Singleton
@RouteHandler("/dataQuery")
public class DataQueryHandler {
	
	@Inject
	private DataQueryService dataQueryService;
	
	/*
	 * 系统时间查询消息<请求1006 / 响应5006>
	 */
	@RouteMapping(value="1006",method=HttpMethod.POST)
    public AbstractInvokeHandler getSystemTime() {
    	return new AbstractInvokeHandler() {
    		@SuppressWarnings(value = { "rawtypes" })
			@Override
    		public BaseMessage<BaseResponse> invoke(RoutingContext event,String jsonBody) throws VertxInvokeException {
				BaseMessage req = JSON.parseObject(jsonBody,BaseMessage.class);
    			String sysTime = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
    			
    			log.debug("执行1006,获得系统时间："+sysTime);
    			
    			BaseMessage<BaseResponse> res = new BaseMessage<BaseResponse>();
    			res.setBody(new Res5006Msg(sysTime));
    			res.setTransType(5006);
    			res.setMessengerId(req.getMessengerId());
    			res.setToken(req.getToken());
    			res.setTimestamp(DateUtils.getStringDateByLongDate(System.currentTimeMillis(),"yyyyMMddHHmmss"));
    			return res;
    		}
    	};
    }
	
	
	/**
	 * 奖期查询消息<请求1001 / 响应5001>
	 */
	@RouteMapping(value="1001",method=HttpMethod.POST)
	public AbstractInvokeHandler getAwardPeriodInfo(){
		
		return new AbstractInvokeHandler(){
			@Override
			public BaseMessage<BaseResponse> invoke(RoutingContext event, String jsonBody) throws Exception {
				/*BaseMessage<Req1001Msg> req = JSON.parseObject(jsonBody,new TypeReference<BaseMessage<Req1001Msg>>(){});
				BaseMessage<BaseResponse> res = new BaseMessage<BaseResponse>();
				String game = req.getBody().getGame();
				String issue = req.getBody().getIssue();*/
				
				@SuppressWarnings("rawtypes")
				BaseMessage req = JSON.parseObject(jsonBody,BaseMessage.class);
				BaseMessage<BaseResponse> res = new BaseMessage<BaseResponse>();
				res.setTransType(5001);
    			res.setMessengerId(req.getMessengerId());
    			res.setToken(req.getToken());
    			
				JSONObject body = (JSONObject) req.getBody();
				
				String game = body.getString("game");
				String issue = body.getString("issue");
				
				String dealerCode = req.getToken();
				
				Integer gameCode = CommonConstant.getGameCode(game.toUpperCase());
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("gameCode", gameCode);
				map.put("issue", issue);
				map.put("dealerCode", dealerCode);
				res.setTimestamp(DateUtils.getStringDateByLongDate(System.currentTimeMillis(),"yyyyMMddHHmmss"));
				
				if(StringUtils.isEmpty(issue) || gameCode == null){
					log.info("请求参数错误");
					BaseResponse bres = new BaseResponse(501);
					res.setBody(bres);
					return res;
				}
				
				//当请求消息的期次为0时，交易系统默认查询返回当前正在销售的期次
				Res5001Msg result = dataQueryService.getAwardPeriodInfo(map);
				if(result == null){
					log.info("查询结果为空！");
					BaseResponse bres = new BaseResponse(41);
					res.setBody(bres);
					return res;
				}
				result.setGame(game);
				res.setBody(result);
				return res;
			}
		};
	}
	

	/**
	 * 账户查询消息<请求1005 / 响应5005>
	 */
	@RouteMapping(value="1005",method=HttpMethod.POST)
	public AbstractInvokeHandler getAccountInfo(){
		return new AbstractInvokeHandler(){

			@SuppressWarnings("rawtypes")
			@Override
			public BaseMessage<BaseResponse> invoke(RoutingContext event, String jsonBody) throws Exception {
				BaseMessage req = JSON.parseObject(jsonBody,BaseMessage.class);
				BaseMessage<BaseResponse> res = new BaseMessage<BaseResponse>();
				res.setTransType(5005);
    			res.setMessengerId(req.getMessengerId());
    			res.setToken(req.getToken());
    			res.setTimestamp(DateUtils.getStringDateByLongDate(System.currentTimeMillis(),"yyyyMMddHHmmss"));
    			
				String dealerCode = req.getToken();  //获取渠道编码
				String balance = dataQueryService.getAccountBalance(dealerCode);
				if(StringUtils.isEmpty(balance)){
					log.info("该账户为空");
					BaseResponse bres = new BaseResponse(102);
					res.setBody(bres);
					return res;
				}
				
				log.debug("执行1005,获得渠道账户信息："+balance);
    			
    			res.setBody(new Res5005Msg(balance));
    			return res;
			}
		};
	}
	
	/**
	 * 日结对账查询消息 <请求1007 / 响应5007>
	 */
	@RouteMapping(value="1007",method=HttpMethod.POST)
	public AbstractInvokeHandler getFundDaliyReport(){
		
		return new AbstractInvokeHandler(){
			@Override
			public BaseMessage<BaseResponse> invoke(RoutingContext event, String jsonBody) throws Exception {
				BaseMessage<Map<String,String>> req = JSON.parseObject(jsonBody,new TypeReference<BaseMessage<Map<String,String>>>(){});
				BaseMessage<BaseResponse> res = new BaseMessage<BaseResponse>();
				res.setTransType(5007);
    			res.setMessengerId(req.getMessengerId());
    			res.setToken(req.getToken());
    			res.setTimestamp(DateUtils.getStringDateByLongDate(System.currentTimeMillis(),"yyyyMMddHHmmss"));
    			
				String dealerCode = req.getToken();  //获取渠道编码
				String date = req.getBody().get("date");
				
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("date", date);
				map.put("dealerCode", dealerCode);
				
				if(StringUtils.isEmpty(date)){
					log.info("请求参数错误");
					BaseResponse bres = new BaseResponse(501);
					res.setBody(bres);
					return res;
				}
				
				//当请求消息的期次为0时，交易系统默认查询返回当前正在销售的期次
				Res5007Msg result = dataQueryService.getFundDaliyReport(map);
				if(result == null){
					log.info("查询结果为空！");
					BaseResponse bres = new BaseResponse(108);
					res.setBody(bres);
					return res;
				}
				res.setBody(result);
				return res;
			}
		};
	}
}
