package com.huacai.assist.net;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.SocketTimeoutException;
import java.net.URL;
import java.net.UnknownHostException;
import java.util.HashMap;
import java.util.Map;
import java.util.Map.Entry;

import android.app.ProgressDialog;
import android.content.Context;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;

import com.huacai.assist.common.App;
import com.huacai.assist.common.Base64;
import com.huacai.assist.login.LoginActivity;
import com.huacai.pistore.R;


/** 网络连接类 */
public class Downloader {
	
	//接收数据buffer的大小 
	public static final int BUFFER_LENGTH = 1024 * 20;
	
	public static interface DownloadListener{
		public void onConnectionFinished(Downloader http);
		
		public void onError(Downloader http,int erroCode,String errmsg);
		
		public void onDownloadProgress(Downloader http,long currentSize,long totalSize);
		
		public void onSendProgress(Downloader http,long currentSize,long totalSize);
	}
	
	public static final String TAG = "Downloader";
	
	private DownloadListener mListener = null;
	
	private String mURL = null;
	private Map<String,String> mHeadMap = new HashMap<String,String>();
	private HttpURLConnection mConn = null;
	
	
	
	//in second
	private int mConnTimeout = 30 * 1000;
	//in second
	private int mReadTimeout = 30 * 1000;
	
	
	private boolean mCancelFlag = false;
	
	private OutputStream mOutputSream;
	
	
	//启始偏移
	private long mStartOffset = 0;

	private ProgressDialog m_pDialog;
	
	/** 存放返回内容的stream */
	public OutputStream getOutPutStream(){
		return mOutputSream;
	}
	
	/** 存放返回内容的stream */
	public void setOutPutStream(OutputStream os){
		mOutputSream = os;
	}
	
	public void setStartOffset(int startOffset){
		mStartOffset = startOffset; 
	}
	public void setListener(DownloadListener listener){
		mListener = listener;
	}
	
	public Downloader(){
	}

	public void setURL(String url) {
		mURL = url;
	}
	
	/** in ms*/
	public void setConnTimeout(int connTimeout) {
		mConnTimeout = connTimeout;
	}

	/** in ms*/
	public void setReadTimeout(int readTimeout) {
		mReadTimeout = readTimeout;
	}

	public void addHead(String name, String value) {
		mHeadMap.put(name, value);
	}
	
	public void addAuth(String user, String pass) {
		// Authorization: Basic base64string
		String auth = "Basic "+Base64.encode((user+":"+pass).getBytes());
		mHeadMap.put("Authorization", auth);
	}
	
	public void showProgress(LoginActivity ctx) {
		if (ctx == null) {
			if (m_pDialog != null) {
				m_pDialog.cancel();
				m_pDialog = null;
			}
			return ;
		}
		m_pDialog = new ProgressDialog(ctx);

		// 设置进度条风格，风格为长形
		m_pDialog.setProgressStyle(ProgressDialog.STYLE_HORIZONTAL);

		// 设置ProgressDialog 标题
		m_pDialog.setTitle(R.string.com_tishi);

		// 设置ProgressDialog 提示信息
		m_pDialog.setMessage(App.getResString(R.string.downloading_soft));

		// 设置ProgressDialog 进度条进度
		m_pDialog.setProgress(100);

		// 设置ProgressDialog 的进度条是否不明确
		m_pDialog.setIndeterminate(false);

		// 设置ProgressDialog 是否可以按退回按键取消
		m_pDialog.setCancelable(false);

		// 让ProgressDialog显示
		m_pDialog.show();

//		new Thread()
//		{
//		    private int m_count = 0;
//
//			public void run()
//		    {
//		        try
//		        {
//		            while (m_count  <= 100)
//		            {
//		                // 由线程来控制进度。
//		                m_pDialog.setProgress(m_count++);
//		                Thread.sleep(100);
//		            }
//		            m_pDialog.cancel();
//		        }
//		        catch (InterruptedException e)
//		        {
//		            m_pDialog.cancel();
//		        }
//		    }
//		}.start();
	}
	
	public boolean isOnline() {
		// 是否联网检测
		ConnectivityManager connectivityManager = 
				(ConnectivityManager) App.c.getSystemService( Context.CONNECTIVITY_SERVICE );   
		NetworkInfo activeNetInfo = connectivityManager.getActiveNetworkInfo();
		return (activeNetInfo != null);
	}

	public void request(final byte[] data) {
		mCancelFlag = false;
		new Thread(new Runnable() {
			@Override
			public void run() {
				if( data != null ){
					ByteArrayInputStream bis = new ByteArrayInputStream(data);
					long length = data!=null?data.length:0;
					runRequest(bis,length);
					try {
						bis.close();
					} catch (IOException e) {
					}
				}else{
					runRequest(null,0);
				}
			}
		}).start();
	}
	
	public void uploadFile(final File file) {
		mCancelFlag = false;
		new Thread(new Runnable() {
			@Override
			public void run() {
				FileInputStream fis = null;
				try {
					fis = new FileInputStream(file);
					runRequest(fis,file.length());
				} catch (FileNotFoundException e) {
					e.printStackTrace();
				}
				if( fis != null ){
					try {
						fis.close();
					} catch (IOException e) {
					}
				}
				
			}
		}).start();
	}
	
