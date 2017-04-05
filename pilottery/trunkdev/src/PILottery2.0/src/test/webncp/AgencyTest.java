package test.webncp;

import java.util.ArrayList;
import java.util.List;

import org.junit.Test;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;

import cls.pilottery.common.utils.HttpClientUtils;
import cls.pilottery.common.utils.PropertiesUtil;
import cls.pilottery.oms.common.entity.BaseMessageReq;
import cls.pilottery.oms.common.entity.BaseMessageRes;
import cls.pilottery.oms.common.entity.MessageLog;
import cls.pilottery.oms.common.msg.AgencyGameAuthReq5007;
import cls.pilottery.oms.common.msg.QytvAgencyReq6009;
import cls.pilottery.web.area.model.GameAuth;

public class AgencyTest {
	@Test
	public void returnAgencySetup() {
		BaseMessageReq breq = new BaseMessageReq(6009, 2);
		QytvAgencyReq6009 req = new QytvAgencyReq6009();
		req.setAgencyCode("0001030002");
		req.setAuditCode(0);
		req.setUserId(1);
		breq.setParams(req);

		breq.setMsn(190);
		String json = JSONObject.toJSONString(breq);
		String url = "http://192.168.26.160:20080/do";

		String resJson = HttpClientUtils.postString(url, json);
		BaseMessageRes res = JSON.parseObject(resJson, BaseMessageRes.class);

		int status = res.getRc();
	}

	@Test
	public void gameAuthenPost() {
		BaseMessageReq  breq=new BaseMessageReq(5007, 2);
		AgencyGameAuthReq5007 req=new AgencyGameAuthReq5007();
		req.setCtrlCode("3");
		req.setCtrlCode("0001030002");
		List<GameAuth> games =new ArrayList<GameAuth>();
		GameAuth auth=new GameAuth();
		//auth.setAgencyCode(Long.valueOf("0001030002"));
		auth.setGameCode(11);
		auth.setClaimingScope(10);
		games.add(auth);
		req.setCtrls(games);
		breq.setParams(req);
		breq.setMsn(200);
		String url = "http://192.168.26.160:20080/do";
		String json=JSONObject.toJSONString(breq);
		
	
		// 向主机发送消息
		String  resulst = HttpClientUtils.postString(url, json);
		BaseMessageRes res = JSON.parseObject(resulst, BaseMessageRes.class);
	}
	public void testJson(){
		
	}
}
