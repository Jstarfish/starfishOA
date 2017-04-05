package test.webncp;

import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.Map;

import org.junit.Test;

import cls.pilottery.common.utils.HttpClientUtils;
import cls.pilottery.webncp.system.model.Request9001Model;
import cls.pilottery.webncp.system.model.Request9002Model;

import com.alibaba.fastjson.JSONObject;

public class DataCollectTest {

	@Test
	public void test9001() throws UnsupportedEncodingException{
		String url = "http://localhost:8080/PILottery/ncp.do";
		
		Request9001Model request = new Request9001Model();
		request.setCMD(0x9001);
		request.setTerminal_code("80000000201");
		
		String req = JSONObject.toJSONString(request);
		
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("req", req);
		Object obj = HttpClientUtils.postWithParam(url, map);
		System.out.println(obj);
	}
	
	@Test
	public void test9002() throws UnsupportedEncodingException{
		String url = "http://localhost:8080/PILottery/ncp.do";
		
		Request9002Model request = new Request9002Model();
		request.setCMD(0x9002);
		request.setApply_status(1);
		request.setFileName("hahah");
		request.setReqSeq("11");
		
		String req = JSONObject.toJSONString(request);
		
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("req", req);
		Object obj = HttpClientUtils.postWithParam(url, map);
		System.out.println(obj);
	}
}