	public void runRequest(InputStream inputStream,long sendLength) {
		if (!isOnline()) {
			onError(-10000, "系统未联网!");
			return ;
		}
		if (mURL == null) {
			onError(-1, "未设置URL!");
			return ;
		}
		URL url;
//		ByteArrayOutputStream bos = null;
		try {
			url = new URL(mURL);
			if (mConn != null) {
				mConn.disconnect();
			}
			mConn=(HttpURLConnection)url.openConnection(); 
			
			DataInputStream in = null;
			mConn.setDoInput(true);
			//设置输入和输出流  
			if (sendLength > 0) {
				mConn.setDoOutput(true); 
				mConn.setRequestMethod("POST"); 
			}else{
				mConn.setRequestMethod("GET"); 
			}
			mConn.setUseCaches(false);  
			mConn.setInstanceFollowRedirects(true); 
			for( Entry<String, String> entry :mHeadMap.entrySet()){
				mConn.setRequestProperty(entry.getKey()	, entry.getValue());
			}
			mConn.setRequestProperty("Content-Type","application/octet-stream");  
            
			mConn.setConnectTimeout(mConnTimeout);
			mConn.setReadTimeout(mReadTimeout);
			mConn.connect();
			
			//发送数据
            if ( inputStream != null && sendLength > 0) {
	            DataOutputStream out = new DataOutputStream(mConn.getOutputStream());   
	            byte[] buffer = new byte[BUFFER_LENGTH];
	            int len;
	            long offset = 0;
	            while ((len = inputStream.read(buffer)) > 0)  
	            {
	            	out.write(buffer,0,len);
	            	out.flush();
	            	offset += len;
	            	if( mListener != null ){
	            		mListener.onSendProgress(this, offset, sendLength);
	            	}
	            }
	            out.close();  
            }
            
            int httpCode = mConn.getResponseCode();
			if (httpCode <200 || httpCode >= 300) {
				onError(-1, "http代码:"+httpCode);
				return;
			}
			
			long contentLength = mConn.getContentLength();
            
            //使用循环来读取获得的数据  
			int len = 0;
            byte[] buffer = new byte[BUFFER_LENGTH];
			in = new DataInputStream(mConn.getInputStream());
			long offset = 0;
			long lastOff = 0;
			if( mOutputSream == null ){
				mOutputSream = new ByteArrayOutputStream();
			}
			boolean lastNotif =false;
            while ((len = in.read(buffer)) > 0)  
            {
	            	lastNotif = false;
	            	mOutputSream.write(buffer,0,len);
	        		mOutputSream.flush();
	            	offset += len;
	            	if( mListener != null && (offset - lastOff) * 200 > contentLength ){
	            		mListener.onDownloadProgress(this, mStartOffset + offset, mStartOffset + contentLength);
	            		lastOff = offset;
	            		lastNotif = true;
	            	}
            }
            if( !lastNotif && mListener != null ){
            		mListener.onDownloadProgress(this, mStartOffset + offset, mStartOffset + contentLength);
            }
//            Map< String,List< String>> map = mConn.getHeaderFields();
            //遍历所有的响应头字段
//            for (String key : map.keySet()){
//            	System.out.println("Http: "+key + " ---> " + map.get(key));
//            }
            
            if( !mCancelFlag ){
            		onReceiveData();
            }
            
          //关闭InputStreamReader  
            in.close();
            
			//关闭连接  
			//urlConn.disconnect();
		} catch (MalformedURLException e) {
			e.printStackTrace();
			onError(-2, "URL地址错误!");
			//e.printStackTrace();
		} catch (UnknownHostException e) {
			e.printStackTrace();
			onError(-3, "找不到主机地址!");
			//e.printStackTrace();
		} catch (SocketTimeoutException e) {
			e.printStackTrace();
			onError(-4, "发送接收超时!");
			//e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
			onError(-5, "IO操作错误!");
			//e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
			onError(-5, "网络错误!");
			//e.printStackTrace();
		}finally{
			if( mOutputSream != null ){
				try {
					mOutputSream.close();
				} catch (IOException e) {
				}
			}
		}
	}
	
	public byte[] getRetData(){
		if( ByteArrayOutputStream.class.isInstance(mOutputSream)){
			return ((ByteArrayOutputStream)mOutputSream).toByteArray();
		}
		return null;
	}

	public void cancel() {
		mCancelFlag = true;
		if (mConn != null) {
			//reportError(-1, "用户取消!");
			mConn.disconnect();
			mConn = null;
		}
	}

	private void onReceiveData() {
		if( mListener != null ){
			mListener.onConnectionFinished(this);
		}
	}
	
	private void onError(int erroCode,final String errmsg){
		if( mListener != null ){
			mListener.onError(this,erroCode,errmsg);
		}
	}

	public void setProgress(long currentSize, long totalSize) {
		int progress = (int)(currentSize*100/totalSize);
		m_pDialog.setProgress(progress);
	}
	
}
