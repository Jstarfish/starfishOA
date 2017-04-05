package cls.taishan.cncp.cmi.handler;

import cls.taishan.cncp.cmi.entity.Req1002Model;
import cls.taishan.cncp.cmi.entity.Res5004Model;
import cls.taishan.cncp.cmi.entity.Resp1002Model;
import cls.taishan.cncp.cmi.model.*;
import cls.taishan.cncp.cmi.service.TransFerService;
import cls.taishan.common.annotations.RouteHandler;
import cls.taishan.common.annotations.RouteMapping;
import cls.taishan.common.constant.CommonConstant;
import cls.taishan.common.constant.ErrorCodeConstant;
import cls.taishan.common.exception.VertxInvokeException;
import cls.taishan.common.handler.AbstractInvokeHandler;
import cls.taishan.common.model.BaseMessage;
import cls.taishan.common.model.BaseResponse;
import cls.taishan.common.model.HostMessageBaseReq;
import cls.taishan.common.utils.DateUtils;
import cls.taishan.common.utils.HttpClientUtils;
import cls.taishan.common.utils.VertxConfiguration;
import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.google.inject.Inject;

import io.vertx.core.http.HttpMethod;
import io.vertx.ext.web.RoutingContext;
import lombok.extern.log4j.Log4j;

import javax.inject.Singleton;

import org.apache.commons.lang3.StringUtils;

import java.math.BigInteger;
import java.util.List;

/**
 * 交易相关消息处理Handler
 *
 * @author huangchy
 * @2016年9月9日 包含消息如下：
 * 1. 彩票查询消息<请求1003 / 响应5003>
 * 2. 彩票投注消息<请求1002 / 响应5002>
 * 3. 返奖查询消息<请求1004 / 响应5004>
 */
@Log4j
@Singleton
@RouteHandler("/transFer")
public class TransFerHandler {

    @Inject
    private TransFerService transFerService;

