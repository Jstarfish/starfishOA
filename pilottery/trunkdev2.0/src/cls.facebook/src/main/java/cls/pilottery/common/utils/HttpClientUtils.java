package cls.pilottery.common.utils;

import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
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

import org.apache.logging.log4j.LogManager;

public abstract class HttpClientUtils {
	final static org.apache.logging.log4j.Logger log = LogManager.getLogger(HttpClientUtils.class);
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
				int readCount = 0; // �Ѿ��ɹ���ȡ���ֽڵĸ���
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
		String results = null;
		
		HttpURLConnection con = null;
		byte[] result = null;
		try {
			URL url = new URL(urlStr);
			con = (HttpURLConnection) url.openConnection();
			con.setDoOutput(true);
			con.setDoInput(true);
			con.setInstanceFollowRedirects(false);
			con.setRequestMethod("GET");
			con.setRequestProperty("charset", CHARSET);
			con.setUseCaches(false);
		

			if (con instanceof HttpsURLConnection) {
				HttpsURLConnection httpsCon = (HttpsURLConnection) con;
				httpsCon.setHostnameVerifier(sslHostnameVerifier);
				httpsCon.setSSLSocketFactory(sslSocketFactory);
			}

			int HttpResult = con.getResponseCode();
			if (HttpResult == HttpURLConnection.HTTP_OK) {
				InputStream in = con.getInputStream();
				int count = 0;
				while (count == 0) {
					count = in.available();
				}
				result = new byte[count];
				int readCount = 0; // �Ѿ��ɹ���ȡ���ֽڵĸ���
				while (readCount < count) {
					readCount += in.read(result, readCount, count - readCount);
				}
				results=new String(result, "UTF-8");
			} else {
				log.info(con.getResponseMessage());
			}
		} catch (Exception e) {
			log.info("post",e);
		} finally {
			if (con != null)
				con.disconnect();
		}

        		
		return results;
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

			// ��ȡURLConnection�����Ӧ�������
			printWriter = new PrintWriter(con.getOutputStream());
			// �����������
			printWriter.write(params.toString());
			// flush������Ļ���
			printWriter.flush();

			int responseCode = con.getResponseCode();
			if (responseCode != 200) {
				log.error(" Error===" + responseCode);
			} else {
				log.info("Post Success!");
			}

			// ����BufferedReader����������ȡURL��ResponseData
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
			}

			URL url = new URL(urlStr);
			con = (HttpURLConnection) url.openConnection();
			con.setDoOutput(true);
			con.setDoInput(true);
			con.setInstanceFollowRedirects(false);
			con.setRequestMethod("POST");
			con.setRequestProperty("charset", CHARSET);
			con.setUseCaches(false);

			// ��ȡURLConnection�����Ӧ�������
			printWriter = new PrintWriter(con.getOutputStream());
			// �����������
			printWriter.write(params);
			// flush������Ļ���
			printWriter.flush();

			int responseCode = con.getResponseCode();
			if (responseCode != 200) {
				log.error(" Error===" + responseCode);
			} else {
				log.info("Post Success!");
			}

			// ����BufferedReader����������ȡURL��ResponseData
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
