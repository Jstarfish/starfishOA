package cls.pilottery.common.utils;

import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;
import java.util.Iterator;
import java.util.Map;

import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSession;
import javax.net.ssl.SSLSocketFactory;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public abstract class HttpClientUtils {
	final static Logger log = LoggerFactory.getLogger(HttpClientUtils.class);
	protected static final String CHARSET="UTF-8";
	static HostnameVerifier sslHostnameVerifier = createHostnameVerifier();
	static SSLSocketFactory sslSocketFactory = createSSLSocketFactory();
	
	public static byte[] post(String urlStr,byte[] data){
		HttpURLConnection con = null;
		byte[] result = null;
		try {
			URL url = new URL(urlStr);
			con = (HttpURLConnection) url.openConnection();
			con.setDoOutput(true);
			con.setDoInput(true);
			con.setInstanceFollowRedirects(false);
			con.setRequestMethod("POST");
			con.setRequestProperty("charset", CHARSET);
			con.setUseCaches(false);

			if (con instanceof HttpsURLConnection) {
				HttpsURLConnection httpsCon = (HttpsURLConnection) con;
				httpsCon.setHostnameVerifier(sslHostnameVerifier);
				httpsCon.setSSLSocketFactory(sslSocketFactory);
			}

			DataOutputStream wr = new DataOutputStream(con.getOutputStream());
			wr.write(data);
			wr.flush();
			wr.close();
			int HttpResult = con.getResponseCode();
			if (HttpResult == HttpURLConnection.HTTP_OK) {
				InputStream in = con.getInputStream();
				int count = 0;
				while (count == 0) {
					count = in.available();
				}
				result = new byte[count];
				int readCount = 0; // 已经成功读取的字节的个数
				while (readCount < count) {
					readCount += in.read(result, readCount, count - readCount);
				}
				
			} else {
				log.info(con.getResponseMessage());
			}
		} catch (Exception e) {
			log.info("post",e);
		} finally {
			if (con != null)
				con.disconnect();
		}
		return result;
	}
	
	public static String get(String urlStr) throws Exception{
		String result = null;
		
		URL url =new URL(urlStr);
        HttpURLConnection conn = (HttpURLConnection)url.openConnection();
        conn.setConnectTimeout(5*1000);
        conn.setRequestMethod("GET");
        InputStream inStream = conn.getInputStream();    
        byte[] data = readInputStream(inStream);
        result=new String(data, "UTF-8");
		
		return result;
	}
	
	public static String postWithParam(String urlStr,Map<String,Object> paraMap){
		HttpURLConnection con = null;
		String result = null;
		PrintWriter printWriter = null;
		BufferedReader bufferedReader = null;
		StringBuffer responseResult = new StringBuffer();
		try {
			if (con instanceof HttpsURLConnection) {
				HttpsURLConnection httpsCon = (HttpsURLConnection) con;
				httpsCon.setHostnameVerifier(sslHostnameVerifier);
				httpsCon.setSSLSocketFactory(sslSocketFactory);
			}

			StringBuffer params = new StringBuffer();
			Iterator it = paraMap.entrySet().iterator();
			while (it.hasNext()) {
				Map.Entry element = (Map.Entry) it.next();
				params.append(element.getKey());
				params.append("=");
				params.append(element.getValue());
				params.append("&");
			}
			if (params.length() > 0) {
				params.deleteCharAt(params.length() - 1);
			}

			URL url = new URL(urlStr);
			con = (HttpURLConnection) url.openConnection();
			con.setDoOutput(true);
			con.setDoInput(true);
			con.setInstanceFollowRedirects(false);
			con.setRequestMethod("POST");
			con.setRequestProperty("charset", CHARSET);
			con.setUseCaches(false);

			// 获取URLConnection对象对应的输出流
			printWriter = new PrintWriter(con.getOutputStream());
			// 发送请求参数
			printWriter.write(params.toString());
			// flush输出流的缓冲
			printWriter.flush();

			int responseCode = con.getResponseCode();
			if (responseCode != 200) {
				log.error(" Error===" + responseCode);
			} else {
				log.info("Post Success!");
			}

			// 定义BufferedReader输入流来读取URL的ResponseData
			bufferedReader = new BufferedReader(new InputStreamReader(con.getInputStream()));
			String line;
			while ((line = bufferedReader.readLine()) != null) {
				responseResult.append(line);
			}
			result = responseResult.toString();
		} catch (Exception e) {
			log.error("send post request error!" + e);
		} finally {
			con.disconnect();
			try {
				if (printWriter != null) {
					printWriter.close();
				}
				if (bufferedReader != null) {
					bufferedReader.close();
				}
			} catch (IOException ex) {
				ex.printStackTrace();
			}

		}
		return result;
	}
	
	public static String postString(String urlStr,String params){
		HttpURLConnection con = null;
		String result = null;
		PrintWriter printWriter = null;
		BufferedReader bufferedReader = null;
		StringBuffer responseResult = new StringBuffer();
		try {
			if (con instanceof HttpsURLConnection) {
				HttpsURLConnection httpsCon = (HttpsURLConnection) con;
				httpsCon.setHostnameVerifier(sslHostnameVerifier);
				httpsCon.setSSLSocketFactory(sslSocketFactory);

				//以下代码新添加，防止超时自动重发请求
				httpsCon.setConnectTimeout(30000);
				httpsCon.setReadTimeout(30000);
				httpsCon.setChunkedStreamingMode(0);
			}

			URL url = new URL(urlStr);
			con = (HttpURLConnection) url.openConnection();
			con.setDoOutput(true);
			con.setDoInput(true);
			con.setInstanceFollowRedirects(false);
			con.setRequestMethod("POST");
			con.setRequestProperty("charset", CHARSET);
			con.setUseCaches(false);

			//以下代码新添加，防止超时自动重发请求
			con.setChunkedStreamingMode(0);
			con.setConnectTimeout(30000);
			con.setReadTimeout(30000);

			// 获取URLConnection对象对应的输出流
			printWriter = new PrintWriter(con.getOutputStream());
			// 发送请求参数
			printWriter.write(params);
			// flush输出流的缓冲
			printWriter.flush();

			int responseCode = con.getResponseCode();
			if (responseCode != 200) {
				log.error(" Error===" + responseCode);
			} else {
				log.info("Post Success!");
			}

			// 定义BufferedReader输入流来读取URL的ResponseData
			bufferedReader = new BufferedReader(new InputStreamReader(con.getInputStream()));
			String line;
			while ((line = bufferedReader.readLine()) != null) {
				responseResult.append(line);
			}
			result = responseResult.toString();
		} catch (Exception e) {
			e.printStackTrace();
			log.error("send post request error!" + e);
		} finally {
			con.disconnect();
			try {
				if (printWriter != null) {
					printWriter.close();
				}
				if (bufferedReader != null) {
					bufferedReader.close();
				}
			} catch (IOException ex) {
				ex.printStackTrace();
			}

		}
		return result;
	}
	
	public static String notify(String urlStr, String data) {
		HttpURLConnection con = null;
		StringBuilder sb = new StringBuilder();
		try {
			URL url = new URL(urlStr);
			con = (HttpURLConnection) url.openConnection();
			con.setDoOutput(true);
			con.setDoInput(true);
			con.setInstanceFollowRedirects(false);
			con.setRequestMethod("POST");
			con.setRequestProperty("charset", CHARSET);
			con.setUseCaches(false);

			if (con instanceof HttpsURLConnection) {
				HttpsURLConnection httpsCon = (HttpsURLConnection) con;
				httpsCon.setHostnameVerifier(sslHostnameVerifier);
				httpsCon.setSSLSocketFactory(sslSocketFactory);
			}

			DataOutputStream wr = new DataOutputStream(con.getOutputStream());
			wr.write(data.getBytes(CHARSET));
			wr.flush();
			wr.close();
			int HttpResult = con.getResponseCode();
			if (HttpResult == HttpURLConnection.HTTP_OK) {
				BufferedReader br = new BufferedReader(new InputStreamReader(
						con.getInputStream(), CHARSET));
				String line = null;

				while ((line = br.readLine()) != null) {
					sb.append(line + "\n");
				}
				br.close();
			} else {
				log.info(con.getResponseMessage());
			}
		} catch (Exception e) {
			log.info("post",e);
		} finally {
			if (con != null)
				con.disconnect();
		}
		return sb.toString();
	}

	@SuppressWarnings("all")
	private static HostnameVerifier createHostnameVerifier(){
		return new HostnameVerifier() {
			public boolean verify(String urlHostName, SSLSession session) {
				return urlHostName != null
						&& urlHostName.equals(session.getPeerHost());
			}
		};
	}
	
	@SuppressWarnings("all")
	private static SSLSocketFactory createSSLSocketFactory(){
		SSLSocketFactory sslSocketFactory = null;
		try{
			SSLContext context = SSLContext.getInstance("TLS");
			final X509TrustManager trustManager = new X509TrustManager() {
				public X509Certificate[] getAcceptedIssuers() {
					return null;
				}

				public void checkClientTrusted(X509Certificate[] chain,
						String authType) throws CertificateException {
				}

				public void checkServerTrusted(X509Certificate[] chain,
						String authType) throws CertificateException {
				}
			};
			context.init(null, new TrustManager[] { trustManager }, null);
			sslSocketFactory = context.getSocketFactory();
		}
		catch(Exception e){
			log.error("createSSLSocketFactory", e);
		}
		return sslSocketFactory;
	}
	
	public static byte[] readInputStream(InputStream instream) throws Exception {
		ByteArrayOutputStream outStream = new ByteArrayOutputStream();
		byte[] buffer = new byte[1204];
		int len = 0;
		while ((len = instream.read(buffer)) != -1) {
			outStream.write(buffer, 0, len);
		}
		instream.close();
		return outStream.toByteArray();
	}
}
