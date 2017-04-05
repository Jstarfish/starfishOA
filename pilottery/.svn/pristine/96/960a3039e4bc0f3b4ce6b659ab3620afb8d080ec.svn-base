package test.webncp;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.junit.Test;

import com.alibaba.fastjson.JSONObject;

import cls.pilottery.common.utils.HttpClientUtils;
import cls.pilottery.webncp.system.model.Request3001Model;

public class WebncpTest {

	@Test
	public void testPost() throws UnsupportedEncodingException{
		String url = "http://localhost:8080/PILottery/ncp.do";
		
		String req = "{\"CMD\":12289,\"gameCode\":7}";
		
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("req", req);
		
		
		Object obj = HttpClientUtils.postWithParam(url, map);
		
		System.out.println(obj);
	}
	
	@Test
	public void testJson(){
		Request3001Model obj1 = new Request3001Model();
		obj1.setAgencyCode("1");
		obj1.setCMD(1);
		
		Request3001Model obj2 = new Request3001Model();
		obj2.setAgencyCode("2");
		obj2.setCMD(2);
		
		Request3001Model obj3 = new Request3001Model();
		obj3.setAgencyCode("3");
		obj3.setCMD(3);
		
		Request3001Model obj4 = new Request3001Model();
		obj4.setAgencyCode("4");
		obj4.setCMD(4);
		
		Request3001Model obj5 = new Request3001Model();
		obj5.setAgencyCode("5");
		obj5.setCMD(5);
		
		List<Request3001Model> list = new ArrayList<Request3001Model>();
		list.add(obj1);
		list.add(obj2);
		list.add(obj3);
		list.add(obj4);
		list.add(obj5);
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("aaa", "test");
		map.put("bbb", 123);
		map.put("ccc", list);
		
		String str = JSONObject.toJSONString(map);
		System.out.println(str);
	}
	
}