    /*
     * 彩票投注消息<请求1002 / 响应5002>
	 */
    @RouteMapping(value = "1002", method = HttpMethod.POST)
    public AbstractInvokeHandler lotteryBet() {
        return new AbstractInvokeHandler() {
            @SuppressWarnings(value = {"rawtypes"})
            @Override
            public BaseMessage<BaseResponse> invoke(RoutingContext event, String jsonBody) throws VertxInvokeException {
                BaseMessage req = JSON.parseObject(jsonBody, BaseMessage.class);
              
                JSONObject jsonObj = (JSONObject) req.getBody();
                String ticketId = jsonObj.getString("ticketId");
                String game = jsonObj.getString("game");
                long issue = jsonObj.getLong("issue");
                long amount = jsonObj.getInteger("amount");
                Object betLines = jsonObj.get("betLines");
                Integer gameCode = CommonConstant.getGameCode(game.toUpperCase());
                
                BaseMessage<BaseResponse> res = new BaseMessage<BaseResponse>();
                res.setTransType(5002);
                res.setMessengerId(req.getMessengerId());
                res.setToken(req.getToken());
                res.setTimestamp(DateUtils.getStringDateByLongDate(System.currentTimeMillis(),"yyyyMMddHHmmss"));
                Res5002Msg res5002Msg = new Res5002Msg(ticketId);
                if(StringUtils.isEmpty(ticketId) || ticketId.length() != 24 || StringUtils.isEmpty(game) || gameCode == null || issue <1 || amount <1 || betLines == null){
                	res5002Msg.setResponseCode(501);
                	res5002Msg.setResponseMsg(ErrorCodeConstant.getMsg(501));
                	res.setBody(res5002Msg);
                	return res;
                }
                int odcount = transFerService.getOrderCountByTicketId(ticketId);
                if(odcount > 0){
                	res5002Msg.setResponseCode(107);
                	res5002Msg.setResponseMsg(ErrorCodeConstant.getMsg(107));
                	res.setBody(res5002Msg);
                	return res;
                }

                Req1002Msg request = new Req1002Msg();
                request.setTicketId(ticketId);
                request.setGame(game.toUpperCase());
                request.setIssue(issue);
                request.setAmount(amount);
                JSONArray array = JSON.parseArray(betLines.toString());
                String betS = "{\"betLines\":" + array.toJSONString() + "}";
                request.setBetLines(betS);
                request.setDealer(req.getToken());
                request.setGameCode(gameCode);

                transFerService.lotteryBet(request);
                log.debug("存储过程p_cncp_sale执行结果：");
                log.info("Error code:"+request.getResponseCode()+" ,Error message:"+request.getResponseMsg());

                if (request.getResponseCode() == 0) {
                	try {
						Long agencyCode = 0L; 
						String hostUrl = "";
						if(gameCode == 12){
							agencyCode = Long.parseLong(VertxConfiguration.configStr("kpw_oms_agency"));
							hostUrl = VertxConfiguration.configStr("kpw_host_url");
						}else{
							agencyCode = Long.parseLong(VertxConfiguration.configStr("nsl_oms_agency"));
							hostUrl = VertxConfiguration.configStr("nsl_host_url");
						}

						HostMessageBaseReq hReq = new HostMessageBaseReq();
						hReq.setFunc(55001);
						hReq.setType(5);
						hReq.setVersion("1.0.0");
						hReq.setWhen(System.currentTimeMillis() / 1000);
						hReq.setToken(Long.parseLong(req.getToken()));

						Req1002Model req1002Model = new Req1002Model();
						//渠道编码，，这个需要配置在某个地方
						req1002Model.setAgencyCode(agencyCode);
						req1002Model.setReqfn(request.getTicketId());

						//游戏 | 期号 | 连续购买期数 | 票金额 | 票扩展标记 | 投注行信息...
						StringBuffer betString = new StringBuffer("");
						betString.append(request.getGame()).append("|");
						betString.append(0).append("|");
						betString.append(1).append("|");
						betString.append(request.getAmount()).append("|");
						betString.append(0).append("|");
						JSONArray jsonArray = JSONArray.parseArray(betLines.toString());
						for (int i = 0; i < jsonArray.size(); i++) {
						    if (i != jsonArray.size() - 1) {
						        betString.append(jsonArray.get(i)).append("/");
						    } else {
						        betString.append(jsonArray.get(i));
						    }
						}

						req1002Model.setBet_string(betString.toString());

						hReq.setParams(req1002Model);
						hReq.setMsn(transFerService.getNextSeq());

						String json1002 = JSONObject.toJSONString(hReq);

						log.debug("向主机发送请求，请求内容：" + json1002);
						String resJson1002 = HttpClientUtils.postString(hostUrl, json1002);
						log.debug("接收到主机的响应，消息内容：" + resJson1002);
						Resp1002Model res1002 = JSON.parseObject(resJson1002, Resp1002Model.class);

						int status23 = res1002.getRc();
						log.info("select ticket return status=" + status23 + ",Is tsn err=" + status23);

						if (status23 == 0) {
							JSONObject result = (JSONObject)res1002.getResult();
							String tsn = result.getString("rspfn");
						    transFerService.updateLottery(request.getTicketId(),tsn, true,null);
						    log.debug("主机投注1002成功,彩票投注消息:" + request.getTicketId());
						    res5002Msg.setResponseCode(status23);
						    res5002Msg.setResponseMsg(ErrorCodeConstant.getMsg(status23));
						} else {
						    transFerService.updateLottery(request.getTicketId(),null, false,"Error:"+status23+ErrorCodeConstant.getMsg(status23));
						    log.debug("主机投注1002失败,彩票投注消息:" + request.getTicketId());
						    res5002Msg.setResponseCode(status23);
						    res5002Msg.setResponseMsg(ErrorCodeConstant.getMsg(status23));
						}
						res.setBody(res5002Msg);
						res.setTimestamp(DateUtils.getStringDateByLongDate(System.currentTimeMillis(),"yyyyMMddHHmmss"));
						log.debug("响应1002,彩票投注消息:" + res.toString());
						return res;
					} catch (Exception e) {
						log.error("投注错误！",e);
						transFerService.updateLottery(request.getTicketId(),null, false,"Error:1,"+e.getMessage());
						res5002Msg.setResponseCode(1);
	                    res.setBody(res5002Msg);
	                    res.setTimestamp(DateUtils.getStringDateByLongDate(System.currentTimeMillis(),"yyyyMMddHHmmss"));
	                    return res;
					}
                } else {
                    log.info("主机投注1002失败,彩票投注消息:" + request.getTicketId());
                    log.info("Error code:"+request.getResponseCode()+" ,Error message:"+request.getResponseMsg());
                    //transFerService.updateLottery(request.getTicketId(),null, false);

                    res5002Msg.setResponseCode(1);
                    res5002Msg.setResponseMsg(ErrorCodeConstant.getMsg(1));
                    res.setBody(res5002Msg);
                    res.setTimestamp(DateUtils.getStringDateByLongDate(System.currentTimeMillis(),"yyyyMMddHHmmss"));
                    log.debug("失败响应1002,彩票投注消息:" + res.toString());
                    return res;
                }
            }
        };
    }

