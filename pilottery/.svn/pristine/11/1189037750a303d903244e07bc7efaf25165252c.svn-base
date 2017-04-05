package test.pos;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.junit.Test;

import cls.pilottery.common.utils.HttpClientUtils;
import cls.pilottery.common.utils.MD5Util;
import cls.pilottery.common.utils.TEAUtil;
import cls.pilottery.common.utils.ZipUtil;
import cls.pilottery.pos.common.model.BaseRequest;
import cls.pilottery.pos.system.model.LoginRequest;
import cls.pilottery.pos.system.model.OutletDaliyReportRequest;
import cls.pilottery.pos.system.model.OutletFlowRequest;
import cls.pilottery.pos.system.model.OutletGoodInfo;
import cls.pilottery.pos.system.model.OutletGoodsRecpRequest;
import cls.pilottery.pos.system.model.OutletPopupRequest;
import cls.pilottery.pos.system.model.OutletWithdrawConRequest;
import cls.pilottery.pos.system.model.OutletWithdrawRequest;
import cls.pilottery.pos.system.model.PayTicketRequest;
import cls.pilottery.pos.system.model.SecurityCode;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;

public class OutLetTest {

	@Test
	public void getOutletInfo() throws UnsupportedEncodingException{
		String temp =null;
		String url = "http://localhost:8080/PILottery/pos.do";
		
		BaseRequest request = new BaseRequest();
		request.setMethod("010001");
		request.setMsn(1);
		request.setWhen(System.currentTimeMillis()/1000);
		
		LoginRequest form = new LoginRequest();
		form.setUsername("saler66");
		form.setPassword("111111");
		form.setType("1");
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
			jsonObject = JSONObject.parseObject(token) ;
			token = jsonObject.get("token").toString();
			System.out.println("获取token："+ token);
		} catch (Exception e) {
			e.printStackTrace();
		} 
		
		request = new BaseRequest();
		request.setMethod("020401");
		request.setMsn(2);
		request.setToken(token);
		request.setWhen(System.currentTimeMillis()/1000);
		request.setParam("{\"outletCode\":\"00000001\"}");
	
	
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
	
	@Test
	public void getOutletFundFlow() throws UnsupportedEncodingException{
		String temp =null;
		String url = "http://localhost:8080/PILottery/pos.do";
		
		BaseRequest request = new BaseRequest();
		request.setMethod("010001");
		request.setMsn(1);
		request.setWhen(System.currentTimeMillis()/1000);
		
		LoginRequest form = new LoginRequest();
		form.setUsername("admin");
		form.setPassword("111111");
		form.setType("1");
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
			jsonObject = JSONObject.parseObject(token) ;
			token = jsonObject.get("token").toString();
			System.out.println("获取token："+ token);
		} catch (Exception e) {
			e.printStackTrace();
		} 
		
		request = new BaseRequest();
		request.setMethod("020402");
		request.setMsn(2);
		request.setToken(token);
		request.setWhen(System.currentTimeMillis()/1000);
		
		OutletFlowRequest req = new OutletFlowRequest();
		req.setCount(10);
		req.setFollow("");
		req.setOutletCode("03510001");
		request.setParam(req);
	
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
	
