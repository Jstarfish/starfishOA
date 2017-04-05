package test.pos;

import java.io.UnsupportedEncodingException;
import java.util.Arrays;

import org.junit.Test;

import cls.pilottery.common.utils.TEAUtil;
import cls.pilottery.pos.common.model.BaseRequest;

import com.alibaba.fastjson.JSONObject;

public class EncryptTest {
	
	@Test
	public void testEncrypt() throws UnsupportedEncodingException{
		BaseRequest req = new BaseRequest();
		req.setToken("256F7E779A787C7798FE7");
		req.setMethod("22222");
		req.setMsn(1L);
		req.setWhen(System.currentTimeMillis()/1000);
		req.setParam("test");
		
		String reqJson = JSONObject.toJSONString(req);
		System.out.println(reqJson);
		byte[] b = TEAUtil.encryptByTea(reqJson.getBytes());
		
		System.out.println(Arrays.toString(b));
	}
	
	@Test
	public void testDecrypt() throws UnsupportedEncodingException{
		BaseRequest req = new BaseRequest();
		req.setToken("256F7E779A787C7798FE7");
		req.setMethod("22222");
		req.setMsn(1L);
		req.setWhen(System.currentTimeMillis()/1000);
		req.setParam("test");
		
		String reqJson = JSONObject.toJSONString(req);
		System.out.println(reqJson);
		byte[] b = TEAUtil.encryptByTea(reqJson.getBytes());
		
		System.out.println(new String(b,"utf-8"));
		System.out.println(Arrays.toString(b));
		
		System.out.println(TEAUtil.decryptByTea(b));
		
	}
}
