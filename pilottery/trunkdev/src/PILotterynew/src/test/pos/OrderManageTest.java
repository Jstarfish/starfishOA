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
import cls.pilottery.pos.system.model.AddDeliveryDetail;
import cls.pilottery.pos.system.model.AddDeliveryRequest;
import cls.pilottery.pos.system.model.DeliveryOrderRequest;
import cls.pilottery.pos.system.model.DoDetailRequest;
import cls.pilottery.pos.system.model.PurchaseOrderRequest;

import com.alibaba.fastjson.JSON;

public class OrderManageTest {
	@Test
	public void getDeliveryOrderList() throws UnsupportedEncodingException{
		//String url = "http://192.168.26.29:9090/PILottery/pos.do";
		String url = "http://localhost:8888/PILottery/pos.do";
		BaseRequest request = new BaseRequest();
		request.setMethod("020101");
		request.setToken("000020150924180255b9845e86-db9d-");
		request.setMsn(4);
		DeliveryOrderRequest dor = new DeliveryOrderRequest();
		dor.setCount(20);
		dor.setFollow("dsfa");
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
	public void getDeliveryOrderDetail() throws UnsupportedEncodingException{
		//String url = "http://192.168.26.29:9090/PILottery/pos.do";
		String url = "http://localhost:8888/PILottery/pos.do";
		BaseRequest request = new BaseRequest();
		request.setMethod("020102");
		request.setToken("000020150924180255b9845e86-db9d-");
		request.setMsn(5);
		DoDetailRequest dor = new DoDetailRequest();
		dor.setDeliveryOrder("CH00000126");
		request.setParam(dor);
		
		String reqJson = JSON.toJSONString(request);
		String md5 = MD5Util.MD5Encode(reqJson);
		System.out.println(md5+reqJson);
		byte[] paramBytes = (md5+reqJson).getBytes();
		System.out.println("请求消息为：");
		System.out.println(Arrays.toString(paramBytes));
		
		paramBytes = ZipUtil.deflater(paramBytes);
		paramBytes = TEAUtil.encryptByTea(paramBytes);
		byte[] result = HttpClientUtils.post(url, paramBytes);
		result = TEAUtil.decryptByTea(result);
		result = ZipUtil.infater(result);
		System.out.println("响应消息为：");
		
		System.out.println(Arrays.toString(result));
		System.out.println(new String(result,"utf-8"));
	}
	
	@Test
	public void addDeliveryOrder() throws UnsupportedEncodingException{
		//String url = "http://192.168.26.29:9090/PILottery/pos.do";
		String url = "http://localhost:8888/PILottery/pos.do";
		BaseRequest request = new BaseRequest();
		request.setMethod("020103");
		request.setToken("0000201509251736390d5c7fe0-51ff-");
		request.setMsn(5);
		AddDeliveryRequest req = new AddDeliveryRequest();
		List<String> orderList = new ArrayList<String>();
		orderList.add("CH00000126");
		List<AddDeliveryDetail> detailList = new ArrayList<AddDeliveryDetail>();
		AddDeliveryDetail d1 = new AddDeliveryDetail();
		d1.setPlanCode("J2015");
		d1.setTickets(13);
		detailList.add(d1);
		req.setPlansList(detailList);
		req.setOrderList(orderList);
		request.setParam(req);
		
		String reqJson = JSON.toJSONString(request);
		String md5 = MD5Util.MD5Encode(reqJson);
		System.out.println(md5+reqJson);
		byte[] paramBytes = (md5+reqJson).getBytes();
		System.out.println("请求消息为：");
		System.out.println(Arrays.toString(paramBytes));
		
		paramBytes = ZipUtil.deflater(paramBytes);
		paramBytes = TEAUtil.encryptByTea(paramBytes);
		byte[] result = HttpClientUtils.post(url, paramBytes);
		result = TEAUtil.decryptByTea(result);
		result = ZipUtil.infater(result);
		System.out.println("响应消息为：");
		
		System.out.println(Arrays.toString(result));
		System.out.println(new String(result,"utf-8"));
	}
	
	@Test
	public void getOrderList() throws UnsupportedEncodingException{
		//String url = "http://192.168.26.29:9090/PILottery/pos.do";
		String url = "http://localhost:8888/PILottery/pos.do";
		BaseRequest request = new BaseRequest();
		request.setMethod("020104");
		request.setToken("00002015101315034412c1ce3f-a87c-");
		request.setMsn(2);
		PurchaseOrderRequest req = new PurchaseOrderRequest();
		req.setCount(30);
		request.setParam(req);
		
		String reqJson = JSON.toJSONString(request);
		String md5 = MD5Util.MD5Encode(reqJson);
		System.out.println(md5+reqJson);
		byte[] paramBytes = (md5+reqJson).getBytes();
		System.out.println("请求消息为：");
		System.out.println(Arrays.toString(paramBytes));
		
		paramBytes = ZipUtil.deflater(paramBytes);
		paramBytes = TEAUtil.encryptByTea(paramBytes);
		byte[] result = HttpClientUtils.post(url, paramBytes);
		result = TEAUtil.decryptByTea(result);
		result = ZipUtil.infater(result);
		System.out.println("响应消息为：");
		
		System.out.println(Arrays.toString(result));
		System.out.println(new String(result,"utf-8"));
	}
	
	@Test
	public void getFundList() throws UnsupportedEncodingException{
		//String url = "http://192.168.26.29:9090/PILottery/pos.do";
		String url = "http://localhost:8888/PILottery/pos.do";
		BaseRequest request = new BaseRequest();
		request.setMethod("020204");
		request.setToken("00002015101315034412c1ce3f-a87c-");
		request.setMsn(2);
		PurchaseOrderRequest req = new PurchaseOrderRequest();
		req.setCount(30);
		request.setParam(req);
		String reqJson = "{\"method\":\"020402\",\"msn\":3,\"param\":{\"count\":500,\"outletCode\":\"01010002\",\"follow\":\"\"},\"token\":\"00122015101917282268af54c8-2e49-\",\"when\":1445232464}";
		
		//String reqJson = "{\"method\":\"020204\",\"msn\":2,\"param\":{\"count\":500,\"follow\":\"\"},\"token\":\"00122015101917282268af54c8-2e49-\",\"when\":1445234028}";
		//String reqJson = JSON.toJSONString(request);
		String md5 = MD5Util.MD5Encode(reqJson);
		System.out.println(md5+reqJson);
		byte[] paramBytes = (md5+reqJson).getBytes();
		System.out.println("请求消息为：");
		System.out.println(Arrays.toString(paramBytes));
		
		paramBytes = ZipUtil.deflater(paramBytes);
		paramBytes = TEAUtil.encryptByTea(paramBytes);
		byte[] result = HttpClientUtils.post(url, paramBytes);
		result = TEAUtil.decryptByTea(result);
		result = ZipUtil.infater(result);
		System.out.println("响应消息为：");
		
		System.out.println(Arrays.toString(result));
		System.out.println(new String(result,"utf-8"));
	}
	
}
