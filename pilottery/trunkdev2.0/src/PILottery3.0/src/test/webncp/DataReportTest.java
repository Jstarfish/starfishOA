package test.webncp;

import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.Map;

import org.junit.Test;

import cls.pilottery.common.utils.HttpClientUtils;
import cls.pilottery.webncp.system.model.Request3001Model;
import cls.pilottery.webncp.system.model.Request3002Model;
import cls.pilottery.webncp.system.model.Request3003Model;
import cls.pilottery.webncp.system.model.Request3005Model;

import com.alibaba.fastjson.JSONObject;

public class DataReportTest {
	
	@Test
	public void test3001() throws UnsupportedEncodingException{
		String url = "http://localhost:8080/PILottery/ncp.do";
		
		Request3001Model request = new Request3001Model();
		request.setCMD(0x3001);
		request.setAgencyCode("100000040");
		request.setGameCode("7");
		request.setStartDate("20150523");
		request.setEndDate("20150523");
		
		String req = JSONObject.toJSONString(request);
		
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("req", req);
		
		
		Object obj = HttpClientUtils.postWithParam(url, map);
		
		System.out.println(obj);
	}
	@Test
	public void test3002() throws UnsupportedEncodingException{
		String url = "http://localhost:8080/PILottery/ncp.do";
		
		Request3002Model request = new Request3002Model();
		request.setCMD(0x3002);
		request.setAgencyCode("100000040");
		request.setGameCode("7");
		request.setStartIssue("20150505");
		request.setCloseIssue("20151111");
		
		String req = JSONObject.toJSONString(request);
		
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("req", req);
		
		
		Object obj = HttpClientUtils.postWithParam(url, map);
		
		System.out.println(obj);
	}
	@Test
	public void test3003() throws UnsupportedEncodingException{
		String url = "http://localhost:8080/PILottery/ncp.do";
		
		Request3003Model request = new Request3003Model();
		request.setCMD(0x3003);
		request.setAgencyCode("100000040");
		
		String req = JSONObject.toJSONString(request);
		
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("req", req);
		
		
		Object obj = HttpClientUtils.postWithParam(url, map);
		
		System.out.println(obj);
	}
	@Test
	public void test3005() throws UnsupportedEncodingException{
		String url = "http://localhost:8080/PILottery/ncp.do";
		
		Request3005Model request = new Request3005Model();
		request.setCMD(0x3005);
		request.setAgencyCode("100000040");
		
		String req = JSONObject.toJSONString(request);
		
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("req", req);
		
		
		Object obj = HttpClientUtils.postWithParam(url, map);
		
		System.out.println(obj);
	}

}
