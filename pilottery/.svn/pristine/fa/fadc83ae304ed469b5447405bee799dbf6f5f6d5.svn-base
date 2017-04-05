package com.huacai.assist.net;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InterruptedIOException;
import java.io.UnsupportedEncodingException;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.StatusLine;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.methods.HttpUriRequest;
import org.apache.http.conn.ClientConnectionManager;
import org.apache.http.conn.HttpHostConnectException;
import org.apache.http.entity.ByteArrayEntity;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.params.CoreConnectionPNames;
import org.json.JSONException;
import org.json.JSONObject;

import android.util.Log;

import com.huacai.assist.common.App;
import com.huacai.assist.common.Crypto;
import com.huacai.assist.common.TEAUtil;
import com.huacai.assist.common.ZipUtil;
import com.huacai.assist.common.appData;
import com.huacai.pistore.R;

public class HttpManager {
//	private static String ServerUrl = "http://192.168.26.29:9090/PILottery/pos.do";
	private static String serverUri = "/PILottery/pos.do";
	public static void initNetParams(){
		
	}
	
	private static NetResult DecodeData(byte[] rdata)
	{
		NetResult result = new NetResult(0, "ok");
        try {
			byte[] decoded = TEAUtil.decryptByTea(rdata);
			byte[] decompressed = ZipUtil.infater(decoded);
			String rsp = new String(decompressed, "UTF-8");
			Log.e("yyc", "DecodeData el "+decoded.length+", dl "+decompressed.length+"\n"+rsp);
			result.jsonObject = new JSONObject(rsp);
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		} catch (JSONException e) {
			e.printStackTrace();
		}
		return result;
	}
	
	private static byte[] EncodeData(final JSONObject jo)
	{
		String jsonStr = jo.toString();
		Log.e("yyc", "EncodeData "+jsonStr);
		jsonStr = Crypto.getMd5Hash(jsonStr)+jsonStr;
		try {
			byte[] compressd = ZipUtil.deflater(jsonStr.getBytes("UTF-8"));
			byte[] encrypted = TEAUtil.encryptByTea(compressd);
			return encrypted;
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return null;
	}
	
	public HttpClient client = null;
	
	public HttpManager(){
		initHttpManager();
	}
	
	public void initHttpManager(){
		client = new DefaultHttpClient();
//		请求超时15秒
		client.getParams().setParameter(CoreConnectionPNames.CONNECTION_TIMEOUT,15000);
//		读取超时15秒
        client.getParams().setParameter(CoreConnectionPNames.SO_TIMEOUT,15000);

	}
	
	static String serverUrl = "http://"
			+appData.usingServerIpAddress+":"+appData.usingServerPort
			+serverUri;
	public static void updateServerConfig() {
		if (appData.usingServerIpAddress.length() == 0) {
			appData.useIp1();
		}
		serverUrl = "http://"
				+appData.usingServerIpAddress+":"+appData.usingServerPort
				+serverUri;
	}
    public NetResult openUrl(final JSONObject jo){
    		NetResult result = null;
        HttpUriRequest request = null;
        ByteArrayOutputStream bos = null;
        HttpPost post;
        if(client == null)
        	initHttpManager();
        try {
        		post = new HttpPost(serverUrl);
            request = post;
            byte[] data = null;
           
            bos = new ByteArrayOutputStream();
       
            data = EncodeData(jo);
            bos.write(data);
 
            data = bos.toByteArray();
            bos.close();
            ByteArrayEntity formEntity = new ByteArrayEntity(data);
            post.setEntity(formEntity);
            
            HttpResponse response = client.execute(request);
            StatusLine status = response.getStatusLine();
            int statusCode = status.getStatusCode();
            
            if (statusCode != 200) {
                String terror = status.getReasonPhrase();
                result = new NetResult(1,terror);
            }else{
            		byte[] resp = readHttpResponse(response);
				result = DecodeData(resp);
            }
        }catch (InterruptedIOException e){
//          联接超时
	        	result = new NetResult(NetResult.TIMEOUTEXCEPTION,App.getResString(R.string.alert_title_net_timeout));
	        	System.out.println("error in HttpManager 联接超时");
        } catch (HttpHostConnectException e) {
//        	连接失败，地址错误
//        	需要更换ip重新连接
        		AsyncRunner.repeat = true;
	        	System.out.println("==========="+appData.usingServerIpAddress+":"+appData.usingServerPort+"_____error=====================================================");
        } catch (IllegalArgumentException e) {
        		result = new NetResult(NetResult.PARAM_ERROR,App.getResString(R.string.alert_title_net_param_error));
	        System.out.println("error in HttpManager "+e.toString());
        } catch (Exception e) {
//        	其他未知异常
        		result = new NetResult(NetResult.UNKNOWEXCEPTION,App.getResString(R.string.alert_title_net_unknow));
	        System.out.println("error in HttpManager "+e.toString());
        }
        request = null;
        bos = null;
        post = null;
        client = null;
        return result;
    }
    
    public  void shutDown(){
	    	if(client != null){
	    		ClientConnectionManager clientmanager = client.getConnectionManager();
	    		clientmanager.shutdown();
	    		clientmanager = null;
	    		client = null;
	    	}
    }
    
    private byte[] readHttpResponse(HttpResponse response) {
        HttpEntity entity = response.getEntity();
        InputStream inputStream;
        try {
            inputStream = entity.getContent();
            ByteArrayOutputStream content = new ByteArrayOutputStream();

            int readBytes = 0;
            byte[] sBuffer = new byte[1500];
            while ((readBytes = inputStream.read(sBuffer)) != -1) {
                content.write(sBuffer, 0, readBytes);
            }
            return content.toByteArray();
        } catch (IllegalStateException e) {
        	
        } catch (IOException e) {
        	
        }
        return null;
    }
}
