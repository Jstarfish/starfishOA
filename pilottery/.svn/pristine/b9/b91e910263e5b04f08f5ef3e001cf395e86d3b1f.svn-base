package cls.pilottery.common.utils;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;

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
	final static Logger LOGGER = LoggerFactory.getLogger(HttpClientUtils.class);
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
				LOGGER.info(con.getResponseMessage());
			}
		} catch (Exception e) {
			LOGGER.info("post",e);
		} finally {
			if (con != null)
				con.disconnect();
		}
		return result;
	}
	/*
	public static String post(String urlStr, byte[] data) {
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
			wr.write(data);
			wr.flush();
			wr.close();
			int HttpResult = con.getResponseCode();
			if (HttpResult == HttpURLConnection.HTTP_OK) {
				
				BufferedInputStream bis = new BufferedInputStream(con.getInputStream());
				byte[] buffer = new byte[1024];
				int bytesRead = 0;
				while ((bytesRead = bis.read(buffer)) != -1) {
					String chunk = new String(buffer, 0, bytesRead);
					sb.append(chunk);
				}
			} else {
				LOGGER.info(con.getResponseMessage());
			}
		} catch (Exception e) {
			LOGGER.info("post",e);
		} finally {
			if (con != null)
				con.disconnect();
		}
		return sb.toString();
	}

	public static String post(String urlStr, String data) throws UnsupportedEncodingException {
		byte[] arr = data.getBytes(CHARSET);
		return post(urlStr,arr);
	}
	*/
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
				LOGGER.info(con.getResponseMessage());
			}
		} catch (Exception e) {
			LOGGER.info("post",e);
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
			LOGGER.error("createSSLSocketFactory", e);
		}
		return sslSocketFactory;
	}
}
