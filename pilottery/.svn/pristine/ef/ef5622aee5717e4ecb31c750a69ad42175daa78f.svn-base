package test.webncp;

import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.Map;

import org.junit.Test;

import com.alibaba.fastjson.JSONObject;

import cls.pilottery.common.utils.HttpClientUtils;
import cls.pilottery.webncp.system.model.Request5001Model;
import cls.pilottery.webncp.system.model.Request5002Model;
import cls.pilottery.webncp.system.model.Request5003Model;
import cls.pilottery.webncp.system.model.Request5004Model;

public class TermialTest {
	@Test
	public void test5001() throws UnsupportedEncodingException{
		String url = "http://localhost:8080/PILottery/ncp.do";
		Request5001Model request = new Request5001Model();
		request.setCMD(0x5001);
		request.setMac_addr("F8-BC-12-6C-5B-86");
		String req = JSONObject.toJSONString(request);
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("req", req);
		Object obj = HttpClientUtils.postWithParam(url, map);
		System.out.println(obj);
	}
	@Test
	public void test5002() throws UnsupportedEncodingException{
		String url = "http://localhost:8080/PILottery/ncp.do";
		Request5002Model request = new Request5002Model();
		request.setCMD(0x5002);
		request.setTerminal_model(1);
		request.setTerminal_code(new Long(1234567));
		request.setTerminal_version("1.1.1.0");
		String req = JSONObject.toJSONString(request);
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("req", req);
		Object obj = HttpClientUtils.postWithParam(url, map);
		System.out.println(obj);
	}
	@Test
	public void test5003() throws UnsupportedEncodingException{
		String url = "http://localhost:8080/PILottery/ncp.do";
		Request5003Model request = new Request5003Model();
		request.setCMD(0x5003);
		request.setModule_name("版本升级");
		request.setTerminal_code(new Long(1234567));
		request.setModule_progress(1);
		request.setSchedule_id(2);
		request.setVersion_no("1.1.1.0");
		String req = JSONObject.toJSONString(request);
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("req", req);
		Object obj = HttpClientUtils.postWithParam(url, map);
		System.out.println(obj);
	}
	@Test
	public void test5004() throws UnsupportedEncodingException{
		String url = "http://localhost:8080/PILottery/ncp.do";
		Request5004Model request = new Request5004Model();
		request.setCMD(0x5004);
		request.setSchedule_id(1);
		request.setTerminal_code(new Long(1234567));
        
		request.setSchedule_id(2);
		request.setVersion_no("1.1.1.0");
		String req = JSONObject.toJSONString(request);
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("req", req);
		Object obj = HttpClientUtils.postWithParam(url, map);
		System.out.println(obj);
	}
}
