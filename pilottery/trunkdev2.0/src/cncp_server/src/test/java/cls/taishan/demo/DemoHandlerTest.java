package cls.taishan.demo;

import java.util.HashMap;
import java.util.Map;

import org.junit.Test;

import com.alibaba.fastjson.JSON;

import cls.taishan.common.utils.HttpClientUtils;
import cls.taishan.demo.entity.User;

public class DemoHandlerTest {
	
	/*@Test
	public void testJsonParam() throws Exception{
		String url = "http://localhost:8080/demo/123";
		
		User user = new User();
		user.setUserId(99);
		user.setLoginName("zhangsan");
		String json = JSON.toJSONString(user);
		
		//HttpClientUtils.get(url);
		String result = HttpClientUtils.postString(url, json);
		System.out.println(result);
	}
	
	@Test
	public void testService() throws Exception{
		String url = "http://localhost:8080/demo";
		User user = new User();
		user.setUserId(99);
		user.setLoginName("zhangsan");
		String json = JSON.toJSONString(user);
		
		//HttpClientUtils.get(url);
		String result = HttpClientUtils.postString(url, json);
		System.out.println(result);
	}
	
	@Test
	public void testGetUserById() throws Exception{
		String url = "http://localhost:8080/demo/getUserById";
		
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("userId", 12);
		
		String result = HttpClientUtils.postString(url, JSON.toJSONString(map));
		System.out.println(result);
	}
	
	@Test
	public void testGetUserByAnnotation() throws Exception{
		String url = "http://localhost:8080/demo/getUserByAnnotation";
		
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("userId", 12);
		
		String result = HttpClientUtils.postString(url, JSON.toJSONString(map));
		System.out.println(result);
	}
	
	@Test
	public void testGetUserList(){
		String url = "http://localhost:8080/demo/getUserList";
		
		String result = HttpClientUtils.postString(url,"");
		System.out.println(result);
	}*/

}
