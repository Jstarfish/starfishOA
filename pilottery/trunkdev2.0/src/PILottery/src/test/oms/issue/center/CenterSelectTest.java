package test.oms.issue.center;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;

import cls.pilottery.common.utils.HttpClientUtils;
import cls.pilottery.oms.common.entity.BaseMessageReq;
import cls.pilottery.oms.common.msg.CenterSelectReq4001;
import cls.pilottery.oms.common.msg.CenterSelectRes4001;
import cls.pilottery.oms.common.msg.LotteryReq4003;
import cls.pilottery.oms.common.msg.LotteryRes4003;

@RunWith(SpringJUnit4ClassRunner.class)  //使用junit4进行测试  
@ContextConfiguration   
({"/config/spring-*.xml"}) //加载配置文件  
public class CenterSelectTest {
	// private LogService logService;
	@Test
   public void gameDraw(){
		String url="http://192.168.26.160:20080/do";
		String tsn="290957338514596204770839";
		BaseMessageReq  breq=new BaseMessageReq(4001, 2);
		CenterSelectReq4001 req = new CenterSelectReq4001();
		req.setRspfn_ticket(tsn);
		breq.setParams(req);
		//Long seq=this.logService.getNextSeq();
		breq.setMsn(384);
		String json=JSONObject.toJSONString(breq);
		String resJson = HttpClientUtils.postString(url, json);
		CenterSelectRes4001 res = JSON.parseObject(resJson, CenterSelectRes4001.class);
		System.out.println(res.toString());
   }
	@Test
	public void saveexpiryInfo(){
		String url="http://192.168.26.160:20080/do";
		String tsn="290957338514596204770839";
		BaseMessageReq  breq=new BaseMessageReq(4003, 2);
		LotteryReq4003 req = new LotteryReq4003();
		req.setRspfn_ticket(tsn);
		req.setReqfn_ticket_pay("Wer123456");
		req.setAreaCode_pay("12");
		breq.setParams(req);
		breq.setMsn(384);
		String json=JSONObject.toJSONString(breq);
		String resJson = HttpClientUtils.postString(url, json);
		LotteryRes4003 res = JSON.parseObject(resJson, LotteryRes4003.class);
		System.out.println(res.toString());
	}
}
