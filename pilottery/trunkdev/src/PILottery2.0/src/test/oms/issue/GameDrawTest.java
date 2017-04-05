package test.oms.issue;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import cls.pilottery.common.utils.HttpClientUtils;
import cls.pilottery.common.utils.PropertiesUtil;
import cls.pilottery.oms.common.entity.BaseMessageReq;
import cls.pilottery.oms.common.entity.BaseMessageRes;
import cls.pilottery.oms.common.entity.MessageLog;
import cls.pilottery.oms.common.msg.DrawConfirm3013Req;
import cls.pilottery.oms.common.msg.DrawNumber3005Req;
import cls.pilottery.oms.common.msg.RestartDraw3015Req;
import cls.pilottery.oms.common.msg.SendPrize3009Req;
import cls.pilottery.oms.common.msg.SendPrize3009Req.PrizeInfo;
import cls.pilottery.oms.common.service.LogService;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
@RunWith(SpringJUnit4ClassRunner.class)  //使用junit4进行测试  
@ContextConfiguration   
({"/config/spring-*.xml"}) //加载配置文件  

public class GameDrawTest {

	
	@Autowired
	private LogService logService;
	
	/**
	 * 
	 *	@Description:重新开奖测试
	 *  @date: 2016-3-14 下午1:27:48
	 */
	
	String url = "http://192.168.26.160:20080/do";
	
	@Test
	public void restart() {
		RestartDraw3015Req restartDrawReq = new RestartDraw3015Req();
		restartDrawReq.setGameCode((short) 11);
		restartDrawReq.setIssueNumber(0000);
		restartDrawReq.setDrawTimes((short) 1);
		BaseMessageReq req = new BaseMessageReq(3015, 2);
		long seq = logService.getNextSeq();
		req.setMsn(11000);
		req.setParams(restartDrawReq);
		String reqJson = JSONObject.toJSONString(req);
		System.out.println("3015向主机发送请求，请求内容：" + reqJson);

		MessageLog msglog = new MessageLog(seq, reqJson);
		
		String resJson = HttpClientUtils.postString(url, reqJson);
		System.out.println("3015接收到主机的响应，消息内容：" + resJson);
		BaseMessageRes res = JSON.parseObject(resJson, BaseMessageRes.class);
		logService.updateLog(msglog);
	}

	/**
	 * 
	 *	@Description:开奖号码录入测试
	 *  @date: 2016-3-14 下午1:27:18
	 */
	@Test
	public void inputDrawNumber() {
		DrawNumber3005Req dnreq = new DrawNumber3005Req();
		dnreq.setGameCode((short) 12);
		dnreq.setIssueNumber(120001);
		dnreq.setDrawNumber("120001");
		dnreq.setNumberCount(1200);
		dnreq.setGameDisplay("12,13,15");
		dnreq.setDrawTimes((short) 1);

		BaseMessageReq req = new BaseMessageReq(3005, 2);
		long seq = logService.getNextSeq();
		req.setMsn(seq);
		req.setParams(dnreq);
		String reqJson = JSONObject.toJSONString(req);
		System.out.println("3005向主机发送请求，请求内容：" + reqJson);
		MessageLog msglog = new MessageLog(seq, reqJson);
		logService.insertLog(msglog);
		String resJson = HttpClientUtils.postString(url, reqJson);
		System.out.println("3005接收到主机的响应，消息内容：" + resJson);
	}
	
	/**
	 * 开奖确认测试
	 *	@Description:
	 *  @date: 2016-3-14 下午1:38:07
	 */
	@Test
	public void prizeConfirm(){
		DrawConfirm3013Req dreq = new DrawConfirm3013Req();
		dreq.setGameCode((short) 13);
		dreq.setIssueNumber(30130001);
		dreq.setDrawTimes((short)1);
		
		BaseMessageReq req = new BaseMessageReq(3013, 2);
		long seq = logService.getNextSeq();
		req.setMsn(seq);
		req.setParams(dreq);
		String reqJson = JSONObject.toJSONString(req);
		System.out.println("3013向主机发送请求，请求内容："+reqJson);
		MessageLog msglog = new MessageLog(seq,reqJson);
		logService.insertLog(msglog);
		String resJson = HttpClientUtils.postString(url, reqJson);
		System.out.println("3013接收到主机的响应，消息内容："+resJson);
	}

	/**
	 * 
	 *	@Description:发送派奖消息
	 *  @date: 2016-3-14 下午2:39:09
	 */
	@Test
	public void waitStatistic() {
		SendPrize3009Req sendPrize = new SendPrize3009Req();
		sendPrize.setGameCode((short) 11);
		sendPrize.setDrawTimes((short) 12);
		sendPrize.setIssueNumber(121);
		sendPrize.setPrizeCount((short) 20);
		for (int i = 0; i < 10; i++) {

			SendPrize3009Req.PrizeInfo prize = sendPrize.new PrizeInfo();
			prize.setPrizeCode((short) 2);
			prize.setPrizeAmount(500);
			sendPrize.prizes.add(prize);
		}
		sendPrize.drawTimes = 1;

		BaseMessageReq req = new BaseMessageReq(3009, 2);
		long seq = logService.getNextSeq();
		req.setMsn(seq);
		req.setParams(sendPrize);
		String reqJson = JSONObject.toJSONString(req);
		System.out.println("3009向主机发送请求，请求内容：" + reqJson);
		MessageLog msglog = new MessageLog(seq, reqJson);
		logService.insertLog(msglog);
		String resJson = HttpClientUtils.postString(url, reqJson);
		System.out.println("3009接收到主机的响应，消息内容：" + resJson);
	}
}
