package com.huacai.assist.net;

import org.json.JSONObject;

import com.huacai.assist.common.App;
import com.huacai.assist.common.appData;
import com.huacai.pistore.R;

public class AsyncRunner {
	
	public static HttpManager tmanager = null;

	/**
	 * 是否需要更换ip和端口号后重试
	 */
	public static boolean repeat = false;
	
    public static void request(final JSONObject jo,
            final RequestListener listener) {
    		App.showProgressDialogIfNeccesary();
	    	if(tmanager != null){
	    		tmanager.shutDown();
	    		tmanager = null;
	    	}
	    	HttpManager.updateServerConfig();
	    	new Thread() {
	            @Override
	            public void run() {
		            	NetResult resp = null;
	            		repeat = false;
		            	tmanager = new HttpManager();
					resp = tmanager.openUrl(jo);
//		            	try {
//						Thread.sleep(500);
//					} catch (InterruptedException e) {
//						e.printStackTrace();
//					}
					if (resp != null && resp.errorCode != 0) {
						repeat = true;
					}
//		            	判断上次连接错误，需要更换ip重试。
		            	if(repeat){
//		            		只重试一次，更改状态
		            		repeat = false;
//		            		更改ip
		            		if(appData.usingServerIpAddress.equalsIgnoreCase(appData.serverIpAddress_1))
		            			appData.useIp2();
		            		else
		            			appData.useIp1();
//		            		更新连接地址后重试
		            		HttpManager.updateServerConfig();
		            		resp = tmanager.openUrl(jo);
		            	}
	                if (listener != null) {
	                		if (resp != null) {
	                			listener.onComplete(resp);
	                		} else {
	                			resp = new NetResult(NetResult.CANNOT_CONNECT,App.getResString(R.string.alert_title_net_can_not_connect));
	                			listener.onComplete(resp);
	                		}
	                }
	                App.hideProgressDialog();
	            }
	        }.start();
    }
}
