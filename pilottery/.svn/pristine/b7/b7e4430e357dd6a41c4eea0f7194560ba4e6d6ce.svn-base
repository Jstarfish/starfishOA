package test.webncp;

import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.Map;

import org.junit.Test;

import com.alibaba.fastjson.JSONObject;

import cls.pilottery.common.utils.HttpClientUtils;
import cls.pilottery.webncp.system.model.Request4001Model;
import cls.pilottery.webncp.system.model.Request4002Model;
import cls.pilottery.webncp.system.model.Request4003Model;
import cls.pilottery.webncp.system.model.Request4004Model;
import cls.pilottery.webncp.system.model.Request4005Model;

public class MessageServiceTest {
	
	private String url = "http://localhost:8080/PILottery/ncp.do";

	@Test
	public void test4001() throws UnsupportedEncodingException {

		Request4001Model request = new Request4001Model();
		request.setCMD(0x4001);
		request.setGameCode("6");
		request.setPerdIssue("2016088");
		
		String req = JSONObject.toJSONString(request);
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("req", req);	
		Object obj = HttpClientUtils.postWithParam(url, map);
		System.out.println(obj);
	}
	
	@Test
	public void test4002() throws UnsupportedEncodingException {
		
		Request4002Model request = new Request4002Model();
		request.setCMD(0x4002);
		request.setGameCode("6");
		request.setPerdIssue("2015002");
		request.setAgencyCode("100000003");
		
		String req = JSONObject.toJSONString(request);
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("req", req);
		Object obj = HttpClientUtils.postWithParam(url, map);
		System.out.println(obj);
	}
	
	@Test
	public void test4003() throws UnsupportedEncodingException {
		
		Request4003Model request = new Request4003Model();
		request.setCMD(0x4003);
		request.setPageSize(10);
		request.setPageIndex(1);
		request.setAreaCode("10");
		
		String req = JSONObject.toJSONString(request);
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("req", req);	
		Object obj = HttpClientUtils.postWithParam(url, map);
		System.out.println(obj);
	}
	
	@Test
	public void test4004() throws UnsupportedEncodingException {
		
		Request4004Model request = new Request4004Model();
		request.setCMD(0x4004);
		request.setNotCode("5");
		
		String req = JSONObject.toJSONString(request);
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("req", req);	
		Object obj = HttpClientUtils.postWithParam(url, map);
		System.out.println(obj);
	}
	
	@Test
	public void test4005() throws UnsupportedEncodingException {
		
		Request4005Model request = new Request4005Model();
		request.setCMD(0x4005);
		request.setGameCode("6");
		request.setPerdIssue("");
		request.setPageSize(10);
		request.setPageIndex(1);
		
		String req = JSONObject.toJSONString(request);
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("req", req);	
		Object obj = HttpClientUtils.postWithParam(url, map);
		System.out.println(obj);
	}
}
