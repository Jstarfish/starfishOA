package cls.facebook.ncpimpl;

import java.io.IOException;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.http.HttpEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;

import cls.facebook.utils.DateUtil;
import cls.facebook.utils.EncryptUtils;
import cls.pilottery.common.utils.HttpClientUtils;

import com.alibaba.fastjson.JSON;

public class TestMessage {

	/**
	 * @param args
	 */
	@SuppressWarnings("null")
	public static void main(String[] args) {
		String deskey = "12345678";
		
		String temgp ="{\"CMD\":20481, \"mac_addr\":\"00:0b:ab:6b:65:df\"}";
		String enjsonb = EncryptUtils.encrypt(temgp, deskey);
		System.out.println("orginal:  req="+enjsonb);
		Request4001Model req = new Request4001Model();
		req.setCMD(0x4001);
		req.setGameCode("12");
		req.setPerdIssue("160616001");
		
		String json = JSON.toJSONString(req);
		System.out.println("orginal:  req="+json);
		
		String enjson = EncryptUtils.encrypt(json, deskey);
		System.out.println("encrpt: http://202.131.84.150:21002/PILottery/ncp.do?req="+enjson);
		
		
		try {
			String result = HttpClientUtils.get("http://202.131.84.150:21002/PILottery/ncp.do?req="+enjson);
			System.out.println("get the origion :" + result );
			result = EncryptUtils.decrypt(result, deskey);
			Response4001Model jn =JSON.parseObject(result, Response4001Model.class);
			if(jn == null)
				System.out.println("get the object :" + jn.getPerdIssue() );
			
		} catch (Exception e1) {
			e1.printStackTrace();
		}
		
		Response4090Model rspSuccess = new Response4090Model();
		rspSuccess.setCMD(0x4090);
		rspSuccess.setGameCode("6");
		rspSuccess.setPerdIssue("160809003");
		rspSuccess.setDrawTime("2016-06-08 12:00:00");
		rspSuccess.setDrawCode("01,03,07,09,11");
		
		List<Response4001Record> prizeLevelInfo = new ArrayList<Response4001Record>();//just for test as so
		prizeLevelInfo.add(new Response4001Record("1", 120000, 2000000l, 100000l, "前三"));
		prizeLevelInfo.add(new Response4001Record("2", 12000, 200000l, 1000l, "前二"));
		
		rspSuccess.setPrzieInfo(new ArrayList<Response4001Record>(prizeLevelInfo));	
		json = JSON.toJSONString(rspSuccess);
		System.out.println("orginal:  rep="+json);
		enjson = EncryptUtils.encrypt(json, deskey);
		System.out.println("encrpt:  rep="+enjson);
		
		
		System.out.println("------------next 0x4091------------");
		req = new Request4001Model();
		req.setCMD(0x4091);
		req.setGameCode("6");
		req.setPerdIssue("0");
		
		json = JSON.toJSONString(req);
		System.out.println("orginal:  req="+json);
		enjson = EncryptUtils.encrypt(json, deskey);
		System.out.println("encrpt:  req="+enjson);
		
		
		List<Response4001Vo> drawInfo = new ArrayList<Response4001Vo>();
		long issue = 20160608000l;
		String drawcode ="";
		for(int i=0;i<50;i++)
		{
			issue = 20160608000l +i;
			drawcode ="";
			DecimalFormat d = new DecimalFormat("00");
			for(int g=0;g<5;g++)
			{
				int rnum =(int)(Math.random()*12);
				if(g == 0){
					
					drawcode = d.format(rnum);
				}
				else{
					drawcode = drawcode +","+d.format(rnum);
				}										
			}
						
			drawInfo.add(new Response4001Vo("6", issue+"", drawcode, DateUtil.getDate(new Date())));
		}
		Response4091Model rspSuccess1 = new Response4091Model();
		rspSuccess1.setCMD(0x4091);
		rspSuccess1.setIssueList(drawInfo);
		
		json = JSON.toJSONString(rspSuccess1);
		System.out.println("orginal:  rep="+json);
		enjson = EncryptUtils.encrypt(json, deskey);
		System.out.println("encrpt:  rep="+enjson);
		
		
		String testjsonurl ="http://jsonplaceholder.typicode.com/posts";

		
		
		CloseableHttpClient httpclient = HttpClients.createDefault();
		HttpGet httpGet = new HttpGet(testjsonurl);
		CloseableHttpResponse response1 =null;
		try {
			response1 = httpclient.execute(httpGet);
		    System.out.println(response1.getStatusLine());
		    HttpEntity entity1 = response1.getEntity();
		    // do something useful with the response body
		    // and ensure it is fully consumed
		    EntityUtils.consume(entity1);
	
		    System.out.println(response1);
		} catch (Exception e) {
			e.printStackTrace();		
		} finally {
		    try {
				response1.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}

	  try {
		String myst = HttpClientUtils.get(testjsonurl);
		
		System.out.println(myst);
		
	} catch (Exception e) {
		e.printStackTrace();
	}
		
		
	}

}