    /*
    * 彩票查询消息<请求1003 / 响应5003>
    */
    @RouteMapping(value = "1003", method = HttpMethod.POST)
    public AbstractInvokeHandler lotteryQuery() {
        return new AbstractInvokeHandler() {
            @SuppressWarnings(value = {"rawtypes"})
            @Override
            public BaseMessage<BaseResponse> invoke(RoutingContext event, String jsonBody) throws VertxInvokeException {
                BaseMessage req = JSON.parseObject(jsonBody, BaseMessage.class);
                JSONObject jsonObj = (JSONObject) req.getBody();
                String ticketId = jsonObj.getString("ticketId");

                log.debug("执行1003,彩票查询消息:" + ticketId);

                Res5003Msg resMsg = transFerService.lotteryQuery(ticketId);

                BaseMessage<BaseResponse> res = new BaseMessage<BaseResponse>();
                res.setBody(resMsg);
                res.setTransType(5003);
                res.setMessengerId(req.getMessengerId());
                res.setToken(req.getToken());
                res.setTimestamp(DateUtils.getStringDateByLongDate(System.currentTimeMillis(),"yyyyMMddHHmmss"));
                return res;
            }
        };
    }


    /*
   * 返奖查询消息<请求1004 / 响应5004>
   */
    @RouteMapping(value = "1004", method = HttpMethod.POST)
    public AbstractInvokeHandler payOffQuery() {
        return new AbstractInvokeHandler() {
            @SuppressWarnings(value = {"unchecked", "rawtypes"})
            @Override
            public BaseMessage<BaseResponse> invoke(RoutingContext event, String jsonBody) throws VertxInvokeException {
                BaseMessage req = JSON.parseObject(jsonBody, BaseMessage.class);
                JSONObject jsonObj = (JSONObject) req.getBody();
                String game = jsonObj.getString("game");
                int issue = jsonObj.getInteger("issue");

                log.debug("执行1004,返奖查询消息:" + issue);
                
                List<Res5004Model> result = transFerService.payOffQuery(CommonConstant.getGameCode(game).toString(), issue);
                JSONArray jsonArray = new JSONArray();
                for (int i = 0; i < result.size(); i++) {
                    jsonArray.add(i, result.get(i));
                }

                Res5004Msg res5004 = new Res5004Msg(jsonArray);
                BaseMessage<BaseResponse> res = new BaseMessage<BaseResponse>();
                res.setBody(res5004);
                res.setTransType(5004);
                res.setMessengerId(req.getMessengerId());
                res.setToken(req.getToken());
                res.setTimestamp(DateUtils.getStringDateByLongDate(System.currentTimeMillis(),"yyyyMMddHHmmss"));
                log.debug("响应1004,返奖查询消息:" + ((Res5004Msg) res.getBody()).getTickets());
                return res;
            }
        };
    }

}