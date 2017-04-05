package test.pos;

import java.io.UnsupportedEncodingException;
import java.util.Arrays;

import org.junit.Test;

import cls.pilottery.common.utils.HttpClientUtils;
import cls.pilottery.common.utils.MD5Util;
import cls.pilottery.common.utils.TEAUtil;
import cls.pilottery.common.utils.ZipUtil;
import cls.pilottery.pos.common.model.BaseRequest;
import cls.pilottery.pos.system.model.LoginRequest;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;

public class SystemTest {

	@Test
	public void testLogin() throws UnsupportedEncodingException{
		//String url = "http://192.168.26.74:8080/PILottery/pos.do";
		String url = "http://localhost:8080/PILottery/pos.do";
		BaseRequest request = new BaseRequest();
		request.setMethod("010001");
		request.setMsn(2);
		request.setWhen(System.currentTimeMillis()/1000);
		
		LoginRequest form = new LoginRequest();
		form.setUsername("cmmsc");
		form.setPassword("222222");
		form.setVersion("1.0.35");
		form.setType("1");
		form.setDeviceSign("2222");
		form.setDeviceType("0");
		request.setParam(form);
		
	
		String reqJson = JSON.toJSONString(request);
		String md5 = MD5Util.MD5Encode(reqJson);
		System.out.println(md5+reqJson);
		byte[] paramBytes = (md5+reqJson).getBytes();
		System.out.println("请求消息为：");
		System.out.println(Arrays.toString(paramBytes));
		
		paramBytes = ZipUtil.deflater(paramBytes);
		System.out.println("压缩后的请求消息为：");
		System.out.println(Arrays.toString(paramBytes));
		
		paramBytes = TEAUtil.encryptByTea(paramBytes);
		System.out.println("加密后的消息为：");
		System.out.println(Arrays.toString(paramBytes));
		
		byte[] result = HttpClientUtils.post(url, paramBytes);
		System.out.println("收到响应消息,响应消息为：");
		System.out.println(Arrays.toString(result));
		
		result = TEAUtil.decryptByTea(result);
		System.out.println("解密后消息为：");
		System.out.println(Arrays.toString(result));
		
		result = ZipUtil.infater(result);
		System.out.println("解压缩后消息为：");
		System.out.println(Arrays.toString(result));
		System.out.println(new String(result,"utf-8"));
	}
	
	@Test
	public void testPlanList() throws UnsupportedEncodingException{
		
		String temp =null;
		String url = "http://192.168.26.29:9090/PILottery/pos.do";
		
		BaseRequest request = new BaseRequest();
		request.setMethod("010001");
		request.setMsn(1);
		request.setWhen(System.currentTimeMillis()/1000);
		
		LoginRequest form = new LoginRequest();
		form.setUsername("admin");
		form.setPassword("111111");
		request.setParam(form);
		
	
		String reqJson = JSON.toJSONString(request);
		String md5 = MD5Util.MD5Encode(reqJson);
		byte[] paramBytes = (md5+reqJson).getBytes();
		paramBytes = ZipUtil.deflater(paramBytes);
		paramBytes = TEAUtil.encryptByTea(paramBytes);		
		byte[] result = HttpClientUtils.post(url, paramBytes);		
		result = TEAUtil.decryptByTea(result);		
		result = ZipUtil.infater(result);
		temp = new String(result,"utf-8");
		System.out.println("解压缩后消息为："+temp);
		System.out.println();
		
		
		String token = null;		
		try {
			JSONObject jsonObject = JSONObject.parseObject(temp) ;
			token = jsonObject.get("result").toString();
			System.out.println("获取token："+ token);
		} catch (Exception e) {
			e.printStackTrace();
		} 
		
		
		request = new BaseRequest();
		request.setMethod("990001");
		request.setMsn(1);
		request.setToken(token);
		request.setWhen(System.currentTimeMillis()/1000);
	
	
		reqJson = JSON.toJSONString(request);
		md5 = MD5Util.MD5Encode(reqJson);
		System.out.println(md5+reqJson);
		paramBytes = (md5+reqJson).getBytes();
		System.out.println("请求消息为：");
		System.out.println(Arrays.toString(paramBytes));
		
		paramBytes = ZipUtil.deflater(paramBytes);
		System.out.println("压缩后的请求消息为：");
		System.out.println(Arrays.toString(paramBytes));
		
		paramBytes = TEAUtil.encryptByTea(paramBytes);
		System.out.println("加密后的消息为：");
		System.out.println(Arrays.toString(paramBytes));
		
		result = HttpClientUtils.post(url, paramBytes);
		System.out.println("收到响应消息,响应消息为：");
		System.out.println(Arrays.toString(result));
		
		result = TEAUtil.decryptByTea(result);
		System.out.println("解密后消息为：");
		System.out.println(Arrays.toString(result));
		
		result = ZipUtil.infater(result);
		System.out.println("解压缩后消息为：");
		System.out.println(Arrays.toString(result));
		System.out.println(new String(result,"utf-8"));
		
		
	}
}