	@Test
	public void getDaliyList() throws UnsupportedEncodingException{
		String temp =null;
		String url = "http://localhost:8888/PILottery/pos.do";
		
		BaseRequest request = new BaseRequest();
		request.setMethod("010001");
		request.setMsn(4);
		request.setWhen(System.currentTimeMillis()/1000);
		
		LoginRequest form = new LoginRequest();
		form.setUsername("leader11");
		form.setPassword("111111");
		request.setParam(form);
		
	
		String reqJson = JSON.toJSONString(request);
		String md5 = MD5Util.MD5Encode(reqJson);
		byte[] paramBytes = (md5+reqJson).getBytes();
		paramBytes = ZipUtil.deflater(paramBytes);
		paramBytes = TEAUtil.encryptByTea(paramBytes);		
		/*byte[] result = HttpClientUtils.post(url, paramBytes);		
		result = TEAUtil.decryptByTea(result);		
		result = ZipUtil.infater(result);
		temp = new String(result,"utf-8");
		System.out.println("解压缩后消息为："+temp);
		System.out.println();*/
		byte[] result = null;
		String token = "0005201510281136326a310e21-d882-";		
		
		request = new BaseRequest();
		request.setMethod("020403");
		request.setMsn(3);
		request.setToken(token);
		request.setWhen(System.currentTimeMillis()/1000);
		
		OutletDaliyReportRequest req = new OutletDaliyReportRequest();
		req.setCount(10);
		req.setFollow("");
		req.setOutletCode("03510001");
		request.setParam(req);
	
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
	
	@Test
	public void getOutletTopup() throws UnsupportedEncodingException{
		String temp =null;
		String url = "http://localhost:8080/PILottery/pos.do";
		
		BaseRequest request = new BaseRequest();
		request.setMethod("010001");
		request.setMsn(1);
		request.setWhen(System.currentTimeMillis()/1000);
		
		LoginRequest form = new LoginRequest();
		form.setUsername("saler6666");
		form.setPassword("111111");
		form.setType("1");
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
			jsonObject = JSONObject.parseObject(token) ;
			token = jsonObject.get("token").toString();
			System.out.println("获取token："+ token);
		} catch (Exception e) {
			e.printStackTrace();
		} 
		
		request = new BaseRequest();
		request.setMethod("020404");
		request.setMsn(2);
		request.setToken(token);
		request.setWhen(System.currentTimeMillis()/1000);
		
		OutletPopupRequest flow = new OutletPopupRequest();
		flow.setOutletCode("01010001");
		flow.setTransPassword("111111");
		//flow.setAdminId(68);
		flow.setAmount(5000000);
	
		request.setParam(flow);
		
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
	
	@Test
	public void addCashWithdrawn() throws UnsupportedEncodingException{
		String temp =null;
		String url = "http://localhost:8080/PILottery/pos.do";
		
		BaseRequest request = new BaseRequest();
		request.setMethod("010001");
		request.setMsn(1);
		request.setWhen(System.currentTimeMillis()/1000);
		
		LoginRequest form = new LoginRequest();
		form.setUsername("saler44");
		form.setPassword("222222");
		form.setType("1");
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
			jsonObject = JSONObject.parseObject(token) ;
			token = jsonObject.get("token").toString();
			System.out.println("获取token："+ token);
		} catch (Exception e) {
			e.printStackTrace();
		} 
		
		request = new BaseRequest();
		request.setMethod("020406");
		request.setMsn(2);
		request.setToken(token);
		request.setWhen(System.currentTimeMillis()/1000);
		
		
		OutletWithdrawRequest flow = new OutletWithdrawRequest();		
		flow.setAmount(10000);
		flow.setOutletCode("01010006");			
		request.setParam(flow);
		
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
	
	@Test
	public void confirmCashWithdrawn() throws UnsupportedEncodingException{
		String temp =null;
		String url = "http://localhost:8080/PILottery/pos.do";
		
		BaseRequest request = new BaseRequest();
		request.setMethod("010001");
		request.setMsn(1);
		request.setWhen(System.currentTimeMillis()/1000);
		
		LoginRequest form = new LoginRequest();
		form.setUsername("admin");
		form.setPassword("111111");
		form.setType("1");
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
			jsonObject = JSONObject.parseObject(token) ;
			token = jsonObject.get("token").toString();
			System.out.println("获取token："+ token);
		} catch (Exception e) {
			e.printStackTrace();
		} 
		
		request = new BaseRequest();
		request.setMethod("020407");
		request.setMsn(2);
		request.setToken(token);
		request.setWhen(System.currentTimeMillis()/1000);
		
		
		OutletWithdrawConRequest flow = new OutletWithdrawConRequest();		
		flow.setPassword("96e79218965eb72c92a549dd5a330112");
		flow.setWithdrawnCode("FA00000023");
		flow.setOutletCode("03510001");			
		request.setParam(flow);
		
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
	
	@Test
	public void addOutletGoodsReceipts() throws UnsupportedEncodingException{
		String temp =null;
		String url = "http://localhost:8080/PILottery/pos.do";
		
		BaseRequest request = new BaseRequest();
		request.setMethod("010001");
		request.setMsn(1);
		request.setWhen(System.currentTimeMillis()/1000);
		
		LoginRequest form = new LoginRequest();
		form.setUsername("saler66");
		form.setPassword("111111");
		form.setType("1");
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
			jsonObject = JSONObject.parseObject(token) ;
			token = jsonObject.get("token").toString();
			System.out.println("获取token："+ token);
		} catch (Exception e) {
			e.printStackTrace();
		} 
		
		request = new BaseRequest();
		request.setMethod("020408");
		request.setMsn(2);
		request.setToken(token);
		request.setWhen(System.currentTimeMillis()/1000);
		
		
		OutletGoodsRecpRequest flow = new OutletGoodsRecpRequest();		
		flow.setPassword("96e79218965eb72c92a549dd5a330112");
		flow.setOutletCode("01010001");	
		
		List<OutletGoodInfo> glist =new ArrayList<OutletGoodInfo>();
		OutletGoodInfo g = new OutletGoodInfo();
		g.setGoodsTag("J20160000101010010000000210000030");
		g.setTickets(10000);
		glist.add(g);
//		g = new OutletGoodInfo();
//		g.setGoodsTag("J201500002001311001001001010000101000200150312001300119.6guardz");
//		g.setTickets(10000);
//		glist.add(g);
		flow.setGoodsTagList(glist);
		request.setParam(flow);
		
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
	
	//退货入库
	@Test
	public void returnGoods() throws UnsupportedEncodingException{
		String temp =null;
		String url = "http://localhost:8080/PILottery/pos.do";
		
		BaseRequest request = new BaseRequest();
		request.setMethod("010001");
		request.setMsn(1);
		request.setWhen(System.currentTimeMillis()/1000);
		
		LoginRequest form = new LoginRequest();
		form.setUsername("saler6666");
		form.setPassword("111111");
		form.setType("1");
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
			jsonObject = JSONObject.parseObject(token) ;
			token = jsonObject.get("token").toString();
			System.out.println("获取token："+ token);
		} catch (Exception e) {
			e.printStackTrace();
		} 
		
		request = new BaseRequest();
		request.setMethod("020410");
		request.setMsn(2);
		request.setToken(token);
		request.setWhen(System.currentTimeMillis()/1000);
		
		
		OutletGoodsRecpRequest flow = new OutletGoodsRecpRequest();		
		flow.setOutletCode("01010001");	
		
		List<OutletGoodInfo> glist =new ArrayList<OutletGoodInfo>();
		OutletGoodInfo g = new OutletGoodInfo();
		g.setGoodsTag("J2016000010001000000001100100");
		g.setTickets(100);
		glist.add(g);
		flow.setGoodsTagList(glist);
		request.setParam(flow);
		
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
	
	@Test
	public void payout() throws UnsupportedEncodingException{
		String temp =null;
		String url = "http://localhost:8080/PILottery/pos.do";
		
		BaseRequest request = new BaseRequest();
		request.setMethod("010001");
		request.setMsn(1);
		request.setWhen(System.currentTimeMillis()/1000);
		
		LoginRequest form = new LoginRequest();
		form.setUsername("saler44");
		form.setPassword("222222");
		form.setType("1");
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
			jsonObject = JSONObject.parseObject(token) ;
			token = jsonObject.get("token").toString();
			System.out.println("获取token："+ token);
		} catch (Exception e) {
			e.printStackTrace();
		} 
		
		request = new BaseRequest();
		request.setMethod("020411");
		request.setMsn(2);
		request.setToken(token);
		request.setWhen(System.currentTimeMillis()/1000);
		
		
		PayTicketRequest flow = new PayTicketRequest();		
		flow.setOutletCode("01010006");	
		
		List<SecurityCode> securityCodeLis = new ArrayList<SecurityCode>();
		
		SecurityCode x1 = new SecurityCode();
		x1.setSecurityCode("X2016000010000004177DKTSANFUBVYUNAORJ0066");
		securityCodeLis.add(x1);
		x1 = new SecurityCode();
		x1.setSecurityCode("U2016000010000004134DKTSANFUBVYUNAORJ0088");
		securityCodeLis.add(x1);
		flow.setSecurityCodeList(securityCodeLis );
		//flow.setSecurityCodeList(map);
		
		request.setParam(flow);
		
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
