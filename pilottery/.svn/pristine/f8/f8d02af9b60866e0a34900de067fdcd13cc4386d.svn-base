package test.pos;

import java.io.UnsupportedEncodingException;
import java.util.Arrays;

import org.junit.Test;

import cls.pilottery.common.utils.HttpClientUtils;
import cls.pilottery.common.utils.MD5Util;
import cls.pilottery.common.utils.TEAUtil;
import cls.pilottery.common.utils.ZipUtil;
import cls.pilottery.pos.common.model.BaseRequest;
import cls.pilottery.pos.system.model.bank.BankTopupRequest;
import cls.pilottery.pos.system.model.bank.BankWithdrawRequest;
import cls.pilottery.pos.system.model.bank.OutletAccInfoRequest;

import com.alibaba.fastjson.JSON;

public class BankServiceTest {
	
	
	String token="0012201703311550111f319188-01d1-";
	//String url = "http://192.168.26.74:8080/PILottery/pos.do";
	String url = "http://localhost:8080/PILottery/pos.do";
	@Test
	public void testTopupType() throws UnsupportedEncodingException{
		
		BaseRequest request = new BaseRequest();
		request.setMethod("030001");
		request.setToken(token);
		request.setMsn(5);

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
	public void OutletBankAccInfo() throws UnsupportedEncodingException{
		BaseRequest request = new BaseRequest();
		request.setMethod("030002");
		request.setToken(token);
		request.setMsn(3);
		OutletAccInfoRequest ac = new OutletAccInfoRequest();
		ac.setOutletCode("15000001");
		ac.setTypeCode(2);
		request.setParam(ac);
		
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
	public void bankTopUp() throws UnsupportedEncodingException{
		
		BaseRequest request = new BaseRequest();
		request.setMethod("030003");
		request.setToken(token);
		request.setMsn(2);
		BankTopupRequest dor = new BankTopupRequest();
		dor.setAccountID("00383661");
		dor.setAmount(10000);
		dor.setOutletCode("15000001");
		dor.setTransPassword("96e79218965eb72c92a549dd5a330112");
		dor.setVerifyCode("413885");
		request.setParam(dor);
		
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
	public void testbankWithdraw() throws UnsupportedEncodingException{
		BaseRequest request = new BaseRequest();
		request.setMethod("030004");
		request.setToken(token);
		request.setMsn(10);
		BankWithdrawRequest dor = new BankWithdrawRequest();
		dor.setAccountID("00614777");
		dor.setAmount(10000);
		dor.setOutletCode("15000001");
		dor.setPassword("96e79218965eb72c92a549dd5a330112");
		request.setParam(dor);
		
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
}
