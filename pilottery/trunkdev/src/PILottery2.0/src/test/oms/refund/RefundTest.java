package test.oms.refund;

import org.junit.Test;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;

import cls.pilottery.common.utils.HttpClientUtils;
import cls.pilottery.oms.common.entity.BaseMessageReq;
import cls.pilottery.oms.common.msg.RefundReq4005;
import cls.pilottery.oms.common.msg.RefundRes4005;

public class RefundTest {
	@Test
  public void refund(){
		String url="http://192.168.26.160:20080/do";
	  BaseMessageReq  breq=new BaseMessageReq(4005, 2);
  	   RefundReq4005 req=new RefundReq4005();
  	 String tsn="290957338514596204770839";
  		req.setRspfn_ticket(tsn);
    	req.setReqfn_ticket_cancel("1");
    	breq.setParams(req);
		
		breq.setMsn(189);
		String json=JSONObject.toJSONString(breq);
		
		String resJson = HttpClientUtils.postString(url, json);
		RefundRes4005 res = JSON.parseObject(resJson, RefundRes4005.class);
		System.out.println(res.toString());
  }
}
